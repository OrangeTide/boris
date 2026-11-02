# Kobold-Pascal Units and Separate Compilation

This note describes the design of the unit system: how a script is split across
several source files that compile separately and link together, so game scripts can
share and link against common material instead of living in one translation unit.

> Status: implemented. `kpcom` compiles a `program` or a `unit` separately to a KPM1 module and links precompiled units through `uses`, resolved by the `-U` search path and interface fingerprints; cross-unit routines, methods, types, and exported globals link and run, `implement I for R` trait conformance is checked, and `kpbundle` packages a program with its units into one self-contained module. A single translation unit plus `{$I}` includes still works as before. The surface and rules below match what the compiler accepts; the KPM1 framework this builds on is in `kp-module-format.md`, and the grammar is in `kp-grammar.md`. The `property` feature is a separate feature, specified in `kp-property.md`; it is not required for units, though it shares object-format inlining machinery with them (see Mapping to KPM1).

## What a unit is

A source file is either a `program`, which has an entry point, or a `unit`, which is a
library of declarations that other units and programs compile against and link to. A
unit has an `interface` part and an `implementation` part:

```pascal
unit geometry;
interface
    type Vec = record x, y: real end;
    function len(const v: Vec): real;
implementation
    function len(const v: Vec): real;
    begin
        len := sqrt(v.x * v.x + v.y * v.y)
    end;
end.
```

A name is exported by appearing in the `interface` part. Its body lives in
`implementation`. Anything declared only in `implementation` is private to the unit.
This is the Borland-family split.

A unit has no `initialization` or `finalization` section. Setup is an exported routine
the program or host calls explicitly.

## Opaque types

A unit may export a record type by name only, hiding its representation. The interface
lists the name; the implementation repeats the type with its full definition:

```pascal
unit grid;
interface
    type Grid;                          { opaque: name only, fields hidden }
    function make(w, h: integer): Grid;
    procedure put(var g: Grid; x, y: integer; v: byte);
    function clone(const g: Grid): Grid;
implementation
    type Grid = record
        w, h: integer;
        cells: array of byte
    end;
    ...
end.
```

An opaque type is a value record with hidden fields, not a reference. The compiler
computes the record's size and alignment from the implementation definition and writes
them into the KPM1 interface (see [Mapping to KPM1](#mapping-to-kpm1)); the fields
themselves stay private. A consumer therefore knows how much space the value occupies and
can hold it, pass it, and assign it by value, but it cannot name or touch a field. It
reaches the contents only through the unit's routines and methods.

The size is computed, never written by hand. The definition in the
implementation is the single source of truth, and the compiler derives the size from it,
so the interface size is always correct.

Because the exposed size is baked into consumers (a value of the type sizes their stack
frames and enclosing records), it is part of the interface fingerprint: change the
record's layout and its size changes, so a consumer that allocates the type recompiles.
See [Interface fingerprinting](#interface-fingerprinting).

Assignment copies the record by value, the same as any Kobold record; there is no
reference sharing and no hidden deep copy. A deep copy that also duplicates any managed
members (a string, a dynamic array, a handle) is an ordinary routine the unit provides,
since only the unit sees the fields:

```pascal
var g, h: Grid;
g := grid.make(16, 16);
h := g;             { a value copy of the record }
h := g.clone;       { a fully independent grid, managed members duplicated }
```

There is no compiler-generated deep-copy hook for a whole record. Copying a record copies
its members by their category: a value member (a dynamic array, a nested record) is
value-copied, and a reference member (an interface or process handle, a `slice`, a `string`)
is retained. So an opaque value record whose fields are themselves values copies
independently; if a field is a reference the copy shares it, and a `clone` the unit provides
is how a caller gets a fully independent value. See the value/reference split and the
record-assignment entry in `kobold.md`.

## Exported state: var

A unit exports mutable state as a `var`. Constants are not state and are described under
Constants below. Computed, validated, or accessor-backed state is the separate `property`
feature (`kp-property.md`), which units can use once it exists but do not depend on.

An exported `var` is a plain storage cell, readable and writable from other units by
default:

```pascal
unit audio;
interface
    var volume: integer;        { read and write from other units }
implementation
    ...
end.
```

At the ABI a `var` is a data symbol: a consumer's `x := audio.volume` and `audio.volume
:= 5` compile to a direct load and store against the address resolved at link. There is
no access control on a plain `var`. When a unit wants read-only exposure, validation, or
a computed value, it uses a `property` (see `kp-property.md`) instead. Converting a `var`
to a `property` later changes the ABI (a load becomes a call), so consumers recompile;
the use-site source does not change.

### Thread-local by default, `shared` to opt out

A mutable exported `var` is thread-local by default. Today there is one execution
context, so this is only a documented guarantee with no runtime cost, but it fixes the
model before threads exist: a global is per-context unless the author opts into one
shared instance with `shared`:

```pascal
var score: integer;             { one per execution context }
shared var highScore: integer;  { a single instance across all contexts }
```

A `shared` global becomes the author's synchronization responsibility once real threads
exist. A `const` needs no such marking: it is immutable, so a single copy is always safe
to share. See [Globals: addressing and the ABI](#globals-addressing-and-the-abi) for how
the per-context model is implemented.

## Constants

An exported `const` is not state. It has no storage, no location, and no identity: it is
a name bound to a value. It has more in common with a preprocessor symbol or a linker
symbol than with a `var`, which is a cell with a reserved location. In the interface a
const lives next to exported type names and enum members, which are compile-time facts
carried as symbols in the same way, not next to `var`.

### Inline constants (the default form)

By default an exported `const` is compile-time inline. Its value is read from the
exporting unit's interface at consumer compile time and baked in, so it works everywhere
Pascal expects a compile-time constant, in array bounds, case labels, subrange types,
and other constant expressions:

```pascal
{ unit rules }
const MaxLives = 3;

{ consumer }
var lives: array[1..MaxLives] of Life;   { ok: compile-time }
case n of MaxLives: ... ;                 { ok }
```

Because the value is baked into consumers, changing an exported inline `const` requires
recompiling the units that use it, not just relinking. This is the same contract as a C
header constant or an enum member. It is made safe by
the interface fingerprint (see [Interface fingerprinting](#interface-fingerprinting)): a
consumer that baked the old value is rejected at link, not left running with a stale one.
Enum members are compile-time constants in the same way, carried with their type.

### Link-time constant symbols

A value that should change with only a relink, without recompiling consumers, is a
link-time constant symbol: the consumer emits a reference to a named const that the linker
patches to an immediate. Because its value is unknown at compile time, it cannot appear in
a constant position (an array bound, a case label, a subrange), the same boundary a property
has. It is a `const`, not a property.

The surface distinguishes it from an inline const by leaving the value out of the interface.
A unit declares a link-time const value-less in its interface, giving only its type, and
supplies the value in the implementation, the same shape an opaque type uses:

```pascal
unit config;
interface
    const Version: integer;      { link-time: a type, no value }
implementation
    const Version = 3;           { the value, resolved at link }
end.
```

Because the interface carries no value, a consumer sees only a typed name with no
compile-time value: it references the constant by address, resolved at link, and it cannot use
the name in a constant position. Changing the value and recompiling the defining unit changes
neither the name nor the type, so the interface fingerprint is unchanged and consumers relink
without recompiling. The value must be an ordinal or `int64` scalar; a string or other managed
value is not a link-time const (that waits on the flat-string work). Within the defining unit
the value is known, so the unit inlines its own uses; only cross-unit references go through the
symbol. The constant lowers to an exported read-only global, resolved through the same
exported-global table a cross-unit `var` uses. See [Mapping to KPM1](#mapping-to-kpm1).

## The uses clause

A program or unit names its dependencies in a single `uses` clause, at the top of the
file after the `unit` or `program` header. There is no separate interface-level and
implementation-level `uses`: a unit has one dependency list, private by default, and the
public surface is stated explicitly with `reexport`. This decouples what a
unit depends on from what it exposes.

Every import has a qualifier. An unqualified `uses` uses the unit's own name as the
qualifier:

```pascal
uses geometry;              { names reachable as geometry.len }
uses geometry as geo;       { qualifier shortened to geo.len }
uses geometry as _;         { no qualifier: names come in bare, len }
```

The `as` slot sets the qualifier. The identifier `_` in that slot means "no qualifier",
so exported names come into scope bare. This makes qualification explicit at every
import and gives the bare form one clear spelling rather than an implicit default.

An optional selective list narrows which names are imported and may rename them
per item:

```pascal
uses geometry (Vec, len);              { only Vec and len, qualified as geometry }
uses geometry as geo (Vec, len);       { only Vec and len, qualified as geo }
uses geometry as _ (Vec, len as glen); { bare, and len is renamed to glen }
```

Without a list, all exported names are visible under the qualifier. With a list, only
the named items are visible; a rename sets the local name (bare when the qualifier is
`_`, otherwise under the qualifier).

Idiomatically a Pascal-like unit is used bare, `uses geometry as _;`, so its names read
like the language's own, the way traditional Pascal `uses` works. This is a convention, not
a requirement, and it is not always possible: when a unit's exported name would shadow a
built-in or collide with another bare import, bring it in under a qualifier (or a selective
list that renames the offenders). `core.strings` is the standard example: its string
`Delete` and `Insert` share names with the dynamic-array built-ins, so it is used qualified
(`uses core.strings;` then `strings.Delete`) rather than `as _`.

## Re-export and cross-unit resolution

Two different questions arise when unit A's interface refers to a name from unit B, for
example a routine `A.makeThing: B.Thing`:

- **Resolution.** Can a consumer's compiler type-check `A.makeThing` and the value it
  returns? Yes, always. B is in the dependency closure, so kpcom reads B's interface to
  resolve `B.Thing`, whether or not the consumer names B. A consumer can hold and pass a
  `B.Thing` it got from A without knowing B, because the value carries its type.
- **Visibility.** Can the consumer *write* the name `B.Thing` itself, to declare a
  variable of that type or construct one? Only if B is in the consumer's own `uses`, or A
  re-exports it.

Re-export is explicit and selective. A unit promotes chosen names from a dependency into
its own public surface with `reexport`:

```pascal
unit scene;
uses geometry;
interface
    reexport geometry (Vec);          { consumers of scene can name Vec }
    function origin: Vec;
implementation
    ...
end.
```

A consumer of `scene` can now write `scene.Vec` (or `Vec` under its chosen qualifier)
without a separate `uses geometry`. Re-export is selective: a unit re-exports only the
names its own interface genuinely requires a consumer to name. Automatic resolution still
lets a consumer hold and pass a name it did not import; re-export is only about which
names the consumer may write.

## Dependency graph

The `uses` graph must be acyclic. Two units may not depend on each other, directly or
transitively. A cycle is a compile error. A DAG gives one resolution order, makes
separate compilation straightforward, and keeps the link step simple. When two units
seem to need each other, the shared declarations belong in a third unit both depend on.

## Methods across units

Methods are open. Any unit may attach a receiver method to any type it can see,
including a type imported from another unit:

```pascal
uses geometry;

{ add a method to geometry's Vec from here }
function taxicab for (const v: Vec): real;
begin
    taxicab := abs(v.x) + abs(v.y)
end;
```

A method is identified by the triple `(receiver type, method name, parameter
signature)`. Methods of the same name but different signature are distinct, so an
overload set for one `(type, name)` may span several units and is resolved by argument
type at the call site, the same as free-routine overloading.

### Definition uniqueness: the COMDAT-style fold

A definition can reach the linked program more than once. The `uses` graph is a DAG, so
a diamond is normal: unit A uses C, unit B uses C, and a program that uses A and B pulls
in C through both paths. Depending on how libraries are packaged, C's definitions may
arrive at the link once (C shipped as its own object, both A and B importing it) or twice
(A and B each a self-contained bundle that absorbed C). The fold makes both correct
without the program author choosing a packaging model.

Every definition absorbed from a used unit is foldable, in the spirit of a linker
folding COMDAT or weak symbols. A unit's own definitions are unique. The fold covers
every exported kind that can arrive twice through a dependency path, not methods alone:
routines, methods, types, and const symbols.

- Maintain a table keyed by symbol identity. For a free routine that is its qualified
  name and signature; for a method the triple `(receiver type, name, parameter
  signature)`; for a type its name; for a const its name.
- On the first definition of an identity, store it as canonical and record its source
  location and origin unit.
- On a later definition of an identity already present, compare the two. If they are
  **identical**, drop the later one and keep the canonical one. If they **differ**, it
  is an error that names both definition sites and their origin units.

Two definitions are identical when their signatures are structurally equal (the same
`SigEqual` / `SameParamType` test used for overloading) and their compiled bodies are
identical (compared by a body hash, with a full body compare on a hash match). A const
identity is identical when its type and value match. Source text is not the comparison:
whitespace and comments do not matter, the emitted code does.

In the common case the two copies of C came from the same compiler over the same source,
so they are byte-identical and the hash matches at once; the fold is cheap. The fold
earns its keep on version skew: A built against C v1 and B against C v2, whose bodies
differ, is an error that names both, not a silent choice of one.

This is order-independent by construction. Whatever order definitions are visited in,
the result is the same: one canonical body, or an error. "Keep the first" is therefore
a fold, and it is safe only because a differing redefinition is
an error rather than a silent overwrite. That invariant, **duplicate implies identical
or error**, is load-bearing. It must never relax to "take the first even if different",
which would reintroduce a silent wrong-body hazard.

Because the fold is order-independent, the check may run at whatever point in
compilation or linking is convenient. It does not require a distinct whole-program
analysis phase. A shared symbol table maintains the invariant as definitions arrive,
which is what the backend already does for host imports.

The idiom for a genuine clash follows from the DAG: if two units both need `.area` on
`Vec` and their bodies differ, move the one intended definition into a common unit both
`uses`. The identical-fold case also means the same definition reaching the table twice
through a shared dependency is harmless, not an error.

This is implemented. The module format marks an absorbed definition `from <unit>` on its
`.func` or `.global` (see `kp-module-format.md`), and the loader folds two `from`-marked
copies of a symbol that meet at link: identical folds to one, differing is a link error
naming both origin units. A module's own definitions are never folded, so two unrelated
modules keep their own same-named exports. The `kpbundle` tool is the packaging step that
produces the absorbed bundles the fold operates on.

The fold and the interface fingerprint are complementary. The fingerprint catches
interface-level skew early, when a consumer resolves against a dependency it was not
compiled against; the fold catches body-level skew at the link, when A's copy of a
definition and B's copy meet. Both enforce the same "no silent version skew" invariant at
different stages.

### Method visibility and dispatch

A method is not gated by a selective import list or a qualifier. Selective lists and
qualifiers control free names (routines, types, constants). A method stays
dot-on-receiver: a call is written `v.area`, never `geo.area(v)`. It resolves whenever
its defining unit is anywhere in the program's dependency closure. Since a method
identity has a single definition program-wide, there is no per-call ambiguity to
resolve with a qualifier.

Dispatch itself is unchanged from the single-unit language, and Kobold has no dynamic
dispatch (see the no-dynamic-dispatch entry in `kobold.md`). On a **record** receiver a
method call resolves statically to the routine that implements it, so record-method
uniqueness is a compile-time namespace fact with no runtime table. On a **handle** receiver
the call resolves at link to the host's registered method; there is one implementation per
handle type, so a shadowing script method is resolved statically and the fold rule keeps that
one canonical body. See [Methods and dispatch](kobold.md#methods-and-dispatch).

Binding a call site to the right overload needs the complete overload set for its
`(type, name)`, so call-site method binding is resolved once the method table is
complete. That naturally happens at link, the same place host imports resolve. This is
ordinary deferred resolution, not a bespoke whole-program pass. Definition uniqueness
folds incrementally; call binding resolves once, at link.

## Interface fingerprinting

Separate compilation lets a consumer be compiled against one version of a unit's
interface and then linked against a different one. Whole-program compilation cannot drift
this way; separate compilation can, so the interface carries a fingerprint and the loader
checks it. This is a required part of the design, not an optimization.

Each object `.kpm` records, for every unit it was compiled against, the fingerprint of
that unit's interface as the consumer saw it. A unit's own `.interface` records its
current fingerprint. At link the loader compares the fingerprint a consumer expects for a
dependency with the dependency's actual fingerprint. A mismatch is a diagnostic that
names the stale consumer and the dependency, never a silent link against the wrong
interface. The exact hash function and the canonical ordering of the entries it covers are
specified in `kp-module-format.md` (the fingerprint hash), so a second implementation
computes the same value.

The fingerprint covers the parts a consumer bakes in or binds to: exported routine and
method headings, exported type names and any transparent definitions, exported const
names and values (an inline const is copied into the consumer), exported `var` symbols and
their types, and any inlinable body a consumer may inline across the boundary (an inline
const value now, a small accessor body once property lands). A change a consumer cannot
observe, for example a private implementation-only routine or an unexported helper, does
not change the fingerprint and does not force a relink.

This is the safety mechanism behind the inline-const contract: an exported inline `const`
that changes value changes the fingerprint, so a consumer that baked the old value is
rejected at link rather than running with a stale number. It also bounds incremental
rebuilds: a consumer must recompile only when a dependency's fingerprint changes, not on
every private edit.

## Mapping to KPM1

A unit compiles to a KPM1 `object` module: `.module object`, with unresolved imports for
the units it uses. Its `.interface` section carries:

- exported routine and method headings (bodies go in the `functions` section);
- exported type names: a transparent type carries its full definition; an opaque record
  type carries its compiler-computed size and alignment but not its fields, so a consumer
  can allocate and value-copy it without seeing the layout;
- exported constants: an inline `const` as a symbol with its value (`.const <name> <type>
  <value>`), since it is compile-time and a consumer bakes the value in; a link-time const
  value-less (`.const <name> <type>`), its value carried instead by an exported read-only
  global outside the interface (so it is not in the fingerprint), which the consumer references
  by address through the exported-global table, exactly like a cross-unit `var`;
- exported `var` symbols, as data symbols with a type and a `shared` flag;
- the interface fingerprint (see [Interface fingerprinting](#interface-fingerprinting)),
  plus, per dependency, the fingerprint the unit was compiled against;
- exported `property` entries once the `property` feature lands, each carrying its
  accessor symbols and, where the accessor is small, an inlinable body; until then the
  interface has no property entries (see `kp-property.md`).

A consumer type-checks against the `.interface` alone and records the fingerprint it saw
for each dependency. The linker reads the `functions` bodies to fold definitions and to
resolve calls and data symbols.

The interface can carry inlinable bodies, not only signatures. An exported inline `const`
already puts its value in the interface for the consumer to bake in; the same mechanism
generalizes to small routine bodies, so a trivial accessor can be inlined across the unit
boundary. This is the object-format hook that lets a `property` read lower to look like a
plain `var` access instead of a call (see `kp-property.md`). An inlined body is consumer-observable, so it is
part of the interface fingerprint, exactly like an inline const value: change the body and
the consumers that inlined it must recompile.

A program compiles to a KPM1 `executable` module: `.module executable` with `.entry
main`. See `kp-module-format.md` for the module kinds and the interface section that
`kpcom` produces and the loader consumes.

For good diagnostics, an exported method heading in the `.interface` records its
defining unit and source location, so the fold rule can point at both sites when two
definitions clash.

## Compilation and linking model

Linking happens in the backend, at load. The split is:

- **Compile against interfaces.** kpcom compiles one unit at a time. It reads the
  `.interface` sections of the units in the dependency closure to resolve and type-check,
  and it does not need their `functions` bodies. It records the fingerprint it saw for
  each dependency and emits an `object` `.kpm` for the unit.
- **Link objects at load.** The backend loads a set of `object` `.kpm` modules and links
  them into a runnable form: it checks each consumer's expected dependency fingerprints,
  folds definitions, resolves call sites and data symbols across modules, binds dispatch,
  and lays out globals. This reuses the load/link and symbol-table machinery that already
  resolves host imports.

So a `.kpm` is read at two stages: by kpcom for its interface when compiling a dependent
unit, and by the backend for its bodies when linking a runnable set. This is what makes a
precompiled `library` `.kpm` usable by a third party with no source, and it is why the
`library` and `executable` module kinds in `kp-module-format.md` pay off. The method fold
rule keeps the backend's new guest-to-guest resolution cheap, because it is an insert
into the existing symbol table (see [the fold rule](#definition-uniqueness-the-comdat-style-fold)).

### Building and running a unit set

The runner links the set. It loads a program `.kpm`, reads its `.uses` list, and loads
each dependency `.kpm` by name from the program's directory, following each dependency's own
`.uses` so a transitive unit is loaded once. It then links and runs the whole set in one
`kp_link`. An embedding host does the same through the public API: `kp_module_dep_count` and
`kp_module_dep_name` walk a loaded module's dependencies, and `kp_module_name` tells which
units are already loaded. There is no separate build tool. The compile step is
`kpcom --emit-kpm -U<dir>` per unit, and the recompile-only-on-interface-change property is a
build-system concern: extract each object's `.interface fingerprint` to a stamp file rewritten
only when it changes, and make a consumer depend on that stamp rather than the dependency's
whole `.kpm`. `examples/units` is a worked Makefile that does exactly this, and it doubles as
the end-to-end multi-unit test in `make check`.

The alternative packaging model is a self-contained bundle. `kpbundle <out> <program> <unit>...`
absorbs the units into the program module, dropping their `.uses`/`.interface` and tagging each
absorbed definition `from <unit>`, so the bundle runs on its own with no unit files beside it.
Two bundles that each absorbed the same unit fold that unit's definitions at link (see the fold
above). The `examples/units` Makefile builds and runs both the object set and the bundle.

### The unit search path

A unit is found by name at two stages, and both stages search the same order: explicit
directories first, then the installed standard library.

- **Compile time.** `kpcom` resolves each `uses` name to an interface `.kpm` by searching, in
  order, the directory of the source being compiled, every `-U<dir>` given on the command
  line, then a directory baked in at build time (the install location,
  `$(PREFIX)/lib/kobold`). A flat name is tried as `<dir>/<name>.kpm` and then its lowercased
  form; a dotted name maps its dots to path separators, so `io.files` is tried as
  `<dir>/io/files.kpm` (and the lowercased fallback). A wildcard `io.*` lists the `<dir>/io/`
  directory for its `.kpm` members (one level); the namespace is read from every search
  directory in that same order, each unit taken from the first directory that has it (as a
  single `uses` would), and the members are sorted so the resulting dependency list is
  deterministic regardless of the directory's own order.
- **Run time.** The runner resolves each dependency in the `.uses` list by searching, in order,
  the main module's own directory, every colon-separated entry of the `KOBOLD_UNITS`
  environment variable, then the same baked-in standard library directory. A dotted dependency
  maps its dots to path separators the same way; a wildcard has already been expanded to
  concrete dependency names at compile time, so the runtime sees no `*`. An embedding host
  that walks dependencies with `kp_module_dep_name` chooses its own lookup.

So a program that `uses strings` compiles and runs with no flags once the library is installed,
builds against a local copy with `-Ubuild/lib`, and runs against a local copy with
`KOBOLD_UNITS=build/lib`. The lowercase fallback keeps a `uses Strings` working on a
case-sensitive filesystem where the file is `strings.kpm`.

### Namespaces and the standard-library tiers

A unit name is dotted. The segments before the last are a namespace and the last segment is the
unit, which is also its default qualifier: `uses io.files;` brings the unit in as `files` (so
`files.ReadFile`), exactly as a flat `uses files;` would. A flat name is a unit in the root
namespace; dotting is how the library is organized as it grows, not a new mechanism (the
qualifier model, selective lists, and `as` are unchanged, and the last segment is what `as` and
the default qualifier act on).

The leading namespace is a portability and category contract, read at a glance:

- `core`: pure, needs no host; available on every tier (hosted, JIT, sandbox, bare metal).
- `io`: input and output (console, files, directories); available wherever the target has
  that I/O seam.
- `std`: needs an operating system or host service; available everywhere except bare metal.
- `experimental`: unstable, for trying things out; no stability promise.
- `kobold`: units about the toolchain itself (host-side developer tools).

The tier is **organizational for now**: the compiler maps the namespace to a directory and
nothing yet stops a bare-metal build from using a `std` unit. Enforcement, where a build target
declares the tiers it provides and a higher-tier `uses` is a compile or link error, is a later
addition once targets carry that capability; the taxonomy is chosen now so units land in the
right place from the start. A program organizes its own units the same way under its own
namespace (`scene.actors`); only the five names above are reserved for the library.

**Wildcard import.** `uses io.*` imports every unit directly in a namespace, one level deep (it
does not reach `io.net.*`), each under its own last-segment qualifier, so it is shorthand for
naming them individually; `as` and a selective list do not apply to it. A wildcard depends on
the namespace's membership at compile time: adding a unit to `io` adds it to every `io.*`
consumer and widens their dependency set and fingerprint, so a wildcard suits a program that
wants the whole category, not the default way to depend on one unit.

### The standard library

The standard library is a set of ordinary units installed under `$(PREFIX)/lib/kobold`, both as
source (`.pas`) and as a precompiled interface (`.kpm`), laid out by namespace (`core/`, `io/`,
`std/`, ...). It uses no privileged mechanism: a standard-library unit is found and linked
exactly like any other unit on the search path, and a program could supply its own unit of the
same name ahead of it with `-U` or `KOBOLD_UNITS`.

The units, by tier:

- `io.files`: whole-file (`ReadFile`/`WriteFile`) and handle (`Open`/`Create`/`ReadLine`/
  `ReadChar`/`WriteLine`/`Close`) text I/O, plus the file-metadata and path operations: `Exists`,
  `FileSize` (an `Int64`), `IsDir`, `DeleteFile`, `RenameFile`, `MakeDir`, `RemoveDir`. Each
  metadata/path call is a thin wrapper over an external cdecl into the runtime, which reaches
  the host through the libc `stat`/`fileops` helpers (statx and the `*at` syscall forms on the
  freestanding tier). `FileSize` and the predicates return a sentinel on a missing path
  (`-1` size, `false` predicate) rather than failing.
- `io.textfile`: the classic ISO/Turbo Pascal text-file verbs over a `TextFile` value, for
  programs that want the familiar idiom rather than `io.files`'s own surface: `Assign` binds a
  name, `Reset` opens it for reading and `Rewrite` creates it for writing, then `Read` takes one
  raw character, `ReadLn` a whole line, and `Write`/`WriteLn` output; `Eof` and `Eoln` are the
  look-ahead end-of-file and end-of-line tests (so `while not Eof(f) do Read(f, c)` visits each
  character once, true before the first `Read` on an empty file), and `CloseFile` finishes. It is
  a thin shim over `io.files`, reading through its `ReadChar` with one character of look-ahead, so
  the descriptors, buffering, and the `kpf_` seam stay single-sourced there. The dialect has no
  `IOResult`, so `Reset`/`Rewrite` record the open outcome and `IOOk` reports it. The verbs are
  reached through the `textfile` qualifier, since `Read`/`Write`/`ReadLn`/`WriteLn` also name
  console builtins.
- `io.dirs`: directory enumeration.
- `io.console`: the standard input and output as typed functions: `Eof` (the sticky
  end-of-input latch), `ReadLine`/`ReadChar`, `WriteStr`/`WriteLine`/`WriteChar`, and the real
  surface `ReadReal`/`WriteReal` (`ReadReal` skips whitespace and reads one real token,
  `WriteReal` prints it in the write statement's `%g` shape). A real crosses the unit cdecl FFI
  the same way the write/read builtins' `io_*_real` path does: in a float register on ColdFire,
  as its 64-bit bits in an integer register pair on the rv32 soft-float tier, so it needs no
  bridge. `ReadInt`/`WriteInt` are the integer surface: `ReadInt` skips whitespace and reads one
  signed decimal token, returning an `Int64` (the same 64-bit cdecl return as `std.time`'s `Now`,
  so endian-safe on both tiers); `WriteInt` prints a 32-bit `Integer`. A non-numeric input reads
  as zero (this tier's lenient scan); a status-returning `Val` surface is a later design pass.
- `io.buffered`: buffered streams over any descriptor, written entirely in Kobold on the raw
  fd seam (`io_write_str`/`kpf_read`). A `BufWriter` (`OpenWriter`/`PutStr`/`PutChar`/`Flush`)
  batches a run of small writes into one `write` per bufferful or per `Flush`; a `BufReader`
  (`OpenReader`/`GetChar`/`UngetStr`/`ReadLine`/`Eof`) pulls host chunks and serves bytes and
  lines, with an arbitrary-length `UngetStr` pushback. The runtime keeps only the one byte of
  input pushback its own numeric and line reads need; this unit is where larger buffering, output
  batching, and a general ungetc live, as the design intends (a stream owns its descriptor, so a
  program does not mix it with the console builtins or a second stream on the same fd).
- `std.time`: `Now` (monotonic milliseconds) and `Sleep(ms)`, over the host clock and the
  park seam. A give-up-the-turn yield is `Pause` in `std.threads`; `Sleep(0)` also parks the
  turn at the host.
- `std.threads`: cooperative threads, the Kobold parallel of the C `<threads.h>` subset
  (`include/threads.h`). It is pure Kobold with no runtime glue: it rides the language's own
  `start` / `yield` / `process` / `release` coroutine primitive, so it works on every tier that
  has coroutines. `Ready(start worker(a, b))` enqueues a started task, `RunAll` round-robins the
  queue until every task finishes. Inside a task, `Pause` gives up the turn (the C `thrd_yield`)
  and `Finish` is the task's final act (the C thread return): a Kobold coroutine cannot report
  its own completion, and resuming one that has run off its end traps, so `Finish` yields the
  stable done marker `RunAll` stops on. A task that returns without `Finish` is a usage error.
  `Mutex` and `Condition` are the cooperative forms: with no preemption a critical section is
  uncontended unless it spans a `Pause`, so `Lock` spins on `Pause` until free and `Wait` pauses
  until the next `Signal` (a broadcast). The caller hands the unit a `process` value, since a
  yielding routine cannot be passed as a value and so cannot be spawned from inside the unit.
- `std.random`: `SeedRandom`, `Randomize` (seed from host entropy), `RandomBelow` and
  `RandomReal` (a uniform real in [0, 1)) over the fast generator, and `SecureRandom(bound)`
  over the ChaCha20 CSPRNG (seeded once from host entropy, rejection-sampled to stay unbiased).
  It needs host entropy, hence `std`. `RandomReal` crosses the cdecl FFI as a real the same
  way `io.console`'s `ReadReal` does, no bridge. A pure, seed-only `core.random` subset usable
  on bare metal is a later addition.
- `core.strings`: pure string helpers built over the string builtins with no runtime
  primitive of its own, so it works on every tier (hence `core`): `UpperCase`/`LowerCase`
  (ASCII), `Trim`/`TrimLeft`/`TrimRight`, `StringReplace`, and a non-mutating string
  `Delete`/`Insert`. Reached qualified as `strings.Delete` so it does not shadow the
  dynamic-array built-ins of the same name.
- `core.convert`: the failable face of the classic `Val(s, v, code)` builtin: `ValInt(s):
  Int64 fails` and `ValReal(s): real fails`. A console read is lenient (a non-numeric token
  reads as zero), so a program that needs to know whether the text was a number reads it as a
  string and converts here, catching a bad token with `or else` or `fails`: `n := ValInt(line)
  or else 0`, or `if ValReal(line) fails then ...`. On failure the error code is the 1-based
  position `Val` reports. `Val` is strict (no whitespace skipping), so `Trim` padded input
  first. Built over the `Val` and `fail` builtins, so it carries no runtime primitive and works
  on every tier.

These units wrap runtime glue (`kp_random_*`, `kp_now_ms`, `kp_sleep_ms`, the console
`io_eof`/`io_read_str`/`io_read_char`/`io_write_str`/`io_write_char`,
the `kpf_*` file primitives) declared `external cdecl` in each unit's implementation, so the compiler core carries no knowledge of them and no
builtin grows (see the units-over-builtins direction in `kobold.md`).

What stays a builtin. An operation moves into a unit when it is an ordinary call: a concrete
(non-generic) signature, reached through `external cdecl` glue or written in Kobold itself.
An operation that the compiler must specialize per call stays a builtin. The array `insert`
and `delete` (and `delete(map, key)`) are the clear case: they are generic over `array of T`,
and the compiler passes the element's size and its managed-field layout to the runtime so it
can zero new slots and release removed handles. A unit would need parametric generics (which
Kobold does not have) and a way to obtain that layout for an arbitrary `T`, so these remain
compiler builtins. This is why `core.strings` can carry a string `Delete`/`Insert` but the
array ones cannot: `string` is one concrete, immutable type, so its helpers are an ordinary
unit; the array operations are generic, mutate a designator by reference, and depend on the
element layout.

## Globals: addressing and the ABI

Exported globals are addressed base-relative, not by absolute address. Each module has a
globals frame; a global access is `[base + offset]`, where the offset is a constant fixed
at compile time within the module and the base is provided at load. There are two frame
classes:

- a **per-context** frame for thread-local globals (the default), reached through a
  per-context base the loader supplies;
- a **shared** frame for `shared` globals, reached through one process-wide base.

This choice is not only about future threads. Because each access offset is a
compile-time constant relative to its frame, a cross-module global reference needs no
load-time relocation, unlike an absolute address that is unknown until load. The loader
sets one base per frame instead of patching every access site, so modules are cleanly
relocatable, which suits the load-time backend linking above. Thread-local then costs
nothing extra later: each execution context gets its own per-context base, and `shared`
globals keep their single frame. Whether the base lives in a pinned register or is loaded
on demand in functions that touch globals is an emitter detail, deferred.

## Future directions

- **A cell as a first-class value.** Shared mutable state that wants identity
  and, later, synchronization could be modeled as a `ref`/cell handle created and passed
  around, built on the existing handle and ARC machinery with no new object-format work.
  This is the Rust `Arc<Mutex>` or Clojure atom shape. It is less "looks like a global"
  than an exported `var`, but it is the honest home for genuinely shared, synchronized
  state.
- **Exporting a `property` across a unit interface.** The `property` feature itself
  (uniform-access, accessor-backed, and computed values, including computed record
  fields) is implemented and specified in `kp-property.md`; a unit can use it today and
  does not require it. What is not yet built is placing a property in a unit's exported
  interface, which needs the interface to carry the accessor binding so the consumer can
  inline across the unit boundary.

## Open questions

- **Whether `kpcom` itself is ever split into units.** The compiler is a single Pascal
  file today, and the self-hosting fixed point does not depend on units.

## See also

- `kp-grammar.md` the concrete syntax for units and the `uses` clause.
- `kp-property.md` the property / uniform-access feature.
- `kp-module-format.md` the KPM1 module kinds and interface section.
- `kobold.md` the language and runtime design.
- `kp-conformance.md` where units sit against the Pascal standards and dialects.
