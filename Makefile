#!/usr/bin/make -f
##############################################################################
# Makefile for building many projects at once.
##############################################################################
# OS specific boiler plate needed first.
OS:=$(shell uname -s)
ifeq ($(OS),Darwin)
SOEXT:=dylib
SOLDFLAGS:=-dynamiclib -Wl,-undefined,dynamic_lookup
else
SOEXT:=so
SOLDFLAGS:=
endif
##############################################################################
# global config
CFLAGS:=-Wall -W -g
# disable debugging.
#CPPFLAGS+=-DNDEBUG
# disable tracing.
CPPFLAGS+=-DNTRACE
# disable unit tests.
CPPFLAGS+=-DNTEST
##############################################################################
# project configurations
MODULES:=\
	boris \
	channel \
	character \
	example \
	fdbfile \
	logging \
	room \
# do not remove this comment.

# boris
EXEC_boris:=boris
LDLIBS_boris:=-ldl -rdynamic
CPPFLAGS_boris:=-D_DEFAULT_SOURCE
CFLAGS_boris:=-pedantic -std=gnu99
SRCS_boris:=boris.c common.c sha1.c sha1crypt.c base64.c util.c config.c worldclock.c comutil.c command.c eventlog.c
OBJS_boris:=$(SRCS_boris:.c=.o)

# channel.so plugin
EXEC_channel:=channel.$(SOEXT)
SRCS_channel:=channel.c
OBJS_channel:=$(SRCS_channel:.c=.o)

# character.so plugin
EXEC_character:=character.$(SOEXT)
SRCS_character:=character.c
OBJS_character:=$(SRCS_character:.c=.o)

# example.so plugin that does nothing
EXEC_example:=example.$(SOEXT)
SRCS_example:=example.c
OBJS_example:=$(SRCS_example:.c=.o)

# fdbfile.so plugin
EXEC_fdbfile:=fdbfile.$(SOEXT)
SRCS_fdbfile:=fdbfile.c
OBJS_fdbfile:=$(SRCS_fdbfile:.c=.o)

# logging.so plugin
EXEC_logging:=logging.$(SOEXT)
SRCS_logging:=logging.c
OBJS_logging:=$(SRCS_logging:.c=.o)

# room.so plugin
EXEC_room:=room.$(SOEXT)
SRCS_room:=room.c
OBJS_room:=$(SRCS_room:.c=.o)

##############################################################################
# Dec 24 2009
#
# MODULES contains a list of names to iterate through.
# each one has a EXEC_module SRCS_module and OBJS_module that must be defined
#
# additionally CFLAGS_module, CPPFLAGS_module and LDLIBS_module may be defined
#
# if EXEC_module ends in .so, all of the SRCS_module will have -fPIC added.
#
##############################################################################
ALL_SRCS:=$(foreach n,$(MODULES),$(SRCS_$(n)))
ALL_EXEC:=$(foreach n,$(MODULES),$(EXEC_$(n)))
ALL_OBJS:=$(foreach n,$(MODULES),$(OBJS_$(n)))
DEPS:=$(ALL_SRCS:.c=.makedep)
# default to non-verbose mode.
V?=0
ifeq ($(V),0)
# macro for doing verbose mode (make V=1)
Q=@echo "$(1)" &&
else
# verbose mode disabled (make V=0)
Q=
endif
all : $(ALL_EXEC)
clean :
	$(call Q,REMOVING $(ALL_OBJS))$(RM) $(ALL_OBJS)
clean-all : clean
	$(call Q,REMOVING $(DEPS))$(RM) $(DEPS)
	$(call Q,REMOVING $(ALL_EXEC))$(RM) $(ALL_EXEC)
documentation :
	doxygen Doxyfile
dumpinfo :
	@echo DEPS=$(DEPS)
	@echo ALL_EXEC=$(ALL_EXEC)
	@echo ALL_OBJS=$(ALL_OBJS)
help :
	@echo "make all        Build everything."
	@echo "make clean      Clean objects."
	@echo "make clean-all  Clean everything."
	@echo "make V=1        Verbose mode."
	@echo "make dumpinfo   Report on internal makefile variables."
.PHONY : all clean clean-all documentation dumpinfo help
##############################################################################
# Generate LDLIBS, CFLAGS, CPPFLAGS for every target.

# look for LDLIBS_module and apply to LDLIBS for each.
$(foreach n,$(MODULES),$(if $(LDLIBS_$(n)),$(eval $(EXEC_$(n)) : LDLIBS+=$(LDLIBS_$(n)))))

# look for CFLAGS_module and apply to CFLAGS for each.
$(foreach n,$(MODULES),$(if $(CFLAGS_$(n)),$(foreach m,$(OBJS_$(n)),$(eval $(m) : CFLAGS+=$(CFLAGS_$(n))))))

# look for CPPFLAGS_module and apply to CPPFLAGS for each.
$(foreach n,$(MODULES),$(if $(CPPFLAGS_$(n)),$(foreach m,$(OBJS_$(n)),$(eval $(m) : CPPFLAGS+=$(CPPFLAGS_$(n))))))

# detect if target is a shared object, then make all deps position-independent.
$(foreach n,$(MODULES),$(if $(filter %.$(SOEXT),$(EXEC_$(n))),$(foreach m,$(OBJS_$(n)),$(eval $(m) : CFLAGS+=-fPIC))))

# define a rule for everything in MODULES
$(foreach n,$(MODULES),$(eval $(EXEC_$(n)) : $(OBJS_$(n))))

##############################################################################
# pattern rules
%.$(SOEXT) : %.o
	$(call Q,SHAREDLIB $@ : $^)$(CC) $(CFLAGS) $(LDFLAGS) $(SOLDFLAGS) $(TARGET_ARCH) $(filter %.o %.a,$^) $(LOADLIBES) $(LDLIBS) -shared -o $@
%.o : %.c
	$(call Q,COMPILE $@ : $^)$(CC) $(CFLAGS) $(CPPFLAGS) -c -o $@ $<
% : %.o
	$(call Q,LINK $@ : $^)$(CC) $(LDFLAGS) $(TARGET_ARCH) $^ $(LOADLIBES) $(LDLIBS) -o $@
% : %.c
	$(call Q,COMPILE+LINK $@ : $^)$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $^ $(LOADLIBES) $(LDLIBS) -o $@
%.makedep : %.c
	$(call Q,DEPENDS $^ -> $@)$(CC) -E $(CFLAGS) $(CPPFLAGS) -MM $^ -MF $@
# only trigger dependies if not help, clean or clean-all
##############################################################################
# dependencies files
ifeq (,$(strip $(filter help clean clean-all,$(MAKECMDGOALS))))
-include $(DEPS)
endif
