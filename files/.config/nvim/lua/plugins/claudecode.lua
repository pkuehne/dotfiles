-- Hide tmux from Claude Code in the side panel. Seeing $TMUX, it copies to the
-- clipboard with an OSC 52 wrapped in tmux DCS passthrough; nvim's terminal is
-- in between and doesn't understand passthrough, so it prints "52;c;<base64>"
-- over the prompt. Copying still works: Claude Code also writes the clipboard
-- natively (wl-copy, or clip.exe under WSL). env values must be strings, and
-- Claude Code treats an empty $TMUX as unset.
return {
  "coder/claudecode.nvim",
  opts = {
    env = { TMUX = "", TMUX_PANE = "" },
  },
}
