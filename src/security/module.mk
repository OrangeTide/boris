LIBRARIES += security
security_DIR  := $(dir $(lastword $(MAKEFILE_LIST)))
security_SRCS  = security.c landlock.c seccomp.c
security_EXPORTED_CPPFLAGS = -I$(security_DIR)
