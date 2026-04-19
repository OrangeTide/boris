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

EXECUTABLES       += test_phaseq
TEST_TARGETS      += test_phaseq
test_phaseq_DIR   := $(util_DIR)
test_phaseq_SRCS   = test_phaseq.c phaseq.c pool.c ../log/log.c
define test_phaseq_TESTCMD
$(test_phaseq_EXEC)
endef
