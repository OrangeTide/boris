# Compact Pascal Language Reference (skj-pc)

`skj-pc` implements a subset of Compact Pascal targeting the Skjegg
shared IR.  This document records what is and is not supported.

## Types

| Type | Status |
|------|--------|
| `integer` (32-bit signed) | supported |
| `boolean` | supported |
| `char` | supported |
| `byte` (unsigned 8-bit) | supported |
| `word` (unsigned 16-bit) | supported |
| `string`, `string[N]` | supported |
| `array[lo..hi] of T` (1D, 2D) | supported |
| `record...end` | supported |
| variant records (tagged, untagged) | supported |
| `set of T` | supported |
| enumerated types | partial (constants only, not distinct types) |
| `real` / floating point | **not implemented** |
| pointer types (`^T`) | **not implemented** |
| file types (`file of T`, `text`) | **not implemented** |
| subrange types (`1..100`) | **not implemented** as standalone declarations |
| procedural types | **not implemented** |

Subrange syntax works in array bounds, set definitions, and case
ranges, but cannot be used as a standalone type declaration.

Enumerated types parse and work, but values are plain integer
constants; they are not a distinct type for range checking.

## Declarations

| Form | Status |
|------|--------|
| `const` (with optional type annotation) | supported |
| `var` (with optional initialization) | supported |
| `type` (alias, enum, record, array, set) | supported |
| `procedure` / `function` | supported |
| `forward` | supported |
| nested procedures (capture-argument passing) | supported |
| typed constants (scalar, array, matrix, record, set) | supported |
| `label` | **not implemented** |
| `uses` / `unit` | **not implemented** |
| `external` | **not implemented** |

## Parameters

| Form | Status |
|------|--------|
| value parameters | supported |
| `var` parameters (by reference) | supported |
| `const` parameters | supported |
| array parameters | supported |
| record parameters | supported |
| string parameters | supported |
| procedural parameters | **not implemented** |

## Statements

| Statement | Status |
|-----------|--------|
| assignment (`:=`) | supported |
| `if...then...else` | supported |
| `while...do` | supported |
| `for...to/downto...do` | supported |
| `repeat...until` | supported |
| `case...of...end` (with `else`, ranges) | supported |
| `with...do` (single and multiple records) | supported |
| `begin...end` | supported |
| procedure calls | supported |
| `break` | supported |
| `continue` | supported |
| `exit` / `exit(value)` | supported |
| `halt` / `halt(code)` | supported |
| `goto` | **not implemented** |
| inline assembly | **not implemented** |

## Expressions and Operators

| Category | Supported |
|----------|-----------|
| Arithmetic: `+`, `-`, `*`, `/`, `div`, `mod` | yes |
| Comparison: `=`, `<>`, `<`, `<=`, `>`, `>=` | yes |
| Boolean: `and`, `or`, `not`, `xor` | yes |
| Short-circuit: `and then`, `or else` | yes |
| Bitwise: `and`, `or`, `xor`, `shl`, `shr` | yes |
| Set membership: `in` | yes |
| Set operations: `+` (union), `*` (intersection), `-` (difference) | yes |
| Set comparison: `=`, `<>`, `<=` (subset), `>=` (superset) | yes |
| String concatenation: `+` | yes |
| Unary minus, unary `not` | yes |
| Array indexing: `a[i]`, `a[i,j]` | yes |
| Record field access: `r.field` | yes |
| String indexing: `s[i]` | yes |
| Type casts: `chr()`, `ord()`, `integer()`, `char()`, `byte()`, `word()` | yes |
| Address-of: `@` | **no** |
| Pointer dereference: `^` | **no** |

## Built-in Procedures and Functions

### I/O

| Name | Status |
|------|--------|
| `write(args...)` | supported (integer, char, boolean, string) |
| `writeln(args...)` | supported |
| `write(x:width)`, `write(x:width:decimals)` | supported |
| `read(vars...)` | supported |
| `readln(vars...)` | supported |
| `eof` | supported |
| `eoln` | **not implemented** |
| `assign`, `reset`, `rewrite`, `close` | **not implemented** (no file types) |
| `ioresult` | **not implemented** |

### Arithmetic and Conversion

| Name | Status |
|------|--------|
| `abs(x)` | supported |
| `sqr(x)` | supported |
| `odd(x)` | supported |
| `succ(x)` | supported |
| `pred(x)` | supported |
| `ord(x)` | supported |
| `chr(x)` | supported |
| `inc(x)`, `inc(x, n)` | supported |
| `dec(x)`, `dec(x, n)` | supported |
| `lo(x)`, `hi(x)` | supported |
| `swap(x)` | supported |
| `upcase(ch)` | supported |
| `lowercase(ch)` | supported |
| `sizeof(T)` | supported |
| `sqrt(x)` | **not implemented** |
| `sin(x)`, `cos(x)` | **not implemented** |
| `trunc(x)`, `round(x)` | **not implemented** |
| `random(n)`, `randomize` | **not implemented** |
| `high(T)`, `low(T)` | **not implemented** |
| `paramcount`, `paramstr(n)` | **not implemented** |

### String Operations

| Name | Status |
|------|--------|
| `length(s)` | supported |
| `copy(s, idx, count)` | supported |
| `pos(substr, str)` | supported |
| `concat(s1, s2, ...)` | supported |
| `delete(s, idx, count)` | supported |
| `insert(src, dst, idx)` | supported |
| `str(val, s)` | supported |
| `val(s, v, code)` | supported |

### Memory

| Name | Status |
|------|--------|
| `fillchar(x, count, val)` | supported |
| `move(src, dst, count)` | supported |
| `new(ptr)` | **not implemented** (no pointers) |
| `dispose(ptr)` | **not implemented** (no pointers) |
| `getmem(ptr, size)` | **not implemented** |
| `freemem(ptr)` | **not implemented** |
| `mark`, `release` | **not implemented** |

## Compiler Directives

| Directive | Status |
|-----------|--------|
| `{$R+}` / `{$R-}` (range checking) | supported |
| `{$Q+}` / `{$Q-}` (overflow checking) | supported |
| `{$ALIGN n}` | supported |
| `{$DEFINE name}` | supported |
| `{$UNDEF name}` | supported |
| `{$IFDEF name}` / `{$IFNDEF name}` | supported |
| `{$ELSE}` / `{$ENDIF}` | supported |
| `{$I filename}` (include) | **not implemented** |
| `{$M stacksize}` | **not implemented** |

Record fields are laid out with **natural per-field alignment**: each field is
aligned to its own size, capped at the target pointer width (4 on the ILP32
targets, 8 on the LP64 x86-64/arm64 targets). So a 4-byte `integer` aligns to 4
on every target, while a pointer or 64-bit field aligns to 8 on LP64. The
pointer-width cap matters on LP64 because a pointer relocation must land on an
8-aligned offset (the Mach-O static linker rejects an unaligned one). `{$ALIGN
n}` lowers the cap for the records that follow it, down to `{$ALIGN 1}` for a
fully packed record. The record's own size is padded up to its alignment so an
array of records keeps every element aligned.

## Literals

| Form | Status |
|------|--------|
| Decimal integers | supported |
| Hex: `$FF`, `0xFF` | supported |
| Octal: `0o77` | supported |
| Binary: `0b1010` | supported |
| String: `'text'` | supported |
| Char: `#65`, `#$41` | supported |
| Real/float literals | **not implemented** |

## Comments

`{ block }`, `(* block *)`, and `// line` comments are all
supported.  Shebang lines (`#!/...`) are skipped.

## Grammar

Compact Pascal has no separate grammar specification file; the grammar is the
one the front end under `pascal/` parses. The EBNF below describes the
implemented subset (it omits the features listed as not implemented above). It
follows the usual conventions: `{ ... }` is zero or more, `[ ... ]` is optional,
`|` separates alternatives, and quoted text is literal.

```ebnf
program       = "program" ident [ "(" ident { "," ident } ")" ] ";"
                block "." ;

block         = { declaration } compound_stmt ;

declaration   = const_decl | type_decl | var_decl | proc_decl ;

const_decl    = "const" { ident [ ":" type ] "=" const_expr ";" } ;
type_decl     = "type" { ident "=" type ";" } ;
var_decl      = "var" { ident { "," ident } ":" type [ "=" const_expr ] ";" } ;

proc_decl     = ( "procedure" ident [ params ]
                | "function"  ident [ params ] ":" type ) ";"
                ( "forward" ";" | block ";" ) ;

params        = "(" param_group { ";" param_group } ")" ;
param_group   = [ "var" | "const" ] ident { "," ident } ":" type ;

type          = ident
              | "string" [ "[" const_expr "]" ]
              | "array" "[" subrange { "," subrange } "]" "of" type
              | "record" field_list "end"
              | "set" "of" type
              | "(" ident { "," ident } ")" ;         (* enumerated *)
subrange      = const_expr ".." const_expr ;
field_list    = field { ";" field } [ variant_part ] ;
field         = ident { "," ident } ":" type ;
variant_part  = "case" [ ident ":" ] ident "of"
                { const_expr { "," const_expr } ":" "(" field_list ")" ";" } ;

compound_stmt = "begin" [ statement { ";" statement } ] "end" ;

statement     = compound_stmt
              | lvalue ":=" expr
              | ident [ "(" [ expr { "," expr } ] ")" ]    (* proc call *)
              | "if" expr "then" statement [ "else" statement ]
              | "while" expr "do" statement
              | "for" ident ":=" expr ( "to" | "downto" ) expr "do" statement
              | "repeat" statement { ";" statement } "until" expr
              | "case" expr "of" case_arm { ";" case_arm }
                [ "else" statement { ";" statement } ] "end"
              | "with" lvalue { "," lvalue } "do" statement
              | "break" | "continue"
              | "exit" [ "(" expr ")" ] | "halt" [ "(" expr ")" ]
              | (* empty *) ;
case_arm      = const_expr { ( "," | ".." ) const_expr } ":" statement ;

lvalue        = ident { "." ident | "[" expr { "," expr } "]" } ;

expr          = simple_expr [ rel_op simple_expr ] ;
rel_op        = "=" | "<>" | "<" | "<=" | ">" | ">=" | "in" ;
simple_expr   = [ "+" | "-" ] term { add_op term } ;
add_op        = "+" | "-" | "or" | "xor" | "or" "else" ;
term          = factor { mul_op factor } ;
mul_op        = "*" | "/" | "div" | "mod" | "and" | "shl" | "shr"
              | "and" "then" ;
factor        = literal
              | lvalue
              | ident "(" [ expr { "," expr } ] ")"       (* func/cast call *)
              | "(" expr ")"
              | "not" factor
              | "[" [ set_elem { "," set_elem } ] "]" ;   (* set literal *)
set_elem      = expr [ ".." expr ] ;

literal       = integer | string | char | ident ;         (* ident: const/enum *)
```

## Summary of Major Gaps

These features are absent from the implementation and would require
substantial work to add:

1. **Floating point** (`real` type, math builtins) -- requires
   integrating the existing IR_F64 support into the Pascal front end
   and adding sin/cos/sqrt/trunc/round either as IR opcodes or
   runtime library calls.

2. **Pointers and dynamic allocation** (`^Type`, `@`, `new`,
   `dispose`) -- requires adding pointer type tracking to the type
   system, lowering dereferences to IR_LW/IR_SW, and providing a
   heap allocator in the runtime.

3. **File I/O** (`file of T`, `text`, assign/reset/rewrite/close) --
   requires file descriptor tracking in the runtime and new built-in
   procedure lowering.

4. **Modules** (`uses`, `unit`) -- requires separate compilation and
   a symbol import/export mechanism.
