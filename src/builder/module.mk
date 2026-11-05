LIBRARIES += builder
builder_DIR   := $(dir $(lastword $(MAKEFILE_LIST)))
builder_SRCS   = builder_save.c builder_ops.c builder_snapshot.c world_restore.c builder_history.c
builder_LIBS   = obj acs log smolvfs
builder_EXPORTED_CPPFLAGS = -I$(builder_DIR)

EXECUTABLES     += test_builder_save
TEST_TARGETS    += test_builder_save
test_builder_save_DIR := $(builder_DIR)
test_builder_save_SRCS = test_builder_save.c
test_builder_save_LIBS = builder obj acs log smolvfs
define test_builder_save_TESTCMD
$(test_builder_save_RUN)
endef

EXECUTABLES     += test_builder_snapshot
TEST_TARGETS    += test_builder_snapshot
test_builder_snapshot_DIR := $(builder_DIR)
test_builder_snapshot_SRCS = test_builder_snapshot.c
test_builder_snapshot_LIBS = builder obj hashtable acs log smolvfs
define test_builder_snapshot_TESTCMD
$(test_builder_snapshot_RUN)
endef

EXECUTABLES     += test_world_restore
TEST_TARGETS    += test_world_restore
test_world_restore_DIR := $(builder_DIR)
test_world_restore_SRCS = test_world_restore.c
test_world_restore_LIBS = builder obj database hashtable acs log smolvfs lmdb
define test_world_restore_TESTCMD
$(test_world_restore_RUN)
endef
