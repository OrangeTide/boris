LIBRARIES += verb
verb_DIR  := $(dir $(lastword $(MAKEFILE_LIST)))
verb_SRCS  = verb_spec.c verb_dispatch.c verb_agent.c verb_handle.c verb_model.c
verb_LIBS  = resolve vfs

EXECUTABLES        += test_verb_spec
TEST_TARGETS       += test_verb_spec
test_verb_spec_DIR  := $(verb_DIR)
test_verb_spec_SRCS  = test_verb_spec.c
test_verb_spec_LIBS  = verb
define test_verb_spec_TESTCMD
$(test_verb_spec_RUN)
endef

EXECUTABLES        += test_verb_handle
TEST_TARGETS       += test_verb_handle
test_verb_handle_DIR  := $(verb_DIR)
test_verb_handle_SRCS  = test_verb_handle.c
test_verb_handle_LIBS  = verb obj database hashtable log smolvfs lmdb
define test_verb_handle_TESTCMD
$(test_verb_handle_RUN)
endef

EXECUTABLES            += test_verb_dispatch
TEST_TARGETS           += test_verb_dispatch
test_verb_dispatch_DIR  := $(verb_DIR)
test_verb_dispatch_SRCS  = test_verb_dispatch.c
test_verb_dispatch_LIBS  = verb resolve vm skjrun obj hashtable log database lmdb util mth tinyaes
define test_verb_dispatch_TESTCMD
$(test_verb_dispatch_RUN)
endef

EXECUTABLES          += test_verb_object
TEST_TARGETS         += test_verb_object
test_verb_object_DIR  := $(verb_DIR)
test_verb_object_SRCS  = test_verb_object.c
test_verb_object_LIBS  = verb resolve vm skjrun obj hashtable log database lmdb util mth tinyaes
define test_verb_object_TESTCMD
$(test_verb_object_RUN)
endef

EXECUTABLES         += test_verb_model
TEST_TARGETS        += test_verb_model
test_verb_model_DIR  := $(verb_DIR)
test_verb_model_SRCS  = test_verb_model.c
test_verb_model_LIBS  = verb resolve vm skjrun obj hashtable log database lmdb util mth tinyaes
define test_verb_model_TESTCMD
$(test_verb_model_RUN)
endef

EXECUTABLES           += test_verb_command
TEST_TARGETS          += test_verb_command
test_verb_command_DIR  := $(verb_DIR)
test_verb_command_SRCS  = test_verb_command.c
test_verb_command_LIBS  = verb resolve vm skjrun obj hashtable log database lmdb util mth tinyaes
define test_verb_command_TESTCMD
$(test_verb_command_RUN)
endef
