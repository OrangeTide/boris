/**
 * @file user.c
 *
 * Access user accounts.
 *
 * @author Jon Mayo <jon@rm-f.net>
 * @version 0.7
 * @date 2022 Aug 27
 *
 * Copyright (c) 2008-2022, Jon Mayo <jon@rm-f.net>
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

#include "user.h"
#include <stdlib.h>
#include <ctype.h>
#include <mud.h>
#include <boris.h>
#define LOG_SUBSYSTEM "user"
#include <log.h>
#include <debug.h>
#include <list.h>
#include <sha1crypt.h>
#include <acs.h>
#include <freelist.h>
#include <fdb.h>
#include <user.h>

/** default level for new users. */
#define USER_LEVEL_NEWUSER mud_config.newuser_level

/** default flags for new users. */
#define USER_FLAGS_NEWUSER mud_config.newuser_flags
/******************************************************************************
 * Data Types
 ******************************************************************************/

/** datastructure that describes a user record. */
struct user {
	unsigned id;
	char *username;
	char *password_crypt;
	char *email;
	struct acs_info acs;
	REFCOUNT_TYPE REFCOUNT_NAME;
	struct attr_list extra_values; /**< load an other values here. */
};

struct userdb_entry {
	struct user *u;
	LIST_ENTRY(struct userdb_entry) list;
};

/******************************************************************************
 * Globals
 ******************************************************************************/

/** list of all users. */
static LIST_HEAD(struct, struct userdb_entry) user_list;

/** pool of available user ids. */
static struct freelist *user_id_freelist;

/******************************************************************************
 * Prototypes
 ******************************************************************************/

int user_illegal(const char *username);
int user_exists(const char *username);

/******************************************************************************
 * Functions - internal
 ******************************************************************************/

/**
 * only free the structure data.
 */
static void
user_ll_free(struct user *u)
{
	if (!u) return;

	attr_list_free(&u->extra_values);
	LIST_INIT(&u->extra_values);
	free(u->username);
	u->username = 0;
	free(u->password_crypt);
	u->password_crypt = 0;
	free(u->email);
	u->email = 0;
	free(u);
}

/** free a user structure. */
static void
user_free(struct user *u)
{
	if (!u) return;

	user_ll_free(u);
}

/**
 * allocate a default struct.
 */
static struct user *
user_defaults(void)
{
	struct user *u;
	u = calloc(1, sizeof * u);

	if (!u) {
		LOG_PERROR("malloc()");
		return NULL;
	}

	u->id = 0;
	REFCOUNT_INIT(u);
	u->username = NULL;
	u->password_crypt = NULL;
	u->email = NULL;
	u->acs.level = USER_LEVEL_NEWUSER;
	u->acs.flags = USER_FLAGS_NEWUSER;
	LIST_INIT(&u->extra_values);
	return u;
}

/**
 * insert a user into user_list, but only if it is not already on the list.
 */
static int
user_ll_add(struct user *u)
{
	struct userdb_entry *ent;
	assert(u != NULL);
	assert(u->username != NULL);

	if (!u) return 0; /**< failure. */

	if (user_exists(u->username)) {
		return 0; /**< failure. */
	}

	ent = calloc(1, sizeof * ent);

	if (!ent)
		return 0; /**< failure. */

	ent->u = u;
	LIST_INSERT_HEAD(&user_list, ent, list);
	return 1; /**< success. */
}

/** load a user by username. */
static struct user *
user_load_byname(const char *username)
{
	struct user *u;
	struct fdb_read_handle *h;
	const char *name, *value;

	h = fdb_read_begin("users", username);

	if (!h) {
		LOG_ERROR("Could not find user \"%s\"", username);
		return 0; /* failure. */
	}

	u = user_defaults(); /* allocate a default struct */

	if (!u) {
		LOG_ERROR("Could not allocate user structure");
		fdb_read_end(h);
		return 0; /* failure */
	}

	while (fdb_read_next(h, &name, &value)) {
		if (!strcasecmp("id", name))
			parse_uint(name, value, &u->id);
		else if (!strcasecmp("username", name))
			parse_str(name, value, &u->username);
		else if (!strcasecmp("pwcrypt", name))
			parse_str(name, value, &u->password_crypt);
		else if (!strcasecmp("email", name))
			parse_str(name, value, &u->email);
		else if (!strcasecmp("acs.level", name))
			sscanf(value, "%hhu", &u->acs.level); /* TODO: add error checking. */
		else if (!strcasecmp("acs.flags", name))
			parse_uint(name, value, &u->acs.flags);
		else
			parse_attr(name, value, &u->extra_values);
	}

	if (!fdb_read_end(h)) {
		LOG_ERROR("Error loading user \"%s\"", username);
		goto failure;
	}

	if (u->id <= 0) {
		LOG_ERROR("User id for user '%s' was not set or set to zero.", username);
		goto failure;
	}

	if (!u->username || strcasecmp(username, u->username)) {
		LOG_ERROR("User name field for user '%s' was not set or does not math.", username);
		goto failure;
	}

	/** @todo check all fields of u to verify they are correct. */

	if (!freelist_thwack(user_id_freelist, u->id, 1)) {
		LOG_ERROR("Could not use user id %d (bad id or id already used?)", u->id);
		goto failure;
	}

	LOG_DEBUG("Loaded user '%s'", username);

	return u; /* success */

failure:
	user_ll_free(u);
	return 0; /* failure */
}

/** write a user file. */
static int
user_write(const struct user *u)
{
	struct fdb_write_handle *h;
	struct attr_entry *curr;

	assert(u != NULL);
	assert(u->username != NULL);

	h = fdb_write_begin("users", u->username);

	if (!h) {
		LOG_ERROR("Could not write user \"%s\"", u->username);
		return 0;
	}

	fdb_write_format(h, "id", "%u", u->id);
	fdb_write_pair(h, "username", u->username);
	fdb_write_pair(h, "pwcrypt", u->password_crypt);
	fdb_write_pair(h, "email", u->email);
	fdb_write_format(h, "acs.level", "%u", u->acs.level);
	fdb_write_format(h, "acs.flags", "0x%08x", u->acs.flags);

	for (curr = LIST_TOP(u->extra_values); curr; curr = LIST_NEXT(curr, list)) {
		fdb_write_pair(h, curr->name, curr->value);
	}

	if (!fdb_write_end(h)) {
		LOG_ERROR("Could not write user \"%s\"", u->username);
		return 0; /* failure. */
	}

	return 1; /* success */
}

/******************************************************************************
 * Functions - external
 ******************************************************************************/

/** test to see if a username is illegal.
 * username must start with a letter. Remaining character can only be letters,
 * numbers, and _ */
int
user_illegal(const char *username)
{
	const char *s;

	if (!username || !*username)
		return 1; /* illegal username */

	s = username;

	if (!isalpha(*s))
		return 1; /* illegal username */

	while (*++s) {
		if (!isalnum(*s) && *s != '_')
			return 1; /* illegal username */
	}

	return 0; /* OK - it's good */
}

/** test to see if a user exists. */
int
user_exists(const char *username)
{
	struct userdb_entry *curr;

	if (user_illegal(username))
		return 0; /**< illegal users never exist */

	for (curr = LIST_TOP(user_list); curr; curr = LIST_NEXT(curr, list)) {
		const struct user *u = curr->u;
		assert(u != NULL);
		assert(u->username != NULL);

		if (!strcasecmp(u->username, username)) {
			return 1; /**< user exists. */
		}
	}

	return 0; /* user not found */
}

/**
 * loads a user into the cache.
 */
struct user *
user_lookup(const char *username)
{
	struct userdb_entry *curr;

	for (curr = LIST_TOP(user_list); curr; curr = LIST_NEXT(curr, list)) {
		struct user *u = curr->u;

		assert(u != NULL);
		assert(u->username != NULL);

		/*
		 * load from disk if not loaded:
		 * if (!strcasecmp(curr->cached_username, username)) {
		 *   u=user_load_byname(username);
		 *   user_ll_add(u);
		 *   return u;
		 * }
		 */

		if (!strcasecmp(u->username, username)) {
			return u; /**< user exists. */
		}
	}

	return NULL; /* user not found. */
}

/** create a user and initialize the password. */
struct user *
user_create(const char *username, const char *password, const char *email)
{
	struct user *u;
	long id;
	char password_crypt[SHA1PASSWD_MAX];

	if (!username || !*username) {
		LOG_ERROR("Username was NULL or empty");
		return NULL; /* failure */
	}

	if (user_illegal(username))
		return NULL; /**< illegal users never exist */

	if (user_exists(username)) {
		LOG_ERROR("Username '%s' already exists.", username);
		return NULL; /* failure */
	}

	/* encrypt password */
	if (!sha1crypt_makepass(password_crypt, sizeof password_crypt, password)) {
		LOG_ERROR("Could not hash password");
		return NULL; /* failure */
	}

	u = user_defaults(); /* allocate a default struct */

	if (!u) {
		LOG_DEBUG("Could not allocate user structure");
		return NULL; /* failure */
	}

	id = freelist_alloc(user_id_freelist, 1);

	if (id < 0) {
		LOG_ERROR("Could not allocate user id for username(%s)", username);
		user_free(u);
		return NULL; /* failure */
	}

	assert(id >= 0);

	u->id = id;
	u->username = strdup(username);
	u->password_crypt = strdup(password_crypt);
	u->email = strdup(email);

	if (!user_write(u)) {
		LOG_ERROR("Could not save account username(%s)", u->username);
		user_free(u);
		return NULL; /* failure */
	}

	user_get(u);

	return u; /* success */
}

int
user_password_check(struct user *u, const char *cleartext)
{
	if (u && cleartext && sha1crypt_checkpass(u->password_crypt, cleartext)) {
		return 1; /* success */
	}

	return 0; /* failure */
}

const char *
user_username(struct user *u)
{
	return u ? u->username : NULL;
}

/** initialize the user system. */
int
user_init(void)
{
	struct fdb_iterator *it;
	const char *id;

	LIST_INIT(&user_list);

	user_id_freelist = freelist_new(1, 32768);
	if (!user_id_freelist) {
		LOG_CRITICAL("could not allocate IDs!");
		return 0;
	}

	fdb_domain_init("users");

	it = fdb_iterator_begin("users");

	if (!it) {
		return 0;
	}

	/* scan for account files */

	while ((id = fdb_iterator_next(it))) {
		struct user *u;

		LOG_DEBUG("Found user record '%s'", id);
		/* Load user file */
		u = user_load_byname(id);

		if (!u) {
			LOG_ERROR("Could not load user from file '%s'", id);
			goto failure;
		}

		/** add all users to a list */
		user_ll_add(u);
	}

	fdb_iterator_end(it);
	return 1; /* success */
failure:
	fdb_iterator_end(it);
	return 0; /* failure */
}

/** shutdown the user system. */
void
user_shutdown(void)
{
	/** @todo free all loaded users. */
	freelist_free(user_id_freelist);
}

/**
 * decrement a reference count.
 */
void
user_put(struct user **user)
{
	if (user && *user) {
		REFCOUNT_PUT(*user, user_free(*user); *user = NULL);
	}
}

/**
 * increment the reference count.
 */
void
user_get(struct user *user)
{
	if (user) {
		REFCOUNT_GET(user);
		LOG_DEBUG("user refcount=%d", user->REFCOUNT_NAME);
	}
}
