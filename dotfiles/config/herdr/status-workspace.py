#!/usr/bin/env python3
"""Print the focused workspace's full label, for ui.tab_bar_right.

Herdr renders the last line of stdout, so keep output to one line.
"""

import json
import os
import subprocess
import sys

herdr = os.environ.get("HERDR_BIN_PATH") or "herdr"


def run(*args):
    proc = subprocess.run([herdr, *args], capture_output=True, text=True)
    if proc.returncode != 0:
        return None
    try:
        return json.loads(proc.stdout)
    except json.JSONDecodeError:
        return None


def focused_label():
    wid = os.environ.get("HERDR_ACTIVE_WORKSPACE_ID")
    if wid:
        got = run("workspace", "get", wid)
        if got:
            return got["result"]["workspace"].get("label")

    listed = run("workspace", "list")
    if listed:
        for ws in listed["result"]["workspaces"]:
            if ws.get("focused"):
                return ws.get("label")
    return None


label = focused_label()
if not label:
    sys.exit(1)
print(label)
