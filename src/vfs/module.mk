LIBRARIES += vfs
vfs_DIR   := $(dir $(lastword $(MAKEFILE_LIST)))
vfs_SRCS   = vfs.c p9_vfs.c
vfs_LIBS   = smolvfs log
# p9_vfs.c serves the vendored 9P wire protocol: it needs the emulator's fs/
# headers (p9_wire.h, ninefs.h). Dependents that drive the server (the unit
# test) include p9_wire.h too, so export the path.
vfs_CPPFLAGS          := -Isdk/toolchain/skjegg/fs
vfs_EXPORTED_CPPFLAGS := -Isdk/toolchain/skjegg/fs

# The in-world compile pipeline. Kept separate from the vfs library because it
# drives the embedded runtime (vm) to run the toolchain stages as guests: vfs is
# a base the emulator depends on (skjrun_LIBS := vfs), so vfs must not depend on
# vm. This top library depends on both, breaking the would-be cycle.
LIBRARIES += compile
compile_DIR  := $(vfs_DIR)
compile_SRCS  = vfs_compile.c
compile_LIBS  = vfs vm log

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

# The compile pipeline test. Its config-error and language cases always run; the
# live compile runs only when the toolchain guests are built (make -C sdk/vm
# toolchain), which a bare `make check` does not do. The env points it at the
# built SDK paths so a developer who has built the toolchain gets the live test;
# otherwise the test finds the paths absent and skips the live part.
EXECUTABLES  += test_vfs_compile
TEST_TARGETS += test_vfs_compile
test_vfs_compile_DIR := $(vfs_DIR)
test_vfs_compile_SRCS = test_vfs_compile.c
test_vfs_compile_LIBS = compile vfs vm smolvfs log
define test_vfs_compile_TESTCMD
VFSCC_TCDIR=$(abspath data/vm/toolchain) \
VFSCC_LIBDIR=$(abspath data/vm/lib) \
VFSCC_INCDIR=$(abspath sdk/toolchain/skjegg/include) \
$(test_vfs_compile_RUN)
endef
