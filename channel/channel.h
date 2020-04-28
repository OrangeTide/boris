#ifndef BORIS_CHANNEL_H_
#define BORIS_CHANNEL_H_
struct channel;
struct channel_member;

int channel_initialize(void);
void channel_shutdown(void);
int channel_join(struct channel *ch, struct channel_member *cm);
void channel_part(struct channel *ch, struct channel_member *cm);
/**
 * get a channel associated with a public(global) name.
 */
struct channel *channel_public(const char *name);
int channel_broadcast(struct channel *ch, struct channel_member **exclude_list, unsigned exclude_list_len, const char *fmt, ...);

#endif
