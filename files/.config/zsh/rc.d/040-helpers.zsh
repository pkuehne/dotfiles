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

function help() {
  command cat <<'EOF'
Custom commands:

  reload         Restart the current shell
  port [number]  Show listening ports (fzf filter, or grep a specific port)
  psef [pattern]   Find processes (fzf filter, or grep a specific pattern)

  dps            List all docker containers (including exited)
  dstatus [name] Inspect a container's status
  dlog [name]    Show last 30 log lines of a container
  dexec [name]   Open /bin/bash in a container
  dkill [name]   Kill a running container
  dbounce [name] Restart a container
  dclean         Prune stopped containers, dangling images, unused networks

  [name] is optional — omit to select via fzf
EOF
}
