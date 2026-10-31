local terminal = "kitty"
local browser  = "firefox"
local launcher = "qs -c titan ipc call launcher toggle"
local clipboard = "qs -c titan ipc call clipboard toggle"
local wallpaper = "qs -c titan ipc call wallpaper toggle"
local keybinds = "qs -c titan ipc call keybinds toggle"
local media    = "qs -c titan ipc call media"
local brightness = "qs -c titan ipc call brightness"
local locker   = "loginctl lock-session"
local screenshot = "hyprshot -m region -o ~/Pictures/Screenshots"

local mainMod = "SUPER"

local function desc(text)
    return { description = text }
end

hl.bind(mainMod .. " + SHIFT + slash", hl.dsp.exec_cmd(keybinds),   desc("Show keybinds"))
hl.bind(mainMod .. " + T",             hl.dsp.exec_cmd(terminal),   desc("Terminal"))
hl.bind(mainMod .. " + D",             hl.dsp.exec_cmd(browser),    desc("Browser"))
hl.bind(mainMod .. " + Space",         hl.dsp.exec_cmd(launcher),   desc("App launcher"))
hl.bind(mainMod .. " + SHIFT + V",     hl.dsp.exec_cmd(clipboard),  desc("Clipboard history"))
hl.bind(mainMod .. " + SHIFT + W",     hl.dsp.exec_cmd(wallpaper),  desc("Choose wallpaper"))
hl.bind(mainMod .. " + Q",             hl.dsp.window.close(),       desc("Close window"))
hl.bind(mainMod .. " + ALT + L",       hl.dsp.exec_cmd(locker),     desc("Lock screen"))
hl.bind(mainMod .. " + SHIFT + S",     hl.dsp.exec_cmd(screenshot), desc("Screenshot region"))
hl.bind(mainMod .. " + SHIFT + E",     hl.dsp.exit(),               desc("Quit Hyprland"))
hl.bind("CTRL + ALT + Delete",         hl.dsp.exit(),               desc("Quit Hyprland"))
hl.bind(mainMod .. " + SHIFT + P", function()
    hl.timer(function()
        hl.dispatch(hl.dsp.dpms({ action = "disable" }))
    end, { timeout = 500, type = "oneshot" })
end, desc("Turn off monitors"))

-- Columns
for _, k in ipairs({ { "left", "H", "l", "left" }, { "right", "L", "r", "right" } }) do
    local arrow, vim, side, word = k[1], k[2], k[3], k[4]
    for _, key in ipairs({ arrow, vim }) do
        hl.bind(mainMod .. " + " .. key,            hl.dsp.layout("focus " .. side),          desc("Focus column " .. word))
        hl.bind(mainMod .. " + CTRL + " .. key,     hl.dsp.layout("swapcol " .. side),        desc("Move column " .. word))
        hl.bind(mainMod .. " + SHIFT + " .. key,    hl.dsp.focus({ monitor = side }),         desc("Focus monitor " .. word))
        hl.bind(mainMod .. " + SHIFT + CTRL + " .. key, hl.dsp.window.move({ monitor = side }), desc("Move window to monitor " .. word))
    end
end

-- Windows within a column
for _, k in ipairs({ { "up", "K", "u", "up" }, { "down", "J", "d", "down" } }) do
    local arrow, vim, side, word = k[1], k[2], k[3], k[4]
    for _, key in ipairs({ arrow, vim }) do
        hl.bind(mainMod .. " + " .. key,            hl.dsp.focus({ direction = side }),       desc("Focus window " .. word))
        hl.bind(mainMod .. " + CTRL + " .. key,     hl.dsp.window.move({ direction = side }), desc("Move window " .. word))
        hl.bind(mainMod .. " + SHIFT + " .. key,    hl.dsp.focus({ monitor = side }),         desc("Focus monitor " .. word))
        hl.bind(mainMod .. " + SHIFT + CTRL + " .. key, hl.dsp.window.move({ monitor = side }), desc("Move window to monitor " .. word))
    end
end

hl.bind(mainMod .. " + bracketleft",   hl.dsp.layout("consume_or_expel prev"), desc("Merge into / split from column left"))
hl.bind(mainMod .. " + bracketright",  hl.dsp.layout("consume_or_expel next"), desc("Merge into / split from column right"))
hl.bind(mainMod .. " + comma",         hl.dsp.layout("consume"),               desc("Merge window into previous column"))
hl.bind(mainMod .. " + period",        hl.dsp.layout("expel"),                 desc("Split window into own column"))

hl.bind(mainMod .. " + R",             hl.dsp.layout("colresize +conf"),       desc("Cycle column width"))
hl.bind(mainMod .. " + SHIFT + R",     hl.dsp.layout("colresize -conf"),       desc("Cycle column width back"))
hl.bind(mainMod .. " + minus",         hl.dsp.layout("colresize -0.1"),        desc("Narrow column"))
hl.bind(mainMod .. " + equal",         hl.dsp.layout("colresize +0.1"),        desc("Widen column"))
hl.bind(mainMod .. " + F",             hl.dsp.window.fullscreen({ mode = "maximized" }),  desc("Maximize"))
hl.bind(mainMod .. " + SHIFT + F",     hl.dsp.window.fullscreen({ mode = "fullscreen" }), desc("Fullscreen"))
hl.bind(mainMod .. " + CTRL + F",      hl.dsp.layout("fit expand"),            desc("Expand column to free space"))
hl.bind(mainMod .. " + C",             hl.dsp.layout("center"),                desc("Center column"))
hl.bind(mainMod .. " + CTRL + C",      hl.dsp.layout("fit visible"),           desc("Fit visible columns"))

hl.bind(mainMod .. " + grave", function()
    if #hl.get_windows({ class = "scratchpad" }) == 0 then
        hl.dispatch(hl.dsp.exec_cmd(terminal .. " --class scratchpad"))
    else
        hl.dispatch(hl.dsp.workspace.toggle_special("scratchpad"))
    end
end, desc("Toggle scratchpad"))

hl.bind(mainMod .. " + V",             hl.dsp.window.float({ action = "toggle" }), desc("Toggle floating"))
hl.bind(mainMod .. " + W",             hl.dsp.group.toggle(),                      desc("Toggle tab group"))

-- Workspaces
for _, k in ipairs({ { "Page_Down", "U", "r+1", "down" }, { "Page_Up", "I", "r-1", "up" } }) do
    local page, vim, ws, word = k[1], k[2], k[3], k[4]
    for _, key in ipairs({ page, vim }) do
        hl.bind(mainMod .. " + " .. key,        hl.dsp.focus({ workspace = ws }),       desc("Workspace " .. word))
        hl.bind(mainMod .. " + CTRL + " .. key, hl.dsp.window.move({ workspace = ws }), desc("Move window to workspace " .. word))
    end
end

for i = 1, 9 do
    hl.bind(mainMod .. " + " .. i,          hl.dsp.focus({ workspace = i }),       desc("Go to workspace"))
    hl.bind(mainMod .. " + CTRL + " .. i,   hl.dsp.window.move({ workspace = i }), desc("Move window to workspace"))
end

-- Mouse
hl.bind(mainMod .. " + mouse_down",          hl.dsp.focus({ workspace = "e+1" }), desc("Next workspace"))
hl.bind(mainMod .. " + mouse_up",            hl.dsp.focus({ workspace = "e-1" }), desc("Previous workspace"))
hl.bind(mainMod .. " + SHIFT + mouse_down",  hl.dsp.layout("focus r"),            desc("Scroll columns"))
hl.bind(mainMod .. " + SHIFT + mouse_up",    hl.dsp.layout("focus l"),            desc("Scroll columns"))
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true, description = "Drag window" })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Resize window" })

-- Media keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 10%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),      { locked = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),    { locked = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd(brightness .. " up"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd(brightness .. " down"), { locked = true, repeating = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd(media .. " playPause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd(media .. " playPause"), { locked = true })
hl.bind("XF86AudioStop",  hl.dsp.exec_cmd(media .. " stop"),      { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd(media .. " previous"),  { locked = true })
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd(media .. " next"),      { locked = true })
