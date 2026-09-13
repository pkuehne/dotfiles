# Keep Mise itself discoverable before its activation script runs. Its installer
# lives at ~/.local/bin; the shims and GOBIN outputs belong on PATH as well.
export PATH="${HOME}/.local/bin:${HOME}/.local/share/mise/shims:${HOME}/go/bin:${PATH}"
