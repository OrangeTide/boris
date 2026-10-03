# Vendored skjegg RV32 C toolchain: the C compiler, assembler, and linker that
# build guest programs for the VM. Host tools (built with the native CC); they
# run at build time to produce guest ELF images, not part of the server.

SKJTC_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
# Use -iquote, not -I: for #include "..." these dirs are searched before every
# -I dir, so skjegg's own headers (util.h, ir.h, type.h, ...) win over boris's
# same-named headers that the global PROJECT_CPPFLAGS puts on the -I path. Each
# .c also finds its sibling headers from its own directory first.
SKJTC_CPPFLAGS := -iquote$(SKJTC_DIR) -iquote$(SKJTC_DIR)ir -iquote$(SKJTC_DIR)cpp \
                  -iquote$(SKJTC_DIR)cc -iquote$(SKJTC_DIR)backend \
                  -iquote$(SKJTC_DIR)as -iquote$(SKJTC_DIR)ld
# Vendored third-party sources: build quietly rather than police their warnings.
SKJTC_CFLAGS := -std=c99 -O2 -w

# Shared IR core, compiled once and linked into each tool.
LIBRARIES += skjir
skjir_DIR := $(SKJTC_DIR)
skjir_SRCS := ir/ir.c ir/util.c ir/arena.c
skjir_CPPFLAGS := $(SKJTC_CPPFLAGS)
skjir_CFLAGS := $(SKJTC_CFLAGS)

EXECUTABLES += skj-cc-rv
skj-cc-rv_DIR := $(SKJTC_DIR)
skj-cc-rv_SRCS := cc/lex.c cc/parse.c cc/type.c cc/lower.c cc/main.c \
                  cpp/tok.c cpp/macro.c cpp/cond.c cpp/dir.c \
                  backend/regalloc_rv.c backend/rv_select.c backend/rv_mc_text.c
skj-cc-rv_CPPFLAGS := $(SKJTC_CPPFLAGS)
skj-cc-rv_CFLAGS := $(SKJTC_CFLAGS)
skj-cc-rv_LIBS := skjir

EXECUTABLES += skj-as-rv
skj-as-rv_DIR := $(SKJTC_DIR)
skj-as-rv_SRCS := as/rv_main.c as/asm_lex.c as/asm_obj.c as/rv_parse.c \
                  as/rv_encode.c as/rv_macro.c as/rv_elf.c
skj-as-rv_CPPFLAGS := $(SKJTC_CPPFLAGS)
skj-as-rv_CFLAGS := $(SKJTC_CFLAGS)
skj-as-rv_LIBS := skjir

EXECUTABLES += skj-ld-rv
skj-ld-rv_DIR := $(SKJTC_DIR)
skj-ld-rv_SRCS := ld/rv_main.c ld/rv_elf_read.c ld/rv_link.c ld/rv_elf_write.c \
                  ld/rv_archive.c ld/link.c ld/script.c ld/mapfile.c
skj-ld-rv_CPPFLAGS := $(SKJTC_CPPFLAGS)
skj-ld-rv_CFLAGS := $(SKJTC_CFLAGS)
skj-ld-rv_LIBS := skjir
