local c = require("colors")

hl.window_rule({
    name  = "scratchpad",
    match = { class = "^scratchpad$" },

    workspace    = "special:scratchpad",
    float        = true,
    size         = { "monitor_w * 0.6", "monitor_h * 0.6" },
    center       = true,
    opacity      = "0.92",
    border_size  = 3,
    border_color = { colors = { c.rgb("orange"), c.rgb("purple"), c.rgb("magenta") }, angle = 45 },
})
