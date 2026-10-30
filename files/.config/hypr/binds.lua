local terminal = "kitty"
local browser  = "firefox"
local launcher = "qs -c titan ipc call launcher toggle"
local locker   = "swaylock"

local mainMod = "SUPER"

hl.bind(mainMod .. " + T",             hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q",             hl.dsp.window.close())
hl.bind(mainMod .. " + D",             hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + Space",         hl.dsp.exec_cmd(launcher))
hl.bind(mainMod .. " + ALT + L",       hl.dsp.exec_cmd(locker))
hl.bind(mainMod .. " + SHIFT + E",     hl.dsp.exit())
hl.bind("CTRL + ALT + Delete",         hl.dsp.exit())
hl.bind(mainMod .. " + SHIFT + P", function()
    hl.timer(function()
        hl.dispatch(hl.dsp.dpms({ action = "disable" }))
    end, { timeout = 500, type = "oneshot" })
end)

-- Columns
for _, k in ipairs({ { "left", "H", "l" }, { "right", "L", "r" } }) do
    local arrow, vim, side = k[1], k[2], k[3]
    for _, key in ipairs({ arrow, vim }) do
        hl.bind(mainMod .. " + " .. key,            hl.dsp.layout("focus " .. side))
        hl.bind(mainMod .. " + CTRL + " .. key,     hl.dsp.layout("swapcol " .. side))
        hl.bind(mainMod .. " + SHIFT + " .. key,    hl.dsp.focus({ monitor = side }))
        hl.bind(mainMod .. " + SHIFT + CTRL + " .. key, hl.dsp.window.move({ monitor = side }))
    end
end

-- Windows within a column
for _, k in ipairs({ { "up", "K", "u" }, { "down", "J", "d" } }) do
    local arrow, vim, side = k[1], k[2], k[3]
    for _, key in ipairs({ arrow, vim }) do
        hl.bind(mainMod .. " + " .. key,            hl.dsp.focus({ direction = side }))
        hl.bind(mainMod .. " + CTRL + " .. key,     hl.dsp.window.move({ direction = side }))
        hl.bind(mainMod .. " + SHIFT + " .. key,    hl.dsp.focus({ monitor = side }))
        hl.bind(mainMod .. " + SHIFT + CTRL + " .. key, hl.dsp.window.move({ monitor = side }))
    end
end

hl.bind(mainMod .. " + bracketleft",   hl.dsp.layout("consume_or_expel prev"))
hl.bind(mainMod .. " + bracketright",  hl.dsp.layout("consume_or_expel next"))
hl.bind(mainMod .. " + comma",         hl.dsp.layout("consume"))
hl.bind(mainMod .. " + period",        hl.dsp.layout("expel"))

hl.bind(mainMod .. " + R",             hl.dsp.layout("colresize +conf"))
hl.bind(mainMod .. " + SHIFT + R",     hl.dsp.layout("colresize -conf"))
hl.bind(mainMod .. " + minus",         hl.dsp.layout("colresize -0.1"))
hl.bind(mainMod .. " + equal",         hl.dsp.layout("colresize +0.1"))
hl.bind(mainMod .. " + F",             hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(mainMod .. " + SHIFT + F",     hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind(mainMod .. " + CTRL + F",      hl.dsp.layout("fit expand"))
hl.bind(mainMod .. " + C",             hl.dsp.layout("center"))
hl.bind(mainMod .. " + CTRL + C",      hl.dsp.layout("fit visible"))

hl.bind(mainMod .. " + grave", function()
    if #hl.get_windows({ class = "scratchpad" }) == 0 then
        hl.dispatch(hl.dsp.exec_cmd(terminal .. " --class scratchpad"))
    else
        hl.dispatch(hl.dsp.workspace.toggle_special("scratchpad"))
    end
end)

hl.bind(mainMod .. " + V",             hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + W",             hl.dsp.group.toggle())

-- Workspaces
for _, k in ipairs({ { "Page_Down", "U", "r+1" }, { "Page_Up", "I", "r-1" } }) do
    local page, vim, ws = k[1], k[2], k[3]
    for _, key in ipairs({ page, vim }) do
        hl.bind(mainMod .. " + " .. key,        hl.dsp.focus({ workspace = ws }))
        hl.bind(mainMod .. " + CTRL + " .. key, hl.dsp.window.move({ workspace = ws }))
    end
end

for i = 1, 9 do
    hl.bind(mainMod .. " + " .. i,          hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + CTRL + " .. i,   hl.dsp.window.move({ workspace = i }))
end

-- Mouse
hl.bind(mainMod .. " + mouse_down",          hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",            hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + SHIFT + mouse_down",  hl.dsp.layout("focus r"))
hl.bind(mainMod .. " + SHIFT + mouse_up",    hl.dsp.layout("focus l"))
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Media keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 10%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),      { locked = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),    { locked = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl --class=backlight set +10%"),        { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl --class=backlight set 10%-"),        { locked = true, repeating = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioStop",  hl.dsp.exec_cmd("playerctl stop"),       { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
