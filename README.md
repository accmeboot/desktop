# desktop

- dwl
- dwlmsg

## Session

`dwl-session` reads two optional files:

- `~/.config/dwl/env`: sourced before dwl starts (variables: `PATH`, `WLR_DRM_DEVICES`, ...)
- `~/.config/dwl/autostart`: executable, run once dwl is up (programs: `qs`, `hypridle`, `wlr-randr`, ...)
