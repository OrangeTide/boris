# Kobold-Pascal Language Reference

This is the reference for writing Kobold-Pascal programs: the types, expressions,
statements, routines, built-ins, and directives the front end accepts. It describes the
language as the compiler implements it, not a superset.

Related documents:

- `kp-grammar.md` gives the full grammar in EBNF. This reference is the prose companion.
- `kp-semantics.md` gives the static-semantics rules: type identity, compatibility,
  conversions, expression typing, overload resolution, and storage layout.
- `kp-builtins.md` gives the signature reference for the predefined routines.
- `kp-evaluation.md` gives the dynamic semantics: evaluation order, arithmetic
  behavior, comparison, default values, traps, and output formatting.
- `kobold.md` explains how the compiler and runtime work, and how the language lowers.
- `kp-abi.md` specifies the host boundary that `external` routines and handle types cross.
- `kp-module-format.md` specifies the KPM1 module the front end emits.

## Program structure

A program is a `program` header, a block, and a terminating dot.

```pascal
program hello;
begin
  writeln('hello');
end.
```

The block holds declarations followed by the program body, a `begin ... end` compound
statement. The compiled program body becomes the module's `main` entry.

A block's declaration part mixes `const`, `type`, `var`, and routine declarations in any
order and any number, each introducing names visible to what follows.

## Comments

Three comment forms, none nesting:

```pascal
{ brace comment }
(* parenthesis-star comment *)
// line comment to end of line
```

A brace comment whose first character is `$` is a compiler directive, not a comment. See
[Compiler directives](#compiler-directives).

## Identifiers and reserved words

An identifier starts with a letter and continues with letters, digits, or underscores.
Identifiers and reserved words are case-insensitive: `Count`, `count`, and `COUNT` are
the same name, and `Begin` is the keyword `begin`.

Reserved words:

```
and array as asm begin bind break buffer case const continue defer div do downto else
end external for forward function goto if implement implementation in interface label
map mod nil not of or procedure program property record reexport ref repeat set
shared shl shr slice start string then to type unit until uses var while with yield
```

`ref` and `slice` are reserved but not parsed: `slice` is held for a future windowed
view. `map` opens `map of T`, `as` is the import alias
in a `uses` clause, and `reexport` names a unit's re-exported surface. `property` declares an
accessor-backed value with uniform access, as a declaration or a computed record field (see
`kp-property.md`). `out`, `cdecl`, `export`, `read`, and `write` are contextual: they act as
keywords only where a routine or property declaration expects them, so an ordinary
identifier may still carry one of these names.

## Constants and literals

- **Integer.** Decimal `123`, or hexadecimal with a `$` prefix, `$1F`.
- **Real.** Digits, a dot, digits, and an optional exponent: `3.14`, `1.0e-9`.
- **String.** Single-quoted text, with `''` for an embedded quote, and `#code` for one
  byte by its numeric code (decimal `#10` or hex `#$0A`). Adjacent pieces join, so
  `'line'#10` is a five-byte string. A one-character string literal is also valid where
  a `char` is expected.
- **Interpolated string.** Double-quoted text builds a string with interpolation holes:
  `"hello ${name}, you have ${count} messages"`. Each `${expr}` is replaced by `expr`
  rendered to text the way `write` renders it (a string or `char` as itself, an integer
  or `int64` as its digits, a `bool` or enum as its ordinal number). Write a literal
  dollar-brace with `$$` before the brace, a literal double quote with `""`, and any
  other `$` stands for itself. Single-quoted literals never interpolate, so existing code
  is unchanged. See [Strings](#strings). (A `real` hole is not supported yet; convert it
  with `str` first. A hole may not itself contain a double-quoted string; use single
  quotes inside a hole.)
- **Boolean.** The predefined constants `true` and `false`.
- **Nil.** `nil`, the empty handle, usable where any handle, string, or dynamic array is
  expected.

Named constants are declared in a `const` part:

```pascal
const
  Limit = 100;
  Name  = 'kobold';
```

A typed constant can also be an aggregate: an array, a record, or a nesting of both. An
array constant gives a parenthesized list of element values, with one nested list per
dimension for a multi-dimensional array. A record constant is a first-class record literal,
`(field: value; ...)`, with its fields in declared order.

```pascal
type
  Point = record x, y: integer; end;
const
  Grid:   array[1..2, 1..3] of integer = ((1, 2, 3), (4, 5, 6));
  Corner: Point = (x: 10; y: 20);
  Spans:  array[0..1] of Point = ((x: 0; y: 0), (x: 4; y: 8));
```

Each value is a constant expression. An ordinal value may use the usual constant arithmetic
(`+`, `-`, `*`, `div`, `mod`, shifts, and bitwise operators); a real value must be a signed
literal, since real constant arithmetic is not folded. A value cannot call a function. A real
or single-precision constant is allowed as a plain scalar, as a record field, and as an array
element. A scalar real or single const reads as its value wherever the type is expected; an
integer value given a real type is promoted (`const Tau: real = 6` is 6.0).

## Types

### Ordinal types

The integer types differ only in width and signedness at declaration; arithmetic is done
at 32 or 64 bits.

| Name | Width | Signed |
|---|---|---|
| `shortint` | 8 | yes |
| `byte` | 8 | no |
| `word` | 16 | no |
| `integer` / `longint` | 32 | yes |
| `cardinal` | 32 | no |
| `int64` | 64 | yes |
| `qword` | 64 | no |

`integer` is the default 32-bit type; `int64` is a real 64-bit type with 64-bit literals,
arithmetic, and comparison. `char` holds one byte. `boolean` holds `false` (0) or `true`
(1).

An **enumeration** declares its own ordered constants:

```pascal
type Color = (Red, Green, Blue);
```

A **subrange** restricts an ordinal type to a range of values:

```pascal
type Digit = 0..9;
```

`ord`, `low`, `high`, `chr`, `inc`, `dec`, `succ`, `pred`, and `odd` operate on
ordinal types.

### Real types

`real` and `double` are 64-bit IEEE doubles; `single` is a 32-bit float. Mixed integer
and real arithmetic promotes to real. `/` always yields a real result.

### string

`string` is a length-counted, host-managed byte string. It is indexed from 1, so `s[1]`
is the first character and `length(s)` is the count. Strings are immutable: `s[i]` reads a
character but cannot be assigned, and `setlength` cannot resize a string. Assignment shares
the bytes by reference, and because no owner can mutate them there is no copy on write.
A new string value is built by concatenation or `copy`, so

```pascal
b := a;                       { b and a share the same immutable value }
a := 'x' + copy(a, 2, length(a) - 1);   { a is a new value; b is unchanged }
```

Concatenation is `+`. A `char` in a string context is boxed to a one-character string, so
`s + ch` and `ch1 + ch2` are strings. See [Strings](#strings).

### Arrays

A fixed array has an ordinal index range:

```pascal
type Row = array[1..8] of integer;
```

A **dynamic array** has no bound and is sized with `setlength`:

```pascal
var xs: array of integer;
...
setlength(xs, n);
```

A dynamic array is a handle with value semantics like a string: assignment shares the
storage, and `setlength` on a shared array makes it unique first (copy on write).
`length`, `low`, and `high` report its bounds; `low` is 0.

`delete(a, index, count)` removes `count` elements starting at `index`, shifting the tail
down. `insert(a, index, count)` opens `count` zero-filled slots at `index`, shifting the tail
up, which the caller then fills by assignment. Both edit the array in place copy-on-write, so
an edit of a shared array leaves the other owners untouched. `index` and `count` are clamped
to the array, so a `delete` past the end removes only to the end. Kobold's `insert` opens a
gap rather than taking the value to insert.

```pascal
delete(xs, 1, 2);      { drop xs[1] and xs[2] }
insert(xs, 1, 1);      { open one slot at index 1 }
xs[1] := 42;           { fill it }
```

An **open-array parameter**, written `array of T`, receives any dynamic array (or a fixed
array) of element type `T`, so one routine works over arrays of any length.

### Maps

A **map** is a string-keyed associative array with a typed value:

```pascal
var scores: map of integer;
```

The key may instead be an ordinal, written `map[K] of T`, where `K` is `integer`,
`int64`, `char`, an enum, or `boolean`:

```pascal
var hits: map[integer] of integer;
var tally: map[char] of integer;
```

Everything below applies to both forms; only the key type changes.

`scores[k]` reads or writes the value for key `k`. Assigning to a key inserts it, creating the
map if the variable is nil; reading a key that is not present traps, so test first with `k in m`
or fetch with `TryGet`. Like a dynamic array, a map has value semantics: assigning or passing
it by value copies it, so an edit of the copy does not affect the original (pass it as a `const`
parameter to avoid the copy when read only).

| Operation | Meaning |
|---|---|
| `m[k]` | the value for key `k` (traps if `k` is absent) |
| `m[k] := v` | insert or update key `k` |
| `k in m` | true when key `k` is present |
| `TryGet(m, k, v)` | if `k` is present, copy its value into `v` and return true, else false |
| `Delete(m, k)` | remove key `k` (no effect if absent) |
| `Length(m)` | the number of entries |

Iterate with a cursor:

```pascal
var it: mapiter; k: string; v: integer;
...
it := MapFirst(scores);
while MapNext(it, k, v) do
  writeln(k, ' = ', v);
```

`MapFirst(m)` returns a `mapiter` over the map, and `MapNext(it, k, v)` writes the next entry's
key and value and returns true, or false at the end. The iteration order is unspecified.
Inserting or removing a key while an iteration is in progress traps; updating the value of a key
that already exists is allowed. The key passed to any map operation has the map's declared key
type (a string, or the ordinal `K` of a `map[K] of T`), and the value type is whatever the map
was declared with (an ordinal, real, string, record, or array). For an ordinal-keyed map, the
`MapNext` key binder is a variable of type `K`.

### Records

A record groups named fields:

```pascal
type Point = record
  x, y: integer;
end;
```

A **variant record** overlays alternatives after a tag, sharing storage:

```pascal
type Number = record
  case kind: integer of
    0: (i: int64);
    1: (d: double);
end;
```

The fields of the largest variant determine the record's size, and the variant fields
share the same offset.

A **computed field** reads and writes like a stored field but runs accessor methods of
the record. It names a getter and, optionally, a setter; with only a getter it is read-only:

```pascal
type Temp = record
  c: integer;
  f: integer read getF write setF;   { Fahrenheit over a Celsius cell }
end;

function getF for (t: Temp): integer;
begin getF := t.c * 9 div 5 + 32; end;

procedure setF for (t: Temp)(v: integer);
begin t.c := (v - 32) * 5 div 9; end;
```

See [Properties](#properties) and `kp-property.md`.

### Sets

A set holds a subset of a small ordinal base type:

```pascal
type CharSet = set of char;
...
if c in ['a'..'z'] then ...
```

Set operators are `+` (union), `-` (difference), `*` (intersection), and `in`
(membership). A set literal is written with brackets, and `[]` is the empty set.

A set is a value, so it can be a record field, a fixed-array element, a
dynamic-array element, or a map value. A set carries no references, so a
dynamic array or map of sets needs no per-element handle tracking: a small set
(up to 64 values, one machine word) is stored like any ordinal, a larger set is
blitted into its slot like a record. Assignment copies the set by value, so a
set read out of or written into a collection is independent of the source.

### Handle and interface types

An `interface` type is a handle: an opaque reference to a host-owned object, reached
through methods rather than fields. Handle values are reference-counted (retain on
assignment, release when overwritten or when a scope ends); `release` drops a reference
explicitly. Handle types and their methods are provided by the host and specified in
`kp-abi.md`. `nil` is the empty handle.

### The process type

`process` is the handle type of a coroutine. See [Coroutines](#coroutines).

## Properties

A `property` presents as a value but reads and writes through accessor routines (uniform
access). A read calls the getter; a write calls the setter; with only a `read` accessor it
is read-only:

```pascal
var backingVol: integer;
function getVolume: integer;
begin getVolume := backingVol; end;
procedure setVolume(v: integer);
begin backingVol := v; end;

property volume: integer read getVolume write setVolume;
property maxVolume: integer read getMax;   { read-only: no write accessor }
```

A declaration-level property's accessors are free routines: a parameterless function of the
property type, and a one-argument procedure taking that type. A property may name an
accessor declared later in the same part. A property is not a stored cell, so it has no
address: it cannot be passed by reference or have its address taken. A record may carry a
computed field with the same form, where the accessors are methods of the record (see
[Records](#records)).

A property carries an ordinal, a real, a 64-bit integer, a handle (string, dynamic array,
map, interface, or process), or an aggregate value (record, fixed array, or large set).
Cross-module (unit interface) properties and inline accessor bodies are not yet supported.
See `kp-property.md`.

## Expressions and operators

Operators, highest precedence first:

| Precedence | Operators | Associativity |
|---|---|---|
| 1 | `not`, unary `+` / `-` | right |
| 2 | `*`, `/`, `div`, `mod`, `and`, `shl`, `shr` | left |
| 3 | `+`, `-`, `or` | left |
| 4 | `=`, `<>`, `<`, `>`, `<=`, `>=`, `in` | none |

`div` and `mod` are integer division and remainder; `/` is real division. `and`, `or`,
and `not` are boolean when applied to booleans and bitwise when applied to integers.
Boolean `and` and `or` short-circuit: the right operand is evaluated only when it can
change the result. `shl` and `shr` are bit shifts. Comparisons yield a boolean.

A type name applied like a call is a conversion, for example `int64(x)`, `longint(x)`, or
`real(x)`.

Argument and operand evaluation order is right to left.

## Statements

- **Assignment.** `target := expr`, where the target is a variable, a field, an array or
  string element, or the enclosing function's name (to set its result).
- **Procedure call.** `name` or `name(args)`. A call with no arguments needs no
  parentheses.
- **Compound.** `begin ... end` groups a sequence separated by semicolons.
- **if.** `if cond then stmt` with an optional `else stmt`.
- **case.** Selects on an ordinal value or a string; labels may be single values or, for an
  ordinal selector, ranges, with an optional `else` branch:

  ```pascal
  case c of
    'a'..'z': writeln('lower');
    '0'..'9': writeln('digit');
  else
    writeln('other');
  end;
  ```

  A string selector matches each label by value, so a whole word can drive the selection.
  String labels are discrete values, not ranges:

  ```pascal
  case command of
    'north', 'n': go(dirNorth);
    'quit': done := true;
  else
    writeln('unknown command');
  end;
  ```

- **while.** `while cond do stmt`.
- **repeat.** `repeat stmts until cond`, testing after the body.
- **for.** `for i := lo to hi do stmt`, or `downto` to count down. The counter is
  undefined after the loop; do not read it once the loop ends.
- **for-in.** `for x in seq do stmt` binds each element of a sequence to the
  pre-declared variable `x` in turn. The source is a fixed array (over its index
  range), a dynamic array (`0..high`), a string (byte by byte, each a `char`), a
  set (its members in ordinal order), a map, or a custom cursor. A map binds two
  variables, `for k, v in m do`, the key (the map's key type) and the value. A custom
  cursor is a type with a `function Next for (c): E fails` method, failure ending
  the loop. Use `_` to ignore a binder and run the body once per element.
  `break` and `continue` work as in any loop. See `kp-foreach.md`.
- **with.** `with recordExpr do stmt` opens a record's fields as bare names in the body.
- **break / continue.** Exit the nearest enclosing loop, or skip to its next iteration.
- **defer.** `defer stmt` registers `stmt` for teardown at the end of its enclosing
  block. Deferred statements run in reverse order (last deferred, first run) on every
  orderly exit from that block: falling off the end, `exit`, `break`, `continue`, and
  the failable diverts (`or exit`/`or fail`/...). An `exit(v)` computes its result
  before the teardown runs. A trap (panic, bounds, nil, divide-by-zero) does not run
  defers. Use a `begin`..`end` block to defer several statements. The deferred statement
  may not itself leave its block, so `exit`, `fail`, `break`, `continue`, `yield`,
  `goto`, and a nested `defer` are compile errors inside it. See `kp-defer.md`.
- **computed goto.** For a bytecode interpreter's inner loop, a `name:` label marks a
  statement and `goto EXPR` jumps to a `label` value. A `label` value is made only by
  `@name` (the address of a label in the current routine) and is **second-class**: it
  may live only in that routine's frame, as a local variable or a routine-local
  `array of label` (the dispatch table). So the usual shape is a table of label
  addresses indexed by the next token, `goto disp[code[pc]]`, the threaded-dispatch
  `NEXT`. There is no unstructured `goto`: a bare `goto name` to a label is a compile
  error, and because a label value cannot leave its frame, a computed jump always
  lands in a live frame. See kp-semantics.md for the `label` type's rules.
- **inline assembly.** `asm('text')` emits its template string into the generated
  assembly at that point, so the text must match the target assembler's syntax. There
  is no string interpolation (the literal is taken as written). The basic form is the
  template alone: the compiler does not read it and register allocation does not see it,
  so the block must leave the machine state the surrounding code expects. The extended
  form, `asm(template : outputs : inputs : clobbers)`, ties the template to program
  values with GNU-style operand constraints, where `%N` in the template is operand N
  (outputs first, then inputs). The supported subset is integer-class operands and the
  general register class: `=r` for an output, `+r` for a read-write output, and `r` for
  an input, an output being an assignable designator; the compiler places each operand
  in a register and reserves the clobbers. Inline assembly is AOT only: the in-process
  JIT does not assemble text, so a program that uses it must be compiled ahead of time.
  See kp-grammar.md.

## Routines

### Procedures and functions

A procedure has no result; a function declares a result type and returns a value:

```pascal
function max(a, b: integer): integer;
begin
  if a > b then max := a else max := b;
end;
```

A function returns by assigning its own name, as above, or with `exit(value)`. Plain
`exit` returns from the current routine.

### Parameters

A parameter group is `[ var | out | const ] names : Type`:

- **value** (no keyword): the routine gets a copy.
- **var**: by reference; the routine may read and write the caller's variable.
- **out**: by reference, intended for output; like `var` for passing.
- **const**: by reference but immutable, for passing aggregates without a copy.

An **open-array parameter** is `array of T` (see [Arrays](#arrays)).

### Forward declarations

`forward` declares a routine's header ahead of its body so two routines can call each
other:

```pascal
function even(n: integer): boolean; forward;
```

### Overloading

Several routines may share a name and be chosen by argument type, resolved at the call
site. This is why `writeln` prints a `string`, an `integer`, or a `real` under one name,
and a program can add its own overload for its own type.

### Nested routines

A routine may be declared inside another and may read and write the enclosing routine's
locals and parameters. Nesting does not escape: a nested routine that uses an enclosing
local may be called but not stored or returned as a value, because there are no closures.

### Methods

A routine may be attached to a record or handle type with a receiver, and called with dot
notation:

```pascal
function sum for (const p: Point): integer;
begin
  sum := p.x + p.y;
end;
...
n := somePoint.sum;
```

The receiver is by reference by default, so a method may mutate it; a `const` receiver is
immutable. On a record the call resolves statically; on a handle it resolves at link to a
direct call to the host's registered method, and a script method with the same name
overrides that host method.

### External routines

`external` marks a routine the host provides through the FFI; it has no Pascal body. The
`cdecl` directive names the C calling convention explicitly and may appear with or in
place of `external`:

```pascal
procedure printInt(n: integer); external;
function ReadFileStr(const path: string): string; external cdecl;
```

The host registers a matching function before the module links (see `kp-abi.md`).

### Exported routines

`export` marks a routine as a module entry an embedding host may call across the FFI, in
addition to lowering its body:

```pascal
function compile(const srcName, srcText: string): string; export;
begin
  ...
end;
```

The program body (`main`) is always an entry. An `export` adds another, which is how a
host calls into a module without running `main`. See the two-stage boot in `kobold.md`.

## Built-in routines

These names are predefined. They are not reserved words, so a program may shadow them.
The table below is a quick index; `kp-builtins.md` is the signature reference, with
each routine's argument rules, result type, and trap behavior.

| Routine | Purpose |
|---|---|
| `length(s)` | length of a string or array |
| `low(x)` / `high(x)` | first and last valid index or ordinal value |
| `ord(x)` | ordinal value of an ordinal or char |
| `chr(n)` | the char with byte code `n` |
| `succ(x)` / `pred(x)` | the next or previous value of an ordinal, as a value of its own type |
| `odd(x)` | `true` when an integer `x` is odd |
| `abs(x)` / `sqr(x)` | absolute value and square, in the argument's own numeric type |
| `sqrt(x)` | square root, as a real (an integer argument is widened) |
| `round(x)` / `trunc(x)` | a real to the nearest integer (round-to-nearest-even) or toward zero |
| `sin(x)` / `cos(x)` / `arctan(x)` | trigonometric functions, in radians, as a real |
| `exp(x)` / `ln(x)` | the exponential and natural logarithm, as a real |
| `pos(sub, s)` | 1-based index of `sub` in `s`, or 0 |
| `copy(s, i, n)` | the `n` characters of `s` from index `i` |
| `setlength(a, n)` | resize a dynamic array (not a string: strings are immutable, not a buffer: the host owns its backing) |
| `delete(a, i, n)` | remove `n` elements of dynamic array `a` at index `i` (copy on write) |
| `insert(a, i, n)` | open `n` zero-filled slots in dynamic array `a` at index `i` (copy on write) |
| `delete(m, k)` | remove key `k` from map `m` |
| `tryget(m, k, v)` | if key `k` is in map `m`, copy its value to `v` and return true, else false |
| `mapfirst(m)` | a `mapiter` cursor over map `m` |
| `mapnext(it, k, v)` | write the next entry's key and value through the cursor; false at the end |
| `str(x, s)` | format an integer (or int64) `x` into string `s` |
| `val(s, x, code)` | parse `s` into `x`; `code` is 0 on success, else the error position |
| `inc(x [, d])` / `dec(x [, d])` | add or subtract 1 (or `d`) in place |
| `exit` / `exit(v)` | return from the current routine, optionally with a result |
| `write(...)` / `writeln(...)` | write values to a stream (see below) |
| `flush(stream)` | flush a stream |
| `halt` / `halt(code)` | end the program with an exit code |
| `abort` | unconditional runtime fault (exit 70) |
| `assert(cond)` | runtime fault (exit 70) unless `cond` holds |
| `release(h)` | drop a reference to a handle |
| `paramcount` | number of command-line arguments |
| `paramstr(i)` | the `i`-th command-line argument (`paramstr(0)` is the program name) |

## Strings

`string` is the one variable-length text type; there is no fixed-length string. Strings
are indexed from 1 and carry their own length, so a NUL byte is an ordinary character.
Strings are immutable: `s[i]` reads a character but cannot be written, and `setlength`
does not apply. Assignment shares the bytes by reference and is cheap; since no owner can
change them, there is never a copy. Build a new value by concatenation (`+`, with a `char`
operand promoted to a one-character string) or `copy`. Convert with `str` (to a string)
and `val` (from a string).

A double-quoted literal is an **interpolated** string: each `${expr}` hole is rendered to
text (as `write` would render it) and concatenated into the result, so
`"x = ${x}, ok = ${found}"` folds to `'x = ' + str(x) + ', ok = ' + str(found)`. Write a
literal dollar-brace as `$$` before the brace and a literal quote as `""`. A single-quoted
literal is never interpolated. Hole types: string, `char`, the integer widths and
`int64`, and `bool`/enum (rendered as their ordinal number); a `real` is not supported yet
(convert it with `str`), and a hole may not contain a double-quoted string.

Higher-level string helpers (`UpperCase`, `LowerCase`, `Trim`, `StringReplace`, and string
`Delete`/`Insert`) live in the standard-library `core.strings` unit, reached with
`uses core.strings` and called qualified (`strings.UpperCase`, `strings.Delete`, so the
string `Delete`/`Insert` do not shadow the dynamic-array built-ins). See `kp-units.md` for
the unit and the search path that finds it.

## Input and output

Output uses the overloaded `write` and `writeln` routines. Each argument is written by
its type, an integer, real, char, or string, and `writeln` ends the line:

```pascal
writeln('count = ', n);
writeln(erroutput, 'failed');
```

An optional first argument selects a stream: the predefined `output` (standard output,
the default) or `erroutput` (standard error). `flush` flushes a stream, and `halt` ends
the program with a chosen exit code. `abort` and `assert(cond)` are the fatal-fault
builtins: they end the program with exit 70 (an unconditional fault, or one when
`cond` is false), distinct from `halt`'s orderly exit, and on skj-run they print a
symbolized backtrace.

Input uses `read` and `readln`, which read from standard input into their arguments.
Each argument must be a variable of a readable type: an integer, real, char, or string.
Reading is token-based: a numeric argument skips leading whitespace (including line
breaks) and reads one whitespace-delimited token; a string argument reads the rest of
the current line; and a char argument reads the next single character. `read` leaves the
line's newline in place, while `readln` consumes the rest of the current line after its
arguments, so `readln(a, b)` reads two values from one line and moves past it. Plain
`readln` with no arguments skips a line. There is no field-width formatting, matching
`write`.

```pascal
readln(count);        { one integer from a line }
readln(x, y);         { two values from one line }
readln(name);         { the rest of the line as a string }
readln;               { skip to the next line }
```

`write` and `writeln` take plain overloaded arguments. Standard Pascal's field-width
and precision formatting (`write(x:width)` and `write(x:width:decimals)`) is not
supported. Format a value with the string builtins (`str`, `copy`) or a host
`external` when needed.

File input in a program is done through a host primitive, not a built-in `file` type. The
compiler itself reads its input with an `external` `ReadFileStr(path): string`.

## Coroutines

A coroutine is a routine that runs on its own stack and can suspend. Its value has type
`process`, a handle.

The five coroutine primitives (`start`, `yield`, `bind`, `release`, and the `process` type)
are base-grammar control flow, like `for` and `while`, not a library reached through a unit.
`start` takes a call form, `yield` is a suspension point, and `bind` introduces a binding, so
they need compiler lowering and a stackful runtime rather than an ordinary call. Higher-level,
library-shaped ergonomics (a scheduler, spawn/join, a give-up-the-turn helper) may be added
later as a unit built on top of these primitives.

- **start.** `start routine(args)` creates a coroutine from a call and returns a
  `process`. A `start begin ... end` block form runs an inline body; the block may not
  read an enclosing local, so data reaches a coroutine through the started routine's
  by-value arguments.
- **yield.** `yield` inside a coroutine suspends it, returning control to whoever ran it.
  A yield is a statement, not an expression, so it may not appear nested in an expression.
- **bind.** `bind` resumes a suspended coroutine.
- **release.** `release` drops a coroutine (or any handle). Dropping a suspended coroutine
  unwinds it so its locals are released.

The full grammar and the lifetime rules are in `kp-grammar.md` and `kobold.md`.

## Handles and lifetime

A handle (an interface value or a `process`) is a reference-counted reference to a
host-owned object. The compiler manages references automatically: an assignment retains
the new value and releases the old, and a handle local is released when its scope ends.
`release` drops a reference early. This is reference counting (ARC), not tracing garbage
collection. Fields of a record that are handles are managed the same way.

## Compiler directives

A directive is a brace comment whose first character is `$`.

- **Range and overflow checks.** `{$R+}` turns on array-bounds checks (raising an index
  trap), `{$R-}` off; `{$Q+}` turns on checked arithmetic (raising an overflow trap),
  `{$Q-}` off. Both are off by default and may be toggled through the source.
- **Conditional compilation.** `{$DEFINE name}` and `{$UNDEF name}` set and clear a
  symbol; `{$IFDEF name}` / `{$IFNDEF name}` ... `{$ELSE}` ... `{$ENDIF}` include a region
  by whether a symbol is defined. The compiler predefines `KOBOLD`, so a source can select
  a Kobold-only region with `{$IFDEF KOBOLD}`.
- **Include.** `{$I filename}` (with a space after `I`) inserts another file at that point.
  The compiler searches the including file's directory.

Directives the compiler does not act on, such as `{$mode ...}` or `{$H+}`, are ignored, so
a source shared with Free Pascal may carry them.

## See also

- `kp-grammar.md` the full grammar in EBNF.
- `kobold.md` the compiler and runtime design, including nested-routine lowering and the
  string and coroutine runtimes.
- `kp-abi.md` the host ABI for `external` routines and handle types.
- `kp-module-format.md` the KPM1 module the front end emits.
