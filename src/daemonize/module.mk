LIBRARIES   += daemonize
daemonize_DIR  := $(dir $(lastword $(MAKEFILE_LIST)))
daemonize_SRCS  = daemonize.c
daemonize_EXPORTED_CPPFLAGS = -I$(daemonize_DIR)

EXECUTABLES      += test_daemonize
TEST_TARGETS     += test_daemonize
test_daemonize_DIR  := $(daemonize_DIR)
test_daemonize_SRCS  = test_daemonize.c
test_daemonize_LIBS  = daemonize log
define test_daemonize_TESTCMD
$(test_daemonize_RUN)
endef
