#ifndef WEBSERVER_H_
#define WEBSERVER_H_

#include "dyad.h"
struct webserver_context {
    dyad_Stream *webserver_upstream;
    int family;
};

int webserver_init(struct webserver_context ctx, unsigned port);
void webserver_shutdown(void);

#endif /* WEBSERVER_H_ */
