/* See LICENSE file for copyright and license details. */
/* Default settings; can be overrided by command line. */

#include "theme.h"

static Bool topbar = True;                  /* -b  option; if False, dmenu appears at bottom */
/* -fn option overrides fonts[0]; default X11 font or font set */
static const char *fonts[] = {
	th_font,
	"monospace:size=10"
};
static const char *prompt = NULL;           /* -p  option; prompt to the elft of input field */
static const char *normbgcolor = th_colbg1; /* -nb option; normal background                 */
static const char *normfgcolor = th_colfg1; /* -nf option; normal foreground                 */
static const char *selbgcolor  = th_colac1; /* -sb option; selected background               */
static const char *selfgcolor  = th_colbg2; /* -sf option; selected foreground               */
static const char *outbgcolor  = "#00ffff";
static const char *outfgcolor  = "#000000";
/* -l option; if nonzero, dmenu uses vertical list with given number of lines */
static unsigned int lines = 0;

