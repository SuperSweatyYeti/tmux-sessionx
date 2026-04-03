#!/usr/bin/env bash
# Dispatch kill to kill-window or kill-session based on the selected item.
# Window items look like "session:index" (number after colon); session items are plain names.

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
target="$1"

if [[ "$target" =~ ^[^:]+:[0-9]+$ ]]; then
	printf 'execute-silent(tmux kill-window -t %s)+reload(tmux list-windows -a -F '\''#{session_name}:#{window_index} #{window_name}'\'')' \
		"$target"
else
	printf 'execute-silent(tmux kill-session -t %s)+reload(%s/reload_sessions.sh)' \
		"$target" "$SCRIPTS_DIR"
fi
