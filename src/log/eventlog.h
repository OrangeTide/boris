#ifndef EVENTLOG_H_
#define EVENTLOG_H_

int eventlog_init(void);
void eventlog_shutdown(void);
void eventlog(const char *type, const char *fmt, ...);
void eventlog_connect(const char *peer_str);
void eventlog_server_startup(void);
void eventlog_server_shutdown(void);
void eventlog_login_failattempt(const char *username, const char *peer_str);
void eventlog_signon(const char *username, const char *peer_str);
void eventlog_signoff(const char *username, const char *peer_str);
void eventlog_toomany(void);
void eventlog_commandinput(const char *remote, const char *username, const char *line);
void eventlog_channel_new(const char *channel_name);
void eventlog_channel_remove(const char *channel_name);
void eventlog_channel_join(const char *remote, const char *channel_name, const char *username);
void eventlog_channel_part(const char *remote, const char *channel_name, const char *username);
void eventlog_webserver_get(const char *remote, const char *uri);
#endif
