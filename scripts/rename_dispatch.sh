#!/usr/bin/env bash
# Dispatch rename to rename_window.sh or rename_session.sh based on the selected item.
# Window items look like "session:index" (number after colon); session items are plain names.

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
target="$1"

if [[ "$target" =~ ^[^:]+:[0-9]+$ ]]; then
	printf 'execute(%s/rename_window.sh "%s")+reload(%s/reload_after_rename.sh window)+change-preview(%s/preview.sh -w {1})' \
		"$SCRIPTS_DIR" "$target" "$SCRIPTS_DIR" "$SCRIPTS_DIR"
else
	printf 'execute(%s/rename_session.sh "%s")+reload(%s/reload_after_rename.sh session)+change-preview(%s/preview.sh {1})+transform-border-label(printf '\''Current session: "%%s" '\'' "$(tmux display-message -p '"'"'#S'"'"')")' \
		"$SCRIPTS_DIR" "$target" "$SCRIPTS_DIR" "$SCRIPTS_DIR"
fi
