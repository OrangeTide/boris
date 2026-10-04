LIBRARIES += stred
stred_DIR   := $(dir $(lastword $(MAKEFILE_LIST)))
stred_SRCS   = stred.c stred_telnet.c
stred_LIBS   = log
stred_EXPORTED_CPPFLAGS = -I$(stred_DIR)

EXECUTABLES     += test_stred
TEST_TARGETS    += test_stred
test_stred_DIR := $(stred_DIR)
test_stred_SRCS = test_stred.c
test_stred_LIBS = stred log
define test_stred_TESTCMD
$(test_stred_RUN)
endef
