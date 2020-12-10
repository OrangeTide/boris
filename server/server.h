#ifndef SERVER_H_
#define SERVER_H_
struct server_info;
struct server_info *server_new(void);
int server_add(struct server_info *serv, const char *portservice);
int server_start(struct server_info *serv);
void server_free(struct server_info *serv);
#endif
