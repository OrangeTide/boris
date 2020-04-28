/**
 * @file channel.c
 *
 * Plugin that provides a Channel service.
 *
 * @author Jon Mayo <jon.mayo@gmail.com>
 * @date 2019 Dec 25
 *
 * Copyright (c) 2009-2019, Jon Mayo
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 * The views and conclusions contained in the software and documentation are
 * those of the authors and should not be interpreted as representing official
 * policies, either expressed or implied, of the Boris MUD project.
 */
#include "channel.h"
#include "boris.h"
#include "logging.h"

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
#define DEBUG(msg, ...) fprintf(stderr, "%s():%d:" msg "\n",  __func__, __LINE__, __VA_ARGS__)
#if 0
#define DEBUG(msg, ...) b_log(B_LOG_DEBUG, "channel", "%s():%d:" msg, __func__, __LINE__, __VA_ARGS__)
#endif

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
static void channel_init(struct channel *ch)
{
	ch->nr_member = 0;
	ch->member = NULL;
}

/**
 * test for membership in a channel.
 */
static struct channel_member **channel_find_member(struct channel *ch, struct channel_member *cm)
{
	unsigned i;

	DEBUG("looking for channel member %p(p=%p)", (void*)cm, cm ? cm->p : NULL);

	if (!ch) return NULL;

	for (i = 0; i < ch->nr_member; i++) {
		DEBUG("looking at %p...", (void*)ch->member[i]);

		if (ch->member[i] == cm) return &ch->member[i];

	}

	DEBUG("not found %p(p=%p)", (void*)cm, cm ? cm->p : NULL);
	return NULL;
}

/**
 * add member to a channel.
 */
static int channel_add_member(struct channel *ch, struct channel_member *cm)
{
	struct channel_member **newlist;

	assert(ch != NULL);
	assert(cm != NULL);

	if (!cm) return 1; /* ignore NULL. */

	if (channel_find_member(ch, cm)) return 0; /* already a member */

	newlist = realloc(ch->member, sizeof * ch->member * (ch->nr_member + 1));

	if (!newlist) {
		b_log(B_LOG_ERROR, "channel", "could not add member to channel.");
		return 0; /* could not allocate. */
	}

	ch->member = newlist;
	ch->member[ch->nr_member++] = cm;
	return 1; /* success */
}

/**
 * remove a member from a channel.
 */
static int channel_delete_member(struct channel *ch, struct channel_member *cm)
{
	struct channel_member **d;

	assert(ch != NULL);
	assert(cm != NULL);

	if (!ch) return 0;

	d = channel_find_member(ch, cm);

	if (!d) return 0; /* not a member */

	DEBUG("found channel member %p at %p", (void*)cm, (void*)d);

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

static struct channel_public *channel_public_find(const char *name)
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
static int channel_public_add(const char *name)
{
	struct channel_public *newch;

	if (channel_public_find(name)) {
		return 0; /* refuse to create duplicate channel. */
	}

	newch = calloc(1, sizeof * newch);

	if (!newch) {
		perror("calloc()");
		b_log(B_LOG_ERROR, "channel", "could not allocate channel.");
		return 0; /* failure. */
	}

	if (name) {
		newch->name = strdup(name);

		if (!newch->name) {
			perror("strdup()");
			b_log(B_LOG_ERROR, "channel", "could not allocate channel.");
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
 * get a channel by numeric id.
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
int channel_initialize(void)
{
	b_log(B_LOG_INFO, "channel", "channel sub-system loaded (" __FILE__ " compiled " __TIME__ " " __DATE__ ")");
	channel_public_add("Wiz");
	channel_public_add("OOC");
	channel_public_add(NULL); /* system channel. */
	return 0;
}

/**
 * Shutdown the sub-system.
 */
void channel_shutdown(void)
{
	b_log(B_LOG_INFO, "channel", "channel sub-system shutting down...");
	b_log(B_LOG_INFO, "channel", "channel sub-system ended.");
}

/**
 * join a channel.
 */
int channel_join(struct channel *ch, struct channel_member *cm)
{
	b_log(B_LOG_TRACE, "channel", "someone(%p) joined\n", cm ? cm->p : NULL);
	return channel_add_member(ch, cm);
}

/**
 * leave a channel.
 */
void channel_part(struct channel *ch, struct channel_member *cm)
{
	b_log(B_LOG_TRACE, "channel", "someone(%p) parted\n", cm ? cm->p : NULL);

	if (!channel_delete_member(ch, cm)) {
		b_log(B_LOG_WARN, "channel", "could not find channel member %p", cm);
	}
}

/**
 * exclude_list can only be NULL if exclude_list_len is 0.
 */
static int is_on_list(const struct channel_member *cm, struct channel_member **exclude_list, unsigned exclude_list_len)
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
int channel_broadcast(struct channel *ch, struct channel_member **exclude_list, unsigned exclude_list_len, const char *fmt, ...)
{
	va_list ap;
	unsigned i;
	char buf[CHANNEL_SEND_MAX];

	va_start(ap, fmt);
	vsnprintf(buf, sizeof buf, fmt, ap);
	va_end(ap);

	for (i = 0; i < ch->nr_member; i++) {
		struct channel_member *cm = ch->member[i];
		DEBUG("cm=%p p=%p\n", (void*)cm, cm ? cm->p : NULL);

		if (cm && cm->send && !is_on_list(cm, exclude_list, exclude_list_len)) {
			cm->send(cm, ch, buf);
		}
	}

	return 0; /* failure */
}
