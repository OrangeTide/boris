LIBRARIES += vfs
vfs_DIR   := $(dir $(lastword $(MAKEFILE_LIST)))
vfs_SRCS   = vfs.c p9_vfs.c
vfs_LIBS   = smolvfs log
# p9_vfs.c serves the vendored 9P wire protocol: it needs the emulator's fs/
# headers (p9_wire.h, ninefs.h). Dependents that drive the server (the unit
# test) include p9_wire.h too, so export the path.
vfs_CPPFLAGS          := -Isdk/toolchain/skjegg/fs
vfs_EXPORTED_CPPFLAGS := -Isdk/toolchain/skjegg/fs

EXECUTABLES  += test_vfs
TEST_TARGETS += test_vfs
test_vfs_DIR := $(vfs_DIR)
test_vfs_SRCS = test_vfs.c
test_vfs_LIBS = vfs smolvfs log
define test_vfs_TESTCMD
$(test_vfs_RUN)
endef

EXECUTABLES  += test_p9_vfs
TEST_TARGETS += test_p9_vfs
test_p9_vfs_DIR := $(vfs_DIR)
test_p9_vfs_SRCS = test_p9_vfs.c
test_p9_vfs_LIBS = vfs smolvfs log
define test_p9_vfs_TESTCMD
$(test_p9_vfs_RUN)
endef
