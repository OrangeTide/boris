/* patrol_main.c : skj-kp-patrol, a host that exposes an opaque handle type to a
   Kobold program, the counterpart of examples/patrol.c in the Kobold tree.

   It demonstrates host opaque handles through the Skjegg JIT.  The program
   (examples/patrol.pas) declares an Entity interface and a spawnGuard factory;
   this host registers them.  A method call e.move(dx, dy) lowers to a plain
   CALL to the symbol "Entity.move" with the handle as the first argument, so in
   the JIT's flat binding model a host method is just a bound C function and needs
   no special dispatch machinery.  The handle itself is a table id (low bit 1); the
   host object behind it lives in the handle table, never in guest memory, so the
   sandbox-isolation invariant holds by construction (doc kp-host-handle-isolation).

   The whole language runtime is shared with skj-kp-jit through kp_host.c; this
   driver only adds the Entity host type. */

#include "kpm.h"
#include "jit_common.h"
#include "kp_host.h"
#include "handle.h"

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

/* The host object behind an Entity handle: a 2-D position the host owns. */
struct entity {
    int x, y;
};

/* Entity.move(self, dx, dy): the receiver handle is the first argument, the
   method's own parameters follow.  Mirrors examples/patrol.c entity_move. */
static void entity_move(uint32_t self, int dx, int dy)
{
    struct entity *e = kp_handle_ptr(NULL, self, KP_H_HOST);

    if (!e)
        return;
    e->x += dx;
    e->y += dy;
    printf("guard at (%d, %d)\n", e->x, e->y);
}

/* The finalizer the handle runs when its last reference is released. */
static void entity_free(kp_vm *vm, void *obj)
{
    (void)vm;
    printf("guard freed\n");
    free(obj);
}

/* spawnGuard(): a fresh Entity at the origin, returned as a handle (refcount 1,
   transferred to the caller).  The host pointer stays in the handle table. */
static uint32_t host_spawn_guard(void)
{
    struct entity *e = calloc(1, sizeof(*e));

    if (!e)
        return 0;
    return kp_handle_intern(NULL, KP_H_HOST, e, entity_free);
}

static void *as_addr(void (*fn)(void))
{
    union { void (*f)(void); void *o; } u;
    u.f = fn;
    return u.o;
}

int main(int argc, char **argv)
{
    struct kp_binding binds[64];
    int nbinds = 0;
    char *text;
    size_t len;
    struct kpm_module m;
    struct kp_jit j;
    char err[256];
    void *entry;
    int64_t iargs[6] = { 0 };
    double fargs[8] = { 0 };
    double fret = 0;
    uintptr_t top;

    if (argc == 2 && (strcmp(argv[1], "-h") == 0 ||
                      strcmp(argv[1], "--help") == 0)) {
        printf("usage: skj-kp-patrol module.kpm\n");
        return 0;
    }
    if (argc != 2) {
        fprintf(stderr, "usage: skj-kp-patrol module.kpm\n");
        return 2;
    }

    kp_install_runtime(binds, &nbinds, (int)(sizeof binds / sizeof binds[0]));
    /* the host type this program imports */
    binds[nbinds].name = "spawnGuard";
    binds[nbinds].addr = as_addr((void (*)(void))host_spawn_guard);
    nbinds++;
    binds[nbinds].name = "Entity.move";
    binds[nbinds].addr = as_addr((void (*)(void))entity_move);
    nbinds++;

    text = kp_read_file(argv[1], &len);
    if (!text) {
        fprintf(stderr, "skj-kp-patrol: cannot read '%s'\n", argv[1]);
        return 1;
    }
    if (kpm_read(&m, text, len, err, sizeof err) != 0) {
        fprintf(stderr, "skj-kp-patrol: %s\n", err);
        free(text);
        return 1;
    }
    if (kp_jit(&j, &m.prog, binds, nbinds, err, sizeof err) != 0) {
        fprintf(stderr, "skj-kp-patrol: jit: %s\n", err);
        kpm_free(&m);
        free(text);
        return 1;
    }
    entry = kp_jit_entry(&j, m.entry ? m.entry : "main");
    if (!entry) {
        fprintf(stderr, "skj-kp-patrol: no entry in the module\n");
        kp_jit_free(&j);
        kpm_free(&m);
        free(text);
        return 1;
    }
    top = ((uintptr_t)j.stack + j.stack_len) & ~(uintptr_t)15;
    kp_call_guest(entry, (void *)top, iargs, fargs, &fret);

    kp_handle_sweep();   /* finalize the guard handle at teardown ("guard freed") */
    kp_jit_free(&j);
    kpm_free(&m);
    free(text);
    return 0;
}
