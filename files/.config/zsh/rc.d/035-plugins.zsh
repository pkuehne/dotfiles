_zplug=${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins

# fzf-tab must be loaded after compinit, before other plugins
source $_zplug/fzf-tab/fzf-tab.plugin.zsh 2>/dev/null
source $_zplug/powerlevel10k/powerlevel10k.zsh-theme 2>/dev/null
source $_zplug/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
source $_zplug/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
unset _zplug

### fzf-tab ###
################
# Without this fzf-tab ignores FZF_DEFAULT_OPTS and loses the Dracula palette.
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' switch-group '<' '>'

# *:* rather than *:argument-rest — `cd <TAB>` has an empty context tail, which
# a literal tail would miss. Overrides below keep a `:*` tail for the same
# reason. --icons=always because a preview is not a tty.
typeset -g _FTB_PATH_PREVIEW='if [[ -d $realpath ]]; then
     eza --tree --level=2 --color=always --icons=always $realpath
   elif [[ -f $realpath ]]; then
     bat --color=always --style=numbers --line-range=:200 $realpath
   fi'
zstyle ':fzf-tab:complete:*:*' fzf-preview $_FTB_PATH_PREVIEW

# $realpath is exported only for file completions, so the catch-all draws an
# empty pane for option names and subcommands — and no zstyle pattern can tell
# `rg --<TAB>` (:complete:rg:) from `cd <TAB>` (:complete:cd:). Decide from the
# candidates instead. The second test keeps the non-file previews below visible.
_ftb_fzf_flags() {
  local pw=right:66% preview
  if [[ $_ftb_compcap != *$'\0'realdir$'\0'* ]]; then
    -ftb-zstyle -s fzf-preview preview
    [[ $preview == $_FTB_PATH_PREVIEW ]] && pw=hidden
  fi
  reply=( --height=60% --preview-window=$pw )
}
zstyle -e ':fzf-tab:*' fzf-flags '_ftb_fzf_flags'

zstyle ':fzf-tab:complete:git-(diff|restore|stash):*' \
  fzf-preview 'git diff --color=always -- $realpath | delta'

# Untracked paths have no diff.
zstyle ':fzf-tab:complete:git-add:*' \
  fzf-preview 'if git ls-files --error-unmatch $realpath >/dev/null 2>&1; then
                 git diff --color=always -- $realpath | delta
               else
                 bat --color=always --style=numbers --line-range=:200 $realpath
               fi'

zstyle ':fzf-tab:complete:git-(switch|checkout|branch|rebase|merge):*' \
  fzf-preview 'git log --oneline --graph --decorate --color=always $word | head -50'

zstyle ':fzf-tab:complete:(kill|ps):argument-rest' \
  fzf-preview 'ps --pid=$word -o cmd --no-headers -w -w'
