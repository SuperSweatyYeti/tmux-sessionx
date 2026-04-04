#!/usr/bin/env bash
# Outputs session list or window list based on mode argument.
# Used after a rename to do a fully fresh reload with no stale state.
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
mode="$1"

if [[ "$mode" == "window" ]]; then
	tmux list-windows -a -F '#{session_name}:#{window_index} #{window_name}'
else
	source "$CURRENT_DIR/git-branch.sh"

	CURRENT_SESSION=$(tmux display-message -p '#S')
	last_session=$(tmux display-message -p '#{client_last_session}')
	SESSIONS=$(tmux list-sessions | sed -E 's/:.*$//' | grep -Fxv "$last_session")

	filtered_sessions=$(tmux show-option -gqv @sessionx-_filtered-sessions)
	if [[ -n "$filtered_sessions" ]]; then
		filtered_and_piped=$(echo "$filtered_sessions" | sed -E 's/,/|/g')
		SESSIONS=$(echo "$SESSIONS" | grep -Ev "$filtered_and_piped")
	fi

	SESSIONS=$(echo -e "$SESSIONS\n$last_session" | awk '!seen[$0]++')

	filter_current=$(tmux show-option -gqv @sessionx-_filter-current)
	if [[ "$filter_current" == "true" ]] && [[ $(echo "$SESSIONS" | wc -l) -gt 1 ]]; then
		SESSIONS=$(echo "$SESSIONS" | grep -Fxv "$CURRENT_SESSION")
	fi

	GIT_BRANCH=$(tmux show-option -gqv "@sessionx-git-branch")
	if [[ "$GIT_BRANCH" == "on" ]]; then
		format_sessions_with_git_branch "$SESSIONS"
	else
		echo "$SESSIONS"
	fi
fi
