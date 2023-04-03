#ifndef WEBSERVER_H_
#define WEBSERVER_H_

#include "dyad.h"
struct webserver_context {
    unsigned upstream_port;
    int family;
};

int webserver_init(struct webserver_context ctx, unsigned port);
void webserver_shutdown(void);

void webserver_test_callback(dyad_Event* ev);
void webserver_accept_callback(dyad_Event* ev);

#endif /* WEBSERVER_H_ */
