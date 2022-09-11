#ifndef FORM_H_
#define FORM_H_
#include <boris.h>
#include <mud.h>

struct form;
struct form_state;

void form_init(struct form *f, const char *title, void (*form_close)(DESCRIPTOR_DATA *cl,struct form_state *fs));
void form_setmessage(struct form *f, const char *message);
void form_free(struct form *f);
void form_additem(struct form *f, unsigned flags, const char *name, const char *prompt, const char *description, int (*form_check)(DESCRIPTOR_DATA *cl,const char *str));
struct form *form_load(const char *buf, void (*form_close)(DESCRIPTOR_DATA *cl, struct form_state *fs));
struct form *form_load_from_file(const char *filename, void (*form_close)(DESCRIPTOR_DATA *cl,struct form_state *fs));
int form_module_init(void);
void form_module_shutdown(void);
void form_createaccount_start(void *p, long unused2, void *unused3);
#endif
