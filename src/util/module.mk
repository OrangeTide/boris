LIBRARIES += util
util_DIR  := $(dir $(lastword $(MAKEFILE_LIST)))
util_SRCS  = util.c grow.c variables.c wordwrap.c pool.c phaseq.c

EXECUTABLES       += test_variables
TEST_TARGETS      += test_variables
test_variables_DIR := $(util_DIR)
test_variables_SRCS = test_variables.c variables.c
define test_variables_TESTCMD
$(test_variables_EXEC)
endef
