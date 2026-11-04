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
	char *msg_verbnomatch; /* a verb matched the word but not the arguments */
	char *msg_verbbadarg;  /* a verb argument named an object not in scope */
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
	unsigned invite_required; /* require invite code for new accounts */
#ifdef CONFIG_LANDLOCK
	unsigned security_landlock;
#endif
#ifdef CONFIG_SECCOMP
	unsigned security_seccomp;
#endif
	unsigned daemonize;
	char *pid_file;
	char *vm_image_path; /* directory holding guest program ELF images */
	char *vm_resident; /* comma-separated resident program ids to keep running */
	unsigned vm_create_max; /* max objects one verb task may create; 0 = unlimited */
	unsigned vm_owned_max; /* max objects one owner may hold; 0 = unlimited */
	char *vm_toolchain_dir; /* directory with skj-{cc,as,ld}-rv.elf for @compile */
	char *vm_lib_dir; /* directory with the C link inputs @compile stages */
	char *vm_include_dir; /* guest C header tree @compile mounts read-only */
	char *vm_tmpdir; /* parent for @compile build dirs (a boris-owned path) */
};

typedef struct mud_config MUD_CONFIG;
extern MUD_CONFIG mud_config;

#endif
