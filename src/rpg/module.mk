LIBRARIES += rpg
rpg_DIR   := $(dir $(lastword $(MAKEFILE_LIST)))
rpg_SRCS   = dice.c position.c rpg_char.c stress.c tag.c

EXECUTABLES   += test_dice
test_dice_DIR := $(rpg_DIR)
test_dice_SRCS = test_dice.c
test_dice_LIBS = log

EXECUTABLES  += test_tag
test_tag_DIR := $(rpg_DIR)
test_tag_SRCS = test_tag.c
test_tag_LIBS = log

EXECUTABLES     += test_stress
test_stress_DIR := $(rpg_DIR)
test_stress_SRCS = test_stress.c
test_stress_LIBS = log
