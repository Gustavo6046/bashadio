#!/bin/bash

source ./config.sh

# -- Initialize misc variables
PA_DEINIT_INDEX=()
MAIN_PID=$$

# -- Subroutines
function wr_setup {
	# -- Set everything up for the server automatically

	# setup PulseAudio virtual sink
	PA_DEINIT_INDEX+=("$(pactl load-module module-null-sink sink_name="$SINK_NAME" sink_properties=\"device.description=\'"$SINK_DESCRIPTION"\'\")")

	# setup PulseAudio loopback if set
	[[ -n "$LOOPBACK_SINK" ]] && PA_DEINIT_INDEX+=("$(pactl load-module module-loopback latency_msec=50 source="$SINK_NAME.monitor" sink="$LOOPBACK_SINK")")

	# setup tmux session
	tmux new-session -d -s "$TMUX_SESSION" -n "$PLAYER_WINDOW_NAME" "./player.sh \"$SINK_NAME\" \"$INIT_DIRECTORY\" \"$MAIN_PID\" \"$TMUX_SESSION\""
}

function wr_listen {
	# -- Create main diagnostics window and start listening for connections
	tmux new-window -t "$TMUX_SESSION" -n "$SERVER_WINDOW_NAME" socat TCP-LISTEN:"$PORT",fork,reuseaddr EXEC:"./client.sh $TMUX_SESSION $SINK_NAME"
}

function wr_show {
	# -- Show the tmux session once everything is set up.
	tmux select-window -t "$PLAYER_WINDOW_NAME"
	tmux attach-session -t "$TMUX_SESSION"
}

function wr_deinit {
	# -- Deinitialize the server setup
	
	# deinit tmux session
	tmux kill-session -t "$TMUX_SESSION"

	# deinit any PulseAudio modules that were setup automatically
	for module_index in "${PA_DEINIT_INDEX[@]}"; do
		[[ -n "$module_index" ]] && pactl unload-module "$module_index"
	done
}

# -- Initialize and run

wr_setup
trap wr_deinit EXIT
trap wr_deinit INT

wr_listen
wr_show
