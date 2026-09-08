#!/usr/bin/env bash
input=$(cat)
model=$(echo "$input" | jq -r '.model.display_name')
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
dir=$(basename "$cwd")

branch=""
if git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
    branch=$(git -C "$cwd" --no-optional-locks rev-parse --abbrev-ref HEAD 2>/dev/null)
    [ -n "$branch" ] && branch=" (${branch})"
fi

ctx=""
[ -n "$used" ] && ctx=$(printf " [%.1f%%]" "$used")

printf '\033[00;32m%s\033[00m\033[01;33m%s\033[00m \033[00;36m%s\033[00m\033[00;36m%s\033[00m' \
    "$dir" "$branch" "$model" "$ctx"
