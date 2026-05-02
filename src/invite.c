/* invite.c : invite code generation, validation, and storage */
/* PUBLIC DOMAIN (CC0-1.0) */

#include "invite.h"
#include <boris.h>
#include <muddb.h>
#define LOG_SUBSYSTEM "invite"
#include <log.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>
#include <fcntl.h>
#include <unistd.h>

#define DOMAIN_INVITES "invites"
#define USER_CODE_COUNT 3

static const char invite_chars[] = "ABCEGHJKLMNPRSTVWXYZ0123456789";

static int
rand_bytes(unsigned char *buf, int len)
{
    int fd = open("/dev/urandom", O_RDONLY);
    if (fd < 0)
        return -1;
    ssize_t n = read(fd, buf, len);
    close(fd);
    return n == len ? 0 : -1;
}

static int
invite_gen_code(char *out, int outsz)
{
    unsigned char rnd[12];

    if (outsz < INVITE_CODE_LEN + 1 || rand_bytes(rnd, sizeof(rnd)) != 0)
        return -1;

    int j = 0;
    for (int i = 0; i < 12; i++) {
        if (i > 0 && i % 4 == 0)
            out[j++] = '-';
        out[j++] = invite_chars[rnd[i] % (sizeof(invite_chars) - 1)];
    }
    out[j] = '\0';
    return 0;
}

int
invite_validate(const char *code)
{
    if (!code || strlen(code) != INVITE_CODE_LEN)
        return 0;

    OBJ *obj = muddb_get(mud_db, DOMAIN_INVITES, code);
    if (!obj)
        return 0;

    const char *max_str = obj_prop_get(obj, "max_uses");
    const char *used_str = obj_prop_get(obj, "used");
    int max_uses = max_str ? atoi(max_str) : 1;
    int used = used_str ? atoi(used_str) : 0;

    obj_free(obj);
    return used < max_uses;
}

int
invite_use(const char *code)
{
    if (!code || strlen(code) != INVITE_CODE_LEN)
        return -1;

    OBJ *obj = muddb_get(mud_db, DOMAIN_INVITES, code);
    if (!obj)
        return -1;

    const char *max_str = obj_prop_get(obj, "max_uses");
    const char *used_str = obj_prop_get(obj, "used");
    int max_uses = max_str ? atoi(max_str) : 1;
    int used = used_str ? atoi(used_str) : 0;

    if (used >= max_uses) {
        obj_free(obj);
        return -1;
    }

    char buf[16];
    snprintf(buf, sizeof(buf), "%d", used + 1);

    OBJ *updated = obj_new(code);
    if (!updated) {
        obj_free(obj);
        return -1;
    }

    OBJ_ITER *it = obj_iter_begin(obj);
    const char *key, *val;
    while (obj_iter_next(it, &key, &val)) {
        if (strcmp(key, "used") != 0)
            obj_prop_set(updated, key, val);
    }
    obj_iter_end(it);
    obj_prop_set(updated, "used", buf);
    obj_free(obj);

    if (muddb_put(mud_db, DOMAIN_INVITES, code, updated) != MUDDB_OK) {
        obj_free(updated);
        return -1;
    }

    obj_free(updated);

    if (used + 1 >= max_uses) {
        muddb_del(mud_db, DOMAIN_INVITES, code);
        LOG_INFO("invite code %s exhausted and removed", code);
    }

    return 0;
}

int
invite_create_for_user(const char *username, int count)
{
    int created = 0;

    for (int i = 0; i < count; i++) {
        char code[INVITE_CODE_LEN + 1];
        if (invite_gen_code(code, sizeof(code)) != 0)
            continue;

        OBJ *obj = obj_new(code);
        if (!obj)
            continue;

        obj_prop_set(obj, "code", code);
        obj_prop_set(obj, "owner", username);
        obj_prop_set(obj, "max_uses", "1");
        obj_prop_set(obj, "used", "0");

        if (muddb_put(mud_db, DOMAIN_INVITES, code, obj) == MUDDB_OK) {
            LOG_INFO("created invite code %s for user %s", code, username);
            created++;
        }

        obj_free(obj);
    }

    return created;
}

int
invite_init(void)
{
    LOG_INFO("invite code system initialized");
    return 1;
}

void
invite_shutdown(void)
{
}
