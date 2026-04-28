/* machine.h : ColdFire virtual machine */
#ifndef MACHINE_H_
#define MACHINE_H_

#include <stddef.h>
#include <stdint.h>

typedef enum {
	MACHINE_INIT,
	MACHINE_READY,
	MACHINE_BUSY,
	MACHINE_SLEEPING,
	MACHINE_DEAD,
} machine_state_t;

typedef enum {
	MACHINE_RUN_OK    =  0,
	MACHINE_RUN_YIELD =  1,
	MACHINE_RUN_SLEEP =  2,
	MACHINE_RUN_EXIT  =  3,
	MACHINE_RUN_HALT  =  4,
	MACHINE_RUN_READY =  5,
	MACHINE_RUN_ERR   = -1,
} machine_run_result_t;

enum machine_file_type {
	MF_NONE  = 0,
	MF_IO    = 1,
	MF_VERB  = 2,
	MF_EVENT = 3,
};

enum machine_file_kind {
	KIND_IO    = 1,
	KIND_VERB  = 2,
	KIND_EVENT = 3,
};

#define MACHINE_MAX_FILES 256

typedef void (*machine_print_fn)(void *ctx, const char *buf, size_t len);
typedef void (*machine_msg_fn)(void *ctx, const char *buf, size_t len);

typedef struct machine machine_t;

machine_t *machine_new(uint32_t ram_size);
void       machine_free(machine_t *m);

void machine_set_print(machine_t *m, machine_print_fn fn, void *ctx);

int  machine_fd_open(machine_t *m, int fd, machine_msg_fn fn, void *ctx);
void machine_fd_close(machine_t *m, int fd);

int machine_load_image(machine_t *m, uint32_t addr,
                       const void *data, size_t len);
int machine_load_elf(machine_t *m, const char *path);
int machine_load_elf_fd(machine_t *m, int fd, const char *name);

int machine_start(machine_t *m, uint32_t entry, uint32_t stack);

machine_run_result_t machine_run(machine_t *m, int max_insns);

machine_state_t machine_state(const machine_t *m);
int             machine_exit_status(const machine_t *m);
uint64_t        machine_sleep_ms(const machine_t *m);
int             machine_wake(machine_t *m);
int             machine_dispatch(machine_t *m, int fd);

int  machine_find_verb(machine_t *m, const char *name);
int  machine_find_event(machine_t *m, const char *name);
int  machine_write_context(machine_t *m, int fd,
                           const char *verb, const char *room_id,
                           const char *player_id,
                           const char *direction);

#endif
