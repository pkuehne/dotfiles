hl.window_rule({
    name  = "firefox-pip",
    match = { class = "firefox$", title = "^Picture-in-Picture$" },

    float = true,
})
