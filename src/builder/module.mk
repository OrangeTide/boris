LIBRARIES += builder
builder_DIR   := $(dir $(lastword $(MAKEFILE_LIST)))
builder_SRCS   = builder_save.c builder_ops.c
builder_LIBS   = obj acs log
builder_EXPORTED_CPPFLAGS = -I$(builder_DIR)

EXECUTABLES     += test_builder_save
TEST_TARGETS    += test_builder_save
test_builder_save_DIR := $(builder_DIR)
test_builder_save_SRCS = test_builder_save.c
test_builder_save_LIBS = builder obj acs log
define test_builder_save_TESTCMD
$(test_builder_save_RUN)
endef
