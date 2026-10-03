LIBRARIES += rv32
rv32_DIR  := $(dir $(lastword $(MAKEFILE_LIST)))
rv32_SRCS  = rv32.c elf32.c
rv32_EXPORTED_LDLIBS = -lm

EXECUTABLES  += test_rv32
TEST_TARGETS += test_rv32
test_rv32_DIR := $(rv32_DIR)
test_rv32_SRCS = test_rv32.c
test_rv32_LIBS = rv32
define test_rv32_TESTCMD
$(test_rv32_RUN)
endef
