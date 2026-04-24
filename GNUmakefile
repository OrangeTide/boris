# modular-make -- A modular GNUmakefile for C, C++, D, Fortran, Objective-C, Objective-C++, Pascal, Modula-2, and Assembly projects [v1.4.0]
# updated: 23 Apr 2026
# Requires GNU Make 4.0 or later (uses $(file) function).
#
# ============================================================================
# OVERVIEW
# ============================================================================
#
# This build system compiles multi-language projects, static libraries,
# and shared libraries from a tree of module.mk descriptor files.  Each
# module.mk declares one or more build targets and their sources, flags,
# and dependencies.  The top-level GNUmakefile provides the rules; the
# module.mk files provide the data.
#
# Supported source languages:
#
#   .c          C              (compiled with CC)
#   .cc .cpp    C++            (compiled with CXX)
#   .d          D              (compiled with GDC)
#   .m          Objective-C    (compiled with CC)
#   .mm         Objective-C++  (compiled with CXX)
#   .f .f90     Fortran        (compiled with FC)
#   .S          Assembly       (preprocessed, compiled with CC)
#   .asm        Assembly       (compiled with NASM)
#   .pas        Pascal         (compiled with FPC, requires cdecl exports)
#   .mod        Modula-2       (compiled with GM2 / GCC Modula-2 frontend)
#
# All languages produce standard .o object files and can be freely mixed
# within a single target.
#
# ============================================================================
# DIRECTORY LAYOUT
# ============================================================================
#
# Source tree (input):
#
#   By default the build system loads src/module.mk as the root module
#   file.  If a top-level module.mk exists instead, it is used and the
#   user is responsible for adding src (or any other directory) to SUBDIRS.
#
#   src/
#     module.mk              <-- declares your central project
#     yourprog.c
#     lib/
#       module.mk            <-- declares a library used by yourprog
#       util.c
#
# Build tree (output, per target triplet):
#
#   _build/<triplet>/        object files (.o) and dependency files (.dep)
#   _out/<triplet>/bin/      executable binaries
#   _out/<triplet>/lib/      shared libraries (.so / .dylib / .dll)
#
# Static archives (.a) are placed under _build/<triplet>/ alongside the
# objects, since they are intermediate build artifacts rather than
# installable outputs.
#
# The triplet (e.g. x86_64-linux-gnu) is obtained from $(CC) -dumpmachine
# so that cross-compiled artifacts do not clobber native ones.
#
# ============================================================================
# MODULE.MK FILES
# ============================================================================
#
# A module.mk file declares build targets by appending to one of three
# lists and setting per-target variables.  The general pattern is:
#
#   EXECUTABLES += mytool           # executable binary
#   LIBRARIES   += mystaticlib      # static archive (.a)
#   SHARED_LIBS += mysharedlib      # shared library (.so/.dylib/.dll)
#
# Every target must define at minimum:
#
#   <name>_DIR  := $(dir $(lastword $(MAKEFILE_LIST)))
#   <name>_SRCS  = file1.c file2.c
#
# The _DIR line is boilerplate -- it captures the directory containing the
# module.mk so that source paths resolve correctly regardless of where
# the file is included from.  Source file names in _SRCS are relative to
# _DIR (the build system prepends _DIR automatically).  Wildcards are
# supported (e.g. *.c), expanded via $(wildcard).
#
# Sources may use any supported extension (.c, .cc, .cpp, .d, .m, .mm,
# .f, .f90, .S, .asm, .pas, .mod) and can be freely mixed:
#
#   myapp_SRCS = main.c accel.S utils.cc
#
# Optional per-target variables:
#
#   <name>_CFLAGS    C / Objective-C compiler flags (e.g. -Wall -O2)
#   <name>_CXXFLAGS  C++ / Objective-C++ compiler flags
#   <name>_CPPFLAGS  Preprocessor flags     (e.g. -I paths, -D defines)
#   <name>_DFLAGS    D compiler flags
#   <name>_FFLAGS    Fortran compiler flags
#   <name>_ASFLAGS   Assembler flags        (.S files)
#   <name>_NASMFLAGS NASM flags             (.asm files)
#   <name>_FPCFLAGS  Free Pascal flags      (.pas files)
#   <name>_GM2FLAGS  GCC Modula-2 flags     (.mod files)
#   <name>_GENERATED_SRCS  Source files produced by code generators.
#                     Paths are relative to BUILDDIR/<name>_DIR (the
#                     generated source mirror of the module directory).
#                     The build system compiles them from BUILDDIR
#                     instead of the source tree.  The module.mk must
#                     provide a rule to create each generated file.
#                     Wildcards and platform suffixes are supported.
#   <name>_EXTRA_OBJS  Additional pre-built .o files to link (not compiled
#                     or cleaned by this build system).
#   <name>_LDFLAGS   Linker flags           (executables and shared libs)
#   <name>_LDLIBS    Link libraries          (executables and shared libs)
#   <name>_EXEC      Set automatically for executables -- the full
#                     output path (e.g. _out/<triplet>/bin/myapp).
#   <name>_LIBS      Names of library targets this target depends on.
#                     Works for both static and shared libraries --
#                     the build system resolves each name to its .a or
#                     .so output automatically.  Dependencies are
#                     resolved transitively -- if lib A depends on
#                     lib B, an executable depending on A will also
#                     link B and inherit its exported flags.
#   <name>_EXPORTED_CPPFLAGS  Preprocessor flags exported to dependents
#   <name>_EXPORTED_CFLAGS    C compiler flags exported to dependents
#   <name>_EXPORTED_CXXFLAGS  C++ compiler flags exported to dependents
#   <name>_EXPORTED_LDFLAGS   Linker flags exported to dependents
#   <name>_EXPORTED_LDLIBS    Link libraries exported to dependents
#
# Platform-specific variable suffixes:
#
#   Most per-target variables (all of the above plus _SRCS,
#   _GENERATED_SRCS, _LIBS, and _EXTRA_OBJS) accept .<os>, .<arch>,
#   and .<os>.<arch> suffixes.
#   After all module.mk files are loaded, suffixed values are appended
#   to the base variable automatically.  <os> comes from `uname -s`
#   (Linux, Darwin, Windows_NT under MSYS/Cygwin) and <arch> from
#   `uname -m` (x86_64, aarch64, ...).
#
#   Example:
#
#     mylib_SRCS         = common.c
#     mylib_SRCS.Linux   = linux/platform.c
#     mylib_SRCS.Darwin  = macos/platform.c
#     mylib_LDLIBS.Linux = -lm -ldl
#     mylib_CFLAGS.Linux.x86_64 = -msse4.2
#
#   <name>_TESTCMD   Shell commands to test the target, written with
#                     define/endef.  Each line runs as a separate
#                     shell command; if any fails, make stops.
#
# Each module.mk may also set:
#
#   TEST_TARGETS     Targets with test commands.  Append a target
#                     name to have 'make run-tests' execute its
#                     _TESTCMD after building it.
#   SUBDIRS          Subdirectories (relative to the module.mk) whose
#                     own module.mk files should be included.  This
#                     drives the recursive module discovery described
#                     below.  SUBDIRS is per-file, not per-target.
#
# The following global variables are available to module.mk files:
#
#   TOP              Absolute path to the project root (with trailing
#                     slash), for referencing files relative to the
#                     top-level directory regardless of module depth.
#
# If any _SRCS in the target or its transitive _LIBS dependencies
# contain C++ or Objective-C++ files (.cc/.cpp/.mm), CXX_MODE is set
# and the linker automatically switches from $(CC) to $(CXX).
#
# Example -- an executable that depends on a static library:
#
#   # src/module.mk
#   SUBDIRS     = lib
#   EXECUTABLES += hello
#   hello_DIR   := $(dir $(lastword $(MAKEFILE_LIST)))
#   hello_SRCS  = hello.c
#   hello_LIBS  = myutil
#
#   # src/lib/module.mk
#   LIBRARIES += myutil
#   myutil_DIR  := $(dir $(lastword $(MAKEFILE_LIST)))
#   myutil_SRCS  = myutil.c
#   myutil_EXPORTED_CPPFLAGS = -I$(myutil_DIR)
#
# Example -- a shared library:
#
#   SHARED_LIBS += myplugin
#   myplugin_DIR  := $(dir $(lastword $(MAKEFILE_LIST)))
#   myplugin_SRCS  = plugin.c hooks.c
#   myplugin_CFLAGS = -Wall
#
# Objects for shared libraries are compiled with -fPIC automatically
# (or -Cg for Pascal).
#
# Example -- mixed C and C++:
#
#   EXECUTABLES += myapp
#   myapp_DIR   := $(dir $(lastword $(MAKEFILE_LIST)))
#   myapp_SRCS   = main.c engine.cpp
#   myapp_CFLAGS = -O2
#   myapp_CXXFLAGS = -O2 -std=c++17
#
# Example -- test commands:
#
#   EXECUTABLES += myapp
#   myapp_DIR   := $(dir $(lastword $(MAKEFILE_LIST)))
#   myapp_SRCS   = main.c
#   define myapp_TESTCMD
#   $(myapp_EXEC) --selftest
#   $(myapp_EXEC) < testdata/input.txt | diff - testdata/expected.txt
#   endef
#   TEST_TARGETS += myapp
#
# The _EXEC variable is set automatically for each executable (expands
# to the full output path, e.g. _out/<triplet>/bin/myapp).  Use
# define/endef for multi-line test commands -- each line becomes a
# separate recipe line checked for errors by Make.  Run all tests
# with 'make run-tests' or a single test with 'make run-test-<name>'.
#
# Example -- generated source files:
#
#   EXECUTABLES += myapp
#   myapp_DIR   := $(dir $(lastword $(MAKEFILE_LIST)))
#   myapp_SRCS  = main.c
#   myapp_GENERATED_SRCS = proto_msg.c
#
#   $(BUILDDIR)/$(myapp_DIR)proto_msg.c : $(myapp_DIR)proto.idl
#   	my-codegen $< -o $@
#
# The generated file ends up at _build/<triplet>/src/proto_msg.c (or
# wherever _DIR points) and is compiled to _build/<triplet>/src/proto_msg.o
# just like a normal source file.  The module.mk must supply the rule
# that creates the generated file.
#
# ============================================================================
# RECURSIVE MODULE DISCOVERY
# ============================================================================
#
# Module.mk files are discovered by a recursive loader seeded from
# src/module.mk.  Each time a module.mk is included, the loader reads
# its SUBDIRS variable and queues any new module.mk files found in
# those subdirectories (resolved relative to the including file).
# The process repeats until no new module.mk files are found.
#
# This means the tree of module.mk files is driven entirely by SUBDIRS
# declarations -- there is no filesystem scanning or globbing.
#
# ============================================================================
# DEPENDENCY TRACKING
# ============================================================================
#
# The compile commands for C, C++, Objective-C, Objective-C++, D,
# Fortran, preprocessed assembly (.S), and Modula-2 emit GCC-style
# dependency files (.dep) via -MMD -MF.  These are included at the
# bottom of this makefile so that changes to headers trigger
# recompilation of the affected objects.  On a clean build the .dep
# files do not yet exist; the -include directive silently ignores the
# missing files.
#
# NASM assembly and Pascal do not generate dependency files.
# Some compilers produce side-effect files (FPC emits .ppu unit
# files, gm2 emits .d definition caches); these are cleaned up
# automatically by 'make clean'.
#
# Library dependencies declared via _LIBS are expressed as makefile
# prerequisites: the library archive or shared object is listed as a
# prerequisite of the executable link step.  This means Make will build
# (or rebuild) any required libraries before linking the project.  The
# library files are passed to the linker through $^ (the prerequisite
# list), so no manual -l flags are needed for internal libraries.
#
# ============================================================================
# BUILD CONFIGURATION (CONFIG_* OPTIONS)
# ============================================================================
#
# Optional per-triplet feature toggles.  A config.mk file in the build
# directory (e.g. _build/x86_64-linux-gnu/config.mk) sets CONFIG_*
# variables to 'y' or 'n' to control which sources, flags, and modules
# are included in the build.
#
# If a defconfig file exists in the project root, config.mk is
# auto-created from it on the first build.  To reset or switch:
#
#   make defconfig              reset to ./defconfig
#   make defconfig_<name>       switch to configs/<name>.mk
#
# Then edit the generated file and rebuild.  Without a defconfig or
# config.mk the build works normally with all CONFIG options disabled.
#
# After changing config options that add or remove source files,
# remove _build/ manually before rebuilding (make clean only removes
# files known to the current config).
#
# For each CONFIG_FOO = y, two things happen automatically:
#
#   1. Per-target variables with a .CONFIG_FOO suffix are merged into
#      their base variable (same mechanism as platform suffixes):
#
#        myapp_SRCS.CONFIG_SSL = ssl.c
#        myapp_LDLIBS.CONFIG_SSL = -lssl -lcrypto
#
#   2. -DCONFIG_FOO=1 is added to PROJECT_CPPFLAGS so C/C++ code can
#      use #ifdef CONFIG_FOO.
#
#   3. A config.h header is auto-generated in the build directory.
#      CONFIG_FOO = y becomes #define CONFIG_FOO 1; any other non-'n'
#      value is emitted verbatim (#define CONFIG_BAR "string").
#      Source files can #include "config.h" to access all config
#      values without -D escaping.  -I$(BUILDDIR) is added
#      automatically.
#
# Non-boolean parameters use the CONFIG_ prefix and a literal value:
#
#   # config.mk
#   CONFIG_GREETING = y
#   CONFIG_GREETING_STR = "What's up"
#
# Modules can also use ifdef to conditionally register entire targets:
#
#   ifeq ($(CONFIG_LUA_SCRIPTING),y)
#     LIBRARIES += lua_bridge
#     lua_bridge_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
#     lua_bridge_SRCS = lua_bridge.c
#   endif
#
# Config options control features, not toolchains.  Compiler selection
# (CC, USE_CLANG) and build modes (DEBUG, RELEASE) belong in .env or
# on the command line.
#
# ============================================================================
# MAKE TARGETS
# ============================================================================
#
#   make              Build all executables (default).
#   make <name>       Build a single project or library by target name.
#   make clean        Remove all generated objects, dependency files,
#                     archives, shared libraries, and binaries.
#   make clean_<name> Remove generated files for a single target.
#   make clean-all    Like clean, then also remove empty build/output
#                     directories (deepest first).
#   make run-tests    Build all test targets, then run their test
#                     commands.  See _TESTCMD in MODULE.MK FILES.
#   make run-test-<name>  Build and test a single target.
#   make compile_commands.json
#                     Generate compile_commands.json for clangd and
#                     other LSP tooling.  Also rebuilt by "make all".
#   make defconfig    Reset $(BUILDDIR)/config.mk from the project's
#                     defconfig template (auto-created on first build).
#                     Edit the file to customize CONFIG_* options.
#   make defconfig_<name>
#                     Generate config.mk from configs/<name>.mk.
#
# ============================================================================
# CUSTOMIZATION
# ============================================================================
#
# The following variables can be overridden on the command line, in
# the environment, or in a .env file (copy env.example to .env):
#
#   USE_CLANG   If set, use clang/clang++ instead of cc/c++.
#   CC          C compiler                         (default: cc)
#   CXX         C++ compiler                       (default: c++)
#   FC          Fortran compiler                   (default: gfortran)
#   GDC         D compiler                         (default: gdc)
#   NASM        Netwide Assembler                  (default: nasm)
#   FPC         Free Pascal compiler               (default: fpc)
#   GM2         GCC Modula-2 frontend              (default: gm2)
#   AR          Archiver                           (default: ar)
#   ARFLAGS     Archiver flags                     (default: rvD)
#   MKDIR_P     Directory creation command          (default: mkdir -p)
#   RMDIR       Directory removal command           (default: rmdir)
#
#   DEBUG       If set, enable debug build flags (-Og -g
#               -fno-omit-frame-pointer).
#   RELEASE     If set, enable release build flags (-O2, LTO,
#               -ffunction-sections, -fdata-sections, -DNDEBUG).
#   RELEASE_MARCH  Target architecture for release builds
#               (default: native).  Examples: x86-64-v2, x86-64-v3.
#               To list available options on x86-64, run:
#               /lib64/ld-linux-x86-64.so.2 --help
#
# DEBUG and RELEASE are mutually exclusive.  Build mode flags are
# injected into all GCC-based compile and link commands (C, C++, D,
# Obj-C, Obj-C++, Fortran, Assembly, Modula-2).  Pascal (FPC) is not
# affected.  LTO is auto-detected: a probe compiles, archives, and
# links a test program to verify the full toolchain supports it.
# Uses -flto=thin with Clang and -flto=auto with GCC.
#
# Per-target CFLAGS, CXXFLAGS, CPPFLAGS, LDFLAGS, LDLIBS, and other
# language-specific flags are set via target-specific variables and do
# not inherit the global values.  This is intentional -- it keeps each
# target's flags self-contained and avoids surprising flag leakage
# between unrelated targets.
#
# Optional build configuration is loaded from $(BUILDDIR)/config.mk,
# auto-created from ./defconfig on first build (or via 'make defconfig').
# See BUILD CONFIGURATION above for details.
#
# ============================================================================

# --- Optional .env for local configuration ----------------------------------
# Variables like USE_CLANG, RELEASE, RELEASE_MARCH, etc.  See env.example.
-include .env

# --- Flags ------------------------------------------------------------------

# Host Commands
ifdef USE_CLANG
  CC  := clang
  CXX := clang++
else
  CC  ?= cc
  CXX ?= c++
endif

MKDIR_P ?= mkdir -p
RMDIR   ?= rmdir
ARFLAGS  = rvD
# Override Make's built-in FC=f77 default, but respect user/env overrides
ifeq ($(origin FC),default)
  FC := gfortran
endif
GDC     ?= gdc
NASM    ?= nasm
FPC     ?= fpc
GM2     ?= gm2

# Detect the compiler's target triplet early so platform guards in the
# RELEASE block and module.mk files can reference it.
TARGET_TRIPLET := $(shell $(CC) -dumpmachine 2>/dev/null)

# Cross-toolchain prefix derived from $(CC) so OBJCOPY/STRIP match the target.
# e.g. CC=aarch64-linux-gnu-gcc -> aarch64-linux-gnu-objcopy.  Empty for native.
_TOOLCHAIN_PREFIX := $(shell echo "$(CC)" | sed -E 's|.*/||; s/(gcc|clang|cc)(-[0-9.]+)?$$//')
OBJCOPY ?= $(_TOOLCHAIN_PREFIX)objcopy
STRIP   ?= $(_TOOLCHAIN_PREFIX)strip

# Release build flags.  Invoke with `make RELEASE=1` for optimized binaries.
#
# Override architecture: `make RELEASE=1 RELEASE_MARCH=x86-64-v3`
#
# The flags are injected into compile/link macros below so they apply
# regardless of per-target CFLAGS/LDFLAGS settings.
#
# To detect what options are available to you on x86-64 for RELEASE_MARCH :
#    /lib64/ld-linux-x86-64.so.2 --help
#
ifdef RELEASE
  ifeq ($(RELEASE_MARCH),)
    RELEASE_MARCH := native
  endif

  # --- LTO detection ----------------------------------------------------------
  # Probe compile + archive + link to catch ar/linker LTO incompatibilities.
  LTO_SUPPORTED := $(shell _d=$$(mktemp -d) && \
	  echo 'int lto_ok(void){return 0;}' | $(CC) -flto -c -x c - -o $$_d/t.o 2>/dev/null && \
	  $(AR) rc $$_d/t.a $$_d/t.o 2>/dev/null && \
	  echo 'int lto_ok(void); int main(void){return lto_ok();}' \
	    | $(CC) -flto -x c - $$_d/t.a -o /dev/null 2>/dev/null && \
	  echo yes; rm -rf $$_d)
  ifeq ($(LTO_SUPPORTED),yes)
    ifdef USE_CLANG
      _LTO := -flto=thin
    else
      _LTO := -flto=auto
    endif
  endif

  ifneq ($(findstring emscripten,$(TARGET_TRIPLET)),)
    # Emscripten does not support -march or -Wl,--gc-sections; its own
    # optimizer handles dead-code elimination internally.
    _BUILD_MODE_CFLAGS  := -O2 -g $(_LTO)
    _BUILD_MODE_CPPFLAGS := -DNDEBUG
    _BUILD_MODE_LDFLAGS := $(_LTO)
  else
    _BUILD_MODE_CFLAGS  := -O2 -g $(_LTO) -march=$(RELEASE_MARCH) \
      -ffunction-sections -fdata-sections
    _BUILD_MODE_CPPFLAGS := -DNDEBUG
    _BUILD_MODE_LDFLAGS := $(_LTO) -Wl,--gc-sections -Wl,-O1
  endif
  ifneq ($(findstring emscripten,$(TARGET_TRIPLET)),)
    $(info RELEASE build: Emscripten $(_LTO))
  else
    $(info RELEASE build: -march=$(RELEASE_MARCH) $(_LTO))
  endif
else ifdef DEBUG
  _BUILD_MODE_CFLAGS  := -Og -g -fno-omit-frame-pointer
  _BUILD_MODE_CPPFLAGS :=
  _BUILD_MODE_LDFLAGS := -g
  $(info DEBUG build)
endif

# Split-debug post-link step: extract debug symbols to <exec>.debug, strip the
# binary, and add a .gnu_debuglink section so GDB/LLDB find the symbols by
# filename next to the binary.  Enabled for RELEASE; harmless if absent.
ifdef RELEASE
  define _split_debug
	$(OBJCOPY) --only-keep-debug $@ $@.debug
	$(STRIP) --strip-debug --strip-unneeded $@
	$(OBJCOPY) --add-gnu-debuglink=$@.debug $@
  endef
endif

# Project-wide CFLAGS / CXXFLAGS / CPPFLAGS / etc...
# Override in a top-level module.mk, but don't set multiple times in your
# project or you'll be at the mercy of the last module.mk to set it.
# PROJECT_CFLAGS := -Wall -W -Werror
# PROJECT_CXXFLAGS := -Wall -W -Werror
# PROJECT_CPPFLAGS := -DYOUR_MACRO
# PROJECT_LDFLAGS :=
# PROJECT_LDLIBS :=
# PROJECT_DFLAGS :=
# PROJECT_FFLAGS :=
# PROJECT_GM2FLAGS :=

# Set .RECIPEPREFIX explicitly so $(.RECIPEPREFIX) can be referenced
.RECIPEPREFIX :=	

# A literal newline (used by subst in test_rules)
define newline


endef

# Source extensions (drives compile rule generation)
EXTENSIONS := c cc cpp d m mm f f90 S asm pas mod

# Command Macros
link.c      = $(if $(CXX_MODE),$(CXX),$(CC)) -o $@ $(_BUILD_MODE_LDFLAGS) $(PROJECT_LDFLAGS) $(LDFLAGS) $(if $(LIBDIR),-L$(LIBDIR)) $^ $(PROJECT_LDLIBS) $(LDLIBS)
link.a      = $(RM) $@.tmp && $(AR) $(ARFLAGS) $@.tmp $(filter %.o,$^) && mv -f $@.tmp $@
link.so     = $(if $(CXX_MODE),$(CXX),$(CC)) -shared -o $@ $(_BUILD_MODE_LDFLAGS) $(PROJECT_LDFLAGS) $(LDFLAGS) $^ $(PROJECT_LDLIBS) $(LDLIBS)
compile.c   = $(CC) -c -o $@ $< -MMD -MF $(@:.o=.dep) $(_BUILD_MODE_CFLAGS) $(_BUILD_MODE_CPPFLAGS) $(PROJECT_CFLAGS) $(PROJECT_CPPFLAGS) $(CFLAGS) $(CPPFLAGS)
compile.cc  = $(CXX) -c -o $@ $< -MMD -MF $(@:.o=.dep) $(_BUILD_MODE_CFLAGS) $(_BUILD_MODE_CPPFLAGS) $(PROJECT_CXXFLAGS) $(PROJECT_CPPFLAGS) $(CXXFLAGS) $(CPPFLAGS)
compile.cpp = $(CXX) -c -o $@ $< -MMD -MF $(@:.o=.dep) $(_BUILD_MODE_CFLAGS) $(_BUILD_MODE_CPPFLAGS) $(PROJECT_CXXFLAGS) $(PROJECT_CPPFLAGS) $(CXXFLAGS) $(CPPFLAGS)
compile.d   = $(GDC) -c -o $@ $< -MMD -MF $(@:.o=.dep) $(_BUILD_MODE_CFLAGS) $(_BUILD_MODE_CPPFLAGS) $(PROJECT_DFLAGS) $(PROJECT_CPPFLAGS) $(DFLAGS)
compile.m   = $(CC) -c -o $@ $< -MMD -MF $(@:.o=.dep) $(_BUILD_MODE_CFLAGS) $(_BUILD_MODE_CPPFLAGS) $(PROJECT_CFLAGS) $(PROJECT_CPPFLAGS) $(CFLAGS) $(CPPFLAGS)
compile.mm  = $(CXX) -c -o $@ $< -MMD -MF $(@:.o=.dep) $(_BUILD_MODE_CFLAGS) $(_BUILD_MODE_CPPFLAGS) $(PROJECT_CXXFLAGS) $(PROJECT_CPPFLAGS) $(CXXFLAGS) $(CPPFLAGS)
compile.f   = $(FC) -c -o $@ $< -cpp -MMD -MF $(@:.o=.dep) $(_BUILD_MODE_CFLAGS) $(_BUILD_MODE_CPPFLAGS) $(PROJECT_FFLAGS) $(PROJECT_CPPFLAGS) $(FFLAGS)
compile.f90 = $(FC) -c -o $@ $< -cpp -MMD -MF $(@:.o=.dep) $(_BUILD_MODE_CFLAGS) $(_BUILD_MODE_CPPFLAGS) $(PROJECT_FFLAGS) $(PROJECT_CPPFLAGS) $(FFLAGS)
compile.S   = $(CC) -c -o $@ $< -MMD -MF $(@:.o=.dep) $(_BUILD_MODE_CFLAGS) $(_BUILD_MODE_CPPFLAGS) $(PROJECT_CFLAGS) $(PROJECT_CPPFLAGS) $(ASFLAGS) $(CPPFLAGS)
compile.asm = $(NASM) -f $(NASM_FMT) -o $@ $(NASMFLAGS) $<
compile.pas = $(FPC) -Cn -FE$(@D) -FU$(@D) $(FPCFLAGS) $<
compile.mod = $(GM2) -c -o $@ $< -fcpp -MMD -MF $(@:.o=.dep) $(_BUILD_MODE_CFLAGS) $(_BUILD_MODE_CPPFLAGS) $(PROJECT_GM2FLAGS) $(PROJECT_CPPFLAGS) $(GM2FLAGS)

# Compilation database (compile_commands.json) support.
# Extensions whose compile commands use GCC-style "-c -o" invocation and
# are consumable by clangd / LSP tooling.  NASM and FPC are excluded.
_compdb_exts := c cc cpp d m mm f f90 S mod
# compdb._emit: write a JSON compilation-database fragment alongside each
# object file.  Uses $(file) so it runs at recipe-expansion time with no
# shell overhead.  $(suffix $<) selects the matching compile.X variable.
compdb._emit = $(file >$(@:.o=.cmd.json),{"directory":"$(CURDIR)","command":"$(subst ",\",$(compile.$(patsubst .%,%,$(suffix $<))))","file":"$(abspath $<)"})

# Utility Macros
# explode_dirs: explode a path list into every intermediate directory.
# Recursion depth is bounded by the deepest path (~5-10 levels).
explode_dirs = $(sort $(filter-out .,$(if $1,$(call explode_dirs,$(filter-out $1,$(patsubst %/,%,$(dir $1))))) $(patsubst %/,%,$1)))

# --- Directories ------------------------------------------------------------
# Object files go under _build/<triplet>/ so cross-compiles don't clobber
# each other.  Binaries and libraries go under _out/<triplet>/bin and
# _out/<triplet>/lib respectively.

# Derive target OS and arch from the compiler's triplet so that
# platform-specific variable suffixes (e.g. _SRCS.aarch64) resolve
# correctly even when cross-compiling with CC=aarch64-linux-gnu-gcc.
# Falls back to uname when the compiler cannot report a triplet.
ifdef TARGET_TRIPLET
  _triplet_fields := $(subst -, ,$(TARGET_TRIPLET))
  _TARGET_ARCH := $(word 1,$(_triplet_fields))
  # Map triplet OS component to the uname -s spelling used in suffixes.
  # Some triplets place the OS-bearing word at position 3 (e.g.
  # wasm32-unknown-emscripten), so fall back to findstring on the full
  # triplet when the word-2 check does not match a known OS.
  _triplet_os := $(word 2,$(_triplet_fields))
  _TARGET_OS := $(strip $(if $(findstring emscripten,$(TARGET_TRIPLET)),Emscripten,\
                $(if $(filter linux,$(_triplet_os)),Linux,\
                $(if $(filter apple,$(_triplet_os)),Darwin,\
                $(if $(filter w64 pc,$(_triplet_os)),$(if $(findstring mingw,$(TARGET_TRIPLET)),Windows_NT,\
                $(if $(findstring cygwin,$(TARGET_TRIPLET)),Windows_NT,\
                $(_triplet_os))),\
                $(_triplet_os))))))
else
  _TARGET_OS   := $(shell uname -s)
  _TARGET_ARCH := $(shell uname -m)
endif

ifdef TARGET_TRIPLET
  BUILDDIR := _build/$(TARGET_TRIPLET)
  OUTDIR := _out/$(TARGET_TRIPLET)
else
  BUILDDIR := _build
  OUTDIR := _out
endif
# for executables
BINDIR = $(OUTDIR)/bin
# for shared libraries
LIBDIR = $(OUTDIR)/lib

# Platform-dependent output extensions
ifneq ($(findstring emscripten,$(TARGET_TRIPLET)),)
  EXTENSION.exe := .html
  EXTENSION.dll := .wasm
else ifneq ($(findstring darwin,$(TARGET_TRIPLET)),)
  EXTENSION.exe :=
  EXTENSION.dll := .dylib
else ifneq ($(findstring mingw,$(TARGET_TRIPLET)),)
  EXTENSION.exe := .exe
  EXTENSION.dll := .dll
else ifneq ($(findstring cygwin,$(TARGET_TRIPLET)),)
  EXTENSION.exe := .exe
  EXTENSION.dll := .dll
else
  EXTENSION.exe :=
  EXTENSION.dll := .so
endif
EXTENSION.lib := .a

# NASM object format (platform-dependent)
ifneq ($(findstring darwin,$(TARGET_TRIPLET)),)
  NASM_FMT := macho64
else ifneq ($(findstring mingw,$(TARGET_TRIPLET)),)
  NASM_FMT := win64
else ifneq ($(findstring cygwin,$(TARGET_TRIPLET)),)
  NASM_FMT := win64
else
  NASM_FMT := elf64
endif

# Delete built-in implicit rules -- they conflict with the out-of-tree
# build layout (objects go to BUILDDIR, not alongside sources).
% : %.o
% : %.c
% : %.cc
% : %.cpp
% : %.S
% : %.f
% : %.f90
%.o : %.c
%.o : %.cc
%.o : %.cpp
%.o : %.S
%.o : %.f
%.o : %.f90

### Build Configuration (CONFIG_* options) ###

ifneq ($(MAKECMDGOALS),clean-all)
include $(BUILDDIR)/config.mk
endif

# Make $(BUILDDIR) available on the include path so source files can
# #include "config.h" for non-boolean config parameters.
PROJECT_CPPFLAGS += -I$(BUILDDIR)

### Module Loader ###

# Recursive module.mk discovery.  Seed with top-level module files;
# after each include, read SUBDIRS and queue any new module.mk files.
# Repeat until no new files remain.
TOP := $(CURDIR)/
.DEFAULT_GOAL := all

# look for module.mk at top-level, else default to src/module.mk
_module_files   := $(if $(wildcard module.mk),module.mk,src/module.mk)
_modules_loaded :=

define _load_modules
$(foreach f,$(filter-out $(_modules_loaded),$(_module_files)),\
  $(eval _modules_loaded += $f)\
  $(eval SUBDIRS :=)\
  $(eval include $f)\
  $(foreach d,$(SUBDIRS),\
    $(if $(filter $(dir $f)$d/module.mk,$(_modules_loaded) $(_module_files)),,\
      $(eval _module_files += $(dir $f)$d/module.mk))))
$(if $(filter-out $(_modules_loaded),$(_module_files)),\
  $(eval $(value _load_modules)))
endef

$(eval $(value _load_modules))

### Platform-specific variable merging ###

# Per-target variables can carry .<os>, .<arch>, or .<os>.<arch> suffixes
# (e.g. foo_SRCS.Linux, foo_LDLIBS.Darwin.arm64).  After all module.mk
# files are loaded the suffixed values are appended to the base variable.
# _TARGET_OS is from `uname -s` (Linux, Darwin, Windows_NT under MSYS/Cygwin).
# _TARGET_ARCH is from `uname -m` (x86_64, aarch64, ...).

_target_platform_suffixes = .$(_TARGET_OS) .$(_TARGET_ARCH) .$(_TARGET_OS).$(_TARGET_ARCH)
_merge_one = $(foreach s,$2,$(eval $1_$3 += $($1_$3$s)))

_platform_vars = SRCS GENERATED_SRCS CFLAGS CXXFLAGS CPPFLAGS LDFLAGS LDLIBS \
  ASFLAGS DFLAGS FFLAGS NASMFLAGS FPCFLAGS GM2FLAGS EXTRA_OBJS LIBS \
  EXPORTED_CPPFLAGS EXPORTED_CFLAGS EXPORTED_CXXFLAGS EXPORTED_LDFLAGS EXPORTED_LDLIBS

define _merge_platform_vars
$(foreach V,$(_platform_vars),$(call _merge_one,$1,$2,$V))
endef

$(foreach t,$(EXECUTABLES) $(LIBRARIES) $(SHARED_LIBS),$(eval $(call _merge_platform_vars,$t,$(_target_platform_suffixes))))

### Config-option variable merging ###

# For each CONFIG_FOO = y, merge .CONFIG_FOO suffixed variables into
# their base (same mechanism as platform suffixes above).
_config_suffixes = $(foreach c,$(filter CONFIG_%,$(.VARIABLES)),$(if $(filter y,$($c)),.$c))
$(foreach t,$(EXECUTABLES) $(LIBRARIES) $(SHARED_LIBS),$(eval $(call _merge_platform_vars,$t,$(_config_suffixes))))

# Inject -DCONFIG_FOO=1 for every enabled option.
PROJECT_CPPFLAGS += $(foreach c,$(filter CONFIG_%,$(.VARIABLES)),$(if $(filter y,$($c)),-D$c=1))

### Rules ###

# get_srcs: expand _SRCS (supports wildcards like *.c) relative to _DIR
get_srcs     = $(wildcard $(addprefix $($1_DIR),$($1_SRCS)))
# get_gen_srcs: expand _GENERATED_SRCS relative to BUILDDIR/_DIR
get_gen_srcs = $(addprefix $(BUILDDIR)/$($1_DIR),$($1_GENERATED_SRCS))
# get_objs: map source files to object files (works for any extension)
get_objs     = $(strip $(foreach X,$(EXTENSIONS),$(patsubst %.$X,$(BUILDDIR)/%.o,$(filter %.$X,$(call get_srcs,$1)))))
# get_gen_objs: map generated sources (already under BUILDDIR) to .o files
get_gen_objs = $(strip $(foreach X,$(EXTENSIONS),$(patsubst %.$X,%.o,$(filter %.$X,$(call get_gen_srcs,$1)))))
# get_all_objs: combined regular and generated objects
get_all_objs = $(strip $(call get_objs,$1) $(call get_gen_objs,$1))
# Compiler side-effect files: FPC emits .ppu alongside .o, gm2 emits .d
get_side_effects = $(strip $(patsubst %.pas,$(BUILDDIR)/%.ppu,$(filter %.pas,$(call get_srcs,$1))) \
                   $(patsubst %.mod,$(BUILDDIR)/%.d,$(filter %.mod,$(call get_srcs,$1))))
get_lib      = $(BUILDDIR)/$1$(EXTENSION.lib)
get_so       = $(LIBDIR)/lib$1$(EXTENSION.dll)
get_lib_file = $(if $(filter $1,$(LIBRARIES)),$(call get_lib,$1),$(call get_so,$1))

# Recursive _LIBS resolver: depth-first transitive closure.
# get_all_libs($1) returns all direct and indirect _LIBS for target $1,
# in topological order (dependents before dependencies) so that the
# linker resolves symbols correctly with static archives.
_expand_libs = $(if $1,$(eval _libs_depth += x)$(if $(word 100,$(_libs_depth)),$(error circular _LIBS dependency detected: $1))$(foreach L,$1,$L $(call _expand_libs,$($L_LIBS))))
# _uniq_last: keep last occurrence of each word (preserves topological order
# so that dependencies appear after their dependents for static linking).
_rev = $(if $1,$(call _rev,$(wordlist 2,$(words $1),$1)) $(firstword $1))
_uniq_first = $(if $1,$(firstword $1) $(call _uniq_first,$(filter-out $(firstword $1),$1)))
_uniq_last = $(call _rev,$(call _uniq_first,$(call _rev,$1)))
get_all_libs = $(eval _libs_depth :=)$(call _uniq_last,$(call _expand_libs,$($1_LIBS)))

# Collect exported flags from all transitive _LIBS dependencies.
get_exported_cppflags = $(strip $(foreach L,$(call get_all_libs,$1),$($L_EXPORTED_CPPFLAGS)))
get_exported_cflags   = $(strip $(foreach L,$(call get_all_libs,$1),$($L_EXPORTED_CFLAGS)))
get_exported_cxxflags = $(strip $(foreach L,$(call get_all_libs,$1),$($L_EXPORTED_CXXFLAGS)))
get_exported_ldflags  = $(strip $(foreach L,$(call get_all_libs,$1),$($L_EXPORTED_LDFLAGS)))
get_exported_ldlibs   = $(strip $(foreach L,$(call get_all_libs,$1),$($L_EXPORTED_LDLIBS)))

# needs_cxx: true if target $1 or any transitive dep has C++/Obj-C++ sources
needs_cxx = $(or $(filter %.cc %.cpp %.mm,$(call get_srcs,$1) $(call get_gen_srcs,$1)),$(strip $(foreach L,$(call get_all_libs,$1),$(filter %.cc %.cpp %.mm,$(call get_srcs,$L) $(call get_gen_srcs,$L)))))

# _all_dirs: every directory that contains a build artifact (used by clean-all)
_all_dirs = $(sort $(dir \
  $(foreach p,$(EXECUTABLES),$(BINDIR)/$p$(EXTENSION.exe) $(call get_all_objs,$p)) \
  $(foreach l,$(LIBRARIES),$(call get_lib,$l) $(call get_all_objs,$l)) \
  $(foreach s,$(SHARED_LIBS),$(call get_so,$s) $(call get_all_objs,$s))))

.SECONDEXPANSION:

# Ensure directories exist for generated sources so that module.mk code
# generation rules do not need order-only directory prerequisites
# (secondary expansion is not available in module.mk files).
_all_gen_srcs := $(foreach t,$(EXECUTABLES) $(LIBRARIES) $(SHARED_LIBS),$(call get_gen_srcs,$t))
$(_all_gen_srcs) : | $$(@D)/

all :: $$(EXECUTABLES) compile_commands.json
clean : $$(addprefix clean_,$$(EXECUTABLES) $$(LIBRARIES) $$(SHARED_LIBS))
clean-all : clean
	$(RM) $(BUILDDIR)/config.mk $(BUILDDIR)/config.h $(BUILDDIR)/config.h.tmp
	-printf '%s\n' $(call explode_dirs,$(_all_dirs)) | sort -r | while read -r d; do $(RMDIR) "$$d" 2>/dev/null; done; true
	$(RM) compile_commands.json
.PHONY : all clean clean-all clean_% defconfig $(EXECUTABLES) $(LIBRARIES) $(SHARED_LIBS)

# config.mk: auto-created from defconfig on first build.
# Only fires when config.mk does not exist yet; updates go through
# 'make defconfig'.
ifeq ($(wildcard $(BUILDDIR)/config.mk),)
ifneq ($(wildcard defconfig),)
$(BUILDDIR)/config.mk : defconfig | $(BUILDDIR)/
	cp $< $@
else
$(BUILDDIR)/config.mk : | $(BUILDDIR)/ ; touch $@
endif
endif

# defconfig: reset config.mk from a template.
defconfig : | $(BUILDDIR)/
	$(if $(wildcard defconfig),cp defconfig $(BUILDDIR)/config.mk,$(error no defconfig found))
defconfig_% : | $(BUILDDIR)/
	$(if $(wildcard configs/$*.mk),cp configs/$*.mk $(BUILDDIR)/config.mk,$(error no configs/$*.mk found))

# config.h: auto-generated header from config.mk.
# CONFIG_FOO = y  ->  #define CONFIG_FOO 1
# CONFIG_BAR = n  ->  (skipped)
# CONFIG_X = val  ->  #define CONFIG_X val
# Uses compare-and-swap to avoid unnecessary rebuilds.
$(BUILDDIR)/config.h : $(BUILDDIR)/config.mk | $(BUILDDIR)/
	@awk '/^[A-Za-z_][A-Za-z0-9_]*[[:space:]]*[?:]*=/ { \
		name = $$1; \
		value = $$0; sub(/^[^=]*=[[:space:]]*/, "", value); \
		if (name ~ /^CONFIG_/ && value == "y") \
			print "#define " name " 1"; \
		else if (value != "n" && value != "") \
			print "#define " name " " value; \
	}' $< > $@.tmp 2>/dev/null; \
	cmp -s $@.tmp $@ 2>/dev/null && rm -f $@.tmp || mv -f $@.tmp $@


# Create directories
%/ : ; $(MKDIR_P) $@
.PRECIOUS : %/

# Per-library rules: compile objects and pack into a static archive.
define library_rules
$1 : $(call get_lib,$1)
$(call get_lib,$1) : $$(call get_all_objs,$1) $$($1_EXTRA_OBJS) $(foreach d,$($1_LIBS),$(call get_lib_file,$d)) | $$(@D)/
	$$(link.a)
$(call get_all_objs,$1) : CFLAGS=$$($1_CFLAGS) $(call get_exported_cflags,$1)
$(call get_all_objs,$1) : CXXFLAGS=$$($1_CXXFLAGS) $(call get_exported_cxxflags,$1)
$(call get_all_objs,$1) : CPPFLAGS=$$($1_CPPFLAGS) $(call get_exported_cppflags,$1)
$(call get_all_objs,$1) : DFLAGS=$$($1_DFLAGS)
$(call get_all_objs,$1) : FFLAGS=$$($1_FFLAGS)
$(call get_all_objs,$1) : ASFLAGS=$$($1_ASFLAGS)
$(call get_all_objs,$1) : NASMFLAGS=$$($1_NASMFLAGS)
$(call get_all_objs,$1) : FPCFLAGS=$$($1_FPCFLAGS)
$(call get_all_objs,$1) : GM2FLAGS=$$($1_GM2FLAGS)
clean_$1 :
	$$(RM) $$(call get_all_objs,$1) $$(patsubst %.o,%.dep,$$(call get_all_objs,$1)) $$(patsubst %.o,%.cmd.json,$$(call get_all_objs,$1)) $$(call get_side_effects,$1) $$(call get_gen_srcs,$1)
	$$(RM) $(call get_lib,$1)
endef
$(foreach l,$(LIBRARIES),$(eval $(call library_rules,$l)))

# Per-shared-library rules: compile with -fPIC, link with -shared.
define shared_library_rules
$1 : $(call get_so,$1)
$(call get_so,$1) : $$(call get_all_objs,$1) $$($1_EXTRA_OBJS) $(foreach d,$($1_LIBS),$(call get_lib_file,$d)) | $$(@D)/
	$$(link.so)
$(call get_so,$1) : CXX_MODE=$(if $(call needs_cxx,$1),1)
$(call get_so,$1) : LDFLAGS=$$($1_LDFLAGS) $(call get_exported_ldflags,$1)
$(call get_so,$1) : LDLIBS=$$($1_LDLIBS) $(call get_exported_ldlibs,$1)
$(call get_all_objs,$1) : CFLAGS=-fPIC $$($1_CFLAGS) $(call get_exported_cflags,$1)
$(call get_all_objs,$1) : CXXFLAGS=-fPIC $$($1_CXXFLAGS) $(call get_exported_cxxflags,$1)
$(call get_all_objs,$1) : CPPFLAGS=$$($1_CPPFLAGS) $(call get_exported_cppflags,$1)
$(call get_all_objs,$1) : DFLAGS=-fPIC $$($1_DFLAGS)
$(call get_all_objs,$1) : FFLAGS=-fPIC $$($1_FFLAGS)
$(call get_all_objs,$1) : ASFLAGS=-fPIC $$($1_ASFLAGS)
$(call get_all_objs,$1) : NASMFLAGS=$$($1_NASMFLAGS)
$(call get_all_objs,$1) : FPCFLAGS=-Cg $$($1_FPCFLAGS)
$(call get_all_objs,$1) : GM2FLAGS=-fPIC $$($1_GM2FLAGS)
clean_$1 :
	$$(RM) $$(call get_all_objs,$1) $$(patsubst %.o,%.dep,$$(call get_all_objs,$1)) $$(patsubst %.o,%.cmd.json,$$(call get_all_objs,$1)) $$(call get_side_effects,$1) $$(call get_gen_srcs,$1)
	$$(RM) $(call get_so,$1)
endef
$(foreach s,$(SHARED_LIBS),$(eval $(call shared_library_rules,$s)))

# Per-project rules: compile objects and link with libraries from LIBS.
# The compile rule is per-project so that CFLAGS/CPPFLAGS are set correctly
# for each object -- target-specific variables on the link target do not
# reliably propagate to prerequisite pattern rules in GNU Make.
define project_rules
$1_EXEC := $(BINDIR)/$1$(EXTENSION.exe)
$1 : $(BINDIR)/$1$(EXTENSION.exe)
$(BINDIR)/$1$(EXTENSION.exe) : $$(call get_all_objs,$1) $$($1_EXTRA_OBJS) $(foreach d,$(call get_all_libs,$1),$(call get_lib_file,$d)) | $(BINDIR)/
	$$(link.c)
	$$(_split_debug)
$(BINDIR)/$1$(EXTENSION.exe) : CXX_MODE=$(if $(call needs_cxx,$1),1)
$(BINDIR)/$1$(EXTENSION.exe) : LDFLAGS=$$($1_LDFLAGS) $(call get_exported_ldflags,$1)
$(BINDIR)/$1$(EXTENSION.exe) : LDLIBS=$$($1_LDLIBS) $(call get_exported_ldlibs,$1)
$(call get_all_objs,$1) : CFLAGS=$$($1_CFLAGS) $(call get_exported_cflags,$1)
$(call get_all_objs,$1) : CXXFLAGS=$$($1_CXXFLAGS) $(call get_exported_cxxflags,$1)
$(call get_all_objs,$1) : CPPFLAGS=$$($1_CPPFLAGS) $(call get_exported_cppflags,$1)
$(call get_all_objs,$1) : DFLAGS=$$($1_DFLAGS)
$(call get_all_objs,$1) : FFLAGS=$$($1_FFLAGS)
$(call get_all_objs,$1) : ASFLAGS=$$($1_ASFLAGS)
$(call get_all_objs,$1) : NASMFLAGS=$$($1_NASMFLAGS)
$(call get_all_objs,$1) : FPCFLAGS=$$($1_FPCFLAGS)
$(call get_all_objs,$1) : GM2FLAGS=$$($1_GM2FLAGS)
clean_$1 :
	$$(RM) $$(call get_all_objs,$1) $$(patsubst %.o,%.dep,$$(call get_all_objs,$1)) $$(patsubst %.o,%.cmd.json,$$(call get_all_objs,$1)) $$(call get_side_effects,$1) $$(call get_gen_srcs,$1)
	$$(RM) $(BINDIR)/$1$(EXTENSION.exe) $(BINDIR)/$1$(EXTENSION.exe).debug$(if $(findstring emscripten,$(TARGET_TRIPLET)), $(BINDIR)/$1.js $(BINDIR)/$1.wasm $(BINDIR)/$1.data)
endef
$(foreach p,$(EXECUTABLES),$(eval $(call project_rules,$p)))

# Per-target test rules: build the target, then run its _TESTCMD.
# The subst inserts .RECIPEPREFIX after each newline so multi-line
# TESTCMDs become separate recipe lines (each checked for errors by Make).
define test_rules
.PHONY : run-test-$1
run-test-$1 : $1
	$$(subst $$(newline),$$(newline)$$(.RECIPEPREFIX),$$($1_TESTCMD))
endef
$(foreach t,$(TEST_TARGETS),$(eval $(call test_rules,$t)))

.PHONY : run-tests
run-tests : $(addprefix run-test-,$(TEST_TARGETS))

# Compile rules -- generated from EXTENSIONS list.  Per-target flags are
# set via target-specific variables on the individual .o files above.
# clangd-compatible extensions also emit a .cmd.json sidecar via $(file).
$(foreach X,$(_compdb_exts),$(eval $(BUILDDIR)/%.o : %.$X | $$$$(@D)/ ; $$(compile.$X)$$(compdb._emit)))
$(foreach X,$(filter-out $(_compdb_exts),$(EXTENSIONS)),$(eval $(BUILDDIR)/%.o : %.$X | $$$$(@D)/ ; $$(compile.$X)))

# Compile rules for generated sources (source and object both under BUILDDIR).
$(foreach X,$(_compdb_exts),$(eval $(BUILDDIR)/%.o : $(BUILDDIR)/%.$X | $$$$(@D)/ ; $$(compile.$X)$$(compdb._emit)))
$(foreach X,$(filter-out $(_compdb_exts),$(EXTENSIONS)),$(eval $(BUILDDIR)/%.o : $(BUILDDIR)/%.$X | $$$$(@D)/ ; $$(compile.$X)))

# Pull in generated dependency files (silent on first build)
-include $(patsubst %.o,%.dep,$(foreach p,$(EXECUTABLES) $(LIBRARIES) $(SHARED_LIBS),$(call get_all_objs,$p)))

# Generate compile_commands.json for clangd / LSP tooling.
# Each clangd-compatible compile rule emits a .cmd.json sidecar via
# $(file) (see compdb._emit above).  This target depends on all object
# files so the sidecars are created first, then concatenates them.
_all_objs := $(foreach p,$(EXECUTABLES) $(LIBRARIES) $(SHARED_LIBS),$(call get_all_objs,$p))
$(_all_objs) : $(BUILDDIR)/config.h
compile_commands.json : $(_all_objs)
	@cat $(wildcard $(patsubst %.o,%.cmd.json,$^)) /dev/null \
	| awk 'BEGIN{printf "["}NR>1{printf ","}  \
	  {printf "\n  %s",$$0}END{printf "\n]\n"}' > $@
	@echo "wrote $@ ($$(grep -c '"file"' $@) entries)"

##### END #####
