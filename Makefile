#!/usr/bin/make -f
##############################################################################
# global config
CFLAGS:=-Wall -W -g
# disable debugging.
CPPFLAGS+=-DNDEBUG
# disable tracing.
CPPFLAGS+=-DNTRACE
# disable unit tests.
CPPFLAGS+=-DNTEST
##############################################################################
# project configurations
MODULES:=boris logging

# boris
EXEC_boris:=boris
LDLIBS_boris:=-ldl -rdynamic
CPPFLAGS_boris:=-D_BSD_SOURCE
CFLAGS_boris:=-pedantic -std=gnu99
SRCS_boris:=boris.c
OBJS_boris:=$(SRCS_boris:.c=.o)

# logging.so plugin
EXEC_logging:=logging.so
SRCS_logging:=logging.c
OBJS_logging:=$(SRCS_logging:.c=.o)

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
$(foreach n,$(MODULES),$(if $(filter %.so,$(EXEC_$(n))),$(foreach m,$(OBJS_$(n)),$(eval $(m) : CFLAGS+=-fPIC))))

# define a rule for everything in MODULES
$(foreach n,$(MODULES),$(eval $(EXEC_$(n)) : $(OBJS_$(n))))

##############################################################################
# pattern rules
%.so : %.o
	$(call Q,SHAREDLIB $@ : $^)$(CC) $(CFLAGS) $(LDFLAGS) $(TARGET_ARCH) $(filter %.o %.a,$^) $(LOADLIBES) $(LDLIBS) -shared -o $@
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
