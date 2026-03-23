# src/tests/module.mk : smoke test target

.PHONY: smoke smoke-valgrind

smoke: $(BINDIR)/boris $(BINDIR)/muddb-tool
	@src/tests/test_smoke.sh

smoke-valgrind: $(BINDIR)/boris $(BINDIR)/muddb-tool
	@USE_VALGRIND=1 src/tests/test_smoke.sh
