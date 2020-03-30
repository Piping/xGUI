/* See LICENSE file for copyright and license details. */
/* appearance */
static const unsigned int borderpx    = 2;        /* border pixel of windows */
static const unsigned int snap        = 32;       /* snap pixel */
static const unsigned int gappx       = 5;        /* pixel gap between clients */
static const int showbar              = 1;        /* 0 means no bar */
static const int topbar               = 1;        /* 0 means bottom bar */
static const int horizpadbar          = 6;        /* horizontal padding for statusbar */
static const int vertpadbar           = 7;        /* vertical padding for statusbar */
static const char *fonts[]            = {"InconsolataGo Nerd Font Mono Regular:size=9", 
										 "Mononoki Nerd Font:size=9:antialias=true:autohint=true", 
										 "Noto Sans Mono:size=9:antialias=true:autohint=true", 
										 "Monospace:size=9:antialias=true:autohint=true"
										};
static const char col_gray1[]         = "#282a36";
static const char col_gray2[]         = "#282a36"; /* border color unfocused windows */
static const char col_gray3[]         = "#96b5b4";
static const char col_gray4[]         = "#d7d7d7";
static const char col_cyan[]          = "#924741"; /* border color focused windows and tags */
/* bar opacity 
 * 0xff is no transparency.
 * 0xee adds wee bit of transparency.
 * Play with the value to get desired transparency.
 */
static const unsigned int baralpha    = 0xff; 
static const unsigned int borderalpha = OPAQUE;
static const char *colors[][3]        = {
	/*               fg         bg         border   */
	[SchemeNorm] = { col_gray4, col_gray1, col_gray2 },
	[SchemeSel]  = { col_gray4, col_cyan,  col_cyan  },
};
static const unsigned int alphas[][3] = {
	/*               fg      bg        border     */
	[SchemeNorm] = { OPAQUE, baralpha, borderalpha },
	[SchemeSel]  = { OPAQUE, baralpha, borderalpha },
};

/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

static const Rule rules[] = {
	/* Run xprop in terminal and use mouse to select window to find out infomation
     * xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 * class           instance    title       tags mask   isfloating   monitor */
	{ "Gnome-terminal", NULL,       NULL,       0 << 0,       0,           -1 },
};

/* layout(s) */
static const float mfact     = 0.50; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 0;    /* 1 means respect size hints in tiled resizals */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[List]",  tile },    /* first entry is default */
	/* { "[Max]",   monocle }, */
	/* { "[float]",  NULL }, */
	{ NULL,      NULL },
};

static const char *termcmd[]  = { "/usr/bin/gnome-terminal", NULL };
static const char *browser[]  = { "/usr/bin/firefox", NULL };

/* key definitions */
#define MODKEY Mod1Mask
static Key keys[] = {
	/* modifier             key        function        argument */
	{ MODKEY,               XK_q,      killclient,     {0} },
	{ MODKEY|ShiftMask,     XK_r,      quit,           {1} }, 
	{ MODKEY,               XK_b,      togglebar,      {0} },
	{ MODKEY,               XK_Return, spawn,          {.v = termcmd} },
	{ MODKEY|ShiftMask,     XK_Return, spawn,          {.v = browser} },
	/* Switch to specific layouts */
	/* { MODKEY,               XK_t,      setlayout,      {.v = &layouts[0]} }, */
	/* { MODKEY,               XK_m,      setlayout,      {0} }, /1* switch between layouts *1/ */
	/* Window List manipulation */
	{ MODKEY,               XK_i,      incnmaster,     {.i = +1 } },
	{ MODKEY,               XK_d,      incnmaster,     {.i = -1 } },
	{ MODKEY,               XK_h,      setmfact,       {.f = -0.05} },
	{ MODKEY,               XK_l,      setmfact,       {.f = +0.05} },
	{ MODKEY|ShiftMask,     XK_j,      pushdown,       {0} },
	{ MODKEY|ShiftMask,     XK_k,      pushup,         {0} },
	{ MODKEY,               XK_j,      focusstack,     {.i = +1 } },
	{ MODKEY,               XK_k,      focusstack,     {.i = -1 } },
	{ MODKEY,               XK_a,      lastview,       {0} },
	{ MODKEY,               XK_Tab,    lastview,       {0} },
	{ MODKEY,               XK_w,      untag_self,     {0} },
	{ MODKEY,               XK_z,      zoom,           {0} }, /* make the window master tile */
	{ MODKEY,               XK_f,      togglefloating, {0} },
	/* Switching between monitors */
	{ MODKEY,               XK_comma,  focusmon,       {.i = -1 } },
	{ MODKEY,               XK_period, focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,     XK_comma,  tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,     XK_period, tagmon,         {.i = +1 } },
    /* Tag : each windows can have up to 32 tags
     * dwm is a list of window clients, each can have more than one tag.
     * We can view them by select one or more tags
     * Super add tag to focused window
     * Alt to view different tags*/
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,              KEY,      view,            {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,    KEY,      toggleview,      {.ui = 1 << TAG} }, \
	{ Mod4Mask,            KEY,      toggletag_view,  {.ui = 1 << TAG} }, \
	{ Mod4Mask|ShiftMask,  KEY,      tag,             {.ui = 1 << TAG} } 
	TAGKEYS(XK_1, 0),
	TAGKEYS(XK_2, 1),
	TAGKEYS(XK_3, 2),
	TAGKEYS(XK_4, 3),
	TAGKEYS(XK_5, 4),
	TAGKEYS(XK_6, 5),
	TAGKEYS(XK_7, 6),
	TAGKEYS(XK_8, 7),
	TAGKEYS(XK_9, 8),
	{ MODKEY,              XK_0,     view,            {.ui = ~0 } },
	{ Mod4Mask,            XK_0,     tag,             {.ui = ~0 } },
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
	/* click           event mask   button          function        argument */
	{ ClkLtSymbol,     0,           Button1,        zoom,           {0} },
	{ ClkWinTitle,     0,           Button2,        zoom,           {0} },
	{ ClkStatusText,   0,           Button2,        view,           {0} },
	{ ClkClientWin,    MODKEY,      Button1,        movemouse,      {0} },
	{ ClkClientWin,    MODKEY,      Button3,        resizemouse,    {0} },
	{ ClkClientWin,    MODKEY,      Button2,        togglefloating, {0} },
	{ ClkTagBar,       0,           Button1,        view,           {0} },
	{ ClkTagBar,       0,           Button3,        toggleview,     {0} },
	{ ClkTagBar,       0,           Button2,        toggletag,      {0} },
	{ ClkTagBar,       MODKEY,      Button1,        tag,            {0} },
};



