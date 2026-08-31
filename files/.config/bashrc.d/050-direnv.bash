has_tool direnv || return 0

eval "$(direnv hook bash)"
