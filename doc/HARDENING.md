# Build Hardening and Testing Tools

Checklist of compiler/tooling options for boris, prioritized by
bang-for-effort. Each item has a rationale, status, and integration notes.

## Priority 1 -- High Value, Low Effort

### [ ] ASan + UBSan (`-fsanitize=address,undefined`)

**What it catches:** heap/stack buffer overflows, use-after-free, double-free,
heap-use-after-scope, stack buffer underflow, signed integer overflow, null
pointer dereference, shift past bitwidth, misaligned access, implicit
conversions.

**Why it matters here:** obj.c and muddb.c do extensive manual
malloc/realloc/free with memmove on token arrays and data buffers. The JSON
path writes null terminators into borrowed buffers (`json_token_tostr`).
telnetclient.c handles untrusted network input. These are exactly the patterns
ASan was designed to catch.

**Effort:** Add a `make tests-asan` / `make smoke-asan` target. Compile and
link with `-fsanitize=address,undefined -fno-omit-frame-pointer`.
No code changes required -- just build flags. Both GCC 13 and Clang 18
support it.

**Constraints:**
- Incompatible with valgrind (pick one per run).
- Incompatible with TSan (separate build required).
- Roughly 2x slowdown, 2-3x memory overhead -- fine for tests.
- Third-party code (lmdb, mongoose, jsmn) gets instrumented too, which is
  actually useful since we ship it.

**Integration plan:**
1. Add `SANITIZE=asan` variable to GNUmakefile or module.mk that injects
   `-fsanitize=address,undefined -fno-omit-frame-pointer` into compile and
   link flags.
2. Add `make tests-asan` that builds with the sanitizer and runs tests.
3. Add `make smoke-asan` that builds the server with the sanitizer and runs
   the smoke test suite against it.
4. Set `ASAN_OPTIONS=detect_leaks=1:abort_on_error=1` in the test runner
   so failures are loud.

---

### [ ] gcov / lcov (code coverage)

**What it shows:** Which lines and branches in the test suite actually
execute. Identifies dead code and untested paths.

**Why it matters here:** There are 16 test files covering obj, muddb,
hashtable, combat, entity, net, dice, charset, wordwrap, etc. plus smoke
tests. But we have no visibility into what percentage of boris's ~24k lines
those tests actually exercise. Coverage data directly prioritizes where to
write the next test.

**Effort:** Compile with `--coverage` (equivalent to `-fprofile-arcs
-ftest-coverage`), run tests, then `lcov` + `genhtml` for an HTML report.
No code changes. GCC 13 and Clang 18 both support it (Clang uses
`llvm-cov gcov` as the gcov-compatible tool).

**Integration plan:**
1. Add `make coverage` target: clean build with `--coverage`, run tests,
   generate HTML report to `_coverage/`.
2. Add `_coverage/` to `.gitignore`.
3. Consider filtering out `src/thirdparty/` from the report to focus on
   our own code.

---

## Priority 2 -- High Value, Moderate Effort

### [ ] Fuzz testing (libFuzzer or AFL++)

**What it catches:** Crashes, hangs, memory errors, and assertion failures
triggered by malformed input. Particularly effective at finding edge cases
in parsers.

**Why it matters here:** The server processes untrusted input at multiple
layers:
- jsmn JSON parser (obj.c wraps it, and objects come from network/database).
- TELNET protocol negotiation (mth).
- HTTP/WebSocket framing (mongoose).
- Login/form/command text parsing in telnetclient.c, command.c.
- OBJ property set/get/delete/serialize with arbitrary key/value strings.

Fuzz testing the OBJ layer and command parser would be particularly
high-payoff since they operate on untrusted data with manual memory
management.

**Effort:** Requires writing fuzz harness functions (`LLVMFuzzerTestOneInput`
for libFuzzer, or stdin-based harnesses for AFL++). Each harness is typically
20-50 lines. libFuzzer is Clang-only; AFL++ works with both GCC and Clang.

**Integration plan:**
1. Create `src/fuzz/` directory with harness files:
   - `fuzz_obj_parse.c` -- feed arbitrary bytes to `obj_new_from_json`.
   - `fuzz_obj_mutations.c` -- parse then random set/get/delete sequences.
   - `fuzz_command.c` -- feed arbitrary command strings.
2. Add `EXECUTABLES += fuzz_*` with `-fsanitize=fuzzer,address,undefined`.
3. Add `make fuzz-obj` / `make fuzz-command` targets.
4. Store corpus in `src/fuzz/corpus/` seeded from sample JSON and commands.

---

### [ ] Release hardening (PIE + stack protector + RELRO + FORTIFY)

**What it provides:** Defense-in-depth for the deployed binary against
memory corruption exploits. Multiple orthogonal mitigations:

| Flag | What it does |
|------|-------------|
| `-fPIE -pie` | Full ASLR for the executable (randomized load address) |
| `-fstack-protector-strong` | Stack canary on functions with local arrays/buffers |
| `-D_FORTIFY_SOURCE=2` | Runtime bounds checking on string/memory functions |
| `-Wformat -Wformat-security` | Catch format string vulnerabilities at compile time |
| `-Wl,-z,relro,-z,now` | Full RELRO -- read-only GOT, immediate binding |
| `-Wl,-z,noexecstack` | Non-executable stack (usually default, belt and suspenders) |

**Why it matters here:** boris is a network-facing server accepting
connections from the internet. Even if the code is correct today, defense
in depth protects against future regressions. These flags are essentially
free at runtime (PIE has negligible overhead on x86-64, stack protector
is a few instructions per function).

**Effort:** Add flags to the RELEASE block in GNUmakefile. No code
changes unless `-Wformat-security` finds existing issues (which would
be worth fixing).

**Integration plan:**
1. Add to `_BUILD_MODE_CFLAGS` in the RELEASE block of GNUmakefile:
   `-fPIE -fstack-protector-strong -Wformat -Wformat-security`.
2. Add to `_BUILD_MODE_CPPFLAGS`: `-D_FORTIFY_SOURCE=2`.
3. Add to `_BUILD_MODE_LDFLAGS`: `-pie -Wl,-z,relro,-z,now -Wl,-z,noexecstack`.
4. Verify with `checksec` or `readelf -l` that the binary has all
   mitigations enabled.

---

## Priority 3 -- Moderate Value, Low-Moderate Effort

### [ ] TSan (`-fsanitize=thread`)

**What it catches:** Data races, lock-order inversions, use of destroyed
mutexes, thread leaks.

**Why it matters here:** Currently the server is single-threaded (event
loop) with mutexes only in muddb.c (write transaction serialization)
and msgqueue.c. The long-term plan is multithreading. TSan would catch
races in the existing mutex-protected paths and will become essential
as threading is introduced.

**Constraints:**
- Mutually exclusive with ASan -- requires a separate build.
- Clang's TSan is more mature than GCC's (prefer `USE_CLANG=1`).
- 5-15x slowdown, 5-10x memory overhead -- too heavy for routine CI,
  good for periodic runs.
- Third-party code (LMDB uses internal threading) may produce findings
  that need suppression files.

**Integration plan:**
1. Add `SANITIZE=tsan` build mode: `-fsanitize=thread
   -fno-omit-frame-pointer`.
2. Add `make tests-tsan` and `make smoke-tsan` targets.
3. Create `tsan.suppressions` for known third-party issues.
4. Run periodically or before multithreading work.

---

### [ ] MSan (`-fsanitize=memory`)

**What it catches:** Reads of uninitialized memory -- a class of bug that
ASan does not detect and valgrind catches but slowly.

**Why it matters here:** The OBJ layer reads from token start/end offsets
into a data buffer that grows but is not zeroed. Command parsing reads
from network buffers. Uninitialized reads are a real risk.

**Constraints:**
- **Clang-only.**
- Requires all linked code (including libc) to be MSan-instrumented,
  or false positives flood the output. In practice this means either:
  (a) building against an MSan-instrumented libc (musl is easier than
  glibc), or (b) using extensive suppressions and accepting partial
  coverage.
- Incompatible with ASan and TSan.
- The practical effort to get clean results is high relative to the
  other sanitizers.

**Integration plan:**
1. Add `SANITIZE=msan` build mode (Clang-only).
2. Start with unit tests only (no libc-heavy server paths).
3. Accept that third-party code and libc calls produce noise.
4. Consider as lower priority unless specific uninitialized-read bugs
   surface.

**Verdict:** High effort for partial results. Valgrind's
`--track-origins=yes` (already in `make tests-valgrind`) covers much of
the same ground with less setup pain. Revisit if valgrind becomes too slow
or if we need CI-speed uninitialized-memory detection.

---

## Priority 4 -- Low Value for Current State

### [ ] gprof (`-pg`)

**What it shows:** Call graph and flat profile of CPU time per function.

**Why it matters here:** boris is I/O-bound (blocking on epoll/select,
waiting for network events and LMDB transactions). CPU profiling a
mostly-idle event loop produces data that is hard to act on. gprof
also has known limitations: it does not profile shared libraries, it
uses sampling that misses short functions, and it requires a clean exit
(no SIGKILL).

**Better alternatives:**
- `perf record` / `perf report` -- sampling profiler with no
  instrumentation overhead, works on unmodified release binaries,
  profiles kernel time too.
- `perf stat` -- hardware counter summary (cache misses, branch
  mispredictions) for specific workloads.
- Valgrind's `callgrind` -- instruction-level profiling, slow but
  precise.

**Verdict:** Skip gprof. If performance profiling is needed, use `perf`
on a release build. No build system changes required for `perf`. Add a
`make profile` convenience target only if/when a specific performance
problem needs investigation.

---

## Implementation Order

Suggested order based on value and dependencies:

1. **ASan + UBSan** -- immediate, catches the most dangerous bugs with
   the least effort. Run on every test cycle during development.
2. **gcov** -- immediate, tells us where to focus testing effort.
3. **Release hardening** -- next release, protects deployed binaries.
4. **Fuzz testing** -- after ASan is integrated (fuzzing + ASan is the
   standard combination). Start with OBJ parser.
5. **TSan** -- when multithreading work begins.
6. **MSan** -- only if a specific class of bug warrants it.
7. **gprof** -- skip; use `perf` ad-hoc instead.

## Build System Integration

All sanitizer/coverage modes should follow the same pattern as the
existing `DEBUG` / `RELEASE` modes in the Makefile. Proposed variable:

```
make tests SANITIZE=asan       # ASan + UBSan
make tests SANITIZE=tsan       # TSan
make tests SANITIZE=msan       # MSan (Clang only)
make coverage                  # gcov + lcov report
make tests-asan                # shorthand
make smoke-asan                # smoke tests under ASan
```

This keeps the interface consistent and avoids polluting the normal
build with sanitizer overhead.
