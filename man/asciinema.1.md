% ASCIICAM(1) Version 2.0.1 | asciicam


NAME
====

**asciicam** - terminal session recorder


SYNOPSIS
========

| **asciicam \-\-version**
| **asciicam** _command_ \[_options_] \[_args_]


DESCRIPTION
===========

asciicam lets you easily record terminal sessions, replay
them in a terminal as well as in a web browser and share them on the web.
asciicam is Free and Open Source Software licensed under
the GNU General Public License v3.


COMMANDS
========

asciicam is composed of multiple commands, similar to `git`, `apt-get` or
`brew`.

When you run **asciicam** with no arguments a help message is displayed, listing
all available commands with their options.


rec [_filename_]
---

Record terminal session.

By running **asciicam rec [filename]** you start a new recording session. The
command (process) that is recorded can be specified with **-c** option (see
below), and defaults to **$SHELL** which is what you want in most cases.

You can temporarily pause the capture of your terminal by pressing
<kbd>Ctrl+\\</kbd>.  This is useful when you want to execute some commands during
the recording session that should not be captured (e.g. pasting secrets). Resume
by pressing <kbd>Ctrl+\\</kbd> again. When pausing desktop notification is
displayed so you're sure the sensitive output won't be captured in the
recording.

Recording finishes when you exit the shell (hit <kbd>Ctrl+D</kbd> or type
`exit`). If the recorded process is not a shell then recording finishes when
the process exits.

If the _filename_ argument is omitted then (after asking for confirmation) the
resulting asciicast is uploaded to
[asciicam-server](https://github.com/khulnasoft-lab/asciicam-server) (by default to
asciicam.org), where it can be watched and shared.

If the _filename_ argument is given then the resulting recording (called
[asciicast](doc/asciicast-v2.md)) is saved to a local file. It can later be
replayed with **asciicam play \<filename>** and/or uploaded to asciicam server
with **asciicam upload \<filename>**.

**ASCIICAM_REC=1** is added to recorded process environment variables. This
can be used by your shell's config file (`.bashrc`, `.zshrc`) to alter the
prompt or play a sound when the shell is being recorded.

Available options:

:   &nbsp;

    `--stdin`
    :   Enable stdin (keyboard) recording (see below)

    `--append`
    :   Append to existing recording

    `--raw`
    :   Save raw STDOUT output, without timing information or other metadata

    `--overwrite`
    :   Overwrite the recording if it already exists

    `-c, --command=<command>`
    :   Specify command to record, defaults to **$SHELL**

    `-e, --env=<var-names>`
    :   List of environment variables to capture, defaults to **SHELL,TERM**

    `-t, --title=<title>`
    :   Specify the title of the asciicast

    `-i, --idle-time-limit=<sec>`
    :   Limit recorded terminal inactivity to max `<sec>` seconds

    `--cols=<n>`
    :   Override terminal columns for recorded process

    `--rows=<n>`
    :   Override terminal rows for recorded process

    `-y, --yes`
    :   Answer "yes" to all prompts (e.g. upload confirmation)

    `-q, --quiet`
    :   Be quiet, suppress all notices/warnings (implies **-y**)

Stdin recording allows for capturing of all characters typed in by the user in
the currently recorded shell. This may be used by a player (e.g.
[asciicam-player](https://github.com/khulnasoft-lab/asciicam-player)) to display
pressed keys. Because it's basically a key-logging (scoped to a single shell
instance), it's disabled by default, and has to be explicitly enabled via
**--stdin** option.


play <_filename_>
---

Replay recorded asciicast in a terminal.

This command replays a given asciicast (as recorded by **rec** command) directly in
your terminal. The asciicast can be read from a file or from *`stdin`* ('-'):

Playing from a local file:

    asciicam play /path/to/asciicast.cast

Playing from HTTP(S) URL:

    asciicam play https://asciicam.org/a/22124.cast
    asciicam play http://example.com/demo.cast

Playing from asciicast page URL (requires `<link rel="alternate"
type="application/x-asciicast" href="/my/ascii.cast">` in page's HTML):

    asciicam play https://asciicam.org/a/22124
    asciicam play http://example.com/blog/post.html

Playing from stdin:

    cat /path/to/asciicast.cast | asciicam play -
    ssh user@host cat asciicast.cast | asciicam play -

Playing from IPFS:

    asciicam play dweb:/ipfs/QmNe7FsYaHc9SaDEAEXbaagAzNw9cH7YbzN4xV7jV1MCzK/ascii.cast

Available options:

:   &nbsp;

    `-i, --idle-time-limit=<sec>`
    : Limit replayed terminal inactivity to max `<sec>` seconds (can be fractional)

    `-s, --speed=<factor>`
    : Playback speed (can be fractional)

While playing the following keyboard shortcuts are available:

:    &nbsp;

    *`Space`*
    :   Toggle pause

    *`.`*
    :   Step through a recording a frame at a time (when paused)

    *`Ctrl+C`*
    :   Exit

Recommendation: run 'asciicam play' in a terminal of dimensions not smaller than the one
used for recording as there's no "transcoding" of control sequences for the new terminal
size.


cat <_filename_>
---

Print full output of recorded asciicast to a terminal.

While **asciicam play <filename>** replays the recorded session using timing
information saved in the asciicast, **asciicam cat <filename>** dumps the full
output (including all escape sequences) to a terminal immediately.

**asciicam cat existing.cast >output.txt** gives the same result as recording via
**asciicam rec \-\-raw output.txt**.


upload <_filename_>
------

Upload recorded asciicast to asciicam.org site.

This command uploads given asciicast (recorded by **rec** command) to
asciicam.org, where it can be watched and shared.

**asciicam rec demo.cast** + **asciicam play demo.cast** + **asciicam upload
demo.cast** is a nice combo if you want to review an asciicast before
publishing it on asciicam.org.

auth
----

Link and manage your install ID with your asciicam.org user account.

If you want to manage your recordings (change title/theme, delete) at
asciicam.org you need to link your "install ID" with your asciicam.org user
account.

This command displays the URL to open in a web browser to do that. You may be
asked to log in first.

Install ID is a random ID ([UUID
v4](https://en.wikipedia.org/wiki/Universally_unique_identifier)) generated
locally when you run asciicam for the first time, and saved at
**$HOME/.config/asciicam/install-id**. It's purpose is to connect local machine
with uploaded recordings, so they can later be associated with asciicam.org
account. This way we decouple uploading from account creation, allowing them to
happen in any order.

Note: A new install ID is generated on each machine and system user account you use
asciicam on. So in order to keep all recordings under a single asciicam.org
account you need to run **asciicam auth** on all of those machines. If you’re
already logged in on asciicam.org website and you run 'asciicam auth' from a new
computer then this new device will be linked to your account.

While you CAN synchronize your config file (which keeps the API token) across
all your machines so all use the same token, that’s not necessary. You can assign
new tokens to your account from as many machines as you want.

Note: asciicam versions prior to 2.0 confusingly referred to install ID as "API
token".


EXAMPLES
========

Record your first session:

    asciicam rec first.cast

End your session:

    exit

Now replay it with double speed:

    asciicam play -s 2 first.cast

Or with normal speed but with idle time limited to 2 seconds:

    asciicam play -i 2 first.cast

You can pass **-i 2** to **asciicam rec** as well, to set it permanently on a
recording. Idle time limiting makes the recordings much more interesting to
watch, try it.

If you want to watch and share it on the web, upload it:

    asciicam upload first.cast

The above uploads it to <https://asciicam.org>, which is a
default asciicam-server (<https://github.com/khulnasoft-lab/asciicam-server>)
instance, and prints a secret link you can use to watch your recording in a web
browser.

You can record and upload in one step by omitting the filename:

    asciicam rec

You'll be asked to confirm the upload when the recording is done, so nothing is
sent anywhere without your consent.


Tricks
------

Record slowly, play faster:

:   First record a session where you can take your time to type slowly what you want
    to show in the recording:

        asciicam rec initial.cast

    Then record the replay of 'initial.cast' as 'final.cast', but with five times the
    initially recorded speed, with all pauses capped to two seconds and with a title
    set as "My fancy title"::

        asciicam rec -c "asciicam play -s 5 -i 2 initial.cast" -t "My fancy title" final.cast

Play from *`stdin`*:

:   &nbsp;

    cat /path/to/asciicast.json | asciicam play -

Play file from remote host accessible with SSH:

:   &nbsp;

    ssh user@host cat /path/to/asciicat.json | asciicam play -


ENVIRONMENT
===========

**ASCIICAM_API_URL**

:   This variable allows overriding asciicam-server URL (which defaults to
    https://asciicam.org) in case you're running your own asciicam-server instance.

**ASCIICAM_CONFIG_HOME**

:   This variable allows overriding config directory location. Default location
    is $XDG\_CONFIG\_HOME/asciicam (when $XDG\_CONFIG\_HOME is set)
    or $HOME/.config/asciicam.


BUGS
====

See GitHub Issues: <https://github.com/khulnasoft-lab/asciicam/issues>


MORE RESOURCES
===============

More documentation is available on the asciicast.org website and its GitHub wiki:

* Web:  [asciicam.org/docs/](https://asciicam.org/docs/)
* Wiki: [github.com/khulnasoft-lab/asciicam/wiki](https://github.com/khulnasoft-lab/asciicam/wiki)
* IRC:  [Channel on Libera.Chat](https://web.libera.chat/gamja/#asciicam)
* Twitter: [@asciicam](https://twitter.com/asciicam)


AUTHORS
=======

asciicam's lead developer is Md Sulaiman.

For a list of all contributors look here: <https://github.com/khulnasoft-lab/asciicam/contributors>

This Manual Page was written by Md Sulaiman with help from Kurt Pfeifle.
