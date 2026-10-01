# desktop

- dwl
- dwlmsg

## Apps

- mpv, with `mpv-picker.sh`: picks a video, then optionally an external audio track and subtitles, from the current directory (two levels deep) with fzf
- pinta
- discord
- thunderbird
- qbittorrent (Qt, so it takes base16's colors and fonts through qt6ct)

## Install

- `pacman -Syu`, never `-S`: installing against a stale package database is a partial upgrade
- dwl and dwlmsg are built on the first install; afterwards `install.sh` asks, since a rebuild is only needed after editing `config.h` or the patches
- `scripts/link-scripts.sh` links the runtime scripts into `~/.local/bin`, which `~/.config/dwl/env` puts on `PATH`
- `scripts/install-quickshell.sh` installs Quickshell with everything mesa-shell uses (see its README) and clones mesa-shell into `~/.config/quickshell/mesa-shell`; upower is D-Bus activated, NetworkManager and bluetooth have to be enabled

### AUR

`scripts/install-aur.sh` never passes `--noconfirm` or `--skipreview`: reviewing each PKGBUILD, and its diff on updates, is the only protection against malicious AUR packages. `less` is installed as paru's review pager. It builds `paru`, not `paru-bin`: paru is built from its author's release tarball, while paru-bin is orphaned. `--rmdeps` removes cargo again after the build. Installed packages are skipped; updates come from `paru` itself.

### dwl

`scripts/build-dwl.sh [dwl] [dwlmsg]` builds both without arguments. `makepkg -s` installs each PKGBUILD's dependencies, `-C` starts from a clean `src/` so the patches always apply to pristine sources, and `-f` overwrites an earlier build.

The patches in `dwl/PKGBUILD` apply in order, each on top of the previous. Only the upstream tarball is checksummed; the local files are tracked by git. The package replaces upstream's `dwl.desktop` (`Exec=dwl`) with one that runs `dwl-session`.

`config.h`:

- `COLOR()` is from [djpohly/dwl#466](https://github.com/djpohly/dwl/issues/466), premultiplied by alpha since wlroots blends rects premultiplied
- the colors are the same gray for both polarities, focus only differs in alpha
- `rules` and `axes` hold a no-op entry because the arrays can't be empty; dialogs still float since `applyrules()` ORs in `client_is_float_type()`
- `gaps`/`smartgaps`/`gappx` come from `gaps.patch`; `scroll_factor`, the `mouse_*` settings and `disabled_devices` from `input-config.patch`

## Session

`dwl-session` is what the greeter starts through `dwl.desktop`. Host-specific setup stays out of the package, in two optional files copied from `session/` by `install.sh` if missing; afterwards they belong to the machine, so local edits never touch the repo:

- `~/.config/dwl/env`: sourced before dwl starts; exported variables reach dwl and everything it spawns (`PATH`, `QT_QPA_PLATFORMTHEME`, `WLR_DRM_DEVICES`, ...). On a hybrid GPU laptop, `export WLR_DRM_DEVICES=/dev/dri/by-path/<iGPU>-card` (from `ls -l /dev/dri/by-path`) runs dwl on the iGPU
- `~/.config/dwl/autostart`: executable, run once dwl is up; background long-running programs with `&`. They are in dwl's startup process group and get SIGTERM when dwl exits. Typical lines: `qs -c mesa-shell &`, `wlr-randr --output DP-2 --mode 2560x1440@239.970001Hz`

dwl writes its status to the startup command's stdin; nothing reads it, so `dwl-session` closes it, or dwl would block once the pipe buffer fills. Portals are D-Bus activated by systemd and only see `WAYLAND_DISPLAY` through the activation environment, so `dwl-session` exports it there. On exit it stops the portals, which would otherwise outlive the compositor and keep a dead `WAYLAND_DISPLAY`.

The configs that are the same everywhere are symlinked instead. `dwl-portals.conf` is needed because `XDG_CURRENT_DESKTOP=dwl` and xdg-desktop-portal-wlr doesn't list dwl itself. The screen chooser in `xdg-desktop-portal-wlr.conf` runs through `/bin/sh -c`, so `$HOME` expands.

## Theming

Colors come from [base16](../base16), which renders a dark and a light palette. The desktop's `color-scheme` setting (`org.gnome.desktop.interface`) decides which one is shown; mesa-shell's dark theme toggle writes it.

- GTK4 / libadwaita: `~/.config/gtk-4.0/gtk.css` imports both palettes, each wrapped in `@media (prefers-color-scheme: ...)`, so GTK picks the right one itself
- GTK3 has no color-scheme preference, so each polarity is its own theme, `base16-dark` / `base16-light`: adw-gtk3 with base16's colors on top
- Qt: qt5ct/qt6ct (`QT_QPA_PLATFORMTHEME=qt5ct`; qt6ct answers to that name too); `qt5ct.conf`/`qt6ct.conf` link to base16's `qtct.conf` for the polarity, which sets the color scheme and fonts
- fonts: `~/.config/fontconfig/fonts.conf` includes base16's `fonts.conf`, which puts the configured fonts in front of sans-serif/serif/monospace. It inserts them right before the generic name, not at the head of the list, so a font an app asks for by name still wins

`scripts/follow-color-scheme.sh`, started from autostart, switches the GTK3 theme and relinks the qt5ct/qt6ct configs when the setting changes; qt*ct reload on their own when a file in their config directory is replaced, so a font change from `base16 build` reaches running Qt apps on the next switch or restart. `scripts/install-theme.sh` writes the GTK3 themes every time, and the GTK4 and fontconfig configs only if missing.
