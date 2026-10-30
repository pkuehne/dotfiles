hl.layer_rule({
    name  = "quickshell-blur",
    match = { namespace = "^quickshell$" },

    blur         = true,
    blur_popups  = true,
    ignore_alpha = 0.1,
})
