#ifndef MUDCONFIG_H_

/** global configuration of the mud. */
struct mud_config {
	char *config_filename;
	char *menu_prompt;
	char *form_prompt;
	char *command_prompt;
	char *msg_errormain;
	char *msg_invalidselection;
	char *msg_invalidusername;
	char *msgfile_noaccount;
	char *msgfile_badpassword;
	char *msg_tryagain;
	char *msg_unsupported;
	char *msg_useralphanumeric;
	char *msg_usercreatesuccess;
	char *msg_userexists;
	char *msg_usermin3;
	char *msg_invalidcommand;
	char *msgfile_welcome;
	unsigned newuser_level;
	unsigned newuser_flags;
	unsigned newuser_allowed; /* true if we're allowing newuser applications */
	char *eventlog_filename;
	char *eventlog_timeformat;
	char *msgfile_newuser_create;
	char *msgfile_newuser_deny;
	char *default_channels;
	unsigned webserver_port;
	char *form_newuser_filename;
	int default_family; /* IPv4 or IPv6 */
};

typedef struct mud_config MUD_CONFIG;
extern MUD_CONFIG mud_config;

#endif
