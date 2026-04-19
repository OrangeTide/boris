# ============================================================================
# Boris MUD - GNU Makefile
# ============================================================================

# --- Optional .env for local configuration ----------------------------------
# Variables like DEPLOY_DEST, RELEASE_ARCH, etc.  See env.example.
-include .env

ifdef USE_CLANG
  CC := clang
else
  CC ?= cc
endif

# --- Flags ------------------------------------------------------------------
CFLAGS   := -Wall -W -Werror=implicit -O2 -g -pthread
CPPFLAGS := -DNTEST -DNDEBUG
LDLIBS   := -pthread

# --- Directories ------------------------------------------------------------
# Object files go under build/<triplet>/ so cross-compiles don't clobber
# each other.  Binaries go to bin/ (flat) -- this is what you run and ship.
TARGET_TRIPLET := $(shell $(CC) -dumpmachine 2>/dev/null)
ifdef TARGET_TRIPLET
  BUILDDIR := build/$(TARGET_TRIPLET)
else
  BUILDDIR := build
endif
BINDIR := bin

# --- Source collection (populated by module.mk includes) --------------------
BORIS_SRCS    :=
MKPASS_SRCS   :=
ALL_TOOL_SRCS :=
TEST_SRCS     :=
TEST_BINS     :=
INCLUDES      := -Isrc/thirdparty/jsmn

# --- Default target (must precede module.mk includes that define rules) -----
.DEFAULT_GOAL := all

# --- Include all modules ----------------------------------------------------
include src/module.mk
include src/thirdparty/dyad/module.mk
include src/thirdparty/lmdb/module.mk
include src/thirdparty/mth/module.mk
include src/thirdparty/mongoose/module.mk
include src/thirdparty/tiny-aes/module.mk
include src/iox/module.mk
include src/scrypt/module.mk
include src/passwd/module.mk
include src/log/module.mk
include src/util/module.mk
include src/help/module.mk
include src/web/module.mk
include src/obj/module.mk
include src/entity/module.mk
include src/rpg/module.mk
include src/database/module.mk
include src/muddb-tool/module.mk
include src/tests/module.mk

# --- Derive object lists ----------------------------------------------------
BORIS_OBJS  := $(patsubst %.c,$(BUILDDIR)/%.o,$(BORIS_SRCS))
MKPASS_OBJS := $(patsubst %.c,$(BUILDDIR)/%.o,$(MKPASS_SRCS))
TOOL_OBJS   := $(patsubst %.c,$(BUILDDIR)/%.o,$(ALL_TOOL_SRCS))
TEST_OBJS   := $(patsubst %.c,$(BUILDDIR)/%.o,$(TEST_SRCS))
ALL_OBJS    := $(sort $(BORIS_OBJS) $(MKPASS_OBJS) $(TOOL_OBJS) $(TEST_OBJS))
DEPS        := $(ALL_OBJS:.o=.d)

CFLAGS += $(INCLUDES)

# --- LTO detection ----------------------------------------------------------
LTO_SUPPORTED := $(shell echo 'int main(){return 0;}' \
	| $(CC) -flto=auto -x c - -o /dev/null 2>/dev/null && echo yes)
ifeq ($(LTO_SUPPORTED),yes)
  CFLAGS  += -flto=auto
  LDFLAGS += -flto=auto
endif

# --- Targets ----------------------------------------------------------------
.PHONY: all clean distclean tests

all: $(BINDIR)/boris $(BINDIR)/mkpass $(BINDIR)/muddb-tool

tests: $(TEST_BINS)
	@for t in $(TEST_BINS); do echo "--- Running $$t ---"; ./$$t || exit 1; done

$(BINDIR)/boris: $(BORIS_OBJS) | $(BINDIR)
	$(CC) $(LDFLAGS) -o $@ $^ $(LDLIBS) -lz

$(BINDIR)/mkpass: $(MKPASS_OBJS) | $(BINDIR)
	$(CC) $(LDFLAGS) -o $@ $^ $(LDLIBS)

# --- Compile ----------------------------------------------------------------
$(BUILDDIR)/%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) $(CPPFLAGS) $(CFLAGS) -MMD -MP -c -o $@ $<

# --- Directory creation -----------------------------------------------------
$(BINDIR):
	@mkdir -p $@

# --- Release and deploy -----------------------------------------------------
RELEASE_ARCH ?= $(if $(findstring x86_64,$(TARGET_TRIPLET)),linux-x86_64,\
	$(if $(findstring aarch64,$(TARGET_TRIPLET)),linux-arm64,\
	$(if $(findstring arm,$(TARGET_TRIPLET)),linux-arm32,\
	linux-unknown)))

.PHONY: release deploy

release: install
	./scripts/build-release $(RELEASE_ARCH)

deploy: release
ifndef DEPLOY_DEST
	$(error DEPLOY_DEST is not set. Set it in .env or on the command line)
endif
	./scripts/deploy.sh $(DEPLOY_DEST)

# --- Clean ------------------------------------------------------------------
clean:
	$(RM) $(ALL_OBJS) $(DEPS)
	-find $(BUILDDIR) -type d -empty -delete 2>/dev/null

distclean: clean
	$(RM) $(BINDIR)/boris $(BINDIR)/mkpass $(BINDIR)/muddb-tool $(TEST_BINS)
	-find $(BINDIR)/www -type f -delete 2>/dev/null
	-find $(BINDIR) -type d -empty -delete 2>/dev/null
	-rmdir $(BINDIR) 2>/dev/null

# --- Auto-generated dependencies --------------------------------------------
-include $(DEPS)
