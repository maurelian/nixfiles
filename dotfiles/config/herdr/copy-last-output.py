#!/usr/bin/env python3
"""Copy the last command's output in the focused pane to the clipboard.

Prompt blocks are delimited by starship's $fill rule (see ~/.config/starship.toml);
the command line itself carries the ➜ character. Everything between the last ➜ and
the rule that follows it is the last command's output.
"""

import os
import re
import subprocess
import sys

RULE = re.compile(r"^[─━┄┅_=-]{20,}\s*$")
PROMPT = "➜"
FALLBACK_LINES = 100

pane = os.environ.get("HERDR_ACTIVE_PANE_ID") or os.environ.get("HERDR_PANE_ID")
if not pane:
    sys.exit("no active pane")

herdr = os.environ.get("HERDR_BIN_PATH") or "herdr"
depth = sys.argv[1] if len(sys.argv) > 1 else "2000"

read = subprocess.run(
    [herdr, "pane", "read", pane, "--source", "recent-unwrapped", "--lines", depth],
    capture_output=True,
    text=True,
)
if read.returncode != 0:
    sys.exit(read.stderr.strip() or "pane read failed")

lines = read.stdout.splitlines()


def rindex(pred, seq):
    for i in range(len(seq) - 1, -1, -1):
        if pred(seq[i]):
            return i
    return None


# The trailing rule belongs to the fresh prompt, so it bounds the block above it.
end = rindex(RULE.match, lines)
block = lines[:end] if end is not None else lines
start = rindex(lambda line: PROMPT in line, block)
out = block[start + 1:] if start is not None else block[-FALLBACK_LINES:]

while out and not out[-1].strip():
    out.pop()
if not out:
    sys.exit("nothing to copy")

subprocess.run(["pbcopy"], input="\n".join(out) + "\n", text=True, check=True)
subprocess.run(
    [herdr, "notification", "show", f"Copied {len(out)} lines", "--position", "bottom-right"],
    capture_output=True,
)
