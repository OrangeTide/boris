/**
 * @file example.c
 *
 * A example of a plugin that does nothing. It can be used as a template for
 * new plugins.
 *
 * @author Your Name <your@email>
 * @date 2009 Dec 27
 *
 * This file is PUBLIC DOMAIN. No copyright is claimed.
 *
 * NOTICE:
 * Because this is a template to be reused by others, it is PUBLIC DOMAIN.
 * Modified versions of this file may be copyrighted, and as such this notice
 * should be removed.
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
static int initialize(void) {
	b_log(B_LOG_INFO, "example", "Example plugin loaded (" __FILE__ " compiled " __TIME__ " " __DATE__ ")");
	return 1;
}

static int shutdown(void) {
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
