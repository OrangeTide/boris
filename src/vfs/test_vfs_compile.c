/* test_vfs_compile.c : the in-world C, assembly, and Kobold compile pipeline
 * over the VFS.
 *
 * The config-error and language cases always run; they need no toolchain. The
 * live compile drives the real toolchain guests, so it runs only when the
 * environment points at a built SDK (a bare `make check` skips it when the
 * toolchain has not been built with `make -C sdk/vm toolchain`):
 *
 *   VFSCC_TCDIR   directory with skj-{cc,as,ld,kp,kpc}-rv.elf
 *   VFSCC_LIBDIR  directory with the C and Kobold link inputs
 *   VFSCC_INCDIR  guest C header tree (optional; the C cases need it only when
 *                 a source includes a header -- these do not)
 *
 * When the toolchain is present it compiles a C program, an assembly program,
 * and a Kobold-Pascal program from the VFS, checks each result is an RV32 ELF,
 * runs it in the VM to its expected exit status, and exercises the
 * broken-source error path. */

#define _POSIX_C_SOURCE 200809L

#include "vfs_compile.h"
#include "vfs.h"
#include "vm.h"

#include "cas.h"
#include "cas-tree.h"

#include "ctest.h"

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

static char tmpdir[] = "/tmp/test_vfs_compile_XXXXXX";

static void
cleanup(void)
{
	char cmd[512];

	snprintf(cmd, sizeof cmd, "rm -rf %s", tmpdir);
	if (system(cmd)) { /* best effort */ }
}

/* A C guest with no includes: main returns 7, so the program exits 7. */
static const char CSRC[] =
	"int main(void) { return 7; }\n";

/* An assembly guest: main returns 5, so the program exits 5. */
static const char ASMSRC[] =
	"\t.text\n"
	"\t.globl main\n"
	"main:\n"
	"\tli a0, 5\n"
	"\tret\n";

/* A Kobold-Pascal guest: Halt(9) sets the exit status, so the program exits 9. */
static const char PASSRC[] =
	"program t;\n"
	"begin\n"
	"  WriteLn('kobold ok');\n"
	"  Halt(9);\n"
	"end.\n";

/* A C source the front end rejects, so the compile stage fails. */
static const char BROKEN[] =
	"int main(void) { this is not C $$$ }\n";

/* Run an in-memory ELF to completion, returning its exit status or -1. */
static int
run_image(const uint8_t *elf, size_t len)
{
	struct vm_task *t = vm_task_new(0);
	enum vm_state st;
	int slices = 0, status;

	if (!t) {
		fprintf(stderr, "run_image: vm_task_new failed\n");
		return -1;
	}
	if (vm_task_load_mem(t, elf, (long)len, "compiled.elf") != 0) {
		fprintf(stderr, "run_image: load_mem failed (len=%zu)\n", len);
		vm_task_free(t);
		return -1;
	}
	do {
		st = vm_task_run(t, 8192);
		if (st == VM_READY && vm_task_blocked(t)) {
			fprintf(stderr, "run_image: parked (blocked) after %d slices\n", slices);
			vm_task_free(t);
			return -1;
		}
	} while (st == VM_READY && ++slices < 200000);
	if (st != VM_EXITED) {
		fprintf(stderr, "run_image: state=%d after %d slices (not exited)\n",
		        (int)st, slices);
		vm_task_free(t);
		return -1;
	}
	status = vm_task_exit_status(t);
	vm_task_free(t);
	return status;
}

/* Compile src_text (staged at src_path) to out_path, assert it is an RV32 ELF,
 * run it, and assert the exit status. */
static void
compile_and_run(struct vfs *v, const struct vfs_compile_cfg *cfg,
	const char *src_path, const char *src_text, const char *out_path,
	int want_exit, const char *what)
{
	char err[4096] = "";
	void *out = NULL;
	size_t outlen = 0;
	int rc;

	EXPECT_EQ(vfs_write(v, src_path, src_text, strlen(src_text)), VFS_OK,
	          "staged source in the VFS");
	rc = vfs_compile(v, src_path, out_path, cfg, err, sizeof err);
	if (rc != VFS_COMPILE_OK)
		fprintf(stderr, "%s: compile error: %s\n", what, err);
	EXPECT_EQ(rc, VFS_COMPILE_OK, what);
	if (rc != VFS_COMPILE_OK)
		return;
	EXPECT_EQ(vfs_read(v, out_path, &out, &outlen), VFS_OK,
	          "the ELF landed in the VFS");
	if (out && outlen > 20) {
		const uint8_t *e = out;

		EXPECT(e[0] == 0x7f && e[1] == 'E' && e[2] == 'L' && e[3] == 'F',
		       "output has the ELF magic");
		EXPECT(e[4] == 1, "output is 32-bit (ELFCLASS32)");
		EXPECT(e[18] == 243 && e[19] == 0, "output targets RISC-V");
		EXPECT_EQ(run_image(e, outlen), want_exit, "the program runs to its exit");
	}
	free(out);
}

int
main(void)
{
	struct cas *store;
	struct cas_tree *ct;
	struct vfs *v;
	char depot[512];
	char err[4096];
	struct vfs_compile_cfg cfg;
	const char *tcdir;

	if (!mkdtemp(tmpdir)) {
		FAIL("mkdtemp");
		return ctest_report("vfs_compile");
	}
	atexit(cleanup);
	snprintf(depot, sizeof depot, "%s/depot", tmpdir);
	store = cas_new(depot);
	EXPECT(store != NULL, "cas depot opened");
	ct = cas_tree_new(store);
	EXPECT(ct != NULL, "cas tree created");
	v = vfs_new(ct, "vfs");
	EXPECT(v != NULL, "vfs opened");
	if (!v) {
		cas_tree_free(ct);
		cas_free(store);
		return ctest_report("vfs_compile");
	}

	EXPECT_EQ(vfs_write(v, "/src/a.c", CSRC, sizeof CSRC - 1), VFS_OK,
	          "staged a C source in the VFS");

	/* Config-error cases: no toolchain needed. */
	memset(&cfg, 0, sizeof cfg);
	EXPECT_EQ(vfs_compile(v, "/src/a.c", "/bin/a.elf", &cfg, err, sizeof err),
	          VFS_COMPILE_ECFG, "a NULL-field config is rejected");

	cfg.toolchain_dir = "/nonexistent/toolchain";
	cfg.lib_dir = "/nonexistent/lib";
	err[0] = '\0';
	EXPECT_EQ(vfs_compile(v, "/src/a.c", "/bin/a.elf", &cfg, err, sizeof err),
	          VFS_COMPILE_ECFG, "a bogus toolchain path is rejected");
	EXPECT(err[0] != '\0', "the config error names what is missing");

	/* The language is chosen by extension before any config check. */
	err[0] = '\0';
	EXPECT_EQ(vfs_compile(v, "/src/a.txt", "/bin/a.elf", &cfg, err, sizeof err),
	          VFS_COMPILE_ELANG, "an unknown source extension is rejected");

	/* Live compile: only when a built toolchain is present. The paths come from
	 * the environment, or default to the in-tree SDK output relative to the repo
	 * root (where `make check` runs), so the live part runs whenever the
	 * toolchain was built and skips cleanly otherwise. */
	tcdir = getenv("VFSCC_TCDIR");
	if (!tcdir)
		tcdir = "data/vm/toolchain";
	{
		char probe[512];

		snprintf(probe, sizeof probe, "%s/skj-ld-rv.elf", tcdir);
		if (access(probe, R_OK) == 0) {
			const char *libdir = getenv("VFSCC_LIBDIR");
			const char *incdir = getenv("VFSCC_INCDIR");

			memset(&cfg, 0, sizeof cfg);
			cfg.toolchain_dir = tcdir;
			cfg.lib_dir = libdir ? libdir : "data/vm/lib";
			cfg.include_dir = incdir ? incdir : "sdk/toolchain/skjegg/include";
			cfg.workdir = tmpdir;

			compile_and_run(v, &cfg, "/src/a.c", CSRC, "/bin/a.elf", 7,
			                "a.c compiles and exits 7");
			compile_and_run(v, &cfg, "/src/b.s", ASMSRC, "/bin/b.elf", 5,
			                "b.s compiles and exits 5");
			compile_and_run(v, &cfg, "/src/t.pas", PASSRC, "/bin/t.elf", 9,
			                "t.pas compiles and exits 9");

			/* A broken C source fails in the compile stage. */
			EXPECT_EQ(vfs_write(v, "/src/bad.c", BROKEN, sizeof BROKEN - 1),
			          VFS_OK, "staged a broken C source");
			err[0] = '\0';
			EXPECT_EQ(vfs_compile(v, "/src/bad.c", "/bin/bad.elf", &cfg,
			                      err, sizeof err),
			          VFS_COMPILE_ESTAGE, "a broken source fails a stage");
			EXPECT(err[0] != '\0', "the stage error carries a diagnostic");
		} else {
			fprintf(stderr, "vfs_compile: toolchain not built at %s, "
			        "skipping live compile\n", tcdir);
		}
	}

	vfs_free(v);
	cas_tree_free(ct);
	cas_free(store);
	return ctest_report("vfs_compile");
}
