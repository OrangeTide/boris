CFLAGS += -Wall -W -g # -O3
all ::
clean ::
tests ::

##

S.stackvm := stackvm.c
O.stackvm := $(S.stackvm:%.c=%.o)
stackvm : $(O.stackvm)
all :: stackvm
clean :: ; $(RM) stackvm $(O.stackvm)
tests :: stackvm hello.vm math.vm
	./stackvm hello.vm
	./stackvm math.vm
	echo "Hello World" | ./stackvm token.vm
