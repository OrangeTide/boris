BORIS_SRCS += \
	src/util/util.c \
	src/util/grow.c \
	src/util/variables.c \
	src/util/wordwrap.c

INCLUDES += -Isrc/util

# --- Test targets ---
TEST_SRCS += src/util/test_variables.c
TEST_BINS += $(BINDIR)/test_variables
TEST_VARIABLES_OBJS := \
	$(BUILDDIR)/src/util/test_variables.o \
	$(BUILDDIR)/src/util/variables.o

$(BINDIR)/test_variables: $(TEST_VARIABLES_OBJS) | $(BINDIR)
	$(CC) $(LDFLAGS) -o $@ $^ $(LDLIBS)
