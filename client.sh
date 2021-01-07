#!/bin/bash

TMUX_SESSION="$1"
SINK_NAME="$2"

function cleanup {
	rm "$1"
}

STREAM_FIFO="$(mktemp -u)"
WINDOW_NAME="$(tmux new-window -t "$TMUX_SESSION" -P "socat EXEC:\"./clientstream.sh $SINK_NAME\" UNIX-LISTEN:$STREAM_FIFO")"
tmux select-window -t "$TMUX_SESSION:0"
trap 'cleanup "$STREAM_FIFO" "$WINDOW_NAME"' EXIT

socat UNIX-CONNECT:"$STREAM_FIFO" STDOUT
