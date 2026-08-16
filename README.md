# Waypaper Video for Omarchy

[Français](README.fr.md)

An Omarchy Quattro service plugin that supervises the `mpvpaper` video
wallpaper selected through Waypaper. Waypaper remains the graphical picker;
the plugin gives the renderer a reliable lifecycle inside `omarchy-shell`.

![Waypaper Video architecture](preview.png)

## Features

- Uses Waypaper as the video folder, picker, and configuration UI.
- Runs `mpvpaper` in the foreground so Omarchy Shell owns its lifecycle.
- Restarts unexpected crashes with capped exponential backoff.
- Supports start, stop, restart, pause, resume, and toggle through IPC.
- Stops the managed renderer when the plugin is disabled or the shell exits.
- Does not edit Waypaper, Hyprland, or Omarchy configuration files.

## Compatibility and requirements

Tested with:

- Omarchy `4.0.0` (Quattro), plugin manifest schema `1`
- Waypaper `2.8`
- mpvpaper `1.9`

Runtime commands and their Arch packages:

| Command | Package | Purpose |
| --- | --- | --- |
| `waypaper` | `waypaper` (AUR) | Graphical picker and configuration |
| `mpvpaper` | `mpvpaper` (AUR) | Video renderer |
| `socat` | `socat` | Pause/resume IPC controls |
| `awk` | `gawk` | Read Waypaper's INI file |
| `pgrep` | `procps-ng` | Retire the renderer using the selected socket |
| `uwsm-app` | `uwsm` | Open Waypaper in the current desktop session |

Omarchy normally already provides `gawk`, `procps-ng`, and `uwsm`. Install the
remaining packages with Omarchy's package helpers:

```sh
omarchy pkg aur add mpvpaper waypaper
omarchy pkg add socat
```

## Install

The plugin executes unsandboxed with your user permissions. Review the source
before enabling it.

```sh
omarchy plugin add \
  https://github.com/GavidetDoliath/omarchy-waypaper-video-background.git
```

When the interactive command asks whether to enable the plugin immediately,
answer **No**. The plugin remains disabled, which leaves the current static
background untouched while Waypaper is configured. In a non-interactive
shell, the plugin remains disabled unless `--enable` is passed explicitly.

## Configure Waypaper

1. Open Waypaper.
2. Select `mpvpaper` as the backend.
3. Select the folder containing your videos.
4. Choose a video and the desired fill mode.
5. Keep sound disabled unless wallpaper audio is intentional.

Useful Waypaper settings include:

```ini
backend = mpvpaper
mpvpaper_sound = False
mpvpaper_options = hwdec=auto loop-file=inf
```

Validate the resolved configuration without starting a renderer:

```sh
~/.config/omarchy/plugins/io.github.gavidetdoliath.waypaper-video-background/start-mpvpaper.sh --check
```

After the check succeeds, replace Omarchy's static background service:

```sh
omarchy plugin disable omarchy.background
omarchy plugin enable io.github.gavidetdoliath.waypaper-video-background
```

Open Waypaper later to select another video:

```sh
omarchy-shell waypaper-video-background open
```

Waypaper sends the selection to the managed mpvpaper process through its IPC
socket, so the Omarchy service does not need to be restarted for each video.

## Controls

```sh
omarchy-shell waypaper-video-background status
omarchy-shell waypaper-video-background start
omarchy-shell waypaper-video-background stop
omarchy-shell waypaper-video-background restart
omarchy-shell waypaper-video-background pause
omarchy-shell waypaper-video-background resume
omarchy-shell waypaper-video-background toggle
omarchy-shell waypaper-video-background open
```

`status` returns JSON containing the process state, PID, restart attempts, last
exit code, and last error message.

## Update

```sh
omarchy plugin update io.github.gavidetdoliath.waypaper-video-background
```

Omarchy shows the incoming Git diff and updates by fast-forward.

## Disable, roll back, and remove

Return to Omarchy's static background before removing the plugin:

```sh
omarchy plugin disable io.github.gavidetdoliath.waypaper-video-background
omarchy plugin enable omarchy.background
omarchy plugin remove io.github.gavidetdoliath.waypaper-video-background
```

Removal unloads the service and deletes only the Git checkout. It does not
delete Waypaper's configuration, your video folder, or the installed packages.

## Behavior and security boundaries

- The plugin reads `~/.config/waypaper/config.ini`; it never writes to it.
- It creates the Waypaper-compatible socket `/tmp/mpv-socket-<monitor>`.
- Before starting, it terminates only an existing user-owned `mpvpaper`
  process whose command line uses that exact socket.
- It launches no downloader, installer, system service, `sudo`, or `pkexec`.
- Video wallpapers continuously use rendering resources. Pause or stop the
  renderer on battery when needed.
- The current Waypaper `monitors` value selects either one output or `All`.

## Troubleshooting

### Configuration and runtime status

Check the effective Waypaper settings:

```sh
~/.config/omarchy/plugins/io.github.gavidetdoliath.waypaper-video-background/start-mpvpaper.sh --check
```

Inspect the managed process:

```sh
omarchy-shell waypaper-video-background status | jq
```

Confirm discovery and enablement:

```sh
omarchy plugin list --json \
  | jq '.[] | select(.id == "io.github.gavidetdoliath.waypaper-video-background")'
```

Inspect recent shell errors:

```sh
qs log -p "$OMARCHY_PATH/shell" --tail 100
```

Configuration or dependency errors stop automatic retries. Correct the issue,
then run `omarchy-shell waypaper-video-background start`.

## Development

Validate the repository on Omarchy Quattro:

```sh
./validate.sh
```

The validation script checks the official Omarchy manifest contract, QML, and
shell syntax without starting the wallpaper. See [TESTING.md](TESTING.md) for
the completed local verification and the remaining public-release matrix.

## License

[MIT](LICENSE)
