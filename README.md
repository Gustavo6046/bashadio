# Bashadio

A simple TCP web radio entirely written in Bash.

## Installation

As long as you have all the dependencies, just copy the scripts to a directory and run from there!

As for dependencies, this script requires the following to be installed a priori:

 * socat
 * ffmpeg
 * tmux
 * bash

It additionally only works if you're using PulseAudio, not JACK.

## Configuration

This server can be configured to your heart's desired! You can edit `config.sh` to do so.

Check the comments in `config.sh` to learn more about configuring Bashadio.

## Usage

Once you've configured the server, simply start it by running `server.sh` without arguments.

The server will listen on the port you specified in `config.sh`. It is a 44100 Hz, 28 kbps Ogg
Opus stream over TCP, and [currently](ROADMAP.md) there is no way to configure the format of the stream.

As soon as you start the server, it will open a tmux session, which should have at least two windows:

* The first window is the "player" window. There you're supposed to play some music using whatever
  media player you want, specifying the commands to run them. For instance,

  ```
  mpv my_tune.mp3
  ```

* The second window is the "server" window. Really it's just a log of the listening socket. Useful
  to diagnose connection issues.

* When a client connects successfully, a "transcoding" window is spawn. [Right now](ROADMAP.md), those
  are not labeled as such; just keep in mind that every window starting from the third is a client window,
  usually transcoding playbacked music using FFmpeg. Multiple of those can exist at once, if multiple clients
  are connected at once. Usually, those windows are closed when a client exits, except with a delay of 60
  seconds (1 minute) if an issue arises in transcoding.

To listen to the tunes playing in the 'web radio', simply connect to the TCP port and stream the Ogg Opus
data from the connection to a media player. Some browsers, like Firefox, just might be able to do this
just by opening the URI of the listen port like any other. However, it's usually better anyway to just
pipe it to a media player. For instance, if you want to hear from a server running in localhost:

```sh
$ socat TCP-CONNECT:localhost:22410 STDOUT | ffplay pipe:0   # use socat and ffplay (recommended)
```

Or:

```sh
$ ncat localhost 22410 | mpv /dev/stdin   # use ncat and mpv (slower, but more straightforward to type)
```

Keep in mind that this should not need to be used if you want to hear the tunes you're playing yourself;
in that case, set the loopback option in `config.sh`. Using the default sink in PulseAudio is the default
behaviour and should be sufficient for most intents and purposes.
