BORIS_SRCS += \
	src/database/muddb.c

INCLUDES += -Isrc/database

# --- Test targets ---
TEST_SRCS += src/database/test_muddb.c
TEST_BINS += $(BINDIR)/test_muddb

TEST_MUDDB_OBJS := \
	$(BUILDDIR)/src/database/test_muddb.o \
	$(BUILDDIR)/src/database/muddb.o \
	$(BUILDDIR)/src/obj/obj.o \
	$(BUILDDIR)/src/log/log.o \
	$(BUILDDIR)/src/thirdparty/lmdb/mdb.o \
	$(BUILDDIR)/src/thirdparty/lmdb/midl.o

$(BINDIR)/test_muddb: $(TEST_MUDDB_OBJS) | $(BINDIR)
	$(CC) $(LDFLAGS) -o $@ $^ $(LDLIBS)
