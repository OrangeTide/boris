/* machine.c : ColdFire virtual machine */
#define LOG_SUBSYSTEM "machine"
#include <log.h>

#include "machine.h"
#include "coldfire.h"
#include "elf_loader.h"

#include <stdlib.h>
#include <string.h>

#define HALT_STUB_ADDR 0x0400

struct machine_file {
	uint16_t type;
	uint16_t flags;
	union {
		struct {
			machine_msg_fn msg_post;
			void          *ctx;
		} io;
		struct {
			char     *name;
			uint32_t  handler_pc;
		} verb;
	};
};

struct machine {
	cf_cpu           cpu;
	uint8_t         *ram;
	uint32_t         ram_size;
	machine_state_t  state;
	machine_state_t  resume_state;
	int              exit_status;
	int              yielded;
	uint64_t         sleep_ms;
	int32_t          wait_ncount;
	uint32_t         wait_handles_addr;
	int32_t          wait_timeout;
	machine_print_fn print_fn;
	void            *print_ctx;
	struct machine_file files[MACHINE_MAX_FILES];
};

/* ------------------------------------------------------------------ */
/* Big-endian bus callbacks with bounds checking                      */
/* ------------------------------------------------------------------ */

static uint32_t
bus_read8(void *ctx, uint32_t addr)
{
	machine_t *m = ctx;
	if (addr < m->ram_size)
		return m->ram[addr];
	return 0;
}

static uint32_t
bus_read16(void *ctx, uint32_t addr)
{
	machine_t *m = ctx;
	if (addr + 1 < m->ram_size)
		return ((uint32_t)m->ram[addr] << 8) | m->ram[addr + 1];
	return 0;
}

static uint32_t
bus_read32(void *ctx, uint32_t addr)
{
	machine_t *m = ctx;
	if (addr + 3 < m->ram_size)
		return ((uint32_t)m->ram[addr] << 24) |
		       ((uint32_t)m->ram[addr + 1] << 16) |
		       ((uint32_t)m->ram[addr + 2] << 8) |
		       m->ram[addr + 3];
	return 0;
}

static void
bus_write8(void *ctx, uint32_t addr, uint32_t val)
{
	machine_t *m = ctx;
	if (addr < m->ram_size)
		m->ram[addr] = val & 0xFF;
}

static void
bus_write16(void *ctx, uint32_t addr, uint32_t val)
{
	machine_t *m = ctx;
	if (addr + 1 < m->ram_size) {
		m->ram[addr]     = (val >> 8) & 0xFF;
		m->ram[addr + 1] = val & 0xFF;
	}
}

static void
bus_write32(void *ctx, uint32_t addr, uint32_t val)
{
	machine_t *m = ctx;
	if (addr + 3 < m->ram_size) {
		m->ram[addr]     = (val >> 24) & 0xFF;
		m->ram[addr + 1] = (val >> 16) & 0xFF;
		m->ram[addr + 2] = (val >> 8) & 0xFF;
		m->ram[addr + 3] = val & 0xFF;
	}
}

/* ------------------------------------------------------------------ */
/* Handle helpers                                                     */
/* ------------------------------------------------------------------ */

#define MACHINE_VERB_BASE 128

static int
read_guest_string(machine_t *m, uint32_t addr, char *buf, size_t bufsz)
{
	size_t i;

	for (i = 0; i < bufsz - 1 && addr + i < m->ram_size; i++) {
		buf[i] = (char)m->ram[addr + i];
		if (buf[i] == '\0')
			return (int)i;
	}
	buf[i] = '\0';
	return -1;
}

static int
alloc_fd(machine_t *m, int base, int limit)
{
	int i;

	for (i = base; i < limit; i++) {
		if (m->files[i].type == MF_NONE)
			return i;
	}
	return -1;
}

static void
file_close(struct machine_file *f)
{
	if (f->type == MF_VERB || f->type == MF_EVENT)
		free(f->verb.name);
	memset(f, 0, sizeof(*f));
}

/* ------------------------------------------------------------------ */
/* Hypercall dispatch (LINE_A opcodes)                                */
/* ------------------------------------------------------------------ */

enum {
	HC_ABORT    = 0,
	HC_TRAP     = 1,
	HC_YIELD    = 2,
	HC_SLEEP    = 3,
	HC_EXIT     = 4,
	HC_PRINT    = 5,
	HC_OPEN     = 6,
	HC_CLOSE    = 7,
	HC_WAIT     = 8,
	HC_MSG_POST = 19,
};

static int
machine_hypercall(struct cf_cpu *cpu, uint16_t opword, void *ctx)
{
	machine_t *m = ctx;
	int func = opword & 0xFFF;

	switch (func) {
	case HC_ABORT:
		m->state = MACHINE_DEAD;
		m->exit_status = -1;
		cpu->halted = 1;
		return 0;

	case HC_TRAP:
		m->state = MACHINE_DEAD;
		m->exit_status = (int)cpu->d[0];
		cpu->halted = 1;
		return 0;

	case HC_YIELD:
		m->yielded = 1;
		return 0;

	case HC_SLEEP:
		m->sleep_ms = (uint64_t)cpu->d[0] * 1000;
		m->resume_state = m->state;
		m->state = MACHINE_SLEEPING;
		cpu->halted = 1;
		return 0;

	case HC_EXIT:
		m->exit_status = (int)cpu->d[0];
		m->state = MACHINE_DEAD;
		cpu->halted = 1;
		return 0;

	case HC_PRINT: {
		uint32_t len  = cpu->d[0];
		uint32_t addr = cpu->a[0];

		if (addr + len > m->ram_size || addr + len < addr) {
			cpu->d[0] = (uint32_t)-14; /* -EFAULT */
			return 0;
		}
		if (m->print_fn)
			m->print_fn(m->print_ctx,
			            (const char *)(m->ram + addr), len);
		cpu->d[0] = 0;
		return 0;
	}

	case HC_OPEN: {
		uint32_t name_addr = cpu->a[0];
		uint32_t handler_pc = cpu->d[1];
		char name[64];
		const char *sep;
		int fd, type;

		if (read_guest_string(m, name_addr, name, sizeof(name)) < 0) {
			cpu->d[0] = (uint32_t)-14; /* -EFAULT */
			return 0;
		}

		sep = strchr(name, ':');
		if (!sep) {
			cpu->d[0] = (uint32_t)-22; /* -EINVAL */
			return 0;
		}

		if (sep - name == 4 && memcmp(name, "verb", 4) == 0)
			type = MF_VERB;
		else if (sep - name == 5 && memcmp(name, "event", 5) == 0)
			type = MF_EVENT;
		else {
			cpu->d[0] = (uint32_t)-22; /* -EINVAL */
			return 0;
		}

		fd = alloc_fd(m, MACHINE_VERB_BASE, MACHINE_MAX_FILES);
		if (fd < 0) {
			cpu->d[0] = (uint32_t)-23; /* -ENFILE */
			return 0;
		}

		m->files[fd].type = (uint16_t)type;
		m->files[fd].flags = 0;
		m->files[fd].verb.name = strdup(sep + 1);
		m->files[fd].verb.handler_pc = handler_pc;
		if (!m->files[fd].verb.name) {
			m->files[fd].type = MF_NONE;
			cpu->d[0] = (uint32_t)-12; /* -ENOMEM */
			return 0;
		}

		cpu->d[0] = (uint32_t)fd;
		return 0;
	}

	case HC_CLOSE: {
		int fd = (int)cpu->d[0];
		int kind;

		if (fd < 0 || fd >= MACHINE_MAX_FILES ||
		    m->files[fd].type == MF_NONE) {
			cpu->d[0] = (uint32_t)-9; /* -EBADF */
			return 0;
		}

		switch (m->files[fd].type) {
		case MF_IO:    kind = KIND_IO;    break;
		case MF_VERB:  kind = KIND_VERB;  break;
		case MF_EVENT: kind = KIND_EVENT; break;
		default:       kind = -9;         break; /* -EBADF */
		}

		file_close(&m->files[fd]);
		cpu->d[0] = (uint32_t)kind;
		return 0;
	}

	case HC_WAIT: {
		int32_t ncount     = (int32_t)cpu->d[0];
		uint32_t handles   = cpu->a[0];
		int32_t timeout_ms = (int32_t)cpu->d[1];

		if (ncount == 0 && timeout_ms < 0) {
			cpu->d[0] = (uint32_t)-1;
			return 0;
		}

		if (ncount == 0) {
			m->sleep_ms = (uint64_t)(unsigned)timeout_ms;
			m->resume_state = m->state;
			m->state = MACHINE_SLEEPING;
			cpu->halted = 1;
			cpu->d[0] = (uint32_t)-1;
			return 0;
		}

		if (ncount < 0 ||
		    handles + (uint32_t)ncount * 2 > m->ram_size) {
			cpu->d[0] = (uint32_t)-14; /* -EFAULT */
			return 0;
		}

		m->wait_ncount = ncount;
		m->wait_handles_addr = handles;
		m->wait_timeout = timeout_ms;
		m->state = MACHINE_READY;
		cpu->halted = 1;
		return 0;
	}

	case HC_MSG_POST: {
		int fd        = (int)cpu->d[0];
		uint32_t len  = cpu->d[1];
		uint32_t addr = cpu->a[0];

		if (fd < 0 || fd >= MACHINE_MAX_FILES ||
		    m->files[fd].type != MF_IO ||
		    !m->files[fd].io.msg_post) {
			cpu->d[0] = (uint32_t)-9; /* -EBADF */
			return 0;
		}
		if (addr + len > m->ram_size || addr + len < addr) {
			cpu->d[0] = (uint32_t)-14; /* -EFAULT */
			return 0;
		}
		m->files[fd].io.msg_post(m->files[fd].io.ctx,
		                         (const char *)(m->ram + addr), len);
		cpu->d[0] = 0;
		return 0;
	}

	default:
		return -1;
	}
}

/* ------------------------------------------------------------------ */
/* ELF loader glue                                                    */
/* ------------------------------------------------------------------ */

static void
elf_write_byte(void *ctx, uint32_t addr, uint8_t byte)
{
	machine_t *m = ctx;
	if (addr < m->ram_size)
		m->ram[addr] = byte;
}

/* ------------------------------------------------------------------ */
/* Public API                                                         */
/* ------------------------------------------------------------------ */

machine_t *
machine_new(uint32_t ram_size)
{
	machine_t *m;

	m = calloc(1, sizeof(*m));
	if (!m)
		return NULL;

	m->ram = calloc(1, ram_size);
	if (!m->ram) {
		free(m);
		return NULL;
	}

	m->ram_size = ram_size;
	m->state = MACHINE_DEAD;
	m->files[0].type = MF_IO;
	m->files[1].type = MF_IO;
	m->files[2].type = MF_IO;

	cf_init(&m->cpu, bus_read8, bus_read16, bus_read32,
	        bus_write8, bus_write16, bus_write32, m);
	cf_set_hypercall(&m->cpu, machine_hypercall, m);

	return m;
}

void
machine_free(machine_t *m)
{
	int i;

	if (!m)
		return;
	for (i = 0; i < MACHINE_MAX_FILES; i++)
		file_close(&m->files[i]);
	free(m->ram);
	free(m);
}

void
machine_set_print(machine_t *m, machine_print_fn fn, void *ctx)
{
	m->print_fn  = fn;
	m->print_ctx = ctx;
}

int
machine_fd_open(machine_t *m, int fd, machine_msg_fn fn, void *ctx)
{
	if (fd < 0 || fd >= MACHINE_MAX_FILES)
		return -1;
	if (m->files[fd].type != MF_NONE && m->files[fd].type != MF_IO)
		return -1;
	m->files[fd].type = MF_IO;
	m->files[fd].io.msg_post = fn;
	m->files[fd].io.ctx      = ctx;
	return 0;
}

void
machine_fd_close(machine_t *m, int fd)
{
	if (fd >= 0 && fd < MACHINE_MAX_FILES)
		file_close(&m->files[fd]);
}

int
machine_load_image(machine_t *m, uint32_t addr,
                   const void *data, size_t len)
{
	if ((uint64_t)addr + len > m->ram_size)
		return -1;
	memcpy(m->ram + addr, data, len);
	return 0;
}

int
machine_load_elf(machine_t *m, const char *path)
{
	uint32_t entry = elf_load(path, elf_write_byte, m);
	if (entry == 0) {
		LOG_ERROR("failed to load ELF: %s", path);
		return -1;
	}
	return (int)entry;
}

int
machine_load_elf_fd(machine_t *m, int fd, const char *name)
{
	uint32_t entry = elf_load_fd(fd, name, elf_write_byte, m);
	if (entry == 0) {
		LOG_ERROR("failed to load ELF: %s", name);
		return -1;
	}
	return (int)entry;
}

int
machine_start(machine_t *m, uint32_t entry, uint32_t stack)
{
	unsigned i;

	if (stack > m->ram_size || entry >= m->ram_size)
		return -1;

	for (i = 0; i < 256; i++)
		bus_write32(m, i * 4, HALT_STUB_ADDR);

	bus_write32(m, 0x00, stack);
	bus_write32(m, 0x04, entry);

	/* HALT instruction at the stub address */
	bus_write16(m, HALT_STUB_ADDR, 0x4AC8);

	cf_reset(&m->cpu);
	m->state        = MACHINE_INIT;
	m->resume_state = MACHINE_INIT;
	m->exit_status  = 0;
	m->yielded      = 0;
	m->sleep_ms     = 0;
	m->wait_ncount  = 0;

	return 0;
}

machine_run_result_t
machine_run(machine_t *m, int max_insns)
{
	int i;

	if (m->state != MACHINE_INIT && m->state != MACHINE_BUSY)
		return MACHINE_RUN_ERR;

	m->yielded     = 0;
	m->cpu.halted  = 0;

	for (i = 0; i < max_insns; i++) {
		if (cf_step(&m->cpu) < 0)
			break;
		if (m->yielded)
			return MACHINE_RUN_YIELD;
	}

	if (m->state == MACHINE_DEAD)
		return MACHINE_RUN_EXIT;
	if (m->state == MACHINE_SLEEPING)
		return MACHINE_RUN_SLEEP;
	if (m->state == MACHINE_READY)
		return MACHINE_RUN_READY;
	if (m->cpu.halted)
		return MACHINE_RUN_HALT;

	return MACHINE_RUN_OK;
}

machine_state_t
machine_state(const machine_t *m)
{
	return m->state;
}

int
machine_exit_status(const machine_t *m)
{
	return m->exit_status;
}

uint64_t
machine_sleep_ms(const machine_t *m)
{
	return m->sleep_ms;
}

int
machine_wake(machine_t *m)
{
	if (m->state != MACHINE_SLEEPING)
		return -1;
	m->state = m->resume_state;
	return 0;
}

int
machine_dispatch(machine_t *m, int fd)
{
	int32_t i;
	uint32_t addr;

	if (m->state != MACHINE_READY)
		return -1;

	addr = m->wait_handles_addr;
	for (i = 0; i < m->wait_ncount; i++) {
		uint16_t h = (uint16_t)bus_read16(m, addr + (uint32_t)i * 2);
		if (h == (uint16_t)fd) {
			m->cpu.d[0] = (uint32_t)i;
			m->state = MACHINE_BUSY;
			m->cpu.halted = 0;
			return 0;
		}
	}

	return -1;
}

int
machine_find_verb(machine_t *m, const char *name)
{
	int i;

	for (i = MACHINE_VERB_BASE; i < MACHINE_MAX_FILES; i++) {
		if (m->files[i].type == MF_VERB &&
		    strcmp(m->files[i].verb.name, name) == 0)
			return i;
	}
	return -1;
}

int
machine_find_event(machine_t *m, const char *name)
{
	int i;

	for (i = MACHINE_VERB_BASE; i < MACHINE_MAX_FILES; i++) {
		if (m->files[i].type == MF_EVENT &&
		    strcmp(m->files[i].verb.name, name) == 0)
			return i;
	}
	return -1;
}

#define CONTEXT_BLOCK_ADDR 0x0800
#define CONTEXT_HEADER_SIZE 0x14

static uint32_t
write_guest_string(machine_t *m, uint32_t off, const char *s)
{
	size_t len = strlen(s) + 1;

	if (off + len > m->ram_size)
		return off;
	memcpy(m->ram + off, s, len);
	return off + (uint32_t)len;
}

int
machine_write_context(machine_t *m, int fd,
                      const char *verb, const char *room_id,
                      const char *player_id, const char *direction)
{
	uint32_t off = CONTEXT_BLOCK_ADDR + CONTEXT_HEADER_SIZE;
	uint32_t verb_ptr, room_ptr, player_ptr, dir_ptr;

	if (off >= m->ram_size)
		return -1;

	verb_ptr = off;
	off = write_guest_string(m, off, verb);

	if (room_id) {
		room_ptr = off;
		off = write_guest_string(m, off, room_id);
	} else {
		room_ptr = 0;
	}

	if (player_id) {
		player_ptr = off;
		off = write_guest_string(m, off, player_id);
	} else {
		player_ptr = 0;
	}

	if (direction) {
		dir_ptr = off;
		off = write_guest_string(m, off, direction);
	} else {
		dir_ptr = 0;
	}

	bus_write32(m, CONTEXT_BLOCK_ADDR + 0x00, (uint32_t)fd);
	bus_write32(m, CONTEXT_BLOCK_ADDR + 0x04, verb_ptr);
	bus_write32(m, CONTEXT_BLOCK_ADDR + 0x08, room_ptr);
	bus_write32(m, CONTEXT_BLOCK_ADDR + 0x0C, player_ptr);
	bus_write32(m, CONTEXT_BLOCK_ADDR + 0x10, dir_ptr);
	return 0;
}
