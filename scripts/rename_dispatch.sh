#!/usr/bin/env bash
# Dispatch rename to rename_window.sh or rename_session.sh based on the selected item.
# Window items look like "session:index" (number after colon); session items are plain names.

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
target="$1"

if [[ "$target" =~ ^[^:]+:[0-9]+$ ]]; then
	printf 'execute(%s/rename_window.sh "%s")+reload(tmux list-windows -a -F '\''#{session_name}:#{window_index} #{window_name}'\'')' \
		"$SCRIPTS_DIR" "$target"
else
	printf 'execute(%s/rename_session.sh "%s")+reload(%s/reload_sessions.sh)+transform-border-label(printf '\''Current session: "%%s" '\'' "$(tmux display-message -p '"'"'#S'"'"')")' \
		"$SCRIPTS_DIR" "$target" "$SCRIPTS_DIR"
fi
