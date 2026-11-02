# Kobold-Pascal Diagnostics

This document covers diagnostics at two stages: the errors the compiler reports
while translating a program, and the runtime facilities a program uses to check
itself as it runs.

## Compiler diagnostics

The front end reports every error as `file:line:col: error[CODE]: message` on standard
error, followed by the offending source line and a caret under the column, in the
gcc/clang style. `CODE` is a stable machine-readable class (see Error codes below):

```
prog.pas:5:8: error[E0003]: undeclared identifier 'other'
  i := other + 1;
       ^
```

A tab in the line's leading text is copied into the caret's padding, so the caret
stays aligned in a terminal. The compiler keeps going so one run surfaces more than
a single problem. It works in phases and stops between them, which keeps the error
list honest rather than flooding it with cascades from an earlier failure:

- **Parse.** The recursive-descent parser recovers at statement and declaration
  boundaries (`Synchronize`), so a single parse reports many syntax errors instead
  of dying on the first. `Expect` names what it wanted and what it found, for
  example `expected ';', found 'end'`.
- **Semantic.** Analysis runs only on a clean parse, so a malformed tree never
  feeds it garbage. It then reports as many name and type errors as it finds in one
  pass, giving a bad expression an error type so one mistake does not invalidate
  every use that follows.
- **Lowering.** A construct the backend cannot yet emit is reported once, at its
  source location, rather than producing a broken module.

Any error means no module is written (`--emit-kpm` produces nothing) and `kpcom`
exits non-zero, so a build step can gate on it.

The compiler also emits **warnings**, which use the same `file:line:col` form with a
`warning:` label and the source excerpt. A warning is advisory: it does not count as
an error, so the module is still written and the exit code stays zero. The first warning
is an unused local variable, reported at a routine's `var` that is declared but never
referenced:

```
prog.pas:8:3: warning[W0001]: variable 'spare' is declared but never used
  spare: integer;
  ^
```

A variable that is read anywhere is not flagged. Parameters have their own warning, described
below.

A related warning covers a local variable that is assigned but whose value is never read.
It is reported at the same `var` declaration:

```
prog.pas:8:3: warning[W0003]: variable 'tmp' is assigned but its value is never read
  tmp: integer;
  ^
```

The loop counter of a `for` loop is treated as read, since the loop tests it against its
bound, so a counting loop that ignores the counter in its body is not flagged. A handle or a
coroutine is also left alone, because either can be held in a write-only local on purpose for
a lifecycle that the scope end closes. As with the unused-variable warning, only routine
locals are checked, not globals.

A parameter that is never referenced in a routine body is also flagged:

```
prog.pas:3:20: warning[W0002]: parameter 'count' is never used
  procedure f(count: integer);
                   ^
```

An interface or callback signature can force a parameter that a given body does not touch.
Prefixing the name with an underscore, such as `_count`, says the author knows and silences
the warning. A method receiver is never flagged, since a method may legitimately ignore it.
A routine with no body (an `external` or a forward header) is not checked, so only a body that
could use the parameter is held to it.

The next warning is a declaration that shadows a built-in. Predefined names (base
types and built-in routines) live in an outer system scope, so a user declaration of
the same name is allowed and shadows the built-in rather than colliding with it. That
is a legal choice, but an easy mistake, so it draws an advisory warning:

```
prog.pas:9:3: warning[W0004]: declaration of 'copy' shadows a built-in
  copy: integer;
  ^
```

Only the program's own scopes are checked, so reading a used unit's interface never
raises it.

A further warning covers a narrowing conversion. Storing a 64-bit `int64` into a
32-bit `integer` silently drops the high half. Both are exact integer types, so the
loss usually hides a bug rather than being intended:

```
prog.pas:7:5: warning[W0005]: narrowing conversion from int64 to integer may lose data; use an explicit integer(...) conversion to silence this
  i := big;
      ^
```

An explicit `integer(...)` conversion states that the truncation is intended and
silences the warning, since its result already has the narrower type. Widening the
other way, an `integer` into an `int64`, keeps the value and is not flagged. Storing a
double into a `single` is deliberately not flagged either: the `single` type is defined
to narrow on store, with computation staying in f64, so a narrowing there is the type
working as designed rather than a mistake.

### Error codes

Every diagnostic carries a stable code in brackets next to its severity, so a host or an
editor can filter, suppress, or link a class of diagnostic without parsing the message text.
An error code is `E####`, a warning code is `W####`, and a code never changes meaning once
assigned. Errors are grouped by phase and broad class; each warning kind has its own code.

| Code  | Class |
|-------|-------|
| E0001 | Lexical: a character or token the scanner cannot read. |
| E0002 | Syntax: the parser expected something else. |
| E0003 | Name: an undeclared or duplicate name, or a name used where its kind does not fit. |
| E0004 | Type: a type clash or another semantic error. The default for the semantic phase. |
| E0005 | Lowering: a construct the backend cannot emit. |
| W0001 | An unused local variable. |
| W0002 | An unused parameter. |
| W0003 | A variable assigned but never read. |
| W0004 | A declaration that shadows a built-in. |
| W0005 | A narrowing conversion. |

The error codes are coarse on purpose. They name the phase and broad class of a failure rather
than a unique message, so the set stays small and stable as messages are reworded. The warning
codes are one per kind, which is what a per-class suppression would key on.

### Quality and current limits

The reporting is correct, located, and shows the source line with a caret. The known
gaps, in rough priority, are the work between a usable compiler and a comfortable one:

- **Warnings.** The warnings are the unused local variable, the assigned-but-never-read
  variable, the unused parameter, the shadowed built-in, and the narrowing conversion
  above. There are no notes attached to an error.
- **Suggestions (partial).** An undeclared name now gets a "did you mean 'X'?" suffix when a
  visible name is a close typo (one edit always, two edits for a name of four characters or
  more), by `SuggestName` over the scope chain. A wrong field or member name does not yet
  suggest.
- **Cross-phase stopping.** A syntax error hides the file's type errors until the
  syntax is clean. This is deliberate, it removes cascade noise, but it can add
  passes to a fix-and-recompile loop compared with a compiler that reports across
  phases at once.
- **Terse wording.** A message states the fact (`expected X, found Y`) without the
  surrounding rule or a hint at the likely cause.

None of these block writing a correct program; they are the main
language-surface-adjacent work left before 1.0.

## Runtime diagnostics

Kobold-Pascal keeps the runtime small, so most run-time diagnostics live in the
guest language rather than the C VM. The compiler self-hosts and the guest has full
I/O, so assertions, tracing, and line coverage are ordinary Pascal that a program
writes for itself. The VM adds only one primitive that the guest cannot express
on its own, because it reaches into the runtime.

The worked example is `tests/kp-corpus/strleak.pas`, run by `skj-kp-jit` (or
built ahead of time through `kobold/aot-run.sh`). It runs as part of `make
check-kp-corpus`.

## The host primitive

A guest program declares it as an external function:

```pascal
function heapLive: integer; external;
```

`heapLive` returns the live guest-heap bytes, the storage behind dynamic arrays
and strings. On its own the number is not meaningful. The value of a call is the
difference between two readings taken around a scope, which is how a guest checks
that the scope frees everything it allocated. `tests/kp-corpus/strleak.pas` uses
it this way: it records `heapLive`, runs a string-churning procedure a thousand
times, and reads `heapLive` again, so a non-zero delta means an operation leaks
an intermediate.

`heapLive` is bound by `kp_install_runtime` (the `BIND` table) in
`kobold/kp_host.c`, so any host that wires up the standard runtime gets it. The
byte count is `kp_gheap_live`, defined in `kobold/rt_host.c` for a hosted build
and `kobold/rt_free.c` for the freestanding tier.

## Building diagnostics on top

Everything else is plain Pascal.

**Assertions** are built in: `assert(cond)` is a runtime fault (exit 70) when
`cond` is false, and `abort` is the unconditional form (kp-builtins.md). Unlike
the `halt`-based wrapper below, a failed `assert` faults like an index or
arithmetic trap, so on skj-run (RISC-V) it prints a symbolized source-level
backtrace rather than just a message. For an assertion that carries its own text
or a custom exit code, the `WriteLn`-and-`halt` wrapper still works:

```pascal
procedure AssertMsg(cond: boolean; msg: string);
begin
  if not cond then
  begin
    WriteLn('assertion failed: ', msg);
    halt(1);
  end;
end;
```

**Line coverage** is a counter array the program bumps at points of interest,
then prints as a tally at the end:

```pascal
var cov: array[0..NLINES] of integer;

procedure Hit(line: integer);
begin
  cov[line] := cov[line] + 1;
end;
```

The line numbers are passed by hand here. A program instruments the points it
cares about; there is no compiler pass injecting the calls.

**Leak checking** reads `heapLive` before and after a scope and compares:

```pascal
base := heapLive;
Churn;               { allocates and drops strings and a dynamic array }
after := heapLive;
WriteLn('leaked bytes across Churn: ', after - base);
```

A local string or dynamic array is reclaimed when its procedure returns, so the
delta is zero. A non-zero delta names a scope that holds onto storage.

## One measurement pitfall

Read `heapLive` into a plain variable, not inside a `WriteLn` argument list.
A string literal or other temporary passed to the same call is itself live
storage at the moment of the call, so measuring in place counts it and reports a
phantom leak. The example takes both readings into variables first for this
reason.

## What the runtime does not do

There is deliberately no built-in debugger, profiler, or coverage pass. The
`-g` line table (see `kp-module-format.md`) resolves a trap address back to a
source location for the host's trap report, but stepping, breakpoints, and
per-line profiling are left to guest code built on the primitives above.

For source locations in a diagnostic helper, the front end provides the
`__line__` intrinsic: a compile-time integer constant equal to the source line
of its own occurrence. A host function does not see the guest call site's line,
and a guest wrapper placing `__line__` in its own body would only ever report
that body's line. So a helper takes the line as a parameter and the caller passes
`__line__` at the call site:

```pascal
procedure Check(cond: boolean; line: integer);
begin
  if not cond then
    WriteLn('check failed at line ', line);
end;

Check(x > 0, __line__);   { reports the line of this call }
```

`__line__` is an ordinary integer wherever an expression is allowed, so it also
serves the line-coverage counter above without counting lines by hand.
