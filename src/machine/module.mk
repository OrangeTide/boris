LIBRARIES   += machine
machine_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
machine_SRCS = machine.c

EXECUTABLES      += test_machine
TEST_TARGETS     += test_machine
test_machine_DIR  := $(machine_DIR)
test_machine_SRCS  = test_machine.c
test_machine_LIBS  = machine coldfire log
define test_machine_TESTCMD
$(test_machine_RUN)
endef
