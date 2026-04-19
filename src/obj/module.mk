BORIS_SRCS += \
	src/obj/obj.c \
	src/obj/obj_cache.c \
	src/obj/obj_cache_muddb.c

INCLUDES += -Isrc/obj

# --- Test targets ---
TEST_SRCS += src/obj/test_obj.c
TEST_BINS += $(BINDIR)/test_obj
TEST_OBJ_OBJS := $(BUILDDIR)/src/obj/test_obj.o $(BUILDDIR)/src/log/log.o

$(BINDIR)/test_obj: $(TEST_OBJ_OBJS) | $(BINDIR)
	$(CC) $(LDFLAGS) -o $@ $^ $(LDLIBS)

TEST_SRCS += src/obj/test_obj_cache.c
TEST_BINS += $(BINDIR)/test_obj_cache
TEST_OBJ_CACHE_OBJS := \
	$(BUILDDIR)/src/obj/test_obj_cache.o \
	$(BUILDDIR)/src/obj/obj_cache.o \
	$(BUILDDIR)/src/obj/obj.o \
	$(BUILDDIR)/src/hashtable.o \
	$(BUILDDIR)/src/log/log.o

$(BINDIR)/test_obj_cache: $(TEST_OBJ_CACHE_OBJS) | $(BINDIR)
	$(CC) $(LDFLAGS) -o $@ $^ $(LDLIBS)
