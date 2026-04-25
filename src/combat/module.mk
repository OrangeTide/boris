LIBRARIES   += combat
combat_DIR  := $(dir $(lastword $(MAKEFILE_LIST)))
combat_SRCS  = combat.c

EXECUTABLES      += test_combat
TEST_TARGETS     += test_combat
test_combat_DIR  := $(combat_DIR)
test_combat_SRCS  = test_combat.c
test_combat_LIBS  = combat util log
define test_combat_TESTCMD
$(test_combat_RUN)
endef
