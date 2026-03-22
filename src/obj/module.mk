BORIS_SRCS += \
	src/obj/obj.c

INCLUDES += -Isrc/obj

# --- Test targets ---
TEST_SRCS += src/obj/test_obj.c
TEST_BINS += $(BINDIR)/test_obj
TEST_OBJ_OBJS := $(BUILDDIR)/src/obj/test_obj.o $(BUILDDIR)/src/log/log.o

$(BINDIR)/test_obj: $(TEST_OBJ_OBJS) | $(BINDIR)
	$(CC) $(LDFLAGS) -o $@ $^ $(LDLIBS)
