BORIS_SRCS += \
	src/rpg/dice.c \
	src/rpg/position.c \
	src/rpg/rpg_char.c \
	src/rpg/stress.c \
	src/rpg/tag.c

INCLUDES += -Isrc/rpg

# --- Test targets ---
TEST_SRCS += src/rpg/test_dice.c
TEST_BINS += $(BINDIR)/test_dice
TEST_DICE_OBJS := $(BUILDDIR)/src/rpg/test_dice.o $(BUILDDIR)/src/log/log.o

$(BINDIR)/test_dice: $(TEST_DICE_OBJS) | $(BINDIR)
	$(CC) $(LDFLAGS) -o $@ $^ $(LDLIBS)

TEST_SRCS += src/rpg/test_tag.c
TEST_BINS += $(BINDIR)/test_tag
TEST_TAG_OBJS := $(BUILDDIR)/src/rpg/test_tag.o $(BUILDDIR)/src/log/log.o

$(BINDIR)/test_tag: $(TEST_TAG_OBJS) | $(BINDIR)
	$(CC) $(LDFLAGS) -o $@ $^ $(LDLIBS)

TEST_SRCS += src/rpg/test_stress.c
TEST_BINS += $(BINDIR)/test_stress
TEST_STRESS_OBJS := $(BUILDDIR)/src/rpg/test_stress.o $(BUILDDIR)/src/log/log.o

$(BINDIR)/test_stress: $(TEST_STRESS_OBJS) | $(BINDIR)
	$(CC) $(LDFLAGS) -o $@ $^ $(LDLIBS)
