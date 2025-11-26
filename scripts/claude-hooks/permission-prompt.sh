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

# Extract tool information from the JSON input
tool_name=$(echo "$input" | jq -r '.tool_name // "unknown"')
tool_description=$(echo "$input" | jq -r '.description // "A tool needs permission"')

# Escape quotes and backslashes for AppleScript
tool_name_escaped=$(echo "$tool_name" | sed 's/\\/\\\\/g; s/"/\\"/g')
tool_description_escaped=$(echo "$tool_description" | sed 's/\\/\\\\/g; s/"/\\"/g')

# Send macOS notification when Claude needs permission
osascript -e "display notification \"$tool_description_escaped\" with title \"Permission needed: $tool_name_escaped\"" || true
