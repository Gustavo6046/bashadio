#!/bin/bash

# == Web radio server configuration ==

# The TCP port the server should listen on. E.g., 22410.
PORT=22410

# The name of the tmux session used by the server. E.g. 'wradio'.
TMUX_SESSION="wradio"

# The name of the first window in the tmux session, that always is the player. E.g. 'Player'.
# The second window is used to log the actual listening process itself.
# Keep in mind that more windows than just two may be created while the server is running. Those are
# the ffmpeg instances of each client, and can be safely ignored if everything works. They can be used
# for troubleshooting transcoding issues. But if they just appear, that just means clients can connect
# to your server. Hooray!
PLAYER_WINDOW_NAME="Player"

# The name of the second window in the tmux session. This is used to log the listening process
# of the server. E.g. "Server"
SERVER_WINDOW_NAME="Server"

# The internal name of the virtual sink used in PulseAudio. E.g. "webradio".
SINK_NAME="webradio"

# The human-friendly description of the virtual sink used in PulseAudio, as can be seen e.g. in
# pavucontrol. E.g. "Web radio sink".
SINK_DESCRIPTION="Web radio sink"
													
# Sink to loopback played audio to the primary output (eg. speakers). The player's audio
# is always redirected to the virtual sink (see SINK_NAME and SINK_DESCRIPTION above). But
# this enables listening to it using a PulseAudio loopback. If setting up a loopback is
# not desired, set this to an empty string instead.

# If listening to the audio played back in the web radio *is* desired, set LOOPBACK_SINK to
# the name of the sink you want to send audio to; for most intents and purposes this is
# the primary sink, most often some sort of ALSA output sink.
LOOPBACK_SINK=alsa_output.pci-0000_00_1b.0.analog-stereo

# The initial directory of the shell started in the first window of the tmux session.
# The first window is the only one you want to worry about if everything is working. There you're
# supposed to start a player process, like mpv or moc or vlc, from the command line. There
# is a second window, and other windows appear and disappear, as well but need not be bothered with
# unless you're troubleshooting a ffmpeg transcoding issue.

# For example, '$HOME/Music' means the shell starts with $HOME/Music as the initial directory;
# this would be the 'Music' subfolder of your home directory.
INIT_DIRECTORY="$HOME/Music"
