/**
 * @file example.c
 *
 * A example of a plugin that does nothing. It can be used as a template for
 * new plugins. You may remove the notices and replace them with your own.
 *
 * @author Your Name <your@email>
 * @date 2009 Dec 27
 *
 * Written in 2009 by Jon Mayo <jon.mayo@gmail.com>
 *
 * To the extent possible under law, the author(s) have dedicated all copyright
 * and related and neighboring rights to this software to the public domain
 * worldwide.  This software is distributed without any warranty.
 *
 * You should have received a copy of the CC0 Public Domain Dedication along with
 * this software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.
 */
#include <stdlib.h>
#include "boris.h"

/******************************************************************************
 * Types
 ******************************************************************************/

struct plugin_example_class {
	struct plugin_basic_class base_class;
};

/******************************************************************************
 * Prototypes
 ******************************************************************************/
extern const struct plugin_example_class plugin_class;

/******************************************************************************
 * Functions
 ******************************************************************************/
static int initialize(void)
{
	b_log(B_LOG_INFO, "example", "Example plugin loaded (" __FILE__ " compiled " __TIME__ " " __DATE__ ")");
	return 1;
}

static int shutdown(void)
{
	b_log(B_LOG_INFO, "example", "Example plugin shutting down...");
	b_log(B_LOG_INFO, "example", "Example plugin ended.");
	return 1;
}


/******************************************************************************
 * Class
 ******************************************************************************/

const struct plugin_example_class plugin_class = {
	.base_class = { PLUGIN_API, "example", initialize, shutdown },
};
