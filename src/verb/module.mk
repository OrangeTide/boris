LIBRARIES += verb
verb_DIR  := $(dir $(lastword $(MAKEFILE_LIST)))
verb_SRCS  = verb_spec.c

EXECUTABLES        += test_verb_spec
TEST_TARGETS       += test_verb_spec
test_verb_spec_DIR  := $(verb_DIR)
test_verb_spec_SRCS  = test_verb_spec.c
test_verb_spec_LIBS  = verb
define test_verb_spec_TESTCMD
$(test_verb_spec_RUN)
endef
