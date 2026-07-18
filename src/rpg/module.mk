LIBRARIES += rpg
rpg_DIR   := $(dir $(lastword $(MAKEFILE_LIST)))
rpg_SRCS   = dice.c position.c rpg_char.c stress.c tag.c

EXECUTABLES   += test_dice
TEST_TARGETS  += test_dice
test_dice_DIR := $(rpg_DIR)
test_dice_SRCS = test_dice.c
test_dice_LIBS = log
define test_dice_TESTCMD
$(test_dice_RUN)
endef

EXECUTABLES  += test_tag
TEST_TARGETS += test_tag
test_tag_DIR := $(rpg_DIR)
test_tag_SRCS = test_tag.c
test_tag_LIBS = obj log
define test_tag_TESTCMD
$(test_tag_RUN)
endef

# test_stress is a long-running stress test; it is built but not part of the
# default 'make check' run.  Run it explicitly with 'make run-test-test_stress'
# after adding it to TEST_TARGETS, or invoke the binary directly.
EXECUTABLES     += test_stress
test_stress_DIR := $(rpg_DIR)
test_stress_SRCS = test_stress.c
test_stress_LIBS = log
