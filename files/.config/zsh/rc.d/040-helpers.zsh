function reload() {
  exec zsh
}

function port() {
  if [[ -n "$1" ]]; then
    ss -tlnp | command grep ":$1 "
  else
    ss -tlnp | tail -n +2 | fzf --header="LISTEN ports"
  fi
}

function psef() {
  if [[ -n "$1" ]]; then
    ps -ef | head -1
    ps -ef | command grep -v grep | command grep "$1"
  else
    ps -ef | fzf --header-lines=1
  fi
}

function _fzf_select_unit() {
  systemctl list-units --type=service --all --plain --no-legend --no-pager |
    awk '{print $1}' |
    fzf --header="Select service" --height=80% \
      --preview="SYSTEMD_COLORS=1 SYSTEMD_URLIFY=0 systemctl status --no-pager {1}" \
      --preview-window="right,60%,wrap"
}

function system() {
  local unit="${1:-$(_fzf_select_unit)}"
  [[ -z "$unit" ]] && return 1
  systemctl status --no-pager "$unit"
}

function journal() {
  local unit="${1:-$(_fzf_select_unit)}"
  [[ -z "$unit" ]] && return 1
  if [[ -z "$(journalctl --unit "$unit" --since today --no-pager -q -n 1)" ]]; then
    echo "No entries today for $unit"
    return 1
  fi
  SYSTEMD_COLORS=1 journalctl --unit "$unit" --since today --no-pager |
    fzf --ansi --no-sort --wrap --multi --height=100% \
      --header="$unit — today | ctrl-a: all history" \
      --bind="load:last" \
      --bind="ctrl-a:reload(SYSTEMD_COLORS=1 journalctl --unit '$unit' --no-pager)+change-header($unit — all history)"
}

function help() {
  command cat <<'EOF'
Custom commands:

  reload            Restart the current shell
  port [number]     Show listening ports (fzf filter, or grep a specific port)
  psef [pattern]    Find processes (fzf filter, or grep a specific pattern)
  system [service]  Show a service's systemctl status
  journal [service] Browse today's journal (ctrl-a for all history)

  dps            List all docker containers (including exited)
  dstatus [name] Inspect a container's status
  dlog [name]    Show last 30 log lines of a container
  dexec [name]   Open /bin/bash in a container
  dkill [name]   Kill a running container
  dbounce [name] Restart a container
  dclean         Prune stopped containers, dangling images, unused networks

  Bracketed args are optional — omit to select via fzf
EOF
}
