#include "theme.h"
/* user and group to drop privileges to */
static const char *user  = "nobody";
static const char *group = "nobody";

static const char *colorname[NUMCOLS] = {
	"black",     /* after initialization */
	th_colac1,   /* during input */
	th_colac3,   /* wrong password */
};

/* treat a cleared input like a wrong password */
static const int failonclear = 1;
