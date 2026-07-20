LIBRARIES += crypt
crypt_DIR  := $(dir $(lastword $(MAKEFILE_LIST)))
crypt_SRCS  = base64.c sha1.c
