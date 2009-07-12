##############################################################################
# boris configuration
SRCS_boris := boris.c
OBJS_boris := $(SRCS_boris:.c=.o)
EXEC_boris := boris$(EXE)
CLEAN_boris := $(OBJS_boris) $(EXEC_boris)
MODULES += boris

# enable BSD related features.
$(OBJS_boris) : CPPFLAGS+=-D_BSD_SOURCE

$(EXEC_boris) : $(OBJS_boris)

ifneq ($(GCC_WIN32),)
# use Winsock2 when building for windows
$(EXEC_boris) : LDLIBS+=-lws2_32
else
$(EXEC_boris) : LDLIBS+=-ldl
endif

documentation-boris :
	doxygen Doxyfile.boris
##############################################################################
