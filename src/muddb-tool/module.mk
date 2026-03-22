MUDDB_TOOL_SRCS := src/muddb-tool/muddb-tool.c

MUDDB_TOOL_OBJS := \
	$(BUILDDIR)/src/muddb-tool/muddb-tool.o \
	$(BUILDDIR)/src/database/muddb.o \
	$(BUILDDIR)/src/obj/obj.o \
	$(BUILDDIR)/src/log/log.o \
	$(BUILDDIR)/src/thirdparty/lmdb/mdb.o \
	$(BUILDDIR)/src/thirdparty/lmdb/midl.o

ALL_TOOL_SRCS += $(MUDDB_TOOL_SRCS)

$(BINDIR)/muddb-tool: $(MUDDB_TOOL_OBJS) | $(BINDIR)
	$(CC) $(LDFLAGS) -o $@ $^ $(LDLIBS)
