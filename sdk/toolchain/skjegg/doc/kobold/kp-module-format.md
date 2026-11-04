# Kobold-Pascal Module Format (KPM1)

A KPM1 module is the serialized IR that passes from the Kobold front end (Pascal)
to the VM backend (C). It is the interface between the two halves, and the unit a
host ships when a program is built ahead of time. See `kobold.md` for how it
fits the pipeline.

This document specifies **format version 1**. It is a work in progress; anything
here can change while the project is pre-1.0.

## Role and scope

The module carries a Skjegg `ir_program` (functions and globals) plus the
Kobold-specific tables the backend and host need: imports, exports, and host type
declarations. It carries what the front end produces and nothing the backend
recomputes.

- **Serialized:** the fields the front end sets on `ir_func`, `ir_insn`, and
  `ir_global` (see `ir.md`), plus the import/export/type tables.
- **Not serialized:** register-allocation results (`temp_reg`, `temp_spill`,
  `nspills`, `nfspills`, `ni64spills`). The backend runs `regalloc()` after
  loading, so these are recomputed, never stored.

How host method dispatch, handle lifetime, string operations, and the coroutine
runtime are actually called is an ABI concern specified separately (`kp-abi.md`).
This format only needs to *name* those things through imports and
the well-known symbols the IR references; it does not fix their calling details.

## Form

Version 1 is a **text**, line-oriented format. A compact binary form may be
defined later as version 2; the header version distinguishes them.

Lexical rules:

- ASCII, UTF-8 compatible. Lines end in LF; a trailing CR is tolerated.
- Tokens are separated by spaces or tabs. Leading and trailing whitespace on a
  line is ignored.
- A `;` that begins a token starts a comment running to end of line. Blank lines
  and comment-only lines are ignored.
- Keywords and mnemonics are case-insensitive; **symbol names are
  case-sensitive** (they name host imports and exports).
- Integers are decimal, optionally signed; `imm` may also be `0x`-prefixed hex.
- A symbol name is `[A-Za-z_][A-Za-z0-9_.$#]*`. The characters `.` `#` `$` let the
  front end mangle names (for example `Entity.move`) without clashing with source
  identifiers.

## Overall structure

A module is a header followed by sections, in this order:

```
header
imports
exports
globals
functions
```

Each section is optional except the header. Within `globals` and `functions`,
entries appear in the order the backend should see them; the front end preserves
declaration order. This section set is not closed: the format reserves a framework for
further sections (a module kind, an entry point, an interface for precompiled units) and
for skipping unknown ones, described under [Module kinds and the section
framework](#module-kinds-and-the-section-framework).

## Header

```
.kpm 1
.target x86-64
```

- `.kpm <version>` is required and must be the first non-comment line. Version `1`
  is this document. A backend rejects a version it does not implement.
- `.target <class>` is the module's pointer-width class, and it is authoritative,
  not a hint: `ilp32` for the 32-bit targets (rv32, ColdFire, MIPS) and `lp64` for
  the 64-bit ones (x86-64, arm64). A KPM1 module is **not** architecture-agnostic.
  Its opcodes bake in the guest pointer width (the `*64` family and the `ptr`
  global flag below are chosen by width), so a module and the backend that loads
  it must agree. The reader rejects a module of the other class with a clear
  pointer-width-mismatch error rather than silently truncating a 64-bit handle to
  32 bits. A legacy value (`agnostic`) or a bare arch name is left unchecked, so an
  older module or a hand-written reader fixture still loads. The integer core,
  control flow, and the rest of the IR are width-independent; only the pointer and
  `int64` opcodes differ, which is why one front end emits both widths from one
  source (gcc `-m32`/`-m64` style).
- `.file "<path>"` is an optional debug hint, written when the front end is run
  with `-g`. It names the source file for the module's address-to-line table (the
  `LOC` opcode below), so a trap can report where it came from. Absent, traps carry
  no source location.

## Imports

Each import is one thing the host must provide before the module runs. The backend
resolves `sym` references in the IR against this table; a `sym` not found here
names a module-internal function or global instead.

```
.import func   <name> ( <class>* ) -> <class>
.import type   <name> methods <n>
    .method <index> <mname> ( <class>* ) -> <class>
    ...
.import helper <name> ( <class>* ) -> <class>
```

- `func` is a host function called directly (a script `external` routine, or a
  built-in output routine bound to a host import). The signature gives arity and
  ABI classes so the loader can bind and call it.
- `type` declares a host handle (interface) type and its methods, in interface (slot)
  order. The `<index>` is the method's slot. The backend uses this to lower and, at
  link, resolve handle method calls to a direct call; the mechanism lives in
  `kp-abi.md`. A method call in the IR references the symbol `<name>.<mname>`. A
  module-internal function of that same name shadows the host-registered method: to
  resolve `<name>.<mname>`, a `.func` of that name in this module (a script method)
  wins over the imported method. This is how a script method overrides a host method,
  and how a script method added to a handle type is reached. The receiver is argument 0 of the call in both cases: a
  host method takes the receiver handle id, a script method takes the same id (a
  handle receiver is passed by value).
- `helper` is a runtime entry the compiler relies on (handle retain/release,
  the string helpers `str_new`/`str_concat`/`str_len`/`str_base`/`str_setchar`/`str_setlen`
  (the guest reads a character inline through the base with an `LB`; `str_setchar` and
  `str_setlen` carry out the copy-on-write mutation and return an owned reference) and the
  string query and conversion helpers
  `str_from_int`/`str_val_int`/`str_val_real`/`str_valcode`/`str_pos`/`str_copy` behind the
  Str, Val, Pos, and Copy builtins, the dynamic-array helpers
  `arr_len`/`arr_base`/`arr_setlen` (the guest indexes the storage directly through the
  base; `arr_setlen` also takes the element size and a guest address of a handle-field
  layout map, a count followed by that many byte offsets, so the runtime releases an
  element's contained handles on shrink and reclaim), the coroutine helpers
  `co_new`/`co_resume`/`co_yield`/`co_self`/`co_cancelling`). Listing them as imports
  keeps the host obligations explicit and inspectable. (`co_drop` is the reclaimer the
  handle table runs, not a helper the module imports.)

**Classes** are ABI value classes, not Pascal types:

| Token   | Meaning                                                       |
|---------|---------------------------------------------------------------|
| `void`  | no value (result only)                                        |
| `int`   | integer-class: `integer` and ordinals, `boolean`, `char`, a handle id, a small set |
| `float` | `real` (f64)                                                  |

Structured values passed or returned by value (records, arrays, large sets) are
not part of version 1's import signatures; they are added with the psABI fields
(see Functions) when needed.

## Exports

```
.export <name>
```

Each names a module function the host may call by name after loading. Order is not
significant.

## Globals

One entry per `ir_global`. Mirrors the front-end-set fields.

```
.global <name> <base_type> [array <n>] [align <a>] [local] [ptr] [export] [rodata] [from <unit>]
    <initializer lines>
.endglobal
```

- `<base_type>` is one of `i8 i16 i32 i64 f32 f64` (the `IR_I*/IR_F*` base types).
- `array <n>` gives the element count (`arr_size`); omit for a scalar.
- `align <a>` sets a required alignment; omit for the base-type default.
- `local` marks a file-local (static) global; omit for a program global.
- `ptr` marks a pointer-sized element (`is_ptr`).
- `export` marks a unit's exported `var`, visible to other modules at link. A
  consumer references it by a bare `LEA <name>`; the loader lays out every module's
  data before emitting code and resolves such a reference to the defining module's
  global. Only `export` globals are cross-module-visible, so a module's private
  globals (string literals, const arrays, non-exported vars) never collide by name.
- `rodata` marks an immutable global: a string literal, the real constant pool, or a
  constant. A backend lays the global in a read-only region, so a stray write faults instead
  of corrupting the value. The x86-64, aarch64, and rv32 JITs enforce it with a
  `mprotect(PROT_READ)` region. The emulator image (`kpelf`) places read-only globals in a
  separate `PF_R` ELF segment the emulator maps read-only, unless `kpelf --no-rodata` folds
  them back into the read-write data segment for a bare target without memory protection. A
  written-at-startup global such as a `const` string or record array (filled with freshly
  built handles) is not marked `rodata`.
- `from <unit>` marks a global absorbed from that unit into a self-contained bundle
  (see the fold note below); omit for a module's own global.

Initializers use one of two forms, matching `ir_global`:

- A string blob:

  ```
  .string "….escaped…"
  ```

  sets `init_string`/`init_strlen`. Bytes are written with C-style escapes
  (`\n`, `\t`, `\"`, `\\`, `\xHH`).

- Element initializers, in order, up to `init_count` (the rest zero-fill):

  ```
  .init <ival>            ; one integer element (init_ivals)
  .init sym <name>        ; a 4-byte address of a symbol (init_syms)
  ```

  For a float base type (`f32`/`f64`), `.init <ival>` carries the raw
  IEEE-754 bit image of the element as an integer, not a decimal literal.
  The backend writes the low `sizeof(base_type)` bytes of the value. So an
  `f64` global initialized to `2.0` is emitted as `.init 4611686018427387904`
  (`0x4000000000000000`). This is how the front end lowers real constants: a
  `_real<n>` constant-pool global with its f64 bit pattern.

  For an aggregate byte image (`ir_init` chunks), each chunk is:

  ```
  .chunk <offset> <size> <ival>
  .chunk <offset> 4 sym <name>
  ```

  where `<size>` is 1, 2, 4, or 8. Chunks are in ascending offset order; the
  backend zero-pads between them and to the global's full size.

## Functions

One entry per `ir_func`, from `.func` to `.endfunc`.

```
.func <name> [local] [from <unit>] [variadic] params <np> slots <ns> temps <nt> labels <nl>
    .slotsize <s0> <s1> … <s(ns-1)>
    .paramclass <c0> … <c(np-1)>        ; 0 = int/pointer, 1 = float
    ; optional psABI hints, omitted unless struct-by-value is in play:
    .paramneb  <…>                      ; register slots per param
    .paramcls  <…>                      ; class of each register slot
    .paramfw   <…>                      ; single-precision flag per param
    .retneb    <n>
    .retcls    <c0> <c1> <c2> <c3>
    <instruction lines>
.endfunc
```

Header counts map directly to `ir_func`: `params`=`nparams`, `slots`=`nslots`,
`temps`=`ntemps`, `labels`=`nlabels`. Slots `0..np-1` are parameters, `np..ns-1`
are locals. `.slotsize` lists all `ns` slot sizes in bytes. `.paramclass` lists
the `np` integer/float classes used by the register calling convention.

The psABI lines are present only when the front end needs struct-by-value ABI
classification; for version 1's scalar-only FFI they are omitted, and the backend
treats a scalar as one register slot.

`from <unit>` marks a function absorbed from that unit into a self-contained bundle;
omit it for a module's own definition. See the fold below.

### Definition folding (COMDAT-style)

A self-contained bundle absorbs the definitions of the units it uses, each marked
`from <unit>` on its `.func` or `.global`. When two modules are linked together and both
carry a definition of the same exported symbol where at least one is `from`-marked, the
loader folds them: it keeps one canonical copy when the definitions are identical (same
signature, frame, and body, compared over the parsed IR, not the source text), and reports
a link error naming both origin units when they differ. This is how a definition that
reaches the link twice through a shared dependency (two bundles that each absorbed the same
unit) stays correct, in the spirit of a linker folding COMDAT or weak symbols. Two modules'
own same-named exports (neither `from`-marked, for example two executables each with `main`)
are left distinct, not folded. See `kp-units.md`, "Definition uniqueness".

### Instructions

One instruction per line: a Skjegg opcode mnemonic (the `IR_*` name without the
`IR_` prefix) followed by only the operand fields that opcode uses, each as
`key=value`. Unlisted fields default to `-1` (or empty for `sym`), exactly as
`ir_emit` initializes them.

```
<OP> [dst=<t>] [a=<t>] [b=<t>] [imm=<n>] [slot=<s>] [label=<L>] [sym=<name>] [nargs=<n>]
```

- `dst`, `a`, `b` are temp numbers (`0..ntemps-1`).
- `slot` is a local-slot index, `label` a label index (`0..nlabels-1`).
- `imm` is an immediate integer; `sym` a symbol name; `nargs` a call arity.

The operand set for each opcode is the one in `ir.md`; the serializer writes
exactly those fields, and the reader fills an `ir_insn` from them. `ir.md` is
the reference for opcode semantics.

**Version 1 opcode subset.** The reader accepts any `IR_*` mnemonic, but the
front end emits only what the language needs. The emitted opcodes:

- constants and moves: `LIC`, `LEA`, `ADL`, `MOV`
- integer arithmetic and bitwise: `ADD SUB MUL DIVS DIVU MODS MODU AND OR XOR SHL SHRS SHRU NEG NOT`
- integer compare: `CMPEQ CMPNE CMPLTS CMPLES CMPGTS CMPGES CMPLTU CMPLEU CMPGTU CMPGEU`
- memory and slots: `LB LBS LH LHS LW SB SH SW LDL STL ALLOCA`
- control flow: `JMP BZ BNZ LABEL`
- calls and returns: `ARG CALL CALLI RET RETV`
- markers: `FUNC ENDF` (implied by `.func`/`.endfunc`; not written in the stream)
- `real` (f64): `FADD FSUB FMUL FDIV FNEG FABS FCMPEQ FCMPLT FCMPLE ITOF FTOI`
  and the f64 loads, stores, args, and returns (`FLS FLD FSS FSD FLDL FSTL FRETV
  FCALL FCALLI`)
- 64-bit (`*64`): the `LIC64`/`ADD64`/… family, used for `set` values (an i64
  bitmask) and any i64 temp

The front end lowers the whole language, so the memory, real, 64-bit, and
call opcodes above are all emitted.

**Overflow, debug, and failable opcodes.** These are part of the shared Skjegg IR
(the `ir.h` opcode enum, not a layered Kobold-only set), and `ir.md` specifies them
with the rest. The ones the Kobold front end emits beyond the plain integer, memory,
real, 64-bit, and call opcodes are:

- `ADDO SUBO MULO`: checked add, subtract, and multiply. The front end emits them
  under `{$Q+}`; the JIT traps `OVERFLOW` on signed 32-bit overflow.
- `LOC imm=<line>`: a source-line marker the front end emits under `-g`. It produces
  no code; the JIT records it in the module's address-to-line table.
- `CALL2 CALLI2 RETV2`: the two-register failable call and return forms. A `fails`
  routine with an ordinal-class result returns its value and the error signal in two
  registers (`RETV2`); a failable call delivers the value in `dst` and stores the
  error signal into the given `slot` (`CALL2`/`CALLI2`). The failable error model is
  in `kp-errors.md` and the ABI in `kp-abi.md`.

Coroutines add no opcodes: `start`/`yield`/`bind`/resume/`release` lower to ordinary
`CALL`/`CALLI` to the coroutine runtime helpers (`kp-abi.md`), so the reader needs no
coroutine opcodes. `MARK`/`CAPTURE`/`RESUME` from the Skjegg IR are accepted by
the reader but the Kobold front end does not emit them.

## Worked example

Source:

```pascal
program hello;
procedure printInt(n: integer); external;
begin
  printInt(2 + 3);
end.
```

Module:

```
.kpm 1
.target x86-64

.import func printInt ( int ) -> void

.export main

.func main params 0 slots 0 temps 3 labels 0
    LIC   dst=0 imm=2
    LIC   dst=1 imm=3
    ADD   dst=2 a=0 b=1
    ARG   a=2
    CALL  sym=printInt nargs=1
    RET
.endfunc
```

The backend reads this, runs `regalloc()` on `main`, JITs it, resolves `printInt`
to the host function the embedder registered under that name, and calls `main`.

## What the reader must do

1. Parse the header; reject an unknown version.
2. Build the import, export, and type tables.
3. Build `ir_global` and `ir_func` structures, filling only front-end fields.
4. Leave regalloc fields unset; the backend calls `regalloc()` per function.
5. Resolve each `sym` against imports (host) or the module's own functions and
   globals; report an import the host did not register.

## Versioning

The header version gates the whole format. Version 1 is this text form. A later
version may change the encoding (for example a binary form) or extend the tables;
a backend refuses a version it does not implement, and the front end writes the
lowest version that expresses the program.

Format growth within version 1 rides the reserved section framework below and the
extension opcodes (for example `LOC`, `ADDO`), neither of which needs a version bump,
so version 1 has room to grow without a version 2.

## Module kinds and the section framework

Version 1 fixes the sections above (`imports`, `exports`, `globals`, `functions`) and
its loader is strict: an unrecognized top-level section or directive is an error. To let
the format grow toward a full unit and image format without a version bump per feature,
the following framework is reserved. It is mostly a direction to fill in as features
arrive; only the parts a milestone needs are implemented, and until then the strict
version 1 loader stands. `.module`, `.entry`, and `.interface` are now accepted (the units
implementation emits them); `.section` below remains reserved and not yet accepted by the loader.

**Module kind.** A `.module <kind>` header line names what the file is:

| Kind         | Meaning                                                              |
|--------------|---------------------------------------------------------------------|
| `object`     | a compiled unit with unresolved imports, for later linking (default) |
| `library`    | a loadable library: exports resolved symbols, may still import host entries |
| `executable` | a fully linked image with an entry point, ready to run              |

Absent, a module is an `object`. A backend handed a kind it cannot use rejects it. The
reader accepts all three kinds and rejects an unknown one; kpcom emits `.module
executable` for a compiled program and `.module object <name>` for a compiled unit. An
object module names its own unit after the kind, so the linker matches a consumer's `.uses`
against it for the fingerprint check below. An executable carries no such name.

**Entry point.** An `executable` names its start routine with a header line:

```
.entry <name>
```

It is the routine the runtime calls to run the image, distinct from `exports`, which
name routines a host may call by name. A non-executable module has no `.entry`.

**Dependencies.** A module that was compiled against other units names each direct
dependency and the interface fingerprint it saw for that dependency with a header line:

```
.uses <name> fingerprint <n>
```

A link traverses these to build the dependency closure and rejects a dependency whose
actual interface fingerprint differs from the one recorded here (a stale consumer). The
loader enforces this: it matches each `.uses <name>` against the loaded object module of
that name (from its `.module object <name>` header) and errors when the recorded fingerprint
differs from that module's own `.interface fingerprint`, or when no module of that name is
loaded.

**Link-time constants.** A unit that exports a link-time constant (a value-less `const` in the
interface, valued in the implementation) emits it as an exported read-only global holding the
value: an ordinary `.global <name> <type> export` with an `.init` line, exactly like an exported
`var` except the compiler never writes it. Its value lives in the global, outside the
`.interface` section, so it is not part of the interface fingerprint and a change forces a
relink rather than a consumer recompile. A consumer references it by address (`LEA sym=<name>`
plus a load), resolved through the same exported-global table a cross-unit `var` uses; the
defining unit inlines its own uses. See `kp-units.md` for the source surface.

**Interface section.** So a module can serve as a precompiled unit others compile against
without its bodies, an interface section carries the exported declarations (a routine
signature, a handle or interface type, a constant, an exported var, a transparent record
type carrying its size, alignment, and fields, or an opaque record type carrying its size
and alignment but not its fields) in a self-delimiting block:

```
.interface fingerprint <n>
    ... exported declarations ...
.endinterface
```

The declaration lines emitted so far, one entry per exported item, are:

```
.type <name> enum <member>...
.type <name> opaque <size> <align>
.type <name> record <size> <align> ( <field-name> <type> <offset>... )
.type <name> handle ( <method-name> <signature>... )
.const <name> <type> <value>
.const <name> <type>                  # a link-time constant: value in an exported read-only global
.var <name> <type> [shared]
.routine <name> <signature>
.method <receiver-type> <name> <signature>   # receiver-type is <type> or <unit>.<type>
```

**Signatures.** A routine, a method, and a handle type's method share one signature
form: a parenthesized parameter list, an arrow, the result type, and an optional
failability marker.

```
<signature> = '(' { <mode> <type> } ')' '->' <type> [ 'fails' ]
```

The `fails` marker is present exactly when the routine or method is failable (see
`kp-errors.md`); its absence means infallible, and it is part of the interface
fingerprint. The result type is `void` for a procedure. A `<mode>` is the parameter
passing mode: `val` (by value, the default), `var` (by reference, read-write), `const`
(by reference, read-only), or `out` (by reference, write).

**Type tokens.** A `<type>` renders by one of these rules, in order:

```
<type> = 'integer' | 'int64' | 'boolean' | 'char' | 'string' | 'real' | 'single' | 'void'
       | <name>                        # an exported enum, record, or handle (interface) type
       | 'int' | 'int64' | 'float'     # the ABI-class fallback for any other type
```

A built-in scalar renders as its own keyword, and `void` is the result of a procedure.
A named exported `enum`, `record`, or `handle` (interface) type renders as that type's
own name, which the reader resolves against the `.type` entries read earlier. Every
other type, one with no named interface form, renders as its fallback ABI class:
`float` for a real, `int64` for a 64-bit integer, and `int` for everything else, which
in practice means a dynamic array, a map, a set, a subrange, or a fixed array. The
fallback carries only the value's ABI width, not its structural shape, so a consumer
binds to it as the integer or real class and cannot reconstruct the original element,
bound, or member type. This is the one lossy point in the interface: a parameter or
result whose exact type a consumer must name should use a named exported type. Type
entries are emitted before the entries
that reference them, so a consumer reading the section top to bottom resolves a forward
type reference. A `.type ... enum` lists its members in order, each a compile-time constant
of that type. A `.type ... record` gives an exported record's size, alignment, and each
field's name, type, and byte offset, so a consumer names its fields and value-copies it with
the same layout, retaining any managed field on the copy exactly as the defining unit does.
A `.type ... opaque` gives an exported record's computed byte size and
alignment but not its fields, so a consumer allocates and value-copies it (a shallow byte
copy that shares any reference members) but cannot name a field; the unit provides any deep
copy. A `.type ... handle` gives a host handle type's methods, each with its name and
signature. A consumer reconstructs the vtable so it emits the `.import type` (below) and
dispatches a call to the right slot; the host still supplies the implementation, so the
interface carries only the type's shape, not a definition to link against. A `.const` with a
value is an inline constant, and a consumer bakes the value in. A `.const` with only a type is
a link-time constant: its value is not in the interface (so a value change does not move the
fingerprint), and it is carried by an exported read-only global (above) the consumer references
by address; a consumer cannot use it in a constant position. A `.var` names its type,
`shared` when it is one instance across contexts
rather than the thread-local default. A `.routine` gives each parameter's mode and type and
the result type (`void` for a procedure). A `.method` is the same but names the receiver
type first; a consumer registers it against that type so a call `v.name` resolves whenever
the defining unit is in the dependency closure, and the call links against the exported
`<receiver-type>.<name>` symbol. When the method's receiver type belongs to another unit (a
unit adds a method to an imported type), the receiver is written `<unit>.<type>`, so a
downstream consumer resolves it through the closure to the same type and dispatches the
method on its own values of that type; the link symbol still uses the type's own name, so it
matches the defining unit's export. The loader records the block's `fingerprint` (to match a
consumer's `.uses`) and otherwise skips to `.endinterface`, since it links against the bodies,
not the interface; kpcom is the reader that consumes the entries, to type-check a dependent
unit and record the dependency fingerprint.

**Host-method imports.** Kobold resolves a call on a host handle at link, not at runtime
(see the no-dynamic-dispatch entry in `kobold.md`). So the format needs a durable,
symbolic representation of a host-method call: the handle type's identity, the method name,
and its signature, as an unresolved import the loader binds against the host's registered
methods (a direct call is patched in; a required method the host does not provide is a link
error). This extends the existing host-function import, keyed additionally by the handle
type. The concrete encoding is the `.import type <name> methods <n>` form above: a consumer
reconstructs the handle type's vtable from the dependency's `.type ... handle` interface entry
and imports it, and the loader resolves each slot to the host's registered method at link,
binding a method thunk that calls `kp_dispatch_to`. There is no runtime-typed dispatch: the
slot is resolved at link with `kp_type_method`, so `kp_dispatch_to` is the only dispatch path.

A consumer reads only the interface to type-check against the unit; the backend that
links or loads it reads the `functions` bodies. The interface also carries a fingerprint,
a 32-bit hash over the rendered entry lines, and a consumer records the fingerprint it saw
for each dependency, so the loader rejects a stale consumer rather than linking against the
wrong interface. The unit design that drives the interface is in `kp-units.md`.

**The fingerprint hash.** The value on the `.interface fingerprint` line is computed as
follows, so a clean-room reader can reproduce it exactly.

The input is the block of entry lines in a fixed canonical order, independent of source
order. The entries are emitted in two passes: the first pass emits every `.type` entry,
and the second emits the `.const`, `.var`, `.routine`, and `.method` entries. Within each
pass the entries follow the unit's source declaration order, and the names re-exported
from a dependency follow the unit's own entries of that pass. Types come first so that a
later entry referencing an exported type resolves when the section is read top to bottom.
The hashed input (the "blob") is the concatenation of these entry lines, **each followed
by a single newline byte** (`0x0A`), in that order. The `.interface fingerprint` line
itself and the closing `.endinterface` are not part of the blob, and no separator other
than the per-entry newline is added.

The hash is a 32-bit unsigned rolling hash with the structure of FNV-1a but using addition
in place of exclusive-or (the dialect that implements the compiler has no `xor` operator).
Starting from `h = 2166136261` (the FNV-1a 32-bit offset basis), for each byte `b` of the
blob, taken as its unsigned 0..255 value:

```
h = (h * 16777619 + b) mod 2^32
```

where `16777619` is the FNV-1a 32-bit prime. The final `h` is written as an unsigned
decimal integer. Masking every step to 32 bits makes the value identical on any host.

Because each entry renders a routine or method signature as parameter modes and types with
no parameter names, renaming a parameter leaves the fingerprint unchanged. A link-time
constant's value is carried by an exported global, not the interface, so changing that
value does not move the fingerprint. Private declarations and function bodies are not in
the interface and never affect it. Changing an exported name, an exported type's shape
(including a transparent record's size, alignment, or field layout), a signature, a mode,
an exported var's type, or an inline const's value does change the rendered entry and so
changes the fingerprint.

**Skipping unknown sections.** For forward compatibility, an extensible section is a
self-delimiting block introduced by a marked directive:

```
.section <name> optional
    ... section body ...
.endsection
```

A loader that does not recognize `<name>` skips an `optional` section to its
`.endsection`, and rejects a `required` one, since it cannot safely run a module whose
required content it does not understand. This gives graceful degradation for additive
metadata while keeping semantics-changing additions safe. The version 1 core sections
predate this framework and stay recognized directly; the framework governs sections
added on top of them.

## Deferred to the ABI spec

These are named here but their calling details live in `kp-abi.md`:

- how a handle method call (a `<Type>.<method>` reference) lowers and how its
  method slot is resolved to a direct call at load time,
- the retain/release, string, and coroutine `helper` signatures and when the
  front end emits calls to them,
- the width of a handle id and the host handle-table API,
- struct-by-value ABI (the psABI function fields), when structured FFI is added,
- No per-suspend-point coroutine stack map is planned. The drop path uses
  **cancel-by-unwind**, which runs the front end's ordinary scope-exit release code
  rather than walking a module-carried map, so no stack-map side-table is added to
  the format.
