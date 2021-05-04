# Jon's modular Makefile
# Copyright 2020-2021 Jon Mayo <jon@rm-f.net>
# Permission is granted to modify and/or redistribute this work.
# THE WORKS ARE WITHOUT WARRANTY.
########################################################################
## Documentation
#
# Basic Usage:
# * For help `make help`.
# * To configure `make configure-` or `make` without .config file present.
# * To build `make` or `make all`.
# * To clean intermediate files, `make clean`.
# * To clean executable files as well, `make clean-all`.
# * To clean everything above plus wipe configuration, `make distclean`.
# * Executables are output to globally configured BINDIR (./bin/ is default).
# * Set TOOLPREFIX to use an alternative toolchain path or prefix.
#
# Adding Your Project:
# * Define parameters for each project in a top-level *.mk file.
# * Mandatory values for TYPE, OUT, SRCS.
# * OUT is the name of your executable (without .exe or .dll extension).
# * TYPE is one of: `exe`, `dll`, `disable*'
# * Set SRCDIR to place the source files of a project in a subdirectory.
# * Optionally set CFLAGS, CPPFLAGS, LDFLAGS, LDLIBS, CXXFLAGS, etc.
# * optional variables based on target platform type. (e.g. SRCS.win32)
#
# Adding A New Platform Configuration:
# * .config files define new platforms
# * LDFLAGS_LIB is a macro. $1 is LIBDIR; $2 is SONAME.
# * ENVIRONMENT is the target platform type and can be anything that is
#   convenient for matching. (win32, x11, posix, linux, bsd, darwin, ...)
# (TODO: complete this section)
#
########################################################################
## TODO
#
# * accept TYPE parameter for making static and dynamic libraries
# * handle languages other than C (finish C++ and ASM support)
# * make it easier to configure a different cross-compiler.
#   * test it out with crossbuild-essential-{arm64,armel,armhf,i386}
# * add pkg-config support as a PKGS parameter.
# * cross-project references of depedencies and configuration parameters.
# * output intermediate objects to a configurable directory.
# * implement a TEST_SCRIPT parameter to run a test script for a project.
# * add a DESCRIPTION field for describing a .config file
# * support matching of multiple tags in the ENVIRONMENT parameter.
#
########################################################################
## Default - for advance use, override these on the command-line.
CC = $(TOOLPREFIX)gcc
CXX = $(TOOLPREFIX)g++
LD = $(TOOLPREFIX)ld
AS = $(TOOLPREFIX)as
AR = $(TOOLPREFIX)ar
CFLAGS = -Wall -W -O3 -flto -g
RM ?= rm -rf
MKDIR ?= mkdir -p
RMDIR = rm -f
BINDIR ?= bin
########################################################################
## Targets
all :: | $(BINDIR)
clean ::
clean-all :: clean ; $(RM) $(DEPS)
distclean : clean-all
	$(RM) .config
	$(RMDIR) $(BINDIR)
.PHONY : all clean clean-all distclean help configure
########################################################################
## Configuration & Help

# load configuration - this is where TOOLCHAIN_PREFIX is defined
-include .config
ifneq ($(lastword $(MAKEFILE_LIST)),.config)
.DEFAULT_GOAL := configure
endif

CONFIG_CHOICES = $(patsubst %.config,%,$(notdir $(wildcard *.config)))

# generate shell commands to display config helps on config-XXXXX
define echo_config_choices
$(foreach i,$1,
@echo configure-$i
@echo "  Configure for $i."
)
endef

configure :
	@echo Select one of
	@echo -------------
	$(call echo_config_choices,$(CONFIG_CHOICES))

configure-% :
	cp $*.config .config

help :
	@echo Build Help
	@echo ----------
	@echo usage: make [goals...]
	@echo
	@echo make all
	@echo "  Builds everything. (default)"
	@echo make clean
	@echo "  Cleans all temporary objects."
	@echo make clean-all
	@echo "  Cleans all executables, dependency files, and objects."
	@echo make distclean
	@echo "  Cleans configuration and all over the above."
	@echo make help
	@echo "  This help."
	@echo make configure
	@echo "  Show configuration help."
	$(call echo_config_choices,$(CONFIG_CHOICES))

########################################################################
## Pattern rules
%.o : %.c
	$(CC) $(CFLAGS) $(COMMON_CFLAGS) $(CPPFLAGS) -c -o $@ $<
%.o : %.cpp
	$(CXX) $(CXXFLAGS) $(COMMON_CFLAGS) $(CPPFLAGS) -c -o $@ $<
########################################################################
## Macros
# load all options for a target into simple variables
define loadproject
include $1
TYPE ?= exe
CFLAGS ?= $(DEFAULT_CFLAGS)
CPPFLAGS ?= $(DEFAULT_CPPFLAGS)
CXXFLAGS ?= $(DEFAULT_CXXFLAGS)
LDFLAGS ?= $(DEFAULT_LDFLAGS)
ASFLAGS ?= $(DEFAULT_ASFLAGS)
ARFLAGS ?= $(DEFAULT_ARFLAGS)
ifneq ($$(TYPE),disabled)
ALL_TARGETS += $1
OUT ?= $$(basename $$(firstword $$(SRCS)))
ifeq ($$(TYPE),exe)
OUT.$1 := $(if $(BINDIR),$(BINDIR)/)$$(OUT)$(EXT)
else ifeq ($$(TYPE),dll)
OUT.$1 := $(if $(BINDIR),$(BINDIR)/)$$(OUT)$(DLLEXT)
endif
SRCS.$1 := $$(addprefix $$(if $$(SRCDIR),$$(SRCDIR)/),$$(SRCS) $$(SRCS.$(ENVIRONMENT)))
EXTRA_OBJS.$1 := $$(OBJS) $$(OBJS.$(ENVIRONMENT))
CFLAGS.$1 := $$(CFLAGS) $$(CFLAGS.$(ENVIRONMENT))
CPPFLAGS.$1 := $$(CPPFLAGS) $$(CPPFLAGS.$(ENVIRONMENT)) $$(if $$(SRCDIR),-I$$(SRCDIR))
CXXFLAGS.$1 := $$(CXXFLAGS) $$(CXXFLAGS.$(ENVIRONMENT))
LDFLAGS.$1 := $$(LDFLAGS) $$(LDFLAGS.$(ENVIRONMENT))
ASFLAGS.$1 := $$(ASFLAGS) $$(ASFLAGS.$(ENVIRONMENT))
ARFLAGS.$1 := $$(ARFLAGS) $$(ARFLAGS.$(ENVIRONMENT))
PKGS.$1 := $$(PKGS) $$(PKGS.$(ENVIRONMENT))
endif
undefine OBJS
undefine OBJS.$(ENVIRONMENT)
undefine SRCS
undefine SRCS.$(ENVIRONMENT)
undefine OUT
undefine TYPE
undefine CFLAGS
undefine CFLAGS.$(ENVIRONMENT)
undefine CPPFLAGS
undefine CPPFLAGS.$(ENVIRONMENT)
undefine CXXFLAGS
undefine CXXFLAGS.$(ENVIRONMENT)
undefine LDFLAGS
undefine LDFLAGS.$(ENVIRONMENT)
undefine ASFLAGS
undefine ASFLAGS.$(ENVIRONMENT)
undefine ARFLAGS
undefine ARFLAGS.$(ENVIRONMENT)
undefine SRCDIR
endef
# generate rules for a target
define generate
OBJS.$1 ?= $$(SRCS.$1:%.c=%.o)
ifneq ($$(strip $$(PKGS.$1)),)
CFLAGS.$1 += $$(shell pkg-config --cflags $$(PKGS.$1))
LDFLAGS.$1 += $$(shell pkg-config --libs $$(PKGS.$1))
endif
all :: $$(OUT.$1)
clean :: ; $$(RM) $$(OBJS.$1)
clean-all :: ; $$(RM) $$(OUT.$1)
$$(OUT.$1) : $$(OBJS.$1) $$(EXTRA_OBJS.$1)
	$$(CC) $$(LDFLAGS) $$^ $$(LDLIBS) -o $$@
$$(OUT.$1) $$(OBJS.$1) : CFLAGS = $$(CFLAGS.$1)
$$(OBJS.$1) : CPPFLAGS = $$(CPPFLAGS.$1)
$$(OBJS.$1) : CXXFLAGS = $$(CXXFLAGS.$1)
$$(OUT.$1) : LDFLAGS = $$(LDFLAGS.$1)
$$(OBJS.$1) : ASFLAGS = $$(ASFLAGS.$1)
$$(OUT.$1) : ARFLAGS = $$(ARFLAGS.$1)
endef
########################################################################
# save all defaults
DEFAULT_CFLAGS := $(CFLAGS)
DEFAULT_CPPFLAGS := $(CPPFLAGS)
DEFAULT_CXXFLAGS := $(CXXFLAGS)
DEFAULT_LDFLAGS := $(LDFLAGS)
DEFAULT_ASFLAGS := $(ASFLAGS)
DEFAULT_ARFLAGS := $(ARFLAGS)
########################################################################
# clean out values that can be pass on the command-line that can also be set in *.mk files
override undefine CFLAGS
override undefine CPPFLAGS
override undefine CXXFLAGS
override undefine LDFLAGS
override undefine ASFLAGS
override undefine ARFLAGS
########################################################################
# Load and process every project
ALL_TARGETS :=
DEPS :=
$(foreach p,$(wildcard *.mk),$(eval $(call loadproject,$p)))
# Process all generated dependency files
DEPS = $(patsubst %.c,%.d,$(foreach p,$(ALL_TARGETS),$(SRCS.$p)))
# generate rules for every target
$(foreach p,$(ALL_TARGETS),$(eval $(call generate,$p)))
-include $(DEPS)
########################################################################
# Utility rules
$(BINDIR) : ; $(MKDIR) $@
