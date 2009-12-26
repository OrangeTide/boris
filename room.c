/**
 * @file room.c
 *
 * basic room support.
 *
 */
#include <assert.h>
#include <stdarg.h>
#include <stdio.h>
#include <string.h>

#include "boris.h"
#include "list.h"
#include "plugin.h"

#define LOGBASIC_LENGTH_MAX 1024

/******************************************************************************
 * Types
 ******************************************************************************/

struct room {
	int id;
	LIST_ENTRY(struct room) room_cache; /**< currently loaded rooms. */
};

struct plugin_room_class {
	struct plugin_basic_class base_class;
	struct plugin_room_interface room_interface;
};

LIST_HEAD(struct room_cache, struct room);

/******************************************************************************
 * Prototypes
 ******************************************************************************/
extern const struct plugin_room_class plugin_class;

/******************************************************************************
 * Globals
 ******************************************************************************/

/** list of all loaded rooms. */
static struct room_cache room_cache;

/******************************************************************************
 * Functions
 ******************************************************************************/

static void initialize(void) {
	b_log(B_LOG_INFO, "room", "Room system loaded (" __FILE__ " compiled " __TIME__ " " __DATE__ ")");
	LIST_INIT(&room_cache);
}

static int shutdown(void) {
	/* TODO: save all dirty objects and free all data. */
	return 0; /* refuse to unload */
}

static struct room *get_room(int room_id) {
	return NULL; /* failure. */
}

static void put_room(struct room *r) {
}

const struct plugin_room_class plugin_class = {
	.base_class = { PLUGIN_API, "room", initialize, shutdown },
	.room_interface = { get_room, put_room }
};
