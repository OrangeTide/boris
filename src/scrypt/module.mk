LIBRARIES  += scrypt
scrypt_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
scrypt_SRCS = \
	crypto_aes.c \
	crypto_aesctr.c \
	crypto_entropy.c \
	crypto_scrypt.c \
	crypto_scrypt_smix.c \
	humansize.c \
	memlimit.c \
	scryptenc.c \
	sha256.c
# Third-party code -- suppress warnings we don't control.
scrypt_CFLAGS = -w
