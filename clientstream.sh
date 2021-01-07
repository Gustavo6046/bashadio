#!/bin/bash

SINK_NAME="$1"
( pacat -r -d "$SINK_NAME".monitor | ffmpeg -f s16le -ar 44100 -ac 2 -i pipe:0 -f ogg -acodec libopus -ar 48000 -b:a 28k pipe:1 ) || pause 60
