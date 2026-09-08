has_tool docker || return 0
has_tool fzf || return 0

dps() {
  docker ps -a --format 'table {{.ID}}\t{{.Names}}\t{{.Status}}'
}

dsel() {
  docker ps -a --format '{{.ID}}\t{{.Names}}\t{{.Status}}' \
    | fzf --prompt='container> ' --header='ID  NAME  STATUS' \
    | cut -f1
}
