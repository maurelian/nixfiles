#!/usr/bin/env python3
"""Push each space's picker index to the sidebar as the $num token.

One-shot by default, for event hooks. With --watch it stays resident and
re-syncs on an interval, which covers renumbering that fires no event.
"""
import fcntl
import json
import os
import signal
import subprocess
import sys
import time

HERDR = os.environ.get("HERDR_BIN_PATH") or "herdr"
SOURCE = "space-numbers"
DEFAULT_INTERVAL = 10.0
LOCK_PATH = os.path.join(
    os.environ.get("TMPDIR", "/tmp"), "herdr-space-numbers-watch.lock"
)


def spaces():
    out = subprocess.run(
        [HERDR, "workspace", "list"], capture_output=True, text=True, check=True
    ).stdout
    return json.loads(out)["result"]["workspaces"]


def display_order(listed):
    """Order spaces the way the sidebar draws them.

    `number` follows herdr's flat order, but the sidebar pulls every worktree child
    up under its parent row, so a child created later than its siblings carries a
    number from further down the list. Group by repo, anchored on the first member
    seen, and the indices match the rows.
    """
    rows = []
    grouped = set()
    for w in listed:
        key = (w.get("worktree") or {}).get("repo_key")
        if key is None:
            rows.append(w)
            continue
        if key in grouped:
            # Insert after the group's last member so siblings keep their own order.
            at = max(i for i, r in enumerate(rows)
                     if (r.get("worktree") or {}).get("repo_key") == key)
            rows.insert(at + 1, w)
        else:
            grouped.add(key)
            rows.append(w)
    return rows


def sync():
    changed = 0
    for position, w in enumerate(display_order(spaces()), start=1):
        want = str(position)
        if (w.get("tokens") or {}).get("num") == want:
            continue
        subprocess.run(
            [HERDR, "workspace", "report-metadata", w["workspace_id"],
             "--source", SOURCE, "--token", "num=" + want],
            check=True, capture_output=True,
        )
        changed += 1
    return changed


def sync_once():
    # A workspace_created hook can fire before the new space is listed; retry briefly.
    for attempt in range(5):
        if sync() or attempt:
            return
        time.sleep(0.2)


def watch(interval):
    # One watcher per machine: the server respawns this at startup, and a hand-started
    # one from an earlier session may still be resident.
    lock = open(LOCK_PATH, "w")
    try:
        fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
    except OSError:
        print("space-numbers: another watcher holds the lock", file=sys.stderr)
        return

    stop = False

    def quit(_signum, _frame):
        nonlocal stop
        stop = True

    for sig in (signal.SIGTERM, signal.SIGINT, signal.SIGHUP):
        signal.signal(sig, quit)

    while not stop:
        try:
            sync()
        except subprocess.CalledProcessError as err:
            # The server may be mid-restart; keep the watcher alive for the next tick.
            print(f"space-numbers: {err}", file=sys.stderr, flush=True)
        except Exception as err:  # noqa: BLE001 - never let the loop die silently
            print(f"space-numbers: {err}", file=sys.stderr, flush=True)
        time.sleep(interval)


try:
    if "--watch" in sys.argv:
        arg = sys.argv[sys.argv.index("--watch") + 1:]
        watch(float(arg[0]) if arg else DEFAULT_INTERVAL)
    else:
        sync_once()
except subprocess.CalledProcessError as err:
    print(f"space-numbers: {err}", file=sys.stderr)
    sys.exit(1)
