X=mud
S:=$(wildcard *.c)
O=$(S:.c=.o)
LDFLAGS+=$(shell pkg-config --libs libwebsockets)
CFLAGS+=$(shell pkg-config --cflags libwebsockets)
CFLAGS+=-Wall -W -flto -O2 -g
all :: $X
clean :: ; $(RM) $X $O
$X : $O
	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $(TARGET_ARCH) -o $@ $^ $(LOADLIBES) $(LDLIBS)
%.o : %.c
	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c -o $@ $<
