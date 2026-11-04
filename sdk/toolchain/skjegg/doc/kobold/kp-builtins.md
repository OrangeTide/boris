# Kobold-Pascal Built-in Routines

This document is the signature reference for the predefined routines of
Kobold-Pascal: what each one takes, what it returns, what it does, and when it can
trap. It is the rule-level companion to the built-in table in `kp-language.md`,
which lists the same routines by purpose. For the type rules the signatures rely on
(what "ordinal", "numeric", "handle", and the compatibility relations mean) see
`kp-semantics.md`; for the failure and trap model see `kp-errors.md`.

## How to read these signatures

Every built-in is a **predefined, shadowable identifier**, not a reserved word. The
predefined names live in a scope that encloses the program, so a program may declare
its own `length`, `copy`, or `write`; the declaration shadows the built-in within
its scope rather than colliding with it.

Internally the compiler registers each built-in with no fixed parameter list and
checks arguments per call, so the signatures below describe the argument arity and
types the compiler actually enforces, written in ordinary Pascal header form. A
`var` parameter must be an assignable designator (a variable, field, or element),
not a computed value. A type written `T` is a type parameter: the routine works for
any element or value type and the result follows that type.

No built-in is itself a failable (`fails`) routine. The operations that can fail at
run time are marked **traps** below; a trap aborts the program with a diagnostic
(see `kp-errors.md`), it is not a consumable failure.

## Ordinal and integer functions

```pascal
function ord(x: Ordinal): integer;
function chr(n: integer): char;
function succ(x: T): T;      { T is any ordinal type }
function pred(x: T): T;      { T is any ordinal type }
function odd(x: integer): boolean;
```

- `ord` yields the ordinal value of an ordinal or char argument as an integer. A
  one-character string literal is accepted and treated as a char.
- `chr` yields the character whose byte code is `n`; the value is reduced modulo 256
  (`n and 255`).
- `succ` and `pred` yield the next and previous value of an ordinal, **as a value of
  the argument's own type**. They do not range-check, so `succ` of the last value
  wraps in the underlying representation.
- `odd` requires an integer argument and yields whether it is odd.

## In-place increment and decrement

```pascal
procedure inc(var x: T [; by: integer]);   { T is any ordinal type }
procedure dec(var x: T [; by: integer]);   { T is any ordinal type }
```

`inc` and `dec` adjust an ordinal variable, field, or element in place, by 1 or by
the optional step `by`. They mutate the designator, unlike `succ` and `pred`, which
yield a value and change nothing. An `int64` target is adjusted with 64-bit
arithmetic.

## Numeric functions

```pascal
function abs(x: T): T;       { T is any numeric type }
function sqr(x: T): T;       { T is any numeric type }
function sqrt(x: Numeric): real;
function round(x: real): integer;
function trunc(x: real): integer;
function sin(x: Numeric): real;
function cos(x: Numeric): real;
function exp(x: Numeric): real;
function ln(x: Numeric): real;
function arctan(x: Numeric): real;
```

- `abs` and `sqr` return a value **of the argument's own numeric type** (integer,
  int64, or real), so `abs` of an integer is an integer and `abs` of a real is a
  real.
- `sqrt` takes any numeric argument (an integer is widened to real) and returns a
  real.
- `round` converts a real to the nearest integer, rounding halves to even; `trunc`
  converts toward zero. Both require a real argument.
- `sin`, `cos`, and `arctan` are in radians. `ln` is the natural logarithm. These
  are the only transcendental functions; there is no `tan`, `power`, `log10`,
  `arcsin`, or `arccos`.

A real argument is **not** implicitly converted to an integer; `round` or `trunc`
is required. See `kp-semantics.md` for the full conversion rules.

### Numeric and ordinal conversion

Converting between numeric and ordinal types is written in call form,
`TypeName(expr)`, for example `int64(n)`, `integer(big)`, or `char(code)`. This is a
type conversion, not one of the built-ins above: it takes exactly one argument, and
both the source value and the named target must be numeric or ordinal. `ord`, `chr`,
`round`, and `trunc` are the built-in functions that convert; the integer-width and
int-to-real conversions are the `TypeName(expr)` form.

## String functions

```pascal
function length(s: string): integer;
function pos(sub, s: string): integer;
function copy(s: string; index, count: integer): string;
procedure str(x: Integer; var s: string);
procedure val(s: string; var dest; var code: integer);
```

- `length` yields the number of characters in a string. (It also accepts a dynamic
  array or a map; see those sections.)
- `pos` yields the 1-based index of the first occurrence of `sub` in `s`, or 0 if it
  does not occur.
- `copy` yields the substring of `count` characters starting at 1-based `index`.
- `str` formats an integer (or int64) value into the string `s`. It does not format
  a real; produce a real's text through a host routine.
- `val` parses the string `s` into the numeric variable `dest` and sets `code` to 0
  on success, or to the 1-based position of the first offending character on
  failure.

Strings are immutable and 1-indexed. A character is read with `s[i]` but cannot be
assigned, and a string cannot be resized. Build a new string by concatenation (the
`+` operator, which promotes a `char` operand to a one-character string) or `copy`.
Reading `s[i]` with `i` outside `1..length(s)` **traps**. Higher-level helpers
(`UpperCase`, `Trim`, `StringReplace`, and the like) are in the standard-library
`strings` unit, not built-ins; see `kp-units.md`.

## Dynamic-array procedures and functions

```pascal
function length(a: array of T): integer;
function high(a: array of T): integer;
function low(a: array of T): integer;
procedure setlength(var a: array of T; n: integer);
procedure insert(var a: array of T; index, count: integer);
procedure delete(var a: array of T; index, count: integer);
```

- `length` yields the element count of a dynamic array. `high` yields
  `length(a) - 1` and `low` yields 0. `high` and `low` apply **only** to dynamic
  arrays; a fixed array's bounds are known statically from its declaration, and
  `length`/`high`/`low` are not the way to take them.
- `setlength` resizes a dynamic array to `n` elements, zero-filling any new tail. It
  is the only way a dynamic array grows. It rejects a `string` (immutable) and a
  `buffer of T` (the host owns the backing).
- `insert` opens `count` zero-filled slots at 1-based `index`; `delete` removes
  `count` elements at `index`. Both edit a dynamic-array variable and are
  copy-on-write. Neither applies to a buffer.

There is no array concatenation operator or `concat` built-in; grow with
`setlength` and assign, or build through `insert`.

## Map procedures and functions

A `map of T` is accessed through indexing, the `in` operator, and these routines.
The key is a `string`, or, in the bracketed form `map[K] of T`, an ordinal `K`
(integer, int64, char, enum, boolean). The signatures below show the string form;
in the bracketed form `key` has type `K` and `mapnext`'s `key` binder is a `K`
variable. Everything else is the same.

```pascal
function length(m: map of T): integer;
function tryget(m: map of T; key: string; var value: T): boolean;
function mapfirst(m: map of T): mapiter;
function mapnext(it: mapiter; var key: string; var value: T): boolean;
procedure delete(var m: map of T; key: string);
```

- `m[key]` reads the value for `key`. Reading an **absent** key **traps**. Assigning
  `m[key] := v` inserts or replaces the entry.
- `key in m` tests whether a key is present and yields a boolean; it never
  traps.
- `length(m)` yields the number of entries.
- `tryget` is the trap-free read: if `key` is present it copies the value into
  `value` and returns true, otherwise it returns false and leaves `value` unchanged.
  `value` must be a variable of the map's value type.
- `delete(m, key)` removes the entry for `key`.
- Iterate with `mapfirst` and `mapnext`: `mapfirst` returns a fresh `mapiter`
  cursor, and each `mapnext` writes the next entry's key and value through its `var`
  parameters and returns true, or returns false when the traversal is exhausted. The
  `value` variable must have the map's value type; the iterator does not check it.

## Error-value functions

```pascal
function fail(code: integer): error;
function errorcode(e: error): integer;
```

- `fail` builds a failure value carrying an integer `code`. It is used to raise a
  failure from a `fails` routine (see the failable forms in `kp-errors.md`).
- `errorcode` reads the integer code back out of an `error` value, for example in an
  `or else` handler that binds the error.

These are the only error built-ins; the `fails`, `or else`, and divert forms are
language syntax, specified in `kp-errors.md`, not routines.

## Handle lifetime

```pascal
procedure release(h: Handle);
```

`release` drops the caller's reference to a handle (a string, interface, process,
dynamic array, map, or iterator). At a zero reference count the referent is
reclaimed. When the argument is a local variable, the variable is also set to `nil`
so the automatic release at scope exit does not double-drop it and a later use traps
as `nil` rather than touching reclaimed storage. Reference counting is otherwise
automatic; `release` is for dropping a reference early. See `kp-abi.md` for the
lifetime model.

## Input and output

```pascal
procedure write(f: text; ...);         { f optional; defaults to output }
procedure writeln(f: text; ...);       { f optional; defaults to output }
procedure read(var ...);               { from standard input }
procedure readln(var ...);             { from standard input }
procedure flush(f: text);              { f optional; defaults to output }
procedure halt(code: integer);         { code optional; defaults to 0 }
procedure abort;                       { unconditional runtime fault, exit 70 }
procedure assert(cond: boolean);       { runtime fault unless cond holds }
```

- `write` and `writeln` take any number of arguments, each written according to its
  type: integer, int64, real, char, or string. An optional first argument of type
  `text`, the predefined `output` (standard output, the default) or `erroutput`
  (standard error), selects the stream. `writeln` ends the line with a newline; a
  bare `writeln` writes just a newline, and a bare `write` writes nothing. There is
  **no** field-width or precision formatting: `write(x:width)` and
  `write(x:width:prec)` are not supported. Format a value with `str` or a host
  routine.
- `read` and `readln` read from standard input into their `var` arguments, each of
  which must be an assignable variable of integer, int64, real, char, or string type.
  Reading is token-based: a numeric argument skips leading whitespace and reads one
  whitespace-delimited token, a char argument reads one character, and a string
  argument reads the rest of the current line. `readln` additionally consumes the
  rest of the current line after its arguments; a bare `readln` skips a line.
- `flush` flushes a stream (the default is `output`). `halt` ends the program with
  the given exit code, or 0.
- `abort` and `assert` are the fatal-fault builtins, distinct from `halt`: `halt`
  is an orderly exit with a chosen code, while `abort` and a failed `assert` are
  runtime faults that end the program with exit 70, the convention the index and
  arithmetic traps use (kp-abi.md). `abort` always faults; `assert(cond)` faults
  only when `cond` is false. On a host with a backtrace facility (skj-run on
  RISC-V) the fault prints a symbolized source-level stack; elsewhere it prints a
  one-line diagnostic. The check in `assert` is unconditional at runtime, not a
  debug-only guard that a release build strips.

## Program environment

```pascal
function paramcount: integer;
function paramstr(i: integer): string;
```

`paramcount` is the number of command-line arguments. `paramstr(i)` is the `i`-th
argument, with `paramstr(0)` the program name.

## Control-flow built-in

```pascal
procedure exit;
procedure exit(value: T);
```

`exit` returns from the current routine immediately. In a function, `exit(value)`
sets the result and returns. `exit` is a predefined name, matched the same way the
other built-ins are.

## Compile-time intrinsic

`__line__` is not a routine but a compile-time intrinsic: it is replaced during
parsing by an integer literal equal to the source line of its own occurrence, which
lets a diagnostic helper receive its call site's line without being passed one. It
is the only such intrinsic; there is no `__file__` or `__func__`.
