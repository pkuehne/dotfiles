-- https://wiki.hypr.land/configuring/

require("monitors")

local terminal = "kitty"
local browser  = "firefox"
local launcher = "qs -c titan ipc call launcher toggle"
local locker   = "swaylock"

hl.on("hyprland.start", function()
    hl.exec_cmd("qs -c titan")
end)

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XDG_SESSION_TYPE", "wayland")


-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in  = 5,
        gaps_out = 20,

        border_size = 2,

        col = {
            active_border   = { colors = {"rgba(33ccffee)", "rgba(00ff99ee)"}, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },

        resize_on_border = false,
        allow_tearing    = false,

        layout = "scrolling",
    },

    decoration = {
        rounding       = 10,
        rounding_power = 2,

        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },

        blur = {
            enabled   = true,
            size      = 3,
            passes    = 1,
            vibrancy  = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },
})

hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })

hl.curve("easy",           { type = "spring", mass = 1, stiffness = 238.1191, damping = 24.21279333 })

hl.animation({ leaf = "global",        enabled = true,  speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true,  speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true,  speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 4.1,  spring = "easy",         style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true,  speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true,  speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true,  speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true,  speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true,  speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true,  speed = 7,    bezier = "quick" })

hl.config({
    scrolling = {
        fullscreen_on_one_column = false,
        column_width             = 1.0,
        explicit_column_widths   = "0.333, 0.5, 0.667, 1.0",
        focus_fit_method         = 1,
    },
})

hl.config({
    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo   = false,
    },
})

hl.config({
    layers = {
        allow_new_top_layers_over_existing_fullscreen = true,
    },
})


---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        numlock_by_default = true,

        follow_mouse = 1,

        sensitivity = 0,

        touchpad = {
            tap_to_click   = true,
            natural_scroll = true,
        },
    },
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})


---------------------
---- KEYBINDINGS ----
---------------------

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


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})

hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

hl.window_rule({
    name  = "firefox-pip",
    match = { class = "firefox$", title = "^Picture-in-Picture$" },

    float = true,
})

hl.window_rule({
    name  = "password-managers-no-screen-share",
    match = { class = "^(org\\.keepassxc\\.KeePassXC|org\\.gnome\\.World\\.Secrets|com\\.onepassword\\.OnePassword)$" },

    no_screen_share = true,
})
