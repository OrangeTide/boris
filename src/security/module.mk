LIBRARIES += security
security_DIR  := $(dir $(lastword $(MAKEFILE_LIST)))
security_SRCS  = security.c
security_SRCS.CONFIG_LANDLOCK = landlock.c
security_SRCS.CONFIG_SECCOMP  = seccomp.c
security_EXPORTED_CPPFLAGS = -I$(security_DIR)
