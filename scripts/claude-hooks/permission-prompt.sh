#!/bin/bash

# Read hook input from stdin
input=$(cat)

# Extract tool information from the JSON input
tool_name=$(echo "$input" | jq -r '.tool_name // "unknown"')
tool_description=$(echo "$input" | jq -r '.description // "A tool needs permission"')

# Send macOS notification when Claude needs permission
osascript -e "display notification \"$tool_description\" with title \"Permission needed: $tool_name\""
