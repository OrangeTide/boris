LIBRARIES += obj
obj_DIR   := $(dir $(lastword $(MAKEFILE_LIST)))
obj_SRCS   = obj.c obj_cache.c obj_cache_muddb.c

EXECUTABLES  += test_obj
TEST_TARGETS += test_obj
test_obj_DIR := $(obj_DIR)
test_obj_SRCS = test_obj.c
test_obj_LIBS = log
define test_obj_TESTCMD
$(test_obj_RUN)
endef

EXECUTABLES        += test_obj_cache
TEST_TARGETS       += test_obj_cache
test_obj_cache_DIR := $(obj_DIR)
test_obj_cache_SRCS = test_obj_cache.c
test_obj_cache_LIBS = obj hashtable log
define test_obj_cache_TESTCMD
$(test_obj_cache_RUN)
endef
