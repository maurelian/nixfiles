#!/bin/bash

# Read hook input from stdin
input=$(cat)

# Extract session info from the JSON input
session_name=$(echo "$input" | jq -r '.session.name // "Claude Code"')

# Send macOS notification when Claude is waiting for input
osascript -e "display notification \"Ready for your input\" with title \"$session_name\""
