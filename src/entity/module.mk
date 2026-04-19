BORIS_SRCS += \
	src/entity/entity.c

INCLUDES += -Isrc/entity

# --- Test targets ---
TEST_SRCS += src/entity/test_entity.c
TEST_BINS += $(BINDIR)/test_entity
TEST_ENTITY_OBJS := \
	$(BUILDDIR)/src/entity/test_entity.o \
	$(BUILDDIR)/src/entity/entity.o \
	$(BUILDDIR)/src/obj/obj_cache.o \
	$(BUILDDIR)/src/obj/obj.o \
	$(BUILDDIR)/src/hashtable.o \
	$(BUILDDIR)/src/log/log.o

$(BINDIR)/test_entity: $(TEST_ENTITY_OBJS) | $(BINDIR)
	$(CC) $(LDFLAGS) -o $@ $^ $(LDLIBS)
