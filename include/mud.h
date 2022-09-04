#ifndef MUD_H_
#define MUD_H_
#include <dyad.h>
#include <terminal.h>
#include <channel.h>
#include <list.h>
#include <acs.h>

struct form_state;
struct menuinfo;
struct user;

typedef struct descriptor_data DESCRIPTOR_DATA;
struct descriptor_data {
	dyad_Stream *stream;
	struct mth_data *mth;
	LIST_ENTRY(DESCRIPTOR_DATA) list;
	enum client_type { CLIENT_TYPE_USER = 1 } type;
	char *host;
	char *name;
	struct user *user;
	struct acs_info acs;
	struct terminal terminal;
	void (*state_free)(DESCRIPTOR_DATA *);
	union state_data {
		/** undocumented - please add documentation. */
		struct login_state {
			char username[16];
		} login;
		const struct form_state *form;
		const struct menuinfo *menu;
	} state;
	void (*line_input)(DESCRIPTOR_DATA *cl, const char *line);
	char *prompt_string;
	int prompt_flag:1;
	unsigned nr_channel; /**< number of channels monitoring. */
	struct channel **channel; /**< pointer to every monitoring channel. */
	struct channel_member channel_member;
};

typedef struct mud_data MUD_DATA;
struct mud_data {
	int                   server;
	int                   boot_time;
	struct system_parameters {
		int port;
		int verbose_logging;
	} params;
	int                   total_plr;
	int                   top_area;
	int                   top_help;
	int                   top_mob_index;
	int                   top_obj_index;
	int                   top_room;
	int                   msdp_table_size;
	int                   mccp_len;
	unsigned char       * mccp_buf;
};

extern MUD_DATA mud;

#endif
