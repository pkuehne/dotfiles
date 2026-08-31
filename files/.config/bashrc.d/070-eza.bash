has_tool eza || return 0

alias ls='eza -lh --group-directories-first --icons=auto'
alias lsa='ls -a'
alias ll='eza -lh --git --group-directories-first --icons=auto'
alias la='eza -lha --git --group-directories-first --icons=auto'
alias lt='eza --tree --level=2 --long --git --icons=auto'
alias lta='lt -a'
