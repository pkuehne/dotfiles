local c = require("colors")

hl.config({
    general = {
        gaps_in  = 5,
        gaps_out = 20,

        border_size = 2,

        col = {
            active_border   = { colors = { c.rgb("blue"), c.rgb("magenta") }, angle = 45 },
            inactive_border = c.rgb("bg_highlight"),
        },

        resize_on_border = false,
        allow_tearing    = false,
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
            color        = c.rgba("bg_dark1", "ee"),
        },

        blur = {
            enabled   = true,
            size      = 3,
            passes    = 1,
            vibrancy  = 0.1696,
        },
    },

    group = {
        col = {
            border_active   = { colors = { c.rgb("magenta"), c.rgb("purple") }, angle = 45 },
            border_inactive = c.rgb("bg_highlight"),
        },
        groupbar = {
            col = {
                active   = c.rgb("magenta"),
                inactive = c.rgb("bg_highlight"),
            },
            text_color          = c.rgb("bg_dark"),
            text_color_inactive = c.rgb("fg_dark"),
        },
    },

    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,
        background_color        = c.rgb("bg"),
    },

    layers = {
        allow_new_top_layers_over_existing_fullscreen = true,
    },
})
