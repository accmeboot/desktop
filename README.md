# desktop

- dwl
- dwlmsg

## Session

`dwl-session` reads two optional files, copied from `session/` by `install.sh` if missing:

- `~/.config/dwl/env`: sourced before dwl starts (variables: `PATH`, `WLR_DRM_DEVICES`, ...)
- `~/.config/dwl/autostart`: executable, run once dwl is up (programs: `qs`, `hypridle`, `wlr-randr`, ...)
