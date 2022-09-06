#ifndef BORIS_CHANNEL_H_
#define BORIS_CHANNEL_H_
#include <stdarg.h>

struct channel;
struct channel_member;

#define CHANNEL_SYS "@system"
#define CHANNEL_OOC "OOC"
#define CHANNEL_WIZ "@wiz"
#define CHANNEL_DEV "devel"
#define CHANNEL_MUDLIST "@mudlist"
#define CHANNEL_CHAT "chat"
#define CHANNEL_NEWBIE "newbie"

/**
 * used to subscribe to a channel.
 * see channel.join() and channel.part().
 *
 * HINT: a fancy macro using offsetof() and casting could be used to find the
 * pointer of the containing struct and avoid the need for the void *p.
 */
struct channel_member {
	void (*send)(struct channel_member *cm, struct channel *ch, const char *msg);
	void *p;
};

int channel_initialize(void);
void channel_shutdown(void);
int channel_join(struct channel *ch, struct channel_member *cm);
void channel_part(struct channel *ch, struct channel_member *cm);
struct channel *channel_public(const char *name);
int channel_vbroadcast(struct channel *ch, struct channel_member **exclude_list, unsigned exclude_list_len, const char *fmt, va_list ap);
int channel_broadcast(struct channel *ch, struct channel_member **exclude_list, unsigned exclude_list_len, const char *fmt, ...);
#endif
