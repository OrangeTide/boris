BORIS_SRCS += src/net/net.c

INCLUDES += -Isrc/net

# --- Test targets ---
TEST_SRCS += src/net/test_net.c
TEST_BINS += $(BINDIR)/test_net
TEST_NET_OBJS := \
	$(BUILDDIR)/src/net/test_net.o \
	$(BUILDDIR)/src/net/net.o \
	$(BUILDDIR)/src/iox/iox_loop.o \
	$(BUILDDIR)/src/iox/iox_fd.o \
	$(BUILDDIR)/src/iox/iox_signal.o \
	$(BUILDDIR)/src/iox/iox_timer.o

$(BINDIR)/test_net: $(TEST_NET_OBJS) | $(BINDIR)
	$(CC) $(LDFLAGS) -o $@ $^ $(LDLIBS)
