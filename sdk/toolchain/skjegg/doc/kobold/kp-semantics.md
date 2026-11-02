# Kobold-Pascal Static Semantics

This document specifies the static semantics of Kobold-Pascal: the type system,
the compatibility and conversion rules, how expressions are typed, how overloaded
calls are resolved, how aggregate values are laid out, what a constant expression
may contain, and how names are resolved. It is the rule-level companion to
`kp-language.md` (the prose reference) and `kp-grammar.md` (the surface syntax).

It describes the language as `kpcom` implements it, not a superset. Where a rule is
subtle or departs from classic Pascal (structural versus nominal typing, the
absence of narrow integer types, case-insensitive name collisions), the text calls
it out. Storage sizes and offsets here are the values the front end computes for the
KPM1 module; the host ABI that consumes them is specified in `kp-abi.md`.

## Type kinds

Every type has one of these kinds:

```
error void integer real boolean char string process nil
enum subrange array record set interface proc map mapiter errorval
```

`error` is the type of an already-reported error, used to suppress cascades. `void`
is the absence of a value (a procedure result). `nil` is the type of the `nil`
literal. `errorval` is the type of a failure value (`error`, see Failability).
`mapiter` is the opaque iterator a `map` traversal yields. The rest correspond to
the source types a program writes.

### The integer and real families

There are two integer types, both of kind `integer`, distinguished only by width:
32-bit (`integer`) and 64-bit (`int64`). There are **no distinct narrow integer
types**: `byte`, `shortint`, `word`, `longint`, and `cardinal` are all aliases for
the 32-bit `integer`, and `qword` is an alias for `int64`. A declared type alias
does not create a new type; it names the same type.

There are two real types, both of kind `real`, distinguished by width: 64-bit
(`real`, aliased `double`) and 32-bit (`single`). A subrange never widens its base
to 64 bits; an `int64` is reached only by naming `int64`.

### Classification

The compiler groups types by predicate rather than by a fixed hierarchy. The
groups that drive the rules below:

- **Ordinal**: `integer`, `char`, `boolean`, `enum`, or a subrange of an ordinal.
  Ordinal types are the legal set bases, case selectors, subrange bases, and array
  index types.
- **Integer-class**: `integer` (either width), or a subrange whose base is
  integer-class.
- **Numeric**: integer-class or `real`.
- **Handle**: `string`, `interface`, `process`, `mapiter`, `map`, or a dynamic
  array. A handle is a reference-counted reference to host-owned storage (see
  `kp-abi.md`); assignment of a handle shares the referent and adjusts its count,
  it does not copy the referent.
- **Aggregate**: a `record`, a fixed array, or a large set. An aggregate is an
  inline value block; assignment copies the whole block.
- **Wide64**: a value that fills one 64-bit register: an `int64` or a small set.

A dynamic array is a handle, not an aggregate; a small set is a Wide64 scalar, not
an aggregate; a large set is an aggregate, not a handle. These three distinctions
decide how a value is passed, returned, copied, and reclaimed.

### The `label` type

`label` is the code-address value type for threaded dispatch (the computed `goto`,
kp-language.md). It is a pointer-sized scalar (one word, like a handle in width) but
not reference-counted and not a handle: it names a code label, not host storage, so
assignment copies the word and nothing is retained or released.

A `label` value is **second-class**, the one escape-restricted type in the language.
It can be produced only by `@name`, where `name` is a label in the current routine,
and it may live only in that routine's own frame. The compiler rejects every path
that would let one outlive the frame it names:

- not a global (module-level) variable;
- not a record or object field;
- not a routine's return type;
- not a parameter (nor an `array of label` parameter);
- not a `map` value or a `set` element.

The only legal homes are a **local variable** of type `label` and a routine-local
**`array of label`** (the dispatch table, filled at loop entry with `@name`
addresses). Because a label value cannot leave its frame, and `@name` resolves only
against the current routine's labels, a `goto` through a label value always targets a
live frame: the safety guarantee is purely static, with no escape analysis and no
runtime frame check. This mirrors the second-class disciplines elsewhere in the
toolkit (a `shared` parameter is call-scoped, never stored or returned).

## Arrays, sets, and maps

- An **array** with one or more index ranges is a **fixed array**: an inline
  aggregate of `element-size x (product of index-range cardinalities)` bytes, in
  row-major order. Its element stride is the element type's size.
- An **array with no index range** (`array of T`) is a **dynamic array**: a handle
  to host-owned, resizable storage. A `buffer of T` is a dynamic array whose
  backing the host owns and will not resize or free on the guest's behalf.
- A **set** (`set of B`, `B` ordinal) is a bitmask indexed by the absolute ordinal
  value of each element, from bit 0. Its width is set by the base's **maximum**
  ordinal, not by how many values the base spans: it is a **small set**, held in one
  64-bit word (a Wide64 scalar), when that maximum is 63 or less, and a **large set**,
  held in two to four 64-bit words and treated as an inline aggregate, when it is
  higher. So `set of 0..7` and `set of (red, green, blue)` are small, but `set of
  'a'..'z'` is large (its maximum ordinal is 122, needing two words) even though it
  spans only 26 values. A base whose maximum ordinal exceeds 255 is not diagnosed; the
  representation is silently capped at four words (256 bits) and higher bits are lost.
- A **map** (`map of T`) is a string-keyed associative array with value type `T`, a
  handle. The bracketed form `map[K] of T` keys by an ordinal `K` (integer, int64,
  char, enum, boolean) instead of a string.

A dynamic-array element and a map value may be any of: an ordinal, a real, a
record, a fixed array, a set, or any handle (including a nested dynamic array or
map, and a record or array that itself contains handle fields). A `buffer of T`
element is restricted to **reference-free data**: no string, handle, array, or
record containing such a field, because the host owns the backing and the runtime
cannot manage element lifetimes across that boundary.

## Type identity and equivalence

Type identity is **nominal by default**. Each occurrence of a type constructor in
the source (`record ... end`, `array [...] of ...`, an enumeration, `set of ...`,
`map of ...`, a procedural type, an `interface`, a subrange) denotes a fresh,
distinct type. A named type is shared only through the name: a `type` declaration
binds one type to an identifier, and every use of that identifier is the same type.
Two separately written but structurally identical declarations are **not** the same
type.

Consequences:

- **Records are nominal.** Two `record` declarations with identical fields are
  distinct types and are not assignment-compatible.
- **Enumerations are nominal.** Each enumeration declaration is a distinct type.
- **Fixed arrays are nominal.** Compatibility holds only between a type and itself.

Three constructors are **structural** for assignment, because a value of one often
has to flow into a variable written at a different source location:

- **Dynamic arrays** match when their element types are equal and both are the same
  array kind (both plain `array of T`, or both `buffer of T`). Array-ness does not
  alias across the host-ownership boundary.
- **`map of T`** values match when their key types and value types `T` are equal (a
  string-keyed map and a `map[K] of T` are distinct types).
- **Procedural types** match when they have the same result type, the same number
  of parameters, and pairwise-equal parameter types.

**Sets are structural for assignment but nominal for comparison.** Any set value is
assignment-compatible with any set variable, but two set values compare equal or
unequal with `=`/`<>`, or order with the subset operators, only when they have the
**same** set type. Two distinct `set of ...` declarations are not comparable.

For matching the parameter lists of overloaded or forward-declared routines, an
open-array parameter (`array of T`) matches another open array of the same element
type even though each written `array of T` is a fresh type; all other parameter
types match by identity.

## Assignment compatibility

A value of type `S` may be assigned to a variable of type `D` (and passed to a
by-value parameter of type `D`, and returned where `D` is expected) exactly when one
of the following holds, tested in order:

1. Either type is the error type (an error was already reported).
2. `D` and `S` are the identical type. This is the nominal base case: it covers
   records, fixed arrays, enumerations, and any two uses of one named type. There is
   one `label` type, so a `label` value is assignable to a `label` variable or
   dispatch-table element by this rule (subject to the second-class placement rules
   above, which bar every non-local home).
3. `S` is `nil` and `D` is a handle able to hold `nil`: an interface, a string, a
   process, a procedural type, or a dynamic array.
4. `D` and `S` are compatible dynamic arrays (equal element type, same array kind).
5. `D` and `S` are maps with equal value type.
6. `D` is a dynamic array and `S` is the empty set constructor `[]` (the empty
   constructor also denotes an empty array).
7. `D` is `real` and `S` is integer-class (integer widens to real).
8. `D` and `S` are both real (a `real` and a `single` are mutually assignable; the
   store widens or narrows).
9. `D` and `S` are both integer-class (any integer width to any integer width).
10. `D` is a subrange: `S` must be assignment-compatible with the subrange's base.
11. `S` is a subrange: its base must be assignment-compatible with `D`.
12. `D` and `S` are both sets (any set to any set).
13. `D` and `S` are both procedural types with matching signatures.

Otherwise the assignment is rejected with `cannot assign S to D`.

Subrange bounds are **not** range-checked statically; a subrange is compatible with
its base in both directions, and an out-of-range store is not a static error.

A **string element is not assignable**: `s[i] := c` is rejected, because a string is
an immutable host value. A **read-only computed field** (a property with no setter)
is likewise not assignable.

### Narrowing warning

Assigning an `int64` value to a 32-bit integer variable is permitted (rule 9) but
raises the narrowing warning W0005, because the high half is dropped. It is silenced
by an explicit `integer(expr)` conversion. Assigning a `real` to a `single` is a
deliberate, unflagged narrowing.

## Implicit conversions

The compiler inserts these conversions automatically; no source syntax is required:

- **Integer to real.** Wherever an integer-class value appears in a real context (a
  real operand of a mixed arithmetic operator, the argument of a real-valued
  built-in, a real assignment target or result), it is converted to real.
- **32-bit to 64-bit integer.** Wherever a 32-bit integer value appears in an
  `int64` context, it is sign-extended to 64 bits.
- **One-character string literal to `char`.** A string literal of length one is
  retyped to `char` in place when the context expects a char: a char assignment or
  argument, a comparison against a char, or a char case label.
- **`char` to string.** In a concatenation where either operand is a string, a
  `char` operand is converted to a one-character string.
- **Small set and large set** are selected by the set's base width; no source form
  distinguishes them.

Nothing else is implicit. In particular:

- There is **no implicit real-to-integer conversion**. Use the `round` or `trunc`
  built-ins.
- There is no implicit conversion between distinct records, between distinct
  enumerations, or between unrelated handle types.

### Explicit conversion

Kobold has no `as` operator. An explicit conversion is written in function-call form,
`TypeName(expr)`. It is permitted only between numeric and ordinal types: both the
source value and the named target must be numeric or ordinal. There is no
conversion between a record, a set, an array, a handle, and another kind.

## Expression typing

Operand and result rules, by operator. `NumResult` of two numeric operands is
`real` if either is real, otherwise `int64` if either is `int64`, otherwise
`integer`. `IntResult` is `int64` if either operand is `int64`, otherwise
`integer`.

| Operator | Operand rule | Result |
| --- | --- | --- |
| `+` | both sets | set union, the operand set type |
| `+` | either operand string, or both char | `string` |
| `+` | both numeric | `NumResult` |
| `-` `*` | both sets | set difference / intersection, the operand set type |
| `-` `*` | both numeric | `NumResult` |
| `/` | both numeric | **always `real`** (real division) |
| `div` `mod` `shl` `shr` | both integer-class | `IntResult` |
| `and` `or` | both boolean | `boolean` |
| `and` `or` | both integer-class | bitwise, `IntResult` |
| `not` (unary) | boolean, or integer-class | same type |
| `-` `+` (unary) | numeric | operand type |
| `=` `<>` `<` `<=` `>` `>=` | comparable (below) | `boolean` |
| `in` | right operand a set | `boolean` |
| `in` | left string, right map | `boolean` (key presence) |

`/` is always real division and always yields `real`, even on two integers; integer
division is `div`. Integer `div` or `mod` by zero is a run-time trap (`DIV_ZERO`),
not a consumable failure and not a compile error, even when the divisor is a literal
zero; see `kp-evaluation.md`. `div` truncates toward zero and `mod` takes the sign of
the dividend (also in `kp-evaluation.md`). For the `in` operator the set case checks
only that the right operand is a set; it does not statically require the left operand
to be an ordinal of the base.

Two operands are **comparable** when both are numeric (compared as numbers after any
int-to-real widening); or, after stripping subranges to their base, they are the
identical type; or one is `nil` and the other a comparable handle (interface, string,
process, or procedural value). The identical-type case is not limited to ordinals: two
strings, two handles of the same interface type, two processes, and two procedural
values compare by it, as does `string = string` (both operands non-`nil`). Because set
types are neither numeric nor reduced by subrange stripping, two sets are comparable
only when they are the identical set type: set comparison is nominal. For comparable
sets, `<=`, `<`, `>=`, and `>` are subset, proper subset, superset, and proper
superset.

An integer literal whose value lies outside the signed 32-bit range is typed
`int64`; otherwise it is typed `integer`. This classification also applies to a
literal used in a constant expression.

## Overload resolution

Routines may be overloaded: several routines in one scope may share a name (any
other kind of duplicate name in one scope is a `duplicate declaration` error). A
call resolves against the set of same-named routines visible at the call site. For
a method call, the candidate set is the same-named methods on the receiver type.

Resolution is **two-phase, exact-first**:

1. **Exact.** A candidate matches exactly when it is non-variadic and every argument
   type is the identical type of the corresponding parameter. If any candidate
   matches exactly, the first such candidate (in declaration order) is chosen.
2. **Compatible.** Otherwise a candidate matches when every argument is
   assignment-compatible with its parameter (a variadic routine matches any
   argument list). The first such candidate is chosen.

There is no finer conversion-cost ranking. The exact-first rule is what makes an
integer argument select an integer overload in preference to a real one. If more
than one candidate matches within the chosen phase, the call is rejected as
ambiguous. If none matches and there is exactly one candidate, the specific argument
mismatch is reported; otherwise `no overload matches`.

A routine may **not** be overloaded on failability alone: two routines that differ
only in whether they are `fails` have the same signature for this purpose and are
rejected at declaration. The predefined I/O routines (`write`, `writeln`, `read`,
`readln`) are variadic and so match any argument list; `read` and `readln`
additionally require each argument to be an assignable designator of integer, real,
char, or string type.

## Storage layout

These are the sizes, alignments, and offsets the front end computes for a value.
All addresses are byte offsets. There **is** alignment; aggregates are not packed.

Scalar sizes and alignments:

| Type | Size | Align |
| --- | --- | --- |
| `integer`, `char`, `boolean`, `enum`, subrange | 4 | 4 |
| `single` | 4 | 4 |
| `real` | 8 | 8 |
| `int64` | 8 | 8 |
| dynamic array, `map` (a handle) | 4 | 4 |

A **set** occupies `8 x word-count` bytes, aligned to 8: a small set is one 8-byte
word, a large set two to four words. The word count is one when the base's maximum
ordinal is 63 or less, otherwise `ceil((maxOrdinal + 1) / 64)` capped at four words
(256 bits).

A **fixed array**'s size is its element size times the product of its index-range
cardinalities; its alignment is the element alignment; its element stride is the
element type's size.

A **record** lays its fields out in declaration order. Each field is placed at the
next offset that is a multiple of the field type's alignment, padding as needed. The
record's own alignment is the largest field alignment, but at least 4. The record's
size is the end of its last field, rounded up to the record alignment. A **computed
(property) field** has no storage: it occupies no offset and does not affect size or
alignment.

A **variant record** lays out the optional tag field normally, then overlays every
variant at a common offset after the tag; the record grows to the size of the widest
variant. Fields within a variant are aligned as usual.

### Handle offsets

For automatic reference counting, the compiler records the byte offset of every
handle reachable inside a value. A handle type contributes its own offset and is not
descended into (a dynamic array is one whole handle, not a walk of its elements). A
record contributes the handle offsets of each field, at the field's offset. A fixed
array contributes the handle offsets of its element type at each element position. A
set contributes none, because a set is reference-free. Each recorded handle also
carries a copy category: a plain reference is retained on copy, while a dynamic
array (other than a buffer) and a map are cloned on copy.

## Constant expressions

A constant expression is evaluated at compile time and is required at subrange
bounds, case labels, and set-constructor elements. It may contain:

- integer, real, string, and `nil` literals (a one-character string literal also
  supplies an ordinal value where a char ordinal is needed);
- `const` identifiers and enumeration members;
- the unary operators `-`, `+`, and `not`;
- the binary operators `+`, `-`, `*`, `div`, `mod`, `shl`, `shr`, `and`, `or`.

Only **integer** binary arithmetic is folded. String and real operands are not
folded in a binary expression (real literals carry a computed bit pattern but are
not combined, which keeps the single-precision tier reproducible). Integer `div` or
`mod` by zero in a constant expression is a compile error. Integer folding uses
64-bit two's-complement arithmetic and **does not check for overflow**: an
overflowing constant computation wraps.

A link-time constant (an exported constant resolved at link time) may be used in an
expression but has **no** compile-time value, so it is rejected where a true
constant is required, such as an array bound, a case label, or a subrange bound.

`__line__` is a compile-time intrinsic that evaluates to the integer source line of
its own occurrence. It is produced during parsing, not constant folding. There is no
`__file__` intrinsic.

## Scopes and name resolution

Scopes nest: a built-in system scope holds the predefined names and base types; the
program or unit top level nests inside it; routine bodies, `with` statements, nested
routines, and failure-binder scopes nest further. A name is resolved by walking
outward from the current scope and taking the first match.

Name lookup is **case-insensitive**: `Count`, `count`, and `COUNT` are one name, and
this applies to collision detection too. Redeclaring a name already present in the
**same** scope is a `duplicate declaration` error, and two names that differ only in
case collide (the sole exception is overloaded routines, which may share a name).
Redeclaring a name that exists only in an **outer** scope is allowed and shadows the
outer name; shadowing a built-in raises the warning W0004.

A `with` statement opens a scope in which the fields of the named record are visible
as unqualified names. A nested routine that reads a local of an enclosing routine is
marked as capturing; such a routine may not be taken as a bare procedural value.

Cross-unit name resolution, qualified names, and interface visibility are specified
in `kp-units.md`.

## Failability as a static property

Failability is part of a routine's signature: a routine is either `fails` or it is
not. It is deliberately excluded from signature matching for overloading, which is
why two routines cannot differ in failability alone.

A call to a `fails` routine must have its failure **consumed** at the call site. The
consuming forms are the failable suffixes (`fails`, `fails e`, `or else EXPR`,
`or else ignore`, and the diverts `or exit` / `or break` / `or continue` /
`or fail`). A `fails` call written as an ordinary expression or statement, with no
consuming form, is rejected with `unhandled failable call`. `or break` and
`or continue` are legal only inside a loop; `or fail` is legal only inside a routine
that is itself `fails`. The error binder introduced by `fails e` or by capture has
type `error`.

The result-passing convention is selected statically from the result type. A failable
routine whose result is **not wide** returns the value and the error in two registers.
A non-wide result is a 32-bit scalar: a 32-bit `integer`, a `char`, a `boolean`, an
enum, a subrange of these, or a handle (a string or other handle value). A failable
routine whose result is **wide** returns the value through a hidden caller-provided
buffer, with the error in a register. A wide result is a `real` or `single`, an
`int64`, a set (small or large), a record, or a fixed array. Note that an `int64`,
though an integer-class type, is wide and so takes the buffer path, not the two
registers. A failable method follows the same rule, with the receiver as the leading
parameter and the result buffer trailing. The convention itself is specified in
`kp-abi.md`.
