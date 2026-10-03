# desktop

## Packages

| Package | Source | Used for |
| --- | --- | --- |
| `dwl-accme` | `dwl/` | the compositor |
| `dwlmsg-accme` | `dwlmsg/` | CLI client for dwl's IPC |
| `base-devel`, `git` | pacman | building dwl, dwlmsg and paru |
| `paru`, `less` | AUR, pacman | AUR helper; `less` is its PKGBUILD review pager |
| `ly` | pacman | login greeter |
| `ghostty` | pacman | terminal |
| `wireplumber`, `playerctl`, `brightnessctl` | pacman | volume, media and brightness keys |
| `grim`, `slurp`, `wl-clipboard`, `libnotify` | pacman | screenshot scripts |
| `wlr-randr` | pacman | output modes |
| `hypridle`, `wlopm` | pacman | lock, screen off and suspend on idle |
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

## dwl

dwl 0.9, patches applied in this order:

| Patch | Source | |
| --- | --- | --- |
| `ipc.patch` | [dwl-patches](https://codeberg.org/dwl/dwl-patches/src/branch/main/patches/ipc) | |
| `gaps.patch` | [dwl-patches](https://codeberg.org/dwl/dwl-patches/src/branch/main/patches/gaps) | rebased onto `ipc.patch` |
| `input-config.patch` | custom | separate mouse and touchpad libinput settings, touchpad scroll factor and disabling pointer devices by name; upstream dwl has one set of settings for all pointers |
| `layer-popups.patch` | custom | for mesa-shell: its panels and click-catcher layer didn't get mouse focus. Layer surface popups get their own layer above everything and are repositioned on `xdg_popup.reposition` |
| `alwayscenter.patch` | [dwl-patches](https://codeberg.org/dwl/dwl-patches/src/branch/main/patches/alwayscenter) | |
| `exclusive-focus.patch` | custom | fixes `exclusive_focus` never being released when a layer surface drops exclusive keyboard focus without unmapping; drop after 0.9 |

## dwlmsg

| Patch | Source | |
| --- | --- | --- |
| `dwl-ipc.patch` | custom | updates dwlmsg to the protocol in dwl's `ipc.patch` (`focused_geometry` event, prints the layout index) |

## Boot

Snapper snapshots are bootable from the Limine menu.

| File | Installed to | |
| --- | --- | --- |
| `boot/limine` | `/etc/default/limine` | `ENABLE_UKI=no`: snapshot entries share kernel files, and the ESP is 1 GiB; `EXCLUDE_SNAPSHOT_TYPES="post"`: only pre snapshots get entries |
| `boot/mkinitcpio.conf` | `/etc/mkinitcpio.conf.d/limine.conf` | adds `btrfs-overlayfs`, so a read-only snapshot boots with a writable layer in RAM |

`install-boot.sh` also removes archinstall's UKI entry and files, which would stop booting after the next kernel update. Snapshots taken before it ran get no entries.

## Scripts

`install.sh` runs everything below in order (mesa-shell's `install.sh` after `clone-repos.sh`), then builds dwl and dwlmsg; on later runs it asks before rebuilding them.

| Script | |
| --- | --- |
| `install-packages.sh` | installs the pacman packages |
| `clone-repos.sh` | clones [terminal](https://github.com/accmeboot/terminal) and [mesa-shell](https://github.com/accmeboot/mesa-shell) next to this repo |
| `install-aur.sh` | builds paru and installs the AUR packages, with PKGBUILD review |
| `install-boot.sh` | sets up Limine with Snapper snapshots |
| `link-scripts.sh` | links the runtime scripts into `~/.local/bin` |
| `install-session.sh` | copies `env` and `autostart` to `~/.config/dwl` if missing, links the portal and hypridle configs |
| `install-ly.sh` | configures ly and enables it on tty2 (tty1 stays a plain login) |
| `build-dwl.sh [dwl] [dwlmsg]` | builds and installs the packages |
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
