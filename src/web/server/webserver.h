#ifndef WEBSERVER_H_
#define WEBSERVER_H_

#include "dyad.h"
typedef struct {
    dyad_Stream *webserver_upstream;
    int family;
} webserver_context_t;

int webserver_init(webserver_context_t ctx, unsigned port);
void webserver_shutdown(void);

#endif /* WEBSERVER_H_ */
