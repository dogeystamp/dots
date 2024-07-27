/* See LICENSE file for copyright and license details. */

#include <X11/XF86keysym.h>

/* constants */
#define TERMINAL "alacritty"

/* appearance */
static const unsigned int borderpx  = 2;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const unsigned int gappih    = 35;       /* horiz inner gap between windows */
static const unsigned int gappiv    = 40;       /* vert inner gap between windows */
static const unsigned int gappoh    = 30;       /* horiz outer gap between windows and screen edge */
static const unsigned int gappov    = 40;       /* vert outer gap between windows and screen edge */
static       int smartgaps          = 0;        /* 1 means no outer gap when there is only one window */
static       int passthrough        = 0;        /* 1 means to ignore most shortcuts */
static const int showbar            = 1;        /* 0 means no bar */
static const int barpadding         = 0;        /* 0 means no padding beneath/above bar */
static const int topbar             = 0;        /* 0 means bottom bar */
static const char *fonts[]          = { "JetBrains Mono:size=15" };
static const char dmenufont[]       = "JetBrains Mono:size=15";
static const char col_gray1[]       = "#000000";
static const char col_gray2[]       = "#202020";
static const char col_gray3[]       = "#505050";
static const char col_gray4[]       = "#99aabb";
static const char col_gray5[]       = "#eeeeee";
static const unsigned int baralpha = 0;
static const unsigned int borderalpha = OPAQUE;
static const char *colors[][3]      = {
	/*               fg         bg         border   */
	[SchemeNorm] = { col_gray4, col_gray1, col_gray3 },
	[SchemeSel]  = { col_gray5, col_gray3, col_gray4 },
	[SchemeHigh] = { col_gray5, col_gray1, col_gray5 },
};
static const unsigned int alphas[][3]      = {
	/*               fg      bg        border     */
	[SchemeNorm] = { OPAQUE, baralpha, borderalpha },
	[SchemeSel]  = { OPAQUE, baralpha, borderalpha },
	[SchemeHigh] = { OPAQUE,     0x55, borderalpha },
};

/* tagging */
static const char *tags[] = { " ", " ", " ", " ", " ", " ", " ", " ", " ", " " };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class              instance  title      tags mask  isfloating  monitor */
	{ "Alacritty",          NULL,    NULL,      0,         0,          -1, },
	{ "popup-bottom-center",NULL,    NULL,      0,         1,          -1, },
	{ "mpv",                NULL,    NULL,      0,         0,          -1, }, /* mpv */
};

/* window swallowing */
static const int swaldecay = 3;
static const int swalretroactive = 1;

/* layout(s) */
static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 0; /* 1 will force focus on the fullscreen window */

#define FORCE_VSPLIT 1  /* nrowgrid layout: force two clients to always split vertically */
#include "vanitygaps.c"

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "[M]",      monocle },
	{ "[@]",      spiral },
	{ "[\\]",     dwindle },
	{ "H[]",      deck },
	{ "TTT",      bstack },
	{ "===",      bstackhoriz },
	{ "HHH",      grid },
	{ "###",      nrowgrid },
	{ "---",      horizgrid },
	{ ":::",      gaplessgrid },
	{ "|M|",      centeredmaster },
	{ ">M>",      centeredfloatingmaster },
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ NULL,       NULL },
};

/* key definitions */
#define MODKEY Mod1Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }
/* open shell command in a terminal window */
#define TERMCMD(cmd) { .v = (const char*[]){ "/usr/bin/alacritty", "-e", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", col_gray1, "-nf", col_gray5, "-sb", col_gray3, "-sf", col_gray4, "-n", NULL };
static const char termcmd[]  = "alacritty msg create-window || alacritty";
static const char *freshtermcmd[]  = { "alacritty", NULL };
static const char *browsercmd[]  = { "qutebrowser", NULL };
static const char *pwdcmd[]  = { "keepassxc", NULL };
static const char *musiccmd[]  = { "sonixd", NULL };
static const char *upvol[]   = { "/usr/bin/pactl", "set-sink-volume", "0", "+5%",     NULL };
static const char *downvol[] = { "/usr/bin/pactl", "set-sink-volume", "0", "-5%",     NULL };
static const char *mutevol[] = { "/usr/bin/pactl", "set-sink-mute",   "0", "toggle",  NULL };
static const char *play[] = { "playerctl", "play-pause",  NULL };
static const char *next[] = { "playerctl", "next",  NULL };
static const char *prev[] = { "playerctl", "previous",  NULL };
static const char *stopcmd[] = { "mpc", "stop",  NULL };

static const Key keys[] = {
	/* modifier                     key        function        argument */
	{ Mod4Mask,                     XK_p,      togglepass,     {0} },
	{ MODKEY,                       XK_f,      togglealtbar,   {0} },
	{ MODKEY,                       XK_p,      spawn,          {.v = dmenucmd } },
	{ MODKEY|ShiftMask,             XK_Return, spawn,          SHCMD(termcmd) },
	{ MODKEY|ShiftMask|ControlMask, XK_Return, spawn,          {.v = freshtermcmd} },
	{ MODKEY|ShiftMask,             XK_b,      spawn,          {.v = browsercmd } },
	{ MODKEY|ShiftMask,             XK_k,      spawn,          {.v = pwdcmd } },
	{ MODKEY|ShiftMask,             XK_d,      spawn,          SHCMD("qbprof dsc") },
	{ MODKEY|ShiftMask,             XK_m,      spawn,          {.v = musiccmd } },
	{ MODKEY|ControlMask,           XK_l,      spawn,          {.v = (const char*[]){ "/usr/local/bin/slock", NULL} } },
	{ MODKEY|ShiftMask,             XK_s,      spawn,          SHCMD("~/.local/bin/deskutils/suspend.sh") },
	{ 0,                            XK_Print,  spawn,          SHCMD("~/.local/bin/deskutils/screenshot.sh") },
	{ ShiftMask,                    XK_Print,  spawn,          SHCMD("~/.local/bin/deskutils/screenshot-save.sh"  ) },
	{ MODKEY,                       XK_z,      spawn,          TERMCMD("bookmk") },
	// SHCMD because we already start a terminal from inside clipedit.sh
	{ MODKEY|ShiftMask,             XK_z,      spawn,          SHCMD("clipedit.sh") },
	{ 0,                     	    XF86XK_AudioStop, spawn, {.v = stopcmd } },
	{ 0,                     	    XF86XK_AudioNext, spawn, {.v = next } },
	{ 0,                     	    XF86XK_AudioPrev, spawn, {.v = prev   } },
	{ 0,                     	    XF86XK_AudioPlay, spawn, {.v = play   } },
    { 0,                     	    XF86XK_AudioLowerVolume, spawn, {.v = downvol } },
	{ 0,                     	    XF86XK_AudioMute, spawn, {.v = mutevol } },
	{ 0,                     	    XF86XK_AudioRaiseVolume, spawn, {.v = upvol   } },
	{ MODKEY,                       XK_b,      togglebar,      {0} },
	{ MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
	{ MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
	{ MODKEY,                       XK_d,      incnmaster,     {.i = -1 } },
	{ MODKEY,                       XK_h,      focusmon,       {.i = +1 } },
	{ MODKEY,                       XK_l,      focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_Return, zoom,           {0} },
	{ MODKEY|Mod4Mask,              XK_u,      incrgaps,       {.i = +1 } },
	{ MODKEY|Mod4Mask|ShiftMask,    XK_u,      incrgaps,       {.i = -1 } },
	{ MODKEY|Mod4Mask,              XK_i,      incrigaps,      {.i = +1 } },
	{ MODKEY|Mod4Mask|ShiftMask,    XK_i,      incrigaps,      {.i = -1 } },
	{ MODKEY|Mod4Mask,              XK_o,      incrogaps,      {.i = +1 } },
	{ MODKEY|Mod4Mask|ShiftMask,    XK_o,      incrogaps,      {.i = -1 } },
	{ MODKEY|Mod4Mask,              XK_6,      incrihgaps,     {.i = +1 } },
	{ MODKEY|Mod4Mask|ShiftMask,    XK_6,      incrihgaps,     {.i = -1 } },
	{ MODKEY|Mod4Mask,              XK_7,      incrivgaps,     {.i = +1 } },
	{ MODKEY|Mod4Mask|ShiftMask,    XK_7,      incrivgaps,     {.i = -1 } },
	{ MODKEY|Mod4Mask,              XK_8,      incrohgaps,     {.i = +1 } },
	{ MODKEY|Mod4Mask|ShiftMask,    XK_8,      incrohgaps,     {.i = -1 } },
	{ MODKEY|Mod4Mask,              XK_9,      incrovgaps,     {.i = +1 } },
	{ MODKEY|Mod4Mask|ShiftMask,    XK_9,      incrovgaps,     {.i = -1 } },
	{ MODKEY|Mod4Mask,              XK_0,      togglegaps,     {0} },
	{ MODKEY|Mod4Mask|ShiftMask,    XK_0,      defaultgaps,    {0} },
	{ MODKEY,                       XK_Tab,    view,           {0} },
	{ MODKEY|ShiftMask,             XK_c,      killclient,     {0} },
	{ MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
	{ MODKEY,                       XK_q,      setlayout,      {.v = &layouts[1]} },
	{ MODKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} },
	{ MODKEY,                       XK_space,  setlayout,      {0} },
	{ MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
	{ MODKEY,                       XK_comma,  setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_period, setmfact,       {.f = +0.05} },
	{ MODKEY|ShiftMask,             XK_h,      tagmon,         {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_l,      tagmon,         {.i = -1 } },
	{ MODKEY,                       XK_u,      swalstopsel,    {0} },
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	// odd keybinds here to bring tags closer to my fingers
	TAGKEYS(                        XK_e,                      4)
	TAGKEYS(                        XK_r,                      5)
	// backwards compatibility
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)

	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)
	TAGKEYS(                        XK_0,                      9)
	{ MODKEY|ShiftMask,             XK_q,      quit,           {0} },
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkClientWin,         MODKEY|ShiftMask, Button1,      swalmouse,      {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

