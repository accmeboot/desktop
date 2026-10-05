# desktop

## Packages

| Package | Source | Used for |
| --- | --- | --- |
| `sway`, `xorg-xwayland` | pacman | the compositor |
| `stow` | pacman | linking the configs |
| `base-devel`, `git` | pacman | building paru |
| `paru`, `less` | AUR, pacman | AUR helper; `less` is its PKGBUILD review pager |
| `ly` | pacman | login greeter |
| `ghostty` | pacman | terminal |
| `wireplumber`, `playerctl`, `brightnessctl` | pacman | volume, media and brightness keys |
| `grim`, `slurp`, `wl-clipboard`, `libnotify` | pacman | screenshot scripts |
| `hypridle` | pacman | lock, screen off and suspend on idle |
| `xdg-desktop-portal`, `-wlr`, `-gtk`, `xdg-utils` | pacman | portals (screen sharing, file pickers) |
| `mpv`, `fzf` | pacman | video player and `mpv-picker.sh` |
| `pinta` | pacman | image editor |
| `discord` | pacman | chat |
| `thunderbird` | pacman | mail |
| `qbittorrent` | pacman | torrents |
| `zen-browser-bin` | AUR | browser |
| `limine` | pacman | bootloader |
| `btrfs-progs`, `snapper`, `snap-pac` | pacman | btrfs snapshots, also before/after every pacman transaction |
| `limine-mkinitcpio-hook` | AUR | kernels, initramfs and Limine entries on kernel updates |
| `limine-snapper-sync`, `xxhash` | AUR, pacman | snapshot entries in the Limine menu |
| `plymouth` | pacman | boot splash |

## Configs

`link.sh` stows these into `~`:

| Package | |
| --- | --- |
| `sway` | `~/.config/sway/config` |
| `hypridle` | `~/.config/hypr/hypridle.conf` |
| `xdg-desktop-portal-wlr` | screen sharing output picker through `mshell dmenu` |

`~/.config/sway/local` is included at the end of the sway config and belongs to the machine: outputs, inputs and per-machine `exec`s go there, not into the repo. `link.sh` creates it empty if missing.

`session/profile.sh` is installed to `/etc/profile.d/desktop.sh`: ly starts sessions through a login shell, so it sets `PATH` (for `mshell` and the scripts in `~/.local/bin`) and `QT_QPA_PLATFORMTHEME` (for mesa-shell's Qt theming) before sway starts. Per-machine variables go in `~/.zprofile`. Pick the stock `Sway` entry in ly.

## Boot

Snapper snapshots are bootable from the Limine menu.

| File | Installed to | |
| --- | --- | --- |
| `boot/limine` | `/etc/default/limine` | `ENABLE_UKI=no`: snapshot entries share kernel files, and the ESP is 1 GiB; `EXCLUDE_SNAPSHOT_TYPES="post"`: only pre snapshots get entries |
| `boot/mkinitcpio.conf` | `/etc/mkinitcpio.conf.d/limine.conf` | adds `btrfs-overlayfs`, so a read-only snapshot boots with a writable layer in RAM |

`install-boot.sh` also removes archinstall's UKI entry and files, which would stop booting after the next kernel update. Snapshots taken before it ran get no entries.

## Scripts

`install.sh` runs everything below in order (mesa-shell's `install.sh` after `clone-repos.sh`).

| Script | |
| --- | --- |
| `install-packages.sh` | installs the pacman packages |
| `clone-repos.sh` | clones [terminal](https://github.com/accmeboot/terminal) and [mesa-shell](https://github.com/accmeboot/mesa-shell) next to this repo |
| `install-aur.sh` | builds paru and installs the AUR packages, with PKGBUILD review |
| `install-boot.sh` | sets up Limine with Snapper snapshots |
| `link-scripts.sh` | links the runtime scripts into `~/.local/bin` |
| `link.sh` | stows the configs, creates `~/.config/sway/local` if missing |
| `install-profile.sh` | installs `session/profile.sh` to `/etc/profile.d/desktop.sh` |
| `install-ly.sh` | configures ly and enables it on tty2 (tty1 stays a plain login) |
| `screenshot-full.sh` | full screen screenshot to `~/Screenshots` and the clipboard |
| `screenshot-area.sh` | same, for a selected area |
| `mpv-picker.sh` | picks a video, audio track and subtitles with fzf and plays them in mpv |

## Archinstall

| Option | Value |
| --- | --- |
| Disk | default layout, btrfs with default subvolumes and compression, ESP at `/boot` (1 GiB) |
| Encryption | none |
| Snapshots | Snapper |
| Bootloader | Limine, UKI on |
| Swap | zram |
| Profile | Minimal |
| Network | NetworkManager |
| Audio | pipewire |
| Bluetooth | on |
| Additional packages | `git`, `vim` |

Then, from the TTY:

```sh
git clone https://github.com/accmeboot/desktop.git ~/setup/desktop
~/setup/desktop/install.sh
~/setup/terminal/install.sh
```
