SCRYPT_SRCS := \
	src/scrypt/crypto_aes.c \
	src/scrypt/crypto_aesctr.c \
	src/scrypt/crypto_entropy.c \
	src/scrypt/crypto_scrypt.c \
	src/scrypt/crypto_scrypt_smix.c \
	src/scrypt/humansize.c \
	src/scrypt/memlimit.c \
	src/scrypt/scryptenc.c \
	src/scrypt/sha256.c

BORIS_SRCS += $(SCRYPT_SRCS)
MKPASS_SRCS += $(SCRYPT_SRCS)

INCLUDES += -Isrc/scrypt
