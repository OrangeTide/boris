LIBRARIES += ui
ui_DIR   := $(dir $(lastword $(MAKEFILE_LIST)))
ui_SRCS   = ui.c ui_render_text.c ui_telnet.c
ui_LIBS   = stred log
ui_EXPORTED_CPPFLAGS = -I$(ui_DIR)

EXECUTABLES     += test_ui
TEST_TARGETS    += test_ui
test_ui_DIR := $(ui_DIR)
test_ui_SRCS = test_ui.c
test_ui_LIBS = ui log
define test_ui_TESTCMD
$(test_ui_RUN)
endef
