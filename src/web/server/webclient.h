#ifndef WEBCLIENT_H_
#define WEBCLIENT_H_
#include "mud.h"
#include "msgqueue.h"
#include <mongoose.h>

enum web_client_state { WC_NEW, WC_ACTIVE, WC_CLOSING };

struct web_client {
	struct web_client *next;
	struct mg_connection *ws_conn;
	DESCRIPTOR_DATA *cl;
	struct msg_queue input_q;
	struct msg_queue output_q;
	enum web_client_state state;
};

struct web_client *webclient_new(struct mg_connection *c);
void webclient_destroy(struct web_client *wc);
struct web_client *webclient_first(void);

void webclient_set_wake_fd(int fd);
int webclient_get_wake_fd(void);

void webclient_lock(void);
void webclient_unlock(void);

#endif
