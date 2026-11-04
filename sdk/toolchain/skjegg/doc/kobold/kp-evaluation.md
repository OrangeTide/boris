# Kobold-Pascal Dynamic Semantics

This document specifies the observable run-time behavior of Kobold-Pascal in the
places the language reference and the grammar leave open: evaluation order, the sign
and overflow behavior of integer arithmetic, how divide-by-zero and other faults
behave, how strings and sets compare, what an uninitialized or default value holds,
how a trap ends the program, how a real number prints, and when a reference-counted
value is released.

It is the run-time companion to `kp-semantics.md` (the static rules). The trap
machinery itself (the landing pad, the host reporting hook, the full trap-kind
table, and the check-policy switches) is specified in `kp-abi.md`; this document
states the language-level behavior and refers there for the mechanism. The failable
error model (`fails`, `or else`, the diverts) is a separate axis specified in
`kp-errors.md`; the faults described here are **traps**, not consumable failures,
and do not interact with `or else`.

## Evaluation order

Evaluation order is deterministic, and it differs between operator operands and call
arguments:

- **Operator operands are evaluated left to right.** For a binary operator (`+`,
  `-`, `*`, `/`, `div`, `mod`, the comparisons, the set operators, string
  concatenation), the left operand is evaluated before the right.
- **Call arguments are evaluated right to left.** The arguments of a procedure or
  function call are evaluated from last to first, then passed in declaration order.
- **`and` and `or` short-circuit.** The left operand is evaluated first; the right
  is evaluated only when the left does not already decide the result.

A program whose result depends on a side effect ordered between two call arguments
should not rely on a particular order beyond right-to-left.

## Integer arithmetic

### Division and modulo sign

`div` truncates toward zero and `mod` takes the sign of the dividend, for both
32-bit `integer` and `int64`. This is the C and hardware convention, not the ISO
Pascal floored convention.

```
(-7) div 2  =  -3        7 div (-2)  =  -3
(-7) mod 2  =  -1        7 mod (-2)  =   1
```

(ISO Pascal would give `-4` and `+1` for the first pair; Kobold does not.) The
convention is the same whether the operation runs as a native instruction or, for
`int64` on a 32-bit target, through the runtime 64-bit helpers.

### Overflow

Signed integer `+`, `-`, `*`, and unary `-` **wrap** in two's complement by default;
an overflow is not detected. Overflow checking is enabled by the `{$Q+}` directive,
which makes a checked `+`, `-`, or `*` trap (`OVERFLOW`) instead of wrapping. Two
limits apply even under `{$Q+}`: the checks cover addition, subtraction, and
multiplication only (unary negation never traps), and they apply to 32-bit arithmetic
only (`int64` always wraps). There is no unsigned integer type in the language.

### The most-negative-divided-by-minus-one case

Dividing the most negative 32-bit `integer` by `-1` (and the matching `mod`)
overflows: the true quotient, 2147483648, is not a representable positive
`integer`. This **traps** (`OVERFLOW`) and exits 70 on every backend, always
checked and independent of `{$Q+}` (the backend tests the operand pair before
the divide). It is separate from the `{$Q+}` add/sub/mul checks above, the way
divide-by-zero is, so it fires even with overflow checking off.

The `int64` minimum divided by `-1` is the one case still left unguarded: its
behavior is target-dependent (on some targets the process faults, on others it
yields an unspecified value), so a program must not divide the `int64` minimum
by `-1`.

### Divide by zero

Integer `div` or `mod` by zero is a **trap** (`DIV_ZERO`), always checked, on every
target and build tier. It is not a consumable failure and has nothing to do with the
`fails` / `or else` model: dividing by a variable that happens to be zero traps, and
so does a literal `x div 0` (it is a run-time trap, not a compile error). A non-zero
constant divisor simply never triggers the check. A trap ends the program as
described under Traps below.

## Comparison

### Strings

Strings compare by **unsigned bytewise lexicographic order**: the first differing
byte decides, and if one string is a prefix of the other the shorter one sorts first.
Because Kobold strings are UTF-8 and UTF-8 byte order equals Unicode code-point
order, `<`, `<=`, `>`, and `>=` order strings by code point. Equality (`=`, `<>`)
holds exactly when the two strings have the same length and the same bytes. The same
byte comparison decides map key equality.

### Sets

Set equality `=` and `<>` compare the bitmasks for exact equality. The ordering
operators are subset relations, over sets of the same type (see `kp-semantics.md` for
why set comparison is restricted to one set type):

- `a <= b` is "`a` is a subset of `b`", computed as `(a and not b) = empty`.
- `a < b` is proper subset, `a <= b` and `a <> b`.
- `a >= b` and `a > b` are superset and proper superset, the mirror.

`x in s` tests membership: whether the bit for the ordinal value `x` is set in `s`.
A large set (more than 64 elements) is compared and tested a 64-bit word at a time;
the results are identical to the single-word case.

## Default and uninitialized values

- **Global variables are zero-initialized.** A global with no initializer holds the
  zero of its type: integer 0, real 0.0, boolean `false`, char code 0, the
  ordinal-0 enumeration member, an empty set, a `nil` handle (string, interface,
  process, dynamic array, map), and a record whose fields are each their own zero.
- **Handle-typed locals are initialized to `nil`** on routine entry (so the
  reference-count discipline sees `nil`, not garbage). This includes the handle
  fields inside a local record or array.
- **All other locals are undefined until assigned.** An integer, real, boolean,
  char, enumeration, or set local, and the non-handle fields of a local record or
  array, hold indeterminate values on entry. Reading one before it is assigned is
  not defined; the program must assign before use.

Runtime containers zero-fill their own storage independently of these rules: a
dynamic array grown with `setlength` zero-fills the new tail, and a map's value slots
are zero when an entry is created, so an element or value that has not been assigned
reads as the zero of its type.

## Traps and exit status

A trap is a fatal run-time fault: an array or string index out of range (when range
checking is on), a divide by zero, a method call on a `nil` handle, a missing map key
read with `m[key]`, a checked arithmetic overflow, a coroutine misuse, an
out-of-memory condition, a coroutine stack overflow, or an explicit `panic`. The full
kind list and the per-kind check policy (which checks are always on and which are
gated by `{$R+}` or `{$Q+}`) are in `kp-abi.md`.

When a trap fires in a standalone program, the runtime writes a one-line diagnostic
naming the fault to standard error and the process **exits with code 70**, regardless
of the trap kind. The kind affects the message, not the exit code. When the runtime
is embedded, a host that installs a landing pad receives the trap code and the program
does not exit; see `kp-abi.md`.

The trap-free alternatives where they exist: read a map with `tryget` rather than
`m[key]` to test-and-fetch without trapping, and test a key with `key in m`.

## Real number output

`write` and `writeln` print a real using C `%g` formatting with the default
precision of six significant digits. The value is rounded to six significant digits;
trailing fraction zeros and a bare trailing decimal point are dropped. The format is
fixed-point when the decimal exponent is in the range `-4` through `5`, and
exponential (`d.ddddde+NN`) outside it. This is ordinary `%g`, not a shortest
round-trip or full-precision format, so a printed real is not guaranteed to read back
as the identical binary value. The freestanding (no-libc) runtime reproduces the same
`%g` behavior.

## Reference lifetime

Handle-typed values (strings, dynamic arrays, maps, interfaces, processes, buffers)
are reference-counted. Release is synchronous: a referent is finalized at the moment
its last reference drops, with no deferred collection. The release points are:

- **End of statement**, for an unretained temporary. A handle produced and consumed
  within one statement, such as a concatenation result passed to a call or used only
  as an expression statement, is released as soon as the statement's consuming
  operation has read it.
- **At an overwriting assignment**, for the previous value of a variable. An
  assignment retains the incoming value (or copies it, for a value array or map),
  stores it, then releases the old value, so self-assignment is safe.
- **At routine return**, for a local that still holds the last reference. A handle
  returned as the function result is not released; it transfers to the caller.

Because finalization is synchronous at the release point, a host object backing a
handle runs its finalizer at a predictable moment: the end of the statement for a
temporary, the overwriting assignment for a replaced variable, or the routine return
for a local.
