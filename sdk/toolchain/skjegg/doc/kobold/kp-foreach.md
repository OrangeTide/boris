# Kobold-Pascal: iterating with `for`-`in`

The counted loop `for i := lo to hi do` walks a range of integers. The
`for`-`in` loop walks the elements of a sequence directly, without naming an
index:

```pascal
for x in seq do
  stmt;
```

Each element of `seq` is bound in turn to the loop variable `x`, and the body
runs once per element. `break` and `continue` behave as in any loop.

## The loop variable is pre-declared

Like the counted loop's counter, the `for`-`in` variable is an ordinary variable
you declare in a `var` section. It is not introduced by the loop. Its type must
match the element type of the sequence:

```pascal
var
  a: array[1..3] of integer;
  x: integer;
begin
  a[1] := 10; a[2] := 20; a[3] := 30;
  for x in a do
    writeln(x);          { 10, 20, 30 }
end;
```

To run the body once per element without using the element, bind `_`:

```pascal
for _ in a do
  count := count + 1;    { counts the elements }
```

## The sequences you can iterate

The source of a `for`-`in` loop must be a variable (or a field or an index of
one), not a computed expression.

- **A fixed array** iterates over its declared index range, in order. The loop
  variable takes the element type.

  ```pascal
  type Triple = array[1..3] of integer;
  var t: Triple; x: integer;
  ...
  for x in t do write(x);      { t[1], t[2], t[3] }
  ```

- **A dynamic array** iterates from index 0 through `high`, so an empty array
  runs the body zero times.

  ```pascal
  var d: array of integer; x: integer;
  ...
  SetLength(d, 3);
  for x in d do write(x);      { d[0], d[1], d[2] }
  ```

- **A string** iterates its bytes, each bound as a `char`. (A string stores
  UTF-8; this walk is over bytes, so a multi-byte character yields each of its
  bytes in turn.)

  ```pascal
  var s: string; c: char;
  ...
  s := 'abc';
  for c in s do write(ord(c));  { 97, 98, 99 }
  ```

- **A map** binds two variables, the key and the value: `for k, v in m do`. The
  key takes the map's key type (a string, or the ordinal `K` of a `map[K] of T`),
  and the value takes the map's value type. The iteration
  order is unspecified, and inserting or removing a key during the loop traps
  (updating an existing key's value is fine). Bind only the key with one
  variable (`for k in m do`), or ignore either side with `_`
  (`for _, v in m do`).

  ```pascal
  var scores: map of integer; name: string; n: integer;
  ...
  for name, n in scores do
    writeln(name, ' = ', n);
  ```

  This is the `MapFirst`/`MapNext` cursor (see kp-language.md) written as a
  loop; it desugars to exactly that pump.

- **A set** iterates its members in ordinal order, low to high. The loop
  variable takes the set's element type.

  ```pascal
  type Color = (Red, Green, Blue);
  var palette: set of Color; c: Color;
  ...
  palette := [Red, Blue];
  for c in palette do write(ord(c));  { 0, 2 }
  ```

  The walk tests membership across the element type's whole range, so its cost
  is the size of that range (the set's universe), not the number of members.

- **A custom cursor** is any record or handle type with a method
  `function Next for (c): E fails`, where a failure signals the end of the
  iteration. `for x in c do` calls `c.Next` for each element, binds the result
  to `x`, and stops when `Next` fails.

  ```pascal
  type Counter = record cur, stop: integer; end;

  function Next for (c: Counter): integer fails;
  begin
    if c.cur >= c.stop then fail(1);
    Next := c.cur;
    c.cur := c.cur + 1;
  end;
  ...
  var c: Counter; x: integer;
  c.cur := 0; c.stop := 3;
  for x in c do write(x);   { 0, 1, 2 }
  ```

  The receiver is by reference, so `Next` advances the cursor in place: a
  `for`-`in` over a cursor consumes it, and the cursor variable is left at its
  end state after the loop.

## How it compiles

A `for`-`in` loop lowers to the counted loop you would have written by hand. The
compiler synthesizes a hidden index that walks the sequence's bounds (its index
range for a fixed array, `0..high` for a dynamic array, `1..length` for a
string) and assigns the element into the loop variable at the top of each
iteration. There is no iterator object and no per-element call, so iterating an
array or string costs exactly what the counted form costs. Because the element
binding is an ordinary assignment, a string loop variable is managed the same
way any string assignment is.

A map loop desugars to its cursor pump: `it := MapFirst(m); while MapNext(it,
k, v) do ...`, with a hidden throwaway variable standing in for any binder you
wrote as `_`. A custom cursor desugars to `while true do begin x := c.Next or
break; ... end`, so it reuses the ordinary failable divert.

A multi-dimensional fixed array cannot be iterated with `for`-`in`; iterate it
with nested counted loops over each dimension.
