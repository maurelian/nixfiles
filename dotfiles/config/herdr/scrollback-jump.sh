#!/usr/bin/env bash
# Browse the focused pane's scrollback in nvim, parked at the last match of a
# landmark pattern. n / N walk to older / newer landmarks; y yanks; q quits.
#
# Usage: scrollback-jump.sh [pattern] [lines]
#   pattern  nvim regex for the landmark (default: the starship prompt rule)
#   lines    scrollback depth to pull (default: 10000)
set -euo pipefail

# Assigned separately: a `}` inside ${1:-...} would close the expansion early.
default_pattern='^[─━]\{20,}'
pattern="${1:-$default_pattern}"
lines="${2:-10000}"

pane="${HERDR_ACTIVE_PANE_ID:-${HERDR_PANE_ID:-}}"
herdr="${HERDR_BIN_PATH:-herdr}"

die() {
  echo "$1" >&2
  sleep 2
  exit 1
}

[ -n "$pane" ] || die "no active pane"

file="$(mktemp -t herdr-scrollback)"
trap 'rm -f "$file"' EXIT
"$herdr" pane read "$pane" --source recent-unwrapped --lines "$lines" >"$file" ||
  die "pane read failed"
# A failed read still exits 0, returning an error envelope as its only line.
if [ "$(wc -l <"$file")" -le 1 ] && grep -q '"error"' "$file"; then
  die "$(cat "$file")"
fi

# --clean skips the user's plugins: no startup prompts to swallow the first key.
exec nvim --clean -R \
  -c 'set clipboard=unnamedplus laststatus=2 ruler ignorecase' \
  -c 'nnoremap <buffer> q :q!<CR>' \
  -c 'normal! G' \
  -c "silent! ?${pattern}" \
  -c 'normal! zt' \
  "$file"
