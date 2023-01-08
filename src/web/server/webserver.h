#ifndef WEBSERVER_H_
#define WEBSERVER_H_

int webserver_init(int family, unsigned port);
void webserver_shutdown(void);

#endif /* WEBSERVER_H_ */
