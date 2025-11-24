#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Extract values
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
model=$(echo "$input" | jq -r '.model.display_name')

# Time in yellow (using printf for colors)
time_str=$(printf '\033[33m%s\033[0m' "$(date +%T)")

# Directory - show last 3 components
dir_parts=$(echo "$cwd" | awk -F/ '{
    n = NF
    if (n <= 3) print $0
    else printf ".../%s/%s/%s", $(n-2), $(n-1), $n
}')

# Git information (skip optional locks)
git_info=""
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git -C "$cwd" -c core.fileMode=false --no-optional-locks branch --show-current 2>/dev/null || echo "detached")

    # Get short commit hash if in detached HEAD
    if [ "$branch" = "detached" ]; then
        commit_hash=$(git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
        branch="$commit_hash"
    fi

    # Git status indicators (similar to starship)
    git_status=$(git -C "$cwd" --no-optional-locks status --porcelain 2>/dev/null)
    if [ -n "$git_status" ]; then
        status_indicator="*"
    else
        status_indicator=""
    fi

    git_info=$(printf ' \033[35mon\033[0m \033[36m%s%s\033[0m' "$branch" "$status_indicator")
fi

# Output the status line (removed trailing ➜)
printf '%s %s%s' "$time_str" "$dir_parts" "$git_info"
