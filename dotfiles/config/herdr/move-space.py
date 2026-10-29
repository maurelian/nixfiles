#!/usr/bin/env python3
"""Move the focused space one slot up or down in the sidebar.

Usage: move-space.py up|down
Bound to prefix+shift+k / prefix+shift+j via [[keys.command]] in config.toml.
"""
import json
import os
import socket
import sys

SOCKET = os.environ.get("HERDR_SOCKET_PATH") or os.path.expanduser(
    "~/.config/herdr/herdr.sock"
)


def call(method, params):
    s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    s.connect(SOCKET)
    s.sendall((json.dumps({"id": "move-space", "method": method, "params": params}) + "\n").encode())
    s.settimeout(10)
    buf = b""
    while b"\n" not in buf:
        chunk = s.recv(65536)
        if not chunk:
            break
        buf += chunk
    reply = json.loads(buf.split(b"\n")[0])
    if "error" in reply:
        raise SystemExit("move-space: %s" % reply["error"].get("message", reply["error"]))
    return reply["result"]


if len(sys.argv) != 2 or sys.argv[1] not in ("up", "down"):
    raise SystemExit("usage: move-space.py up|down")
delta = -1 if sys.argv[1] == "up" else 1

spaces = call("workspace.list", {})["workspaces"]

# HERDR_ACTIVE_WORKSPACE_ID is only set for keybinding-launched commands.
active = os.environ.get("HERDR_ACTIVE_WORKSPACE_ID")
if active:
    index = next((i for i, w in enumerate(spaces) if w["workspace_id"] == active), None)
else:
    index = next((i for i, w in enumerate(spaces) if w.get("focused")), None)
if index is None:
    raise SystemExit("move-space: no focused space")

target = index + delta
if not 0 <= target < len(spaces):
    sys.exit(0)

# insert_index counts slots in the list *before* the space is lifted out, so a
# downward move has to clear its own vacated slot as well.
insert_index = target if target < index else target + 1

call("workspace.move", {"workspace_id": spaces[index]["workspace_id"], "insert_index": insert_index})
