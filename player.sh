#!/bin/bash

function deinit {
	# deinitialization; stop tmux, which stops the server
	[[ -n "$4" ]] && tmux kill-session -t "$4"
}

[[ -n "$3" ]] && trap deinit EXIT
[[ -n "$1" ]] && export PULSE_SINK="$1"

# let execute user's default shell by not specifying a command to run at this point. if this shell exits, we run deinit.
# we run it in a subshell to ensure we do not trigger the trap early either. but this might just be paranoia.
( cd "$2" && eval "$SHELL" )
deinit "$@"
