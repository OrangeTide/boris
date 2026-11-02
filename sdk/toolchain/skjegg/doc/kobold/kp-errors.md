# Kobold-Pascal Error Handling

This note describes the design of recoverable error handling: how a routine reports an
expected failure to its caller, and how the caller deals with it. It is the expected-failure
half of the language. The unexpected-failure half, programming errors and resource faults,
stays on the trap axis (`panic`, nil dispatch, overflow, and the rest) described in
`kp-abi.md`.

> Status: implemented. The `error` type, the `fails` signature marker, and all the call-site
> forms compile and run, with the second return register wired on every backend, and the grammar
> and fixtures are in place. The error register holds an integer code; the deferred items at the
> end are still to come.

## Two axes, kept apart

Kobold separates two kinds of failure, and does not let one mechanism serve both.

- **Expected failure** is an ordinary outcome: a file that is not there, a parse that does
  not match, a lookup that misses. The routine reports it by value and the caller must deal
  with it. This is what this note is about. It never unwinds the stack and never uses
  `longjmp`.
- **Unexpected failure** is a programming error or an unrecoverable fault: a nil dispatch, a
  divide by zero, a bad index, or an explicit `panic`. It raises a trap, unwinds to the
  host's landing pad, and is the subject of `kp-abi.md`.

The two are kept apart. The trap
mechanism relies on a single VM-wide landing pad and the invariant that no landing pad spans
a `yield` (see `kp-abi.md`). A value-returned error installs no pad and does no `longjmp`, so
it composes with coroutines for free. A guest-side `try`/`except` that caught a
`panic` would put a landing pad on the guest stack, break that invariant, and force
per-coroutine pad chains. Expected failures are values; unexpected
failures are traps.

## The model: an error is a second return value

A failable routine hands back two results side by side: its normal return value in the usual
return register, and an error signal in a second register next to it. The caller tests the
second register and branches. There is no hidden control flow.

Every surface form below is thin sugar over the same three steps: make the call, test the
error register, branch. A reader can look at the generated IR and see an ordinary `if`.

Take a failable function:

```pascal
function parse(s: string): integer fails;
```

The statement form, when the returned value is not wanted:

```pascal
if parse(s) fails then
  writeln('parse failed');
```

lowers to:

```
call parse(s)          { value in the result register, ignored here }
e := error register
if e <> 0 then
  writeln('parse failed');
```

Binding the error, to report it:

```pascal
if parse(s) fails e then
  writeln('parse failed, code ', errorcode(e));
```

```
call parse(s)
e := error register    { bind the second register to e }
if e <> 0 then
  writeln('parse failed, code ', errorcode(e));
```

The value form, which keeps the result, with a fallback:

```pascal
n := parse(s) or else 0;
```

```
tmp := call parse(s)   { value register }
err := error register
if err <> 0 then
  n := 0               { the 'or else' value }
else
  n := tmp;
```

And the common case, bail out of the current routine on failure:

```pascal
n := parse(s) or exit;
```

```
tmp := call parse(s)
err := error register
if err <> 0 then
  exit
else
  n := tmp;
```

## The error type

`error` is an opaque type, accessed only through operations, never compared as a raw integer.

The invariant that makes the representation migratable is that **success is always "the error
register is zero."** The call-site test is `reg <> 0` regardless of what the register holds.

The representation:

- The error register holds an integer code. Zero means success; any other value is a code the
  program chose.
- Construct a failure with `fail(code: integer)`.
- Read the code with `errorcode(e): integer`.
- No allocation, no reference counting, no heap object. The whole mechanism is a register and
  a branch.

Because `error` is opaque and the success test never changes, a later move to a managed-handle
representation that carries a human-readable message (the deferred item below) is a recompile,
not a source edit: it bumps the interface fingerprint, which the unit system already handles,
and existing call sites, `or else`, and `fails` forms are unaffected.

### Returning success and failure

A failable routine returns success by default. The error register is zero unless the routine
executed a `fail(...)`. Falling off the end, assigning the function result and returning, or a
plain `exit` all return success, the same as a non-failable routine, with the error register
left zero. Only `fail(...)` sets it.

One consequence matters at the call site. A plain `or exit` inside a failable routine leaves
that routine reporting **success**, because `exit` does not set the error register. So `or exit`
abandons the current work without reporting a failure upward. To leave a failable routine *and*
report the failure, the routine must run a `fail(...)`. See the forwarding note below.

## Declaring failability

A routine opts into failure in its signature, with `fails` after the result:

```pascal
function parse(s: string): integer fails;
procedure commit(c: Change) fails;
function midpoint for (seg: Segment): Point fails;   { a method, result is a record }
```

A method (a routine with a `for` receiver) is failable the same way, and the
result of a failable function or method may be any value type: an ordinal, a
real, an `int64`, a string or other handle, or a record. An ordinal-class result
rides beside the error in a second register; a wider result (a real, an `int64`,
or a record) returns through a hidden caller buffer with the error alone in the
register, the mechanism described under "The ABI across backends" below. The
handling forms are identical whatever the result width.

Failability is part of the one true signature. It is serialized into the KPM1 interface and
contributes to the interface fingerprint, so a caller in another unit sees it and a change to
it forces a recompile.

It is strict, in the Pascal tradition. Failability is never a dimension overload resolution
uses: two routines with the same name and parameters cannot differ only by `fails`, and a
failable and a non-failable routine are not interchangeable. A routine either fails or it does
not, and the signature says which.

## Handling at the call site

Calling a failable routine and doing nothing with the error is a compile error. The result of
a failable call cannot reach the rest of the program until the error has been dealt with.

There are five ways to deal with it.

**Test and branch, with `fails`.** A postfix operator on a failable call, used in a condition.
It is not a function call; the optional identifier after it is a binder that introduces a new
variable bound to the error, the way the control variable in `for i :=` is a binder.

```pascal
if parse(s) fails then     ... ;      { test only }
if parse(s) fails e then    ... ;     { test, bind the error to e }
while next() fails e do     ... ;
```

The statement form discards the returned value. Use it for failable procedures, or when the
value is not needed.

**Recover with a value, with `or else`.** An expression suffix that supplies the result when
the call fails.

```pascal
n := parse(s) or else 0;
port := lookup(name) or else defaultPort;
name := lookupName(id) or else 'unknown';   { a managed (string) result }
```

The result may be a managed value (a string, a dynamic array, or a map), not
only a plain scalar. The recovered value is owned the same way an assignment's
right-hand side is: on success it is the callee's own result, and on failure a
reference type (a string) is retained while a value type (a dynamic array or a
map) is cloned, so the recovered value is independent of the fallback source.

**Divert on failure, with `or`.** A shorthand for leaving when the call fails, over the
reserved control words `exit`, `break`, `continue`, and `fail`.

```pascal
n := parse(s) or exit;
item := head(q) or break;
v := step() or continue;
raw := readFile(path) or fail;
```

`or exit`, `or break`, and `or continue` leave by the matching control transfer, and each
returns success from the current routine, because none of them sets the error register (see
"Returning success and failure"). `or exit` in a failable routine therefore abandons the work
and reports success upward; it is the "give up quietly" form.

`or fail` is different: it leaves the current routine by *forwarding the inner error unchanged*.
It is the one-level forwarding form, the clean way for one failable routine to pass a callee's
failure to its own caller, with no error binding and no repeated call. It is legal only inside a
failable routine, since a non-failable routine has no error to set. Each routine that wants to
forward writes `or fail` for itself; nothing propagates implicitly across frames.

The shorthand is limited to those reserved words. The parser reaches `or` without
type information and cannot tell a failable call from a boolean, so it decides from the token
after `or`. `else`, `exit`, `break`, `continue`, and `fail` can never begin a
boolean operand, so `a or else`, `a or exit`, `a or fail`, and the rest are unambiguous, while a
general `or someCall()` stays boolean `or` of a function call.
The idiomatic exit call, `Exit()`, is written in the body of a handler; the `or exit` divert is
the keyword form.

**Discard explicitly, with `or else ignore`.** When dropping the error is genuinely intended,
it is written out, so it is visible in the source and never silent.

```pascal
log(msg) or else ignore;
```

### Explicit, one-level propagation

Propagation exists, but only the explicit, single-level kind. There is no implicit propagation
operator (no `?`, no `try` that forwards on its own). The one forwarding form is `or fail`, and
it is marked at the call site every time. A failable call is handled by its immediate caller; if
the caller wants to send the failure further up, it says so with `or fail`:

```pascal
function load(path: string): Config fails;
var raw: string;
begin
  raw := readFile(path) or fail;   { keep the value on success, forward the error on failure }
  ...
end;
```

`or fail` forwards the inner error unchanged and keeps the returned value on success, in one
statement with no error binding. To forward a *different* code, or later a wrapped message, bind
the error and construct a new one, with the `fails` test form:

```pascal
if readFile(path) fails e then
  fail(E_CONFIG);              { translate the failure to this routine's own code }
raw := readFile(path) or fail;
```

That translating form repeats the call. For the common case, forwarding the error as is,
`or fail` needs no error binding and no repeated call.

## The ABI across backends

A failable call returns its value in the normal return register and the error in a second,
reserved return register. The caller does a plain compare-and-branch on the error register.
There is no dependence on a condition flag.

The error signal is flag-independent. Of the three targets, RISC-V has no condition flags at
all; its backend already synthesizes carry and overflow as register values with `sltu`.
Encoding the error signal in a condition flag would be unimplementable there, and fragile even
on x86-64 and aarch64, where a callee's epilogue clobbers the flags. The error is a value in a
register, and each backend branches in its own idiom: `test`/`jnz` on x86-64, `cbnz` on
aarch64, `bnez` on rv32. A backend may peephole an intra-module case onto real flags later,
but that is an optimization, never part of the semantics.

The register pair is the standard C two-word return on every target, so a failable routine
crosses the host FFI with no deviation:

| Target  | value reg        | error reg | C equivalent                         |
|---------|------------------|-----------|--------------------------------------|
| x86-64  | RAX (XMM0 float) | RDX       | `struct { long value; long err; }`   |
| aarch64 | X0 (V0 float)    | X1        | same, returned in X0:X1              |
| rv32    | a0 (fa0 float)   | a1        | same, returned in a0:a1              |

The register pair above carries an integer-class value (an integer, char, boolean, enum,
pointer, or string handle). A failable **plain function** whose result is a real, an int64, or
a record returns the value through a hidden caller buffer instead, with the error alone in the
first integer return register. This is the C classing for a result past two words (`struct { T
value; long err; }` where `T` does not fit the value slot): the caller allocates the buffer,
passes its address as a hidden final argument, makes an ordinary call to read the error, and
reads the value from the buffer. A record already returns through that buffer (the sret path a
record result uses anyway), so only the error channel changes. A failable **method** takes the
same two paths: its receiver is an ordinary leading parameter and the hidden buffer the trailing
one, so a method whose result is a real, an int64, or a record returns the value through the
buffer with the error in the first integer return register, exactly as a plain function does.

The IR carries returns as an N-ary, class-tagged list of operands (integer or float), not a
hardcoded pair, the same way arguments are already staged by class. The register assignment is
wired for two returns now, which covers the integer-class failable case for both a plain function
and a method. A wider value takes the hidden-buffer path above rather than a third return
register, which is where the C ABI also leaves the two-word convention. Failable is a special case of this general multi-return: a
routine whose last result is an `error`, with the type system requiring that result to be
consumed.

General tuple returns in the source (`function f: (integer, integer)` with `a, b := f()`) are a
separate language question that this note does not open. The ABI is built generically; only
failable is exposed.

## Coroutines

A coroutine is not failable in this version. A coroutine communicates through `yield` and
resume, not an ordinary return, so "a coroutine that fails" would mean putting an error channel
on the resume path, which is deferred.

A coroutine body may still call failable routines, and must handle them locally, which is the
only option anyway since there is no propagation. A coroutine that hits an unrecoverable
condition uses `panic`, the trap axis, which the resume bracket already handles.

## Grammar notes

The surface stays within the parser's existing one-token lookahead (`PeekTokenKind`), so it
does not raise the grammar's lookahead class.

- `fails` is recognized contextually (not a reserved word), used both as the signature marker and
  the postfix test. After `fails`, a single current token decides the binder: an identifier binds
  the error, `then` or `do` does not.
- `or` is overloaded. As the boolean operator it keeps its additive precedence. As the
  failable suffix it is the lowest precedence, so the whole left expression is the failable
  call. When the boolean-`or` loop meets `or`, it peeks one token: `else`, `exit`, `break`,
  `continue`, or `fail` means the failable suffix and the boolean loop stops; anything else is
  boolean `or`. The peeked words are all reserved and cannot start a boolean operand, so nothing
  is ambiguous.
- `exit` and `fail` are not reserved. After `or`, a one-token peek decides: `else`, `exit`,
  `break`, `continue`, or `fail` means the failable suffix (and the boolean-`or` loop stops);
  anything else is boolean `or`. `exit` and `fail` stay ordinary builtins, so `Exit()` and
  `fail(code)` keep their normal call path.
- `or else` exists as the failable recover suffix. There is no `and then`; the success path of a
  failable call needs no operator, because the value simply flows out.

## Deferred and non-goals

Deferred, extensible later without reworking the above:

- A propagation operator (`?` / `try` / `or return`).
- Human-readable messages (`fail(msg)`, `errormessage(e)`, the handle representation).
- Failable coroutines (an error channel on resume).
- Three and four return values (leaves the C ABI; needs a documented reason).

Non-goals, deliberately not built:

- `Result[T, E]` as a sum type, and the generics it would need.
- General tuple returns in the source surface.
- Error wrapping and cause chains.
- Error backtraces. They would need the stack maps the register-allocated-frame design does
  not keep, the same reason coroutine drop is cancel-by-unwind (see `kp-abi.md`).
- A guest-side `try`/`except` over `panic`. It would break the single-landing-pad invariant.

## See also

- `kp-abi.md` for the trap axis, the landing pad, and the host boundary.
- `kp-evaluation.md` for the run-time behavior of traps (exit status) and the
  arithmetic faults (divide by zero) that sit on the trap axis, not this one.
- `kobold.md` for the no `Result[T, E]`, no generics, multiple returns in registers, and
  trusted-now trap model.
- `kp-units.md` for interface fingerprints, which absorb the representation migration.
