fpath=(${XDG_DATA_HOME:-$HOME/.local/share}/zsh/{completions,plugins/zsh-completions/src} $fpath)

# A full compinit — security-scanning every fpath directory, then rebuilding the
# dump — costs ~0.34s here, on every single shell. Run it at most once a day and
# take the -C fast path (load the dump, skip the scan) in between. The dump is
# version-suffixed so a zsh upgrade is never served an incompatible cached one,
# and `mise run completions` deletes it so new completions appear immediately.
_zcompdump_dir=${XDG_CACHE_HOME:-$HOME/.cache}/zsh
_zcompdump=$_zcompdump_dir/zcompdump-$ZSH_VERSION
[[ -d $_zcompdump_dir ]] || mkdir -p $_zcompdump_dir

autoload -Uz compinit
if () { emulate -L zsh -o extended_glob; [[ -n $_zcompdump(#qN.mh-24) ]] }; then
  compinit -C -d $_zcompdump
else
  compinit -d $_zcompdump
fi
unset _zcompdump _zcompdump_dir

# zsh ships _sccs, whose `#compdef` line claims SCCS's own `delta` command and so
# shadows the _delta the completions task generates. Bind it back explicitly.
compdef _delta delta

# LS_COLORS is unset here; eza, fzf-tab and the completion menu all read it.
# vivid costs a ~119ms fork, so cache it like the dump above — -nt against mise's
# versioned install path picks up a `mise up`.
if (( $+commands[vivid] )); then
  _lscolors=${XDG_CACHE_HOME:-$HOME/.cache}/vivid/tokyonight-moon
  if [[ ! -s $_lscolors || $commands[vivid] -nt $_lscolors ]]; then
    mkdir -p ${_lscolors:h}
    vivid generate tokyonight-moon > $_lscolors
  fi
  export LS_COLORS="$(<$_lscolors)"
  unset _lscolors
fi

# No _correct/_approximate: fzf does the fuzzy matching now.
zstyle ':completion:*' completer _expand _complete _ignored
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no   # required by fzf-tab
