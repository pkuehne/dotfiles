function dps() {
  docker ps -a --format "table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"
}

function _fzf_select_container() {
  docker ps --format "{{.Names}}" | fzf --header="Select container"
}

function _fzf_select_container_all() {
  docker ps -a --format "{{.Names}}\t{{.Status}}" | fzf --header="Select container" | cut -f1
}

function dstatus() {
  local container="${1:-$(_fzf_select_container)}"
  [[ -z "$container" ]] && return 1
  docker inspect --format '
Name:    {{.Name}}
Image:   {{.Config.Image}}
Status:  {{.State.Status}}
Started: {{.State.StartedAt}}
Health:  {{if .State.Health}}{{.State.Health.Status}}{{else}}N/A{{end}}
Ports:   {{range $p, $conf := .NetworkSettings.Ports}}{{$p}}->{{(index $conf 0).HostPort}} {{end}}
' "$container"
}

function dlog() {
  local container="${1:-$(_fzf_select_container)}"
  [[ -z "$container" ]] && return 1
  docker logs --tail 30 "$container"
}

function dexec() {
  local container="${1:-$(_fzf_select_container)}"
  [[ -z "$container" ]] && return 1
  docker exec -it "$container" /bin/bash
}

function dkill() {
  local container="${1:-$(_fzf_select_container)}"
  [[ -z "$container" ]] && return 1
  docker kill "$container"
}

function dbounce() {
  local container="${1:-$(_fzf_select_container_all)}"
  [[ -z "$container" ]] && return 1
  docker restart "$container"
}

function dclean() {
  docker system prune -f
}
