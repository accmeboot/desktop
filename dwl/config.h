#define COLOR(hex)    { ((hex >> 24) & 0xFF) / 255.0f * (hex & 0xFF) / 255.0f, \
                        ((hex >> 16) & 0xFF) / 255.0f * (hex & 0xFF) / 255.0f, \
                        ((hex >> 8) & 0xFF) / 255.0f * (hex & 0xFF) / 255.0f, \
                        (hex & 0xFF) / 255.0f }

static const int sloppyfocus               = 1;
static const int bypass_surface_visibility = 0;
static const unsigned int borderpx         = 1;

static const int smartgaps                 = 0;
static int gaps                            = 1;
static const unsigned int gappx            = 8;
static const unsigned int snap             = 32;

static const float rootcolor[]             = COLOR(0x222222ff);
static const float bordercolor[]           = COLOR(0x80808060);
static const float focuscolor[]            = COLOR(0x808080d0);
static const float urgentcolor[]           = COLOR(0xd05050ff);

static const float fullscreen_bg[]         = {0.0f, 0.0f, 0.0f, 1.0f};

#define TAGCOUNT (9)

static int log_level = WLR_ERROR;

static const Rule rules[] = {
	{ "mshell.wall",      NULL,       0,            1,           -1 },
};

static const Layout layouts[] = {
	{ "[]=",      tile },
	{ "><>",      NULL },
	{ "[M]",      monocle },
};

static const MonitorRule monrules[] = {
	{ NULL,       0.55f, 1,      1,    &layouts[0], WL_OUTPUT_TRANSFORM_NORMAL,   -1,  -1 },
};

static const struct xkb_rule_names xkb_rules = {
	.layout = "us,ru",
	.options = "grp:alt_shift_toggle",
};

static const int repeat_rate = 25;
static const int repeat_delay = 600;

static const int tap_to_click = 0;
static const int tap_and_drag = 1;
static const int drag_lock = 1;
static const int natural_scrolling = 1;
static const int disable_while_typing = 1;
static const int left_handed = 0;
static const int middle_button_emulation = 0;

static const enum libinput_config_scroll_method scroll_method = LIBINPUT_CONFIG_SCROLL_2FG;

static const enum libinput_config_click_method click_method = LIBINPUT_CONFIG_CLICK_METHOD_CLICKFINGER;

static const uint32_t send_events_mode = LIBINPUT_CONFIG_SEND_EVENTS_ENABLED;

static const enum libinput_config_accel_profile accel_profile = LIBINPUT_CONFIG_ACCEL_PROFILE_ADAPTIVE;
static const double accel_speed = 0.0;

static const double scroll_factor = 0.1;

static const int mouse_natural_scrolling = 0;
static const enum libinput_config_accel_profile mouse_accel_profile = LIBINPUT_CONFIG_ACCEL_PROFILE_FLAT;
static const double mouse_accel_speed = 0.0;

static const char *const disabled_devices[] = {
	"Sony Interactive Entertainment DualSense Edge Wireless Controller Touchpad",
	"DualSense Edge Wireless Controller Touchpad",
};

static const enum libinput_config_tap_button_map button_map = LIBINPUT_CONFIG_TAP_MAP_LRM;

#define MODKEY WLR_MODIFIER_LOGO

#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                    KEY,            view,            {.ui = 1 << TAG} }, \
	{ MODKEY|WLR_MODIFIER_CTRL,  KEY,            toggleview,      {.ui = 1 << TAG} }, \
	{ MODKEY|WLR_MODIFIER_SHIFT, KEY,            tag,             {.ui = 1 << TAG} }, \
	{ MODKEY|WLR_MODIFIER_CTRL|WLR_MODIFIER_SHIFT,KEY,toggletag,  {.ui = 1 << TAG} }

#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

static const char *termcmd[] = { "ghostty", NULL };
static const char *menucmd[] = { "mshell", "dmenu", "toggle", NULL };

static const Key keys[] = {
	{ MODKEY,                    XKB_KEY_p,           spawn,            {.v = menucmd} },
	{ MODKEY|WLR_MODIFIER_SHIFT, XKB_KEY_Return,      spawn,            {.v = termcmd} },
	{ MODKEY,                    XKB_KEY_j,           focusstack,       {.i = +1} },
	{ MODKEY,                    XKB_KEY_k,           focusstack,       {.i = -1} },
	{ MODKEY,                    XKB_KEY_i,           incnmaster,       {.i = +1} },
	{ MODKEY,                    XKB_KEY_d,           incnmaster,       {.i = -1} },
	{ MODKEY,                    XKB_KEY_h,           setmfact,         {.f = -0.05f} },
	{ MODKEY,                    XKB_KEY_l,           setmfact,         {.f = +0.05f} },
	{ MODKEY,                    XKB_KEY_Return,      zoom,             {0} },
	{ MODKEY,                    XKB_KEY_Tab,         view,             {0} },
	{ MODKEY|WLR_MODIFIER_SHIFT, XKB_KEY_c,           killclient,       {0} },
	{ MODKEY,                    XKB_KEY_t,           setlayout,        {.v = &layouts[0]} },
	{ MODKEY,                    XKB_KEY_f,           setlayout,        {.v = &layouts[1]} },
	{ MODKEY,                    XKB_KEY_m,           setlayout,        {.v = &layouts[2]} },
	{ MODKEY,                    XKB_KEY_space,       setlayout,        {0} },
	{ MODKEY|WLR_MODIFIER_SHIFT, XKB_KEY_space,       togglefloating,   {0} },
	{ MODKEY,                    XKB_KEY_e,           togglefullscreen, {0} },
	{ MODKEY,                    XKB_KEY_0,           view,             {.ui = ~0} },
	{ MODKEY|WLR_MODIFIER_SHIFT, XKB_KEY_0,           tag,              {.ui = ~0} },
	{ MODKEY,                    XKB_KEY_comma,       focusmon,         {.i = WLR_DIRECTION_LEFT} },
	{ MODKEY,                    XKB_KEY_period,      focusmon,         {.i = WLR_DIRECTION_RIGHT} },
	{ MODKEY|WLR_MODIFIER_SHIFT, XKB_KEY_comma,       tagmon,           {.i = WLR_DIRECTION_LEFT} },
	{ MODKEY|WLR_MODIFIER_SHIFT, XKB_KEY_period,      tagmon,           {.i = WLR_DIRECTION_RIGHT} },
	TAGKEYS(                     XKB_KEY_1,           0),
	TAGKEYS(                     XKB_KEY_2,           1),
	TAGKEYS(                     XKB_KEY_3,           2),
	TAGKEYS(                     XKB_KEY_4,           3),
	TAGKEYS(                     XKB_KEY_5,           4),
	TAGKEYS(                     XKB_KEY_6,           5),
	TAGKEYS(                     XKB_KEY_7,           6),
	TAGKEYS(                     XKB_KEY_8,           7),
	TAGKEYS(                     XKB_KEY_9,           8),
	{ MODKEY|WLR_MODIFIER_SHIFT, XKB_KEY_q,           quit,             {0} },

	{ 0, XKB_KEY_XF86AudioMute,        spawn, SHCMD("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle") },
	{ 0, XKB_KEY_XF86AudioLowerVolume, spawn, SHCMD("wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-") },
	{ 0, XKB_KEY_XF86AudioRaiseVolume, spawn, SHCMD("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 1%+") },
	{ 0, XKB_KEY_XF86AudioMicMute,     spawn, SHCMD("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle") },

	{ 0, XKB_KEY_XF86AudioPlay,        spawn, SHCMD("playerctl play-pause") },
	{ 0, XKB_KEY_XF86AudioPause,       spawn, SHCMD("playerctl play-pause") },
	{ 0, XKB_KEY_XF86AudioPrev,        spawn, SHCMD("playerctl previous") },
	{ 0, XKB_KEY_XF86AudioNext,        spawn, SHCMD("playerctl next") },
	{ 0, XKB_KEY_XF86AudioStop,        spawn, SHCMD("playerctl stop") },

	{ 0, XKB_KEY_XF86MonBrightnessDown, spawn, SHCMD("brightnessctl set 1%-") },
	{ 0, XKB_KEY_XF86MonBrightnessUp,   spawn, SHCMD("brightnessctl set 1%+") },

	{ MODKEY, XKB_KEY_a, spawn, SHCMD("mshell panel toggle audio") },
	{ MODKEY, XKB_KEY_s, spawn, SHCMD("mshell panel toggle tray") },
	{ MODKEY, XKB_KEY_q, spawn, SHCMD("mshell panel toggle control") },
	{ MODKEY, XKB_KEY_bracketleft, spawn, SHCMD("mshell notifications dismissLast") },
	{ MODKEY,                    XKB_KEY_w, spawn, SHCMD("ghostty --class=mshell.wall -e mshell wall dark") },
	{ MODKEY|WLR_MODIFIER_SHIFT, XKB_KEY_w, spawn, SHCMD("ghostty --class=mshell.wall -e mshell wall light") },

	{ 0,                  XKB_KEY_Print, spawn, SHCMD("screenshot-full.sh") },
	{ WLR_MODIFIER_SHIFT, XKB_KEY_Print, spawn, SHCMD("screenshot-area.sh") },

	{ WLR_MODIFIER_CTRL|WLR_MODIFIER_ALT,XKB_KEY_BackSpace, quit, {0} },

#define CHVT(n) { WLR_MODIFIER_CTRL|WLR_MODIFIER_ALT,XKB_KEY_F##n, chvt, {.ui = (n)} }
	CHVT(1), CHVT(2), CHVT(3), CHVT(4), CHVT(5), CHVT(6),
	CHVT(7), CHVT(8), CHVT(9), CHVT(10), CHVT(11), CHVT(12),
};

static const Button buttons[] = {
	{ MODKEY, BTN_LEFT,   moveresize,     {.ui = CurMove} },
	{ MODKEY, BTN_MIDDLE, togglefloating, {0} },
	{ MODKEY, BTN_RIGHT,  moveresize,     {.ui = CurResize} },
};

static const Axis axes[] = {
	{ 0, 0, NULL, {0} },
};
