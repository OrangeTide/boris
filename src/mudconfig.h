#ifndef MUDCONFIG_H_
#define MUDCONFIG_H_

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
	char *newuser_room; /* starting room for new characters */
	unsigned obj_cache_size; /* max unreferenced objects in LRU cache */
	unsigned character_cache_size; /* max unreferenced characters in LRU cache */
	unsigned rpg_enabled; /* feature gate for RPG subsystem commands */
#ifdef CONFIG_LANDLOCK
	unsigned security_landlock;
#endif
#ifdef CONFIG_SECCOMP
	unsigned security_seccomp;
#endif
	unsigned daemonize;
	char *pid_file;
};

typedef struct mud_config MUD_CONFIG;
extern MUD_CONFIG mud_config;

#endif
