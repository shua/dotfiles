/* See LICENSE file for copyright and license details. */

/* appearance */
#include "theme.h"

static const char *fonts[] = { th_font, "monospace:size=10" };
#define dmenufont  th_font
#define normbordercolor th_colbg2
#define normbgcolor th_colbg1
#define normfgcolor th_colfg1
#define selbordercolor th_colac1
#define selbgcolor th_colac1
#define selfgcolor th_colbg2 // originally #eeeeee
static const unsigned int borderpx  = 1;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const unsigned int systraypinning = 0;   /* 0: sloppy systray follows selected monitor, >0: pin systray to monitor X */
static const unsigned int systrayspacing = 2;   /* systray spacing */
static const int systraypinningfailfirst = 1;   /* 1: if pinning fails, display systray on the first monitor, 0: display systray on the last monitor*/
static const int showsystray       = 1;     /* 0 means no systray */
static const int showbar           = 1;     /* 0 means no bar */
static const int topbar            = 1;     /* 0 means bottom bar */

/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

static const Rule rules[] = {
	/* class      instance    title       tags mask     isfloating   monitor */
	{ "Gimp",     NULL,       NULL,       1 << 3,       0,       -1 },
	{ "Firefox",  NULL,       NULL,       1 << 1,       0,       -1 },
	{ "Chromium", NULL,       NULL,       1 << 1,       0,       -1 },
	{ "Chromium", NULL,       "crx_nckgahadagoaajjgafhacjanaoiihapd", 
	                                      1 << 1,       1,       -1 },
	{ "google-chrome-beta", NULL, NULL,   1 << 1,       0,       -1 },
	{ "Surf",     NULL,       NULL,       1 << 1,       0,       -1 },
	{ "tabbed",   "surf",     NULL,       1 << 1,       0,       -1 },
	{ "Pidgin",   NULL,       NULL,       1 << 7,       0,       -1 },
	{ "spotify",  NULL,       NULL,       1 << 8,       0,       -1 },
	{ "Spotify",  NULL,       NULL,       1 << 8,       0,       -1 },
    { "Spotify",  "Spotify",  NULL,       1 << 8,       0,       -1 },
    { "Spotify",  "Spotify",  "Spotify",  1 << 8,       0,       -1 },
	{ "st",       "download", NULL,            0,       1,       -1 },
};

/* layout(s) */
static const float mfact      = 0.65; /* factor of master area size [0.05..0.95] */
static const int nmaster      = 1;    /* number of clients in master area */
static const int resizehints = 0; /* 1 means respect size hints in tiled resizals */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "│├┤",      tile },    /* first entry is default */
	{ "┊o┊",      NULL },    /* no layout function means floating behavior */
	{ "│╳│",      monocle },
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", normbgcolor, "-nf", normfgcolor, "-sb", selbgcolor, "-sf", selfgcolor, NULL };
static const char *termcmd[]  = { "st", NULL };
static const char *slockcmd[] = { "slock", NULL};
static const char *mutecmd[]  = { "amixer", "-q", "sset", "Master", "toggle", NULL };
static const char *volupcmd[] = { "amixer", "-q", "sset", "Master", "5+", NULL };
static const char *voldncmd[] = { "amixer", "-q", "sset", "Master", "5-", NULL };
static const char *bklticmd[] = { "light", "-A", "5", NULL };
static const char *bkltdcmd[] = { "light", "-U", "5", NULL };
static const char *kbdcmd[]   = { "kbd", NULL };

static Key keys[] = {
	/* modifier                     key        function        argument */
	{ 0,                            0x1008ff02, spawn,         {.v = bklticmd } },
	{ 0,                            0x1008ff03, spawn,         {.v = bkltdcmd } },
	{ 0,                            0x1008ff12, spawn,         {.v = mutecmd } },
	{ 0,                            0x1008ff11, spawn,         {.v = voldncmd } },
	{ 0,                            0x1008ff13, spawn,         {.v = volupcmd } },
	{ MODKEY,                       XK_p,      spawn,          {.v = dmenucmd } },
	{ MODKEY|ShiftMask,             XK_Return, spawn,          {.v = termcmd } },
	{ MODKEY,                       XK_b,      togglebar,      {0} },
	{ MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
	{ MODKEY,                       XK_equal,  setmfact,       {.f = +0.05} },
	{ MODKEY,                       XK_minus,  setmfact,       {.f = -0.05} },
	{ MODKEY|ShiftMask,             XK_equal,  incnmaster,     {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_minus,  incnmaster,     {.i = -1 } },
	{ MODKEY,                       XK_Return, zoom,           {0} },
	{ MODKEY|ShiftMask,             XK_c,      killclient,     {0} },
	{ MODKEY|ShiftMask,             XK_t,      setlayout,      {.v = &layouts[0]} },
	{ MODKEY|ShiftMask,             XK_f,      setlayout,      {.v = &layouts[1]} },
	{ MODKEY|ShiftMask,             XK_m,      setlayout,      {.v = &layouts[2]} },
	{ MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
	{ MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)
	{ MODKEY,                       XK_Right,  shiftview,      { .i = +1 } },
	{ MODKEY,                       XK_Left,   shiftview,      { .i = -1 } },
	{ MODKEY|ShiftMask,             XK_q,      quit,           {0} },
	{ MODKEY,                       XK_semicolon, spawn,       {.v = slockcmd } },
	{ MODKEY,                       XK_space,  spawn,          {.v = kbdcmd } },
/*	{ MODKEY,                       XK_Tab,    view,           {0} }, */
/*	{ MODKEY,                       XK_space,  setlayout,      {0} }, */
};

/* button definitions */
/* click can be ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

