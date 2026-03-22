# ============================================================================
# Boris MUD - GNU Makefile
# ============================================================================

ifdef USE_CLANG
  CC := clang
else
  CC ?= cc
endif

# --- Flags ------------------------------------------------------------------
CFLAGS   := -Wall -W -O2 -g -pthread
CPPFLAGS := -DNTEST -DNDEBUG
LDLIBS   := -pthread

# --- Directories ------------------------------------------------------------
BUILDDIR := build
BINDIR   := bin

# --- Source collection (populated by module.mk includes) --------------------
BORIS_SRCS  :=
MKPASS_SRCS :=
TEST_SRCS   :=
TEST_BINS   :=
INCLUDES    := -Isrc/thirdparty/jsmn

# --- Default target (must precede module.mk includes that define rules) -----
.DEFAULT_GOAL := all

# --- Include all modules ----------------------------------------------------
include src/module.mk
include src/thirdparty/dyad/module.mk
include src/thirdparty/lmdb/module.mk
include src/thirdparty/mth/module.mk
include src/thirdparty/mongoose/module.mk
include src/thirdparty/tiny-aes/module.mk
include src/scrypt/module.mk
include src/passwd/module.mk
include src/log/module.mk
include src/util/module.mk
include src/help/module.mk
include src/web/module.mk
include src/obj/module.mk
include src/database/module.mk
include src/tests/module.mk

# --- Derive object lists ----------------------------------------------------
BORIS_OBJS  := $(patsubst %.c,$(BUILDDIR)/%.o,$(BORIS_SRCS))
MKPASS_OBJS := $(patsubst %.c,$(BUILDDIR)/%.o,$(MKPASS_SRCS))
TEST_OBJS   := $(patsubst %.c,$(BUILDDIR)/%.o,$(TEST_SRCS))
ALL_OBJS    := $(sort $(BORIS_OBJS) $(MKPASS_OBJS) $(TEST_OBJS))
DEPS        := $(ALL_OBJS:.o=.d)

CFLAGS += $(INCLUDES)

# --- LTO detection ----------------------------------------------------------
LTO_SUPPORTED := $(shell echo 'int main(){return 0;}' \
	| $(CC) -flto -x c - -o /dev/null 2>/dev/null && echo yes)
ifeq ($(LTO_SUPPORTED),yes)
  CFLAGS  += -flto
  LDFLAGS += -flto
endif

# --- Targets ----------------------------------------------------------------
.PHONY: all clean distclean tests

all: $(BINDIR)/boris $(BINDIR)/mkpass

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

# --- Clean ------------------------------------------------------------------
clean:
	$(RM) $(ALL_OBJS) $(DEPS)
	-find $(BUILDDIR) -type d -empty -delete 2>/dev/null

distclean: clean
	$(RM) $(BINDIR)/boris $(BINDIR)/mkpass $(TEST_BINS)
	$(RM) $(BINDIR)/www/index.html
	$(RM) $(BINDIR)/www/assets/layout.css $(BINDIR)/www/assets/system.css
	$(RM) $(BINDIR)/www/assets/favicon.ico
	-find $(BINDIR)/www -type f -delete 2>/dev/null
	-find $(BINDIR)/www -type d -empty -delete 2>/dev/null
	-rmdir $(BINDIR) 2>/dev/null

# --- Auto-generated dependencies --------------------------------------------
-include $(DEPS)
