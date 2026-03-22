# src/tests/module.mk : smoke test target

.PHONY: smoke smoke-valgrind

smoke: $(BINDIR)/boris
	@src/tests/test_smoke.sh

smoke-valgrind: $(BINDIR)/boris
	@USE_VALGRIND=1 src/tests/test_smoke.sh
