/**
 * @file channel.c
 *
 * Channel service.
 *
 * @author Jon Mayo <jon@rm-f.net>
 * @version 0.7
 * @date 2022 Aug 27
 *
 * Copyright (c) 2009-2022, Jon Mayo <jon@rm-f.net>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

#include "channel.h"
#include "boris.h"

#define LOG_SUBSYSTEM "channel"
#include <log.h>

#include <assert.h>
#include <stdarg.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/******************************************************************************
 * Defines
 ******************************************************************************/
#define CHANNEL_SEND_MAX 1024

/******************************************************************************
 * Types
 ******************************************************************************/

struct channel {
	/* array of members */
	unsigned nr_member;
	struct channel_member **member;
};

struct channel_public {
	struct channel channel;
	LIST_ENTRY(struct channel_public) list;
	char *name;
};

LIST_HEAD(struct channel_public_list, struct channel_public);

/******************************************************************************
 * Globals
 ******************************************************************************/

static struct channel_public_list channel_public_list;

/******************************************************************************
 * Functions
 ******************************************************************************/
static void
channel_init(struct channel *ch)
{
	ch->nr_member = 0;
	ch->member = NULL;
}

/**
 * test for membership in a channel.
 */
static struct channel_member **
channel_find_member(struct channel *ch, struct channel_member *cm)
{
	unsigned i;

	LOG_DEBUG("looking for channel member %p(p=%p)", (void*)cm, cm ? cm->p : NULL);

	if (!ch) return NULL;

	for (i = 0; i < ch->nr_member; i++) {
		LOG_DEBUG("looking at %p...", (void*)ch->member[i]);

		if (ch->member[i] == cm) return &ch->member[i];

	}

	LOG_DEBUG("not found %p(p=%p)", (void*)cm, cm ? cm->p : NULL);
	return NULL;
}

/**
 * add member to a channel.
 */
static int
channel_add_member(struct channel *ch, struct channel_member *cm)
{
	struct channel_member **newlist;

	assert(ch != NULL);
	assert(cm != NULL);

	if (!cm) return 1; /* ignore NULL. */

	if (channel_find_member(ch, cm)) return 0; /* already a member */

	newlist = realloc(ch->member, sizeof * ch->member * (ch->nr_member + 1));

	if (!newlist) {
		LOG_ERROR("could not add member to channel.");
		return 0; /* could not allocate. */
	}

	ch->member = newlist;
	ch->member[ch->nr_member++] = cm;
	return 1; /* success */
}

/**
 * remove a member from a channel.
 */
static int
channel_delete_member(struct channel *ch, struct channel_member *cm)
{
	struct channel_member **d;

	assert(ch != NULL);
	assert(cm != NULL);

	if (!ch) return 0;

	d = channel_find_member(ch, cm);

	if (!d) return 0; /* not a member */

	LOG_DEBUG("found channel member %p at %p", (void*)cm, (void*)d);

	assert(ch->nr_member > 0);

	/* copy last member to old position */
	*d = NULL;
	*d = ch->member[--ch->nr_member];

	/* if there are no members then free all data. */
	if (!ch->nr_member) {
		free(ch->member);
		ch->member = NULL;
	}

	return 1; /* success */
}

static struct channel_public *
channel_public_find(const char *name)
{
	struct channel_public *curr;

	for (curr = LIST_TOP(channel_public_list); curr; curr = LIST_NEXT(curr, list)) {
		/* if name is NULL, then only match system channel. (which is also NULL)
		 * else if name is not-NULL then string compare for channel name.
		 */
		if ((name && !strcasecmp(name, curr->name)) || (!name && !curr->name)) {
			return curr;
		}
	}

	return NULL; /* not found. */
}

/**
 * define a new public channel.
 */
static int
channel_public_add(const char *name)
{
	struct channel_public *newch;

	if (!name) {
		return 0; /* failure : refuse to create channel NULL */
	}

	if (channel_public_find(name)) {
		return 0; /* refuse to create duplicate channel. */
	}

	newch = calloc(1, sizeof * newch);

	if (!newch) {
		perror("calloc()");
		LOG_ERROR("could not allocate channel.");
		return 0; /* failure. */
	}

	if (name) {
		newch->name = strdup(name);

		if (!newch->name) {
			perror("strdup()");
			LOG_ERROR("could not allocate channel.");
			free(newch);
			return 0; /* failure. */
		}
	} else {
		newch->name = NULL;
	}

	channel_init(&newch->channel);
	LIST_INSERT_HEAD(&channel_public_list, newch, list);

	return 1; /* success */
}

/**
 * get a channel by name.
 */
struct channel *channel_public(const char *name)
{
	struct channel_public *cp;
	cp = channel_public_find(name);

	if (cp) {
		return &cp->channel;
	}

	return NULL; /* failure */
}

/**
 * Initialize the sub-system.
 */
int
channel_initialize(void)
{
	LOG_INFO("channel sub-system loaded (" __FILE__ " compiled " __TIME__ " " __DATE__ ")");
	channel_public_add(CHANNEL_WIZ); /* Wizards */
	channel_public_add(CHANNEL_OOC); /* Out-of-Character chat */
	channel_public_add(CHANNEL_SYS); /* system channel. */
	return 0;
}

/**
 * Shutdown the sub-system.
 */
void
channel_shutdown(void)
{
	LOG_INFO("channel sub-system shutting down...");
	LOG_INFO("channel sub-system ended.");
}

/**
 * join a channel.
 */
int
channel_join(struct channel *ch, struct channel_member *cm)
{
	LOG_TRACE("someone(%p) joined\n", cm ? cm->p : NULL);
	return channel_add_member(ch, cm);
}

/**
 * leave a channel.
 */
void
channel_part(struct channel *ch, struct channel_member *cm)
{
	LOG_TRACE("someone(%p) parted\n", cm ? cm->p : NULL);

	if (!channel_delete_member(ch, cm)) {
		LOG_WARNING("could not find channel member %p", cm);
	}
}

/**
 * exclude_list can only be NULL if exclude_list_len is 0.
 */
static int
is_on_list(const struct channel_member *cm, struct channel_member **exclude_list, unsigned exclude_list_len)
{
	unsigned i;

	for (i = 0; i < exclude_list_len; i++) {
		if (cm == exclude_list[i]) return 1;
	}

	return 0;
}

/**
 * send a message to everyone except those on exclude_list.
 */
int
channel_broadcast(struct channel *ch, struct channel_member **exclude_list, unsigned exclude_list_len, const char *fmt, ...)
{
	va_list ap;
	unsigned i;
	char buf[CHANNEL_SEND_MAX];

	va_start(ap, fmt);
	vsnprintf(buf, sizeof buf, fmt, ap);
	va_end(ap);

	for (i = 0; i < ch->nr_member; i++) {
		struct channel_member *cm = ch->member[i];
		LOG_DEBUG("cm=%p p=%p\n", (void*)cm, cm ? cm->p : NULL);

		if (cm && cm->send && !is_on_list(cm, exclude_list, exclude_list_len)) {
			cm->send(cm, ch, buf);
		}
	}

	return 0; /* failure */
}
