# Kobold-Pascal Tutorial

This tutorial teaches Kobold-Pascal from a first program upward, one feature at a
time. Each step is a complete program you can compile and run. For the quickest
loop, run each with the in-process JIT:

```sh
skj-kp-jit step.pas
```

Two steps need more than the bare JIT, and each says so where it comes up: a
program that `uses` a unit needs that unit's compiled module on the path (step
19), and inline assembly is ahead-of-time only (step 20).

For the precise rules behind anything here, see the reference (`kp-language.md`)
and the grammar (`kp-grammar.md`). The static-semantics rules are in
`kp-semantics.md`, the predefined routines in `kp-builtins.md`, and the run-time
behavior in `kp-evaluation.md`. For how to embed the language in a C host, see
`kp-guide.md`, `kp-embedding.md`, and `kp-abi.md`.

Kobold is case-insensitive, so `WriteLn`, `writeln`, and `WRITELN` are the same
name, and so is `Begin` for the keyword `begin`.

## 1. Hello, Kobold

Every program is a `program` block with a name, optional declarations, and a body
between `begin` and `end.` (note the trailing period).

```pascal
program hello;
var i: integer;
begin
  WriteLn('Hello from Kobold via skjegg');
  WriteLn('6 * 7 = ', 6 * 7);
  for i := 1 to 3 do
    WriteLn('line ', i);
end.
```

`WriteLn` is not special syntax; it is an overloaded routine, so it prints
strings and integers through one name and takes several arguments. `Write` is the
same without the trailing newline.

Run it:

```sh
skj-kp-jit hello.pas
```

## 2. Variables and expressions

Declare variables in a `var` block, with the type after the colon. Assignment is
`:=`; `=` is the equality test. The ordinary integer operators are `+ - *`, with
`div` and `mod` for integer division and remainder; `/` produces a `real`.

```pascal
program vars;
var
  a, b, sum: integer;
  avg: real;
begin
  a := 17;
  b := 25;
  sum := a + b;
  avg := sum / 2;
  WriteLn('sum = ', sum);
  WriteLn('avg = ', avg);
end.
```

Operator precedence, highest first: `not` and unary sign; then `* / div mod and
shl shr`; then `+ - or`; then the comparisons `= <> < > <= >= in`. Parenthesize
when in doubt. Argument and operand evaluation order is right to left.

## 3. Scalar types: integers, reals, char, boolean

`integer` is the default 32-bit signed type. The other integer types differ only
in width and signedness at declaration: `byte` and `shortint` (8-bit), `word`
(16-bit), `cardinal` (unsigned 32-bit), and the genuine 64-bit `int64` and
`qword`. A `char` holds one byte, and `boolean` holds `false` or `true`. A
`boolean` or an enum prints as its ordinal number, so `WriteLn(true)` prints `1`.

```pascal
program scalars;
var
  b: byte;
  big: int64;
  ok: boolean;
  ch: char;
begin
  b := 255;
  big := 1000000000;
  big := big * big;          { a real 64-bit product }
  ok := b > 100;
  ch := Chr(65);
  WriteLn(b, ' ', big);
  WriteLn(ok, ' ', ch, ' ', Ord(ch));
end.
```

`real` and `double` are 64-bit IEEE doubles; `single` is a 32-bit float. Mixed
integer and real arithmetic promotes to real, and `/` always yields a real.
Default real output prints the shortest form that round-trips, with no trailing
zeros, so `2.5` prints `2.5` and `6.28` prints `6.28`.

A **subrange** restricts an ordinal type to a range of values, and a type name
applied like a call is a conversion:

```pascal
type Digit = 0..9;
...
d := 7;              { a Digit }
n := int64(d);       { a conversion to int64 }
```

The ordinal built-ins operate on any ordinal type: `Ord`, `Chr`, `Low`, `High`,
`Succ`, `Pred`, `Inc`, `Dec`, and `Odd`.

## 4. Named constants

Declare constants in a `const` part. A constant can be a scalar, or a typed
aggregate: an array, a record, or a nesting of both.

```pascal
program constants;
type Point = record x, y: integer; end;
const
  Limit = 3;
  Name  = 'kobold';
  Grid:   array[1..2, 1..3] of integer = ((1, 2, 3), (4, 5, 6));
  Corner: Point = (x: 10; y: 20);
var i, j: integer;
begin
  WriteLn(Name, ', limit ', Limit);
  for i := 1 to 2 do
    for j := 1 to 3 do
      Write(Grid[i, j], ' ');
  WriteLn;
  WriteLn(Corner.x, ',', Corner.y);
end.
```

A constant value is a constant expression: ordinal arithmetic is folded, a real
constant must be a signed literal, and a value cannot call a function.

## 5. Control flow

The usual Pascal control structures are here. A block of more than one statement
is wrapped in `begin ... end`.

```pascal
program flow;
var i, n: integer;
begin
  n := 0;
  for i := 1 to 10 do
  begin
    if (i mod 2) = 0 then
      n := n + i;          { sum the even numbers }
  end;
  WriteLn('sum of evens 1..10 = ', n);

  i := 1;
  while i <= 3 do
  begin
    WriteLn('while ', i);
    i := i + 1;
  end;

  repeat
    WriteLn('repeat ', i);
    i := i - 1;
  until i = 0;
end.
```

`and` and `or` short-circuit, so a left operand can guard the right:
`(i <= n) and (a[i] = x)` is safe when `i` might be out of range. `break` and
`continue` work inside any loop. The `for` counter is undefined after the loop;
`downto` counts down instead of up.

A **case** statement selects on an ordinal or a string. Labels may be single
values or, for an ordinal, ranges, with an optional `else`:

```pascal
program grade;
var i: integer; c: char;
begin
  for i := 1 to 5 do
    case i of
      1, 2: WriteLn(i, ': small');
      3..4: WriteLn(i, ': middle');
    else
      WriteLn(i, ': large');
    end;

  c := 'q';
  case c of
    'a'..'p': WriteLn('early');
    'q'..'z': WriteLn('late');
  end;
end.
```

A string selector matches each label by value, so a whole word can drive the
selection (`'north', 'n': ...`). String labels are discrete values, not ranges.

## 6. Procedures and functions

A procedure returns nothing; a function returns a value, assigned to the
function's own name inside the body, or returned early with `exit(value)`. Plain
`exit` returns from the current routine.

```pascal
program routines;

function firstDigit(s: string): integer;
var i: integer;
begin
  for i := 1 to Length(s) do
    if (s[i] >= '0') and (s[i] <= '9') then
      exit(Ord(s[i]) - Ord('0'));   { return as soon as one is found }
  firstDigit := -1;                 { fall through: none found }
end;

begin
  WriteLn(firstDigit('abc7x'));     { 7 }
  WriteLn(firstDigit('none'));      { -1 }
end.
```

**Parameters** are by value unless marked otherwise. A parameter group is
`[ var | out | const ] names : Type`:

- **value** (no keyword): the routine gets a copy.
- **var**: by reference; the routine may read and write the caller's variable.
- **out**: by reference, intended for a result the routine writes.
- **const**: by reference but read-only, used for large values like arrays and
  records you do not want copied.

```pascal
procedure divmod(a, b: integer; out q, r: integer);
begin
  q := a div b;
  r := a mod b;
end;
```

**Overloading** lets several routines share a name and be chosen by argument
type at the call site. This is why `WriteLn` prints a string, an integer, or a
real under one name, and a program can add its own:

```pascal
type Point = record x, y: integer; end;
procedure show(n: integer);        begin WriteLn('int ', n); end;
procedure show(const p: Point);    begin WriteLn('(', p.x, ', ', p.y, ')'); end;
```

**forward** declares a routine's header ahead of its body so two routines can
call each other:

```pascal
function isEven(n: integer): boolean; forward;
```

A routine may be **nested** inside another and may read and write the enclosing
routine's locals. A nested routine does not escape: it may be called but not
stored or returned, because there are no closures.

```pascal
function sumTo(n: integer): integer;
var total, i: integer;
  procedure add(k: integer);
  begin total := total + k; end;    { reaches the enclosing total }
begin
  total := 0;
  for i := 1 to n do add(i);
  sumTo := total;
end;
```

## 7. Arrays and records

A fixed array has an ordinal index range; a record groups named fields. Both are
value types: assigning one copies it.

```pascal
program shapes;
type
  Vec   = array[1..3] of integer;
  Point = record x, y: integer; end;
var
  v: Vec;
  p: Point;
  i: integer;

function dot(const u, w: Vec): integer;
var acc, k: integer;
begin
  acc := 0;
  for k := 1 to 3 do
    acc := acc + u[k] * w[k];
  dot := acc;
end;

begin
  for i := 1 to 3 do
    v[i] := i;
  WriteLn('dot(v, v) = ', dot(v, v));

  with p do begin        { open p's fields as bare names }
    x := -3;
    y := 4;
  end;
  WriteLn('p = (', p.x, ', ', p.y, ')');
end.
```

Arrays can be multi-dimensional (`array[0..3, 1..2] of integer`), and a field or
element can itself be an array or record. The `with recordExpr do stmt` form
opens a record's fields as bare names in the body.

A **method** attaches a routine to a record (or a handle type) with a `for`
receiver, called with dot notation. The receiver is by reference by default, so a
method may mutate it; a `const` receiver is read-only:

```pascal
function manhattan for (const p: Point): integer;
begin manhattan := Abs(p.x) + Abs(p.y); end;
...
WriteLn(p.manhattan);
```

A **variant record** overlays alternatives after a tag, sharing storage. The
largest variant sets the size, and the variant fields share one offset:

```pascal
type Number = record
  case kind: integer of
    0: (i: integer);
    1: (r: real);
end;
```

## 8. Enumerations and sets

An enumerated type lists its ordered values; a set holds a subset of a small
ordinal base type.

```pascal
program colors;
type
  Direction = (north, east, south, west);
  DirSet    = set of Direction;
var
  d: Direction;
  exits: DirSet;
begin
  d := east;
  exits := [north, east];
  if d in exits then
    WriteLn('can go east');
  if not (south in exits) then
    WriteLn('south is blocked');
end.
```

Set operators are `+` (union), `-` (difference), `*` (intersection), and `in`
(membership); `[]` is the empty set. A set is a value, so it can be a record
field, an array element, or a map value, and assignment copies it.

## 9. Dynamic arrays and open-array parameters

A **dynamic array** has no fixed bound and is sized with `SetLength`. It is a
handle with value semantics like a string: assignment shares the storage, and the
next edit of a shared array makes it unique first (copy on write). `Length`,
`Low`, and `High` report its bounds, and `Low` is always 0.

```pascal
program dyn;
var xs: array of integer; i: integer;
begin
  SetLength(xs, 4);
  for i := 0 to High(xs) do
    xs[i] := i * i;

  Insert(xs, 0, 1);      { open one slot at index 0, shifting the tail up }
  xs[0] := 99;           { fill it }
  Delete(xs, 2, 1);      { remove one element at index 2, shifting the tail down }

  for i := 0 to High(xs) do
    Write(xs[i], ' ');
  WriteLn;
  WriteLn('len = ', Length(xs));
end.
```

`Insert(a, index, count)` opens `count` zero-filled slots that the caller then
fills by assignment; Kobold's `Insert` opens a gap rather than taking a value.
`index` and `count` are clamped to the array.

An **open-array parameter**, written `array of T`, receives any dynamic array (or
a fixed array) of element type `T`, so one routine works over arrays of any
length:

```pascal
function total(const xs: array of integer): integer;
var i: integer;
begin
  total := 0;
  for i := 0 to High(xs) do
    total := total + xs[i];
end;
```

## 10. Maps

A **map** is an associative array with a typed value. The key is a string by
default, or an ordinal written `map[K] of T` where `K` is `integer`, `int64`,
`char`, an enum, or `boolean`.

```pascal
program scores;
var
  m: map of integer;
  name: string;
  n: integer;
begin
  m['ada'] := 42;
  m['bob'] := 7;
  m['bob'] := m['bob'] + 1;
  WriteLn('bob = ', m['bob']);
  WriteLn('count = ', Length(m));

  if 'ada' in m then WriteLn('ada present');
  if TryGet(m, 'ada', n) then WriteLn('got ', n);

  Delete(m, 'ada');
  WriteLn('count = ', Length(m));

  for name, n in m do
    WriteLn(name, ' = ', n);
end.
```

Assigning to a key inserts it, creating the map if the variable is nil. Reading a
key that is not present traps, so test with `k in m` first or fetch with
`TryGet`. A map has value semantics like a dynamic array: pass it as `const` to
read it without a copy. Iterate with the two-variable `for k, v in m do` (step
12), or with the explicit `MapFirst`/`MapNext` cursor. The iteration order is
unspecified, and inserting or removing a key mid-iteration traps.

## 11. Strings and interpolation

`string` is a length-counted, host-managed byte string, not a block of memory. It
is indexed from 1, so `s[1]` is the first character and `Length(s)` is the count.
Strings are immutable: `s[i]` reads a character but cannot be assigned. Assignment
shares the bytes cheaply; a new value comes from concatenation (`+`) or `Copy`.

```pascal
program strings;
var a, b: string; where: integer;
begin
  a := 'kobold';
  b := a;                            { b and a share the same value }
  WriteLn(Length(a), ' ', a[1]);     { 6 K }
  WriteLn(Copy(a, 2, 3));            { obo }
  where := Pos('bol', a);            { 1-based index, or 0 }
  WriteLn('bol at ', where);
  WriteLn('up ' + a);                { concatenation }
end.
```

A `char` in a string context is promoted to a one-character string, so `s + ch`
and `ch1 + ch2` are strings.

A **double-quoted** literal is an **interpolated** string: each `${expr}` hole is
rendered to text the way `Write` renders it, and concatenated into the result. A
single-quoted literal never interpolates.

```pascal
program interp;
var name: string; count: integer;
begin
  name := 'Ada';
  count := 3;
  WriteLn("hello ${name}, you have ${count} messages");
end.
```

Write a literal dollar-brace as `$$` before the brace and a literal double quote
as `""`. A hole may hold a string, a `char`, an integer width, an `int64`, or a
`bool`/enum (as its ordinal number); a `real` hole is not supported yet, so
convert it with `Str` first, and a hole may not contain a double-quoted string.

Higher-level helpers (`UpperCase`, `LowerCase`, `Trim`, `StringReplace`, and
string `Delete`/`Insert`) live in the `core.strings` unit (step 19), not the
base language.

## 12. Iterating with for-in

The counted loop walks a range of integers; the `for`-`in` loop walks the
elements of a sequence directly. The loop variable is pre-declared, like the
counted loop's counter, and its type must match the element type.

```pascal
program iterate;
type Triple = array[1..3] of integer;
var
  t: Triple;
  s: string;
  x: integer;
  c: char;
begin
  t[1] := 10; t[2] := 20; t[3] := 30;
  for x in t do Write(x, ' ');       { 10 20 30 }
  WriteLn;

  s := 'abc';
  for c in s do Write(Ord(c), ' ');  { 97 98 99, byte by byte }
  WriteLn;
end.
```

The source can be a fixed array (over its index range), a dynamic array
(`0..High`), a string (byte by byte, each a `char`), a set (its members in
ordinal order), a map (binding two variables, `for k, v in m do`), or a custom
cursor. Use `_` to ignore a binder and run the body once per element. `break` and
`continue` work as in any loop.

A **custom cursor** is any record or handle type with a method
`function Next for (c): E fails` (step 15), where a failure ends the loop:

```pascal
type Counter = record cur, stop: integer; end;

function Next for (c: Counter): integer fails;
begin
  if c.cur >= c.stop then fail(1);
  Next := c.cur;
  c.cur := c.cur + 1;
end;
...
c.cur := 0; c.stop := 4;
for x in c do Write(x, ' ');         { 0 1 2 3 }
```

The receiver is by reference, so `Next` advances the cursor in place and the loop
consumes it. A multi-dimensional fixed array cannot be iterated this way; use
nested counted loops.

## 13. Properties and computed fields

A **property** presents as a value but reads and writes through accessor routines
(uniform access). A read calls the getter; a write calls the setter; with only a
`read` accessor it is read-only.

```pascal
program vol;
var backing: integer;

function getVolume: integer;
begin getVolume := backing; end;

procedure setVolume(v: integer);
begin if v < 0 then v := 0; backing := v; end;   { the setter validates }

property volume: integer read getVolume write setVolume;

begin
  volume := 5;
  volume := volume + 3;
  WriteLn('volume = ', volume);     { 8 }
  volume := -1;
  WriteLn('clamped = ', volume);    { 0, the setter clamped it }
end.
```

A record may carry a **computed field** with the same form, where the accessors
are methods of the record:

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

A property is not a stored cell, so it has no address and cannot be passed by
reference. See `kp-property.md`.

## 14. Scoped cleanup with defer

`defer stmt` registers `stmt` to run at the end of its enclosing block, in
reverse order (last deferred, first run). It gives a routine one local place to
pair a release with its acquisition instead of repeating cleanup on every exit
path.

```pascal
program cleanup;
procedure run;
begin
  defer WriteLn('released B');   { runs second }
  defer WriteLn('released A');   { runs first }
  WriteLn('working');
end;
begin
  run;
end.
```

This prints `working`, `released A`, `released B`. Deferred statements run on
every orderly exit from the block: falling off the end, `exit`, `break`,
`continue`, and the failable diverts of step 15. They do **not** run on a trap
(panic, bounds, nil, divide-by-zero), which unwinds straight to the program's
landing pad. The deferred statement may not itself leave its block, so `exit`,
`break`, `continue`, `yield`, a failable divert, and a nested `defer` are compile
errors inside it. See `kp-defer.md`.

## 15. Error handling: failable routines

Kobold keeps two kinds of failure apart. An **unexpected** failure (a bad index,
a nil dispatch, divide-by-zero, an explicit `abort` or `assert`) is a trap: it
unwinds to the landing pad and exits 70. An **expected** failure (a parse that
does not match, a lookup that misses) is an ordinary value the caller must deal
with. This step is about the second kind.

A routine opts into failure with `fails` after its result. Inside, `fail(code)`
reports a failure; falling off the end, or a plain `exit`, reports success.

```pascal
program failable;

function parse(s: string): integer fails;
var i, v: integer;
begin
  if Length(s) = 0 then fail(1);
  v := 0;
  for i := 1 to Length(s) do
  begin
    if (s[i] < '0') or (s[i] > '9') then fail(2);
    v := v * 10 + (Ord(s[i]) - Ord('0'));
  end;
  parse := v;
end;

begin
  WriteLn(parse('123') or else -1);     { 123, the value on success }
  WriteLn(parse('xy')  or else -1);     { -1, the fallback on failure }

  if parse('') fails e then             { test, binding the error to e }
    WriteLn('failed, code ', errorcode(e));
end.
```

Calling a failable routine and ignoring the error is a compile error. There are
five ways to deal with it:

- **`or else V`** recovers with a value: `n := parse(s) or else 0;`.
- **`fails`** tests in a condition, with an optional error binder:
  `if parse(s) fails e then ...`. The binder `e` is scoped to that branch.
- **`or exit` / `or break` / `or continue`** leave by that control transfer. Each
  reports **success** upward, because none of them sets the error register, so
  `or exit` is the "give up quietly" form.
- **`or fail`** leaves the current routine forwarding the inner error unchanged.
  It is legal only inside a failable routine, and is the one-level propagation
  form: `raw := readFile(path) or fail;`.
- **`or else ignore`** drops the error explicitly, so it is visible in the source:
  `log(msg) or else ignore;`.

The result of a failable function or method may be any value type. There is no
implicit propagation and no `try`/`except`; each caller handles or forwards, once,
at the call site. See `kp-errors.md`.

## 16. Host handles and methods

A game or tool embeds Kobold and exposes its own objects to scripts as opaque
handles. A script declares the handle type with `interface` syntax and calls
methods on it; the host dispatches the call. The script never sees the object's
memory, only the handle.

```pascal
program move;
type
  Entity = interface
    move: procedure (dx, dy: integer);
    name: function : string;
  end;

procedure step(e: Entity);
begin
  e.move(1, 0);
  WriteLn(e.name, ' moved');
end;

var guard: Entity;
begin
  guard := spawnGuard;   { a host function that returns a handle }
  step(guard);
end.
```

Handle values are reference-counted: a reference is retained on assignment and
released when overwritten or when a scope ends, and `release(h)` drops one early.
`nil` is the empty handle. This program needs a host that registers `Entity` and
provides `spawnGuard`, so it is compiled against a host rather than run bare. See
`kp-embedding.md` for the host side and `kp-abi.md` for the handle contract.

A routine the host provides is declared `external` (step 19 shows the FFI forms).

## 17. Coroutines

A coroutine runs until it reaches a `yield`, then suspends. `start` creates one
and returns a `process` handle; you resume it by calling that handle like a
function, `k(v)`. The first call runs the body from the top to its first `yield`,
and each later call continues from where it suspended. `yield E` hands `E` back as
the value of that call.

```pascal
program ticker;
var
  k: process;
  i: integer;

procedure counter;
var n: integer;
begin
  for n := 1 to 3 do
    yield n;           { suspend, handing n back to the resumer }
end;

begin
  k := start counter;  { create the coroutine; the body has not run yet }
  for i := 1 to 3 do
    WriteLn('tick ', k(0));   { each call runs to the next yield }
end.
```

A coroutine keeps its own stack, so it can be suspended at any call depth and
resumed later. The argument passed in a resume, `k(0)` above, becomes the value of
the waiting `yield`. `release(k)` cancels one you will not resume, unwinding it so
its locals are released. The five primitives (`start`, `yield`, `bind`,
`release`, and the `process` type) are base control flow, not a library. See the
Coroutines section of `kp-guide.md` for `bind` and the inline `start begin ... end`
block form.

## 18. Computed goto (threaded dispatch)

For a bytecode interpreter's inner loop, Kobold has a restricted computed `goto`.
A `name:` label marks a statement, `@name` is the address of a label, and
`goto EXPR` jumps to a label value. The usual shape is a table of label addresses
indexed by the next opcode, the threaded-dispatch `NEXT`.

```pascal
program vm;
procedure run;
var
  disp: array[0..2] of label;
  code: array[0..2] of integer;
  acc, pc: integer;
begin
  disp[0] := @op_push;              { build the dispatch table }
  disp[1] := @op_dbl;
  disp[2] := @op_done;
  code[0] := 0; code[1] := 1; code[2] := 2;
  acc := 0; pc := 0;
  goto disp[code[pc]];              { NEXT }
op_push:
  acc := acc + 7; pc := pc + 1; goto disp[code[pc]];
op_dbl:
  acc := acc * 2; pc := pc + 1; goto disp[code[pc]];
op_done:
  WriteLn('acc = ', acc);           { (0 + 7) * 2 = 14 }
end;
begin
  run;
end.
```

A `label` value is **second-class**: it is made only by `@name` and may live only
in its routine's own frame, as a local variable or a routine-local `array of
label`, so the machine runs inside a procedure. There is no unstructured `goto`: a
bare `goto name` to a label is a compile error, and because a label value cannot
leave its frame, a computed jump always lands in a live frame. See
`kp-semantics.md`.

## 19. Units and the standard library

A larger program is divided into units that compile separately and link by
`uses`. A unit has an `interface` part (what it exports) and an `implementation`
part (the bodies). A name is exported by appearing in the interface; anything
declared only in the implementation is private.

```pascal
unit geometry;
interface
  type Vec = record x, y: real; end;
  function magnitude(const v: Vec): real;
implementation
  function magnitude(const v: Vec): real;
  begin
    magnitude := sqrt(v.x * v.x + v.y * v.y);
  end;
end.
```

A program brings a unit in with `uses`. The `as _` form imports its names bare,
which is the default idiom; qualify only when a bare name would clash:

```pascal
program app;
uses geometry as _;
var v: Vec;
begin
  v.x := 3.0; v.y := 4.0;
  WriteLn('len = ', magnitude(v));
end.
```

A unit is compiled to a module first, then the program is compiled against it. The
dotted unit name maps its dots to directory separators, so `core.strings` is
sought as `core/strings` under the unit path:

```sh
# compile the unit to a module in a unit directory
skj-kpc --emit-kpm geometry.pas -o units/geometry.kpm

# then compile the program with that directory on the unit path
skj-kpc -U units --emit-kpm app.pas -o app.kpm
```

Under the quick JIT loop, the compiled `units/geometry.kpm` must sit beside the
program source (in the same dotted-path layout), because the JIT front end
resolves units from the source's own directory.

The **standard library** ships as units under this model. `core.strings` holds
the higher-level string helpers, `core.convert` the failable `Val`, `io.files`
and `io.textfile` file I/O, and `std.threads` cooperative threads. Bring one in
the same way:

```pascal
uses core.strings as _;
...
s := UpperCase(Trim(raw));
```

See `kp-units.md` for the full model (opaque types, exported `var` and `const`,
interface fingerprints, and `implement ... for` trait conformance) and the search
path that finds a unit.

## 20. Inline assembly

When you need an instruction the language does not expose, `asm('text')` drops one
line straight into the generated assembly:

```pascal
program spin;
var a: integer;
begin
  a := 40;
  asm('/* kobold inline asm marker */');   { emitted verbatim }
  WriteLn('a = ', a + 2);
end.
```

The string is passed through unchanged, so its text must match the assembler for
the target you are building. Here the payload is a C-style comment, which every
target assembler accepts, so the program builds on each backend. For a real
instruction you would write target-specific text, for example `asm('syscall')` on
x86-64 or `asm('svc #0')` on AArch64. The literal is taken as written, with no
`${...}` interpolation even though it looks like a string.

In this basic form there are no operand constraints and no register substitution:
the compiler does not read the text and register allocation does not see it, so
the block must leave the machine state the surrounding code expects.

To hand values to the template, use the extended form, which adds GNU-style
operand sections. Each operand is a constraint string and a parenthesized value,
and `%N` in the template is operand N (outputs first, then inputs):

```pascal
asm('add %0, %1' : '+r'(a) : 'r'(b));   { a := a + b, both in registers }
```

The supported subset is integer-class operands and the general register class:
`=r` for an output, `+r` for a read-write output, and `r` for an input, with a
final section listing any clobbered registers.

Inline assembly is **ahead-of-time only**. The in-process JIT emits machine code
directly and has no assembler for a verbatim string, so a program that uses `asm`
must be compiled with the AOT path (`skj-kpc` plus `kobold/aot-run.sh`); running
it under the JIT reports that inline asm is unsupported.

## 21. Directives, builds, and runtime faults

A compiler **directive** is a brace comment whose first character is `$`:

- `{$R+}` / `{$R-}` turn array-bounds checks on and off; `{$Q+}` / `{$Q-}` turn
  checked arithmetic (overflow) on and off. Both are off by default.
- `{$DEFINE name}`, `{$UNDEF name}`, and `{$IFDEF name}` ... `{$ELSE}` ...
  `{$ENDIF}` select a region by whether a symbol is defined. The compiler
  predefines `KOBOLD`.
- `{$I filename}` (with a space after `I`) inserts another file at that point.

With `{$R+}`, an out-of-bounds index is a trap:

```pascal
program bounds;
{$R+}
var a: array[1..3] of integer; i: integer;
begin
  for i := 1 to 3 do a[i] := i;
  i := 5;
  WriteLn(a[i]);          { traps: array index out of bounds, exit 70 }
end.
```

A trap prints a runtime-fault line and exits 70, distinct from the orderly `Halt`
and `Halt(code)`. `abort` is an unconditional trap and `assert(cond)` traps unless
`cond` holds; on skj-run both print a symbolized backtrace.

Two build paths run a program:

```sh
# quick loop: the in-process JIT compiles and runs source directly
skj-kp-jit prog.pas

# ahead of time: compile to a module, then run it natively
skj-kpc --emit-kpm prog.pas -o prog.kpm
sh kobold/aot-run.sh prog.kpm
```

The JIT is the fast iteration loop; the AOT path is what inline asm and a shipped
native build use. Reading input uses `Read` and `ReadLn`, and command-line
arguments come from `ParamCount` and `ParamStr`.

## Where to go next

- `kp-examples.md` collects complete, annotated programs to compile and run.
- `kp-language.md` is the full reference; `kp-grammar.md` is the grammar;
  `kp-semantics.md` is the static-semantics companion.
- `kp-builtins.md` is the signature reference for the predefined routines.
- `kp-errors.md` covers failable routines; `kp-foreach.md`, `kp-defer.md`, and
  `kp-property.md` cover `for`-`in`, `defer`, and properties in depth.
- `kp-units.md` is the unit and separate-compilation model.
- `kp-guide.md` and `kp-embedding.md` cover embedding and the ahead-of-time build;
  `kp-abi.md` is the host boundary.
