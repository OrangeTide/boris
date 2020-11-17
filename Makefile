all ::
clean ::
clean-all : clean ; $(RM) $(DEPFILES)
tests ::
.PHONY : all clean clean-all tests
########################################################################
# Configuration
########################################################################
CFLAGS := -Wall -Os -g
COMMON_CFLAGS := -MMD -MP
BINDIR := bin
########################################################################
# Nasm rules
########################################################################
NASMFLAGS := -felf64 -Wall -g
%.o %.d : %.asm
	nasm $(NASMFLAGS) $(CPPFLAGS) -o $*.o -MD $*.d -MP $<
########################################################################
# Rules
########################################################################
%.o : %.c
	$(CC) $(COMMON_CFLAGS) $(CFLAGS) $(CPPFLAGS) $(if $(PKGS),$(shell pkg-config --cflags $(PKGS))) -c -o $*.o $<
########################################################################
# Macros
########################################################################
makeobjs = $(filter %.o,$(patsubst %.c,%.o,$(patsubst %.cpp,%.o,$(patsubst %.cc,%.o,$(patsubst %.C,%.o,$(patsubst %.S,%.o,$(patsubst %.s,%.o,$(patsubst %.asm,%.o,$1))))))))
# generate rules for a target
# $1 = name of executable
# inputs: SRCS, OBJS, CFLAGS, CPPFLAGS, CXXFLAGS, LDFLAGS, LDLIBS
define generate
$(eval
$(addprefix $(BINDIR)/,$1) : $(addprefix $(DIR)/,$(call makeobjs,$(SRCS)) $(OBJS)) | $(BINDIR)
	$$(CC) $$(CFLAGS) $$(CPPFLAGS) $$(LDFLAGS) $$^ $$(if $$(PKGS),$$(shell pkg-config --libs $$(PKGS))) $$(LDLIBS) -o $$@
clean :: ; $$(RM) $1 $(addprefix $(DIR)/,$(call makeobjs,$(SRCS)))
$(if $(CFLAGS),$(addprefix $(DIR)/,$(call makeobjs,$(SRCS))) : CFLAGS = $(CFLAGS))
$(if $(CPPFLAGS),$(addprefix $(DIR)/,$(call makeobjs,$(SRCS))) : CPPFLAGS = $(CPPFLAGS))
$(if $(CXXFLAGS),$(addprefix $(DIR)/,$(call makeobjs,$(SRCS))) : CXXFLAGS = $(CXXFLAGS))
$(if $(LDFLAGS),$(addprefix $(BINDIR)/,$1) : LDFLAGS = $(LDFLAGS))
$(if $(LDLIBS),$(addprefix $(BINDIR)/,$1) : LDLIBS = $(LDLIBS))
$(if $(PKGS),$(addprefix $(BINDIR)/,$1) : PKGS = $(PKGS))
DEPFILES += $$(patsubst %.o,%.d,$(addprefix $(DIR)/,$(call makeobjs,$(SRCS))))
CFLAGS := $(DEFAULT_CFLAGS)
CPPFLAGS := $(DEFAULT_CPPFLAGS)
CXXFLAGS := $(DEFAULT_CXXFLAGS)
LDFLAGS := $(DEFAULT_LDFLAGS)
LDLIBS := $(DEFAULT_LDLIBS)
PKGS :=
SRCS :=
OBJS :=
DIR :=)
endef
# generate an executable
define generate-exe
$(call generate,$1)\
$(eval all :: $(addprefix $(BINDIR)/,$1))
endef
# generate a test
define generate-test
$(call generate,$1)
$(eval tests :: $(addprefix $(BINDIR)/,$1)
	./$(addprefix $(BINDIR)/,$1))
endef
########################################################################
# Init
########################################################################
DEFAULT_CFLAGS := $(CFLAGS)
DEFAULT_CPPFLAGS := $(CPPFLAGS)
DEFAULT_CXXFLAGS := $(CXXFLAGS)
DEFAULT_LDFLAGS := $(LDFLAGS)
DEFAULT_LDLIBS := $(LDLIBS)
SRCS :=
OBJS :=
PKGS :=
DIR :=
DEPFILES :=
########################################################################
# Build System stages
########################################################################
$(BINDIR) :
	mkdir -p $@
########################################################################
include $(wildcard *.mk)
-include $(DEPFILES)
