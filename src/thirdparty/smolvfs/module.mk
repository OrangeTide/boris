LIBRARIES   += smolvfs
smolvfs_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
smolvfs_SRCS = cas.c cas-codec.c cas-pack.c cas-tree.c

EXECUTABLES    += test_cas
TEST_TARGETS   += test_cas
test_cas_DIR := $(smolvfs_DIR)
test_cas_SRCS = test_cas.c
test_cas_LIBS = smolvfs
# run from a scratch cwd: the upstream cas_new(NULL) default-basedir
# test creates ./depot in whatever directory it runs from
define test_cas_TESTCMD
d=$$(mktemp -d) && (cd "$$d" && $(TESTWRAP) $(abspath $(test_cas_EXEC))) && rm -rf "$$d"
endef

EXECUTABLES    += test_cas_tree
TEST_TARGETS   += test_cas_tree
test_cas_tree_DIR := $(smolvfs_DIR)
test_cas_tree_SRCS = test_cas_tree.c
test_cas_tree_LIBS = smolvfs
define test_cas_tree_TESTCMD
$(test_cas_tree_RUN)
endef
