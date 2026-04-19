#ifndef WEBSERVER_H_
#define WEBSERVER_H_

struct webserver_context {
    unsigned upstream_port;
    int family;
};

int webserver_init(struct webserver_context ctx, unsigned port);
void webserver_shutdown(void);

#endif /* WEBSERVER_H_ */
