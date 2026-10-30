hl.window_rule({
    name  = "password-managers-no-screen-share",
    match = { class = "^(org\\.keepassxc\\.KeePassXC|org\\.gnome\\.World\\.Secrets|com\\.onepassword\\.OnePassword)$" },

    no_screen_share = true,
})
