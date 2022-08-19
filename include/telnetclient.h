#ifndef TELNETCLIENT_H_
#define TELNETCLIENT_H_
#include "mud.h"
struct telnetserver;

const char *telnetclient_username(DESCRIPTOR_DATA *cl);
int telnetclient_puts(DESCRIPTOR_DATA *cl, const char *str);
int telnetclient_vprintf(DESCRIPTOR_DATA *cl, const char *fmt, va_list ap);
int telnetclient_printf(DESCRIPTOR_DATA *cl, const char *fmt, ...);
void telnetclient_setprompt(DESCRIPTOR_DATA *cl, const char *prompt);
void telnetclient_start_lineinput(DESCRIPTOR_DATA *cl, void (*line_input)(DESCRIPTOR_DATA *cl, const char *line), const char *prompt);
int telnetclient_isstate(DESCRIPTOR_DATA *cl, void (*line_input)(DESCRIPTOR_DATA *cl, const char *line), const char *prompt);
void telnetclient_close(DESCRIPTOR_DATA *cl);
struct channel_member *telnetclient_channel_member(DESCRIPTOR_DATA *cl);
dyad_Stream *telnetclient_socket_handle(DESCRIPTOR_DATA *cl);
const char *telnetclient_socket_name(DESCRIPTOR_DATA *cl);
const struct terminal *telnetclient_get_terminal(DESCRIPTOR_DATA *cl);
int telnetserver_listen(int port);
void telnetclient_prompt_refresh(DESCRIPTOR_DATA *cl);
void telnetclient_prompt_refresh_all(struct telnetserver *);
struct telnetserver *telnetserver_first(void);
struct telnetserver *telnetserver_next(struct telnetserver *server);
#endif
