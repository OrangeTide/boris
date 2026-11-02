# Kobold-Pascal Examples

A set of complete programs you can compile and run, each with its output. They
are small on purpose, one idea apiece. For a guided path through the language,
read `kp-tutorial.md`; for the rules, `kp-language.md`.

Every program here is in the skjegg tree under `tests/kp-src/`, paired with a
`.expected` file holding exactly the output shown below (the test suite compiles
and runs each one and compares). Run any of them with the in-process JIT:

```sh
skj-kp-jit tests/kp-src/hello.pas
```

or build a native executable:

```sh
skj-kpc --emit-kpm tests/kp-src/hello.pas -o hello.kpm
sh kobold/aot-run.sh hello.kpm
```

## Hello and a counting loop

`tests/kp-src/hello.pas`. Output through the overloaded `WriteLn`, mixing a
string and an integer, and a `for` loop.

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

```
Hello from Kobold via skjegg
6 * 7 = 42
line 1
line 2
line 3
```

## Recursion: Fibonacci

`tests/kp-src/fib.pas`. A recursive function returns its value by assigning to
its own name.

```pascal
program fib;
var i: integer;

function fib(n: integer): integer;
begin
  if n < 2 then
    fib := n
  else
    fib := fib(n - 1) + fib(n - 2);
end;

begin
  for i := 0 to 10 do
    WriteLn('fib(', i, ') = ', fib(i));
end.
```

```
fib(0) = 0
fib(1) = 1
fib(2) = 1
fib(3) = 2
fib(4) = 3
fib(5) = 5
fib(6) = 8
fib(7) = 13
fib(8) = 21
fib(9) = 34
fib(10) = 55
```

## 64-bit integers

`tests/kp-src/int64.pas`. `int64` holds values beyond the 32-bit range, with the
full set of operators.

```pascal
program i64test;
var
  a, b: int64;
begin
  a := 1000000000;
  b := a * a;
  WriteLn('a = ', a);
  WriteLn('b = ', b);
  WriteLn('b div a = ', b div a);
end.
```

```
a = 1000000000
b = 1000000000000000000
b div a = 1000000000
```

## Real numbers and formatting

`tests/kp-src/realfmt.pas`. `real` is an IEEE double. Default output prints the
shortest form that round-trips, with no trailing zeros.

```pascal
program realfmt;
var
  x: real;
begin
  x := 14.25;
  WriteLn(x);
  x := 3.14;
  WriteLn(x);
  WriteLn(2.5);
  WriteLn(0.25);
  WriteLn(x + x);
end.
```

```
14.25
3.14
2.5
0.25
6.28
```

## Transcendental functions

`tests/kp-src/transc.pas`. The math built-ins are available in every tier,
including the freestanding one, and agree to the printed precision across
targets.

```pascal
program transc;
begin
  WriteLn(sin(0.0));
  WriteLn(cos(0.0));
  WriteLn(exp(1.0));
  WriteLn(ln(exp(2.0)));
  WriteLn(sin(1.0));
  WriteLn(arctan(1.0));
  WriteLn(cos(3.0));
end.
```

```
0
1
2.71828
2
0.841471
0.785398
-0.989992
```

## Coroutines

`tests/kp-src/coro.pas`. `start` creates a coroutine; calling the `process`
handle resumes it to the next `yield`, whose value the call returns.

```pascal
program coro;

procedure counter;
begin
  yield 1;
  yield 2;
  yield 3;
end;

var
  k: process;
begin
  k := start counter;
  WriteLn(k(0));
  WriteLn(k(0));
  WriteLn(k(0));
end.
```

```
1
2
3
```

## Scoped cleanup with `defer`

`tests/kp-corpus/defer.pas`. `defer stmt` runs `stmt` when its block exits, in
reverse order (last deferred, first run), on every orderly exit: fall-through,
`exit`, `break`, and `continue`. It keeps a release next to its acquisition.

```pascal
program deferdemo;

procedure run;
begin
  defer WriteLn('closed');   { runs when run returns, after the body }
  WriteLn('opened');
  WriteLn('working');
end;

begin
  run;
end.
```

```
opened
working
closed
```

## String interpolation

`tests/kp-corpus/interp.pas`. A double-quoted string interpolates `${expr}` holes,
each rendered to text the way `write` renders it; single-quoted strings stay plain.

```pascal
program greet;

var
  name: string;
  count: integer;
begin
  name := 'Ada';
  count := 3;
  WriteLn("hello ${name}, you have ${count} messages");
end.
```

```
hello Ada, you have 3 messages
```

## Iterating with `for`-`in`

`tests/kp-corpus/forin.pas`. `for x in seq do` binds each element of a sequence
to `x` in turn: a fixed array over its index range, a dynamic array over
`0..high`, a string byte by byte. `_` ignores the element.

```pascal
program forindemo;
type Triple = array[1..3] of integer;
var
  t: Triple;
  s: string;
  x: integer;
  c: char;
begin
  t[1] := 10; t[2] := 20; t[3] := 30;
  for x in t do WriteLn(x);
  s := 'abc';
  for c in s do WriteLn(Ord(c));
end.
```

```
10
20
30
97
98
99
```

## Inline assembly

`tests/kp-asm/inline_asm.pas`. `asm('text')` emits its one string literal
verbatim into the generated assembly. The text must match the target
assembler's syntax; here it is a C-style comment, which every target assembler
accepts. A live value spans the `asm` to show it does not disturb the code
around it. Unlike the other examples, this one is **ahead-of-time only**: the
JIT has no assembler for a verbatim string, so build it with `skj-kpc` +
`aot-run.sh`, not `skj-kp-jit`.

```pascal
program inline_asm;
var
  a: integer;
begin
  a := 40;
  asm('/* kobold inline asm marker */');   { emitted verbatim }
  WriteLn('a = ', a + 2);
end.
```

```
a = 42
```

The extended form (`tests/kp-asm/inline_asm_ext.pas`) ties the template to program
variables with GNU-style operand constraints. The simple subset supports
integer-class operands and the general register class: `=r` names an output, `+r`
a read-write output, and `r` an input, with `%N` in the template standing for
operand N (outputs first, then inputs). A fourth section lists clobbered
registers. It is ahead-of-time only, like the basic form.

```pascal
var a, b: integer;
begin
  a := 40; b := 2;
  asm('add %0, %1' : '+r'(a) : 'r'(b));   { a := a + b, in registers }
  WriteLn('a = ', a);                      { a = 42 }
end.
```

## More programs

The skjegg test corpora hold many more Kobold programs, each paired with its
expected output:

- `tests/kp-src/` the portable set that runs on every tier, including the
  no-libc freestanding one (integers, strings, int64, reals, coroutines).
- `tests/kp-asm/` the inline-assembly example, run ahead-of-time only.
- `tests/kp-corpus/` the broad behavioral set: records, arrays, maps, dynamic
  arrays, strings, enums, sets, casts, `var` parameters, and control flow.
- `tests/kp-multi/` cross-unit programs that exercise `uses` and separate
  compilation (see `kp-units.md`).
- `tests/kp-io/` programs that read standard input and command-line arguments.
- `tests/kp-inc/` programs that use the `{$I ...}` include directive.
