BORIS_SRCS += \
	src/rpg/dice.c \
	src/rpg/rpg_char.c

INCLUDES += -Isrc/rpg

# --- Test targets ---
TEST_SRCS += src/rpg/test_dice.c
TEST_BINS += $(BINDIR)/test_dice
TEST_DICE_OBJS := $(BUILDDIR)/src/rpg/test_dice.o $(BUILDDIR)/src/log/log.o

$(BINDIR)/test_dice: $(TEST_DICE_OBJS) | $(BINDIR)
	$(CC) $(LDFLAGS) -o $@ $^ $(LDLIBS)
