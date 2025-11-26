#!/bin/bash
set -euo pipefail

# Check for required tools
if ! command -v jq &> /dev/null; then
    echo "Error: jq is required but not installed" >&2
    exit 1
fi

if ! command -v osascript &> /dev/null; then
    echo "Error: osascript is required (macOS only)" >&2
    exit 1
fi

# Read hook input from stdin
input=$(cat)

# Extract session info from the JSON input
session_name=$(echo "$input" | jq -r '.session.name // "Claude Code"')

# Escape quotes and backslashes for AppleScript
session_name_escaped=$(echo "$session_name" | sed 's/\\/\\\\/g; s/"/\\"/g')

# Send macOS notification when Claude is waiting for input
osascript -e "display notification \"Ready for your input\" with title \"$session_name_escaped\"" || true
