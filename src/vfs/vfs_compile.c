/* vfs_compile.c : the in-world guest compile pipeline over the VFS.
 * C, assembly, and Kobold-Pascal, chosen by the source extension. The toolchain
 * stages run as RV32 guests under the embedded runtime, each confined to the
 * build directory through a hostcap mount, so the pipeline needs no host
 * execve. See vfs_compile.h. */

#define _POSIX_C_SOURCE 200809L
#define LOG_SUBSYSTEM "vfs_compile"

#include "vfs_compile.h"
#include "vfs.h"

#include <vm.h>
#include <log.h>

#include <dirent.h>
#include <errno.h>
#include <stdarg.h>
#include <fcntl.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>

/* A stage's captured diagnostics are bounded; a real message fits well under
 * it. */
#define CAP_MAX 4096

/* The toolchain is a big batch guest: raise the per-task caps well above an
 * interactive verb's. These mirror skj-run's own defaults. */
#define TC_MEM   (256u * 1024u * 1024u)
#define TC_HEAP  (16u * 1024u * 1024u)
#define TC_STACK (1u * 1024u * 1024u)

/* A compile stage runs until it exits; cap the work so a stuck stage cannot
 * stall the server. Each vm_task_run slice advances a large instruction budget;
 * the product bounds the worst case. */
#define TC_SLICE_INSNS (1u << 24)       /* ~16M instructions per run call */
#define TC_MAX_SLICES  4096             /* overall ceiling before giving up */

/* The mount names the stages see: the build directory (read-write) and the
 * guest C header tree (read-only, for the C front end). */
#define MNT_BUILD "w"
#define MNT_INC   "i"

/* The most link inputs any language stages (the C set is the larger). */
#define N_LINK_MAX 5

/* The link inputs a program needs, staged from lib_dir into the build dir and
 * passed to the linker in this order with the compiled object inserted at
 * obj_at. A C or assembly program links the crt, the varargs and soft-divide
 * helpers, the object, the libc archive, and the finalizer. A Kobold program
 * links its own crt, the object, and the freestanding runtime archive. */
struct link_spec {
	const char *const *inputs;      /* staged files, in link order           */
	int                n;           /* how many                              */
	int                obj_at;      /* where the compiled object goes among them */
};

static const char *const C_INPUTS[] = {
	"crt0.o", "va_rv.o", "soft64_div.o", "libc.a", "fini.o",
};
static const char *const KP_INPUTS[] = {
	"kp_crt_rv.o", "libkpaot-rv-free.a",
};
static const struct link_spec C_LINK  = { C_INPUTS, 5, 3 };
static const struct link_spec KP_LINK = { KP_INPUTS, 2, 1 };

/* Append up to a terminating NUL, never overflowing errsz. A NULL errbuf is a
 * no-op, so callers that do not want diagnostics pass NULL. */
static void
err_set(char *errbuf, size_t errsz, const char *fmt, ...)
{
	va_list ap;

	if (!errbuf || errsz == 0)
		return;
	va_start(ap, fmt);
	vsnprintf(errbuf, errsz, fmt, ap);
	va_end(ap);
}

/* Fill dst with "<a>/<b>", bounded. */
static void
join(char *dst, size_t dstsz, const char *a, const char *b)
{
	snprintf(dst, dstsz, "%s/%s", a, b);
}

/* The leaf of a VFS path with its last extension removed, into base[basesz].
 * "/src/greet.c" -> "greet". Falls back to "out" for a degenerate name. */
static void
base_name(const char *path, char *base, size_t basesz)
{
	const char *leaf = strrchr(path, '/');
	const char *dot;
	size_t n;

	leaf = leaf ? leaf + 1 : path;
	dot = strrchr(leaf, '.');
	n = dot ? (size_t)(dot - leaf) : strlen(leaf);
	if (n == 0 || n >= basesz) {
		snprintf(base, basesz, "out");
		return;
	}
	memcpy(base, leaf, n);
	base[n] = '\0';
}

/* Remove a directory and the regular files directly in it (the pipeline writes
 * no subdirectories). Best effort. */
static void
rm_workdir(const char *dir)
{
	DIR *d = opendir(dir);
	struct dirent *de;
	char p[VFS_PATH_MAX];

	if (d) {
		while ((de = readdir(d))) {
			if (strcmp(de->d_name, ".") == 0 ||
			    strcmp(de->d_name, "..") == 0)
				continue;
			join(p, sizeof p, dir, de->d_name);
			unlink(p);
		}
		closedir(d);
	}
	rmdir(dir);
}

/* Write len bytes to a host file. Returns 0 or -1. */
static int
spill(const char *path, const void *data, size_t len)
{
	int fd = open(path, O_WRONLY | O_CREAT | O_TRUNC, 0600);
	const char *p = data;
	size_t left = len;

	if (fd < 0)
		return -1;
	while (left) {
		ssize_t n = write(fd, p, left);

		if (n < 0) {
			close(fd);
			return -1;
		}
		p += n;
		left -= (size_t)n;
	}
	return close(fd) == 0 ? 0 : -1;
}

/* Slurp a host file into a freshly malloc'd buffer. Returns 0 (caller frees
 * *out) or -1. */
static int
slurp(const char *path, void **out, size_t *len_out)
{
	int fd = open(path, O_RDONLY);
	struct stat sb;
	uint8_t *buf;
	size_t off = 0;

	if (fd < 0)
		return -1;
	if (fstat(fd, &sb) != 0 || sb.st_size < 0) {
		close(fd);
		return -1;
	}
	buf = malloc((size_t)sb.st_size ? (size_t)sb.st_size : 1);
	if (!buf) {
		close(fd);
		return -1;
	}
	while (off < (size_t)sb.st_size) {
		ssize_t n = read(fd, buf + off, (size_t)sb.st_size - off);

		if (n <= 0) {
			free(buf);
			close(fd);
			return -1;
		}
		off += (size_t)n;
	}
	close(fd);
	*out = buf;
	*len_out = off;
	return 0;
}

/* Copy a host file from src to dst. Returns 0 or -1. */
static int
copy_file(const char *src, const char *dst)
{
	void *buf = NULL;
	size_t len = 0;
	int rc;

	if (slurp(src, &buf, &len) != 0)
		return -1;
	rc = spill(dst, buf, len);
	free(buf);
	return rc;
}

/* The guest languages the pipeline knows, chosen by the source extension. */
enum lang { LANG_C, LANG_ASM, LANG_PAS };

/* The link inputs a language links against. */
static const struct link_spec *
link_spec_for(enum lang lang)
{
	return lang == LANG_PAS ? &KP_LINK : &C_LINK;
}

/* The language a source path names, or -1 for an unknown extension. */
static int
detect_lang(const char *path)
{
	const char *leaf = strrchr(path, '/');
	const char *ext;

	leaf = leaf ? leaf + 1 : path;
	ext = strrchr(leaf, '.');
	if (!ext)
		return -1;
	if (strcmp(ext, ".c") == 0)
		return LANG_C;
	if (strcmp(ext, ".s") == 0 || strcmp(ext, ".S") == 0)
		return LANG_ASM;
	if (strcmp(ext, ".pas") == 0 || strcmp(ext, ".kp") == 0)
		return LANG_PAS;
	return -1;
}

/* A configured file must be readable. */
static int
need_file(const char *path, const char *what, char *errbuf, size_t errsz)
{
	if (!path) {
		err_set(errbuf, errsz, "no %s configured", what);
		return -1;
	}
	if (access(path, R_OK) != 0) {
		err_set(errbuf, errsz, "missing %s: %s", what, path);
		return -1;
	}
	return 0;
}

/* Validate the config for the chosen language: the stage ELFs it runs and the
 * link inputs it stages must all exist. */
static int
cfg_ok(const struct vfs_compile_cfg *cfg, enum lang lang, char *errbuf,
	size_t errsz)
{
	const struct link_spec *ls = link_spec_for(lang);
	char p[VFS_PATH_MAX];
	int i;

	if (!cfg || !cfg->toolchain_dir || !cfg->lib_dir) {
		err_set(errbuf, errsz, "incomplete compile configuration");
		return -1;
	}
	join(p, sizeof p, cfg->toolchain_dir, "skj-as-rv.elf");
	if (need_file(p, "assembler", errbuf, errsz) != 0)
		return -1;
	join(p, sizeof p, cfg->toolchain_dir, "skj-ld-rv.elf");
	if (need_file(p, "linker", errbuf, errsz) != 0)
		return -1;
	if (lang == LANG_C) {
		join(p, sizeof p, cfg->toolchain_dir, "skj-cc-rv.elf");
		if (need_file(p, "compiler", errbuf, errsz) != 0)
			return -1;
	}
	if (lang == LANG_PAS) {
		join(p, sizeof p, cfg->toolchain_dir, "skj-kpc-rv.elf");
		if (need_file(p, "Kobold front end", errbuf, errsz) != 0)
			return -1;
		join(p, sizeof p, cfg->toolchain_dir, "skj-kp-rv.elf");
		if (need_file(p, "Kobold backend", errbuf, errsz) != 0)
			return -1;
	}
	for (i = 0; i < ls->n; i++) {
		join(p, sizeof p, cfg->lib_dir, ls->inputs[i]);
		if (need_file(p, ls->inputs[i], errbuf, errsz) != 0)
			return -1;
	}
	return 0;
}

/* Capture context for a stage's console output (its diagnostics). */
struct cap_ctx {
	char  *buf;
	size_t sz;
	size_t used;
};

static void
cap_sink(void *ctx, const char *buf, size_t len)
{
	struct cap_ctx *c = ctx;
	size_t room;

	if (!c || !c->buf || c->sz == 0)
		return;
	room = c->sz - 1 - c->used;
	if (room == 0)
		return;
	if (len > room)
		len = room;
	memcpy(c->buf + c->used, buf, len);
	c->used += len;
	c->buf[c->used] = '\0';
}

/* Run one toolchain stage ELF as a guest confined to builddir (and, for the C
 * front end, the read-only include tree). argv[0] is the tool name; the file
 * arguments are mount-prefixed (w:foo.c). Diagnostics the stage prints are
 * captured into cap (NUL-terminated, bounded). Returns the guest exit status
 * (0 on success), or -1 if the stage could not run or did not exit cleanly. */
static int
run_stage(const char *elf_path, const char *builddir, const char *incdir,
	const char *const argv[], int argc, char *cap, size_t capsz)
{
	struct vm_task *t;
	struct cap_ctx cc = { cap, capsz, 0 };
	enum vm_state st = VM_FAULTED;
	int slices;

	if (capsz)
		cap[0] = '\0';
	t = vm_task_new(0);
	if (!t)
		return -1;
	vm_task_set_limits(t, TC_MEM, TC_HEAP, TC_STACK);
	vm_task_set_output(t, cap_sink, &cc);
	if (vm_task_add_mount(t, MNT_BUILD, builddir, 0) != 0 ||
	    (incdir && vm_task_add_mount(t, MNT_INC, incdir, 1) != 0)) {
		vm_task_free(t);
		return -1;
	}
	if (vm_task_load_file(t, elf_path) != 0) {
		vm_task_free(t);
		return -1;
	}
	if (vm_task_set_args(t, argv, argc) != 0) {
		vm_task_free(t);
		return -1;
	}
	for (slices = 0; slices < TC_MAX_SLICES; slices++) {
		st = vm_task_run(t, TC_SLICE_INSNS);
		if (st != VM_READY)
			break;
		if (vm_task_blocked(t))         /* a batch stage never blocks */
			break;
	}
	if (st == VM_EXITED) {
		int rc = vm_task_exit_status(t);

		vm_task_free(t);
		return rc;
	}
	vm_task_free(t);
	return -1;
}

/* Build the mount-relative name "w:<leaf>" for a file in the build dir. */
static void
wpath(char *dst, size_t dstsz, const char *leaf)
{
	snprintf(dst, dstsz, "%s:%s", MNT_BUILD, leaf);
}

/* Link the staged object base.o into base.elf with the language's start files
 * and runtime, all staged in the build dir. The link inputs come in link order
 * from the language's link spec, with the object inserted at obj_at. Returns
 * VFS_COMPILE_OK or a negative code with warn filled. */
static int
link_object(const struct vfs_compile_cfg *cfg, enum lang lang,
	const char *builddir, const char *base, char *warn, size_t warnsz)
{
	const struct link_spec *ls = link_spec_for(lang);
	char w_o[VFS_PATH_MAX], w_elf[VFS_PATH_MAX], w_in[N_LINK_MAX][VFS_PATH_MAX];
	char tool[VFS_PATH_MAX];
	const char *argv[4 + N_LINK_MAX + 1];
	char cap[CAP_MAX - 64];       /* smaller than warn, so the prefix always fits */
	int n = 0, i, st;

	join(tool, sizeof tool, cfg->toolchain_dir, "skj-ld-rv.elf");
	snprintf(w_o, sizeof w_o, "%s:%s.o", MNT_BUILD, base);
	snprintf(w_elf, sizeof w_elf, "%s:%s.elf", MNT_BUILD, base);

	argv[n++] = "skj-ld-rv";
	argv[n++] = "-o";
	argv[n++] = w_elf;
	for (i = 0; i < ls->n; i++) {
		if (i == ls->obj_at)
			argv[n++] = w_o;        /* the compiled object, at its place */
		wpath(w_in[i], sizeof w_in[i], ls->inputs[i]);
		argv[n++] = w_in[i];
	}
	if (ls->obj_at == ls->n)                /* object after every input */
		argv[n++] = w_o;

	st = run_stage(tool, builddir, NULL, argv, n, cap, sizeof cap);
	if (st != 0) {
		snprintf(warn, warnsz, "stage ld failed (exit %d):\n%s", st, cap);
		return VFS_COMPILE_ESTAGE;
	}
	return VFS_COMPILE_OK;
}

int
vfs_compile(struct vfs *v, const char *src_path, const char *out_path,
	const struct vfs_compile_cfg *cfg, char *errbuf, size_t errsz)
{
	char base[64];
	char tmpl[512];
	char f_src[VFS_PATH_MAX], f_elf[VFS_PATH_MAX], f_in[VFS_PATH_MAX];
	char lib_src[VFS_PATH_MAX];
	char w_src[VFS_PATH_MAX], w_s[VFS_PATH_MAX], w_o[VFS_PATH_MAX];
	char w_kpm[VFS_PATH_MAX], inc_flag[16];
	char tool[VFS_PATH_MAX];
	char cap[CAP_MAX];
	const struct link_spec *ls;
	const char *tmproot;
	const char *srcext;
	void *src = NULL, *elf = NULL;
	size_t srclen = 0, elflen = 0;
	int rc = VFS_COMPILE_EINTERNAL;
	int lang, i, st;

	lang = detect_lang(src_path);
	if (lang < 0) {
		err_set(errbuf, errsz,
		        "unknown source language for %s (want .c, .s/.S, or .pas/.kp)",
		        src_path);
		return VFS_COMPILE_ELANG;
	}
	if (cfg_ok(cfg, (enum lang)lang, errbuf, errsz) != 0)
		return VFS_COMPILE_ECFG;
	if (vfs_read(v, src_path, &src, &srclen) != VFS_OK) {
		err_set(errbuf, errsz, "cannot read source %s from the VFS", src_path);
		return VFS_COMPILE_ESRC;
	}

	ls = link_spec_for((enum lang)lang);
	base_name(src_path, base, sizeof base);
	srcext = lang == LANG_C ? ".c" : lang == LANG_PAS ? ".pas" : ".s";

	tmproot = cfg->workdir ? cfg->workdir : "/tmp";
	(void)mkdir(tmproot, 0700);     /* create the build-dir parent if absent */
	snprintf(tmpl, sizeof tmpl, "%s/vfscc-XXXXXX", tmproot);
	if (!mkdtemp(tmpl)) {
		LOG_ERROR("mkdtemp(%s): %s", tmpl, strerror(errno));
		err_set(errbuf, errsz, "cannot create a build dir under %s", tmproot);
		free(src);
		return VFS_COMPILE_EINTERNAL;
	}

	/* Stage the source and the link inputs into the build dir. */
	snprintf(f_src, sizeof f_src, "%s/%s%s", tmpl, base, srcext);
	if (spill(f_src, src, srclen) != 0) {
		err_set(errbuf, errsz, "cannot stage source to %s", f_src);
		rc = VFS_COMPILE_EINTERNAL;
		goto done;
	}
	for (i = 0; i < ls->n; i++) {
		join(lib_src, sizeof lib_src, cfg->lib_dir, ls->inputs[i]);
		join(f_in, sizeof f_in, tmpl, ls->inputs[i]);
		if (copy_file(lib_src, f_in) != 0) {
			err_set(errbuf, errsz, "cannot stage link input %s", ls->inputs[i]);
			rc = VFS_COMPILE_EINTERNAL;
			goto done;
		}
	}

	snprintf(w_src, sizeof w_src, "%s:%s%s", MNT_BUILD, base, srcext);
	snprintf(w_s, sizeof w_s, "%s:%s.s", MNT_BUILD, base);
	snprintf(w_o, sizeof w_o, "%s:%s.o", MNT_BUILD, base);
	snprintf(w_kpm, sizeof w_kpm, "%s:%s.kpm", MNT_BUILD, base);

	if (lang == LANG_C) {
		/* Stage 1: compile. skj-cc-rv [-Ii:] -o w:base.s w:base.c */
		const char *argv[6];
		int n = 0;

		join(tool, sizeof tool, cfg->toolchain_dir, "skj-cc-rv.elf");
		argv[n++] = "skj-cc-rv";
		if (cfg->include_dir) {
			snprintf(inc_flag, sizeof inc_flag, "-I%s:", MNT_INC);
			argv[n++] = inc_flag;
		}
		argv[n++] = "-o";
		argv[n++] = w_s;
		argv[n++] = w_src;
		st = run_stage(tool, tmpl, cfg->include_dir, argv, n, cap, sizeof cap);
		if (st != 0) {
			err_set(errbuf, errsz, "stage cc failed (exit %d):\n%s", st, cap);
			rc = VFS_COMPILE_ESTAGE;
			goto done;
		}
		/* Stage 2: assemble. skj-as-rv -o w:base.o w:base.s */
		join(tool, sizeof tool, cfg->toolchain_dir, "skj-as-rv.elf");
		{
			const char *aargv[] = { "skj-as-rv", "-o", w_o, w_s };

			st = run_stage(tool, tmpl, NULL, aargv, 4, cap, sizeof cap);
			if (st != 0) {
				err_set(errbuf, errsz, "stage as failed (exit %d):\n%s", st, cap);
				rc = VFS_COMPILE_ESTAGE;
				goto done;
			}
		}
	} else if (lang == LANG_PAS) {
		/* Stage 1: front end. skj-kpc-rv --emit-kpm -o w:base.kpm w:base.pas */
		const char *kargv[] = {
			"skj-kpc-rv", "--emit-kpm", "-o", w_kpm, w_src
		};

		join(tool, sizeof tool, cfg->toolchain_dir, "skj-kpc-rv.elf");
		st = run_stage(tool, tmpl, NULL, kargv, 5, cap, sizeof cap);
		if (st != 0) {
			err_set(errbuf, errsz, "stage kpc failed (exit %d):\n%s", st, cap);
			rc = VFS_COMPILE_ESTAGE;
			goto done;
		}
		/* Stage 2: backend. skj-kp-rv w:base.kpm -o w:base.s */
		join(tool, sizeof tool, cfg->toolchain_dir, "skj-kp-rv.elf");
		{
			const char *bargv[] = { "skj-kp-rv", w_kpm, "-o", w_s };

			st = run_stage(tool, tmpl, NULL, bargv, 4, cap, sizeof cap);
			if (st != 0) {
				err_set(errbuf, errsz, "stage kp failed (exit %d):\n%s", st, cap);
				rc = VFS_COMPILE_ESTAGE;
				goto done;
			}
		}
		/* Stage 3: assemble. skj-as-rv -o w:base.o w:base.s */
		join(tool, sizeof tool, cfg->toolchain_dir, "skj-as-rv.elf");
		{
			const char *aargv[] = { "skj-as-rv", "-o", w_o, w_s };

			st = run_stage(tool, tmpl, NULL, aargv, 4, cap, sizeof cap);
			if (st != 0) {
				err_set(errbuf, errsz, "stage as failed (exit %d):\n%s", st, cap);
				rc = VFS_COMPILE_ESTAGE;
				goto done;
			}
		}
	} else {
		/* LANG_ASM: one stage. skj-as-rv -o w:base.o w:base.s */
		const char *aargv[] = { "skj-as-rv", "-o", w_o, w_src };

		join(tool, sizeof tool, cfg->toolchain_dir, "skj-as-rv.elf");
		st = run_stage(tool, tmpl, NULL, aargv, 4, cap, sizeof cap);
		if (st != 0) {
			err_set(errbuf, errsz, "stage as failed (exit %d):\n%s", st, cap);
			rc = VFS_COMPILE_ESTAGE;
			goto done;
		}
	}

	/* Link. */
	rc = link_object(cfg, (enum lang)lang, tmpl, base, cap, sizeof cap);
	if (rc != VFS_COMPILE_OK) {
		err_set(errbuf, errsz, "%s", cap);
		goto done;
	}

	snprintf(f_elf, sizeof f_elf, "%s/%s.elf", tmpl, base);
	if (slurp(f_elf, &elf, &elflen) != 0) {
		err_set(errbuf, errsz, "cannot read the linked image %s", f_elf);
		rc = VFS_COMPILE_EOUT;
		goto done;
	}
	if (vfs_write(v, out_path, elf, elflen) != VFS_OK) {
		err_set(errbuf, errsz, "cannot write %s to the VFS", out_path);
		rc = VFS_COMPILE_EOUT;
		goto done;
	}
	LOG_INFO("compiled %s -> %s (%zu bytes)", src_path, out_path, elflen);
	if (errbuf && errsz)          /* success: hand back any warnings, else "" */
		errbuf[0] = '\0';
	rc = VFS_COMPILE_OK;

done:
	rm_workdir(tmpl);
	free(src);
	free(elf);
	return rc;
}
