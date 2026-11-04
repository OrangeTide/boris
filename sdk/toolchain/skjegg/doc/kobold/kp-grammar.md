# Kobold-Pascal Grammar

This document is the grammar of Kobold-Pascal, a subset of Pascal with no
pointers, opaque host handles, Go-style methods, and stackful coroutines. For the
rationale behind these choices see `kobold.md`. The static-semantics rules the
grammar does not capture (type identity, compatibility, conversions, expression
typing, overload resolution, and storage layout) are in `kp-semantics.md`.

> This grammar tracks the language `kpcom` accepts. A few productions remain
> ahead of the implementation; each is marked inline where it appears (for
> example cross-module property export). See the design document's status
> section for the current feature map.

## Notation

EBNF is used throughout. Terminals are shown in `'single quotes'` or as
`UPPER_CASE` token names. Non-terminals are in CamelCase. `{ ... }` means zero or
more repetitions, `[ ... ]` means optional, and `|` means alternation.

The language is **case-insensitive**: keywords and identifiers are matched without
regard to case.

## Programs

```ebnf
CompilationUnit  = Program | Unit .

Program          = 'program' Identifier ';' [ UsesClause ] Block '.' .

Block            = { DeclSection } StatementPart .

DeclSection      = ConstDeclPart
                 | TypeDeclPart
                 | VarDeclPart
                 | ProcOrFuncDecl
                 | PropertyDecl
                 | ImplementDecl .

StatementPart    = CompoundStmt .
```

## Compilation units

A source file is either a `program` (with an entry point) or a `unit` (a library of
declarations other units and programs compile against and link to). A `uses` clause
names the units a program or unit depends on. This is the source side of the
separate-compilation feature the KPM1 format reserves. The design, including the
opacity, import, and method rules, is in `kp-units.md`; see also `kp-module-format.md`.

> Implemented. `kpcom` parses `unit` files and the `uses` / `reexport`
> clauses, resolves names across units, emits and reads the `.interface` section, and links
> precompiled `.kpm` objects; `kpbundle` packages a program with its units. The surface
> below matches what is built (see `kp-units.md`).

```ebnf
Unit             = 'unit' UnitName ';'
                   [ UsesClause ]
                   InterfacePart
                   ImplementationPart
                   'end' '.' .
                 (* UnitName is dotted (kp-units.md): the leading segments are a
                    namespace (core, io, std, experimental, kobold, or a user
                    namespace), the last segment is the unit and the default
                    qualifier. A flat name is still a unit in the root namespace. *)
                 (* one uses clause for the whole unit, private by default; the public
                    surface is stated with reexport. No separate interface-level and
                    implementation-level uses. No initialization or finalization
                    section: run-once setup is an exported routine. *)

InterfacePart    = 'interface' { InterfaceDecl } .
InterfaceDecl    = ConstDeclPart
                 | ExportedTypeDeclPart
                 | VarDeclPart
                 | PropertyDecl               (* cross-module property export is deferred, kp-property.md *)
                 | ReexportClause
                 | ProcOrFuncHeading ';' .
                 (* an exported routine or method is declared by heading only; its body
                    lives in the implementation part. An exported const is compile-time
                    inline, a link symbol rather than state; an exported var is a plain
                    read-write cell. A PropertyDecl declared in a program or in a unit's
                    implementation part is accepted; exporting a property across a unit
                    interface is deferred (kp-property.md). *)

ExportedTypeDeclPart = 'type' ExportedTypeDef { ExportedTypeDef } .
ExportedTypeDef  = Identifier '=' Type ';'
                 | Identifier ';' .
                 (* the second form is an opaque type: the name is exported, the full
                    definition is given in the implementation part and hidden from
                    consumers. An opaque value is reference-like; a deep copy is an
                    exported routine, see kp-units.md. *)

PropertyDecl     = 'property' Identifier ':' Type AccessorSpec ';' .
AccessorSpec     = 'read' Identifier [ 'write' Identifier ] .
                 (* accessor-backed value with uniform access: 'read' names the getter,
                    optional 'write' the setter, so a property is read-only when 'write'
                    is omitted. A property may also be a record field (see RecordType).
                    Implemented for scalar-value types (routine-reference accessors); inline
                    accessor bodies, handle/aggregate types, and cross-module export are
                    deferred (kp-property.md). *)

ReexportClause   = 'reexport' ReexportItem { ',' ReexportItem } ';' .
ReexportItem     = Identifier [ '(' Identifier { ',' Identifier } ')' ] .
                 (* promote names from a used unit into this unit's public surface,
                    selectively: 'reexport geometry (Vec)'. *)

ImplementationPart = 'implementation' { DeclSection } .
                 (* supplies the bodies for the interface headings and the full
                    definitions for opaque types, plus any private declarations. *)

ProcOrFuncHeading = 'procedure' Identifier
                     ( 'for' Receiver [ FormalParams ] | [ FormalParams ] )
                 | 'function' Identifier
                     ( 'for' Receiver [ FormalParams ] ':' Type
                     | [ FormalParams ] ':' Type ) .
                 (* the 'for' Receiver form exports a method. Method definitions are
                    open across units, but each (receiver type, name, signature) has
                    one definition program-wide (the fold rule in kp-units.md). *)

UsesClause       = 'uses' UnitImport { ',' UnitImport } ';' .
UnitImport       = PlainImport | WildcardImport .
PlainImport      = UnitName [ 'as' Qualifier ]
                   [ '(' ImportItem { ',' ImportItem } ')' ] .
WildcardImport   = UnitName '.' '*' .
                 (* 'uses io.*' imports every unit directly in the io namespace
                    (one level, not recursive), each under its own last-segment
                    qualifier; no 'as' and no selective list apply to a wildcard.
                    The import depends on the namespace's current membership
                    (kp-units.md). *)
UnitName         = Identifier { '.' Identifier } .
                 (* dotted: segments but the last are the namespace; the last is
                    the unit and the default qualifier. *)
Qualifier        = Identifier | '_' .
                 (* the qualifier defaults to the unit name's last segment; 'as X'
                    shortens it to X; 'as _' drops it, so exported names come into
                    scope bare. *)
ImportItem       = Identifier [ 'as' Identifier ] .
                 (* selective import: only the named items are visible, and 'A as B'
                    renames A to B locally. Without a list, all exported names are
                    visible under the qualifier. Methods are not gated by the list;
                    a method resolves whenever its unit is in the dependency closure. *)
```

## Declarations

```ebnf
ConstDeclPart    = 'const' ConstDef { ConstDef } .
ConstDef         = Identifier '=' ConstExpr ';'
                 | Identifier ':' Type '=' ConstExpr ';' .
                 (* first form is an untyped constant;
                    second form is a typed constant / initialized variable *)

TypeDeclPart     = 'type' TypeDef { TypeDef } .
TypeDef          = Identifier '=' Type ';' .

VarDeclPart      = [ 'shared' ] 'var' VarDecl { VarDecl } .
                 (* a plain module-level var is thread-local by default; 'shared' makes
                    the vars in the part one instance across execution contexts. See
                    kp-units.md. 'shared' has no effect on a var local to a routine. *)
VarDecl          = IdentList ':' Type [ '=' ConstExpr ] ';' .
IdentList        = Identifier { ',' Identifier } .

ConstExpr        = Expression .
                 (* syntactically an Expression, evaluated at compile time *)
```

## Types

```ebnf
Type             = SimpleType
                 | ArrayType
                 | BufferType
                 | MapType
                 | RecordType
                 | SetType
                 | InterfaceType
                 | ProceduralType .

SimpleType       = TypeIdentifier
                 | EnumType
                 | SubrangeType .

TypeIdentifier   = Identifier .
                 (* built-in: integer/longint, shortint, byte, word, cardinal,
                    int64/qword, real/double, single, boolean, char, process, mapiter.
                    'string' is a predefined host handle type (see below); 'mapiter' is a
                    predefined map-cursor handle (see MapType).
                    A host handle type is one declared with InterfaceType.
                    'label' is the code-address value type (see below); it is
                    second-class, so it names a type only for a local variable or a
                    routine-local 'array of label' (the dispatch table). *)

EnumType         = '(' IdentList ')' .

SubrangeType     = ConstExpr '..' ConstExpr
                 | Identifier '(' ConstExpr '..' ConstExpr ')' .
                 (* second form is a typed subrange with an explicit base type,
                    e.g. Day(Mon..Fri) *)

ArrayType        = 'array' ( '[' SubrangeType { ',' SubrangeType } ']' | ) 'of' Type .
                 (* the bracketed form is a fixed array; 'array of Type' with no
                    subranges is a dynamic array, a refcounted handle sized at run time
                    with SetLength and read with Length/High/Low. A dynamic array is a
                    value type: assignment eager-copies *)

BufferType       = 'buffer' [ '[' { ',' } ']' ] 'of' Type .
                 (* a shared dynamic array whose element backing is host-owned: the host
                    places the region and may re-map it, ARC never frees the backing, and the
                    guest cannot SetLength it. The element must be reference-free data (no
                    string, handle, array, or record with such a field). Interoperates only
                    with another buffer, not with a value array. A buffer is
                    created by the host through the FFI, not minted in guest code.
                    The optional bracket form gives a multidimensional buffer: one strided
                    region whose rank is the comma count plus one, so 'buffer[,] of T' is 2D
                    and 'buffer[,,] of T' is 3D. It is indexed b[i, j, ...] with one subscript
                    per axis (checked at compile time) as base + sum(i_k * stride_k); the
                    per-axis extents and byte strides are set by the host at creation, so a
                    row pitch may exceed cols * elemsize *)

MapType          = 'map' [ '[' Type ']' ] 'of' Type .
                 (* an associative array with value type Type, a refcounted handle. The key type
                    in brackets is an ordinal (integer, int64, char, enum, boolean); 'map of T'
                    with no brackets is the string-keyed form. m[k] gets or sets (set inserts, get
                    traps if absent), k in m tests membership, Delete(m, k) removes, Length(m)
                    counts, TryGet(m, k, v) fetches, and MapFirst/MapNext iterate with a 'mapiter'
                    cursor. A map is a value type: assignment eager-copies, like a dynamic array *)

RecordType       = 'record' FieldList [ VariantPart ] 'end' .
FieldList        = [ FieldDecl { ';' FieldDecl } [ ';' ] ] .
FieldDecl        = IdentList ':' Type
                 | Identifier ':' Type AccessorSpec .
                 (* the second form is a computed field: an accessor-backed property on
                    the record, uniform with a stored field at the use site. The accessors
                    are methods of the record (kp-property.md). *)
VariantPart      = 'case' [ Identifier ':' ] TypeIdentifier 'of'
                   Variant { ';' Variant } .
Variant          = CaseLabelList ':' '(' FieldList ')' .

SetType          = 'set' 'of' SimpleType .
                 (* base type is an ordinal type; a set holds at most 256
                    values, so at most 32 bytes. See the note below. *)

InterfaceType    = 'interface' { InterfaceField } 'end' .
InterfaceField   = Identifier ':' ProceduralType ';' .
                 (* In Kobold an interface type is a host handle type: named
                    procedural fields are the operations the host provides.
                    See Handle types below. *)

ProceduralType   = 'procedure' [ FormalParams ]
                 | 'function' [ FormalParams ] ':' Type .

ImplementDecl    = 'implement' Identifier 'for' Identifier ';' .
                 (* A nominal, static assertion that record R conforms to interface I:
                    'implement I for R;'. The compiler checks R's for-receiver methods
                    match I's signatures; it is a compile-time conformance check for
                    constraints and overloading, with no boxing and no dynamic dispatch
                    (Kobold has no vtables). Retroactive: it may name an R or I from
                    another unit. *)
```

There are no pointer types. There is no `^` type constructor and no pointer
arithmetic. A reference to a host object is a handle, a value of a
host-registered type, not a pointer. The one address-like value is `label`: a
`label`-typed value holds the address of a code label in the current routine,
made by the `@` operator and consumed by a computed `goto` (the threaded-dispatch
primitive). It is second-class (see `label` below), so it is not a general
pointer: it cannot be stored outside its routine's frame, and `@` accepts only a
label name, never a data object.

`string` is not a value type. It is a predefined host handle type, so a `string`
variable holds a handle to a host-owned string. There is no `string[n]` sizing,
because the script does not own the bytes. String literals in source compile to a
host create call, and string operations are host FFI calls.

`nil` is the null handle. It is assignable to and comparable with any handle type,
including `string`. Calling a method on `nil` faults in safe mode.

### The `label` type

`label` is the one code-address value type, for writing a threaded-dispatch inner
loop (a bytecode interpreter's `NEXT`: `goto table[token]`). A `label` value is
made only by `@name`, where `name` is a label in the current routine, and is
consumed only by a computed `goto`. It is **second-class**: it may live only in
the routine that made it, as a local variable or a routine-local `array of label`
(the dispatch table, filled at loop entry). It may not be a global, a record or
object field, a routine's return type, a parameter, or a map or set element. Those
rules are what keep a computed `goto` provably landing in a live frame, so no
escape analysis or runtime frame check is needed. There is no general `goto`: a
bare `goto name` naming a label is rejected, and `break`/`continue` remain the
structured exits.

### Handle types

A host handle type is declared with the `interface` syntax: an `interface` block
of named procedural fields. It names an opaque, typed reference whose storage
lives in the host.

```pascal
type
  Entity = interface
    move: procedure (dx, dy: integer);
    alive: function: boolean;
  end;
```

An interface field's result type is a simple type or a handle, never a `string`,
record, or array (a structured result has no way to cross the field's procedural
type).

In Kobold an interface *is* the handle type, and the concrete implementation is
the host's:
the host registers matching methods, and the loader resolves each of the interface's
methods at link to a direct call against the host's registered function, so a call
like `e.move(1, 0)` reaches the host with no runtime vtable lookup. A method an
interface requires that the host does not register is a link error. There is no
`implement` block for a host handle type. A script may still add its own methods to a
handle type with the `for` receiver form (see below).

### Sets

A `set of T` is sized to its base type, up to 256 values, so at most 32 bytes. A
set that fits in a machine integer is held in a register (`_smallSet`); a larger
set is an array of integers (`_largeSet`). The `set` type wraps whichever applies;
the distinction is not visible in the language.

A set is a value and may be an element of any aggregate: a record field, a fixed
or dynamic array element, or a map value. It carries no references, so a dynamic
array or map of sets needs no per-element handle layout.

### The process type

`process` is a built-in type: a first-class handle to a coroutine (see
[Coroutine constructs](#coroutine-constructs)). Most coroutine code never names
one, because `start` and `yield` use the current coroutine implicitly. A
`process` variable is for the cases that store a coroutine to resume across
ticks, pass it, or choose among several.

## Procedures, functions, and methods

```ebnf
ProcOrFuncDecl   = ProcDecl | FuncDecl .

ProcDecl         = 'procedure' Identifier
                   ( 'for' Receiver [ FormalParams ] [ 'fails' ] ';' Block ';'
                   | [ FormalParams ] [ 'fails' ] ';' Tail ) .

FuncDecl         = 'function' Identifier
                   ( 'for' Receiver [ FormalParams ] ':' Type [ 'fails' ] ';' Block ';'
                   | [ FormalParams ] ':' Type [ 'fails' ] ';' Tail ) .

Tail             = [ 'export' ';' ] Block ';' | 'forward' ';'
                 | HostImport ';' .
HostImport       = 'external' | 'cdecl' | 'external' 'cdecl'
                 | 'cdecl' 'external' .
                 (* 'for' Receiver marks a Go-style method attached to a type.
                    'forward' declares ahead for mutual recursion.
                    'external' (or 'cdecl', naming the C calling convention)
                    marks a routine provided by the host FFI; it has no Pascal
                    body. 'export' marks a routine as a module entry an
                    embedding host may call across the FFI. 'fails' marks the
                    routine as failable: it reports an error alongside its
                    result, and every call must handle that error. 'fails' is
                    part of the signature; it cannot be overloaded away. See
                    FailableForm under Expressions and kp-errors.md. *)

FormalParams     = '(' FormalParam { ';' FormalParam } ')' .
FormalParam      = [ 'var' | 'out' | 'const' ] IdentList ':' Type .
                 (* value; 'var' (by reference); 'out' (by reference, for
                    output); and 'const' (by reference, immutable) parameters.
                    'array of' Type in a FormalParam is an open array. An 'out'
                    parameter is also how a routine returns more than one value;
                    there is no dedicated tuple-return syntax. *)

Receiver         = '(' [ 'const' ] Identifier ':' TypeIdentifier ')' .
                 (* the named type is a script record or a host handle type.
                    The receiver is by reference by default, so a method may
                    mutate it. A 'const' receiver is immutable. There is no
                    pointer receiver: no '^' form. *)
```

**Recoverable errors.** A routine marked `fails` reports an expected failure by
value: its normal result in the usual place and an `error` beside it. The caller
must deal with that error through one of the failable forms (see FailableForm
under Expressions), so a failure cannot be ignored. This is the sanctioned
recoverable-error mechanism; programming errors still trap. See `kp-errors.md`.

**Multiple returns.** Kobold has no tuple return and no `Result[T, E]` type. A
routine that must report two ordinary values returns one as its result and the
other through an `out` parameter, the `TryLookup` idiom:

```
function TryLookup(k: Key; out v: Value): Boolean;
```

The caller checks the `Boolean` (or an enum status) before reading `v`. For an
error rather than a second value, prefer a `fails` routine.

A method is called with dot notation. On a record receiver the call resolves
statically to the script routine that implements the method. On a handle receiver
the call cannot bind at compile time, so it resolves at link to a direct call
against the method the host registered for that handle type; there is no runtime
vtable lookup.

A script may define a method on a host handle type, layering behavior over the
host type. When a script method and a host-registered method share a name on the
same handle type, the script method wins: the call binds statically to the script
method, which overrides the host one.

**Overloading.** Several procedures or functions may share a name and be selected
by argument type, resolved statically at the call site. This is how `writeln` has
one name across `string`, `integer`, and `real`, and how a script adds a printer
for its own type, for example `writeln(SomeEntity)`. Output is not special grammar;
it is ordinary overloaded calls.

**Nested procedures.** A procedure or function may be declared inside another (its
`Block` has its own declaration part). A nested routine may read and write the
enclosing routine's locals and parameters. Nesting is non-escaping: a nested routine
is called, never stored or returned as a value if it uses anything from an enclosing
scope. The front end lowers nesting away before the IR, so it is purely a source-level
convenience (see `kobold.md`).

**Procedure values.** A value of a `ProceduralType` (a variable, parameter, record
field, interface field, or array element) is a bare code pointer with no captured
environment. It may hold a top-level routine or a nested routine that captures
nothing from its enclosing scope. Taking the value of a nested routine that reads or
writes an enclosing local is a compile-time error: there are no closures. A procedure
value is called through the ordinary call syntax in `Designator`, whatever the
callee designator is: a name, an interface method field (host handle methods, the
common case), or a computed element such as `table[op](args)`. The last is the
direct-threaded dispatch shape, an array of routine values walked and called in a
loop.

## Statements

```ebnf
CompoundStmt     = 'begin' StmtSequence 'end' .
StmtSequence     = Statement { ';' Statement } .

Statement        = [ LabelPrefix ]
                   [ AssignOrCallStmt
                   | CompoundStmt
                   | IfStmt
                   | WhileStmt
                   | ForStmt
                   | ForInStmt
                   | RepeatStmt
                   | CaseStmt
                   | WithStmt
                   | StartExpr
                   | BindExpr
                   | YieldExpr
                   | BreakStmt
                   | ContinueStmt
                   | DeferStmt
                   | GotoStmt
                   | AsmStmt ] .
                 (* StartExpr, BindExpr, and YieldExpr are also expressions; as
                    statements their value is discarded. See Coroutine
                    constructs. *)

AsmStmt          = 'asm' '(' StringLiteral
                     [ ':' [ AsmOperand { ',' AsmOperand } ]
                       [ ':' [ AsmOperand { ',' AsmOperand } ]
                         [ ':' [ StringLiteral { ',' StringLiteral } ] ] ] ] ')' .
AsmOperand       = StringLiteral '(' Expression ')' .
                 (* Inline assembly. The first StringLiteral is the template, emitted
                    into the generated assembly at that point, so its text must match
                    the target assembler's syntax. There is no '${}' interpolation (the
                    literal is taken as written; a single- or double-quoted literal is
                    accepted, but a double-quoted one does not interpolate here).

                    The basic form is the template alone. The template then carries no
                    operands, the compiler does not parse it, and register allocation
                    does not see it, so the block must leave the machine state the
                    surrounding code expects.

                    The extended form adds, after a ':', the output operands, then a
                    second ':' and the input operands, then a third ':' and the
                    clobbered register names (GNU style). Each operand is a constraint
                    string and a parenthesised expression; in the template, '%N' is
                    operand N, outputs numbered first then inputs. The simple subset the
                    compiler supports: the operand type is a single-register integer-class
                    ordinal (integer, char, boolean, enum, or subrange), the constraint is
                    the general register class only ('=r' for an output, '+r' for a
                    read-write output, 'r' for an input), and an output expression must be
                    an assignable designator. The register allocator places each operand
                    and reserves the clobbers.

                    AOT only: the in-process JIT does not assemble text. *)

LabelPrefix      = Identifier ':' .
                 (* names the statement that follows as a jump target, scoped to
                    the enclosing routine. The only use of a label name is in '@'
                    (take its address, below); a bare 'goto name' is rejected, so
                    there is no unstructured goto. *)
DeferStmt        = 'defer' Statement .
                 (* registers the Statement for teardown at the end of its
                    enclosing block, run LIFO on every orderly exit from that
                    block: fall-through, 'exit', 'break', 'continue', and the
                    failable diverts. A trap skips it. Use a 'begin'..'end' block
                    to defer several statements. The deferred Statement may not
                    transfer control out of itself ('exit'/'fail'/'break'/
                    'continue'/'yield'/'goto'/a nested 'defer' are rejected). See
                    kp-defer.md. *)
GotoStmt         = 'goto' Expression .
                 (* a computed jump: the Expression must have type 'label'. The
                    label value can only be made by '@' on a current-routine
                    label, so the jump always lands in a live frame. This is the
                    threaded-dispatch primitive (goto table[token]); a bare
                    'goto name' to a label identifier is a compile error. *)

AssignOrCallStmt = Designator ( ':=' Expression | [ FailableSuffix ] ) .
                 (* a bare Designator is a procedure or method call; with ':='
                    it is an assignment. A call of a 'fails' routine may instead
                    carry a FailableSuffix (see Expressions), e.g.
                    `log(m) or else ignore;` or `step() or fail;` *)

IfStmt           = 'if' Expression 'then' Statement [ 'else' Statement ] .
                 (* dangling else binds to the nearest unmatched if *)
WhileStmt        = 'while' Expression 'do' Statement .
ForStmt          = 'for' Identifier ':=' Expression ( 'to' | 'downto' )
                   Expression 'do' Statement .
ForInStmt        = 'for' ForBinder [ ',' ForBinder ] 'in' Designator 'do'
                   Statement .
ForBinder        = Identifier | '_' .
                 (* iterates the elements of the Designator, binding each to the
                    pre-declared ForBinder variable(s); '_' ignores a binder. A
                    second binder is only for a map, where the pair is key, value.
                    The source is a fixed array (its index range), a dynamic
                    array (0..high), a string (its bytes), a set, or a custom
                    cursor. See kp-foreach.md. *)
RepeatStmt       = 'repeat' StmtSequence 'until' Expression .
CaseStmt         = 'case' Expression 'of' CaseElement { ';' CaseElement }
                   [ ';' ] [ 'else' StmtSequence ] 'end' .
CaseElement      = CaseLabelList ':' Statement .
CaseLabelList    = CaseLabel { ',' CaseLabel } .
CaseLabel        = ConstExpr [ '..' ConstExpr ] .
WithStmt         = 'with' Designator { ',' Designator } 'do' Statement .

BreakStmt        = 'break' .
ContinueStmt     = 'continue' .
```

## Coroutine constructs

```ebnf
StartExpr        = 'start' ( CompoundStmt | Expression ) .
                 (* creates a suspended coroutine from the body and evaluates to its
                    handle (a 'process' value). The body does not run at 'start'; the
                    first resume, k(v), runs it from the top up to its first yield.
                    Usable as a statement, but then the handle is dropped and the body
                    never runs, so the useful forms bind the handle. The body may not
                    capture an enclosing local (it would escape, which the no-closure
                    rule forbids); data enters through the started routine's by-value
                    arguments, as in 'start worker(a, b)'. See below. *)

YieldExpr        = 'yield' [ Expression ] .
                 (* the simple form: suspends the current coroutine and delivers
                    Expression to whoever last resumed it. Names no handle. It is
                    also an expression: its own value is what the next resume passes
                    back, so a coroutine can both hand out a value and receive one
                    back at the same point. *)

BindExpr         = 'bind' Identifier 'in' Expression .
                 (* the explicit form: binds the current coroutine handle to
                    Identifier (a 'process' value) within Expression, then
                    suspends with Expression's value. Identifier is the stable handle
                    the spawner holds. As an expression, its value is the resume
                    value. *)
```

A `process` names a stackful coroutine. It is resumed by calling it like a
function, `k(Expression)`, which switches into the coroutine and runs it to its next
`yield`, returning the yielded value; the argument to `k` becomes the result of the
`yield`/`bind` that suspended it. The **first** resume runs the body from the top to
its first `yield`, so there is no suspended `yield`/`bind` waiting for a value and the
argument to that first `k(...)` is ignored. A coroutine is **resumed repeatedly**, advancing
each time, so the handle is stable rather than replaced on each yield. It is **not
forkable**: resuming a suspension twice in parallel, resuming a coroutine that is
already running, or resuming one that has completed is a runtime error. The resumed `k`
may be a `process` variable, parameter, array element, or record field, so a scheduler can
hold several coroutines in an `array of process` and resume a chosen one with `q[i](v)`,
or keep one in a record and resume it with `rec.k(v)`.

**Answer type and resume type.** A `start` boundary has two types, both fixed
statically. The *answer type* is the type delivered out of the boundary each time
the coroutine suspends: the value a resume `k(...)` returns, the operand of every
`yield`/`bind` that targets it, and, when `B` runs to completion, `B`'s own result
must all share this one type. `start B` itself evaluates to a `process`, not to the
answer value. The *resume type* is the type carried back in: the value passed to
`k(...)` when the process is resumed, which is the result type of the `yield`/`bind`
expression that captured it. The two may differ, so a coroutine can yield one type
and be resumed with another. A `yield`/`bind` used as a statement discards its
resume value.

A **suspend point** is a `yield`, a `bind`, or a call to a routine that can itself
suspend. Even though `yield` and `bind` are expressions, a suspend point may appear only
at statement position: as a whole statement, or as the entire right-hand side of an
assignment. It may not be nested inside a larger expression, a loop or branch condition,
or an argument list. So `x := yield e` and `x := gen()` are allowed, while `x := 1 + yield e`
and `while gen() do` are rejected. This keeps a dropped coroutine's cleanup prompt (a
suspend buried in a condition could otherwise run unbounded before the next
statement-boundary check) and leak-free (a suspend mid-expression could otherwise abandon
an owned temporary when the coroutine unwinds).

Most coroutine code uses only `start` and `yield` and never names a process:
the runtime tracks the current coroutine. `bind ... in ...` and `process`
variables are for storing a coroutine to resume later, passing it, or choosing among
several.

`release(k)` drops the caller's reference to a reference-counted handle: a `process`, a
`string`, or an interface handle. It is the ARC-style release, not a Pascal-style
`Dispose` free: it decrements the reference count, and only when the last reference goes
does the handle's kind-specific finalizer run (for a `process`, that cancels it and frees
its private stack). When `k` is a variable, `release` also sets it to `nil`, so the
variable is not released a second time at scope exit and a later use of it is a `nil`
rather than a stale id. Releasing `nil` is a no-op; releasing an already-released handle
is a no-op in the default mode and a trap under the safe-mode checks. It is written as an
ordinary call.

## Expressions

```ebnf
Expression       = Comparison [ FailableSuffix ] .
Comparison       = SimpleExpr [ RelOp SimpleExpr ] .
RelOp            = '=' | '<>' | '<' | '>' | '<=' | '>=' | 'in' .

FailableSuffix   = 'fails' [ Identifier ]
                 | 'or' 'else' ( Expression | 'ignore' )
                 | 'or' ( 'exit' | 'break' | 'continue' | 'fail' ) .
                 (* the postfix handling of a call to a 'fails' routine, lowest
                    precedence, so the whole left Comparison is the failable call.
                    'fails' tests the error (and optionally binds it to a fresh
                    Identifier, like a for-loop counter); 'or else' recovers with
                    a value, or 'ignore' discards the error; 'or exit|break|
                    continue|fail' diverts on failure. 'exit', 'fail', and 'fails'
                    are not reserved: at 'or' a one-token lookahead picks the
                    failable suffix over boolean 'or', and 'fails' is recognized
                    only in this postfix position. See kp-errors.md. *)

SimpleExpr       = [ '+' | '-' ] Term { AddOp Term } .
AddOp            = '+' | '-' | 'or' .

Term             = Factor { MulOp Factor } .
MulOp            = '*' | '/' | 'div' | 'mod' | 'and' | 'shl' | 'shr' .

Factor           = INTEGER_LITERAL
                 | REAL_LITERAL
                 | STRING_LITERAL
                 | INTERP_STRING
                 | 'nil'
                 | '__line__'
                 | Designator
                 | '(' Expression ')'
                 | Aggregate
                 | RecordLiteral
                 | 'not' Factor
                 | '@' Identifier
                 | SetConstructor
                 | StartExpr
                 | BindExpr
                 | YieldExpr .
                 (* '@' name takes the address of a label in the current routine,
                    yielding a 'label' value for a computed 'goto'. It is the only
                    use of '@', and the only operand it accepts is a label name;
                    there is no general address-of operator. *)

Aggregate        = '(' Expression ',' Expression { ',' Expression } ')' .
                 (* an array constant's elements, one nested Aggregate per dimension
                    for a multi-dimensional array; meaningful only as a constant value *)
RecordLiteral    = '(' Identifier ':' Expression { ';' Identifier ':' Expression } ')' .
                 (* a record constant's fields, in the record's declared order;
                    meaningful only as a constant value *)

SetConstructor   = '[' [ SetElement { ',' SetElement } ] ']' .
SetElement       = Expression [ '..' Expression ] .

Designator       = Identifier { Selector } .
Selector         = '.' Identifier             (* field access or method call *)
                 | '[' ExprList ']'           (* array indexing *)
                 | '(' [ ExprList ] ')' .     (* call: function, method, or
                                                 process invocation *)

ExprList         = Expression { ',' Expression } .
```

There is no `'^'` selector: no pointer dereference, because there are no pointers.

`and` and `or` are **short-circuit** when their operands are boolean: the right
operand is not evaluated when the result is already determined by the left. On
integer operands they are bitwise. There is no `and then` operator; `and` covers
both roles. `or else` is not a boolean operator either: it is the failable recover
suffix (see FailableSuffix), told apart from boolean `or` by the token after `or`.
`not` is boolean or bitwise the same way.

`/` is real division and yields a `real`. `div` and `mod` are the integer
operators. `shl` and `shr` are the bitwise shifts on integer operands.

### Operator precedence

From highest to lowest:

| Precedence | Operators | Associativity |
|---|---|---|
| 1 | `not`, unary `+` / `-`, `@` | Right |
| 2 | `*`, `/`, `div`, `mod`, `and`, `shl`, `shr` | Left |
| 3 | `+`, `-`, `or` | Left |
| 4 | `=`, `<>`, `<`, `>`, `<=`, `>=`, `in` | None |

## Lexical elements

```ebnf
Identifier       = LETTER { LETTER | DIGIT | '_' }
                 | '_' ( LETTER | DIGIT | '_' ) { LETTER | DIGIT | '_' } .

INTEGER_LITERAL  = DIGIT { DIGIT }
                 | '$' HEX_DIGIT { HEX_DIGIT } .

REAL_LITERAL     = DIGIT { DIGIT } '.' DIGIT { DIGIT }
                   [ 'e' [ '+' | '-' ] DIGIT { DIGIT } ] .

STRING_LITERAL   = StringElement { StringElement } .
StringElement    = "'" { CHARACTER | "''" } "'"
                 | '#' INTEGER_LITERAL .
                 (* "''" is an escaped single quote inside a string;
                    '#' followed by 0..255 produces one byte *)

INTERP_STRING    = '"' { CHUNK | HOLE } '"' .
HOLE             = '${' Expression '}' .
                 (* A double-quoted literal with interpolation holes. Each HOLE's
                    Expression is rendered to text as 'write' renders it and
                    concatenated into the result. A CHUNK is literal text in which
                    "" is a literal double quote, "$$" before a brace is a literal
                    "${", and any other '$' stands for itself. The Expression is a
                    full expression and runs to its closing '}' (a '}' inside a
                    single-quoted literal within it does not close the hole). A
                    single-quoted STRING_LITERAL never interpolates. A 'real' hole
                    is not yet supported, and a HOLE may not contain a '"'. *)

LETTER           = 'a'..'z' | 'A'..'Z' .
DIGIT            = '0'..'9' .
HEX_DIGIT        = '0'..'9' | 'a'..'f' | 'A'..'F' .
CHARACTER        = (* any source byte *) .
```

Source files are UTF-8. Only ASCII-range bytes are significant to the lexer; bytes
0x80 through 0xFF pass through verbatim inside string literals and comments.

### Comments

```ebnf
Comment          = '{' { CHARACTER } '}'
                 | '(*' { CHARACTER } '*)'
                 | '//' { CHARACTER } EOL .
```

Comments may appear anywhere whitespace is allowed. Line comments (`//`) run to
the end of the line.

### Reserved words

```
and       array     as        begin     bind      break     buffer
case      const     continue  div       do        downto
else      end       external  for       forward
function  goto      if        implement implementation     in        interface
label     map       mod       nil       not       of        or        procedure
program   property  record    reexport  ref       repeat    set
shared    shl       shr       slice     start     string
then      to        type      unit      until     uses
var       while     with      yield
```

`start`, `bind`, and `yield` are reserved for the coroutine constructs, and
`bind` also uses the reserved `in`. `shl` and `shr` are the bitwise shift
operators. `interface` opens a host handle type. `external` is reserved for
routines provided by the host FFI. `for` doubles as the loop keyword and the method-receiver keyword.

`goto` is the computed jump of the threaded-dispatch primitive and `label` is the
code-address value type it jumps through (see the `label` type above). `goto`
takes a `label`-valued expression only; a bare `goto name` to a label identifier
is rejected, so there is no unstructured goto.

`map` opens `map of T`, a string-keyed associative array with value type `T`, or
`map[K] of T`, keyed by an ordinal `K` (integer, int64, char, enum, boolean) (see MapType).

`buffer` opens `buffer of T`, a host-backed shared array whose element backing the host owns
and places, so ARC never frees it and the guest cannot resize it. `ref` and `slice` stay
reserved but are not parsed. `slice` is held for a possible future windowed view (a subrange
`a[lo..hi]` sharing backing).

`unit`, `uses`, `reexport`, `implementation`, and `shared` are part of the implemented units
surface (see the Compilation units section), as is `implement` for guest-record trait
conformance (`implement I for R`, a static conformance check). `as` is the import alias in a
`uses` clause. `property` declares an accessor-backed value (`kp-property.md`); it works in a program or in a
unit's implementation part for scalar, handle, and aggregate value types, with cross-module
property export still deferred.

`out` (a parameter mode), `cdecl` (a calling convention on a host import),
`export` (a module entry), `read` and `write` (property accessors), and `fails` (the
failable signature marker and postfix test) are contextual: they act as keywords
only where a routine, property, or failable form expects them,
so an ordinary identifier may still carry one of these names. `exit` and `fail`
likewise stay ordinary (a builtin and the failure constructor): after `or`, a
one-token lookahead selects the failable divert, so `or exit` and `or fail` parse
without reserving the words. In a `uses` import, the identifier `_` in the alias
position means "no qualifier" rather than a name.

Identifiers such as `true`, `false`, `integer`, `real`, `boolean`, `char`,
`error`, `process`, `mapiter`, the built-in `release`, the error builtins
(`fail`, `errorcode`), the map helpers (`TryGet`, `MapFirst`, `MapNext`), and the
overloaded output functions are predefined identifiers, not reserved words, so a
program may shadow them.

An underscore may begin an identifier only when at least one identifier character
follows it. A lone `_` is the wildcard token, used for the "no qualifier" alias in a
`uses` import. An underscore-prefixed name, such as `_unused`, is an ordinary
identifier, and on a parameter it opts out of the unused-parameter warning (see
`kp-diagnostics.md`). `__line__` is a compile-time intrinsic, not an identifier: it
evaluates to an integer constant equal to the source line of its own occurrence.
