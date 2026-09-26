import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui
import "Model.js" as Model

// Fan / thermal profile widget. Reads fan rpm and temperatures straight from
// hwmon and writes the ACPI platform profile directly, deliberately bypassing
// power-profiles-daemon: ppd collapses this machine's six profiles down to
// three and would hide `cool`, `balanced-performance` and `custom` entirely.
//
// See README.md for the udev rule that makes the sysfs write possible without
// root, and for the caveat about ppd overwriting the profile on AC transitions.
Panel {
  id: root

  moduleName: "peter.fan"
  ipcTarget: "peter.fan"

  // ------------------------------------------------------------------ state
  property var info: ({})
  property bool loaded: false
  property bool busy: false
  property string lastError: ""
  property int cursorIndex: 0
  property bool cursorActive: false

  readonly property color fg: root.bar ? root.bar.foreground : Color.foreground
  readonly property string ff: root.bar ? root.bar.fontFamily : Style.font.family

  // Plugins can live anywhere on disk, so resolve the helper relative to this
  // file rather than trusting PATH.
  readonly property string fanctl: {
    var u = String(Qt.resolvedUrl("fanctl"))
    return u.indexOf("file://") === 0 ? u.substring(7) : u
  }

  readonly property var choices: Model.profiles(info)
  readonly property string activeProfile: String(info.profile || "")
  readonly property bool writable: String(info.writable || "") === "1"
  readonly property var fans: Model.fans(info)
  readonly property var temps: Model.temps(info)
  readonly property int peakRpm: Model.peak(fans, "rpm")
  readonly property int peakMax: Model.peak(fans, "max")
  readonly property int peakTemp: Model.peak(temps, "celsius")
  readonly property bool spinning: peakRpm > 0

  readonly property int columns: Math.max(1, Number(setting("columns", 3)) || 3)
  readonly property int refreshIntervalSec: Math.max(2, Number(setting("refreshIntervalSec", 10)) || 10)

  // Nothing to control on a machine without an ACPI platform profile. Stay
  // visible until the first read lands, so the bar doesn't flicker at startup.
  readonly property bool supported: !loaded || activeProfile !== ""

  readonly property string statusText: {
    if (busy) return "Switching"
    if (!loaded) return "Reading"
    if (activeProfile === "") return "Unavailable"
    if (!writable) return Model.profileLabel(activeProfile) + " · read only"
    return Model.profileLabel(activeProfile)
  }

  // --------------------------------------------------------------- behavior
  function refresh() {
    if (!sensorsProc.running) sensorsProc.running = true
  }

  function ingest(raw) {
    var next = Model.parseKeyValue(raw)
    // A poll that races a driver unbind comes back empty; keep the last good
    // reading rather than collapsing the panel mid-view.
    if (Object.keys(next).length === 0 && loaded) return
    info = next
    loaded = true
    if (opened && !cursorActive) syncCursorToActive()
  }

  function syncCursorToActive() {
    var idx = choices.indexOf(activeProfile)
    if (idx >= 0) cursorIndex = idx
  }

  function applyProfile(name) {
    if (!name || setProc.running || !writable) return
    lastError = ""
    busy = true
    setProc.command = [root.fanctl, "set", String(name)]
    setProc.running = true
  }

  function moveCursor(dx, dy) {
    if (!cursorActive) { cursorActive = true; syncCursorToActive(); return }
    cursorIndex = Model.moveIndex(cursorIndex, dx, dy, choices.length, columns)
  }

  function activateCursor() {
    if (cursorIndex >= 0 && cursorIndex < choices.length) applyProfile(choices[cursorIndex])
  }

  onOpenedChanged: {
    if (!opened) return
    refresh()
    cursorActive = false
    syncCursorToActive()
  }

  onSupportedChanged: if (!supported) close()

  visible: supported
  implicitWidth: supported ? button.implicitWidth : 0
  implicitHeight: supported ? button.implicitHeight : 0

  Process {
    id: sensorsProc
    command: [root.fanctl, "sensors"]
    stdout: StdioCollector { waitForEnd: true; onStreamFinished: root.ingest(text) }
  }

  Process {
    id: setProc
    stderr: StdioCollector { waitForEnd: true; onStreamFinished: root.lastError = String(text).trim() }
    onExited: {
      root.busy = false
      // The driver can clamp or refuse a profile, so re-read rather than
      // assuming the write took.
      root.refresh()
    }
  }

  // Poll faster while the panel is open; the slow cadence exists only to keep
  // the bar icon's spin state honest.
  Timer {
    interval: root.opened ? 2000 : root.refreshIntervalSec * 1000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: root.refresh()
  }

  // ------------------------------------------------------------- bar button
  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: Model.FAN_GLYPH
    tooltipText: root.loaded
      ? Model.profileLabel(root.activeProfile) + (root.spinning ? " · " + root.peakRpm + " rpm" : " · fans idle")
      : "Fans"
    onPressed: function(b) { root.toggle() }
  }

  // Rotate the bar glyph while air is actually moving — the one piece of live
  // state worth showing without opening anything.
  NumberAnimation {
    id: spin
    target: button
    property: "textRotation"
    from: 0
    to: 360
    duration: Model.spinDuration(root.peakRpm, root.peakMax)
    loops: Animation.Infinite
    running: root.spinning && root.supported
    onRunningChanged: if (!running) button.textRotation = 0
  }

  // ------------------------------------------------------------------ panel
  KeyboardPanel {
    id: panel
    anchorItem: button
    owner: root
    bar: root.bar
    open: root.opened && root.supported
    focusTarget: keyCatcher
    contentWidth: panel.fittedContentWidth(Style.space(360))
    contentHeight: panel.fittedContentHeight(column.implicitHeight)

    PanelKeyCatcher {
      id: keyCatcher
      anchors.fill: parent
      onMoveRequested: function(dx, dy) { root.moveCursor(dx, dy) }
      onActivateRequested: if (root.cursorActive) root.activateCursor()
      onCloseRequested: root.close()
      onTabRequested: function(direction) { root.switchPanel(direction) }

      Column {
        id: column
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        spacing: Style.space(14)

        // ---------- Hero: fan glyph · title/status · peak rpm ----------
        Item {
          width: parent.width
          implicitHeight: Math.max(heroIcon.implicitHeight, heroLabels.implicitHeight, heroValue.implicitHeight)

          Text {
            id: heroIcon
            text: Model.FAN_GLYPH
            color: root.fg
            font.family: root.ff
            font.pixelSize: Style.font.display
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter

            NumberAnimation on rotation {
              from: 0
              to: 360
              duration: Model.spinDuration(root.peakRpm, root.peakMax)
              loops: Animation.Infinite
              running: root.spinning && root.opened
            }
          }

          Column {
            id: heroLabels
            anchors.left: heroIcon.right
            anchors.leftMargin: Style.space(14)
            anchors.right: heroValue.left
            anchors.rightMargin: Style.space(10)
            anchors.verticalCenter: parent.verticalCenter
            spacing: Style.space(2)

            Text {
              text: "Fans"
              color: root.fg
              font.family: root.ff
              font.pixelSize: Style.font.title
              font.bold: true
              elide: Text.ElideRight
              width: parent.width
            }

            Text {
              text: root.statusText.toUpperCase()
              color: Qt.darker(root.fg, 1.4)
              font.family: root.ff
              font.pixelSize: Style.font.caption
              font.bold: true
              font.letterSpacing: 1.2
              elide: Text.ElideRight
              width: parent.width
            }
          }

          // Peak rpm across every fan: the number that answers "why is it loud".
          Text {
            id: heroValue
            text: root.spinning ? String(root.peakRpm) : "—"
            color: root.fg
            // The placeholder dash carries no information; at display size it
            // reads as a stray mark unless it recedes.
            opacity: root.spinning ? 1.0 : 0.35
            font.family: root.ff
            font.pixelSize: Style.font.displayLarge
            font.bold: true
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
          }
        }

        // ---------- Per-fan rpm with a fill against the driver's ceiling ----------
        Column {
          width: parent.width
          spacing: Style.space(10)
          visible: root.fans.length > 0

          Repeater {
            model: root.fans

            Column {
              required property var modelData
              width: column.width
              spacing: Style.space(4)

              Row {
                width: parent.width
                Text {
                  text: modelData.label
                  color: root.fg
                  opacity: 0.6
                  font.family: root.ff
                  font.pixelSize: Style.font.bodySmall
                }
                Item {
                  width: Math.max(0, parent.width - parent.children[0].implicitWidth - parent.children[2].implicitWidth)
                  height: 1
                }
                Text {
                  text: modelData.rpm > 0 ? modelData.rpm + " rpm" : "idle"
                  color: root.fg
                  font.family: root.ff
                  font.pixelSize: Style.font.bodySmall
                }
              }

              Item {
                width: parent.width
                implicitHeight: Style.space(5)

                Rectangle {
                  id: track
                  anchors.fill: parent
                  radius: height / 2
                  color: Qt.rgba(root.fg.r, root.fg.g, root.fg.b, 0.12)
                }

                Rectangle {
                  anchors.left: track.left
                  anchors.verticalCenter: track.verticalCenter
                  height: track.height
                  radius: track.radius
                  color: root.fg
                  width: modelData.fraction > 0 ? Math.max(track.height, track.width * modelData.fraction) : 0
                  Behavior on width { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }
                }
              }
            }
          }
        }

        // ---------- Temperatures ----------
        Row {
          width: parent.width
          spacing: Style.space(20)
          visible: root.temps.length > 0

          Repeater {
            model: root.temps

            Row {
              required property var modelData
              spacing: Style.space(6)

              Text {
                text: Model.TEMP_GLYPH
                color: root.fg
                opacity: 0.6
                font.family: root.ff
                font.pixelSize: Style.font.bodySmall
              }
              Text {
                text: modelData.label
                color: root.fg
                opacity: 0.6
                font.family: root.ff
                font.pixelSize: Style.font.bodySmall
              }
              Text {
                text: modelData.celsius + "°C"
                color: root.fg
                font.family: root.ff
                font.pixelSize: Style.font.bodySmall
              }
            }
          }
        }

        // ---------- Profile picker ----------
        PanelSeparator { foreground: root.fg }

        Column {
          width: parent.width
          spacing: Style.space(10)

          PanelSectionHeader {
            text: "PLATFORM PROFILE"
            foreground: root.fg
            fontFamily: root.ff
          }

          Grid {
            id: profileGrid
            width: parent.width
            columns: root.columns
            spacing: Style.space(6)

            readonly property real cellWidth: columns > 0
              ? (width - spacing * (columns - 1)) / columns
              : 0

            Repeater {
              model: root.choices

              Button {
                required property var modelData
                required property int index

                width: profileGrid.cellWidth
                iconText: Model.profileIcon(String(modelData))
                iconSize: Style.font.title
                text: Model.profileLabel(String(modelData))
                fontSize: Style.font.bodySmall
                foreground: root.fg
                fontFamily: root.ff
                horizontalPadding: Style.spacing.controlPaddingX
                verticalPadding: Style.spacing.controlPaddingY + Style.space(2)
                bordered: true
                opacity: root.writable ? 1.0 : 0.45
                active: root.activeProfile === String(modelData)
                hasCursor: root.cursorActive && root.cursorIndex === index
                onClicked: root.applyProfile(String(modelData))
                onHovered: function(h) {
                  if (!h) return
                  root.cursorActive = true
                  root.cursorIndex = index
                }
              }
            }
          }

          // Surfaced rather than swallowed: without the udev rule the buttons
          // do nothing, and silence there is the worst possible answer.
          Text {
            width: parent.width
            visible: root.loaded && !root.writable
            text: "Needs write access — install 90-platform-profile.rules"
            color: root.bar ? root.bar.urgent : Color.urgent
            font.family: root.ff
            font.pixelSize: Style.font.caption
            wrapMode: Text.WordWrap
          }

          Text {
            width: parent.width
            visible: root.lastError !== ""
            text: root.lastError
            color: root.bar ? root.bar.urgent : Color.urgent
            font.family: root.ff
            font.pixelSize: Style.font.caption
            wrapMode: Text.WordWrap
          }
        }
      }
    }
  }
}
