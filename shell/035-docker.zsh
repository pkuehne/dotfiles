if ! command -v docker &>/dev/null; then
  return
fi

# docker ps -a with just the essentials
dps() {
  docker ps -a --format 'table {{.ID}}\t{{.Names}}\t{{.Status}}'
}

# Pick a container ID interactively with fzf (use in command substitution)
# e.g. docker inspect $(dsel)
dsel() {
  docker ps -a --format '{{.ID}}\t{{.Names}}\t{{.Status}}' \
    | fzf --prompt='container> ' --header='ID  NAME  STATUS' \
    | cut -f1
}
