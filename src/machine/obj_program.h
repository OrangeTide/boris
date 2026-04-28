/* obj_program.h : attach machine programs to objects */
#ifndef OBJ_PROGRAM_H
#define OBJ_PROGRAM_H

struct iox_loop;

int  obj_program_init(struct iox_loop *loop);
void obj_program_shutdown(void);

int  obj_program_attach(const char *obj_id, int image_fd,
                        const char *prog_id,
                        unsigned ram_size, const char *interface);

int  obj_program_dispatch_verb(const char *obj_id, const char *verb,
                               const char *player_id,
                               const char *direction);

#endif
