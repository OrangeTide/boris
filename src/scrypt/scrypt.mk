X.scrypt := libscrypt.a
S.scrypt := \
	crypto_aes.c \
	crypto_aesctr.c \
	crypto_entropy.c \
	crypto_scrypt.c \
	crypto_scrypt_smix.c \
	humansize.c \
	memlimit.c \
	scryptenc.c \
	sha256.c
O.scrypt := $(S.scrypt:.c=.o)
$(X.scrypt) : $(O.scrypt)
clean :: ; $(RM) $(X.scrypt) $(O.scrypt)

X.test_scrypt := test_scrypt
S.test_scrypt := test_scrypt.c 
O.test_scrypt := $(S.test_scrypt:.c=.o)
L.test_scrypt := scrypt
$(X.test_scrypt) : $(O.test_scrypt) $(patsubst %,lib%.a,$(L.test_scrypt))
clean :: ; $(RM) $(X.test_scrypt) $(O.test_scrypt)
all :: $(X.test_scrypt)

tests :: | test_scrypt
	./test_scrypt | cmp - test_scrypt.good
