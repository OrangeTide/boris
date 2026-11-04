{ Kobold-Pascal language front end (Pascal), single file. It is a complete
  compiler: a lexer, a recursive-descent parser that builds an AST, the
  semantic analyzer and type system, IR generation, and the KPM1 module
  writer. See doc/languages/kobold/kp-grammar.md. }

program kpcom;

{$mode objfpc}{$H+}

{$IFNDEF KOBOLD}
uses SysUtils;   { FindFirst/FindNext for the `uses ns.*` wildcard under the fpc bootstrap }
{$ENDIF}

{ ---- Constants ---- }

const
  KP_VERSION = {$I version.inc};   { 'vX.Y.Z', written by the Makefile }
  KP_STDLIB  = {$I stdlib.inc};    { default unit search dir, written by the Makefile }

{ ---- Types ---- }

type
  TTokenKind = (
    tkEOF,
    { literals and identifiers }
    tkIdent, tkIntLit, tkRealLit, tkStrLit, tkInterpStr,
    { reserved words (doc/languages/kobold/kp-grammar.md) }
    tkAnd, tkAsm, tkArray, tkBegin, tkBreak, tkCase, tkConst, tkContinue, tkDefer, tkDiv,
    tkDo, tkDownto, tkElse, tkEnd, tkExternal, tkFor, tkForward, tkFunction,
    tkIf, tkIn, tkInterface, tkMod, tkNil, tkNot, tkOf, tkOr, tkProcedure,
    tkProgram, tkRecord, tkRepeat, tkStart, tkSet, tkBind, tkString, tkThen,
    tkTo, tkType, tkUntil, tkVar, tkWhile, tkWith, tkYield,
    { threaded-code dispatch: `label` value type, `goto` computed jump
      (doc/languages/kobold/kp-grammar.md, the `label` type) }
    tkGoto, tkLabel,
    { the units surface (doc/languages/kobold/kp-units.md), implemented; `property` is the
      uniform-access feature (doc/languages/kobold/kp-property.md), also implemented }
    tkImplementation, tkProperty, tkShared, tkUnit, tkUses, tkReexport, tkAs,
    { `ref array of T` is the reference (shared) dynamic array; `buffer of T` is its
      host-backed sibling. `slice` stays reserved for a future windowed view (a[lo..hi]). }
    tkRef, tkSlice, tkBuffer,
    { `map of T` is the string-keyed associative array (doc/languages/kobold/kp-language.md) }
    tkMap,
    { guest-record trait conformance: `implement I for R` (doc/languages/kobold/kp-units.md) }
    tkImplement,
    { punctuation and operators }
    tkAssign, tkColon, tkSemicolon, tkComma, tkDot, tkDotDot,
    tkUnderscore, tkAt,
    tkLParen, tkRParen, tkLBracket, tkRBracket,
    tkEq, tkNeq, tkLt, tkLe, tkGt, tkGe,
    tkPlus, tkMinus, tkStar, tkSlash,
    { the bitwise shift keywords }
    tkShl, tkShr
  );

  TTokenSet = set of TTokenKind;

  TToken = record
    Kind: TTokenKind;
    Line, Col: LongInt;
    IntVal: Int64;      { tkIntLit }
    RealVal: Double;    { tkRealLit }
    StrVal: string;     { decoded value of tkStrLit; text of tkIdent }
    Text: string;       { the raw lexeme, for diagnostics and dumps }
  end;

  TKeyword = record
    Name: string;       { lowercase spelling }
    Kind: TTokenKind;
  end;

  { A little-endian base-2^16 natural number, used only to convert a real
    literal's decimal text to its IEEE-754 binary64 bit pattern in integer
    arithmetic. Going through a host Double would give the wrong answer on the
    single-float sandbox tier (Double is f32 there), so the conversion never
    touches a real: the emitted bits are identical on every tier. 120 limbs
    (1920 bits) covers the full binary64 exponent range with margin. }
  TBig = record
    n: LongInt;                 { count of significant limbs }
    d: array[0..119] of LongInt;{ base 65536, little-endian }
  end;

  { Abstract syntax tree. Nodes live in a pool and reference each other by
    index (a NodeId; -1 means none). A node has up to four fixed child slots
    (A..D) plus a variable child list (Kids), which is enough for every
    production without a distinct record per kind. Each kind's slot layout is
    documented at its constructor in the parser. }
  TNodeKind = (
    nkProgram, nkBlock,
    nkConstDecl, nkTypeDecl, nkVarDecl, nkProcDecl, nkFuncDecl, nkParam,
    nkReceiver,
    nkTypeRef, nkEnumType, nkSubrange, nkArrayType, nkRecordType, nkFieldDecl,
    nkVariantPart, nkVariant, nkCaseLabelList, nkCaseLabel, nkSetType,
    nkMapType,
    nkInterfaceType, nkInterfaceField, nkProcType,
    nkCompound, nkEmpty, nkAssign, nkCallStmt, nkIf, nkWhile, nkFor, nkRepeat,
    nkCase, nkCaseElement, nkWith, nkBreak, nkContinue, nkStart, nkYield,
    nkBind,
    { threaded-code dispatch (doc/languages/kobold/kp-grammar.md, the `label` type):
      nkLabelStmt is a `name:` labeled statement, nkGoto a computed `goto EXPR`,
      nkLabelAddr an `@name` label-address expression }
    nkLabelStmt, nkGoto, nkLabelAddr,
    nkBinary, nkUnary, nkIntLit, nkRealLit, nkStrLit, nkNil, nkIdent,
    nkField, nkIndex, nkCall, nkSetConstructor, nkSetElement, nkAggregate,
    nkRecordLit, nkFieldInit,
    { compilation-unit surface (doc/languages/kobold/kp-units.md) }
    nkUnit, nkUses, nkUsesItem, nkImportItem,
    nkInterface, nkImplementation, nkReexport, nkReexportItem,
    { guest-record trait conformance: `implement I for R;` (doc/languages/kobold/kobold.md) }
    nkImplement,
    { failable call-site forms (doc/languages/kobold/kp-errors.md): the `fails [e]` postfix test, the
      `or else EXPR` / `or else ignore` recover, and the `or exit|break|continue|fail` divert }
    nkFailsTest, nkOrElse, nkOrDivert,
    { accessor-backed value with uniform access (doc/languages/kobold/kp-property.md) }
    nkPropertyDecl,
    { `defer STMT`: block-scoped teardown run LIFO on orderly scope exit
      (doc/languages/kobold/kp-defer.md) }
    nkDefer,
    { the to-string wrapper the string-interpolation expansion puts around each
      hole expression (doc/languages/kobold/kp-language.md) }
    nkToStr,
    { `for x in e do` and `for k, v in m do`: iterate an array, string, map, set,
      or a cursor type (doc/languages/kobold/kp-foreach.md) }
    nkForIn,
    { `asm('text')`: basic inline assembly, emitted verbatim (AOT only)
      (doc/languages/kobold/kp-grammar.md). nkAsmOp is one extended-asm operand or
      clobber, a child of nkAsm: Text holds the constraint string (or the clobber's
      register name), A the operand expression (or -1 for a clobber), Flag the role
      (0 input, 1 output, 2 inout, 3 clobber). }
    nkAsm, nkAsmOp
  );

  TNode = record
    Kind: TNodeKind;
    Line, Col: LongInt;
    A, B, C, D: LongInt;      { fixed child slots, -1 if unused }
    Kids: array of LongInt;   { variable-length children }
    Text: string;             { name, string value, or operator lexeme }
    IntVal: Int64;            { nkIntLit }
    RealVal: Double;          { nkRealLit }
    Op: TTokenKind;           { nkBinary / nkUnary operator }
    Flag: LongInt;            { small per-kind flag (mode, downto, body kind) }
    CConv: LongInt;           { proc/func decl: 1 for the cdecl calling convention }
    Exported: LongInt;        { proc/func decl: 1 when marked `export` (a module entry) }
    Failable: LongInt;        { proc/func decl: 1 when marked `fails` (returns a second error) }
    Sym: LongInt;             { resolved symbol for an identifier, or -1 (set by sema) }
    Ty: LongInt;              { result type of an expression, or -1 (set by sema) }
  end;

  { Semantic types. Each declared or built-in type is an entry in a table,
    referenced by a TypeId (index; -1 means none/unknown). }
  TSemKind = (
    skError, skVoid, skInteger, skReal, skBoolean, skChar, skString,
    skProcess, skNil, skEnum, skSubrange, skArray, skRecord, skSet,
    skInterface, skProc, skMap, skMapIter, skErrorVal,
    { the code-address value type of the threaded-dispatch primitive
      (doc/languages/kobold/kp-grammar.md, the `label` type); second-class }
    skLabel
  );

  TSemType = record
    Kind: TSemKind;
    Name: string;               { for built-in and named types, in diagnostics }
    Base: LongInt;              { subrange base, set base, or array element }
    Lo, Hi: Int64;              { subrange bounds }
    Names: array of string;     { enum literals, record fields, or interface methods }
    Subs: array of LongInt;     { record field types, interface method types, array index types }
    MemberOff: array of LongInt; { record field byte offsets; variants overlay at one offset }
    PropGet: array of string;   { computed-field getter method name per member, else '' }
    PropSet: array of string;   { computed-field setter method name per member, else '' (read-only) }
    ParamTypes: array of LongInt;
    ParamModes: array of LongInt;  { 0 value, 1 var, 2 const }
    RetType: LongInt;           { -1 for a procedure }
    Failable: Boolean;          { a routine marked `fails`: returns an error in a second register }
    Variadic: Boolean;          { a built-in that accepts any arguments }
    FloatBits: LongInt;         { a real's storage width: 32 for single, else 64 (double) }
    IntBits: LongInt;           { an integer's storage width: 64 for int64, else 32 }
    Size: LongInt;              { explicit byte size, or -1 to compute from the layout }
    Align: LongInt;             { explicit byte alignment, or -1 to compute }
    Opaque: Boolean;            { an exported record whose fields are hidden from consumers }
    HostBuf: Boolean;           { a `buffer of T`: a shared dynamic array whose element backing is
                                  host-owned, so ARC never frees it and it is not eager-copied }
    Rank: LongInt;              { a buffer's dimension count: 1 for `buffer of T`, 2 for
                                  `buffer[,] of T`, etc. 0/1 for any non-buffer dynamic array }
    FromUnit: string;           { the dependency unit an imported type was read from, else '' }
  end;

  TSymKind = (
    syConst, syVar, syType, syProc, syFunc, syParam, syEnumLit, syProgram
  );

  TSym = record
    Name: string;               { original case; matched case-insensitively }
    LowerName: string;          { Name pre-lowercased, for the O(1) symbol index }
    Kind: TSymKind;
    TypeId: LongInt;            { value type, or the type a syType names }
    Ordinal: Int64;             { enum literal ordinal, or const integer value }
    ConstStr: string;           { const string value }
    ConstIsStr: Boolean;
    ConstAggName: string;        { for an aggregate (array) constant: its read-only global }
    ConstGName: string;          { for a scalar named const: its module-local read-only global,
                                   created on first value read (the backend folds the load back
                                   to an immediate and drops the global if nothing else uses it) }
    Node: LongInt;              { defining AST node, or -1 }
    Scope: LongInt;
    Captures: Boolean;          { a routine that reads an enclosing local }
    Slot: LongInt;              { local slot index for a param/local, or -1 (set by lowering) }
    BodyScope: LongInt;         { a routine's body scope, or -1 (set by sema) }
    WithBase: LongInt;          { for a `with` field alias: the record base designator node, else -1 }
    ParamMode: LongInt;         { for a syParam: 0 value, 1 var, 2 const, 3 out }
    Used: Boolean;              { referenced by name after declaration (set in Lookup) }
    Read: Boolean;              { its value is read somewhere (set at an rvalue use); a var that is
                                  Used but not Read was only ever assigned, never read back }
    Warnable: Boolean;          { a real var declaration eligible for the unused warning }
    Imported: Boolean;          { from another unit's interface: a cross-unit link symbol }
    LinkName: string;           { the external (export) name for emission, when it differs
                                  from Name (a renamed import); '' means use Name }
    LinkConst: Boolean;         { a link-time constant: its value is resolved at link (patched
                                  to an immediate), not baked into consumers. A unit declares it
                                  value-less in its interface and supplies the value in the
                                  implementation (doc/languages/kobold/kp-units.md). Not usable in a constant
                                  position, since it has no compile-time value. }
    LinkPending: Boolean;       { a link-time const declared in the interface, not yet completed
                                  by the implementation's value. }
    BinderVar: Boolean;         { a `fails e` error binder: always lives in a local slot, never a
                                  global cell, even when introduced at program scope (kp-errors.md) }
    DisambDone: Boolean;        { EmittedRoutineName has resolved this routine's overload suffix }
    DisambName: string;         { cached overload-disambiguated emit name, or '' for no suffix }
  end;

  TIntArray = array of LongInt;
  TInt64Array = array of Int64;       { a typed word-array global's init values }
  TSetWords = array[0..3] of Int64;   { a set value's up to four 64-bit words }

  TScope = record
    Parent: LongInt;
    Members: array of LongInt;  { symbol ids declared in this scope }
  end;

  TConstVal = record
    Ok: Boolean;
    IsStr: Boolean;
    IsReal: Boolean;
    I: Int64;
    RBits: Int64;    { the f64 bit pattern when IsReal, sign already applied }
    S: string;
    Ty: LongInt;
  end;

  { The target ABI the front end compiles for. It is established once at every
    compilation entry (the native driver from its target selection, the `compile`
    export from its caller's target) and never defaulted at the point of use, so a
    type's size is a static property of the target the way cc's is. Pointer and
    handle types size and lower from PtrBytes, which is what makes record layout
    and pointer-versus-integer IR follow the target. Room to grow: endianness and
    the long-integer width would join it. }
  TTarget = record
    PtrBytes: LongInt;   { guest pointer/handle width: 4 (ILP32: rv32/cf/mips)
                           or 8 (LP64: x86-64/arm64) }
    Arch: string;        { the target architecture this binary compiles for:
                           'rv32', 'cf', 'x86-64', 'arm64', baked at build time
                           from a KP_TARGET_* define. A unit is bound to one Arch
                           (not just one width), so the KPM header stamps it and
                           the reader rejects a cross-arch module. Empty when the
                           binary was built without a target define (the width tag
                           is then emitted, the legacy behaviour). }
  end;

const
  { The guest pointer/handle width this compiler binary was built for, baked at
    build time the way cc's CC_PTR_SIZE is. It derives from the target
    architecture: skj-pc (or fpc) compiles kpcom with -d KP_TARGET_X64 or
    -d KP_TARGET_ARM64 for an LP64 backend (8 bytes), and -d KP_TARGET_RV or
    -d KP_TARGET_CF for an ILP32 backend (4 bytes). The width is a static
    property of the binary, Plan 9 style: one front end per backend, native
    width, no cross flag. }
{$IFDEF KP_TARGET_X64}
  KpNativePtrBytes = 8;
{$ELSE}
  {$IFDEF KP_TARGET_ARM64}
  KpNativePtrBytes = 8;
  {$ELSE}
  KpNativePtrBytes = 4;
  {$ENDIF}
{$ENDIF}

{ ---- Lookup tables ---- }

const
  { Printable name per token kind, in enum order. Used by the token dump. }
  TokenName: array[TTokenKind] of string = (
    'tkEOF',
    'tkIdent', 'tkIntLit', 'tkRealLit', 'tkStrLit', 'tkInterpStr',
    'tkAnd', 'tkAsm', 'tkArray', 'tkBegin', 'tkBreak', 'tkCase', 'tkConst', 'tkContinue', 'tkDefer',
    'tkDiv', 'tkDo', 'tkDownto', 'tkElse', 'tkEnd', 'tkExternal', 'tkFor',
    'tkForward', 'tkFunction', 'tkIf', 'tkIn', 'tkInterface', 'tkMod', 'tkNil',
    'tkNot', 'tkOf', 'tkOr', 'tkProcedure', 'tkProgram', 'tkRecord', 'tkRepeat',
    'tkStart', 'tkSet', 'tkBind', 'tkString', 'tkThen', 'tkTo', 'tkType',
    'tkUntil', 'tkVar', 'tkWhile', 'tkWith', 'tkYield',
    'tkGoto', 'tkLabel',
    'tkImplementation', 'tkProperty', 'tkShared', 'tkUnit', 'tkUses',
    'tkReexport', 'tkAs',
    'tkRef', 'tkSlice', 'tkBuffer', 'tkMap', 'tkImplement',
    'tkAssign', 'tkColon', 'tkSemicolon', 'tkComma', 'tkDot', 'tkDotDot',
    'tkUnderscore', 'tkAt',
    'tkLParen', 'tkRParen', 'tkLBracket', 'tkRBracket',
    'tkEq', 'tkNeq', 'tkLt', 'tkLe', 'tkGt', 'tkGe',
    'tkPlus', 'tkMinus', 'tkStar', 'tkSlash',
    'tkShl', 'tkShr'
  );

  KeywordCount = 58;
  Keywords: array[1..KeywordCount] of TKeyword = (
    (Name: 'and';       Kind: tkAnd),
    (Name: 'array';     Kind: tkArray),
    (Name: 'as';        Kind: tkAs),
    (Name: 'asm';       Kind: tkAsm),
    (Name: 'begin';     Kind: tkBegin),
    (Name: 'bind';      Kind: tkBind),
    (Name: 'break';     Kind: tkBreak),
    (Name: 'buffer';    Kind: tkBuffer),
    (Name: 'case';      Kind: tkCase),
    (Name: 'const';     Kind: tkConst),
    (Name: 'continue';  Kind: tkContinue),
    (Name: 'defer';     Kind: tkDefer),
    (Name: 'div';       Kind: tkDiv),
    (Name: 'do';        Kind: tkDo),
    (Name: 'downto';    Kind: tkDownto),
    (Name: 'else';      Kind: tkElse),
    (Name: 'end';       Kind: tkEnd),
    (Name: 'external';  Kind: tkExternal),
    (Name: 'for';       Kind: tkFor),
    (Name: 'forward';   Kind: tkForward),
    (Name: 'function';  Kind: tkFunction),
    (Name: 'goto';      Kind: tkGoto),
    (Name: 'if';        Kind: tkIf),
    (Name: 'implement';  Kind: tkImplement),
    (Name: 'implementation'; Kind: tkImplementation),
    (Name: 'in';        Kind: tkIn),
    (Name: 'interface'; Kind: tkInterface),
    (Name: 'label';     Kind: tkLabel),
    (Name: 'map';       Kind: tkMap),
    (Name: 'mod';       Kind: tkMod),
    (Name: 'nil';       Kind: tkNil),
    (Name: 'not';       Kind: tkNot),
    (Name: 'of';        Kind: tkOf),
    (Name: 'or';        Kind: tkOr),
    (Name: 'procedure'; Kind: tkProcedure),
    (Name: 'program';   Kind: tkProgram),
    (Name: 'property';   Kind: tkProperty),
    (Name: 'record';    Kind: tkRecord),
    (Name: 'reexport';  Kind: tkReexport),
    (Name: 'ref';       Kind: tkRef),
    (Name: 'repeat';    Kind: tkRepeat),
    (Name: 'set';       Kind: tkSet),
    (Name: 'shared';    Kind: tkShared),
    (Name: 'shl';       Kind: tkShl),
    (Name: 'shr';       Kind: tkShr),
    (Name: 'slice';     Kind: tkSlice),
    (Name: 'start';     Kind: tkStart),
    (Name: 'string';    Kind: tkString),
    (Name: 'then';      Kind: tkThen),
    (Name: 'to';        Kind: tkTo),
    (Name: 'type';      Kind: tkType),
    (Name: 'unit';      Kind: tkUnit),
    (Name: 'until';     Kind: tkUntil),
    (Name: 'uses';      Kind: tkUses),
    (Name: 'var';       Kind: tkVar),
    (Name: 'while';     Kind: tkWhile),
    (Name: 'with';      Kind: tkWith),
    (Name: 'yield';     Kind: tkYield)
  );

  { Printable name per node kind, in enum order. Used by the AST dump. }
  NodeKindName: array[TNodeKind] of string = (
    'Program', 'Block',
    'ConstDecl', 'TypeDecl', 'VarDecl', 'ProcDecl', 'FuncDecl', 'Param',
    'Receiver',
    'TypeRef', 'EnumType', 'Subrange', 'ArrayType', 'RecordType', 'FieldDecl',
    'VariantPart', 'Variant', 'CaseLabelList', 'CaseLabel', 'SetType',
    'MapType',
    'InterfaceType', 'InterfaceField', 'ProcType',
    'Compound', 'Empty', 'Assign', 'CallStmt', 'If', 'While', 'For', 'Repeat',
    'Case', 'CaseElement', 'With', 'Break', 'Continue', 'Start', 'Yield',
    'Bind',
    'LabelStmt', 'Goto', 'LabelAddr',
    'Binary', 'Unary', 'IntLit', 'RealLit', 'StrLit', 'Nil', 'Ident',
    'Field', 'Index', 'Call', 'SetConstructor', 'SetElement', 'Aggregate',
    'RecordLit', 'FieldInit',
    'Unit', 'Uses', 'UsesItem', 'ImportItem',
    'Interface', 'Implementation', 'Reexport', 'ReexportItem',
    'Implement',
    'FailsTest', 'OrElse', 'OrDivert',
    'PropertyDecl', 'Defer', 'ToStr', 'ForIn', 'Asm', 'AsmOp'
  );

  { Token-kind sets the parser tests against. }
  RelOps:       set of TTokenKind = [tkEq, tkNeq, tkLt, tkGt, tkLe, tkGe, tkIn];
  AddOps:       set of TTokenKind = [tkPlus, tkMinus, tkOr];
  MulOps:       set of TTokenKind =
    [tkStar, tkSlash, tkDiv, tkMod, tkAnd, tkShl, tkShr];
  DeclStart:    set of TTokenKind =
    [tkConst, tkType, tkVar, tkProcedure, tkFunction, tkImplement, tkProperty];
  StmtStart:    set of TTokenKind =
    [tkBegin, tkIf, tkWhile, tkFor, tkRepeat, tkCase, tkWith, tkStart, tkBind,
     tkYield, tkBreak, tkContinue, tkDefer, tkGoto, tkAsm, tkIdent];
  StmtTerm:     set of TTokenKind = [tkEnd, tkUntil, tkEOF];
  ExprStart:    set of TTokenKind =
    [tkIntLit, tkRealLit, tkStrLit, tkInterpStr, tkNil, tkLParen, tkNot, tkLBracket,
     tkStart, tkBind, tkYield, tkIdent, tkPlus, tkMinus, tkAt];

{ ---- Global variables ---- }

var
  { Scanner state }
  Src: string;          { whole source buffer, 1-based }
  SrcLen: LongInt;
  Pos: LongInt;         { index of the next unread char, 1..SrcLen+1 }
  CurLine, CurCol: LongInt;
  SrcName: string;      { file name, for diagnostics }
  Tok: TToken;          { the current token, filled by NextToken }
  ErrCount: LongInt;    { lexical errors seen across all inputs }

  { Conditional compilation ($IFDEF/$IFNDEF/$ELSE/$ENDIF/$DEFINE/$UNDEF). Defines holds
    the lowercased defined symbols; each open $IF pushes a frame while the lexer scans. }
  Defines: array of string;
  CondActiveStk, CondTakenStk: array of Boolean;
  CondTop: LongInt;

  { Symbols defined on the command line (-D). InitScanner resets Defines per file,
    so these are re-applied there after the built-in 'kobold' symbol. }
  CmdDefines: array of string;

  { Parser state }
  Nodes: array of TNode;  { the AST node pool }
  NodeCount: LongInt;

  { Semantic analysis state }
  SemTypes: array of TSemType;
  SemCount: LongInt;
  Syms: array of TSym;
  SymCount: LongInt;
  Scopes: array of TScope;
  ScopeCount: LongInt;
  CurScope: LongInt;
  { Symbol membership index: a hash over (scope, lowercased name) -> membership entries, so a
    by-name lookup in a scope is O(1) instead of a linear scan of the scope's member list. It is
    kept in lockstep with every Scopes[].Members append (AddMember) and the single rollback
    (RemoveLastMember). Scope ids are permanent for a compile, so entries never go stale. }
  SymIdxBucket: array of LongInt;   { bucket heads (entry ids), -1 when empty }
  SymIdxMask: LongInt;              { bucket count - 1 (bucket count is a power of two) }
  SymIdxSym: array of LongInt;      { entry -> symbol id }
  SymIdxScope: array of LongInt;    { entry -> scope id }
  SymIdxPos: array of LongInt;      { entry -> its position in that scope's Members list }
  SymIdxNext: array of LongInt;     { entry -> next entry in the same bucket }
  SymIdxCount: LongInt;             { number of membership entries in use }
  LoopDepth: LongInt;     { > 0 inside a loop, for break/continue }
  { Per-routine label table for threaded dispatch (the `name:` / `@name` / `goto`
    surface). Entries are scoped to the current routine by LabelBase: a nested
    routine raises LabelBase to the current count on entry and restores it on
    exit, so @name and a label definition only ever see the current routine's
    labels. Used in both passes: sema sets LabelDefd (name resolution and the
    second-class checks), lowering sets LabelIrId (name -> IR label id, shared by
    the label definition and every @name so forward references resolve). }
  LabelBase, LabelCount: LongInt;
  LabelNames: array of string;
  LabelIrId: array of LongInt;
  LabelDefd: array of Boolean;
  LabelNode: array of LongInt;   { the node that first mentioned the label, for diagnostics }
  CurFailable: Boolean;   { true while analyzing a failable routine's body, for `or fail` / `fail` }
  FailTargetNode: LongInt;{ the call node currently analyzed as a fail-form target, for must-consume }
  StartDepth: LongInt;    { > 0 inside a start body, for yield/bind }
  AnswerType: LongInt;    { the answer type of the innermost start, -1 if unset }
  CurFuncSym: LongInt;    { the enclosing function symbol, for result assignment }
  CurRoutineSym: LongInt; { the routine whose body is being analyzed, or -1 }
  CurRoutineScope: LongInt; { that routine's body scope, for capture detection }
  AnalyzingInterface: Boolean; { true while analyzing a unit's interface declarations, so a
                                 value-less const there is taken as a link-time constant }
  StrConstArrays: array of LongInt;   { symbols of string constant arrays, filled in main }
  StrConstArrayCount: LongInt;
  RecConstArrays: array of LongInt;   { symbols of record constant arrays, filled in main }
  RecConstArrayCount: LongInt;
  GlobalScope: LongInt;   { the program/global scope; its vars become IR globals }
  SystemScope: LongInt;   { the outer scope holding predefined names (built-ins, base types),
                            which a user declaration shadows; used to warn on that shadowing }
  { Cross-unit resolution (doc/languages/kobold/kp-units.md). UnitPath holds the -U dependency search
    directories; UnitSrcDir is the directory of the source being compiled, searched first.
    CompilingUnitName is the unit under compilation, so a self-use reads as a cycle. }
  UnitPath: array of string;
  MainFiles: array of string;   { driver input files, compiled after the argument scan }
  UnitSrcDir: string;
  CompilingUnitName: string;
  { The loaded dependency interfaces, keyed by name (case-insensitive). UUScope is the
    detached scope holding a unit's exported symbols; UUState marks a unit unloaded (0),
    on the current resolution stack (1, a back-edge to it is a cycle), or done (2). }
  UUCount: LongInt;
  UUName: array of string;
  UUScope: array of LongInt;
  UUFingerprint: array of Int64;
  UUState: array of LongInt;
  { The consumer's own qualifier map: a qualifier (unit name, an `as` alias) resolves a
    dotted reference to that unit's export scope. A bare (`as _`) import instead aliases the
    exported symbols straight into the global scope, so no qualifier entry is made. }
  QCount: LongInt;
  QName: array of string;
  QScope: array of LongInt;
  { The consumer's direct dependencies and the fingerprint each was seen at, emitted as
    `.uses` lines so a later link can detect a stale interface and traverse the graph. }
  DepCount: LongInt;
  DepName: array of string;
  DepFingerprint: array of Int64;
  { Symbols this unit re-exports from a dependency: promoted into its own interface so a
    consumer can name them without using that dependency directly (doc/languages/kobold/kp-units.md). }
  ReexportCount: LongInt;
  ReexportSym: array of LongInt;
  { methods attached to a type by a receiver: parallel arrays }
  MethRecv: array of LongInt;
  MethName: array of string;
  MethSig: array of LongInt;
  MethSym: array of LongInt;   { the routine symbol, so an imported method reaches its link name }
  MethCount: LongInt;
  { built-in type ids, set by InitSema }
  tyErr, tyVoid, tyInt, tyReal, tyBool, tyChar, tyStr, tyProcess, tyNil: LongInt;
  tySingle: LongInt;    { single-precision real; tyReal is double }
  tyInt64: LongInt;     { 64-bit integer; tyInt is 32-bit }
  tyText: LongInt;      { a text stream; Output and ErrOutput are its only values }
  tyMapIter: LongInt;   { a map iterator handle, produced by MapFirst, advanced by MapNext }
  tyLabel: LongInt;     { the `label` code-address value type; second-class, @name makes it,
                          computed `goto` consumes it (doc/languages/kobold/kp-grammar.md) }
  tyErrorVal: LongInt;  { the language `error` type for failable routines; opaque, an i32 code
                          for now (0 = success), built by fail() and read by code(). Distinct
                          from tyErr, the compiler's internal bottom type. See doc/languages/kobold/kp-errors.md }

  { Driver options }
  OptVerbose: Boolean;
  OptDump: Boolean;       { -d: dump the token stream }
  OptDumpAst: Boolean;    { --dump-ast: dump the parse tree }
  OptEmitKpm: Boolean;    { --emit-kpm: lower and write the KPM1 module }
  OptDebug: Boolean;      { -g: emit .file and per-statement LOC debug markers }
  OptOut: string;         { -o target; recorded but unused until codegen exists }
  CurTarget: TTarget;     { the active target ABI; see TTarget. Set at every
                            compilation entry, read by all type sizing }

  { Compiler directive state, toggled by the R and Q switches (R+/R-, Q+/Q-) as the
    lexer scans them. The trusted-now default is off. The value in effect at a
    construct's source position governs whether it is checked. }
  OptRangeChecks: Boolean;    { R+: array index bounds, raising INDEX_RANGE }
  OptOverflowChecks: Boolean; { Q+: checked arithmetic, raising OVERFLOW }

{ ---- Character helpers (ASCII only, per the grammar) ---- }

function ToLowerCh(c: Char): Char;
begin
  if (c >= 'A') and (c <= 'Z') then
    ToLowerCh := Chr(Ord(c) + 32)
  else
    ToLowerCh := c;
end;

function LowerStr(const s: string): string;
var
  i: LongInt;
  r: string;
begin
  { Accumulate into a plain local, not the function-result pseudo-var: a local
    `r := r + ch` is the self-append idiom the lowering grows in place
    (kp_str_append_char, amortized O(n) with capacity doubling), while the
    result name is excluded from that fast path and would allocate per char. }
  r := '';
  for i := 1 to Length(s) do
    r := r + ToLowerCh(s[i]);
  LowerStr := r;
end;

function SameTextCI(const a, b: string): Boolean;
{ Case-insensitive string equality with no allocation: the zero-garbage way to
  compare an identifier against a keyword or another name, where LowerStr would
  allocate (and churn the heap) only to be compared and discarded. }
var
  i, n: LongInt;
begin
  n := Length(a);
  if n <> Length(b) then begin
    SameTextCI := False;
    Exit;
  end;
  for i := 1 to n do
    if ToLowerCh(a[i]) <> ToLowerCh(b[i]) then begin
      SameTextCI := False;
      Exit;
    end;
  SameTextCI := True;
end;

{ ---- Per-routine label table (threaded-dispatch primitive) ---- }

function LabelFind(const name: string): LongInt;
{ the label of this name in the current routine, or -1 (case-insensitive,
  searching only [LabelBase, LabelCount) so a nested routine cannot see an
  outer label) }
var
  i: LongInt;
begin
  LabelFind := -1;
  for i := LabelBase to LabelCount - 1 do
    if SameTextCI(LabelNames[i], name) then begin LabelFind := i; Exit; end;
end;

function LabelIntern(const name: string; node: LongInt): LongInt;
{ the label of this name in the current routine, creating the entry (with no
  IR id yet and undefined) if it is the first mention; node is recorded for a
  diagnostic when the label turns out never to be defined }
begin
  LabelIntern := LabelFind(name);
  if LabelIntern >= 0 then Exit;
  if LabelCount > High(LabelNames) then begin
    SetLength(LabelNames, LabelCount * 2 + 8);
    SetLength(LabelIrId, LabelCount * 2 + 8);
    SetLength(LabelDefd, LabelCount * 2 + 8);
    SetLength(LabelNode, LabelCount * 2 + 8);
  end;
  LabelNames[LabelCount] := name;
  LabelIrId[LabelCount] := -1;
  LabelDefd[LabelCount] := False;
  LabelNode[LabelCount] := node;
  LabelIntern := LabelCount;
  Inc(LabelCount);
end;

function TypeMentionsLabel(ty: LongInt): Boolean;
{ true when ty is the `label` type or a container (array/buffer/map/set) whose
  element is label-bearing. It does not recurse through a record, because a
  record field that mentions label is rejected when that record is declared, so
  a record is always label-free by the time it is named here (this also keeps a
  recursive record type from looping). Used to keep a label value second-class:
  it may be only a local variable or a routine-local array of label, never a
  global, a field, a parameter, a return, or a map/set element. }
begin
  TypeMentionsLabel := False;
  if (ty < 0) or (ty >= SemCount) then Exit;
  case SemTypes[ty].Kind of
    skLabel: TypeMentionsLabel := True;
    skArray, skMap, skSet: TypeMentionsLabel := TypeMentionsLabel(SemTypes[ty].Base);
  end;
end;

{ The last segment of a dotted unit name is its default qualifier: core.strings
  comes in as strings.  A flat name is its own last segment. }
function LastSegment(const s: string): string;
var
  i: LongInt;
begin
  LastSegment := s;
  for i := Length(s) downto 1 do
    if s[i] = '.' then begin
      LastSegment := Copy(s, i + 1, Length(s) - i);
      Exit;
    end;
end;

{ A dotted unit name maps its dots to path separators when it is resolved to a
  file: io.files is found as <dir>/io/files.kpm (doc/languages/kobold/kp-units.md). }
function DotToSlash(const s: string): string;
var
  i: LongInt;
begin
  DotToSlash := '';
  for i := 1 to Length(s) do
    if s[i] = '.' then DotToSlash := DotToSlash + '/'
    else DotToSlash := DotToSlash + s[i];
end;

function IsDigit(c: Char): Boolean;
begin
  IsDigit := (c >= '0') and (c <= '9');
end;

function IsHexDigit(c: Char): Boolean;
begin
  IsHexDigit := IsDigit(c)
    or ((c >= 'a') and (c <= 'f'))
    or ((c >= 'A') and (c <= 'F'));
end;

function IsAlpha(c: Char): Boolean;
begin
  IsAlpha := ((c >= 'a') and (c <= 'z')) or ((c >= 'A') and (c <= 'Z'));
end;

function IsIdentTail(c: Char): Boolean;
begin
  IsIdentTail := IsAlpha(c) or IsDigit(c) or (c = '_');
end;

function IsSpace(c: Char): Boolean;
begin
  IsSpace := (c = ' ') or (c = #9) or (c = #10) or (c = #13)
    or (c = #11) or (c = #12);
end;

function HexVal(c: Char): LongInt;
begin
  if IsDigit(c) then HexVal := Ord(c) - Ord('0')
  else HexVal := (Ord(ToLowerCh(c)) - Ord('a')) + 10;
end;

{ ---- Error reporting ---- }

procedure DiagExcerpt(line, col: LongInt);
{ Print the offending source line and a caret under the reported column, in the
  gcc/clang style, so a diagnostic points at the code and not just a line:col. A tab
  in the leading text is copied into the caret padding, so the caret stays aligned in
  a terminal. Prints nothing when the location falls outside the source. }
var
  i, ls, le, n: LongInt;
  pad: string;
begin
  if (line < 1) or (Src = '') then Exit;
  { walk to the start of the target line }
  ls := 1; n := 1;
  while (ls <= SrcLen) and (n < line) do begin
    if Src[ls] = #10 then Inc(n);
    Inc(ls);
  end;
  if n < line then Exit;   { the line is past the end of the source }
  { the line runs to the next newline or carriage return, exclusive }
  le := ls;
  while (le <= SrcLen) and (Src[le] <> #10) and (Src[le] <> #13) do Inc(le);
  WriteLn(ErrOutput, Copy(Src, ls, le - ls));
  pad := '';
  i := ls;
  while i < ls + col - 1 do begin
    if (i <= SrcLen) and (Src[i] = #9) then pad := pad + #9
    else pad := pad + ' ';
    Inc(i);
  end;
  WriteLn(ErrOutput, pad, '^');
end;

procedure EmitDiag(line, col: LongInt; const severity, code, msg: string);
{ Emit one diagnostic: the `file:line:col: <severity>[<code>]: <msg>` header and the source
  excerpt. Every error and warning goes through here so their form stays uniform. The code is a
  stable machine-readable class (E#### for an error, W#### for a warning; see kp-diagnostics.md)
  that a host or an editor can filter or link on without parsing the message text. Pending stdout
  is flushed first so a diagnostic interleaves in program order even when stdout and stderr share
  a destination. }
begin
  Flush(Output);
  WriteLn(ErrOutput, SrcName, ':', line, ':', col, ': ', severity, '[', code, ']: ', msg);
  DiagExcerpt(line, col);
  Flush(ErrOutput);
end;

procedure LexError(line, col: LongInt; const msg: string);
begin
  EmitDiag(line, col, 'error', 'E0001', msg);
  Inc(ErrCount);
end;

{ ---- Scanner ---- }

function CurCh: Char;
begin
  if Pos <= SrcLen then CurCh := Src[Pos] else CurCh := #0;
end;

function PeekCh(k: LongInt): Char;
begin
  if Pos + k <= SrcLen then PeekCh := Src[Pos + k] else PeekCh := #0;
end;

procedure Adv;
{ Consume one char and track the source position. A bare CR is zero-width for
  column counting; LF ends a line. }
begin
  if Pos <= SrcLen then begin
    if Src[Pos] = #10 then begin
      Inc(CurLine);
      CurCol := 1;
    end
    else if Src[Pos] <> #13 then
      Inc(CurCol);
    Inc(Pos);
  end;
end;

function CondCompiling: Boolean;
{ True when the current source region is being compiled: no open conditional, or the
  innermost open one is active. }
begin
  CondCompiling := (CondTop = 0) or CondActiveStk[CondTop - 1];
end;

function IsDefinedSym(const sym: string): Boolean;
var
  i: LongInt;
  l: string;
begin
  IsDefinedSym := False;
  l := LowerStr(sym);
  for i := 0 to High(Defines) do
    if Defines[i] = l then begin IsDefinedSym := True; Exit; end;
end;

procedure AddDefineSym(const sym: string);
var
  n: LongInt;
begin
  if IsDefinedSym(sym) then Exit;
  n := Length(Defines);
  SetLength(Defines, n + 1);
  Defines[n] := LowerStr(sym);
end;

procedure RemoveDefineSym(const sym: string);
var
  i, n: LongInt;
  l: string;
begin
  l := LowerStr(sym);
  n := Length(Defines);
  for i := 0 to n - 1 do
    if Defines[i] = l then begin
      Defines[i] := Defines[n - 1];
      SetLength(Defines, n - 1);
      Exit;
    end;
end;

function ReadDirectiveWord: string;
{ Read the run of letters starting a directive body (positioned just after the dollar),
  lowercased, leaving the scanner at the first non-letter. }
begin
  ReadDirectiveWord := '';
  while ((CurCh >= 'a') and (CurCh <= 'z')) or
        ((CurCh >= 'A') and (CurCh <= 'Z')) do begin
    ReadDirectiveWord := ReadDirectiveWord + ToLowerCh(CurCh);
    Adv;
  end;
end;

function ReadDirectiveArg: string;
{ Skip blanks, then read an identifier argument (a conditional symbol name). }
begin
  while (CurCh = ' ') or (CurCh = #9) do Adv;
  ReadDirectiveArg := '';
  while IsIdentTail(CurCh) do begin
    ReadDirectiveArg := ReadDirectiveArg + CurCh;
    Adv;
  end;
end;

procedure SkipToBrace;
{ Consume the rest of a directive up to and including its closing brace. }
begin
  while (CurCh <> #0) and (CurCh <> '}') do Adv;
  if CurCh = '}' then Adv;
end;

{ The low-level file read. Under Kobold it is a runtime primitive (a host import), so
  the self-hosted compiler needs no `file` type. Under the FPC bootstrap it is a
  self-contained body, keeping kpcom a single file with no companion object. Both
  return the whole file as a string, or the empty string when it cannot be read. }
{$IFDEF KOBOLD}
function ReadFileStr(const path: string): string; external cdecl;
{$ELSE}
function ReadFileStr(const path: string): string;
var
  f: file;
  n, got: LongInt;
begin
  ReadFileStr := '';
  Assign(f, path);
  {$I-} Reset(f, 1); {$I+}
  if IOResult <> 0 then Exit;
  n := FileSize(f);
  SetLength(ReadFileStr, n);
  got := n;
  if n > 0 then BlockRead(f, ReadFileStr[1], n, got);
  Close(f);
  if got <> n then ReadFileStr := '';
end;
{$ENDIF}

function ReadWholeFile(const path: string; out data: string): Boolean;
{ Read the whole file into data, returning False when it is missing or unreadable. An
  empty file also reads as False, which for a source or include is harmless. }
begin
  data := ReadFileStr(path);
  ReadWholeFile := data <> '';
end;

{ Write data to a host file, 1 on success and 0 on failure. Host-provided when
  self-hosted (the JIT and AOT runtimes bind it beside ReadFileStr), native when
  built with fpc. Used by the -o output path. }
{$IFDEF KOBOLD}
function WriteFileStr(const path, data: string): LongInt; external cdecl;
{$ELSE}
function WriteFileStr(const path, data: string): LongInt;
var
  f: file;
begin
  WriteFileStr := 0;
  Assign(f, path);
  {$I-} Rewrite(f, 1); {$I+}
  if IOResult <> 0 then Exit;
  if Length(data) > 0 then BlockWrite(f, data[1], Length(data));
  Close(f);
  WriteFileStr := 1;
end;
{$ENDIF}

{ Directory enumeration for the `uses ns.*` namespace wildcard. Under Kobold these are the
  same host imports the io.dirs unit uses: kpd_open returns a small handle (or -1), kpd_next
  the next entry name ('' at the end), kpd_close releases it. Under the FPC bootstrap they
  are a self-contained FindFirst/FindNext wrapper, keeping kpcom a single file with no
  companion object. }
{$IFDEF KOBOLD}
function kpd_open(const path: string): LongInt; external cdecl;
function kpd_next(handle: LongInt): string; external cdecl;
procedure kpd_close(handle: LongInt); external cdecl;
{$ELSE}
const
  KPD_MAX = 16;
var
  kpd_rec: array[0 .. KPD_MAX - 1] of TSearchRec;
  kpd_used: array[0 .. KPD_MAX - 1] of Boolean;
  kpd_pending: array[0 .. KPD_MAX - 1] of Boolean;   { a prefetched entry awaits in kpd_rec }

function kpd_open(const path: string): LongInt;
var
  h: LongInt;
begin
  kpd_open := -1;
  for h := 0 to KPD_MAX - 1 do
    if not kpd_used[h] then begin
      if FindFirst(path + '/*', faAnyFile, kpd_rec[h]) = 0 then begin
        kpd_used[h] := True;
        kpd_pending[h] := True;
        kpd_open := h;
      end;
      Exit;
    end;
end;

function kpd_next(handle: LongInt): string;
begin
  kpd_next := '';
  if (handle < 0) or (handle >= KPD_MAX) or not kpd_used[handle] then Exit;
  if not kpd_pending[handle] then Exit;
  kpd_next := kpd_rec[handle].Name;
  if FindNext(kpd_rec[handle]) <> 0 then kpd_pending[handle] := False;
end;

procedure kpd_close(handle: LongInt);
begin
  if (handle >= 0) and (handle < KPD_MAX) and kpd_used[handle] then begin
    FindClose(kpd_rec[handle]);
    kpd_used[handle] := False;
    kpd_pending[handle] := False;
  end;
end;
{$ENDIF}

function DirOf(const path: string): string;
{ The directory prefix of a path (up to and including the last '/'), or '' if none. An
  include file name is resolved relative to the directory of the file that includes it. }
var
  i: LongInt;
begin
  DirOf := '';
  for i := Length(path) downto 1 do
    if path[i] = '/' then begin DirOf := Copy(path, 1, i); Exit; end;
end;

procedure DoInclude(dirStart, dirLine, dirCol: LongInt);
{ At a dollar-I include directive, read the file name up to the closing brace, load the file,
  and splice its contents into the source in place of the directive, so the included text is
  tokenized where it appears. The directive starts at dirStart (the opening brace); after the
  splice the scanner resumes there. }
var
  fn, content: string;
begin
  Adv;                                     { past 'I' }
  while IsSpace(CurCh) do Adv;
  fn := '';
  while (CurCh <> #0) and (CurCh <> '}') do begin fn := fn + CurCh; Adv; end;
  if CurCh = '}' then Adv;                 { past the closing brace }
  while (Length(fn) > 0) and (fn[Length(fn)] = ' ') do fn := Copy(fn, 1, Length(fn) - 1);
  if not ReadWholeFile(DirOf(SrcName) + fn, content) then begin
    LexError(dirLine, dirCol, 'cannot open include file ''' + fn + '''');
    content := '';
  end;
  Src := Copy(Src, 1, dirStart - 1) + content + Copy(Src, Pos, SrcLen - Pos + 1);
  SrcLen := Length(Src);
  Pos := dirStart;
  CurLine := dirLine;
  CurCol := dirCol;
end;

function SkipDeadBranch(stopAtElse: Boolean): string;
{ Consume source in an inactive conditional branch until the matching `$ELSE` (when
  stopAtElse) or `$ENDIF` at this nesting level, stepping over nested conditionals and
  over comments and string literals so a directive inside them is not taken for a real
  one. Returns 'else' or 'endif' (or '' at end of file), positioned just past the stop. }
var
  depth: LongInt;
  kw: string;
begin
  SkipDeadBranch := '';
  depth := 0;
  while CurCh <> #0 do begin
    if (CurCh = '{') and (PeekCh(1) = '$') then begin
      Adv; Adv;
      kw := ReadDirectiveWord;
      SkipToBrace;
      if (kw = 'ifdef') or (kw = 'ifndef') then Inc(depth)
      else if kw = 'endif' then begin
        if depth = 0 then begin SkipDeadBranch := 'endif'; Exit; end;
        Dec(depth);
      end
      else if (kw = 'else') and stopAtElse and (depth = 0) then begin
        SkipDeadBranch := 'else'; Exit;
      end;
    end
    else if CurCh = '{' then begin
      Adv;
      while (CurCh <> #0) and (CurCh <> '}') do Adv;
      if CurCh = '}' then Adv;
    end
    else if (CurCh = '(') and (PeekCh(1) = '*') then begin
      Adv; Adv;
      while (CurCh <> #0) and not ((CurCh = '*') and (PeekCh(1) = ')')) do Adv;
      if CurCh <> #0 then begin Adv; Adv; end;
    end
    else if (CurCh = '/') and (PeekCh(1) = '/') then
      while (CurCh <> #0) and (CurCh <> #10) do Adv
    else if CurCh = '''' then begin
      Adv;
      while (CurCh <> #0) and (CurCh <> '''') do Adv;
      if CurCh = '''' then Adv;
    end
    else
      Adv;
  end;
end;

procedure OpenCond(active: Boolean);
{ Push a conditional frame as the scanner enters an `$IF` body. }
begin
  if CondTop >= Length(CondActiveStk) then begin
    SetLength(CondActiveStk, CondTop + 8);
    SetLength(CondTakenStk, CondTop + 8);
  end;
  CondActiveStk[CondTop] := active;
  CondTakenStk[CondTop] := active;
  Inc(CondTop);
end;

procedure SkipTrivia;
{ Skip whitespace and the three comment forms, acting on brace-dollar directives.
  Reports unterminated block comments. }
var
  startLine, startCol, dirStart: LongInt;
  kw, arg, kind: string;
begin
  while CurCh <> #0 do begin
    if IsSpace(CurCh) then
      Adv
    else if CurCh = '{' then begin
      startLine := CurLine; startCol := CurCol; dirStart := Pos;
      Adv;
      if CurCh = '$' then begin
        Adv;   { past the $ }
        { $I followed by a space is an include; every other directive begins with a
          keyword. This loop only runs in a live region, so a directive here always acts. }
        if (ToLowerCh(CurCh) = 'i') and IsSpace(PeekCh(1)) then
          DoInclude(dirStart, startLine, startCol)
        else begin
          kw := ReadDirectiveWord;
          if (kw = 'ifdef') or (kw = 'ifndef') then begin
            arg := ReadDirectiveArg;
            SkipToBrace;
            OpenCond(IsDefinedSym(arg) = (kw = 'ifdef'));
            if not CondActiveStk[CondTop - 1] then begin
              { the taken branch is dead: skip to its $else or $endif }
              kind := SkipDeadBranch(True);
              if kind = 'else' then begin
                CondActiveStk[CondTop - 1] := True;
                CondTakenStk[CondTop - 1] := True;
              end
              else
                Dec(CondTop);   { $endif: the whole conditional is done }
            end;
          end
          else if kw = 'else' then begin
            { reached only while the $if branch was active; skip the $else body }
            SkipToBrace;
            if CondTop > 0 then begin
              SkipDeadBranch(False);   { to the matching $endif }
              Dec(CondTop);
            end;
          end
          else if kw = 'endif' then begin
            SkipToBrace;
            if CondTop > 0 then Dec(CondTop);
          end
          else if kw = 'define' then begin
            AddDefineSym(ReadDirectiveArg); SkipToBrace;
          end
          else if kw = 'undef' then begin
            RemoveDefineSym(ReadDirectiveArg); SkipToBrace;
          end
          else if (kw = 'r') or (kw = 'q') then begin
            { the range (R+/R-) and overflow (Q+/Q-) switches }
            if (CurCh = '+') or (CurCh = '-') then
              if kw = 'r' then OptRangeChecks := CurCh = '+'
              else OptOverflowChecks := CurCh = '+';
            SkipToBrace;
          end
          else
            SkipToBrace;   { an unknown directive ($mode, $H, $I-, ...): ignore }
        end;
      end
      else begin
        while (CurCh <> #0) and (CurCh <> '}') do Adv;
        if CurCh = #0 then
          LexError(startLine, startCol, 'unterminated { } comment')
        else
          Adv;
      end;
    end
    else if (CurCh = '(') and (PeekCh(1) = '*') then begin
      startLine := CurLine; startCol := CurCol;
      Adv; Adv;
      while (CurCh <> #0) and not ((CurCh = '*') and (PeekCh(1) = ')')) do Adv;
      if CurCh = #0 then
        LexError(startLine, startCol, 'unterminated (* *) comment')
      else begin
        Adv; Adv;
      end;
    end
    else if (CurCh = '/') and (PeekCh(1) = '/') then begin
      while (CurCh <> #0) and (CurCh <> #10) do Adv;
    end
    else
      Break;
  end;
end;

procedure ScanIdentOrKeyword;
var
  i: LongInt;
  low: string;
begin
  Tok.Text := '';
  while IsIdentTail(CurCh) do begin
    Tok.Text := Tok.Text + CurCh;
    Adv;
  end;
  Tok.StrVal := Tok.Text;
  low := LowerStr(Tok.Text);
  for i := 1 to KeywordCount do
    if Keywords[i].Name = low then begin
      Tok.Kind := Keywords[i].Kind;
      Exit;
    end;
  Tok.Kind := tkIdent;
end;

procedure ScanNumber;
{ Decimal or $hex integer, or a real literal DIGIT+ '.' DIGIT+ [exponent]. A
  '.' that is not followed by a digit belongs to '..' or '.', not to a real. }
var
  code: Word;
begin
  Tok.Text := '';
  if CurCh = '$' then begin
    Tok.Text := '$';
    Adv;
    if not IsHexDigit(CurCh) then begin
      LexError(Tok.Line, Tok.Col, 'expected hex digits after ''$''');
      Tok.Kind := tkIntLit;
      Tok.IntVal := 0;
      Exit;
    end;
    Tok.IntVal := 0;
    while IsHexDigit(CurCh) do begin
      Tok.IntVal := (Tok.IntVal * 16) + HexVal(CurCh);
      Tok.Text := Tok.Text + CurCh;
      Adv;
    end;
    Tok.Kind := tkIntLit;
    Exit;
  end;

  while IsDigit(CurCh) do begin
    Tok.Text := Tok.Text + CurCh;
    Adv;
  end;

  if (CurCh = '.') and IsDigit(PeekCh(1)) then begin
    Tok.Text := Tok.Text + '.';
    Adv;
    while IsDigit(CurCh) do begin
      Tok.Text := Tok.Text + CurCh;
      Adv;
    end;
    if (CurCh = 'e') or (CurCh = 'E') then begin
      Tok.Text := Tok.Text + CurCh;
      Adv;
      if (CurCh = '+') or (CurCh = '-') then begin
        Tok.Text := Tok.Text + CurCh;
        Adv;
      end;
      if not IsDigit(CurCh) then
        LexError(Tok.Line, Tok.Col, 'expected digits in exponent');
      while IsDigit(CurCh) do begin
        Tok.Text := Tok.Text + CurCh;
        Adv;
      end;
    end;
    Val(Tok.Text, Tok.RealVal, code);
    if code <> 0 then
      LexError(Tok.Line, Tok.Col, 'malformed real literal');
    Tok.Kind := tkRealLit;
    Exit;
  end;

  Val(Tok.Text, Tok.IntVal, code);
  if code <> 0 then
    LexError(Tok.Line, Tok.Col, 'integer literal out of range');
  Tok.Kind := tkIntLit;
end;

procedure ScanNumericByte(out value: LongInt);
{ Reads the INTEGER_LITERAL after a '#' in a string literal. }
begin
  value := 0;
  if CurCh = '$' then begin
    Adv;
    if not IsHexDigit(CurCh) then
      LexError(CurLine, CurCol, 'expected hex digits after ''#$''');
    while IsHexDigit(CurCh) do begin
      value := (value * 16) + HexVal(CurCh);
      Adv;
    end;
  end
  else begin
    if not IsDigit(CurCh) then
      LexError(CurLine, CurCol, 'expected a number after ''#''');
    while IsDigit(CurCh) do begin
      value := (value * 10) + (Ord(CurCh) - Ord('0'));
      Adv;
    end;
  end;
end;

procedure ScanString;
{ A string literal is one or more adjacent parts: '...' quoted runs (with ''
  for an embedded quote) and #nn byte escapes. Their bytes concatenate. }
var
  b: LongInt;
begin
  Tok.Kind := tkStrLit;
  Tok.StrVal := '';
  Tok.Text := '';
  while (CurCh = '''') or (CurCh = '#') do begin
    if CurCh = '''' then begin
      Tok.Text := Tok.Text + CurCh;
      Adv;
      while True do begin
        if CurCh = #0 then begin
          LexError(Tok.Line, Tok.Col, 'unterminated string literal');
          Exit;
        end;
        if CurCh = '''' then begin
          if PeekCh(1) = '''' then begin
            Tok.StrVal := Tok.StrVal + '''';
            Tok.Text := Tok.Text + '''''';
            Adv; Adv;
          end
          else begin
            Tok.Text := Tok.Text + '''';
            Adv;
            Break;
          end;
        end
        else begin
          Tok.StrVal := Tok.StrVal + CurCh;
          Tok.Text := Tok.Text + CurCh;
          Adv;
        end;
      end;
    end
    else begin
      Tok.Text := Tok.Text + '#';
      Adv;
      ScanNumericByte(b);
      if (b < 0) or (b > 255) then
        LexError(Tok.Line, Tok.Col, 'byte value out of range 0..255')
      else
        Tok.StrVal := Tok.StrVal + Chr(b);
    end;
  end;
end;

procedure ScanInterpStr;
{ A double-quoted interpolated string literal, with dollar-brace holes. The whole
  inner text, with a doubled quote collapsed to one literal quote, is captured raw
  into Tok.StrVal; the parser splits it into literal chunks and holes (see
  BuildInterp). The single-quoted literal stays plain and non-interpolated, so
  existing code is unchanged. One line only; a hole may not itself contain a quote. }
begin
  Tok.Kind := tkInterpStr;
  Tok.StrVal := '';
  Tok.Text := '"';
  Adv;   { past the opening quote }
  while True do begin
    if (CurCh = #0) or (CurCh = #10) or (CurCh = #13) then begin
      LexError(Tok.Line, Tok.Col, 'unterminated interpolated string');
      Exit;
    end;
    if CurCh = '"' then begin
      if PeekCh(1) = '"' then begin
        Tok.StrVal := Tok.StrVal + '"'; Tok.Text := Tok.Text + '""'; Adv; Adv;
      end
      else begin
        Tok.Text := Tok.Text + '"'; Adv; Break;
      end;
    end
    else begin
      Tok.StrVal := Tok.StrVal + CurCh; Tok.Text := Tok.Text + CurCh; Adv;
    end;
  end;
end;

function ScanSymbol: Boolean;
{ Punctuation and operators. Returns False when the char is not recognized (it
  has been reported and consumed), so NextToken can try again. }
var
  c: Char;
begin
  ScanSymbol := True;
  c := CurCh;
  case c of
    ':':
      if PeekCh(1) = '=' then begin
        Tok.Kind := tkAssign; Tok.Text := ':='; Adv; Adv;
      end
      else begin
        Tok.Kind := tkColon; Tok.Text := ':'; Adv;
      end;
    ';': begin Tok.Kind := tkSemicolon; Tok.Text := ';'; Adv; end;
    ',': begin Tok.Kind := tkComma; Tok.Text := ','; Adv; end;
    '_':
      { a lone '_' is the wildcard token; '_' followed by an identifier character starts an
        identifier (so the '__line__' intrinsic and underscore-prefixed names scan as names) }
      if IsIdentTail(PeekCh(1)) then ScanIdentOrKeyword
      else begin Tok.Kind := tkUnderscore; Tok.Text := '_'; Adv; end;
    '.':
      if PeekCh(1) = '.' then begin
        Tok.Kind := tkDotDot; Tok.Text := '..'; Adv; Adv;
      end
      else begin
        Tok.Kind := tkDot; Tok.Text := '.'; Adv;
      end;
    '(': begin Tok.Kind := tkLParen; Tok.Text := '('; Adv; end;
    ')': begin Tok.Kind := tkRParen; Tok.Text := ')'; Adv; end;
    '[': begin Tok.Kind := tkLBracket; Tok.Text := '['; Adv; end;
    ']': begin Tok.Kind := tkRBracket; Tok.Text := ']'; Adv; end;
    '=': begin Tok.Kind := tkEq; Tok.Text := '='; Adv; end;
    '<':
      if PeekCh(1) = '=' then begin
        Tok.Kind := tkLe; Tok.Text := '<='; Adv; Adv;
      end
      else if PeekCh(1) = '>' then begin
        Tok.Kind := tkNeq; Tok.Text := '<>'; Adv; Adv;
      end
      else begin
        Tok.Kind := tkLt; Tok.Text := '<'; Adv;
      end;
    '>':
      if PeekCh(1) = '=' then begin
        Tok.Kind := tkGe; Tok.Text := '>='; Adv; Adv;
      end
      else begin
        Tok.Kind := tkGt; Tok.Text := '>'; Adv;
      end;
    '+': begin Tok.Kind := tkPlus; Tok.Text := '+'; Adv; end;
    '-': begin Tok.Kind := tkMinus; Tok.Text := '-'; Adv; end;
    '*': begin Tok.Kind := tkStar; Tok.Text := '*'; Adv; end;
    '/': begin Tok.Kind := tkSlash; Tok.Text := '/'; Adv; end;
    '@': begin Tok.Kind := tkAt; Tok.Text := '@'; Adv; end;
  else
    begin
      LexError(CurLine, CurCol, 'unexpected character ''' + c + '''');
      Adv;
      ScanSymbol := False;
    end;
  end;
end;

procedure NextToken;
{ Fill Tok with the next token. Skips trivia, and on an unrecognized character
  reports it and continues, so a single run reports more than one error. }
var
  c: Char;
begin
  while True do begin
    SkipTrivia;
    Tok.Line := CurLine;
    Tok.Col := CurCol;
    Tok.Text := '';
    Tok.StrVal := '';
    Tok.IntVal := 0;
    Tok.RealVal := 0.0;
    c := CurCh;
    if c = #0 then begin
      Tok.Kind := tkEOF;
      Tok.Text := '<eof>';
      Exit;
    end;
    if IsAlpha(c) then begin ScanIdentOrKeyword; Exit; end;
    if IsDigit(c) or (c = '$') then begin ScanNumber; Exit; end;
    if (c = '''') or (c = '#') then begin ScanString; Exit; end;
    if c = '"' then begin ScanInterpStr; Exit; end;
    if ScanSymbol then Exit;
    { unrecognized char: reported and consumed; loop for the next token }
  end;
end;

function PeekTokenKind: TTokenKind;
{ The kind of the token after the current one, without consuming it. Saves the
  scanner cursor and current token, scans one token, then restores. Used to tell
  a record literal '(field: ...' apart from a parenthesized expression '(expr'. }
var
  savePos, saveLine, saveCol: LongInt;
  saveTok: TToken;
begin
  savePos := Pos; saveLine := CurLine; saveCol := CurCol; saveTok := Tok;
  NextToken;
  PeekTokenKind := Tok.Kind;
  Pos := savePos; CurLine := saveLine; CurCol := saveCol; Tok := saveTok;
end;

procedure PeekNext(var kind: TTokenKind; var lowText: string);
{ The kind and lowercased text of the token after the current one, without consuming it, so a
  caller can see its text as well as its kind. Used to tell the failable `or` suffix (over the
  words exit/fail, which are not reserved) from the boolean `or` operator. Returned through var
  parameters rather than a record result, which the self-hosted codegen does not return. }
var
  savePos, saveLine, saveCol: LongInt;
  saveTok: TToken;
begin
  savePos := Pos; saveLine := CurLine; saveCol := CurCol; saveTok := Tok;
  NextToken;
  kind := Tok.Kind; lowText := LowerStr(Tok.Text);
  Pos := savePos; CurLine := saveLine; CurCol := saveCol; Tok := saveTok;
end;

procedure InitScanner(const name, text: string);
var
  cdi: LongInt;
begin
  SrcName := name;
  Src := text;
  SrcLen := Length(text);
  Pos := 1;
  CurLine := 1;
  CurCol := 1;
  { start each file with a fresh conditional state; KOBOLD marks this compiler, so a
    source can select a Kobold-only body against the FPC bootstrap with $IFDEF KOBOLD }
  CondTop := 0;
  SetLength(Defines, 0);
  AddDefineSym('kobold');
  { re-apply command-line -D symbols (e.g. KP_TARGET_X64 when emitting an x86-64 seed) }
  for cdi := 0 to Length(CmdDefines) - 1 do
    AddDefineSym(CmdDefines[cdi]);
end;

{ ---- Token dump (the -d output, and the lexer test oracle) ---- }

function EscapeStr(const s: string): string;
const
  Hex = '0123456789abcdef';
var
  i: LongInt;
  c: Char;
begin
  EscapeStr := '"';
  for i := 1 to Length(s) do begin
    c := s[i];
    case c of
      '"':  EscapeStr := EscapeStr + '\"';
      '\':  EscapeStr := EscapeStr + '\\';
      #10:  EscapeStr := EscapeStr + '\n';
      #9:   EscapeStr := EscapeStr + '\t';
      #13:  EscapeStr := EscapeStr + '\r';
    else
      if (c >= ' ') and (c <= '~') then
        EscapeStr := EscapeStr + c
      else
        EscapeStr := EscapeStr + '\x'
          + Hex[(Ord(c) shr 4) + 1] + Hex[(Ord(c) and 15) + 1];
    end;
  end;
  EscapeStr := EscapeStr + '"';
end;

procedure DumpToken(const t: TToken);
var
  line: string;
begin
  Str(t.Line, line);
  Write(line, ':');
  Str(t.Col, line);
  Write(line, ' ', TokenName[t.Kind]);
  case t.Kind of
    tkIdent:   Write(' ', t.StrVal);
    tkIntLit:  begin Str(t.IntVal, line); Write(' ', line); end;
    tkRealLit: Write(' ', t.Text);
    tkStrLit:  Write(' ', EscapeStr(t.StrVal));
  end;
  WriteLn;
end;

{ ---- Parser ---- }
{ A recursive-descent parser for the grammar in doc/languages/kobold/kp-grammar.md.
  It builds the AST in the node pool and recovers at statement and declaration
  boundaries so a single run can report more than one error. It does not check
  types or resolve names; the semantic analyzer below does that. }

{ Forward declarations for the mutually recursive productions. }
function ParseExpression: LongInt; forward;
function OrIntroducesFailSuffix: Boolean; forward;
function ParseType: LongInt; forward;
function ParseSubrangeType: LongInt; forward;
function ParseRecordType: LongInt; forward;
function ParseVariantPart: LongInt; forward;
function ParseInterfaceType: LongInt; forward;
function ParseProcType: LongInt; forward;
function ParseReceiver: LongInt; forward;
procedure ParseFormalParams(owner: LongInt); forward;
function ParseDesignator: LongInt; forward;
function ParseStart: LongInt; forward;
function ParseYield: LongInt; forward;
function ParseBind: LongInt; forward;
function ParseStatement: LongInt; forward;
function ParseCaseStmt: LongInt; forward;
procedure ParseStmtSeq(owner: LongInt); forward;
function ParseCompound: LongInt; forward;
function ParseBlock: LongInt; forward;
function ParseProcOrFunc: LongInt; forward;
procedure ParseAccessorSpec(d: LongInt); forward;
function IsDirective(const w: string): Boolean; forward;
function ParseUsesClause: LongInt; forward;

procedure ParseErrAt(line, col: LongInt; const msg: string);
begin
  EmitDiag(line, col, 'error', 'E0002', msg);
  Inc(ErrCount);
end;

procedure ParseErr(const msg: string);
begin
  ParseErrAt(Tok.Line, Tok.Col, msg);
end;

function NewNode(k: TNodeKind): LongInt;
begin
  if NodeCount >= Length(Nodes) then begin
    if Length(Nodes) = 0 then SetLength(Nodes, 256)
    else SetLength(Nodes, Length(Nodes) * 2);
  end;
  Nodes[NodeCount].Kind := k;
  Nodes[NodeCount].Line := Tok.Line;
  Nodes[NodeCount].Col := Tok.Col;
  Nodes[NodeCount].A := -1;
  Nodes[NodeCount].B := -1;
  Nodes[NodeCount].C := -1;
  Nodes[NodeCount].D := -1;
  SetLength(Nodes[NodeCount].Kids, 0);
  Nodes[NodeCount].Text := '';
  Nodes[NodeCount].IntVal := 0;
  Nodes[NodeCount].RealVal := 0.0;
  Nodes[NodeCount].Op := tkEOF;
  Nodes[NodeCount].Flag := 0;
  Nodes[NodeCount].CConv := 0;
  Nodes[NodeCount].Exported := 0;
  Nodes[NodeCount].Failable := 0;
  Nodes[NodeCount].Sym := -1;
  Nodes[NodeCount].Ty := -1;
  NewNode := NodeCount;
  Inc(NodeCount);
end;

procedure AddKid(parent, kid: LongInt);
var
  n: LongInt;
begin
  n := Length(Nodes[parent].Kids);
  SetLength(Nodes[parent].Kids, n + 1);
  Nodes[parent].Kids[n] := kid;
end;

function Accept(k: TTokenKind): Boolean;
begin
  if Tok.Kind = k then begin NextToken; Accept := True; end
  else Accept := False;
end;

procedure Expect(k: TTokenKind);
begin
  if Tok.Kind = k then NextToken
  else ParseErr('expected ' + TokenName[k] + ', found ' + TokenName[Tok.Kind]);
end;

procedure Synchronize(stop: TTokenSet);
begin
  while not (Tok.Kind in stop) and (Tok.Kind <> tkEOF) do NextToken;
end;

function IdentNode: LongInt;
begin
  IdentNode := NewNode(nkIdent);
  if Tok.Kind = tkIdent then begin
    Nodes[IdentNode].Text := Tok.StrVal;
    NextToken;
  end
  else ParseErr('expected an identifier');
end;

function EatIdent(const what: string): string;
begin
  if Tok.Kind = tkIdent then begin
    EatIdent := Tok.StrVal;
    NextToken;
  end
  else begin
    ParseErr('expected ' + what);
    EatIdent := '';
  end;
end;

function ParseForBinder: string;
{ a for-in binder: an identifier, or '_' to ignore its value }
begin
  if Accept(tkUnderscore) then ParseForBinder := '_'
  else ParseForBinder := EatIdent('a loop variable');
end;

procedure ParseIdentList(owner: LongInt);
begin
  AddKid(owner, IdentNode);
  while Accept(tkComma) do AddKid(owner, IdentNode);
end;

procedure ParseExprList(owner: LongInt);
begin
  AddKid(owner, ParseExpression);
  while Accept(tkComma) do AddKid(owner, ParseExpression);
end;

function ParseSelectors(base: LongInt): LongInt;
var
  n: LongInt;
begin
  while True do begin
    case Tok.Kind of
      tkDot: begin
        n := NewNode(nkField); NextToken;
        Nodes[n].A := base;
        if Tok.Kind = tkIdent then begin
          Nodes[n].Text := Tok.StrVal; NextToken;
        end
        else ParseErr('expected a field or method name');
        base := n;
      end;
      tkLBracket: begin
        n := NewNode(nkIndex); NextToken;
        { Stamp the range-check state in effect here, so lowering emits a bounds
          check for this access when range checks were on at its source position. }
        if OptRangeChecks then Nodes[n].Flag := 1;
        Nodes[n].A := base;
        ParseExprList(n);
        Expect(tkRBracket);
        base := n;
      end;
      tkLParen: begin
        n := NewNode(nkCall); NextToken;
        Nodes[n].A := base;
        if Tok.Kind <> tkRParen then ParseExprList(n);
        Expect(tkRParen);
        base := n;
      end;
    else
      Break;
    end;
  end;
  ParseSelectors := base;
end;

function ParseDesignator: LongInt;
begin
  ParseDesignator := ParseSelectors(IdentNode);
end;

function ParseSetConstructor: LongInt;
var
  n, e: LongInt;
begin
  n := NewNode(nkSetConstructor);
  Expect(tkLBracket);
  if Tok.Kind <> tkRBracket then
    repeat
      e := NewNode(nkSetElement);
      Nodes[e].A := ParseExpression;
      if Accept(tkDotDot) then Nodes[e].B := ParseExpression;
      AddKid(n, e);
    until not Accept(tkComma);
  Expect(tkRBracket);
  ParseSetConstructor := n;
end;

function ParseExprString(const s: string): LongInt;
{ Parse s as a standalone expression (an interpolation hole) by pointing the
  scanner at s and restoring it afterward. The hole is a complete expression, so
  the parse ends at end of input. }
var
  saveSrc, saveName: string;
  savePos, saveLen, saveLine, saveCol: LongInt;
  saveTok: TToken;
  r: LongInt;
begin
  saveSrc := Src; saveName := SrcName; savePos := Pos; saveLen := SrcLen;
  saveLine := CurLine; saveCol := CurCol; saveTok := Tok;
  Src := s; SrcLen := Length(s); SrcName := '<interpolation>';
  Pos := 1; CurLine := 1; CurCol := 1;
  NextToken;
  r := ParseExpression;
  if Tok.Kind <> tkEOF then
    LexError(CurLine, CurCol, 'unexpected text after the expression in ${...}');
  Src := saveSrc; SrcLen := saveLen; SrcName := saveName; Pos := savePos;
  CurLine := saveLine; CurCol := saveCol; Tok := saveTok;
  ParseExprString := r;
end;

function BuildInterp(const raw: string): LongInt;
{ Expand an interpolated literal's raw inner text into a '+'-concat chain of
  string pieces: a literal chunk becomes an nkStrLit, a hole an nkToStr around the
  parsed expr. A doubled dollar-brace is a literal dollar-brace, a lone dollar is
  literal, and a hole runs to its closing brace (one inside a single-quoted literal
  in the hole does not end it). }
var
  i, n, acc, startH, hole: LongInt;
  chunk, hs: string;
  inStr: Boolean;

  function Concat2(a, b: LongInt): LongInt;
  var m: LongInt;
  begin
    if a < 0 then Concat2 := b
    else begin
      m := NewNode(nkBinary); Nodes[m].Op := tkPlus; Nodes[m].A := a; Nodes[m].B := b;
      Concat2 := m;
    end;
  end;

  procedure FlushChunk;
  var c: LongInt;
  begin
    if chunk <> '' then begin
      c := NewNode(nkStrLit); Nodes[c].Text := chunk;
      acc := Concat2(acc, c);
      chunk := '';
    end;
  end;

begin
  i := 1; n := Length(raw); chunk := ''; acc := -1;
  while i <= n do begin
    if (raw[i] = '$') and (i + 2 <= n) and (raw[i+1] = '$') and (raw[i+2] = '{') then begin
      chunk := chunk + '${'; i := i + 3;
    end
    else if (raw[i] = '$') and (i + 1 <= n) and (raw[i+1] = '{') then begin
      FlushChunk;
      i := i + 2; startH := i; inStr := False;
      while i <= n do begin
        if inStr then begin
          if raw[i] = '''' then begin
            if (i < n) and (raw[i+1] = '''') then i := i + 2
            else begin inStr := False; Inc(i); end;
          end
          else Inc(i);
        end
        else begin
          if raw[i] = '''' then begin inStr := True; Inc(i); end
          else if raw[i] = '}' then Break
          else Inc(i);
        end;
      end;
      if i > n then begin
        LexError(Tok.Line, Tok.Col, 'unterminated ${ } in interpolated string');
        BuildInterp := NewNode(nkStrLit); Exit;
      end;
      hs := Copy(raw, startH, i - startH);
      i := i + 1;   { past the closing brace }
      if hs = '' then
        LexError(Tok.Line, Tok.Col, 'empty ${} has no expression to interpolate');
      hole := NewNode(nkToStr);
      Nodes[hole].A := ParseExprString(hs);
      acc := Concat2(acc, hole);
    end
    else begin
      chunk := chunk + raw[i]; Inc(i);
    end;
  end;
  FlushChunk;
  if acc < 0 then begin
    acc := NewNode(nkStrLit); Nodes[acc].Text := '';
  end;
  BuildInterp := acc;
end;

function ParseFactor: LongInt;
var
  n, agg, fi: LongInt;
begin
  case Tok.Kind of
    tkIntLit: begin
      n := NewNode(nkIntLit); Nodes[n].IntVal := Tok.IntVal; NextToken;
    end;
    tkRealLit: begin
      n := NewNode(nkRealLit);
      Nodes[n].Text := Tok.Text; Nodes[n].RealVal := Tok.RealVal; NextToken;
    end;
    tkStrLit: begin
      n := NewNode(nkStrLit); Nodes[n].Text := Tok.StrVal; NextToken;
    end;
    tkInterpStr: begin
      n := BuildInterp(Tok.StrVal); NextToken;
    end;
    tkNil: begin n := NewNode(nkNil); NextToken; end;
    tkIdent:
      if SameTextCI(Tok.StrVal, '__line__') then begin
        { a compile-time intrinsic: the source line of its own occurrence, as an integer
          constant. A diagnostic helper receives the call site's line through it without the
          caller counting lines by hand, since a host routine never sees the guest line. }
        n := NewNode(nkIntLit); Nodes[n].IntVal := Tok.Line; NextToken;
      end
      else n := ParseDesignator;
    tkLParen: begin
      NextToken;
      if (Tok.Kind = tkIdent) and (PeekTokenKind = tkColon) then begin
        { a record literal, (field: value; field: value), meaningful as a record constant
          value, typically an element of a constant array of records }
        n := NewNode(nkRecordLit);
        repeat
          fi := NewNode(nkFieldInit);
          Nodes[fi].Text := Tok.Text;
          NextToken;
          Expect(tkColon);
          Nodes[fi].A := ParseExpression;
          AddKid(n, fi);
        until not Accept(tkSemicolon);
      end
      else begin
        n := ParseExpression;
        if Tok.Kind = tkComma then begin
          { a parenthesized comma list is an aggregate initializer, (e1, e2, ...), meaningful
            as an array or record constant value }
          agg := NewNode(nkAggregate);
          AddKid(agg, n);
          while Accept(tkComma) do AddKid(agg, ParseExpression);
          n := agg;
        end;
      end;
      Expect(tkRParen);
    end;
    tkNot: begin
      n := NewNode(nkUnary); Nodes[n].Op := tkNot; NextToken;
      Nodes[n].A := ParseFactor();   { () forces the recursive call }
    end;
    tkAt: begin
      { `@name` takes the address of a label in the current routine, yielding a
        `label` value for a computed `goto`. The only legal operand is a label
        name (checked in sema). }
      n := NewNode(nkLabelAddr); NextToken;
      Nodes[n].Text := EatIdent('a label name after ''@''');
    end;
    tkLBracket: n := ParseSetConstructor;
    tkStart: n := ParseStart;
    tkBind: n := ParseBind;
    tkYield: n := ParseYield;
  else
    ParseErr('expected an expression, found ' + TokenName[Tok.Kind]);
    n := NewNode(nkEmpty);
  end;
  ParseFactor := n;
end;

function ParseTerm: LongInt;
var
  left, right, n: LongInt;
begin
  left := ParseFactor;
  while Tok.Kind in MulOps do begin
    n := NewNode(nkBinary); Nodes[n].Op := Tok.Kind; NextToken;
    if OptOverflowChecks then Nodes[n].Flag := 1;
    right := ParseFactor;
    Nodes[n].A := left; Nodes[n].B := right;
    left := n;
  end;
  ParseTerm := left;
end;

function ParseSimpleExpr: LongInt;
var
  left, right, n: LongInt;
begin
  if Tok.Kind in [tkPlus, tkMinus] then begin
    n := NewNode(nkUnary); Nodes[n].Op := Tok.Kind; NextToken;
    Nodes[n].A := ParseTerm;
    left := n;
  end
  else left := ParseTerm;
  while Tok.Kind in AddOps do begin
    { `or else/exit/break/continue/fail` is the failable suffix, lowest precedence: stop the
      boolean loop and leave it for ParseFailSuffix (doc/languages/kobold/kp-errors.md) }
    if (Tok.Kind = tkOr) and OrIntroducesFailSuffix then Break;
    n := NewNode(nkBinary); Nodes[n].Op := Tok.Kind; NextToken;
    if OptOverflowChecks then Nodes[n].Flag := 1;
    right := ParseTerm;
    Nodes[n].A := left; Nodes[n].B := right;
    left := n;
  end;
  ParseSimpleExpr := left;
end;

function ParseComparison: LongInt;
var
  left, right, n: LongInt;
begin
  left := ParseSimpleExpr;
  if Tok.Kind in RelOps then begin
    n := NewNode(nkBinary); Nodes[n].Op := Tok.Kind; NextToken;
    right := ParseSimpleExpr;
    Nodes[n].A := left; Nodes[n].B := right;
    left := n;
  end;
  ParseComparison := left;
end;

function OrIntroducesFailSuffix: Boolean;
{ With the current token `or`, True when the token after it begins a failable suffix
  (else / break / continue / exit / fail), so the `or` is the failable recover or divert,
  not the boolean operator. The words exit and fail are matched by text: they are builtins,
  not reserved, and neither can legally begin a boolean operand (doc/languages/kobold/kp-errors.md). }
var
  k: TTokenKind;
  t: string;
begin
  PeekNext(k, t);
  OrIntroducesFailSuffix :=
    (k = tkElse) or (k = tkBreak) or (k = tkContinue) or
    ((k = tkIdent) and ((t = 'exit') or (t = 'fail')));
end;

function ParseFailSuffix(left: LongInt): LongInt;
{ Attach a failable call-site form to `left` if one follows: the `fails [e]` postfix test,
  `or else EXPR`, `or else ignore`, or an `or exit|break|continue|fail` divert. Returns `left`
  unchanged when no suffix is present. The whole left expression is the failable call; sema
  checks it actually resolves to one. }
var
  n: LongInt;
begin
  ParseFailSuffix := left;
  if (Tok.Kind = tkIdent) and (SameTextCI(Tok.Text, 'fails')) then begin
    { `X fails` test, with an optional binder identifier naming the error }
    n := NewNode(nkFailsTest); Nodes[n].A := left;
    NextToken;
    if Tok.Kind = tkIdent then begin
      Nodes[n].Text := Tok.Text; NextToken;   { a new variable bound to the error }
    end;
    ParseFailSuffix := n;
  end
  else if (Tok.Kind = tkOr) and OrIntroducesFailSuffix then begin
    NextToken;   { consume `or` }
    case Tok.Kind of
      tkElse: begin
        NextToken;
        if (Tok.Kind = tkIdent) and (SameTextCI(Tok.Text, 'ignore')) then begin
          n := NewNode(nkOrElse); Nodes[n].A := left; Nodes[n].Flag := 1; Nodes[n].B := -1;
          NextToken;   { `or else ignore`: discard the error }
        end
        else begin
          n := NewNode(nkOrElse); Nodes[n].A := left; Nodes[n].Flag := 0;
          Nodes[n].B := ParseExpression;   { `or else EXPR`: the fallback value }
        end;
      end;
      tkBreak:    begin n := NewNode(nkOrDivert); Nodes[n].A := left; Nodes[n].Flag := 1; NextToken; end;
      tkContinue: begin n := NewNode(nkOrDivert); Nodes[n].A := left; Nodes[n].Flag := 2; NextToken; end;
    else
      { an identifier: exit or fail (OrIntroducesFailSuffix already vetted it) }
      n := NewNode(nkOrDivert); Nodes[n].A := left;
      if SameTextCI(Tok.Text, 'fail') then Nodes[n].Flag := 3 else Nodes[n].Flag := 0;
      NextToken;
    end;
    ParseFailSuffix := n;
  end;
end;

function ParseExpression: LongInt;
begin
  ParseExpression := ParseFailSuffix(ParseComparison);
end;

function ParseStart: LongInt;
var
  n: LongInt;
begin
  n := NewNode(nkStart);
  Expect(tkStart);
  if Tok.Kind = tkBegin then begin
    Nodes[n].Flag := 1; Nodes[n].A := ParseCompound;
  end
  else begin
    Nodes[n].Flag := 0; Nodes[n].A := ParseExpression;
  end;
  ParseStart := n;
end;

function ParseYield: LongInt;
var
  n: LongInt;
begin
  n := NewNode(nkYield);
  Expect(tkYield);
  if Tok.Kind in ExprStart then Nodes[n].A := ParseExpression;
  ParseYield := n;
end;

function ParseBind: LongInt;
var
  n: LongInt;
begin
  n := NewNode(nkBind);
  Expect(tkBind);
  Nodes[n].Text := EatIdent('a process name');
  Expect(tkIn);
  Nodes[n].A := ParseExpression;
  ParseBind := n;
end;

function ParseSubrangeType: LongInt;
var
  n, t: LongInt;
  name: string;
  ln, cl: LongInt;
begin
  if Tok.Kind = tkIdent then begin
    name := Tok.StrVal; ln := Tok.Line; cl := Tok.Col; NextToken;
    if Accept(tkLParen) then begin
      n := NewNode(nkSubrange); Nodes[n].Line := ln; Nodes[n].Col := cl;
      Nodes[n].Flag := 1; Nodes[n].Text := name;
      Nodes[n].A := ParseExpression; Expect(tkDotDot);
      Nodes[n].B := ParseExpression; Expect(tkRParen);
    end
    else if Tok.Kind = tkDotDot then begin
      n := NewNode(nkSubrange); Nodes[n].Line := ln; Nodes[n].Col := cl;
      t := NewNode(nkIdent); Nodes[t].Text := name;
      Nodes[n].A := t;
      Expect(tkDotDot);
      Nodes[n].B := ParseExpression;
    end
    else begin
      { a named ordinal type used as an array index, array[TColor]: its whole range }
      n := NewNode(nkSubrange); Nodes[n].Line := ln; Nodes[n].Col := cl;
      Nodes[n].Flag := 2; Nodes[n].Text := name;
    end;
  end
  else begin
    n := NewNode(nkSubrange);
    Nodes[n].A := ParseExpression; Expect(tkDotDot);
    Nodes[n].B := ParseExpression;
  end;
  ParseSubrangeType := n;
end;

procedure ParseFormalParams(owner: LongInt);
var
  p: LongInt;
begin
  Expect(tkLParen);
  if Tok.Kind <> tkRParen then
    repeat
      p := NewNode(nkParam);
      { `out` is a contextual keyword: a mode only when it leads a parameter
        group (an identifier list follows), so an identifier named `out` is
        unaffected. `var` and `out` pass by reference, `const` by value. }
      if Accept(tkVar) then Nodes[p].Flag := 1
      else if Accept(tkConst) then Nodes[p].Flag := 2
      else if (Tok.Kind = tkIdent) and (SameTextCI(Tok.Text, 'out')) and
              (PeekTokenKind = tkIdent) then begin
        NextToken; Nodes[p].Flag := 3;
      end
      else Nodes[p].Flag := 0;
      ParseIdentList(p);
      Expect(tkColon);
      Nodes[p].A := ParseType;
      AddKid(owner, p);
    until not Accept(tkSemicolon);
  Expect(tkRParen);
end;

function ParseProcType: LongInt;
var
  pt: LongInt;
begin
  pt := NewNode(nkProcType);
  if Accept(tkFunction) then Nodes[pt].Flag := 1
  else begin Expect(tkProcedure); Nodes[pt].Flag := 0; end;
  if Tok.Kind = tkLParen then ParseFormalParams(pt);
  if Nodes[pt].Flag = 1 then begin
    Expect(tkColon); Nodes[pt].B := ParseType;
  end;
  ParseProcType := pt;
end;

function ParseReceiver: LongInt;
var
  rc, t, q: LongInt;
  name: string;
begin
  rc := NewNode(nkReceiver);
  Expect(tkLParen);
  if Accept(tkConst) then Nodes[rc].Flag := 1;
  Nodes[rc].Text := EatIdent('a receiver name');
  Expect(tkColon);
  name := EatIdent('a type name');
  t := NewNode(nkTypeRef);
  if Tok.Kind = tkDot then begin
    { a unit-qualified receiver type, a.Point: A holds the qualifier ident }
    NextToken;
    q := NewNode(nkIdent); Nodes[q].Text := name;
    Nodes[t].A := q;
    Nodes[t].Text := EatIdent('a type name');
  end
  else
    Nodes[t].Text := name;
  Nodes[rc].A := t;
  Expect(tkRParen);
  ParseReceiver := rc;
end;

function ParseInterfaceType: LongInt;
var
  it, f: LongInt;
begin
  it := NewNode(nkInterfaceType);
  Expect(tkInterface);
  while Tok.Kind = tkIdent do begin
    f := NewNode(nkInterfaceField);
    Nodes[f].Text := EatIdent('a method name');
    Expect(tkColon);
    Nodes[f].A := ParseProcType;
    Expect(tkSemicolon);
    AddKid(it, f);
  end;
  Expect(tkEnd);
  ParseInterfaceType := it;
end;

function ParseVariantPart: LongInt;
var
  vp, v, ll, cl, f, disc: LongInt;
  id1: string;
begin
  vp := NewNode(nkVariantPart);
  Expect(tkCase);
  id1 := EatIdent('a discriminant or tag name');
  if Accept(tkColon) then begin
    Nodes[vp].Text := id1;
    disc := NewNode(nkTypeRef); Nodes[disc].Text := EatIdent('a type name');
  end
  else begin
    disc := NewNode(nkTypeRef); Nodes[disc].Text := id1;
  end;
  Nodes[vp].A := disc;
  Expect(tkOf);
  while not (Tok.Kind in [tkEnd, tkRParen, tkEOF]) do begin
    v := NewNode(nkVariant);
    ll := NewNode(nkCaseLabelList);
    repeat
      cl := NewNode(nkCaseLabel);
      Nodes[cl].A := ParseExpression;
      if Accept(tkDotDot) then Nodes[cl].B := ParseExpression;
      AddKid(ll, cl);
    until not Accept(tkComma);
    Nodes[v].A := ll;
    Expect(tkColon); Expect(tkLParen);
    while Tok.Kind = tkIdent do begin
      f := NewNode(nkFieldDecl);
      ParseIdentList(f);
      Expect(tkColon);
      Nodes[f].A := ParseType;
      AddKid(v, f);
      if not Accept(tkSemicolon) then Break;
    end;
    Expect(tkRParen);
    AddKid(vp, v);
    if not Accept(tkSemicolon) then Break;
  end;
  ParseVariantPart := vp;
end;

function ParseRecordType: LongInt;
var
  r, f: LongInt;
begin
  r := NewNode(nkRecordType);
  Expect(tkRecord);
  while Tok.Kind = tkIdent do begin
    f := NewNode(nkFieldDecl);
    ParseIdentList(f);
    Expect(tkColon);
    Nodes[f].A := ParseType;
    if IsDirective('read') then begin
      { a computed field: `name: Type read getX [write setX]` (doc/languages/kobold/kp-property.md).
        Only a single-name field may be computed. }
      if High(Nodes[f].Kids) <> 0 then
        ParseErr('a computed field names one field only');
      Nodes[f].Flag := 1;
      ParseAccessorSpec(f);
    end;
    AddKid(r, f);
    if not Accept(tkSemicolon) then Break;
  end;
  if Tok.Kind = tkCase then begin
    AddKid(r, ParseVariantPart);
    Accept(tkSemicolon);
  end;
  Expect(tkEnd);
  ParseRecordType := r;
end;

function ParseType: LongInt;
var
  n, t: LongInt;
  name: string;
  ln, cl: LongInt;
begin
  case Tok.Kind of
    tkArray: begin
      n := NewNode(nkArrayType); NextToken;
      if Accept(tkOf) then
        { a dynamic array `array of T`: no index subranges, so no subrange kids }
        Nodes[n].A := ParseType()
      else begin
        Expect(tkLBracket);
        AddKid(n, ParseSubrangeType);
        while Accept(tkComma) do AddKid(n, ParseSubrangeType);
        Expect(tkRBracket);
        Expect(tkOf);
        Nodes[n].A := ParseType();   { () forces the recursive call }
      end;
    end;
    tkBuffer: begin
      { `buffer of T`: a reference dynamic array whose element backing is host-owned. Same node
        shape; Flag=2 marks it a buffer. An optional `[,...]` gives the rank for a multidimensional
        buffer (a single strided region, extents host-set at run time): the comma count plus one is
        the dimension count, so `buffer[,] of T` is 2D and `buffer[,,] of T` is 3D. The rank
        goes in IntVal, a scalar field; the child slots A..D must not hold it, since tree
        walkers recurse into those. 1 when no brackets. }
      n := NewNode(nkArrayType); Nodes[n].Flag := 2; NextToken;
      Nodes[n].IntVal := 1;
      if Accept(tkLBracket) then begin
        while Accept(tkComma) do Nodes[n].IntVal := Nodes[n].IntVal + 1;
        Expect(tkRBracket);
      end;
      Expect(tkOf);
      Nodes[n].A := ParseType();
    end;
    tkRecord: n := ParseRecordType;
    tkSet: begin
      n := NewNode(nkSetType); NextToken; Expect(tkOf);
      Nodes[n].A := ParseType();
    end;
    tkMap: begin
      { `map of T`: a string-keyed associative array whose value type is T.
        `map[K] of T`: an explicit ordinal (or string) key type K. }
      n := NewNode(nkMapType); NextToken;
      if Accept(tkLBracket) then begin
        Nodes[n].B := ParseType();   { the explicit key type; absent (B < 0) means string }
        Expect(tkRBracket);
      end;
      Expect(tkOf);
      Nodes[n].A := ParseType();
    end;
    tkInterface: n := ParseInterfaceType;
    tkProcedure, tkFunction: n := ParseProcType;
    tkLParen: begin
      n := NewNode(nkEnumType); NextToken;
      ParseIdentList(n);
      Expect(tkRParen);
    end;
    tkString: begin
      n := NewNode(nkTypeRef); Nodes[n].Text := 'string'; NextToken;
    end;
    tkLabel: begin
      { the `label` code-address type (threaded dispatch); resolved to tyLabel }
      n := NewNode(nkTypeRef); Nodes[n].Text := 'label'; NextToken;
    end;
    tkIdent: begin
      name := Tok.StrVal; ln := Tok.Line; cl := Tok.Col; NextToken;
      if Tok.Kind = tkLParen then begin
        n := NewNode(nkSubrange); Nodes[n].Line := ln; Nodes[n].Col := cl;
        Nodes[n].Flag := 1; Nodes[n].Text := name; NextToken;
        Nodes[n].A := ParseExpression; Expect(tkDotDot);
        Nodes[n].B := ParseExpression; Expect(tkRParen);
      end
      else if Tok.Kind = tkDotDot then begin
        n := NewNode(nkSubrange); Nodes[n].Line := ln; Nodes[n].Col := cl;
        t := NewNode(nkIdent); Nodes[t].Text := name;
        Nodes[n].A := t; NextToken;
        Nodes[n].B := ParseExpression;
      end
      else if Tok.Kind = tkDot then begin
        { a unit-qualified type name, geo.Vec: A holds the qualifier ident }
        NextToken;
        n := NewNode(nkTypeRef); Nodes[n].Line := ln; Nodes[n].Col := cl;
        t := NewNode(nkIdent); Nodes[t].Text := name;
        Nodes[n].A := t;
        Nodes[n].Text := EatIdent('a type name');
      end
      else begin
        n := NewNode(nkTypeRef); Nodes[n].Line := ln; Nodes[n].Col := cl;
        Nodes[n].Text := name;
      end;
    end;
  else
    if Tok.Kind in ExprStart then begin
      n := NewNode(nkSubrange);
      Nodes[n].A := ParseExpression; Expect(tkDotDot);
      Nodes[n].B := ParseExpression;
    end
    else begin
      ParseErr('expected a type, found ' + TokenName[Tok.Kind]);
      n := NewNode(nkTypeRef);
    end;
  end;
  ParseType := n;
end;

procedure ParseStmtSeq(owner: LongInt);
var
  s: LongInt;
begin
  while True do begin
    s := ParseStatement;
    if Nodes[s].Kind <> nkEmpty then AddKid(owner, s);
    if Tok.Kind = tkSemicolon then NextToken
    else if (Tok.Kind in StmtTerm) or (Tok.Kind = tkElse) then Break
    else begin
      ParseErr('expected ";" after statement');
      Synchronize(StmtTerm + StmtStart + [tkSemicolon, tkElse]);
      if Tok.Kind = tkSemicolon then NextToken
      else if (Tok.Kind in StmtTerm) or (Tok.Kind = tkElse) then Break;
    end;
  end;
end;

function ParseCompound: LongInt;
var
  c: LongInt;
begin
  c := NewNode(nkCompound);
  Expect(tkBegin);
  ParseStmtSeq(c);
  Expect(tkEnd);
  ParseCompound := c;
end;

function ParseCaseStmt: LongInt;
var
  n, ce, ll, cl, elseC: LongInt;
begin
  n := NewNode(nkCase);
  Expect(tkCase);
  Nodes[n].A := ParseExpression;
  Expect(tkOf);
  while not (Tok.Kind in [tkEnd, tkElse, tkEOF]) do begin
    ce := NewNode(nkCaseElement);
    ll := NewNode(nkCaseLabelList);
    repeat
      cl := NewNode(nkCaseLabel);
      Nodes[cl].A := ParseExpression;
      if Accept(tkDotDot) then Nodes[cl].B := ParseExpression;
      AddKid(ll, cl);
    until not Accept(tkComma);
    Nodes[ce].A := ll;
    Expect(tkColon);
    Nodes[ce].B := ParseStatement;
    AddKid(n, ce);
    if not Accept(tkSemicolon) then Break;
  end;
  if Accept(tkElse) then begin
    elseC := NewNode(nkCompound);
    ParseStmtSeq(elseC);
    AddKid(n, elseC);
  end;
  Expect(tkEnd);
  ParseCaseStmt := n;
end;

procedure ParseAsmOperands(parent: LongInt; isOutput: Boolean);
{ Parse one extended-asm operand section: zero or more `"constraint" ( expr )`
  entries, comma separated, each attached to the nkAsm parent as an nkAsmOp child.
  An output whose constraint begins with `+` is read-write (Flag 2); a plain output
  is Flag 1 and an input is Flag 0. The section ends at the next `:` or the closing
  `)`. }
var
  op, c: LongInt;
begin
  if Tok.Kind in [tkColon, tkRParen] then Exit;   { an empty section }
  repeat
    op := NewNode(nkAsmOp);
    if Tok.Kind = tkStrLit then begin
      Nodes[op].Text := Tok.StrVal; NextToken;
    end
    else
      ParseErr('an asm operand needs a "constraint" string');
    Expect(tkLParen);
    if isOutput then c := ParseDesignator else c := ParseExpression;
    Nodes[op].A := c;
    Expect(tkRParen);
    if isOutput then begin
      if (Length(Nodes[op].Text) >= 1) and (Nodes[op].Text[1] = '+') then
        Nodes[op].Flag := 2
      else
        Nodes[op].Flag := 1;
    end
    else
      Nodes[op].Flag := 0;
    AddKid(parent, op);
  until not Accept(tkComma);
end;

procedure ParseAsmClobbers(parent: LongInt);
{ Parse the clobber section: zero or more bare `"register"` strings, comma
  separated, each an nkAsmOp child with Flag 3 and no expression. }
var
  op: LongInt;
begin
  if Tok.Kind = tkRParen then Exit;
  repeat
    op := NewNode(nkAsmOp);
    if Tok.Kind = tkStrLit then begin
      Nodes[op].Text := Tok.StrVal; NextToken;
    end
    else
      ParseErr('an asm clobber needs a "register" string');
    Nodes[op].A := -1;
    Nodes[op].Flag := 3;
    AddKid(parent, op);
  until not Accept(tkComma);
end;

function ParseStatement: LongInt;
var
  n, d: LongInt;
  firstBinder: string;
begin
  { A statement may nest another statement. The recursive calls use () because a
    bare function name inside its own body denotes the result variable, not a
    call. }
  { a `name:` label prefix (threaded dispatch): an identifier immediately
    followed by a lone colon names the statement that follows as a jump target.
    Told apart from an assignment (`name :=`) and a call (`name(` / `name.`) by
    the single colon. }
  if (Tok.Kind = tkIdent) and (PeekTokenKind = tkColon) then begin
    n := NewNode(nkLabelStmt);
    Nodes[n].Text := Tok.StrVal; NextToken;   { the label name }
    Expect(tkColon);
    Nodes[n].A := ParseStatement();           { the labeled statement }
    ParseStatement := n;
    Exit;
  end;
  case Tok.Kind of
    tkBegin: n := ParseCompound;
    tkIf: begin
      n := NewNode(nkIf); NextToken;
      Nodes[n].A := ParseExpression; Expect(tkThen);
      Nodes[n].B := ParseStatement();
      if Accept(tkElse) then Nodes[n].C := ParseStatement();
    end;
    tkWhile: begin
      n := NewNode(nkWhile); NextToken;
      Nodes[n].A := ParseExpression; Expect(tkDo);
      Nodes[n].B := ParseStatement();
    end;
    tkFor: begin
      NextToken;   { past 'for' }
      firstBinder := ParseForBinder;
      if (Tok.Kind = tkIn) or (Tok.Kind = tkComma) then begin
        { for-in: `for x in e do` or, over a map, `for k, v in m do`. Use '_' to
          ignore a binder (doc/languages/kobold/kp-foreach.md). }
        n := NewNode(nkForIn);
        Nodes[n].Text := firstBinder;
        Nodes[n].B := -1;   { second binder (map value), an nkIdent, or -1 }
        if Accept(tkComma) then begin
          Nodes[n].B := NewNode(nkIdent);
          Nodes[Nodes[n].B].Text := ParseForBinder;
        end;
        Expect(tkIn);
        Nodes[n].A := ParseExpression;
        Expect(tkDo);
        Nodes[n].C := ParseStatement();
      end
      else begin
        { the counted loop: `for i := lo to|downto hi do` }
        n := NewNode(nkFor);
        Nodes[n].Text := firstBinder;
        Expect(tkAssign);
        Nodes[n].A := ParseExpression;
        if Accept(tkDownto) then Nodes[n].Flag := 1
        else begin Expect(tkTo); Nodes[n].Flag := 0; end;
        Nodes[n].B := ParseExpression;
        Expect(tkDo);
        Nodes[n].C := ParseStatement();
      end;
    end;
    tkRepeat: begin
      n := NewNode(nkRepeat); NextToken;
      ParseStmtSeq(n);
      Expect(tkUntil);
      Nodes[n].A := ParseExpression;
    end;
    tkCase: n := ParseCaseStmt;
    tkWith: begin
      n := NewNode(nkWith); NextToken;
      AddKid(n, ParseDesignator);
      while Accept(tkComma) do AddKid(n, ParseDesignator);
      Expect(tkDo);
      Nodes[n].A := ParseStatement();
    end;
    tkStart: n := ParseStart;
    tkBind: n := ParseBind;
    tkYield: n := ParseYield;
    tkBreak: begin n := NewNode(nkBreak); NextToken; end;
    tkContinue: begin n := NewNode(nkContinue); NextToken; end;
    tkAsm: begin
      { `asm('text')`: basic inline assembly. The one string literal is emitted
        verbatim to the generated assembly; there are no operand constraints and
        no dollar-brace interpolation (the text is taken as written). AOT only:
        the JIT does not assemble text (doc/languages/kobold/kp-grammar.md). }
      n := NewNode(nkAsm); NextToken;
      Expect(tkLParen);
      if Tok.Kind in [tkStrLit, tkInterpStr] then begin
        Nodes[n].Text := Tok.StrVal; NextToken;
      end
      else
        ParseErr('asm expects a string literal with the assembly text');
      { optional extended form, GNU style: `: outputs : inputs : clobbers`. Each
        operand is `"constraint" ( expr )`; a clobber is a bare `"register"`. The
        operands become nkAsmOp children, outputs then inputs then clobbers. }
      if Accept(tkColon) then begin
        ParseAsmOperands(n, True);
        if Accept(tkColon) then begin
          ParseAsmOperands(n, False);
          if Accept(tkColon) then
            ParseAsmClobbers(n);
        end;
      end;
      Expect(tkRParen);
    end;
    tkDefer: begin
      { `defer STMT` registers STMT for LIFO teardown at the end of its block
        (doc/languages/kobold/kp-defer.md); use a begin..end block for several }
      n := NewNode(nkDefer); NextToken; Nodes[n].A := ParseStatement();
    end;
    tkGoto: begin
      { a computed jump: `goto EXPR` where EXPR has type label. A bare
        `goto name` to a label identifier is rejected in sema, so there is no
        unstructured goto. }
      n := NewNode(nkGoto); NextToken;
      Nodes[n].A := ParseExpression;
    end;
    tkIdent: begin
      d := ParseDesignator;
      if Accept(tkAssign) then begin
        n := NewNode(nkAssign); Nodes[n].A := d;
        Nodes[n].B := ParseExpression;
      end
      else begin
        { a bare call may carry a failable form: `log(m) or else ignore;`, `step() or fail;` }
        d := ParseFailSuffix(d);
        if Nodes[d].Kind in [nkFailsTest, nkOrElse, nkOrDivert] then
          n := d
        else begin
          n := NewNode(nkCallStmt); Nodes[n].A := d;
        end;
      end;
    end;
    tkSemicolon, tkEnd, tkUntil, tkElse, tkEOF:
      n := NewNode(nkEmpty);
  else
    ParseErr('expected a statement, found ' + TokenName[Tok.Kind]);
    n := NewNode(nkEmpty);
    NextToken;   { consume the offending token to guarantee progress }
  end;
  ParseStatement := n;
end;

procedure ParseConstPart(owner: LongInt);
var
  c: LongInt;
begin
  Expect(tkConst);
  while Tok.Kind = tkIdent do begin
    c := NewNode(nkConstDecl);
    Nodes[c].Text := Tok.StrVal; NextToken;
    if Accept(tkColon) then Nodes[c].A := ParseType;
    { `= value` is optional: `const Name: Type;` with no value is a link-time constant, valid
      only in a unit interface, whose value the implementation supplies (doc/languages/kobold/kp-units.md). }
    if Accept(tkEq) then Nodes[c].B := ParseExpression;
    Expect(tkSemicolon);
    AddKid(owner, c);
  end;
end;

procedure ParseTypePart(owner: LongInt);
var
  t: LongInt;
begin
  Expect(tkType);
  while Tok.Kind = tkIdent do begin
    t := NewNode(nkTypeDecl);
    Nodes[t].Text := Tok.StrVal; NextToken;
    Expect(tkEq);
    Nodes[t].A := ParseType;
    Expect(tkSemicolon);
    AddKid(owner, t);
  end;
end;

procedure ParseVarPart(owner: LongInt);
var
  v: LongInt;
begin
  Expect(tkVar);
  while Tok.Kind = tkIdent do begin
    v := NewNode(nkVarDecl);
    ParseIdentList(v);
    Expect(tkColon);
    Nodes[v].A := ParseType;
    if Accept(tkEq) then Nodes[v].B := ParseExpression;
    Expect(tkSemicolon);
    AddKid(owner, v);
  end;
end;

function IsDirective(const w: string): Boolean;
{ True when the current token is an identifier matching a contextual directive word,
  such as `cdecl`. Contextual so the word stays usable as an ordinary identifier. }
begin
  IsDirective := (Tok.Kind = tkIdent) and (SameTextCI(Tok.Text, w));
end;

function ParseProcOrFunc: LongInt;
var
  d, blk: LongInt;
  isFunc: Boolean;
begin
  isFunc := (Tok.Kind = tkFunction);
  NextToken;
  if isFunc then d := NewNode(nkFuncDecl) else d := NewNode(nkProcDecl);
  Nodes[d].Text := EatIdent('a routine name');
  if Tok.Kind = tkFor then begin
    { method form: 'for' Receiver [FormalParams] [':' Type] ';' Block ';' }
    NextToken;
    Nodes[d].A := ParseReceiver;
    if Tok.Kind = tkLParen then ParseFormalParams(d);
    if isFunc then begin Expect(tkColon); Nodes[d].B := ParseType; end;
    if IsDirective('fails') then begin Nodes[d].Failable := 1; NextToken; end;
    Expect(tkSemicolon);
    blk := ParseBlock; AddKid(d, blk);
    Expect(tkSemicolon);
  end
  else begin
    if Tok.Kind = tkLParen then ParseFormalParams(d);
    if isFunc then begin Expect(tkColon); Nodes[d].B := ParseType; end;
    if IsDirective('fails') then begin Nodes[d].Failable := 1; NextToken; end;
    Expect(tkSemicolon);
    if Accept(tkForward) then begin
      Nodes[d].Flag := 1; Expect(tkSemicolon);
    end
    else if (Tok.Kind = tkExternal) or IsDirective('cdecl') then begin
      { a host import. `cdecl` names the C/SysV calling convention explicitly; it may
        appear before or after `external`. Both spellings bridge through the host FFI. }
      Nodes[d].Flag := 2;
      while (Tok.Kind = tkExternal) or IsDirective('cdecl') do
        if Tok.Kind = tkExternal then NextToken
        else begin NextToken; Nodes[d].CConv := 1; end;
      Expect(tkSemicolon);
    end
    else begin
      if IsDirective('export') then begin
        { a module entry: emit a `.export` so an embedding host can call this routine
          across the FFI, in addition to lowering its body }
        Nodes[d].Exported := 1;
        NextToken; Expect(tkSemicolon);
      end;
      blk := ParseBlock; AddKid(d, blk);
      Expect(tkSemicolon);
    end;
  end;
  ParseProcOrFunc := d;
end;

function ParseImplement: LongInt;
{ ImplementDecl = 'implement' Identifier 'for' Identifier ';'. A nominal, static assertion
  that record R (the second name, in A) conforms to interface I (the first name, in Text):
  the sema pass checks R's for-receiver methods match I's signatures (doc/languages/kobold/kobold.md). }
var
  n, r: LongInt;
begin
  n := NewNode(nkImplement);
  Expect(tkImplement);
  Nodes[n].Text := EatIdent('an interface name');
  Expect(tkFor);
  r := NewNode(nkIdent);
  Nodes[r].Text := EatIdent('a record type name');
  Nodes[n].A := r;
  Expect(tkSemicolon);
  ParseImplement := n;
end;

procedure ParseAccessorSpec(d: LongInt);
{ AccessorSpec = 'read' Identifier [ 'write' Identifier ] (doc/languages/kobold/kp-property.md).
  `read` and `write` are contextual words, so they stay usable as the ordinary built-in
  procedures elsewhere. The getter ident node is stored in Nodes[d].B and an optional setter
  ident node in Nodes[d].C (-1 when the property is read-only). }
var
  w: LongInt;
begin
  if not IsDirective('read') then
    ParseErr('a property needs a ''read'' accessor');
  NextToken;
  w := NewNode(nkIdent);
  Nodes[w].Text := EatIdent('a getter routine name');
  Nodes[d].B := w;
  if IsDirective('write') then begin
    NextToken;
    w := NewNode(nkIdent);
    Nodes[w].Text := EatIdent('a setter routine name');
    Nodes[d].C := w;
  end;
end;

function ParsePropertyDecl: LongInt;
{ PropertyDecl = 'property' Identifier ':' Type AccessorSpec ';' (doc/languages/kobold/kp-property.md).
  Text is the property name, A the type node, B the getter ident node, C the setter ident
  node or -1. }
var
  d: LongInt;
begin
  d := NewNode(nkPropertyDecl);
  Expect(tkProperty);
  Nodes[d].Text := EatIdent('a property name');
  Expect(tkColon);
  Nodes[d].A := ParseType;
  ParseAccessorSpec(d);
  Expect(tkSemicolon);
  ParsePropertyDecl := d;
end;

function ParseBlock: LongInt;
var
  b: LongInt;
begin
  b := NewNode(nkBlock);
  while Tok.Kind in DeclStart do
    case Tok.Kind of
      tkConst: ParseConstPart(b);
      tkType: ParseTypePart(b);
      tkVar: ParseVarPart(b);
      tkProcedure, tkFunction: AddKid(b, ParseProcOrFunc);
      tkImplement: AddKid(b, ParseImplement);
      tkProperty: AddKid(b, ParsePropertyDecl);
    end;
  AddKid(b, ParseCompound);
  ParseBlock := b;
end;

function ParseProgram: LongInt;
var
  p: LongInt;
begin
  p := NewNode(nkProgram);
  Expect(tkProgram);
  Nodes[p].Text := EatIdent('a program name');
  Expect(tkSemicolon);
  if Tok.Kind = tkUses then Nodes[p].B := ParseUsesClause;   { A = block, B = uses or -1 }
  Nodes[p].A := ParseBlock;
  Expect(tkDot);
  ParseProgram := p;
end;

{ Units and separate compilation (doc/languages/kobold/kp-units.md, doc/languages/kobold/kp-grammar.md). These routines parse a
  `unit` file and the `uses` / `reexport` clauses into the AST. Cross-unit resolution, interface
  emission, and linking are implemented downstream (AnalyzeUnit, LowerUnit, the loader). }

function ParseUnitImport: LongInt;
{ UnitImport = UnitName [ 'as' Qualifier ] [ '(' ImportItem, ... ')' ]
             | UnitName '.' '*' .
  UnitName is dotted (core.strings); the last segment is the default qualifier.
  Text is the full dotted unit name; A is the qualifier ident ('_' means bare) or
  -1 for the default (the last segment); Kids are the selective ImportItems, empty
  when no list.  Flag = 1 marks a wildcard import of the namespace in Text. }
var
  item, q, ii, r: LongInt;
begin
  item := NewNode(nkUsesItem);
  Nodes[item].Text := EatIdent('a unit name');
  while Tok.Kind = tkDot do begin
    NextToken;                        { consume '.' }
    if Tok.Kind = tkStar then begin
      NextToken;                      { consume '*': a namespace wildcard }
      Nodes[item].Flag := 1;
      ParseUnitImport := item;        { no 'as' and no selective list on a wildcard }
      Exit;
    end;
    Nodes[item].Text := Nodes[item].Text + '.' + EatIdent('a unit name segment');
  end;
  if Accept(tkAs) then begin
    q := NewNode(nkIdent);
    if Accept(tkUnderscore) then Nodes[q].Text := '_'
    else Nodes[q].Text := EatIdent('a qualifier');
    Nodes[item].A := q;
  end;
  if Accept(tkLParen) then begin
    repeat
      ii := NewNode(nkImportItem);
      Nodes[ii].Text := EatIdent('an imported name');
      if Accept(tkAs) then begin
        r := NewNode(nkIdent);
        Nodes[r].Text := EatIdent('a local name');
        Nodes[ii].A := r;
      end;
      AddKid(item, ii);
    until not Accept(tkComma);
    Expect(tkRParen);
  end;
  ParseUnitImport := item;
end;

function ParseUsesClause: LongInt;
{ UsesClause = 'uses' UnitImport, ... ';'. Kids are the UnitImports. }
var
  u: LongInt;
begin
  Expect(tkUses);
  u := NewNode(nkUses);
  repeat
    AddKid(u, ParseUnitImport);
  until not Accept(tkComma);
  Expect(tkSemicolon);
  ParseUsesClause := u;
end;

procedure ParseExportedTypePart(owner: LongInt);
{ ExportedTypeDef = Identifier '=' Type ';' | Identifier ';'. The second form is an
  opaque type: the name is exported (Flag = 1) and its definition lives in the
  implementation part. }
var
  t: LongInt;
begin
  Expect(tkType);
  while Tok.Kind = tkIdent do begin
    t := NewNode(nkTypeDecl);
    Nodes[t].Text := Tok.StrVal; NextToken;
    if Accept(tkEq) then Nodes[t].A := ParseType
    else Nodes[t].Flag := 1;
    Expect(tkSemicolon);
    AddKid(owner, t);
  end;
end;

procedure ParseExportedVar(owner: LongInt);
{ VarDeclPart = [ 'shared' ] 'var' VarDecl.... A `shared` part marks its var
  decls one-instance-across-contexts (Flag = 1); the default is thread-local. }
var
  v, sh: LongInt;
begin
  sh := 0;
  if Accept(tkShared) then sh := 1;
  Expect(tkVar);
  while Tok.Kind = tkIdent do begin
    v := NewNode(nkVarDecl);
    Nodes[v].Flag := sh;
    ParseIdentList(v);
    Expect(tkColon);
    Nodes[v].A := ParseType;
    if Accept(tkEq) then Nodes[v].B := ParseExpression;
    Expect(tkSemicolon);
    AddKid(owner, v);
  end;
end;

function ParseReexportClause: LongInt;
{ ReexportClause = 'reexport' ReexportItem, ... ';'.
  ReexportItem = Identifier [ '(' Identifier, ... ')' ]. Each item's
  Text is the source unit; its Kids are the promoted name idents (empty for a bare
  item). }
var
  rx, it, nm: LongInt;
begin
  Expect(tkReexport);
  rx := NewNode(nkReexport);
  repeat
    it := NewNode(nkReexportItem);
    Nodes[it].Text := EatIdent('a unit name');
    if Accept(tkLParen) then begin
      repeat
        nm := NewNode(nkIdent);
        Nodes[nm].Text := EatIdent('a name');
        AddKid(it, nm);
      until not Accept(tkComma);
      Expect(tkRParen);
    end;
    AddKid(rx, it);
  until not Accept(tkComma);
  Expect(tkSemicolon);
  ParseReexportClause := rx;
end;

function ParseInterfaceHeading: LongInt;
{ ProcOrFuncHeading ';' in the interface: a routine or method exported by heading
  only, its body supplied in the implementation part (Flag = 3). A `for` Receiver in
  A marks a method, as in ParseProcOrFunc. }
var
  d: LongInt;
  isFunc: Boolean;
begin
  isFunc := (Tok.Kind = tkFunction);
  NextToken;
  if isFunc then d := NewNode(nkFuncDecl) else d := NewNode(nkProcDecl);
  Nodes[d].Text := EatIdent('a routine name');
  if Tok.Kind = tkFor then begin
    NextToken;
    Nodes[d].A := ParseReceiver;
  end;
  if Tok.Kind = tkLParen then ParseFormalParams(d);
  if isFunc then begin Expect(tkColon); Nodes[d].B := ParseType; end;
  if IsDirective('fails') then begin Nodes[d].Failable := 1; NextToken; end;
  Expect(tkSemicolon);
  Nodes[d].Flag := 3;
  ParseInterfaceHeading := d;
end;

function ParseInterfacePart: LongInt;
{ InterfacePart = 'interface' InterfaceDecl.... Const, exported type, exported var,
  reexport, and routine/method headings, in any order. }
var
  ip: LongInt;
begin
  Expect(tkInterface);
  ip := NewNode(nkInterface);
  while Tok.Kind in [tkConst, tkType, tkVar, tkShared, tkReexport,
                     tkProcedure, tkFunction] do
    case Tok.Kind of
      tkConst: ParseConstPart(ip);
      tkType: ParseExportedTypePart(ip);
      tkVar, tkShared: ParseExportedVar(ip);
      tkReexport: AddKid(ip, ParseReexportClause);
      tkProcedure, tkFunction: AddKid(ip, ParseInterfaceHeading);
    end;
  ParseInterfacePart := ip;
end;

function ParseImplementationPart: LongInt;
{ ImplementationPart = 'implementation' DeclSection.... Full declarations with
  bodies and the opaque types' real definitions, up to the unit's `end`. }
var
  im: LongInt;
begin
  Expect(tkImplementation);
  im := NewNode(nkImplementation);
  while Tok.Kind in [tkConst, tkType, tkVar, tkShared,
                     tkProcedure, tkFunction, tkImplement] do
    case Tok.Kind of
      tkConst: ParseConstPart(im);
      tkType: ParseTypePart(im);
      tkVar, tkShared: ParseExportedVar(im);
      tkProcedure, tkFunction: AddKid(im, ParseProcOrFunc);
      tkImplement: AddKid(im, ParseImplement);
    end;
  ParseImplementationPart := im;
end;

function ParseUnit: LongInt;
{ Unit = 'unit' UnitName ';' [ UsesClause ] InterfacePart ImplementationPart
  'end' '.'. A is the uses clause or -1, B the interface part, C the implementation.
  UnitName is dotted (core.strings): the namespace leads, the last segment names
  the unit. }
var
  u: LongInt;
begin
  u := NewNode(nkUnit);
  Expect(tkUnit);
  Nodes[u].Text := EatIdent('a unit name');
  while Tok.Kind = tkDot do begin
    NextToken;
    Nodes[u].Text := Nodes[u].Text + '.' + EatIdent('a unit name segment');
  end;
  Expect(tkSemicolon);
  if Tok.Kind = tkUses then Nodes[u].A := ParseUsesClause;
  Nodes[u].B := ParseInterfacePart;
  Nodes[u].C := ParseImplementationPart;
  Expect(tkEnd);
  Expect(tkDot);
  ParseUnit := u;
end;

function ParseCompilationUnit: LongInt;
{ A source file is a program or a unit. }
begin
  if Tok.Kind = tkUnit then ParseCompilationUnit := ParseUnit
  else ParseCompilationUnit := ParseProgram;
end;

procedure InitParser;
begin
  NodeCount := 0;
end;

{ ---- AST dump (the --dump-ast output, and the parser test oracle) ---- }

function Spaces(n: LongInt): string;
var
  i: LongInt;
begin
  Spaces := '';
  for i := 1 to n do Spaces := Spaces + ' ';
end;

function IntToStr(v: Int64): string;
begin
  Str(v, IntToStr);
end;

function OpSym(op: TTokenKind): string;
begin
  case op of
    tkPlus:  OpSym := '+';
    tkMinus: OpSym := '-';
    tkStar:  OpSym := '*';
    tkSlash: OpSym := '/';
    tkDiv:   OpSym := 'div';
    tkMod:   OpSym := 'mod';
    tkAnd:   OpSym := 'and';
    tkOr:    OpSym := 'or';
    tkNot:   OpSym := 'not';
    tkShl:   OpSym := 'shl';
    tkShr:   OpSym := 'shr';
    tkEq:    OpSym := '=';
    tkNeq:   OpSym := '<>';
    tkLt:    OpSym := '<';
    tkGt:    OpSym := '>';
    tkLe:    OpSym := '<=';
    tkGe:    OpSym := '>=';
    tkIn:    OpSym := 'in';
  else
    OpSym := TokenName[op];
  end;
end;

function NodeAttr(id: LongInt): string;
begin
  NodeAttr := '';
  case Nodes[id].Kind of
    nkProgram, nkConstDecl, nkTypeRef, nkIdent, nkField,
    nkBind, nkInterfaceField,
    nkUnit, nkUsesItem, nkImportItem, nkReexportItem, nkImplement:
      NodeAttr := Nodes[id].Text;
    nkTypeDecl: begin
      NodeAttr := Nodes[id].Text;
      if Nodes[id].Flag = 1 then NodeAttr := NodeAttr + ' opaque';
    end;
    nkVarDecl:
      if Nodes[id].Flag = 1 then NodeAttr := 'shared';
    nkIntLit:  NodeAttr := IntToStr(Nodes[id].IntVal);
    nkRealLit: NodeAttr := Nodes[id].Text;
    nkStrLit:  NodeAttr := EscapeStr(Nodes[id].Text);
    nkBinary, nkUnary: NodeAttr := OpSym(Nodes[id].Op);
    nkFor: begin
      NodeAttr := Nodes[id].Text;
      if Nodes[id].Flag = 1 then NodeAttr := NodeAttr + ' downto'
      else NodeAttr := NodeAttr + ' to';
    end;
    nkStart:
      if Nodes[id].Flag = 1 then NodeAttr := 'block' else NodeAttr := 'expr';
    nkFailsTest:
      if Nodes[id].Text <> '' then NodeAttr := 'bind ' + Nodes[id].Text;
    nkOrElse:
      if Nodes[id].Flag = 1 then NodeAttr := 'ignore';
    nkOrDivert:
      case Nodes[id].Flag of
        1: NodeAttr := 'break';
        2: NodeAttr := 'continue';
        3: NodeAttr := 'fail';
      else
        NodeAttr := 'exit';
      end;
    nkReceiver: begin
      if Nodes[id].Flag = 1 then NodeAttr := 'const ';
      NodeAttr := NodeAttr + Nodes[id].Text;
    end;
    nkSubrange:
      if Nodes[id].Flag = 1 then NodeAttr := 'typed ' + Nodes[id].Text;
    nkVariantPart:
      if Nodes[id].Text <> '' then NodeAttr := 'tag ' + Nodes[id].Text;
    nkProcType:
      if Nodes[id].Flag = 1 then NodeAttr := 'function' else NodeAttr := 'procedure';
    nkParam:
      case Nodes[id].Flag of
        1: NodeAttr := 'var';
        2: NodeAttr := 'const';
        3: NodeAttr := 'out';
      else
        NodeAttr := 'value';
      end;
    nkProcDecl, nkFuncDecl: begin
      NodeAttr := Nodes[id].Text;
      case Nodes[id].Flag of
        1: NodeAttr := NodeAttr + ' forward';
        2: NodeAttr := NodeAttr + ' external';
        3: NodeAttr := NodeAttr + ' heading';
      end;
      if Nodes[id].CConv = 1 then NodeAttr := NodeAttr + ' cdecl';
      if Nodes[id].Failable = 1 then NodeAttr := NodeAttr + ' fails';
      if Nodes[id].A >= 0 then NodeAttr := NodeAttr + ' method';
    end;
  end;
end;

procedure DumpNode(id, depth: LongInt);
var
  i: LongInt;
  a: string;
begin
  if id < 0 then Exit;
  a := NodeAttr(id);
  if a <> '' then
    WriteLn(Spaces(depth * 2), NodeKindName[Nodes[id].Kind], ' ', a)
  else
    WriteLn(Spaces(depth * 2), NodeKindName[Nodes[id].Kind]);
  DumpNode(Nodes[id].A, depth + 1);
  DumpNode(Nodes[id].B, depth + 1);
  DumpNode(Nodes[id].C, depth + 1);
  DumpNode(Nodes[id].D, depth + 1);
  for i := 0 to Length(Nodes[id].Kids) - 1 do
    DumpNode(Nodes[id].Kids[i], depth + 1);
end;

procedure DumpTree(root: LongInt);
begin
  DumpNode(root, 0);
end;

{ ---- Semantic analysis ---- }
{ Binds names to declarations and checks a first, conservative slice of the type
  rules. It resolves every declaration and identifier, and reports undeclared
  names, duplicate declarations, unknown types, break/continue outside a loop,
  and yield/bind outside a start, plus a subset of expression and assignment
  type checks. Full overload resolution, Go-style method attachment, the
  coroutine answer/resume typing, and the no-closure rule are later increments;
  where a check is not yet reliable, the analyzer degrades to the error type
  rather than reporting a false positive. }

{ Forward declarations for the mutually recursive analysis. }
function ResolveType(node: LongInt): LongInt; forward;
function QualIndex(const qual: string): LongInt; forward;
function LinkNameOf(s: LongInt): string; forward;
function ConstGlobalName(s: LongInt): string; forward;
procedure ProcessReexports(intf: LongInt); forward;
function EvalConst(node: LongInt): TConstVal; forward;
function RealLitBits(const s: string): Int64; forward;
function RealBitsFromConst(valNode: LongInt): Int64; forward;
procedure CopyAggregateManaged(dstAddr, srcAddr, ty: LongInt); forward;
procedure CheckRecordLit(lit, recTy: LongInt); forward;
procedure CheckConstValue(valNode, ty: LongInt); forward;
procedure CheckConstArray(arrTy, dim, node: LongInt); forward;
function RoundUp(x, a: LongInt): LongInt; forward;
function TypeSize(ty: LongInt): LongInt; forward;
function TypeAlign(ty: LongInt): LongInt; forward;
function AnalyzeExpr(node: LongInt): LongInt; forward;
procedure AnalyzeStmt(node: LongInt); forward;
procedure AnalyzeBlock(node: LongInt); forward;
function AssignCompatible(dst, src: LongInt): Boolean; forward;
function IsDynArray(ty: LongInt): Boolean; forward;
function IsBuffer(ty: LongInt): Boolean; forward;
function IsMap(ty: LongInt): Boolean; forward;
function MapKeyType(ty: LongInt): LongInt; forward;
function BufRank(ty: LongInt): LongInt; forward;
function IsSingle(ty: LongInt): Boolean; forward;
function IsInt64(ty: LongInt): Boolean; forward;
function Wide64(ty: LongInt): Boolean; forward;
function IsRealType(ty: LongInt): Boolean; forward;
function IsAggregate(ty: LongInt): Boolean; forward;
function IsHandle(ty: LongInt): Boolean; forward;

procedure SemErrCode(node: LongInt; const code, msg: string);
{ A semantic error with an explicit class code. SemErr and SemErrName wrap it with the two
  codes the semantic phase uses; the lowering blocker passes E0005 directly. }
begin
  EmitDiag(Nodes[node].Line, Nodes[node].Col, 'error', code, msg);
  Inc(ErrCount);
end;

procedure SemErr(node: LongInt; const msg: string);
{ A type or general semantic error (E0004): the default class for the semantic phase. }
begin
  SemErrCode(node, 'E0004', msg);
end;

procedure SemErrName(node: LongInt; const msg: string);
{ A name-resolution error (E0003): an undeclared or duplicate name, or a name used where its
  kind does not fit. Split out from E0004 so a host can tell a lookup failure from a type clash. }
begin
  SemErrCode(node, 'E0003', msg);
end;

procedure SemWarn(node: LongInt; const code, msg: string);
{ A warning is advisory: it does not count toward ErrCount, so it never fails the build or
  suppresses the module. Each warning kind carries its own W#### code. }
begin
  EmitDiag(Nodes[node].Line, Nodes[node].Col, 'warning', code, msg);
end;

function AssignNeverReadWarnable(ty: LongInt): Boolean;
{ A var that is only ever assigned, never read, is almost always dead code worth a
  warning. The exception is a handle or a coroutine: either can be held in a write-only
  local on purpose, for a lifecycle the scope end closes (the finalizer or the release),
  so those two types are left alone to avoid flagging a deliberate scope guard. }
begin
  AssignNeverReadWarnable := True;
  if (ty < 0) or (ty >= SemCount) then Exit;
  if SemTypes[ty].Kind in [skInterface, skProcess] then
    AssignNeverReadWarnable := False;
end;

function NameOptsOutOfUnused(const name: string): Boolean;
{ A leading underscore marks a name the author knows is unused: an interface or callback
  signature can force a parameter that a given body does not touch, and `_`-prefixing it says
  so and silences the unused warning. }
begin
  NameOptsOutOfUnused := (Length(name) >= 1) and (name[1] = '_');
end;

procedure WarnUnusedInScope(scope: LongInt);
{ Warn about local variables declared in this scope that were never referenced, about ones
  assigned but whose value was never read, and about parameters never referenced in the body.
  With-aliases and bound-process variables are left alone (not Warnable). A `_`-prefixed name
  opts out, and a method receiver is never flagged. }
var
  i, s: LongInt;
begin
  if scope < 0 then Exit;
  for i := 0 to High(Scopes[scope].Members) do begin
    s := Scopes[scope].Members[i];
    if (Syms[s].Kind = syVar) and Syms[s].Warnable and (Syms[s].Node >= 0) then begin
      if not Syms[s].Used then
        SemWarn(Syms[s].Node, 'W0001', 'variable ''' + Syms[s].Name + ''' is declared but never used')
      else if not Syms[s].Read and AssignNeverReadWarnable(Syms[s].TypeId) then
        SemWarn(Syms[s].Node, 'W0003', 'variable ''' + Syms[s].Name +
          ''' is assigned but its value is never read');
    end
    else if (Syms[s].Kind = syParam) and (Syms[s].Node >= 0)
       and not Syms[s].Used
       and (Nodes[Syms[s].Node].Kind <> nkReceiver)
       and not NameOptsOutOfUnused(Syms[s].Name) then
      SemWarn(Syms[s].Node, 'W0002', 'parameter ''' + Syms[s].Name + ''' is never used');
  end;
end;

function NewSemType(k: TSemKind): LongInt;
begin
  if SemCount >= Length(SemTypes) then begin
    if Length(SemTypes) = 0 then SetLength(SemTypes, 64)
    else SetLength(SemTypes, Length(SemTypes) * 2);
  end;
  SemTypes[SemCount].Kind := k;
  SemTypes[SemCount].Name := '';
  SemTypes[SemCount].Base := -1;
  SemTypes[SemCount].Lo := 0;
  SemTypes[SemCount].Hi := 0;
  SetLength(SemTypes[SemCount].Names, 0);
  SetLength(SemTypes[SemCount].Subs, 0);
  SetLength(SemTypes[SemCount].ParamTypes, 0);
  SetLength(SemTypes[SemCount].ParamModes, 0);
  SemTypes[SemCount].RetType := -1;
  SemTypes[SemCount].Failable := False;
  SemTypes[SemCount].Variadic := False;
  SemTypes[SemCount].FloatBits := 64;
  SemTypes[SemCount].IntBits := 32;
  SemTypes[SemCount].Size := -1;
  SemTypes[SemCount].Align := -1;
  SemTypes[SemCount].Opaque := False;
  SemTypes[SemCount].HostBuf := False;
  SemTypes[SemCount].Rank := 0;
  SemTypes[SemCount].FromUnit := '';
  NewSemType := SemCount;
  Inc(SemCount);
end;

function TypeName(ty: LongInt): string;
var
  commas: string;
  j: LongInt;
begin
  if (ty < 0) or (ty >= SemCount) then TypeName := '<?>'
  else if SemTypes[ty].Name <> '' then TypeName := SemTypes[ty].Name
  else case SemTypes[ty].Kind of
    skEnum:      TypeName := 'enum';
    skSubrange:  TypeName := 'subrange';
    skArray:
      if Length(SemTypes[ty].Subs) <> 0 then TypeName := 'array'   { a fixed array }
      else if SemTypes[ty].HostBuf then begin
        commas := '';
        for j := 2 to SemTypes[ty].Rank do commas := commas + ',';
        if commas <> '' then
          TypeName := 'buffer[' + commas + '] of ' + TypeName(SemTypes[ty].Base)
        else
          TypeName := 'buffer of ' + TypeName(SemTypes[ty].Base);
      end
      else
        TypeName := 'array of ' + TypeName(SemTypes[ty].Base);
    skRecord:    TypeName := 'record';
    skSet:       TypeName := 'set';
    skMap:       if MapKeyType(ty) = tyStr then
                   TypeName := 'map of ' + TypeName(SemTypes[ty].Base)
                 else
                   TypeName := 'map[' + TypeName(MapKeyType(ty)) + '] of ' + TypeName(SemTypes[ty].Base);
    skMapIter:   TypeName := 'mapiter';
    skErrorVal:  TypeName := 'error';
    skInterface: TypeName := 'interface';
    skProc:      TypeName := 'procedure';
    skLabel:     TypeName := 'label';
    skNil:       TypeName := 'nil';
    skError:     TypeName := '<error>';
  else
    TypeName := '<type>';
  end;
end;

function IsIntClass(ty: LongInt): Boolean;
begin
  IsIntClass := False;
  if (ty < 0) or (ty >= SemCount) then Exit;
  case SemTypes[ty].Kind of
    skInteger: IsIntClass := True;
    skSubrange: IsIntClass := IsIntClass(SemTypes[ty].Base);
  end;
end;

function IsNumeric(ty: LongInt): Boolean;
begin
  IsNumeric := IsIntClass(ty) or ((ty >= 0) and (SemTypes[ty].Kind = skReal));
end;

function IsOrdinalType(ty: LongInt): Boolean;
{ An ordinal type: integer, char, boolean, an enumeration, or a subrange of one. Each value has
  a definite position, which is what a case selector (and a set base) requires. }
begin
  IsOrdinalType := False;
  if (ty < 0) or (ty >= SemCount) then Exit;
  case SemTypes[ty].Kind of
    skInteger, skChar, skBoolean, skEnum: IsOrdinalType := True;
    skSubrange: IsOrdinalType := IsOrdinalType(SemTypes[ty].Base);
  end;
end;

function IsSet(ty: LongInt): Boolean;
begin
  IsSet := (ty >= 0) and (ty < SemCount) and (SemTypes[ty].Kind = skSet);
end;

function IsPropertyValueType(ty: LongInt): Boolean;
{ A property (declaration-level or a computed record field) is backed by accessor calls. Its
  type may be a simple value (an ordinal, a real/single, or a 64-bit integer), a reference-counted
  handle (a string, a dynamic array, a map, an interface, or a process), or an inline aggregate
  (a record, a fixed array, or a large set). A handle read transfers its owned reference the way
  any handle-returning call does (IsOwnedExpr); an aggregate read returns through the getter's
  sret buffer, whose address is the value's location, exactly like an aggregate-returning
  function call (doc/languages/kobold/kp-property.md). }
begin
  IsPropertyValueType := IsOrdinalType(ty) or IsRealType(ty) or IsSingle(ty) or IsInt64(ty)
    or IsHandle(ty) or IsAggregate(ty);
end;

function PropSetterName(node: LongInt): string;
{ The setter routine name of a property/computed-field node, or '' when read-only. }
begin
  if Nodes[node].C >= 0 then PropSetterName := Nodes[Nodes[node].C].Text
  else PropSetterName := '';
end;

function IsPropertySym(s: LongInt): Boolean;
{ True when symbol s is a declaration-level property (a syVar whose Node is an nkPropertyDecl),
  rather than a stored variable. }
begin
  IsPropertySym := (s >= 0) and (Syms[s].Kind = syVar) and (Syms[s].Node >= 0) and
    (Nodes[Syms[s].Node].Kind = nkPropertyDecl);
end;

{ ---- scopes and symbols ---- }

procedure OpenScope;
var
  idx: LongInt;
begin
  if ScopeCount >= Length(Scopes) then begin
    if Length(Scopes) = 0 then SetLength(Scopes, 32)
    else SetLength(Scopes, Length(Scopes) * 2);
  end;
  idx := ScopeCount;
  Inc(ScopeCount);
  Scopes[idx].Parent := CurScope;
  SetLength(Scopes[idx].Members, 0);
  CurScope := idx;
end;

procedure CloseScope;
begin
  if CurScope >= 0 then CurScope := Scopes[CurScope].Parent;
end;

function SymHashName(const l: string): LongInt;
{ A small djb2 hash over an already-lowercased name. Each step is masked to 24 bits so the
  arithmetic cannot overflow a LongInt regardless of the host compiler's overflow checking. }
var
  i, h: LongInt;
begin
  h := 5381;
  for i := 1 to Length(l) do
    h := ((h shl 5) + h + Ord(l[i])) and $FFFFFF;
  SymHashName := h;
end;

function SymHashBucket(const l: string; scope: LongInt): LongInt;
{ The bucket for a (scope, lowercased name) pair. Scope is folded in so the same name in
  different scopes spreads across buckets. Uses the same formula on insert and on lookup. }
begin
  SymHashBucket := ((SymHashName(l) * 31) + scope) and SymIdxMask;
end;

procedure ResetSymIndex;
{ Clear the membership index for a fresh compile. Entry arrays are kept allocated across
  compiles; only the count and the bucket heads are reset. }
var
  i: LongInt;
begin
  if Length(SymIdxBucket) = 0 then begin
    SetLength(SymIdxBucket, 4096);
    SymIdxMask := 4095;
  end;
  for i := 0 to SymIdxMask do SymIdxBucket[i] := -1;
  SymIdxCount := 0;
end;

procedure SymIdxGrow;
{ Double the bucket count and rehash every entry (keeps the load factor bounded). }
var
  newMask, i, e, h: LongInt;
begin
  newMask := ((SymIdxMask + 1) * 2) - 1;
  SetLength(SymIdxBucket, newMask + 1);
  SymIdxMask := newMask;
  for i := 0 to newMask do SymIdxBucket[i] := -1;
  for e := 0 to SymIdxCount - 1 do begin
    h := SymHashBucket(Syms[SymIdxSym[e]].LowerName, SymIdxScope[e]);
    SymIdxNext[e] := SymIdxBucket[h];
    SymIdxBucket[h] := e;
  end;
end;

procedure AddMember(scope, sym: LongInt);
{ Append `sym` to `scope`'s member list and record the membership in the index. The member
  list is kept because several passes iterate a scope's members in declaration order. }
var
  n, e, h: LongInt;
begin
  n := Length(Scopes[scope].Members);
  SetLength(Scopes[scope].Members, n + 1);
  Scopes[scope].Members[n] := sym;
  if (SymIdxCount * 4) >= ((SymIdxMask + 1) * 3) then SymIdxGrow;   { keep load factor <= 0.75 }
  if SymIdxCount >= Length(SymIdxSym) then begin
    if Length(SymIdxSym) = 0 then begin
      SetLength(SymIdxSym, 1024);
      SetLength(SymIdxScope, 1024);
      SetLength(SymIdxPos, 1024);
      SetLength(SymIdxNext, 1024);
    end
    else begin
      SetLength(SymIdxSym, Length(SymIdxSym) * 2);
      SetLength(SymIdxScope, Length(SymIdxSym));
      SetLength(SymIdxPos, Length(SymIdxSym));
      SetLength(SymIdxNext, Length(SymIdxSym));
    end;
  end;
  e := SymIdxCount;
  Inc(SymIdxCount);
  SymIdxSym[e] := sym;
  SymIdxScope[e] := scope;
  SymIdxPos[e] := n;
  h := SymHashBucket(Syms[sym].LowerName, scope);
  SymIdxNext[e] := SymIdxBucket[h];
  SymIdxBucket[h] := e;
end;

procedure RemoveLastMember(scope: LongInt);
{ Undo the most recent AddMember for `scope`. The only caller is the cross-unit `.method`
  path, which adds a link-only symbol and then drops it from the lookup scope. }
var
  n, e, h, p: LongInt;
begin
  n := Length(Scopes[scope].Members);
  if n > 0 then SetLength(Scopes[scope].Members, n - 1);
  e := SymIdxCount - 1;
  if (e >= 0) and (SymIdxScope[e] = scope) then begin
    h := SymHashBucket(Syms[SymIdxSym[e]].LowerName, scope);
    if SymIdxBucket[h] = e then
      SymIdxBucket[h] := SymIdxNext[e]
    else begin
      p := SymIdxBucket[h];
      while (p >= 0) and (SymIdxNext[p] <> e) do p := SymIdxNext[p];
      if p >= 0 then SymIdxNext[p] := SymIdxNext[e];
    end;
    Dec(SymIdxCount);
  end;
end;

function FindLocal(const name: string; scope: LongInt): LongInt;
{ The first symbol (in declaration order) named `name` directly in `scope`, or -1. Resolved
  through the membership index: scan only the bucket chain and keep the match with the lowest
  member position, which is exactly what a linear scan of the member list would return. }
var
  e, best, bestPos: LongInt;
  l: string;
begin
  l := LowerStr(name);
  best := -1;
  bestPos := 0;
  e := SymIdxBucket[SymHashBucket(l, scope)];
  while e >= 0 do begin
    if (SymIdxScope[e] = scope) and (Syms[SymIdxSym[e]].LowerName = l) then
      if (best < 0) or (SymIdxPos[e] < bestPos) then begin
        best := SymIdxSym[e];
        bestPos := SymIdxPos[e];
      end;
    e := SymIdxNext[e];
  end;
  FindLocal := best;
end;

function Lookup(const name: string): LongInt;
var
  sc, s: LongInt;
begin
  Lookup := -1;
  sc := CurScope;
  while sc >= 0 do begin
    s := FindLocal(name, sc);
    if s >= 0 then begin
      { every by-name reference resolves through here, so this is the one place that
        records a symbol was used; declarations go through Declare, not Lookup }
      Syms[s].Used := True;
      Exit(s);
    end;
    sc := Scopes[sc].Parent;
  end;
end;

function EditDist(const a, b: string): LongInt;
{ The Levenshtein edit distance between two strings (insert/delete/substitute, cost 1
  each), computed with two rolling rows. Used to suggest a near name for a typo. }
var
  la, lb, i, j, cost, del, ins, sub: LongInt;
  prev, cur: array of LongInt;
begin
  la := Length(a);
  lb := Length(b);
  SetLength(prev, lb + 1);
  SetLength(cur, lb + 1);
  for j := 0 to lb do prev[j] := j;
  for i := 1 to la do begin
    cur[0] := i;
    for j := 1 to lb do begin
      if a[i] = b[j] then cost := 0 else cost := 1;
      del := prev[j] + 1;
      ins := cur[j - 1] + 1;
      sub := prev[j - 1] + cost;
      if del < ins then cur[j] := del else cur[j] := ins;
      if sub < cur[j] then cur[j] := sub;
    end;
    for j := 0 to lb do prev[j] := cur[j];
  end;
  EditDist := prev[lb];
end;

function SuggestName(const name: string): string;
{ If a visible symbol is a near match for an undeclared name, return a "; did you mean 'X'?"
  suffix to append to the error, else ''. Walks the scope chain like Lookup and picks the
  closest name by edit distance, suggesting only a close typo: one edit always, two edits
  for a name of four characters or more. Names match case-insensitively, so a name that
  reached the undeclared-name path differs from every candidate by at least one real edit. }
var
  sc, i, s, d, best, bestd, nlen: LongInt;
  ln: string;
begin
  SuggestName := '';
  best := -1;
  bestd := 1000000;
  ln := LowerStr(name);
  nlen := Length(name);
  sc := CurScope;
  while sc >= 0 do begin
    for i := 0 to High(Scopes[sc].Members) do begin
      s := Scopes[sc].Members[i];
      if Syms[s].Name = '' then Continue;
      d := EditDist(ln, Syms[s].LowerName);
      if d < bestd then begin
        bestd := d;
        best := s;
      end;
    end;
    sc := Scopes[sc].Parent;
  end;
  if (best >= 0) and ((bestd = 1) or ((bestd = 2) and (nlen >= 4))) then
    SuggestName := '; did you mean ''' + Syms[best].Name + '''?';
end;

function IsAncestorScope(anc, sc: LongInt): Boolean;
{ True if scope anc is a strict ancestor of scope sc. }
begin
  IsAncestorScope := False;
  if sc < 0 then Exit;
  sc := Scopes[sc].Parent;
  while sc >= 0 do begin
    if sc = anc then Exit(True);
    sc := Scopes[sc].Parent;
  end;
end;

procedure MarkCapture(s: LongInt);
{ If the current routine reads a local of an enclosing routine (a scope that is
  an ancestor of the routine body, other than the global scope), record that the
  routine captures. Global variables do not count. }
begin
  if CurRoutineSym < 0 then Exit;
  if Syms[s].Scope = 0 then Exit;
  if Syms[s].Scope = GlobalScope then Exit;   { a global is addressed directly, not captured }
  if Syms[s].Scope = CurRoutineScope then Exit;
  if IsAncestorScope(Syms[s].Scope, CurRoutineScope) then
    Syms[CurRoutineSym].Captures := True;
end;

procedure AddMethod(recv: LongInt; const nm: string; sig, sym: LongInt);
var
  n: LongInt;
begin
  n := MethCount;
  Inc(MethCount);
  if MethCount > Length(MethRecv) then begin
    if Length(MethRecv) = 0 then begin
      SetLength(MethRecv, 32); SetLength(MethName, 32);
      SetLength(MethSig, 32); SetLength(MethSym, 32);
    end
    else begin
      SetLength(MethRecv, Length(MethRecv) * 2);
      SetLength(MethName, Length(MethName) * 2);
      SetLength(MethSig, Length(MethSig) * 2);
      SetLength(MethSym, Length(MethSym) * 2);
    end;
  end;
  MethRecv[n] := recv;
  MethName[n] := nm;
  MethSig[n] := sig;
  MethSym[n] := sym;
end;

function FindMethodSym(recv: LongInt; const nm: string): LongInt;
{ The routine symbol of a script method (recv, nm), or -1. An imported method's symbol
  carries the link name a cross-unit call resolves against. }
var
  i: LongInt;
  l: string;
begin
  FindMethodSym := -1;
  l := LowerStr(nm);
  for i := 0 to MethCount - 1 do
    if (MethRecv[i] = recv) and (LowerStr(MethName[i]) = l) then Exit(MethSym[i]);
end;

function FindMethod(recv: LongInt; const nm: string): LongInt;
{ Returns the signature type of a script method (recv, nm), or -1. }
var
  i: LongInt;
  l: string;
begin
  FindMethod := -1;
  l := LowerStr(nm);
  for i := 0 to MethCount - 1 do
    if (MethRecv[i] = recv) and (LowerStr(MethName[i]) = l) then Exit(MethSig[i]);
end;

function FindMethodName(recv: LongInt; const nm: string): string;
{ Returns a script method's name in its declared casing, so a call site and the
  method definition agree on the mangled symbol. Empty when there is no match. }
var
  i: LongInt;
  l: string;
begin
  FindMethodName := '';
  l := LowerStr(nm);
  for i := 0 to MethCount - 1 do
    if (MethRecv[i] = recv) and (LowerStr(MethName[i]) = l) then Exit(MethName[i]);
end;

function AddSym(const name: string; k: TSymKind): LongInt;
var
  idx: LongInt;
begin
  if SymCount >= Length(Syms) then begin
    if Length(Syms) = 0 then SetLength(Syms, 128)
    else SetLength(Syms, Length(Syms) * 2);
  end;
  idx := SymCount;
  Inc(SymCount);
  Syms[idx].Name := name;
  Syms[idx].LowerName := LowerStr(name);
  Syms[idx].Kind := k;
  Syms[idx].TypeId := -1;
  Syms[idx].Ordinal := 0;
  Syms[idx].ConstStr := '';
  Syms[idx].ConstIsStr := False;
  Syms[idx].ConstAggName := '';
  Syms[idx].ConstGName := '';
  Syms[idx].Node := -1;
  Syms[idx].Scope := CurScope;
  Syms[idx].Captures := False;
  Syms[idx].Slot := -1;
  Syms[idx].BodyScope := -1;
  Syms[idx].WithBase := -1;
  Syms[idx].ParamMode := 0;
  Syms[idx].Used := False;
  Syms[idx].Read := False;
  Syms[idx].Warnable := False;
  Syms[idx].Imported := False;
  Syms[idx].LinkName := '';
  Syms[idx].BinderVar := False;
  Syms[idx].DisambDone := False;
  Syms[idx].DisambName := '';
  AddMember(CurScope, idx);
  AddSym := idx;
end;

function Declare(const name: string; k: TSymKind; node: LongInt): LongInt;
var
  existing: LongInt;
begin
  existing := FindLocal(name, CurScope);
  if existing >= 0 then
    { routines may share a name (overloading); anything else is a duplicate }
    if not ((Syms[existing].Kind in [syProc, syFunc]) and
            (k in [syProc, syFunc])) then
      if node >= 0 then
        SemErrName(node, 'duplicate declaration of ''' + name + '''');
  Declare := AddSym(name, k);
  Syms[Declare].Node := node;
  { warn when a user declaration shadows a predefined name (a built-in routine or base type).
    The language allows it by design (the system scope is an outer scope), so this is advisory.
    Restricted to the program's own scopes, so reading a used unit's interface never triggers it. }
  if (node >= 0) and (CurScope <> SystemScope)
     and ((CurScope = GlobalScope) or IsAncestorScope(GlobalScope, CurScope))
     and (FindLocal(name, SystemScope) >= 0) then
    SemWarn(node, 'W0004', 'declaration of ''' + name + ''' shadows a built-in');
end;

{ ---- type table helpers ---- }

procedure AddMember(ty: LongInt; const nm: string; mty: LongInt);
var
  n: LongInt;
begin
  n := Length(SemTypes[ty].Names);
  SetLength(SemTypes[ty].Names, n + 1);
  SetLength(SemTypes[ty].Subs, n + 1);
  SetLength(SemTypes[ty].PropGet, n + 1);
  SetLength(SemTypes[ty].PropSet, n + 1);
  SemTypes[ty].Names[n] := nm;
  SemTypes[ty].Subs[n] := mty;
  SemTypes[ty].PropGet[n] := '';
  SemTypes[ty].PropSet[n] := '';
end;

procedure SetMemberProp(ty: LongInt; const g, s: string);
{ Mark the most recently added member of record ty as a computed field backed by getter
  method `g` and optional setter method `s` ('' = read-only). }
var
  n: LongInt;
begin
  n := High(SemTypes[ty].Names);
  SemTypes[ty].PropGet[n] := g;
  SemTypes[ty].PropSet[n] := s;
end;

procedure SetMemberOff(ty, off: LongInt);
{ Record the byte offset of the most recently added member of record ty. Variant fields
  share a base offset, so offsets are computed at layout time rather than by summing. }
var
  n: LongInt;
begin
  n := High(SemTypes[ty].Subs);
  SetLength(SemTypes[ty].MemberOff, n + 1);
  SemTypes[ty].MemberOff[n] := off;
end;

function FindMember(ty: LongInt; const nm: string): LongInt;
var
  i: LongInt;
  l: string;
begin
  FindMember := -1;
  l := LowerStr(nm);
  for i := 0 to High(SemTypes[ty].Names) do
    if LowerStr(SemTypes[ty].Names[i]) = l then Exit(i);
end;

procedure AddSigParam(sig, pty, mode: LongInt);
var
  n: LongInt;
begin
  n := Length(SemTypes[sig].ParamTypes);
  SetLength(SemTypes[sig].ParamTypes, n + 1);
  SetLength(SemTypes[sig].ParamModes, n + 1);
  SemTypes[sig].ParamTypes[n] := pty;
  SemTypes[sig].ParamModes[n] := mode;
end;

{ ---- constant evaluation ---- }

function EvalConst(node: LongInt): TConstVal;
var
  a, b: TConstVal;
  s: LongInt;
begin
  EvalConst.Ok := False;
  EvalConst.IsStr := False;
  EvalConst.IsReal := False;
  EvalConst.I := 0;
  EvalConst.RBits := 0;
  EvalConst.S := '';
  EvalConst.Ty := tyErr;
  if node < 0 then Exit;
  case Nodes[node].Kind of
    nkRealLit: begin
      { a real constant is a signed literal only: its f64 bit pattern comes from the literal
        text in integer arithmetic (RealLitBits), the same deterministic path a lowered real
        literal uses. Real constant arithmetic is not folded, so it keeps the fixed point on
        the single-float tier where a host Double would round differently. }
      EvalConst.Ok := True; EvalConst.IsReal := True;
      EvalConst.RBits := RealLitBits(Nodes[node].Text); EvalConst.Ty := tyReal;
    end;
    nkIntLit: begin
      EvalConst.Ok := True; EvalConst.I := Nodes[node].IntVal;
      if (Nodes[node].IntVal < -2147483648) or (Nodes[node].IntVal > 2147483647) then
        EvalConst.Ty := tyInt64
      else EvalConst.Ty := tyInt;
    end;
    nkStrLit: begin
      EvalConst.Ok := True; EvalConst.IsStr := True;
      EvalConst.S := Nodes[node].Text; EvalConst.Ty := tyStr;
      { a one-character string literal also denotes a char value; expose its code in I so an
        ordinal context (a char case label, a set element) can read it }
      if Length(Nodes[node].Text) = 1 then EvalConst.I := Ord(Nodes[node].Text[1]);
    end;
    nkNil: begin EvalConst.Ok := True; EvalConst.Ty := tyNil; end;
    nkIdent: begin
      s := Lookup(Nodes[node].Text);
      if s >= 0 then
        case Syms[s].Kind of
          syConst:
            { a link-time constant has no compile-time value, so it is usable in an expression
              but not in a constant position (array bound, case label, subrange). }
            if not Syms[s].LinkConst then begin
              EvalConst.Ok := True; EvalConst.Ty := Syms[s].TypeId;
              if Syms[s].ConstIsStr then begin
                EvalConst.IsStr := True; EvalConst.S := Syms[s].ConstStr;
              end
              else if IsRealType(Syms[s].TypeId) then begin
                { a real or single const holds its f64 bit pattern in Ordinal }
                EvalConst.IsReal := True; EvalConst.RBits := Syms[s].Ordinal;
              end
              else EvalConst.I := Syms[s].Ordinal;
            end;
          syEnumLit: begin
            EvalConst.Ok := True; EvalConst.I := Syms[s].Ordinal;
            EvalConst.Ty := Syms[s].TypeId;
          end;
        end;
    end;
    nkUnary: begin
      a := EvalConst(Nodes[node].A);
      if a.Ok and a.IsReal then begin
        { a signed real literal: flip the f64 sign bit for unary minus, leave it for plus }
        case Nodes[node].Op of
          tkMinus: begin
            { toggle the f64 sign bit; the dialect has no xor, so branch on it }
            EvalConst.Ok := True; EvalConst.IsReal := True; EvalConst.Ty := a.Ty;
            if (a.RBits and (Int64(1) shl 63)) <> 0 then
              EvalConst.RBits := a.RBits and (not (Int64(1) shl 63))
            else
              EvalConst.RBits := a.RBits or (Int64(1) shl 63);
          end;
          tkPlus: begin
            EvalConst.Ok := True; EvalConst.IsReal := True; EvalConst.Ty := a.Ty;
            EvalConst.RBits := a.RBits;
          end;
        end;
      end
      else if a.Ok and not a.IsStr then begin
        EvalConst.Ok := True; EvalConst.Ty := a.Ty;
        case Nodes[node].Op of
          tkMinus: EvalConst.I := -a.I;
          tkPlus:  EvalConst.I := a.I;
          tkNot:   EvalConst.I := not a.I;
        else
          EvalConst.Ok := False;
        end;
      end;
    end;
    nkBinary: begin
      a := EvalConst(Nodes[node].A);
      b := EvalConst(Nodes[node].B);
      if a.Ok and b.Ok and not a.IsStr and not b.IsStr and
         not a.IsReal and not b.IsReal then begin
        EvalConst.Ok := True; EvalConst.Ty := tyInt;
        case Nodes[node].Op of
          tkPlus:  EvalConst.I := a.I + b.I;
          tkMinus: EvalConst.I := a.I - b.I;
          tkStar:  EvalConst.I := a.I * b.I;
          tkDiv:   if b.I <> 0 then EvalConst.I := a.I div b.I else EvalConst.Ok := False;
          tkMod:   if b.I <> 0 then EvalConst.I := a.I mod b.I else EvalConst.Ok := False;
          tkShl:   EvalConst.I := a.I shl b.I;
          tkShr:   EvalConst.I := a.I shr b.I;
          tkAnd:   EvalConst.I := a.I and b.I;
          tkOr:    EvalConst.I := a.I or b.I;
        else
          EvalConst.Ok := False;
        end;
      end;
    end;
  end;
end;

{ ---- type resolution ---- }

function TypeIsHandleSem(ty: LongInt): Boolean;
{ True when a resolved type is a reference-counted handle: an interface, a string, a
  process, or a dynamic array. (The lowering-side IsHandle is not yet in scope here.) }
begin
  TypeIsHandleSem := (ty >= 0) and (ty < SemCount) and
    ((SemTypes[ty].Kind in [skInterface, skString, skProcess, skMap, skMapIter]) or
     ((SemTypes[ty].Kind = skArray) and (Length(SemTypes[ty].Subs) = 0)));
end;

function TypeHasHandle(ty: LongInt): Boolean;
{ True when a type is a handle or contains a handle anywhere: a record with a handle field
  or an array of handles, recursively. Marks an aggregate whose element or field lifetimes
  a dynamic-array element cannot yet manage (that is slice 3b). }
var
  i: LongInt;
begin
  TypeHasHandle := False;
  if (ty < 0) or (ty >= SemCount) then Exit;
  if TypeIsHandleSem(ty) then Exit(True);
  case SemTypes[ty].Kind of
    skRecord:
      for i := 0 to High(SemTypes[ty].Subs) do
        if TypeHasHandle(SemTypes[ty].Subs[i]) then Exit(True);
    skArray: TypeHasHandle := TypeHasHandle(SemTypes[ty].Base);
  end;
end;

function OrdinalRange(ty: LongInt; var lo, hi: Int64): Boolean;
{ The inclusive ordinal range of an ordinal type used as an array index. }
begin
  OrdinalRange := True;
  if (ty < 0) or (ty >= SemCount) then begin OrdinalRange := False; Exit; end;
  case SemTypes[ty].Kind of
    skEnum:     begin lo := 0; hi := High(SemTypes[ty].Names); end;
    skSubrange: begin lo := SemTypes[ty].Lo; hi := SemTypes[ty].Hi; end;
    skBoolean:  begin lo := 0; hi := 1; end;
    skChar:     begin lo := 0; hi := 255; end;
  else
    OrdinalRange := False;
  end;
end;

function SetWords(setTy: LongInt): LongInt;
{ The number of 64-bit words a set value occupies: 1 for up to 64 elements (a small set held
  in a register), otherwise ceil((maxOrdinal + 1) / 64) up to 4 (a 256-bit large set addressed
  in memory word by word). The width comes from the base ordinal type's range; an untyped or
  empty set falls back to one word, with the context giving the real width. }
var
  lo, hi: Int64;
  bits, w: LongInt;
begin
  SetWords := 1;
  if (setTy < 0) or (setTy >= SemCount) or (SemTypes[setTy].Kind <> skSet) then Exit;
  if not OrdinalRange(SemTypes[setTy].Base, lo, hi) then Exit;
  bits := LongInt(hi) + 1;
  if bits <= 64 then Exit;
  w := (bits + 63) div 64;
  if w > 4 then w := 4;
  SetWords := w;
end;

function IsLargeSet(ty: LongInt): Boolean;
begin
  IsLargeSet := (ty >= 0) and (ty < SemCount) and (SemTypes[ty].Kind = skSet) and
    (SetWords(ty) > 1);
end;

function IsSmallSet(ty: LongInt): Boolean;
begin
  IsSmallSet := (ty >= 0) and (ty < SemCount) and (SemTypes[ty].Kind = skSet) and
    (SetWords(ty) = 1);
end;

function EvalConstSet(node, setTy: LongInt; var w: TSetWords): Boolean;
{ Evaluate a set constructor into the word image of a set of type setTy: each element is a
  constant ordinal, or a constant lo..hi range, and its ordinal indexes a bit (word ord div 64,
  bit ord mod 64), the same layout membership reads. Returns False on a non-constant or
  out-of-range element. }
var
  i, e, nw, wi, bit: LongInt;
  lo, hi: TConstVal;
  loI, hiI, v: Int64;

  function OrdOf(const c: TConstVal; out o: Int64): Boolean;
  { An ordinal element value: an ordinal constant directly, or a one-character string constant
    taken as its character code (a set-of-char element is written as a char literal). }
  begin
    o := 0;
    OrdOf := c.Ok;
    if not c.Ok then Exit;
    if c.IsStr then begin
      OrdOf := Length(c.S) = 1;
      if OrdOf then o := Ord(c.S[1]);
    end
    else o := c.I;
  end;

begin
  EvalConstSet := False;
  for i := 0 to 3 do w[i] := 0;
  if (node < 0) or (Nodes[node].Kind <> nkSetConstructor) then Exit;
  nw := SetWords(setTy);
  for i := 0 to High(Nodes[node].Kids) do begin
    e := Nodes[node].Kids[i];
    lo := EvalConst(Nodes[e].A);
    if not OrdOf(lo, loI) then Exit;
    if Nodes[e].B >= 0 then begin
      hi := EvalConst(Nodes[e].B);
      if not OrdOf(hi, hiI) then Exit;
    end
    else hiI := loI;
    v := loI;
    while v <= hiI do begin
      if (v < 0) or (v >= Int64(nw) * 64) then Exit;
      wi := LongInt(v) div 64;
      bit := LongInt(v) mod 64;
      w[wi] := w[wi] or (Int64(1) shl bit);
      Inc(v);
    end;
  end;
  EvalConstSet := True;
end;

function ResolveType(node: LongInt): LongInt;
var
  ty, i, s, fld, v, disc: LongInt;
  loV, hiV: TConstVal;
  lo, hi: Int64;
  rec, vp, f, f2, nm: LongInt;
  cur, vbase, vmax, voff, dt, kt: LongInt;
begin
  ResolveType := tyErr;
  if node < 0 then Exit;
  case Nodes[node].Kind of
    nkTypeRef: begin
      if Nodes[node].A >= 0 then begin
        { a unit-qualified type name, geo.Vec: resolve in the dependency's export scope }
        i := QualIndex(Nodes[Nodes[node].A].Text);
        if i < 0 then begin
          SemErrName(node, 'unknown unit qualifier ''' + Nodes[Nodes[node].A].Text + '''');
          Exit;
        end;
        s := FindLocal(Nodes[node].Text, QScope[i]);
        if (s < 0) or (Syms[s].Kind <> syType) then
          SemErrName(node, 'unit ''' + Nodes[Nodes[node].A].Text +
            ''' has no exported type ''' + Nodes[node].Text + '''')
        else ResolveType := Syms[s].TypeId;
        Exit;
      end;
      s := Lookup(Nodes[node].Text);
      if s < 0 then SemErrName(node, 'unknown type ''' + Nodes[node].Text + '''')
      else if Syms[s].Kind <> syType then
        SemErrName(node, '''' + Nodes[node].Text + ''' is not a type')
      else ResolveType := Syms[s].TypeId;
    end;
    nkEnumType: begin
      ty := NewSemType(skEnum);
      for i := 0 to High(Nodes[node].Kids) do begin
        AddMember(ty, Nodes[Nodes[node].Kids[i]].Text, tyInt);
        s := Declare(Nodes[Nodes[node].Kids[i]].Text, syEnumLit, Nodes[node].Kids[i]);
        Syms[s].TypeId := ty;
        Syms[s].Ordinal := i;
      end;
      ResolveType := ty;
    end;
    nkSubrange: begin
      ty := NewSemType(skSubrange);
      if Nodes[node].Flag = 2 then begin
        { a named ordinal type used whole as an array index, array[TColor] }
        s := Lookup(Nodes[node].Text);
        if (s < 0) or (Syms[s].Kind <> syType) then begin
          SemErr(node, 'unknown index type ''' + Nodes[node].Text + '''');
          SemTypes[ty].Lo := 0; SemTypes[ty].Hi := 0; SemTypes[ty].Base := tyInt;
        end
        else if not OrdinalRange(Syms[s].TypeId, lo, hi) then begin
          SemErr(node, '''' + Nodes[node].Text + ''' is not an ordinal index type');
          SemTypes[ty].Lo := 0; SemTypes[ty].Hi := 0; SemTypes[ty].Base := tyInt;
        end
        else begin
          SemTypes[ty].Lo := lo; SemTypes[ty].Hi := hi;
          SemTypes[ty].Base := Syms[s].TypeId;
        end;
        ResolveType := ty;
        Exit;
      end;
      loV := EvalConst(Nodes[node].A);
      hiV := EvalConst(Nodes[node].B);
      if not loV.Ok then SemErr(node, 'subrange lower bound is not constant');
      if not hiV.Ok then SemErr(node, 'subrange upper bound is not constant');
      SemTypes[ty].Lo := loV.I;
      SemTypes[ty].Hi := hiV.I;
      if Nodes[node].Flag = 1 then begin
        s := Lookup(Nodes[node].Text);
        if (s >= 0) and (Syms[s].Kind = syType) then SemTypes[ty].Base := Syms[s].TypeId
        else begin
          SemErr(node, 'unknown base type ''' + Nodes[node].Text + '''');
          SemTypes[ty].Base := tyInt;
        end;
      end
      else if loV.Ok then SemTypes[ty].Base := loV.Ty
      else SemTypes[ty].Base := tyInt;
      ResolveType := ty;
    end;
    nkArrayType: begin
      ty := NewSemType(skArray);
      for i := 0 to High(Nodes[node].Kids) do begin
        s := ResolveType(Nodes[node].Kids[i]);
        v := Length(SemTypes[ty].Subs);
        SetLength(SemTypes[ty].Subs, v + 1);
        SemTypes[ty].Subs[v] := s;
      end;
      SemTypes[ty].Base := ResolveType(Nodes[node].A);
      { Flag=2 on the type node marks `buffer of T`, a shared dynamic array whose backing is
        host-owned; the default `array of T` is the value/eager-copy form. }
      if Nodes[node].Flag = 2 then begin
        SemTypes[ty].HostBuf := true;
        SemTypes[ty].Rank := Nodes[node].IntVal;   { 1 for `buffer of T`, 2 for `buffer[,]`, ... }
        { A buffer's backing is host memory, so the runtime cannot manage element handle
          lifetimes across the boundary. Restrict its element to reference-free data. }
        if TypeHasHandle(SemTypes[ty].Base) then
          SemErr(node, 'a buffer element must be reference-free data (no string, handle, ' +
            'array, or record with such a field)');
      end;
      if Length(SemTypes[ty].Subs) = 0 then begin
        { a dynamic array; element types are ordinals, reals, whole handles (strings,
          interfaces, processes, nested dynamic arrays), sets, and records or fixed arrays,
          including those with handle fields. A set is reference-free, so it carries no
          per-element handle layout: a small set rides the 64-bit scalar slot, a large set
          blits like any inline aggregate. }
        s := SemTypes[ty].Base;
        if not ((s >= 0) and (s < SemCount) and
                ((SemTypes[s].Kind in [skInteger, skBoolean, skChar, skEnum, skSubrange,
                                       skReal, skRecord, skArray, skSet]) or
                 TypeIsHandleSem(s))) then
          SemErr(node, 'a dynamic array element must be an ordinal, real, handle, ' +
            'set, record, or array');
      end;
      ResolveType := ty;
    end;
    nkSetType: begin
      ty := NewSemType(skSet);
      SemTypes[ty].Base := ResolveType(Nodes[node].A);
      if TypeMentionsLabel(SemTypes[ty].Base) then
        SemErr(node, 'a ''label'' value cannot be a set element');
      ResolveType := ty;
    end;
    nkMapType: begin
      { `map of T`: a string-keyed associative array. Base is the value type T. The value is
        managed like a dynamic-array element (ordinal, real, whole handle, set, record, or
        fixed array), so the same handle-field layout reclaims managed values. A set is
        reference-free, so its slot needs no handle layout. }
      ty := NewSemType(skMap);
      { the key type: `map[K] of T` gives K, bare `map of T` is string-keyed. A string key uses
        the handle-keyed table (kp_map_*); an ordinal key (integer, int64, char, enum, boolean)
        is stored by value and hashed as a 64-bit integer (kp_imap_*). }
      if Nodes[node].B >= 0 then kt := ResolveType(Nodes[node].B) else kt := tyStr;
      if not ((kt = tyStr) or IsOrdinalType(kt)) then
        SemErr(node, 'a map key must be a string or an ordinal (integer, int64, char, enum, boolean)');
      SetLength(SemTypes[ty].Subs, 1);
      SemTypes[ty].Subs[0] := kt;
      SemTypes[ty].Base := ResolveType(Nodes[node].A);
      if TypeMentionsLabel(SemTypes[ty].Base) then
        SemErr(node, 'a ''label'' value cannot be a map value');
      s := SemTypes[ty].Base;
      if not ((s >= 0) and (s < SemCount) and
              ((SemTypes[s].Kind in [skInteger, skBoolean, skChar, skEnum, skSubrange,
                                     skReal, skRecord, skArray, skSet]) or
               TypeIsHandleSem(s))) then
        SemErr(node, 'a map value must be an ordinal, real, handle, set, record, or array');
      ResolveType := ty;
    end;
    nkRecordType: begin
      rec := NewSemType(skRecord);
      cur := 0;
      for i := 0 to High(Nodes[node].Kids) do begin
        f := Nodes[node].Kids[i];
        if Nodes[f].Kind = nkFieldDecl then begin
          fld := ResolveType(Nodes[f].A);
          { a `label` value is second-class: a record field would let it escape
            the frame, so it may not be a field (nor an array-of-label field) }
          if TypeMentionsLabel(fld) then
            SemErr(f, 'a ''label'' value cannot be a record field; it may live ' +
              'only in a local variable or a routine-local array of label');
          if Nodes[f].Flag = 1 then begin
            { a computed field: accessor-backed, no storage (doc/languages/kobold/kp-property.md).
              Its accessors are methods of this record, resolved at the use site like any
              method, so a forward reference to an accessor declared later is fine. }
            if not IsPropertyValueType(fld) then
              SemErr(f, 'a computed field type must be a value (ordinal, real, int64), a handle '
                + '(string, dynamic array, map, interface, process), or an aggregate (record, array, set)');
            AddMember(rec, Nodes[Nodes[f].Kids[0]].Text, fld);
            SetMemberOff(rec, -1);
            SetMemberProp(rec, Nodes[Nodes[f].B].Text, PropSetterName(f));
          end
          else
            for v := 0 to High(Nodes[f].Kids) do begin
              cur := RoundUp(cur, TypeAlign(fld));
              AddMember(rec, Nodes[Nodes[f].Kids[v]].Text, fld);
              SetMemberOff(rec, cur);
              cur := cur + TypeSize(fld);
            end;
        end
        else if Nodes[f].Kind = nkVariantPart then begin
          vp := f;
          if Nodes[vp].Text <> '' then begin
            dt := ResolveType(Nodes[vp].A);
            cur := RoundUp(cur, TypeAlign(dt));
            AddMember(rec, Nodes[vp].Text, dt);
            SetMemberOff(rec, cur);
            cur := cur + TypeSize(dt);
          end;
          { every variant overlays the others, so each starts at the same base offset;
            the record grows to the widest variant }
          vbase := cur;
          vmax := cur;
          for v := 0 to High(Nodes[vp].Kids) do begin
            disc := Nodes[vp].Kids[v];   { nkVariant }
            voff := vbase;
            for nm := 0 to High(Nodes[disc].Kids) do begin
              f2 := Nodes[disc].Kids[nm];
              if Nodes[f2].Kind = nkFieldDecl then begin
                fld := ResolveType(Nodes[f2].A);
                for s := 0 to High(Nodes[f2].Kids) do begin
                  voff := RoundUp(voff, TypeAlign(fld));
                  AddMember(rec, Nodes[Nodes[f2].Kids[s]].Text, fld);
                  SetMemberOff(rec, voff);
                  voff := voff + TypeSize(fld);
                end;
              end;
            end;
            if voff > vmax then vmax := voff;
          end;
          cur := vmax;
        end;
      end;
      ResolveType := rec;
    end;
    nkInterfaceType: begin
      ty := NewSemType(skInterface);
      for i := 0 to High(Nodes[node].Kids) do begin
        f := Nodes[node].Kids[i];   { nkInterfaceField, Text=name, A=ProcType }
        AddMember(ty, Nodes[f].Text, ResolveType(Nodes[f].A));
      end;
      ResolveType := ty;
    end;
    nkProcType: begin
      ty := NewSemType(skProc);
      for i := 0 to High(Nodes[node].Kids) do begin
        f := Nodes[node].Kids[i];   { nkParam }
        fld := ResolveType(Nodes[f].A);
        for v := 0 to High(Nodes[f].Kids) do
          AddSigParam(ty, fld, Nodes[f].Flag);
      end;
      if Nodes[node].Flag = 1 then SemTypes[ty].RetType := ResolveType(Nodes[node].B)
      else SemTypes[ty].RetType := -1;
      ResolveType := ty;
    end;
  else
    SemErr(node, 'invalid type');
  end;
end;

{ ---- expression checks ---- }

function MatchCall(sig: LongInt; const argtys: TIntArray): Boolean;
var
  i: LongInt;
begin
  MatchCall := False;
  if (sig < 0) or (SemTypes[sig].Kind <> skProc) then Exit;
  if SemTypes[sig].Variadic then Exit(True);
  if Length(argtys) <> Length(SemTypes[sig].ParamTypes) then Exit;
  for i := 0 to High(argtys) do
    if not AssignCompatible(SemTypes[sig].ParamTypes[i], argtys[i]) then Exit;
  MatchCall := True;
end;

function MatchExact(sig: LongInt; const argtys: TIntArray): Boolean;
{ Every argument is exactly the parameter type. Preferred over a match that
  needs a conversion, so an int argument picks the int overload over a real one. }
var
  i: LongInt;
begin
  MatchExact := False;
  if (sig < 0) or (SemTypes[sig].Kind <> skProc) or SemTypes[sig].Variadic then Exit;
  if Length(argtys) <> Length(SemTypes[sig].ParamTypes) then Exit;
  for i := 0 to High(argtys) do
    if argtys[i] <> SemTypes[sig].ParamTypes[i] then Exit;
  MatchExact := True;
end;

function NormOrd(ty: LongInt): LongInt;
begin
  if (ty >= 0) and (SemTypes[ty].Kind = skSubrange) then NormOrd := SemTypes[ty].Base
  else NormOrd := ty;
end;

function IsCharLit(node: LongInt): Boolean;
{ A one-character string literal, which denotes a char value when used against a char. }
begin
  IsCharLit := (node >= 0) and (Nodes[node].Kind = nkStrLit) and
               (Length(Nodes[node].Text) = 1);
end;

procedure CoerceCharLit(node, otherTy: LongInt);
{ In a char context (compared, assigned, or passed against a char), retype a one-character
  string literal to char in place, so it lowers as a character code rather than a freshly
  built string. }
begin
  if IsCharLit(node) and (NormOrd(otherTy) = tyChar) then Nodes[node].Ty := tyChar;
end;

procedure CheckCall(node, sig: LongInt; const argtys: TIntArray);
{ Report a wrong argument count or the first incompatible argument. }
var
  i, aty: LongInt;
begin
  if (sig < 0) or (SemTypes[sig].Kind <> skProc) then Exit;
  if SemTypes[sig].Variadic then Exit;
  if Length(argtys) <> Length(SemTypes[sig].ParamTypes) then begin
    SemErr(node, 'wrong number of arguments: expected ' +
      IntToStr(Length(SemTypes[sig].ParamTypes)) + ', got ' +
      IntToStr(Length(argtys)));
    Exit;
  end;
  for i := 0 to High(argtys) do begin
    aty := argtys[i];
    { a one-character string literal denotes a char value where a char is expected
      (doc/languages/kobold/kp-language.md), so retype the argument node in place and
      pass it as a char rather than rejecting it as a string }
    if (NormOrd(SemTypes[sig].ParamTypes[i]) = tyChar) and (i < Length(Nodes[node].Kids))
       and IsCharLit(Nodes[node].Kids[i]) then begin
      CoerceCharLit(Nodes[node].Kids[i], SemTypes[sig].ParamTypes[i]);
      aty := tyChar;
    end;
    if not AssignCompatible(SemTypes[sig].ParamTypes[i], aty) then
      SemErr(node, 'argument ' + IntToStr(i + 1) + ': cannot pass ' +
        TypeName(argtys[i]) + ' to ' + TypeName(SemTypes[sig].ParamTypes[i]));
  end;
end;

procedure CollectRoutines(const name: string; scope: LongInt; out cands: TIntArray);
var
  i, s, n: LongInt;
  l: string;
begin
  SetLength(cands, 0);
  n := 0;
  l := LowerStr(name);
  for i := 0 to High(Scopes[scope].Members) do begin
    s := Scopes[scope].Members[i];
    if (Syms[s].Kind in [syProc, syFunc]) and (Syms[s].LowerName = l) then begin
      SetLength(cands, n + 1); cands[n] := s; Inc(n);
    end;
  end;
end;

function ResolveOverload(const cands, argtys: TIntArray; out nmatch: LongInt): LongInt;
var
  i, best: LongInt;
begin
  { first prefer an exact match, then fall back to a compatible one }
  best := -1;
  nmatch := 0;
  for i := 0 to High(cands) do
    if MatchExact(Syms[cands[i]].TypeId, argtys) then begin
      Inc(nmatch);
      if best < 0 then best := cands[i];
    end;
  if nmatch > 0 then begin ResolveOverload := best; Exit; end;
  for i := 0 to High(cands) do
    if MatchCall(Syms[cands[i]].TypeId, argtys) then begin
      Inc(nmatch);
      if best < 0 then best := cands[i];
    end;
  ResolveOverload := best;
end;

function Comparable(a, b: LongInt): Boolean;
begin
  Comparable := True;
  if (a = tyErr) or (b = tyErr) then Exit;
  if IsNumeric(a) and IsNumeric(b) then Exit;
  a := NormOrd(a);
  b := NormOrd(b);
  if a = b then Exit;
  if (SemTypes[a].Kind = skNil) and
     (SemTypes[b].Kind in [skInterface, skString, skProcess, skProc]) then Exit;
  if (SemTypes[b].Kind = skNil) and
     (SemTypes[a].Kind in [skInterface, skString, skProcess, skProc]) then Exit;
  Comparable := False;
end;

procedure CheckRoutineValue(node, s: LongInt);
{ A nested routine that reads an enclosing local cannot be taken as a value
  (a procedural value is a bare code pointer with no environment). }
begin
  if (Syms[s].Scope <> 0) and Syms[s].Captures then
    SemErr(node, 'cannot take the value of nested routine ''' + Syms[s].Name +
      ''' that reads an enclosing variable');
end;

function NumResult(a, b: LongInt): LongInt;
begin
  if (SemTypes[a].Kind = skReal) or (SemTypes[b].Kind = skReal) then
    NumResult := tyReal
  else if IsInt64(a) or IsInt64(b) then NumResult := tyInt64
  else NumResult := tyInt;
end;

function IntResult(a, b: LongInt): LongInt;
{ The result width of an integer-only operator (div, mod, shift, bitwise): Int64 when
  either operand is Int64, else the 32-bit integer. }
begin
  if IsInt64(a) or IsInt64(b) then IntResult := tyInt64
  else IntResult := tyInt;
end;

function AnalyzeBinary(node: LongInt): LongInt;
var
  lt, rt: LongInt;
begin
  lt := AnalyzeExpr(Nodes[node].A);
  rt := AnalyzeExpr(Nodes[node].B);
  AnalyzeBinary := tyErr;
  if (lt = tyErr) or (rt = tyErr) then Exit;
  case Nodes[node].Op of
    tkPlus:
      if IsSet(lt) and IsSet(rt) then AnalyzeBinary := lt
      else if (lt = tyStr) or (rt = tyStr) then AnalyzeBinary := tyStr
      else if (lt = tyChar) and (rt = tyChar) then AnalyzeBinary := tyStr
      else if IsNumeric(lt) and IsNumeric(rt) then AnalyzeBinary := NumResult(lt, rt)
      else SemErr(node, 'operands of + are not compatible');
    tkMinus, tkStar:
      if IsSet(lt) and IsSet(rt) then AnalyzeBinary := lt
      else if IsNumeric(lt) and IsNumeric(rt) then AnalyzeBinary := NumResult(lt, rt)
      else SemErr(node, 'operands of ' + OpSym(Nodes[node].Op) +
        ' must be numeric');
    tkSlash:
      if IsNumeric(lt) and IsNumeric(rt) then AnalyzeBinary := tyReal
      else SemErr(node, 'operands of / must be numeric');
    tkDiv, tkMod, tkShl, tkShr:
      if IsIntClass(lt) and IsIntClass(rt) then AnalyzeBinary := IntResult(lt, rt)
      else SemErr(node, 'operands of ' + OpSym(Nodes[node].Op) +
        ' must be integer');
    tkAnd, tkOr:
      if (lt = tyBool) and (rt = tyBool) then AnalyzeBinary := tyBool
      else if IsIntClass(lt) and IsIntClass(rt) then AnalyzeBinary := IntResult(lt, rt)
      else SemErr(node, 'operands of ' + OpSym(Nodes[node].Op) +
        ' must be boolean or integer');
    tkEq, tkNeq, tkLt, tkGt, tkLe, tkGe: begin
      { a one-character string literal opposite a char is compared as a char }
      CoerceCharLit(Nodes[node].A, rt);
      CoerceCharLit(Nodes[node].B, lt);
      if Nodes[Nodes[node].A].Ty = tyChar then lt := tyChar;
      if Nodes[Nodes[node].B].Ty = tyChar then rt := tyChar;
      if Comparable(lt, rt) then AnalyzeBinary := tyBool
      else SemErr(node, 'operands of ' + OpSym(Nodes[node].Op) +
        ' are not comparable');
    end;
    tkIn:
      if IsSet(rt) then AnalyzeBinary := tyBool
      else if IsMap(rt) then begin
        CoerceCharLit(Nodes[node].A, MapKeyType(rt));
        if Nodes[Nodes[node].A].Ty = tyChar then lt := tyChar;
        if not AssignCompatible(MapKeyType(rt), lt) then
          SemErr(node, 'the left operand of in on a map must be a ' + TypeName(MapKeyType(rt)) + ' key')
        else
          AnalyzeBinary := tyBool;   { k in m tests for a key }
      end
      else SemErr(node, 'the right operand of in must be a set or a map');
  else
    AnalyzeBinary := tyErr;
  end;
end;

function AnalyzeField(node: LongInt): LongInt;
var
  bt, m, sig, qi, s: LongInt;
begin
  AnalyzeField := tyErr;
  { a unit-qualified reference, geo.name: the base is a qualifier, not a value. Resolve
    name in that unit's export scope and mark the node so lowering treats it as a direct
    reference to the resolved symbol, not a method dispatch. }
  if Nodes[Nodes[node].A].Kind = nkIdent then begin
    qi := QualIndex(Nodes[Nodes[node].A].Text);
    if qi >= 0 then begin
      s := FindLocal(Nodes[node].Text, QScope[qi]);
      if s < 0 then begin
        SemErr(node, 'unit ''' + QName[qi] + ''' has no exported ''' +
          Nodes[node].Text + '''');
        Exit;
      end;
      Syms[s].Used := True;
      Nodes[node].Sym := s;
      Nodes[node].Flag := 1;            { a unit-qualified reference }
      AnalyzeField := Syms[s].TypeId;    { value type for var/const, signature for a routine }
      Exit;
    end;
  end;
  bt := AnalyzeExpr(Nodes[node].A);
  if bt = tyErr then Exit;
  case SemTypes[bt].Kind of
    skRecord: begin
      m := FindMember(bt, Nodes[node].Text);
      if m >= 0 then begin
        AnalyzeField := SemTypes[bt].Subs[m];
        { a computed field is backed by accessor methods on the record; check the getter
          (and setter, when present) exist (doc/languages/kobold/kp-property.md) }
        if SemTypes[bt].PropGet[m] <> '' then begin
          if FindMethod(bt, SemTypes[bt].PropGet[m]) < 0 then
            SemErr(node, 'computed field ''' + Nodes[node].Text +
              ''' needs a ''' + SemTypes[bt].PropGet[m] + ''' method on ' + TypeName(bt));
          if (SemTypes[bt].PropSet[m] <> '') and (FindMethod(bt, SemTypes[bt].PropSet[m]) < 0) then
            SemErr(node, 'computed field ''' + Nodes[node].Text +
              ''' needs a ''' + SemTypes[bt].PropSet[m] + ''' method on ' + TypeName(bt));
        end;
      end
      else begin
        sig := FindMethod(bt, Nodes[node].Text);
        if sig >= 0 then AnalyzeField := sig
        else SemErr(node, 'record has no field or method ''' +
          Nodes[node].Text + '''');
      end;
    end;
    skInterface: begin
      { a script method on the handle type overrides a host vtable entry }
      sig := FindMethod(bt, Nodes[node].Text);
      if sig >= 0 then AnalyzeField := sig
      else begin
        m := FindMember(bt, Nodes[node].Text);
        if m >= 0 then AnalyzeField := SemTypes[bt].Subs[m]
        else SemErr(node, 'interface has no method ''' + Nodes[node].Text + '''');
      end;
    end;
  else
    { field access on a non-record/interface: left for a later increment }
  end;
end;

function AnalyzeIndex(node: LongInt): LongInt;
var
  bt, i: LongInt;
begin
  AnalyzeIndex := tyErr;
  bt := AnalyzeExpr(Nodes[node].A);
  for i := 0 to High(Nodes[node].Kids) do AnalyzeExpr(Nodes[node].Kids[i]);
  if bt = tyErr then Exit;
  case SemTypes[bt].Kind of
    skArray:
      { a dynamic array is indexed by exactly its rank: one subscript for `array of T`,
        `ref array of T`, or a 1D buffer, and one per dimension for a multidimensional
        buffer. A fixed array keeps its existing (unchecked) indexing. }
      if IsDynArray(bt) and (Length(Nodes[node].Kids) <> BufRank(bt)) then
        SemErr(node, 'a ' + TypeName(bt) + ' takes ' + IntToStr(BufRank(bt)) +
          ' subscript(s), not ' + IntToStr(Length(Nodes[node].Kids)))
      else
        AnalyzeIndex := SemTypes[bt].Base;
    skString: AnalyzeIndex := tyChar;   { s[i] is a character }
    skMap: begin
      { a map takes one subscript, its key; the result is the value type }
      if Length(Nodes[node].Kids) = 1 then
        CoerceCharLit(Nodes[node].Kids[0], MapKeyType(bt));
      if Length(Nodes[node].Kids) <> 1 then
        SemErr(node, 'a map takes one key subscript, not ' +
          IntToStr(Length(Nodes[node].Kids)))
      else if not AssignCompatible(MapKeyType(bt), Nodes[Nodes[node].Kids[0]].Ty) then
        SemErr(node, 'a map key must be a ' + TypeName(MapKeyType(bt)))
      else
        AnalyzeIndex := SemTypes[bt].Base;
    end;
    skInteger, skReal, skBoolean, skChar:
      SemErr(node, 'cannot index a ' + TypeName(bt));
  end;
end;

function AnalyzeCallOf(callee: LongInt; const argtys: TIntArray;
  errNode: LongInt): LongInt;
{ Resolve and check a call of the given callee designator with the given
  argument types. Shared by a call expression and a bare call statement. }
var
  s, sig, ret, best, nmatch: LongInt;
  cands: TIntArray;
  bn: string;
begin
  AnalyzeCallOf := tyErr;
  if Nodes[callee].Kind = nkIdent then begin
    s := Lookup(Nodes[callee].Text);
    Nodes[callee].Sym := s;
    if s < 0 then begin
      SemErrName(callee, 'undeclared identifier ''' + Nodes[callee].Text + '''' +
        SuggestName(Nodes[callee].Text));
      Exit;
    end;
    case Syms[s].Kind of
      syProc, syFunc: begin
        CollectRoutines(Nodes[callee].Text, Syms[s].Scope, cands);
        best := ResolveOverload(cands, argtys, nmatch);
        if best < 0 then begin
          if Length(cands) = 1 then CheckCall(errNode, Syms[cands[0]].TypeId, argtys)
          else SemErr(errNode, 'no overload of ''' + Nodes[callee].Text +
            ''' matches the arguments');
          sig := Syms[s].TypeId;   { best-effort result type }
        end
        else begin
          if nmatch > 1 then
            SemErr(errNode, 'call to ''' + Nodes[callee].Text + ''' is ambiguous');
          Nodes[callee].Sym := best;   { the resolved overload, for lowering }
          sig := Syms[best].TypeId;
        end;
        ret := SemTypes[sig].RetType;
        if ret < 0 then AnalyzeCallOf := tyVoid else AnalyzeCallOf := ret;
        { succ/pred take one ordinal and return that same ordinal type; odd takes
          one integer and returns boolean }
        if (Syms[s].Node < 0) and (Length(argtys) = 1) then begin
          bn := Syms[s].LowerName;
          if (bn = 'succ') or (bn = 'pred') then begin
            if not IsOrdinalType(argtys[0]) then
              SemErr(errNode, bn + ' requires an ordinal argument')
            else
              AnalyzeCallOf := argtys[0];
          end
          else if (bn = 'odd') and not IsIntClass(argtys[0]) then
            SemErr(errNode, 'odd requires an integer argument')
          { abs/sqr carry the argument's own numeric type }
          else if (bn = 'abs') or (bn = 'sqr') then begin
            if not IsNumeric(argtys[0]) then
              SemErr(errNode, bn + ' requires a numeric argument')
            else
              AnalyzeCallOf := argtys[0];
          end
          else if (bn = 'sqrt') and not IsNumeric(argtys[0]) then
            SemErr(errNode, 'sqrt requires a numeric argument')
          else if ((bn = 'round') or (bn = 'trunc')) and not IsRealType(argtys[0]) then
            SemErr(errNode, bn + ' requires a real argument')
          else if ((bn = 'sin') or (bn = 'cos') or (bn = 'exp') or (bn = 'ln')
                or (bn = 'arctan')) and not IsNumeric(argtys[0]) then
            SemErr(errNode, bn + ' requires a numeric argument');
        end;
        { SetLength cannot resize a buffer (the host owns its element backing) or a string (a
          string is immutable). Checked here in the semantic pass so it reports even when the
          program has other errors and lowering does not run. }
        if (Syms[s].Node < 0) and (Syms[s].LowerName = 'setlength') and
           (Length(argtys) >= 1) then begin
          if IsBuffer(argtys[0]) then
            SemErr(errNode, 'cannot SetLength a buffer; the host owns its backing')
          else if (argtys[0] >= 0) and (argtys[0] < SemCount) and
                  (SemTypes[argtys[0]].Kind = skString) then
            SemErr(errNode, 'a string is immutable; SetLength cannot resize it ' +
              '(build with concatenation or Copy)');
        end;
        { Delete(m, key) removes a key from a map. Delete(a, index, count) and
          Insert(a, index, count) edit a dynamic array in place: the first argument is a value
          `array of T` (not a buffer, whose backing the host owns), and the index and count are
          integers. }
        if (Syms[s].Node < 0) and (Syms[s].LowerName = 'delete') and
           (Length(argtys) = 2) and IsMap(argtys[0]) then begin
          CoerceCharLit(Nodes[errNode].Kids[1], MapKeyType(argtys[0]));
          if not AssignCompatible(MapKeyType(argtys[0]), Nodes[Nodes[errNode].Kids[1]].Ty) then
            SemErr(errNode, 'Delete on a map takes a ' + TypeName(MapKeyType(argtys[0])) + ' key');
        end
        else if (Syms[s].Node < 0) and
           ((Syms[s].LowerName = 'delete') or (Syms[s].LowerName = 'insert')) then begin
          if Length(argtys) <> 3 then
            SemErr(errNode, Syms[s].Name + ' takes a dynamic array, an index, and a count')
          else if not IsDynArray(argtys[0]) or IsBuffer(argtys[0]) then
            SemErr(errNode, Syms[s].Name + ' requires a dynamic-array variable')
          else if not IsIntClass(argtys[1]) or not IsIntClass(argtys[2]) then
            SemErr(errNode, 'the index and count of ' + Syms[s].Name + ' must be integers');
        end;
        { TryGet(m, key, out v) tests a map and fetches the value; the out value must match the
          map's value type. MapFirst(m) returns an iterator; MapNext(it, out k, out v) advances
          it. The iterator is opaque, so MapNext's out value type is not checked against the map:
          the caller must pass a variable of the map's value type. }
        if (Syms[s].Node < 0) and (Syms[s].LowerName = 'tryget') then begin
          if (Length(argtys) = 3) and IsMap(argtys[0]) then
            CoerceCharLit(Nodes[errNode].Kids[1], MapKeyType(argtys[0]));
          if Length(argtys) <> 3 then
            SemErr(errNode, 'TryGet takes a map, a key, and an out value')
          else if not IsMap(argtys[0]) then
            SemErr(errNode, 'the first argument of TryGet must be a map')
          else if not AssignCompatible(MapKeyType(argtys[0]), Nodes[Nodes[errNode].Kids[1]].Ty) then
            SemErr(errNode, 'the key of TryGet must be a ' + TypeName(MapKeyType(argtys[0])))
          else if argtys[2] <> SemTypes[argtys[0]].Base then
            SemErr(errNode, 'the out value of TryGet must be the map value type');
        end;
        if (Syms[s].Node < 0) and (Syms[s].LowerName = 'mapfirst') then begin
          if (Length(argtys) <> 1) or not IsMap(argtys[0]) then
            SemErr(errNode, 'MapFirst takes one map');
        end;
        if (Syms[s].Node < 0) and (Syms[s].LowerName = 'mapnext') then begin
          if Length(argtys) <> 3 then
            SemErr(errNode, 'MapNext takes an iterator, an out key, and an out value')
          else if argtys[0] <> tyMapIter then
            SemErr(errNode, 'the first argument of MapNext must be a mapiter')
          else if not ((argtys[1] = tyStr) or IsOrdinalType(argtys[1])) then
            { the iterator is opaque, so the key kind cannot be checked against its map here;
              the lowering dispatches on this out-key's own type (string handle vs ordinal) }
            SemErr(errNode, 'the key of MapNext must be a string or an ordinal');
        end;
        { fail(code) builds an error value from an integer code; errorcode(e) reads it back }
        if (Syms[s].Node < 0) and (Syms[s].LowerName = 'fail') then begin
          if (Length(argtys) <> 1) or not IsIntClass(argtys[0]) then
            SemErr(errNode, 'fail takes one integer error code');
        end;
        if (Syms[s].Node < 0) and (Syms[s].LowerName = 'errorcode') then begin
          if (Length(argtys) <> 1) or (argtys[0] <> tyErrorVal) then
            SemErr(errNode, 'errorcode takes one error value');
        end;
      end;
      syVar, syParam: begin
        MarkCapture(s);
        sig := Syms[s].TypeId;
        if (sig >= 0) and (SemTypes[sig].Kind = skProc) then begin
          CheckCall(errNode, sig, argtys);
          ret := SemTypes[sig].RetType;
          if ret < 0 then AnalyzeCallOf := tyVoid else AnalyzeCallOf := ret;
        end
        else if (sig >= 0) and (SemTypes[sig].Kind = skProcess) then
          { resuming a coroutine, k(v); the answer type is not carried in the
            opaque process type, so the result stays unknown }
        else
          SemErr(callee, '''' + Nodes[callee].Text + ''' is not callable');
      end;
      syType:
        { a type name applied to one argument is a conversion, not a call. Only the
          numeric and ordinal types convert, which is all kpcom needs (Int64/LongInt). }
        if Length(argtys) <> 1 then
          SemErr(errNode, 'a type conversion takes one argument')
        else if not (IsNumeric(argtys[0]) or IsOrdinalType(argtys[0])) then
          SemErr(errNode, 'cannot convert ' + TypeName(argtys[0]) + ' to ' +
            TypeName(Syms[s].TypeId))
        else if not (IsNumeric(Syms[s].TypeId) or IsOrdinalType(Syms[s].TypeId)) then
          SemErr(errNode, 'cannot convert to ' + TypeName(Syms[s].TypeId))
        else
          AnalyzeCallOf := Syms[s].TypeId;
    else
      SemErr(callee, '''' + Nodes[callee].Text + ''' is not callable');
    end;
  end
  else begin
    { for a method call the callee is a field; take its raw proc type rather
      than the auto-called value type }
    if Nodes[callee].Kind = nkField then sig := AnalyzeField(callee)
    else sig := AnalyzeExpr(callee);
    { record the callee's type on the node: the field path bypasses the AnalyzeExpr
      wrapper that normally stores it, and lowering classifies the callee by it }
    Nodes[callee].Ty := sig;
    if (sig >= 0) and (SemTypes[sig].Kind = skProc) then begin
      CheckCall(errNode, sig, argtys);
      ret := SemTypes[sig].RetType;
      if ret < 0 then AnalyzeCallOf := tyVoid else AnalyzeCallOf := ret;
    end
    else if (sig >= 0) and (SemTypes[sig].Kind = skProcess) then
      { resuming a coroutine held in a record field, k(v); as for a process
        variable, the answer type is not carried in the opaque process type }
    ;
    { else: an unresolved member (deferred); stay at the error type }
  end;
end;

function IsAssignableDesignator(node: LongInt): Boolean;
{ True when node names a storage location an argument can be passed by reference:
  a variable or parameter (not a constant, function, or type), a record field, or
  an array element. }
var
  s: LongInt;
begin
  case Nodes[node].Kind of
    nkIdent: begin
      s := Nodes[node].Sym;
      IsAssignableDesignator := (s >= 0) and (Syms[s].Kind in [syVar, syParam]);
    end;
    nkField, nkIndex:
      IsAssignableDesignator := True;
  else
    IsAssignableDesignator := False;
  end;
end;

procedure CheckByRefArgs(callNode, sig: LongInt);
{ A var/out argument must be an assignable designator, since the callee writes
  through its address. }
var
  i, np, na: LongInt;
begin
  if (sig < 0) or (SemTypes[sig].Kind <> skProc) then Exit;
  np := Length(SemTypes[sig].ParamModes);
  na := Length(Nodes[callNode].Kids);
  for i := 0 to na - 1 do
    if (i < np) and
       ((SemTypes[sig].ParamModes[i] = 1) or (SemTypes[sig].ParamModes[i] = 3)) and
       not IsAssignableDesignator(Nodes[callNode].Kids[i]) then
      SemErr(Nodes[callNode].Kids[i], 'argument ' + IntToStr(i + 1) +
        ': a var or out parameter needs a variable');
end;

function AnalyzeCall(node: LongInt): LongInt;
var
  argtys: TIntArray;
  i, argn, callee, s: LongInt;
begin
  argn := Length(Nodes[node].Kids);
  SetLength(argtys, argn);
  for i := 0 to argn - 1 do argtys[i] := AnalyzeExpr(Nodes[node].Kids[i]);
  AnalyzeCall := AnalyzeCallOf(Nodes[node].A, argtys, node);
  { the by-reference check reads the callee resolved above; a direct routine call
    carries its signature on the callee symbol }
  callee := Nodes[node].A;
  { must-consume: a call to a `fails` routine has to be handled by a failable form, so its
    result and error cannot reach the program unchecked (doc/languages/kobold/kp-errors.md). The fail-form
    analysis flags its own target in FailTargetNode; any other failable call is an error. }
  s := -1;
  if Nodes[callee].Kind = nkIdent then s := Nodes[callee].Sym;
  if (s >= 0) and (Syms[s].Kind in [syProc, syFunc]) and
     (Syms[s].TypeId >= 0) and SemTypes[Syms[s].TypeId].Failable and
     (node <> FailTargetNode) then
    SemErr(node, 'unhandled failable call; use ''fails'', ''or else'', or a divert')
  else if (Nodes[callee].Kind = nkField) and (Nodes[callee].Ty >= 0) and
          (Nodes[callee].Ty < SemCount) and (SemTypes[Nodes[callee].Ty].Kind = skProc) and
          SemTypes[Nodes[callee].Ty].Failable and (node <> FailTargetNode) then
    SemErr(node, 'unhandled failable call; use ''fails'', ''or else'', or a divert');
  if Nodes[callee].Kind = nkIdent then begin
    s := Nodes[callee].Sym;
    if (s >= 0) and (Syms[s].Kind in [syProc, syFunc, syVar, syParam]) then
      CheckByRefArgs(node, Syms[s].TypeId);
    { read/readln write into their arguments, so each must be an assignable variable
      of a readable type: an integer, real, char, or string. }
    if (s >= 0) and (Syms[s].Node < 0) and
       ((Syms[s].LowerName = 'read') or (Syms[s].LowerName = 'readln')) then
      for i := 0 to argn - 1 do begin
        if not IsAssignableDesignator(Nodes[node].Kids[i]) then
          SemErr(Nodes[node].Kids[i], Syms[s].LowerName + ' needs a variable argument')
        else if not (IsIntClass(argtys[i]) or IsRealType(argtys[i])
                or (argtys[i] = tyChar) or (argtys[i] = tyStr)) then
          SemErr(Nodes[node].Kids[i], Syms[s].LowerName +
            ' cannot read into ' + TypeName(argtys[i]));
      end;
  end;
end;

function CallTargetSig(d: LongInt): LongInt;
{ After analysis, the resolved skProc signature a failable-form target invokes, or -1 when the
  target is not a call to a routine. The target is a call node, a bare paramless-routine
  identifier, or a method/field designator (whose proc type AnalyzeCallOf records on the node). }
var
  callee, s: LongInt;
begin
  CallTargetSig := -1;
  if Nodes[d].Kind = nkCall then callee := Nodes[d].A else callee := d;
  if Nodes[callee].Kind = nkIdent then begin
    s := Nodes[callee].Sym;
    if (s >= 0) and (Syms[s].Kind in [syProc, syFunc]) then CallTargetSig := Syms[s].TypeId;
  end
  else if (Nodes[callee].Ty >= 0) and (Nodes[callee].Ty < SemCount) and
          (SemTypes[Nodes[callee].Ty].Kind = skProc) then
    CallTargetSig := Nodes[callee].Ty;
end;

function AnalyzeFailForm(node: LongInt): LongInt;
{ Analyze a failable call-site form (nkFailsTest / nkOrElse / nkOrDivert) and return its type:
  boolean for the `fails` test, the call's value type for `or else EXPR` and the diverts, and
  tyVoid for `or else ignore`. The target must resolve to a call to a `fails` routine. }
var
  target, sig, vt, fb, binder, saved: LongInt;
  empty: TIntArray;
begin
  AnalyzeFailForm := tyErr;
  target := Nodes[node].A;
  { analyze the target as a call, flagging it so the must-consume check in AnalyzeCall accepts
    it (its own arguments, analyzed within, are still checked against the flag) }
  saved := FailTargetNode;
  FailTargetNode := target;
  if Nodes[target].Kind = nkCall then vt := AnalyzeCall(target)
  else begin
    SetLength(empty, 0);
    vt := AnalyzeCallOf(target, empty, target);
  end;
  FailTargetNode := saved;
  sig := CallTargetSig(target);
  if (sig < 0) or not SemTypes[sig].Failable then
    SemErr(node, 'the left of a failable form must be a call to a routine marked ''fails''');
  case Nodes[node].Kind of
    nkFailsTest: begin
      { an optional binder introduces a fresh error variable, scoped like a for-loop counter.
        AddSym (not Declare) so repeating a binder name in a sibling statement is not a dup, and
        the binder always lives in a local slot (BinderVar), even at program scope. }
      if Nodes[node].Text <> '' then begin
        binder := AddSym(Nodes[node].Text, syVar);
        Syms[binder].TypeId := tyErrorVal;
        Syms[binder].BinderVar := True;
        Syms[binder].Node := node;
        Nodes[node].Sym := binder;
      end;
      AnalyzeFailForm := tyBool;
    end;
    nkOrElse:
      if Nodes[node].Flag = 1 then
        AnalyzeFailForm := tyVoid        { or else ignore: the value and error are discarded }
      else begin
        fb := AnalyzeExpr(Nodes[node].B);
        if vt = tyVoid then
          SemErr(node, '''or else'' needs a value, but the call is a procedure')
        else if not AssignCompatible(vt, fb) then
          SemErr(node, 'the ''or else'' fallback does not match the call result type');
        AnalyzeFailForm := vt;
      end;
    nkOrDivert: begin
      case Nodes[node].Flag of
        1, 2: if LoopDepth = 0 then
                SemErr(node, '''or break'' or ''or continue'' outside of a loop');
        3: if not CurFailable then
             SemErr(node, '''or fail'' is only valid inside a routine marked ''fails''');
      end;
      AnalyzeFailForm := vt;   { the value flows out on success; on failure the form diverts }
    end;
  end;
end;

function AnalyzeSet(node: LongInt): LongInt;
var
  sty, base, et, i: LongInt;
begin
  sty := NewSemType(skSet);
  base := tyErr;
  for i := 0 to High(Nodes[node].Kids) do begin
    et := AnalyzeExpr(Nodes[Nodes[node].Kids[i]].A);
    if Nodes[Nodes[node].Kids[i]].B >= 0 then AnalyzeExpr(Nodes[Nodes[node].Kids[i]].B);
    if base = tyErr then base := et;
  end;
  SemTypes[sty].Base := base;
  AnalyzeSet := sty;
end;

function AutoCall(t: LongInt): LongInt;
{ A zero-parameter function used as a value is a call, yielding its result. }
begin
  if (t >= 0) and (SemTypes[t].Kind = skProc) and (SemTypes[t].RetType >= 0)
     and (Length(SemTypes[t].ParamTypes) = 0) then
    AutoCall := SemTypes[t].RetType
  else AutoCall := t;
end;

{ Small synthesized-node builders used to desugar for-in into existing forms. }
function MkIdent(const nm: string): LongInt;
begin
  MkIdent := NewNode(nkIdent); Nodes[MkIdent].Text := nm;
end;

function MkIntLit(v: Int64): LongInt;
begin
  MkIntLit := NewNode(nkIntLit); Nodes[MkIntLit].IntVal := v;
end;

function MkCall1(const fn: string; arg: LongInt): LongInt;
begin
  MkCall1 := NewNode(nkCall); Nodes[MkCall1].A := MkIdent(fn); AddKid(MkCall1, arg);
end;

function MkIndex(base, idx: LongInt): LongInt;
begin
  MkIndex := NewNode(nkIndex); Nodes[MkIndex].A := base; AddKid(MkIndex, idx);
end;

function MkAssign(lhs, rhs: LongInt): LongInt;
begin
  MkAssign := NewNode(nkAssign); Nodes[MkAssign].A := lhs; Nodes[MkAssign].B := rhs;
end;

function MkCompound2(a, b: LongInt): LongInt;
begin
  MkCompound2 := NewNode(nkCompound); AddKid(MkCompound2, a); AddKid(MkCompound2, b);
end;

function MkCall3(const fn: string; a1, a2, a3: LongInt): LongInt;
begin
  MkCall3 := NewNode(nkCall); Nodes[MkCall3].A := MkIdent(fn);
  AddKid(MkCall3, a1); AddKid(MkCall3, a2); AddKid(MkCall3, a3);
end;

function MkWhile(cond, body: LongInt): LongInt;
begin
  MkWhile := NewNode(nkWhile); Nodes[MkWhile].A := cond; Nodes[MkWhile].B := body;
end;

function MkBinary(op: TTokenKind; a, b: LongInt): LongInt;
begin
  MkBinary := NewNode(nkBinary); Nodes[MkBinary].Op := op;
  Nodes[MkBinary].A := a; Nodes[MkBinary].B := b;
end;

function MkIf(cond, thenS: LongInt): LongInt;
begin
  MkIf := NewNode(nkIf); Nodes[MkIf].A := cond; Nodes[MkIf].B := thenS;
  Nodes[MkIf].C := -1;
end;

function MkField(base: LongInt; const nm: string): LongInt;
begin
  MkField := NewNode(nkField); Nodes[MkField].A := base; Nodes[MkField].Text := nm;
end;

function MkHiddenBinder(const nm: string; ty: LongInt): LongInt;
{ A fresh slot-resident variable with no source declaration, to receive an
  ignored for-in binder ('_') or the map iterator. Returns a use of it. }
var
  s: LongInt;
begin
  s := AddSym(nm, syVar);
  Syms[s].TypeId := ty;
  Syms[s].BinderVar := True;
  MkHiddenBinder := MkIdent(nm);
end;

procedure AnalyzeForIn(node: LongInt);
{ `for x in e do` / `for k, v in m do`. Each backing desugars into existing
  statements (stored in node.D) which carry all the type checks and lowering:
  an array or string iterates a synthesized counted loop whose body binds the
  element, so the binder assignment is an ordinary (ARC-correct) assignment.
  Binders are pre-declared variables, as the counted loop's variable is; '_'
  ignores a binder. (doc/languages/kobold/kp-foreach.md) }
var
  bt, idxSym, syn, elemNode, assignNode, bodyC, sub: LongInt;
  keySym, valSym, itSym, keyNode, valNode, msig: LongInt;
  idxName, itName: string;
  lo, hi: Int64;
  two, isStr: Boolean;
begin
  { synth nodes built below take their source line from Tok (dormant in this
    phase), so point it at the for-in so any binder/element error reads right. }
  Tok.Line := Nodes[node].Line;
  Tok.Col := Nodes[node].Col;
  Nodes[node].IntVal := -1;   { no hidden index var unless a backing adds one }
  two := Nodes[node].B >= 0;   { a second binder was given: `for k, v in m` }
  bt := AnalyzeExpr(Nodes[node].A);
  if not (Nodes[Nodes[node].A].Kind in [nkIdent, nkField, nkIndex]) then begin
    SemErr(node, 'the source of a for-in loop must be a variable');
    Inc(LoopDepth); AnalyzeStmt(Nodes[node].C); Dec(LoopDepth);
    Exit;
  end;
  if (bt < 0) or (bt >= SemCount) then begin
    Inc(LoopDepth); AnalyzeStmt(Nodes[node].C); Dec(LoopDepth); Exit;
  end;
  case SemTypes[bt].Kind of
    skArray, skString: begin
      isStr := SemTypes[bt].Kind = skString;
      if two then begin
        SemErr(node, 'iterating a ' + TypeName(bt) + ' binds one variable, not two');
        Inc(LoopDepth); AnalyzeStmt(Nodes[node].C); Dec(LoopDepth); Exit;
      end;
      if (not isStr) and (Length(SemTypes[bt].Subs) > 1) then begin
        SemErr(node, 'for-in cannot iterate a multi-dimensional array');
        Inc(LoopDepth); AnalyzeStmt(Nodes[node].C); Dec(LoopDepth); Exit;
      end;
      { desugar to a counted loop over the index range, binding the element in
        the body. A string iterates its bytes (1..length), a dynamic array its
        0..high, a fixed array its declared index subrange. }
      idxName := '__for_i_' + IntToStr(node);
      idxSym := AddSym(idxName, syVar);
      Syms[idxSym].TypeId := tyInt;
      Syms[idxSym].BinderVar := True;   { lives in a local slot, even at program scope }
      elemNode := MkIndex(Nodes[node].A, MkIdent(idxName));
      if Nodes[node].Text <> '_' then
        assignNode := MkAssign(MkIdent(Nodes[node].Text), elemNode)
      else assignNode := -1;
      if assignNode >= 0 then bodyC := MkCompound2(assignNode, Nodes[node].C)
      else bodyC := Nodes[node].C;
      syn := NewNode(nkFor);
      Nodes[syn].Text := idxName;
      Nodes[syn].Flag := 0;
      if isStr then begin
        Nodes[syn].A := MkIntLit(1);
        Nodes[syn].B := MkCall1('length', Nodes[node].A);
      end
      else if IsDynArray(bt) then begin
        Nodes[syn].A := MkIntLit(0);
        Nodes[syn].B := MkCall1('high', Nodes[node].A);
      end
      else begin
        sub := SemTypes[bt].Subs[0];
        Nodes[syn].A := MkIntLit(SemTypes[sub].Lo);
        Nodes[syn].B := MkIntLit(SemTypes[sub].Hi);
      end;
      Nodes[syn].C := bodyC;
      Nodes[node].D := syn;
      Nodes[node].IntVal := idxSym;
      AnalyzeStmt(syn);
    end;
    skMap: begin
      { for k, v in m  ->  it := MapFirst(m); while MapNext(it, k, v) do body.
        A map binds the key (the map's key type: a string or an ordinal) and optionally the
        value; a second binder is the value. An omitted or '_' binder gets a hidden throwaway so
        MapNext always has both out slots. }
      keySym := -1; valSym := -1;
      if Nodes[node].Text = '_' then
        keyNode := MkHiddenBinder('__for_k_' + IntToStr(node), MapKeyType(bt))
      else begin
        keySym := Lookup(Nodes[node].Text);
        keyNode := MkIdent(Nodes[node].Text);
      end;
      if Nodes[node].B < 0 then
        valNode := MkHiddenBinder('__for_v_' + IntToStr(node), SemTypes[bt].Base)
      else if Nodes[Nodes[node].B].Text = '_' then
        valNode := MkHiddenBinder('__for_v_' + IntToStr(node), SemTypes[bt].Base)
      else begin
        valSym := Lookup(Nodes[Nodes[node].B].Text);
        valNode := MkIdent(Nodes[Nodes[node].B].Text);
      end;
      { clearer errors than MapNext's, naming the binder the user wrote }
      if (keySym >= 0) and not AssignCompatible(MapKeyType(bt), Syms[keySym].TypeId) then
        SemErr(node, 'a map key binder must be a ' + TypeName(MapKeyType(bt)) + ': ''' +
          Nodes[node].Text + '''');
      if (valSym >= 0) and (Syms[valSym].TypeId <> SemTypes[bt].Base) then
        SemErr(node, 'the value binder must be the map value type (' +
          TypeName(SemTypes[bt].Base) + ')');
      itName := '__for_it_' + IntToStr(node);
      itSym := AddSym(itName, syVar);
      Syms[itSym].TypeId := tyMapIter;
      Syms[itSym].BinderVar := True;
      syn := MkCompound2(
        MkAssign(MkIdent(itName), MkCall1('mapfirst', Nodes[node].A)),
        MkWhile(MkCall3('mapnext', MkIdent(itName), keyNode, valNode), Nodes[node].C));
      Nodes[node].D := syn;
      AnalyzeStmt(syn);
    end;
    skSet: begin
      { for x in s  ->  for x := lo to hi do if x in s then body, walking the
        element type's ordinal range and keeping the members. The loop variable
        is the binder itself (the element type), so no separate binding is
        needed. Cost is the universe size, not the member count. }
      if two then begin
        SemErr(node, 'iterating a set binds one variable, not two');
        Inc(LoopDepth); AnalyzeStmt(Nodes[node].C); Dec(LoopDepth); Exit;
      end;
      if not OrdinalRange(SemTypes[bt].Base, lo, hi) then begin
        SemErr(node, 'cannot iterate a ' + TypeName(bt));
        Inc(LoopDepth); AnalyzeStmt(Nodes[node].C); Dec(LoopDepth); Exit;
      end;
      if Nodes[node].Text = '_' then begin
        idxName := '__for_e_' + IntToStr(node);
        idxSym := AddSym(idxName, syVar);
        Syms[idxSym].TypeId := SemTypes[bt].Base;
        Syms[idxSym].BinderVar := True;
      end
      else idxName := Nodes[node].Text;
      syn := NewNode(nkFor);
      Nodes[syn].Text := idxName;
      Nodes[syn].Flag := 0;
      Nodes[syn].A := MkIntLit(lo);
      Nodes[syn].B := MkIntLit(hi);
      Nodes[syn].C := MkIf(MkBinary(tkIn, MkIdent(idxName), Nodes[node].A), Nodes[node].C);
      Nodes[node].D := syn;
      AnalyzeStmt(syn);
    end;
  else
    { a custom cursor: a type with a `function Next for (c): E fails` method,
      failure signalling the end. for x in c -> while true do begin
      x := c.Next or break; body end. The by-reference receiver advances the
      cursor in place, so the source variable is consumed. }
    msig := FindMethod(bt, 'Next');
    if (msig >= 0) and SemTypes[msig].Failable and
       (SemTypes[msig].RetType >= 0) and (SemTypes[msig].RetType <> tyVoid) then begin
      if two then begin
        SemErr(node, 'iterating a cursor binds one variable, not two');
        Inc(LoopDepth); AnalyzeStmt(Nodes[node].C); Dec(LoopDepth); Exit;
      end;
      if Nodes[node].Text = '_' then
        elemNode := MkHiddenBinder('__for_e_' + IntToStr(node), SemTypes[msig].RetType)
      else elemNode := MkIdent(Nodes[node].Text);
      assignNode := NewNode(nkOrDivert);   { c.Next or break }
      Nodes[assignNode].A := MkField(Nodes[node].A, 'Next');
      Nodes[assignNode].Flag := 1;
      syn := MkWhile(MkIdent('true'),
        MkCompound2(MkAssign(elemNode, assignNode), Nodes[node].C));
      Nodes[node].D := syn;
      AnalyzeStmt(syn);
    end
    else begin
      SemErr(node, 'cannot iterate over a value of type ' + TypeName(bt) +
        ' (a sequence, set, map, or a type with a ''Next ... fails'' method)');
      Inc(LoopDepth); AnalyzeStmt(Nodes[node].C); Dec(LoopDepth);
    end;
  end;
end;

function CheckInterpHole(node: LongInt): LongInt;
{ The interpolation hole (nkToStr): the value is rendered to a string the way
  write renders it. Allowed: string, char, any integer width (incl int64), and the
  ordinals (bool, enum) that render as their number. A real needs a string-producing
  formatter the runtime does not expose yet, so it is rejected for now. }
var
  t: LongInt;
begin
  t := AnalyzeExpr(Nodes[node].A);
  if IsRealType(t) then
    SemErr(node, 'interpolating a real is not supported yet; format it with str or write')
  else if (t <> tyStr) and (t <> tyChar) and (not IsInt64(t)) and (not IsOrdinalType(t)) then
    SemErr(node, 'cannot interpolate a value of this type into a string');
  CheckInterpHole := tyStr;
end;

function AnalyzeExpr(node: LongInt): LongInt;
var
  s, at, savedAnswer: LongInt;
begin
  AnalyzeExpr := tyErr;
  if node < 0 then Exit;
  case Nodes[node].Kind of
    nkIntLit:
      { a literal that does not fit a signed 32-bit integer is an Int64 }
      if (Nodes[node].IntVal < -2147483648) or (Nodes[node].IntVal > 2147483647) then
        AnalyzeExpr := tyInt64
      else AnalyzeExpr := tyInt;
    nkRealLit: AnalyzeExpr := tyReal;
    nkStrLit:  AnalyzeExpr := tyStr;
    nkToStr:   AnalyzeExpr := CheckInterpHole(node);
    nkNil:     AnalyzeExpr := tyNil;
    nkLabelAddr: begin
      { `@name` is a label value; register the mention against the current
        routine (an undefined label is caught at routine exit). The type is
        `label`; the IR label id is assigned in lowering. }
      LabelIntern(Nodes[node].Text, node);
      AnalyzeExpr := tyLabel;
    end;
    nkIdent: begin
      s := Lookup(Nodes[node].Text);
      Nodes[node].Sym := s;
      if s < 0 then
        SemErrName(node, 'undeclared identifier ''' + Nodes[node].Text + '''' +
          SuggestName(Nodes[node].Text))
      else case Syms[s].Kind of
        syVar, syParam: begin
          MarkCapture(s);
          Syms[s].Read := True;   { an rvalue use: the value is read here }
          AnalyzeExpr := Syms[s].TypeId;
        end;
        syConst, syEnumLit: AnalyzeExpr := Syms[s].TypeId;
        syFunc:
          { inside its own body a bare function name is the result variable, whatever its
            parameters (write F(args) to recurse); otherwise a paramless function is called
            and one with parameters used bare is a procedural value being taken }
          if s = CurFuncSym then
            AnalyzeExpr := SemTypes[Syms[s].TypeId].RetType
          else if Length(SemTypes[Syms[s].TypeId].ParamTypes) = 0 then begin
            { a bare paramless function is auto-called here; if it is failable, that call is
              unhandled (a fail-form analyzes its target through AnalyzeCallOf, not this path) }
            if SemTypes[Syms[s].TypeId].Failable then
              SemErr(node, 'unhandled failable call; use ''fails'', ''or else'', or a divert');
            AnalyzeExpr := SemTypes[Syms[s].TypeId].RetType;
          end
          else begin
            CheckRoutineValue(node, s);
            AnalyzeExpr := Syms[s].TypeId;
          end;
        syProc: begin
          CheckRoutineValue(node, s);
          AnalyzeExpr := Syms[s].TypeId;
        end;
        syType: SemErr(node, '''' + Nodes[node].Text + ''' is a type, not a value');
      end;
    end;
    nkUnary: begin
      at := AnalyzeExpr(Nodes[node].A);
      if at = tyErr then Exit;
      case Nodes[node].Op of
        tkMinus, tkPlus:
          if IsNumeric(at) then AnalyzeExpr := at
          else SemErr(node, 'operand of unary ' + OpSym(Nodes[node].Op) +
            ' must be numeric');
        tkNot:
          if (at = tyBool) or IsIntClass(at) then AnalyzeExpr := at
          else SemErr(node, 'operand of not must be boolean or integer');
      end;
    end;
    nkBinary: AnalyzeExpr := AnalyzeBinary(node);
    nkField:  AnalyzeExpr := AutoCall(AnalyzeField(node));
    nkIndex:  AnalyzeExpr := AnalyzeIndex(node);
    nkCall:   AnalyzeExpr := AnalyzeCall(node);
    nkFailsTest, nkOrElse, nkOrDivert: AnalyzeExpr := AnalyzeFailForm(node);
    nkSetConstructor: AnalyzeExpr := AnalyzeSet(node);
    nkStart: begin
      { each start is a fresh answer-type boundary }
      savedAnswer := AnswerType;
      AnswerType := -1;
      Inc(StartDepth);
      if Nodes[node].Flag = 1 then AnalyzeStmt(Nodes[node].A)
      else begin
        at := AnalyzeExpr(Nodes[node].A);
        { when the body completes, its own result is delivered as the answer }
        if (at >= 0) and (at <> tyVoid) and (at <> tyErr) and (at <> tyNil) and
           (at <> tyProcess) then
          if AnswerType < 0 then AnswerType := at;
      end;
      Dec(StartDepth);
      AnswerType := savedAnswer;
      AnalyzeExpr := tyProcess;
    end;
    nkYield: begin
      if (CurRoutineSym < 0) and (StartDepth = 0) then
        SemErr(node, 'yield is not allowed in the main program body')
      else if Nodes[node].A >= 0 then begin
        at := AnalyzeExpr(Nodes[node].A);
        if at <> tyErr then
          if AnswerType < 0 then AnswerType := at
          else if not AssignCompatible(AnswerType, at) then
            SemErr(node, 'yield type ' + TypeName(at) +
              ' does not match the start answer type ' + TypeName(AnswerType));
      end;
    end;
    nkBind: begin
      if (CurRoutineSym < 0) and (StartDepth = 0) then
        SemErr(node, 'bind is not allowed in the main program body');
      OpenScope;
      s := Declare(Nodes[node].Text, syVar, node);
      Syms[s].TypeId := tyProcess;
      Nodes[node].Sym := s;   { the bound process variable, for lowering }
      at := AnalyzeExpr(Nodes[node].A);
      CloseScope;
      if ((CurRoutineSym >= 0) or (StartDepth > 0)) and (at <> tyErr) then
        if AnswerType < 0 then AnswerType := at
        else if not AssignCompatible(AnswerType, at) then
          SemErr(node, 'bind type ' + TypeName(at) +
            ' does not match the start answer type ' + TypeName(AnswerType));
    end;
  end;
  Nodes[node].Ty := AnalyzeExpr;   { record the result type for lowering }
end;

{ ---- statement checks ---- }

procedure CheckBool(node, ty: LongInt; const what: string);
begin
  if (ty <> tyErr) and (ty <> tyBool) then
    SemErr(node, what + ' must be boolean');
end;

function AnalyzeLValue(node: LongInt): LongInt;
var
  s: LongInt;
begin
  if Nodes[node].Kind = nkIdent then begin
    s := Lookup(Nodes[node].Text);
    Nodes[node].Sym := s;
    if s < 0 then begin
      SemErrName(node, 'undeclared identifier ''' + Nodes[node].Text + '''' +
        SuggestName(Nodes[node].Text));
      AnalyzeLValue := tyErr;
    end
    else case Syms[s].Kind of
      syVar, syParam: begin
        if IsPropertySym(s) and (Nodes[Syms[s].Node].C < 0) then
          SemErr(node, 'cannot assign to read-only property ''' + Nodes[node].Text +
            ''' (it has no ''write'' accessor)');
        MarkCapture(s);
        Nodes[node].Ty := Syms[s].TypeId;
        AnalyzeLValue := Syms[s].TypeId;
      end;
      syFunc:
        if s = CurFuncSym then AnalyzeLValue := SemTypes[Syms[s].TypeId].RetType
        else begin
          SemErr(node, 'cannot assign to function ''' + Nodes[node].Text + '''');
          AnalyzeLValue := tyErr;
        end;
      syConst, syEnumLit: begin
        SemErr(node, 'cannot assign to constant ''' + Nodes[node].Text + '''');
        AnalyzeLValue := tyErr;
      end;
    else
      SemErr(node, 'cannot assign to ''' + Nodes[node].Text + '''');
      AnalyzeLValue := tyErr;
    end;
  end
  else
    AnalyzeLValue := AnalyzeExpr(node);   { field / index target }
end;

function AssignCompatible(dst, src: LongInt): Boolean;
var
  i: LongInt;
begin
  AssignCompatible := True;
  if (dst = tyErr) or (src = tyErr) then Exit;
  if dst = src then Exit;
  if SemTypes[src].Kind = skNil then begin
    AssignCompatible := (SemTypes[dst].Kind in
      [skInterface, skString, skProcess, skProc]) or IsDynArray(dst);
    Exit;
  end;
  { two dynamic arrays share a value (a handle) when their element types match; this is what
    lets a dynamic array pass to an `array of T` open parameter, and lets a value `array of T`
    and a `ref array of T` interoperate (the copy-vs-share choice is keyed on the destination
    type at the assignment). A `buffer of T` is host-backed, so it interoperates only with a
    buffer: array-ness and buffer-ness must not silently alias across the ownership boundary. }
  if IsDynArray(dst) and IsDynArray(src) and
     (SemTypes[dst].Base = SemTypes[src].Base) and
     (IsBuffer(dst) = IsBuffer(src)) then Exit;
  { two maps share a value (a handle) when their key types and value types match, the same
    structural rule dynamic arrays get above. A map has no host-backed variant, so the key type
    and the value type (Base) are the only things that distinguish two map types. The key types
    must agree: a string-keyed map and an ordinal-keyed `map[K] of T` are different runtime
    objects (KP_OBJ_MAP vs KP_OBJ_IMAP) whose operations dispatch differently. This is what lets
    a map pass to a matching `map ... of T` parameter and lets an `or else` fallback recover a map
    result, the fallback and the call result being separate declaration occurrences. }
  if IsMap(dst) and IsMap(src) and (SemTypes[dst].Base = SemTypes[src].Base) and
     (MapKeyType(dst) = MapKeyType(src)) then Exit;
  { the empty constructor `[]` (a set with no element type) also denotes an empty array }
  if IsDynArray(dst) and IsSet(src) and (SemTypes[src].Base = tyErr) then Exit;
  if (SemTypes[dst].Kind = skReal) and IsIntClass(src) then Exit;
  { real and single are freely assignable to each other; the store widens or narrows }
  if (SemTypes[dst].Kind = skReal) and (SemTypes[src].Kind = skReal) then Exit;
  if IsIntClass(dst) and IsIntClass(src) then Exit;
  if SemTypes[dst].Kind = skSubrange then begin
    AssignCompatible := AssignCompatible(SemTypes[dst].Base, src); Exit;
  end;
  if SemTypes[src].Kind = skSubrange then begin
    AssignCompatible := AssignCompatible(dst, SemTypes[src].Base); Exit;
  end;
  if IsSet(dst) and IsSet(src) then Exit;
  if (SemTypes[dst].Kind = skProc) and (SemTypes[src].Kind = skProc) then begin
    { procedural values: assignable when the signatures match }
    AssignCompatible := False;
    if SemTypes[dst].RetType <> SemTypes[src].RetType then Exit;
    if Length(SemTypes[dst].ParamTypes) <> Length(SemTypes[src].ParamTypes) then Exit;
    for i := 0 to High(SemTypes[dst].ParamTypes) do
      if SemTypes[dst].ParamTypes[i] <> SemTypes[src].ParamTypes[i] then Exit;
    AssignCompatible := True;
    Exit;
  end;
  AssignCompatible := False;
end;

function IsNarrowing(dst, src: LongInt): Boolean;
{ true when an assignment that AssignCompatible already allows silently truncates a value: a
  64-bit integer stored into a 32-bit integer. Both are exact integer types, so dropping the
  high half usually hides a bug. Widening (integer into int64) and same-width assignments keep
  the value and are not flagged. An explicit integer(...) conversion silences the warning, since
  its result already has the narrower type. Storing a double into a single is deliberately not
  flagged: the single type is defined to narrow on store (computation stays in f64), so a
  narrowing there is the type working as designed, not a mistake. }
begin
  IsNarrowing := False;
  if (dst < 0) or (src < 0) or (dst >= SemCount) or (src >= SemCount) then Exit;
  if IsInt64(src) and IsIntClass(dst) and not IsInt64(dst) then IsNarrowing := True;
end;

procedure AnalyzeAssign(node: LongInt);
var
  tt, vt, lhs, bt, m: LongInt;
begin
  tt := AnalyzeLValue(Nodes[node].A);
  vt := AnalyzeExpr(Nodes[node].B);
  { a read-only computed record field (a `read` accessor and no `write`) rejects assignment }
  lhs := Nodes[node].A;
  if Nodes[lhs].Kind = nkField then begin
    bt := Nodes[Nodes[lhs].A].Ty;
    if (bt >= 0) and (bt < SemCount) and (SemTypes[bt].Kind = skRecord) then begin
      m := FindMember(bt, Nodes[lhs].Text);
      if (m >= 0) and (SemTypes[bt].PropGet[m] <> '') and (SemTypes[bt].PropSet[m] = '') then
        SemErr(node, 'cannot assign to read-only computed field ''' + Nodes[lhs].Text +
          ''' (it has no ''write'' accessor)');
    end;
  end;
  { A string is immutable: reject element assignment s[i] := c. The character read s[i]
    stays legal; only writing an element is banned. }
  lhs := Nodes[node].A;
  if Nodes[lhs].Kind = nkIndex then begin
    bt := Nodes[Nodes[lhs].A].Ty;
    if (bt >= 0) and (bt < SemCount) and (SemTypes[bt].Kind = skString) then
      SemErr(node, 'a string is immutable; cannot assign to a character element ' +
        '(build a new string with concatenation or Copy)');
  end;
  { a one-character string literal assigned to a char is that char }
  CoerceCharLit(Nodes[node].B, tt);
  if Nodes[Nodes[node].B].Ty = tyChar then vt := tyChar;
  if (tt <> tyErr) and (vt <> tyErr) and not AssignCompatible(tt, vt) then
    SemErr(node, 'cannot assign ' + TypeName(vt) + ' to ' + TypeName(tt))
  else if IsNarrowing(tt, vt) then
    SemWarn(node, 'W0005', 'narrowing conversion from ' + TypeName(vt) + ' to ' + TypeName(tt) +
      ' may lose data; use an explicit ' + TypeName(tt) + '(...) conversion to silence this');
end;

procedure AnalyzeWith(node: LongInt);
var
  i, dt, opened, m, fs: LongInt;
begin
  opened := 0;
  for i := 0 to High(Nodes[node].Kids) do begin
    dt := AnalyzeExpr(Nodes[node].Kids[i]);
    if (dt >= 0) and (SemTypes[dt].Kind = skRecord) then begin
      OpenScope;
      Inc(opened);
      for m := 0 to High(SemTypes[dt].Names) do begin
        fs := Declare(SemTypes[dt].Names[m], syVar, node);
        Syms[fs].TypeId := SemTypes[dt].Subs[m];
        Syms[fs].WithBase := Nodes[node].Kids[i];   { alias for base.field, for lowering }
      end;
    end;
  end;
  AnalyzeStmt(Nodes[node].A);
  while opened > 0 do begin CloseScope; Dec(opened); end;
end;

procedure AnalyzeCase(node: LongInt);
{ The selector's type drives the labels. A case selector is an ordinal type (integer, char,
  boolean, or enumeration) or a string. A string selector carries string labels matched by
  value; an ordinal selector carries ordinal labels. Labels follow the selector: a
  one-character string literal is a char only when the selector is a char, and every ordinal
  label must share the selector's type. There is no coercion of the selector itself, so a char
  case cannot carry string labels and vice versa, and a string case cannot carry a label range
  (the labels are discrete strings). }
var
  i, j, k, ll, lab, st: LongInt;
  strSel: Boolean;

  procedure CheckLabel(lb: LongInt);
  { Validate one label endpoint against the selector type st. For an ordinal selector a
    one-character string literal is coerced to char when st is a char so it is matched by its
    character code; for a string selector the label must itself be a string constant. }
  var
    cv: TConstVal;
    lty: LongInt;
  begin
    CoerceCharLit(lb, st);
    cv := EvalConst(lb);
    if not cv.Ok then begin SemErr(lb, 'case label is not constant'); Exit; end;
    if strSel then begin
      if not cv.IsStr then SemErr(lb, 'a string case label is required');
      Exit;
    end;
    if cv.IsStr then begin
      if Length(cv.S) = 1 then lty := tyChar else lty := tyStr;
    end
    else lty := cv.Ty;
    if (st <> tyErr) and IsOrdinalType(st) and not Comparable(st, lty) then
      SemErr(lb, 'case label type does not match the selector');
  end;

begin
  st := AnalyzeExpr(Nodes[node].A);
  strSel := (st >= 0) and (st < SemCount) and (SemTypes[st].Kind = skString);
  if (st <> tyErr) and not IsOrdinalType(st) and not strSel then
    SemErr(Nodes[node].A, 'case selector must be an ordinal type (integer, char, boolean, ' +
      'or enumeration) or a string');
  for i := 0 to High(Nodes[node].Kids) do begin
    k := Nodes[node].Kids[i];
    if Nodes[k].Kind = nkCaseElement then begin
      ll := Nodes[k].A;
      for j := 0 to High(Nodes[ll].Kids) do begin
        lab := Nodes[ll].Kids[j];
        CheckLabel(Nodes[lab].A);
        if Nodes[lab].B >= 0 then begin
          if strSel then
            SemErr(Nodes[lab].B, 'a string case label cannot be a range')
          else
            CheckLabel(Nodes[lab].B);
        end;
      end;
      AnalyzeStmt(Nodes[k].B);
    end
    else
      AnalyzeStmt(k);   { the else compound }
  end;
end;

procedure CheckDeferBody(node, errNode: LongInt);
{ A deferred statement runs during scope-exit teardown, so it must not itself
  transfer control out of its block. Reject exit/fail/break/continue/yield, a
  computed goto, a failable divert, and a nested defer (doc .../kp-defer.md). }
var
  i, callee: LongInt;
begin
  if node < 0 then Exit;
  case Nodes[node].Kind of
    nkBreak:    SemErr(errNode, 'break is not allowed inside a defer');
    nkContinue: SemErr(errNode, 'continue is not allowed inside a defer');
    nkYield:    SemErr(errNode, 'yield is not allowed inside a defer');
    nkGoto:     SemErr(errNode, 'goto is not allowed inside a defer');
    nkDefer:    SemErr(errNode, 'a defer may not be nested inside a defer');
    nkOrDivert: SemErr(errNode,
      'a failable divert (or exit/break/continue/fail) is not allowed inside a defer');
    nkCall, nkCallStmt: begin
      if Nodes[node].Kind = nkCallStmt then callee := Nodes[node].A else callee := node;
      if (callee >= 0) and (Nodes[callee].Kind = nkCall) then callee := Nodes[callee].A;
      if (callee >= 0) and (Nodes[callee].Kind = nkIdent) and
         (SameTextCI(Nodes[callee].Text, 'exit') or SameTextCI(Nodes[callee].Text, 'fail')) then
        SemErr(errNode, 'exit/fail is not allowed inside a defer');
    end;
  end;
  CheckDeferBody(Nodes[node].A, errNode);
  CheckDeferBody(Nodes[node].B, errNode);
  CheckDeferBody(Nodes[node].C, errNode);
  CheckDeferBody(Nodes[node].D, errNode);
  for i := 0 to High(Nodes[node].Kids) do
    CheckDeferBody(Nodes[node].Kids[i], errNode);
end;

procedure AnalyzeStmt(node: LongInt);
var
  i, s, ct, d: LongInt;
  noArgs: TIntArray;
begin
  if node < 0 then Exit;
  case Nodes[node].Kind of
    nkCompound:
      for i := 0 to High(Nodes[node].Kids) do AnalyzeStmt(Nodes[node].Kids[i]);
    nkEmpty: ;
    nkAssign: AnalyzeAssign(node);
    nkCallStmt: begin
      { a bare designator statement is a zero-argument call, not a value }
      d := Nodes[node].A;
      if Nodes[d].Kind = nkCall then AnalyzeExpr(d)
      else begin
        SetLength(noArgs, 0);
        AnalyzeCallOf(d, noArgs, d);
      end;
      { a statement-position `fail(code)` returns failure from the enclosing routine, so it is
        only legal inside a failable one (doc/languages/kobold/kp-errors.md) }
      if Nodes[d].Kind = nkCall then begin
        s := Nodes[Nodes[d].A].Sym;
        if (s >= 0) and (Syms[s].Node < 0) and (Syms[s].LowerName = 'fail')
           and not CurFailable then
          SemErr(node, '''fail'' as a statement is only valid inside a routine marked ''fails''');
      end;
    end;
    nkFailsTest, nkOrElse, nkOrDivert: AnalyzeFailForm(node);
    nkIf:
      { a `fails e` binder in the condition is scoped to the then-branch, like a for-counter to
        its body: the binder lives in a fresh scope so a sibling `fails e` (or an outer variable
        of the same name) does not resolve to it. FindLocal returns the first symbol by position,
        so an unscoped binder added after a same-named one would never be found again. }
      if (Nodes[Nodes[node].A].Kind = nkFailsTest) and (Nodes[Nodes[node].A].Text <> '') then begin
        OpenScope;
        ct := AnalyzeExpr(Nodes[node].A); CheckBool(node, ct, 'if condition');
        AnalyzeStmt(Nodes[node].B);
        CloseScope;
        AnalyzeStmt(Nodes[node].C);
      end
      else begin
        ct := AnalyzeExpr(Nodes[node].A); CheckBool(node, ct, 'if condition');
        AnalyzeStmt(Nodes[node].B);
        AnalyzeStmt(Nodes[node].C);
      end;
    nkWhile:
      { the `fails e` binder is scoped to the loop body for the same reason as the if-branch }
      if (Nodes[Nodes[node].A].Kind = nkFailsTest) and (Nodes[Nodes[node].A].Text <> '') then begin
        OpenScope;
        ct := AnalyzeExpr(Nodes[node].A); CheckBool(node, ct, 'while condition');
        Inc(LoopDepth); AnalyzeStmt(Nodes[node].B); Dec(LoopDepth);
        CloseScope;
      end
      else begin
        ct := AnalyzeExpr(Nodes[node].A); CheckBool(node, ct, 'while condition');
        Inc(LoopDepth); AnalyzeStmt(Nodes[node].B); Dec(LoopDepth);
      end;
    nkFor: begin
      s := Lookup(Nodes[node].Text);
      Nodes[node].Sym := s;
      if s < 0 then
        SemErrName(node, 'undeclared loop variable ''' + Nodes[node].Text + '''' +
          SuggestName(Nodes[node].Text))
      else if not (Syms[s].Kind in [syVar, syParam]) then
        SemErr(node, 'loop variable ''' + Nodes[node].Text +
          ''' is not a variable')
      else begin
        MarkCapture(s);
        Syms[s].Read := True;   { the loop control reads the counter each iteration for its bound }
      end;
      AnalyzeExpr(Nodes[node].A);
      AnalyzeExpr(Nodes[node].B);
      Inc(LoopDepth); AnalyzeStmt(Nodes[node].C); Dec(LoopDepth);
    end;
    nkForIn: AnalyzeForIn(node);
    nkRepeat: begin
      Inc(LoopDepth);
      for i := 0 to High(Nodes[node].Kids) do AnalyzeStmt(Nodes[node].Kids[i]);
      Dec(LoopDepth);
      ct := AnalyzeExpr(Nodes[node].A); CheckBool(node, ct, 'until condition');
    end;
    nkCase: AnalyzeCase(node);
    nkWith: AnalyzeWith(node);
    nkBreak, nkContinue:
      if LoopDepth = 0 then
        SemErr(node, 'break or continue outside of a loop');
    nkAsm:
      { basic inline asm carries only verbatim text. The extended form carries
        operands: analyze each operand expression and restrict its type to a
        single-register integer-class ordinal (the simple subset). An output or
        inout operand must be an assignable lvalue; a clobber has no expression. }
      for i := 0 to High(Nodes[node].Kids) do begin
        s := Nodes[node].Kids[i];
        if Nodes[s].Flag = 3 then Continue;   { a clobber: a register name only }
        if Nodes[s].Flag >= 1 then
          ct := AnalyzeLValue(Nodes[s].A)      { an output or inout: an lvalue }
        else
          ct := AnalyzeExpr(Nodes[s].A);       { an input }
        if (ct <> tyErr) and not (IsOrdinalType(ct) and not IsInt64(ct)) then
          SemErr(s, 'an asm operand must be an integer-class value (integer, char, ' +
            'boolean, enum, or subrange); ' + TypeName(ct) + ' is not supported');
        { the simple subset allows only the general register constraint: an output
          is "=r", an inout "+r", and an input "r" }
        if ((Nodes[s].Flag = 1) and (Nodes[s].Text <> '=r')) or
           ((Nodes[s].Flag = 2) and (Nodes[s].Text <> '+r')) or
           ((Nodes[s].Flag = 0) and (Nodes[s].Text <> 'r')) then
          SemErr(s, 'only the register constraints ''r'', ''=r'', and ''+r'' are ' +
            'supported; got ''' + Nodes[s].Text + '''');
      end;
    nkDefer: begin
      CheckDeferBody(Nodes[node].A, node);
      AnalyzeStmt(Nodes[node].A);
    end;
    nkLabelStmt: begin
      { a `name:` label definition; register it in the current routine's table,
        rejecting a duplicate, then analyze the statement it marks }
      i := LabelIntern(Nodes[node].Text, node);
      if LabelDefd[i] then
        SemErr(node, 'duplicate label ''' + Nodes[node].Text +
          ''' in this routine')
      else
        LabelDefd[i] := True;
      AnalyzeStmt(Nodes[node].A);
    end;
    nkGoto: begin
      { a computed jump: the operand must be a `label` value. A bare
        `goto name` naming a label is the unstructured goto, which stays
        omitted, so it gets a teaching error pointing at the computed form. }
      d := Nodes[node].A;
      if (Nodes[d].Kind = nkIdent) and (LabelFind(Nodes[d].Text) >= 0) then
        SemErr(node, '''goto'' takes a label value, not a label name: write ' +
          '''goto @' + Nodes[d].Text + ''' for a computed jump, or use ' +
          'break/continue')
      else begin
        ct := AnalyzeExpr(d);
        if (ct >= 0) and (ct <> tyErr) and (SemTypes[ct].Kind <> skLabel) then
          SemErr(node, '''goto'' requires a label value, found ' + TypeName(ct));
      end;
    end;
    nkStart, nkYield, nkBind: AnalyzeExpr(node);
  end;
end;

{ ---- declarations ---- }

procedure CheckConstValue(valNode, ty: LongInt);
{ Validate that valNode is a compile-time constant of type ty, recursively. A record type
  takes a record literal, a fixed array type a parenthesized element list, and a scalar type
  a folding constant expression. A function call never folds, so it is reported as a value
  that is not a constant. }
var
  ev: TConstVal;
begin
  if (ty < 0) or (ty >= SemCount) then begin
    SemErr(valNode, 'a constant of this type is not supported');
    Exit;
  end;
  if SemTypes[ty].Kind = skRecord then begin
    CheckRecordLit(valNode, ty);
    Exit;
  end;
  if (SemTypes[ty].Kind = skArray) and (Length(SemTypes[ty].Subs) > 0) then begin
    if Nodes[valNode].Kind <> nkAggregate then
      SemErr(valNode, 'an array constant needs a parenthesized list of elements')
    else
      CheckConstArray(ty, 0, valNode);
    Exit;
  end;
  ev := EvalConst(valNode);
  if not ev.Ok then begin
    if Nodes[valNode].Kind = nkCall then
      SemErr(valNode, 'a constant value cannot call a function')
    else
      SemErr(valNode, 'a constant value is required');
    Exit;
  end;
  if SemTypes[ty].Kind = skString then begin
    if not ev.IsStr then SemErr(valNode, 'a string constant is required');
  end
  else if IsRealType(ty) then begin
    { real (f64) and single (f32) share this check; a single is narrowed where it is stored }
    if ev.IsStr then SemErr(valNode, 'a real constant is required');
  end
  else if IsInt64(ty) then begin
    if ev.IsStr or ev.IsReal then SemErr(valNode, 'an integer constant is required');
  end
  else if SemTypes[ty].Kind in [skInteger, skBoolean, skChar, skEnum, skSubrange] then begin
    if ev.IsStr or ev.IsReal then SemErr(valNode, 'an ordinal constant is required');
  end
  else
    SemErr(valNode, 'a constant of this type is not supported');
end;

procedure CheckConstArray(arrTy, dim, node: LongInt);
{ Validate one dimension of a fixed-array constant: the element count matches the dimension's
  extent, and each element is either a nested dimension (another parenthesized list) or, at the
  last dimension, a value of the element type. }
var
  sub, extent, i: LongInt;
begin
  sub := SemTypes[arrTy].Subs[dim];
  extent := SemTypes[sub].Hi - SemTypes[sub].Lo + 1;
  if Length(Nodes[node].Kids) <> extent then
    SemErr(node, 'array dimension has ' + IntToStr(Length(Nodes[node].Kids)) +
      ' elements but holds ' + IntToStr(extent));
  for i := 0 to High(Nodes[node].Kids) do
    if dim < High(SemTypes[arrTy].Subs) then begin
      if Nodes[Nodes[node].Kids[i]].Kind <> nkAggregate then
        SemErr(Nodes[node].Kids[i], 'a nested array dimension needs a parenthesized list')
      else
        CheckConstArray(arrTy, dim + 1, Nodes[node].Kids[i]);
    end
    else
      CheckConstValue(Nodes[node].Kids[i], SemTypes[arrTy].Base);
end;

procedure CheckRecordLit(lit, recTy: LongInt);
{ Validate a record literal, (field: value; ...), against its record type: every field is
  named once, in the type's declared order, and each value is a constant assignable to the
  field (recursively, so a field may itself be a record, a fixed array, a string, a real, or
  an ordinal). }
var
  i, m: LongInt;
  fi: LongInt;
begin
  if Nodes[lit].Kind <> nkRecordLit then begin
    SemErr(lit, 'a record constant element must be a record literal (field: value; ...)');
    Exit;
  end;
  if Length(Nodes[lit].Kids) <> Length(SemTypes[recTy].Names) then
    SemErr(lit, 'record literal has ' + IntToStr(Length(Nodes[lit].Kids)) +
      ' fields but the record has ' + IntToStr(Length(SemTypes[recTy].Names)));
  for i := 0 to High(Nodes[lit].Kids) do begin
    fi := Nodes[lit].Kids[i];
    m := FindMember(recTy, Nodes[fi].Text);
    if m < 0 then begin
      SemErr(fi, 'record has no field named ' + Nodes[fi].Text);
      Continue;
    end;
    if m <> i then
      SemErr(fi, 'field ' + Nodes[fi].Text + ' is out of declared order');
    CheckConstValue(Nodes[fi].A, SemTypes[recTy].Subs[m]);
  end;
end;

procedure DeclConst(node: LongInt);
var
  s, arrTy, elemTy, agg, setTy, recTy: LongInt;
  cv: TConstVal;
  sw: TSetWords;
begin
  { a value-less const `Name: Type;` is a link-time constant (doc/languages/kobold/kp-units.md): its value is
    supplied by the unit's implementation and resolved at link, not baked into consumers. It is
    valid only in a unit interface, and must be an ordinal or int64 scalar (a value the loader
    can patch as an immediate). }
  if Nodes[node].B < 0 then begin
    if not AnalyzingInterface then begin
      SemErr(node, 'a constant needs a value');
      Exit;
    end;
    if Nodes[node].A < 0 then begin
      SemErr(node, 'a link-time constant needs an explicit type');
      Exit;
    end;
    s := Declare(Nodes[node].Text, syConst, node);
    Nodes[node].Sym := s;
    Syms[s].TypeId := ResolveType(Nodes[node].A);
    if not (IsOrdinalType(Syms[s].TypeId) or (Syms[s].TypeId = tyInt64) or
            (Syms[s].TypeId = tyStr)) then
      SemErr(node, 'a link-time constant must be an ordinal, int64, or string scalar');
    Syms[s].LinkConst := True;
    Syms[s].LinkPending := True;
    Exit;
  end;
  agg := Nodes[node].B;
  if (agg >= 0) and (Nodes[agg].Kind = nkAggregate) then begin
    { a typed constant array: NAME : array[Lo..Hi] of T = (e1, e2, ...). The image is built
      from the constant elements during lowering; sema declares the symbol and checks it. }
    { An array or record constant has no cross-unit interface form yet, so a unit cannot export
      one: it would be dropped silently from the interface and a consumer would fail to find it.
      Report it here instead. Keep the constant in the implementation and expose it through a
      function (doc/languages/kobold/kp-units.md). }
    if AnalyzingInterface then begin
      SemErr(node, 'an array or record constant cannot be exported from a unit interface yet; ' +
        'keep it in the implementation and expose it through a function');
      Exit;
    end;
    s := Declare(Nodes[node].Text, syConst, node);
    if Nodes[node].A < 0 then begin
      SemErr(node, 'a constant array needs an explicit array type');
      Exit;
    end;
    arrTy := ResolveType(Nodes[node].A);
    Syms[s].TypeId := arrTy;
    if (arrTy < 0) or (SemTypes[arrTy].Kind <> skArray) or
       (Length(SemTypes[arrTy].Subs) = 0) then begin
      SemErr(node, 'a constant array needs a fixed array type');
      Exit;
    end;
    elemTy := SemTypes[arrTy].Base;
    { validate the shape and the element values recursively, so a multi-dimensional array is a
      list of nested lists and an element may itself be a record or a nested array }
    CheckConstArray(arrTy, 0, agg);
    if (Length(SemTypes[arrTy].Subs) = 1) and (SemTypes[elemTy].Kind = skString) then begin
      { a one-dimensional array of strings: each element string is created and stored into a
        global slot array when main starts (see EmitStrConstArrayInits) }
      SetLength(StrConstArrays, StrConstArrayCount + 1);
      StrConstArrays[StrConstArrayCount] := s;
      Inc(StrConstArrayCount);
    end
    else if (Length(SemTypes[arrTy].Subs) = 1) and (not IsInt64(elemTy)) and
            (SemTypes[elemTy].Kind in [skInteger, skBoolean, skChar, skEnum, skSubrange]) then
      { a one-dimensional array of 32-bit ordinals: a pure-bits read-only image built on first
        use in integer arithmetic (see ConstArrayGlobal), no run-time fill needed }
    else begin
      { anything else (multi-dimensional, or an element that is a record, int64, or real) is
        built into a global blob when main starts (see EmitBlobConstInits) }
      SetLength(RecConstArrays, RecConstArrayCount + 1);
      RecConstArrays[RecConstArrayCount] := s;
      Inc(RecConstArrayCount);
    end;
    Exit;
  end;
  if (agg >= 0) and (Nodes[agg].Kind = nkRecordLit) then begin
    { a first-class record constant: NAME : TRec = (field: value; ...). Like an array constant
      it has no cross-unit interface form yet, so a unit cannot export one. The value is built
      into a global blob when main starts (see EmitBlobConstInits). }
    if AnalyzingInterface then begin
      SemErr(node, 'an array or record constant cannot be exported from a unit interface yet; ' +
        'keep it in the implementation and expose it through a function');
      Exit;
    end;
    s := Declare(Nodes[node].Text, syConst, node);
    if Nodes[node].A < 0 then begin
      SemErr(node, 'a record constant needs an explicit record type');
      Exit;
    end;
    recTy := ResolveType(Nodes[node].A);
    Syms[s].TypeId := recTy;
    if (recTy < 0) or (SemTypes[recTy].Kind <> skRecord) then begin
      SemErr(node, 'a record constant needs a record type');
      Exit;
    end;
    CheckRecordLit(agg, recTy);
    SetLength(RecConstArrays, RecConstArrayCount + 1);
    RecConstArrays[RecConstArrayCount] := s;
    Inc(RecConstArrayCount);
    Exit;
  end;
  if (Nodes[node].B >= 0) and (Nodes[Nodes[node].B].Kind = nkSetConstructor) then begin
    { a constant set: NAME : set of T = [...]. A set constant is pure bits with no runtime
      handle, so a small set stores its 64-bit mask and a large set gets a read-only image
      built on first use (see ConstSetGlobal). }
    s := Declare(Nodes[node].Text, syConst, node);
    if Nodes[node].A < 0 then begin
      SemErr(node, 'a constant set needs an explicit set type');
      Exit;
    end;
    setTy := ResolveType(Nodes[node].A);
    Syms[s].TypeId := setTy;
    if not IsSet(setTy) then begin
      SemErr(node, 'a constant set needs a set type');
      Exit;
    end;
    if not EvalConstSet(Nodes[node].B, setTy, sw) then
      SemErr(node, 'constant set has a non-constant or out-of-range element')
    else if IsSmallSet(setTy) then
      Syms[s].Ordinal := sw[0];
    Exit;
  end;
  cv := EvalConst(Nodes[node].B);
  if not cv.Ok then SemErr(node, 'constant expression expected');
  { complete a link-time const the interface declared value-less: the implementation supplies
    its value on the same symbol rather than declaring a second one (like an opaque type). }
  s := Lookup(Nodes[node].Text);
  if (s >= 0) and (Syms[s].Kind = syConst) and Syms[s].LinkConst and Syms[s].LinkPending then begin
    Syms[s].LinkPending := False;
    Nodes[node].Sym := s;
    if Syms[s].TypeId = tyStr then begin
      if not cv.IsStr then SemErr(node, 'string constant expected')
      else begin Syms[s].ConstIsStr := True; Syms[s].ConstStr := cv.S; end;
    end
    else if cv.IsStr or cv.IsReal then
      SemErr(node, 'a link-time constant must be an ordinal, int64, or string scalar')
    else Syms[s].Ordinal := cv.I;
    Exit;
  end;
  s := Declare(Nodes[node].Text, syConst, node);
  Nodes[node].Sym := s;   { for a unit interface, the exported const's value symbol }
  if Nodes[node].A >= 0 then Syms[s].TypeId := ResolveType(Nodes[node].A)
  else Syms[s].TypeId := cv.Ty;
  if cv.IsStr then begin
    Syms[s].ConstIsStr := True; Syms[s].ConstStr := cv.S;
  end
  { a real or single const stores its f64 bit pattern in Ordinal (an int value given a real
    type is promoted to those bits); a real value given a non-real type is a mismatch }
  else if IsRealType(Syms[s].TypeId) then
    Syms[s].Ordinal := RealBitsFromConst(Nodes[node].B)
  else if cv.IsReal then
    SemErr(node, 'a real constant value needs a real or single type')
  else Syms[s].Ordinal := cv.I;
end;

procedure DeclType(node: LongInt);
var
  ty, s, g, existing: LongInt;
begin
  { an opaque interface type, `type Grid;`, names a record whose fields the implementation
    supplies. Register a placeholder record now; the implementation completes it in place, so
    every earlier reference (a routine signature) sees the fields and size once filled. }
  if Nodes[node].Flag = 1 then begin
    g := NewSemType(skRecord);
    SemTypes[g].Name := Nodes[node].Text;
    SemTypes[g].Opaque := True;
    s := Declare(Nodes[node].Text, syType, node);
    Syms[s].TypeId := g;
    Nodes[node].Sym := s;
    Exit;
  end;
  { an implementation `type Grid = record ...` completes an opaque placeholder of the same
    name from the interface, filling its fields in place rather than declaring a new type }
  existing := FindLocal(Nodes[node].Text, CurScope);
  if (existing >= 0) and (Syms[existing].Kind = syType) and (Syms[existing].TypeId >= 0) and
     SemTypes[Syms[existing].TypeId].Opaque and
     (Length(SemTypes[Syms[existing].TypeId].Subs) = 0) then begin
    ty := ResolveType(Nodes[node].A);
    g := Syms[existing].TypeId;
    if (ty >= 0) and (SemTypes[ty].Kind = skRecord) then begin
      SemTypes[g].Names := SemTypes[ty].Names;
      SemTypes[g].Subs := SemTypes[ty].Subs;
      SemTypes[g].MemberOff := SemTypes[ty].MemberOff;
    end
    else
      SemErr(node, 'opaque type ''' + Nodes[node].Text + ''' must be completed by a record');
    Nodes[node].Sym := existing;
    Exit;
  end;
  ty := ResolveType(Nodes[node].A);
  s := Declare(Nodes[node].Text, syType, node);
  Syms[s].TypeId := ty;
  Nodes[node].Sym := s;   { for interface emission of an exported type }
  if (ty >= 0) and (SemTypes[ty].Name = '') then SemTypes[ty].Name := Nodes[node].Text;
end;

procedure DeclVar(node: LongInt);
var
  vt, i, s: LongInt;
begin
  vt := ResolveType(Nodes[node].A);
  { a `label` value is second-class: it may live only in the frame of the
    routine that made it, so a global (module-level) variable may not hold one.
    A local `label` or routine-local `array of label` is the only legal home. }
  if (CurRoutineSym < 0) and TypeMentionsLabel(vt) then
    SemErr(node, 'a ''label'' value cannot be a global; it may live only in a ' +
      'local variable or a routine-local array of label');
  for i := 0 to High(Nodes[node].Kids) do begin
    s := Declare(Nodes[Nodes[node].Kids[i]].Text, syVar, Nodes[node].Kids[i]);
    Syms[s].TypeId := vt;
    Syms[s].Warnable := True;   { a real var declaration: eligible for the unused warning }
    Nodes[Nodes[node].Kids[i]].Sym := s;
  end;
  if Nodes[node].B >= 0 then AnalyzeExpr(Nodes[node].B);
end;

procedure DeclProperty(node: LongInt);
{ A declaration-level property (doc/languages/kobold/kp-property.md): a value-typed symbol whose
  reads and writes become calls to free-routine accessors. It is a syVar whose Node is the
  nkPropertyDecl, so IsPropertySym can tell it from a stored variable; it is given no storage
  (LowerGlobalVars and AssignBlockSlots skip the property node). The accessors are resolved
  after the whole declaration part, so a property may name an accessor declared later. }
var
  ty, s: LongInt;
begin
  ty := ResolveType(Nodes[node].A);
  if not IsPropertyValueType(ty) then
    SemErr(node, 'a property type must be a value (ordinal, real, int64), a handle (string, '
      + 'dynamic array, map, interface, process), or an aggregate (record, array, set)');
  s := Declare(Nodes[node].Text, syVar, node);
  Syms[s].TypeId := ty;
  Nodes[node].Sym := s;
end;

procedure ResolvePropertyAccessors(node: LongInt);
{ Resolve and check a property's read/write accessors once every routine in the declaration
  part is declared. The getter is a parameterless function of the property type; the setter,
  when present, a procedure taking one argument of that type. }
var
  ty, g, st, sig: LongInt;
begin
  ty := Syms[Nodes[node].Sym].TypeId;
  g := Lookup(Nodes[Nodes[node].B].Text);
  if g < 0 then
    SemErr(node, 'undeclared getter ''' + Nodes[Nodes[node].B].Text + '''')
  else if Syms[g].Kind <> syFunc then
    SemErr(node, 'property getter ''' + Nodes[g].Text + ''' must be a function')
  else begin
    Nodes[Nodes[node].B].Sym := g;
    sig := Syms[g].TypeId;
    if Length(SemTypes[sig].ParamTypes) <> 0 then
      SemErr(node, 'property getter ''' + Syms[g].Name + ''' must take no arguments')
    else if not AssignCompatible(ty, SemTypes[sig].RetType) then
      SemErr(node, 'property getter ''' + Syms[g].Name + ''' must return ' + TypeName(ty));
  end;
  if Nodes[node].C >= 0 then begin
    st := Lookup(Nodes[Nodes[node].C].Text);
    if st < 0 then
      SemErr(node, 'undeclared setter ''' + Nodes[Nodes[node].C].Text + '''')
    else if Syms[st].Kind <> syProc then
      SemErr(node, 'property setter ''' + Nodes[st].Text + ''' must be a procedure')
    else begin
      Nodes[Nodes[node].C].Sym := st;
      sig := Syms[st].TypeId;
      if Length(SemTypes[sig].ParamTypes) <> 1 then
        SemErr(node, 'property setter ''' + Syms[st].Name + ''' must take one argument')
      else if not AssignCompatible(SemTypes[sig].ParamTypes[0], ty) then
        SemErr(node, 'property setter ''' + Syms[st].Name + ''' must take ' + TypeName(ty));
    end;
  end;
end;

function SameParamType(x, y: LongInt): Boolean;
{ Two parameter types are the same when they share an id, or, for an open-array param
  (`array of T`), when both are dynamic arrays of the same element type. Each occurrence
  of `array of T` mints a fresh anonymous type, so a forward header and its definition
  carry distinct ids for a structurally identical open-array parameter. }
begin
  SameParamType := (x = y) or
    (IsDynArray(x) and IsDynArray(y) and (SemTypes[x].Base = SemTypes[y].Base));
end;

function SigEqual(a, b: LongInt): Boolean;
{ True when two routine signatures have the same parameter types and modes and the same result
  type, so one is the completion of the other rather than a distinct overload. }
var
  i: LongInt;
begin
  SigEqual := False;
  if (a < 0) or (b < 0) then Exit;
  if Length(SemTypes[a].ParamTypes) <> Length(SemTypes[b].ParamTypes) then Exit;
  for i := 0 to High(SemTypes[a].ParamTypes) do begin
    if not SameParamType(SemTypes[a].ParamTypes[i], SemTypes[b].ParamTypes[i]) then Exit;
    if SemTypes[a].ParamModes[i] <> SemTypes[b].ParamModes[i] then Exit;
  end;
  if SemTypes[a].RetType <> SemTypes[b].RetType then Exit;
  SigEqual := True;
end;

function CompleteForward(const name: string; sig: LongInt; isFunc: Boolean): LongInt;
{ The symbol of a still-open forward declaration this definition completes: a routine of the
  same kind, name, and signature in the current scope whose node is still the forward header.
  Reusing it keeps a forward-then-defined routine one symbol, so a call is not ambiguous.
  Returns -1 when there is none. }
var
  i, s: LongInt;
  wantKind: TSymKind;
  l: string;
begin
  CompleteForward := -1;
  if isFunc then wantKind := syFunc else wantKind := syProc;
  l := LowerStr(name);
  for i := 0 to High(Scopes[CurScope].Members) do begin
    s := Scopes[CurScope].Members[i];
    { Flag 1 is a `forward` header; Flag 3 is a unit interface heading whose body
      lives in the implementation part. Either is completed by a matching body. }
    if (Syms[s].Kind = wantKind) and (Syms[s].LowerName = l) and
       (Syms[s].Node >= 0) and
       ((Nodes[Syms[s].Node].Flag = 1) or (Nodes[Syms[s].Node].Flag = 3)) and
       SigEqual(Syms[s].TypeId, sig) then
      Exit(s);
  end;
end;

function CompleteForwardMethod(const name: string; sig, recvTy: LongInt;
  isFunc: Boolean): LongInt;
{ Like CompleteForward, but for a method: match a forward or interface heading of the same
  name and signature whose receiver type is also recvTy, so a method body completes the
  right heading among same-named methods on different types. }
var
  s: LongInt;
  wantKind: TSymKind;
  l: string;
begin
  CompleteForwardMethod := -1;
  if isFunc then wantKind := syFunc else wantKind := syProc;
  l := LowerStr(name);
  for s := 0 to SymCount - 1 do
    if (Syms[s].Kind = wantKind) and (Syms[s].LowerName = l) and
       (Syms[s].Node >= 0) and
       ((Nodes[Syms[s].Node].Flag = 1) or (Nodes[Syms[s].Node].Flag = 3)) and
       (Nodes[Syms[s].Node].A >= 0) and                    { the heading is a method }
       (Nodes[Nodes[Syms[s].Node].A].Ty = recvTy) and      { on the same receiver type }
       SigEqual(Syms[s].TypeId, sig) then
      Exit(s);
end;

function FailsConflict(const name: string; sig, recvTy: LongInt;
  isFunc, isMethod: Boolean): Boolean;
{ True when a routine of this name and the same parameter signature (and receiver, for a
  method) is already declared but with the opposite `fails` marker. Failable is deliberately
  left out of SigEqual so the two read as one signature, which is exactly the case the language
  forbids: a name may not be overloaded on `fails` alone (doc/languages/kobold/kp-errors.md). Free routines are
  matched within the current scope, methods against every same-receiver declaration. }
var
  i, s: LongInt;
  wantKind: TSymKind;
  l: string;
begin
  FailsConflict := False;
  if isFunc then wantKind := syFunc else wantKind := syProc;
  l := LowerStr(name);
  if isMethod then begin
    for s := 0 to SymCount - 1 do
      if (Syms[s].Kind = wantKind) and (Syms[s].LowerName = l) and
         (Syms[s].Node >= 0) and (Nodes[Syms[s].Node].A >= 0) and
         (Nodes[Nodes[Syms[s].Node].A].Ty = recvTy) and
         SigEqual(Syms[s].TypeId, sig) and
         (SemTypes[Syms[s].TypeId].Failable <> SemTypes[sig].Failable) then
        Exit(True);
  end
  else
    for i := 0 to High(Scopes[CurScope].Members) do begin
      s := Scopes[CurScope].Members[i];
      if (Syms[s].Kind = wantKind) and (Syms[s].LowerName = l) and
         (Syms[s].Node >= 0) and (Nodes[Syms[s].Node].A < 0) and
         SigEqual(Syms[s].TypeId, sig) and
         (SemTypes[Syms[s].TypeId].Failable <> SemTypes[sig].Failable) then
        Exit(True);
    end;
end;

procedure DeclRoutine(node: LongInt);
var
  isFunc, completedHeading: Boolean;
  sig, s, i, v, body, recv, pty, ps, recvTy: LongInt;
  savedFunc, savedRSym, savedRScope, savedAnswer: LongInt;
  savedLabelBase: LongInt;
  savedFailable: Boolean;
begin
  isFunc := Nodes[node].Kind = nkFuncDecl;
  { build the signature in the enclosing scope }
  sig := NewSemType(skProc);
  for i := 0 to High(Nodes[node].Kids) do
    if Nodes[Nodes[node].Kids[i]].Kind = nkParam then begin
      pty := ResolveType(Nodes[Nodes[node].Kids[i]].A);
      { a `label` value is second-class: it crosses no routine boundary, so it
        cannot be a parameter (nor an array of label passed in) }
      if TypeMentionsLabel(pty) then
        SemErr(Nodes[node].Kids[i], 'a ''label'' value cannot be a parameter; ' +
          'it may live only in the frame of the routine that made it');
      for v := 0 to High(Nodes[Nodes[node].Kids[i]].Kids) do
        AddSigParam(sig, pty, Nodes[Nodes[node].Kids[i]].Flag);
    end;
  if isFunc then SemTypes[sig].RetType := ResolveType(Nodes[node].B)
  else SemTypes[sig].RetType := -1;
  { a `label` value cannot be returned either (the frame it names is gone) }
  if isFunc and TypeMentionsLabel(SemTypes[sig].RetType) then
    SemErr(node, 'a routine cannot return a ''label'' value; it may live only ' +
      'in the frame of the routine that made it');
  SemTypes[sig].Failable := Nodes[node].Failable = 1;
  { a failable routine returns its value through a hidden caller buffer (sret) and the error in
    the integer register, so a real, int64, or record result works; an integer-class result
    keeps the two-register RETV2/CALL2 fast path. This holds for a method too: its receiver is
    an ordinary leading parameter and the sret pointer the trailing one, so the same wide path
    serves both (doc/languages/kobold/kp-errors.md). }

  { resolve a method's receiver type early: method completion and interface emission both
    need it, and it is recorded on the receiver node for later reads }
  recvTy := -1;
  if Nodes[node].A >= 0 then begin
    recvTy := ResolveType(Nodes[Nodes[node].A].A);
    Nodes[Nodes[node].A].Ty := recvTy;
  end;

  { a body definition may complete an earlier interface heading or forward header, reusing
    its symbol so the routine stays one symbol: a free routine matches by name and signature,
    a method also by receiver type. }
  s := -1;
  if Nodes[node].Flag = 0 then
    if Nodes[node].A >= 0 then s := CompleteForwardMethod(Nodes[node].Text, sig, recvTy, isFunc)
    else s := CompleteForward(Nodes[node].Text, sig, isFunc);
  completedHeading := s >= 0;
  if completedHeading then begin
    { the body must repeat the heading's `fails` marker, since it is part of the signature }
    if SemTypes[Syms[s].TypeId].Failable <> SemTypes[sig].Failable then
      SemErrName(node, 'routine ''' + Nodes[node].Text +
        ''' and its heading disagree on ''fails''');
    Syms[s].Node := node   { point the heading symbol at the body-bearing node for lowering }
  end
  else begin
    { a name may not be overloaded on `fails` alone (doc/languages/kobold/kp-errors.md) }
    if FailsConflict(Nodes[node].Text, sig, recvTy, isFunc, Nodes[node].A >= 0) then
      SemErrName(node, 'routine ''' + Nodes[node].Text +
        ''' cannot overload on ''fails'' alone');
    if isFunc then s := Declare(Nodes[node].Text, syFunc, node)
    else s := Declare(Nodes[node].Text, syProc, node);
    Syms[s].TypeId := sig;
  end;
  Nodes[node].Sym := s;   { the routine's own symbol, for lowering }

  { record a method against its receiver type for x.method resolution, unless the body just
    completed a heading that already registered it }
  if (Nodes[node].A >= 0) and (recvTy >= 0) and not completedHeading then
    AddMethod(recvTy, Nodes[node].Text, sig, s);

  { find a body block among the children (absent for forward/external) }
  body := -1;
  for i := 0 to High(Nodes[node].Kids) do
    if Nodes[Nodes[node].Kids[i]].Kind = nkBlock then body := Nodes[node].Kids[i];
  if body < 0 then Exit;

  savedFunc := CurFuncSym;
  savedRSym := CurRoutineSym;
  savedRScope := CurRoutineScope;
  OpenScope;
  CurRoutineSym := s;
  CurRoutineScope := CurScope;
  Syms[s].BodyScope := CurScope;   { for capture analysis in lowering }
  { a method receiver becomes a by-reference parameter }
  if Nodes[node].A >= 0 then begin
    recv := Nodes[node].A;   { nkReceiver, Text=name, A=nkTypeRef }
    v := Declare(Nodes[recv].Text, syParam, recv);
    Syms[v].TypeId := recvTy;
    Nodes[recv].Sym := v;   { for lowering: the receiver is the first parameter }
  end;
  for i := 0 to High(Nodes[node].Kids) do
    if Nodes[Nodes[node].Kids[i]].Kind = nkParam then begin
      pty := ResolveType(Nodes[Nodes[node].Kids[i]].A);
      for v := 0 to High(Nodes[Nodes[node].Kids[i]].Kids) do begin
        ps := Declare(Nodes[Nodes[Nodes[node].Kids[i]].Kids[v]].Text,
          syParam, Nodes[Nodes[node].Kids[i]].Kids[v]);
        Syms[ps].TypeId := pty;
        Syms[ps].ParamMode := Nodes[Nodes[node].Kids[i]].Flag;
        Nodes[Nodes[Nodes[node].Kids[i]].Kids[v]].Sym := ps;
      end;
    end;
  if isFunc then CurFuncSym := s;   { a nested proc keeps the outer function }
  { a routine body is its own coroutine boundary: yield/bind inside it check
    against a fresh answer type, so a routine started as a coroutine may yield }
  savedAnswer := AnswerType;
  AnswerType := -1;
  savedFailable := CurFailable;
  CurFailable := SemTypes[Syms[s].TypeId].Failable;   { `or fail` / `fail` are legal in a failable body }
  { open this routine's label scope: @name and a label definition see only
    labels in [savedLabelBase, LabelCount) from here on }
  savedLabelBase := LabelBase;
  LabelBase := LabelCount;
  AnalyzeBlock(body);
  { any label reached by @name but never defined by a `name:` prefix }
  for i := LabelBase to LabelCount - 1 do
    if not LabelDefd[i] then
      SemErr(LabelNode[i], 'no label named ''' + LabelNames[i] +
        ''' in this routine (reached by ''@'')');
  LabelCount := LabelBase;
  LabelBase := savedLabelBase;
  CurFailable := savedFailable;
  AnswerType := savedAnswer;
  WarnUnusedInScope(CurScope);   { the routine's locals, before the scope closes }
  CloseScope;
  CurFuncSym := savedFunc;
  CurRoutineSym := savedRSym;
  CurRoutineScope := savedRScope;
end;

procedure AnalyzeBlock(node: LongInt);
var
  i, k: LongInt;
begin
  for i := 0 to High(Nodes[node].Kids) do begin
    k := Nodes[node].Kids[i];
    case Nodes[k].Kind of
      nkConstDecl: DeclConst(k);
      nkTypeDecl:  DeclType(k);
      nkVarDecl:   DeclVar(k);
      nkProcDecl, nkFuncDecl: DeclRoutine(k);
      nkPropertyDecl: DeclProperty(k);
      nkCompound:  AnalyzeStmt(k);
    end;
  end;
  { a property may name an accessor declared later in the same part, so resolve them after
    every routine symbol in this part exists }
  for i := 0 to High(Nodes[node].Kids) do begin
    k := Nodes[node].Kids[i];
    if (Nodes[k].Kind = nkPropertyDecl) and (Nodes[k].Sym >= 0) then
      ResolvePropertyAccessors(k);
  end;
end;

procedure DeclareBuiltinProc(const nm: string);
var
  sig, s: LongInt;
begin
  sig := NewSemType(skProc);
  SemTypes[sig].Variadic := True;
  s := Declare(nm, syProc, -1);
  Syms[s].TypeId := sig;
end;

procedure DeclareBuiltinFunc(const nm: string; retTy: LongInt);
var
  sig, s: LongInt;
begin
  sig := NewSemType(skProc);
  SemTypes[sig].Variadic := True;
  SemTypes[sig].RetType := retTy;
  s := Declare(nm, syFunc, -1);
  Syms[s].TypeId := sig;
end;

procedure RegType(const nm: string; ty: LongInt);
{ Declare a type name. Uses a temp so the Syms element is addressed after
  Declare has (possibly) reallocated the pool. }
var
  s: LongInt;
begin
  s := Declare(nm, syType, -1);
  Syms[s].TypeId := ty;
end;

procedure InitSema;
var
  s: LongInt;
begin
  SemCount := 0; SymCount := 0; ScopeCount := 0; CurScope := -1;
  ResetSymIndex;
  LoopDepth := 0; StartDepth := 0; AnswerType := -1; CurFuncSym := -1;
  CurFailable := False; FailTargetNode := -1;
  CurRoutineSym := -1; CurRoutineScope := -1;
  LabelBase := 0; LabelCount := 0;
  StrConstArrayCount := 0; SetLength(StrConstArrays, 0);
  RecConstArrayCount := 0; SetLength(RecConstArrays, 0);
  { cross-unit resolution state (the -U path persists across files, so it is not reset here) }
  UUCount := 0; SetLength(UUName, 0); SetLength(UUScope, 0);
  SetLength(UUFingerprint, 0); SetLength(UUState, 0);
  QCount := 0; SetLength(QName, 0); SetLength(QScope, 0);
  DepCount := 0; SetLength(DepName, 0); SetLength(DepFingerprint, 0);
  ReexportCount := 0; SetLength(ReexportSym, 0);
  MethCount := 0;
  SetLength(MethRecv, 0); SetLength(MethName, 0); SetLength(MethSig, 0);
  SetLength(MethSym, 0);
  tyErr  := NewSemType(skError);        SemTypes[tyErr].Name  := '<error>';
  tyVoid := NewSemType(skVoid);         SemTypes[tyVoid].Name := 'void';
  tyInt  := NewSemType(skInteger);      SemTypes[tyInt].Name  := 'integer';
  tyReal := NewSemType(skReal);         SemTypes[tyReal].Name := 'real';
  tySingle := NewSemType(skReal);       SemTypes[tySingle].Name := 'single';
  SemTypes[tySingle].FloatBits := 32;
  tyInt64 := NewSemType(skInteger);     SemTypes[tyInt64].Name := 'int64';
  SemTypes[tyInt64].IntBits := 64;
  tyBool := NewSemType(skBoolean);      SemTypes[tyBool].Name := 'boolean';
  tyChar := NewSemType(skChar);         SemTypes[tyChar].Name := 'char';
  tyStr  := NewSemType(skString);       SemTypes[tyStr].Name  := 'string';
  tyProcess := NewSemType(skProcess); SemTypes[tyProcess].Name := 'process';
  tyNil  := NewSemType(skNil);          SemTypes[tyNil].Name  := 'nil';
  tyText := NewSemType(skInteger);      SemTypes[tyText].Name := 'text';
  tyMapIter := NewSemType(skMapIter);   SemTypes[tyMapIter].Name := 'mapiter';
  tyLabel := NewSemType(skLabel);       SemTypes[tyLabel].Name := 'label';
  tyErrorVal := NewSemType(skErrorVal); SemTypes[tyErrorVal].Name := 'error';
  OpenScope;   { the system scope: predefined identifiers live in an outer scope that the
                 program's own scope nests inside, so a user declaration of the same name
                 shadows a built-in rather than colliding with it }
  SystemScope := CurScope;
  RegType('integer', tyInt);
  RegType('real', tyReal);
  RegType('double', tyReal);
  RegType('single', tySingle);
  RegType('boolean', tyBool);
  RegType('char', tyChar);
  RegType('string', tyStr);
  RegType('process', tyProcess);
  RegType('mapiter', tyMapIter);
  RegType('label', tyLabel);
  RegType('error', tyErrorVal);
  RegType('byte', tyInt);
  RegType('shortint', tyInt);
  RegType('word', tyInt);
  RegType('longint', tyInt);
  RegType('cardinal', tyInt);
  RegType('int64', tyInt64);
  RegType('qword', tyInt64);
  RegType('text', tyText);
  s := Declare('true', syConst, -1);  Syms[s].TypeId := tyBool; Syms[s].Ordinal := 1;
  s := Declare('false', syConst, -1); Syms[s].TypeId := tyBool; Syms[s].Ordinal := 0;
  { the two predefined text streams; their ordinal is the stream id the host writes to }
  s := Declare('output', syConst, -1);   Syms[s].TypeId := tyText; Syms[s].Ordinal := 1;
  s := Declare('erroutput', syConst, -1); Syms[s].TypeId := tyText; Syms[s].Ordinal := 2;
  DeclareBuiltinFunc('length', tyInt);
  DeclareBuiltinFunc('high', tyInt);
  DeclareBuiltinFunc('low', tyInt);
  DeclareBuiltinFunc('ord', tyInt);
  DeclareBuiltinFunc('chr', tyChar);
  { succ/pred yield the argument's own ordinal type; the tyInt here is a
    placeholder overridden per call in AnalyzeCallOf. odd is always boolean. }
  DeclareBuiltinFunc('succ', tyInt);
  DeclareBuiltinFunc('pred', tyInt);
  DeclareBuiltinFunc('odd', tyBool);
  { abs/sqr return the argument's own numeric type (placeholder overridden per
    call). sqrt is always real; round/trunc convert a real to an integer. }
  DeclareBuiltinFunc('abs', tyInt);
  DeclareBuiltinFunc('sqr', tyInt);
  DeclareBuiltinFunc('sqrt', tyReal);
  DeclareBuiltinFunc('round', tyInt);
  DeclareBuiltinFunc('trunc', tyInt);
  { the transcendentals: one real argument, a real result, via runtime helpers }
  DeclareBuiltinFunc('sin', tyReal);
  DeclareBuiltinFunc('cos', tyReal);
  DeclareBuiltinFunc('exp', tyReal);
  DeclareBuiltinFunc('ln', tyReal);
  DeclareBuiltinFunc('arctan', tyReal);
  DeclareBuiltinFunc('pos', tyInt);
  DeclareBuiltinFunc('copy', tyStr);
  DeclareBuiltinProc('setlength');
  DeclareBuiltinProc('delete');
  DeclareBuiltinProc('insert');
  { map helpers: tryget(m, key, out v) tests and fetches; mapfirst/mapnext iterate }
  DeclareBuiltinFunc('tryget', tyBool);
  DeclareBuiltinFunc('mapfirst', tyMapIter);
  DeclareBuiltinFunc('mapnext', tyBool);
  { failable error values: fail(code) builds an error, errorcode(e) reads its code back. See
    doc/languages/kobold/kp-errors.md. On the int-code representation both are identities over the i32. }
  DeclareBuiltinFunc('fail', tyErrorVal);
  DeclareBuiltinFunc('errorcode', tyInt);
  DeclareBuiltinProc('str');
  DeclareBuiltinProc('val');
  DeclareBuiltinProc('inc');
  DeclareBuiltinProc('dec');
  DeclareBuiltinProc('exit');
  DeclareBuiltinProc('writeln');
  DeclareBuiltinProc('write');
  DeclareBuiltinProc('readln');
  DeclareBuiltinProc('read');
  DeclareBuiltinProc('flush');
  DeclareBuiltinProc('halt');
  DeclareBuiltinProc('abort');
  DeclareBuiltinProc('assert');
  DeclareBuiltinProc('release');
  DeclareBuiltinFunc('paramstr', tyStr);
  DeclareBuiltinFunc('paramcount', tyInt);
  OpenScope;   { the program/global scope: top-level user declarations live here }
  GlobalScope := CurScope;
end;

procedure CheckOneImplement(node: LongInt);
{ Verify a `implement I for R;` assertion: I names an interface type, R a record type, and R
  has a for-receiver method matching each of I's method signatures. A static, compile-time
  conformance check with no runtime representation (doc/languages/kobold/kobold.md). }
var
  isym, rsym, ity, rty, i, rsig: LongInt;
  mname: string;
begin
  isym := Lookup(Nodes[node].Text);
  if (isym < 0) or (Syms[isym].Kind <> syType) then begin
    SemErr(node, 'unknown interface type ''' + Nodes[node].Text + ''''); Exit;
  end;
  ity := Syms[isym].TypeId;
  if (ity < 0) or (ity >= SemCount) or (SemTypes[ity].Kind <> skInterface) then begin
    SemErr(node, '''' + Nodes[node].Text + ''' is not an interface type'); Exit;
  end;
  rsym := Lookup(Nodes[Nodes[node].A].Text);
  if (rsym < 0) or (Syms[rsym].Kind <> syType) then begin
    SemErr(node, 'unknown record type ''' + Nodes[Nodes[node].A].Text + ''''); Exit;
  end;
  rty := Syms[rsym].TypeId;
  if (rty < 0) or (rty >= SemCount) or (SemTypes[rty].Kind <> skRecord) then begin
    SemErr(node, '''' + Nodes[Nodes[node].A].Text + ''' is not a record type'); Exit;
  end;
  for i := 0 to High(SemTypes[ity].Names) do begin
    mname := SemTypes[ity].Names[i];
    rsig := FindMethod(rty, mname);
    if rsig < 0 then
      SemErr(node, 'record ''' + SemTypes[rty].Name + ''' does not implement method ''' +
        mname + ''' required by interface ''' + SemTypes[ity].Name + '''')
    else if not SigEqual(SemTypes[ity].Subs[i], rsig) then
      SemErr(node, 'method ''' + mname + ''' of ''' + SemTypes[rty].Name +
        ''' does not match its signature in interface ''' + SemTypes[ity].Name + '''');
  end;
end;

procedure CheckImplements(listNode: LongInt);
{ Run the conformance check for every `implement` assertion in a declaration list, after all
  its declarations are analyzed so the receiver methods are registered. }
var
  i, k: LongInt;
begin
  for i := 0 to High(Nodes[listNode].Kids) do begin
    k := Nodes[listNode].Kids[i];
    if Nodes[k].Kind = nkImplement then CheckOneImplement(k);
  end;
end;

procedure AnalyzeUnit(u: LongInt);
{ A unit is analyzed in the module (global) scope: the interface declarations first, then
  the implementation. An interface routine heading (Flag 3) registers a signature that its
  implementation body completes through CompleteForward, exactly like a forward. Every such
  heading must be given a body. Its dependencies were already bound (BindUses in Analyze);
  re-exports promote dependency names into this unit's own interface surface. }
var
  i, h, s, bn: LongInt;
begin
  ProcessReexports(Nodes[u].B);
  AnalyzingInterface := True;
  AnalyzeBlock(Nodes[u].B);   { interface part: headings, consts, vars, types }
  AnalyzingInterface := False;
  AnalyzeBlock(Nodes[u].C);   { implementation part: bodies and private decls }
  CheckImplements(Nodes[u].C);   { conformance assertions, after methods are registered }
  for i := 0 to High(Nodes[Nodes[u].B].Kids) do begin
    h := Nodes[Nodes[u].B].Kids[i];
    if Nodes[h].Kind in [nkProcDecl, nkFuncDecl] then begin
      s := Nodes[h].Sym;
      if s >= 0 then begin
        bn := Syms[s].Node;
        if (bn = h) or (Nodes[bn].Flag = 3) then
          SemErr(h, 'interface routine ''' + Nodes[h].Text +
            ''' has no implementation');
      end;
    end
    else if (Nodes[h].Kind = nkTypeDecl) and (Nodes[h].Flag = 1) then begin
      s := Nodes[h].Sym;
      if (s >= 0) and (Syms[s].TypeId >= 0) and
         (Length(SemTypes[Syms[s].TypeId].Subs) = 0) then
        SemErr(h, 'opaque type ''' + Nodes[h].Text +
          ''' has no record definition in the implementation');
    end
    else if Nodes[h].Kind = nkConstDecl then begin
      s := Nodes[h].Sym;
      if (s >= 0) and Syms[s].LinkConst and Syms[s].LinkPending then
        SemErr(h, 'link-time constant ''' + Nodes[h].Text +
          ''' has no value in the implementation');
    end;
  end;
end;

{ ---- cross-unit resolution: read a dependency's .interface (doc/languages/kobold/kp-units.md) ---- }

function ParseI64(const s: string): Int64;
{ A signed decimal, tolerant of surrounding text: non-digits after an optional leading
  minus stop the scan. Used for interface const values and fingerprints. }
var
  i: LongInt;
  neg: Boolean;
  v: Int64;
begin
  v := 0;
  neg := False;
  i := 1;
  if (Length(s) >= 1) and (s[1] = '-') then begin neg := True; i := 2; end;
  while (i <= Length(s)) and (s[i] >= '0') and (s[i] <= '9') do begin
    v := v * 10 + (Ord(s[i]) - Ord('0'));
    Inc(i);
  end;
  if neg then ParseI64 := -v else ParseI64 := v;
end;

function NextField(const s: string; var pos: LongInt): string;
{ The next whitespace-delimited token of s from pos, advancing pos past it; '' at end. }
var
  st: LongInt;
begin
  while (pos <= Length(s)) and ((s[pos] = ' ') or (s[pos] = #9)) do Inc(pos);
  st := pos;
  while (pos <= Length(s)) and (s[pos] <> ' ') and (s[pos] <> #9) do Inc(pos);
  NextField := Copy(s, st, pos - st);
end;

function NextLine(const text: string; var pos: LongInt): string;
{ The next line of text from pos, advancing pos past the newline. }
var
  st: LongInt;
begin
  st := pos;
  while (pos <= Length(text)) and (text[pos] <> #10) do Inc(pos);
  NextLine := Copy(text, st, pos - st);
  if pos <= Length(text) then Inc(pos);
end;

function UUFind(const uname: string): LongInt; forward;

function RefToType(const nm: string; uscope: LongInt): LongInt;
{ Map an interface type name back to a sem type: a built-in scalar by its canonical name,
  or the ABI-class fallback (int/int64/float), or an exported type resolved by name in the
  unit's own scope (an enum read from an earlier .type entry). A `unit.Type` name (a method
  receiver defined in another unit) resolves through that dependency's scope in the closure.
  An unknown name is read as the integer class, matching the ABI-class fallback the emitter
  uses. }
var
  s, i, dot, uu: LongInt;
begin
  { a dotted name qualifies the type by its defining unit; resolve it in that unit's scope }
  dot := 0;
  for i := 1 to Length(nm) do
    if nm[i] = '.' then begin dot := i; Break; end;
  if dot > 0 then begin
    uu := UUFind(Copy(nm, 1, dot - 1));
    if uu >= 0 then begin
      s := FindLocal(Copy(nm, dot + 1, Length(nm) - dot), UUScope[uu]);
      if (s >= 0) and (Syms[s].Kind = syType) then RefToType := Syms[s].TypeId
      else RefToType := tyInt;
    end
    else RefToType := tyInt;
    Exit;
  end;
  if (nm = 'integer') or (nm = 'int') then RefToType := tyInt
  else if nm = 'int64' then RefToType := tyInt64
  else if nm = 'boolean' then RefToType := tyBool
  else if nm = 'char' then RefToType := tyChar
  else if nm = 'string' then RefToType := tyStr
  else if (nm = 'real') or (nm = 'float') then RefToType := tyReal
  else if nm = 'single' then RefToType := tySingle
  else if nm = 'process' then RefToType := tyProcess
  else if nm = 'void' then RefToType := -1
  else begin
    s := FindLocal(nm, uscope);
    if (s >= 0) and (Syms[s].Kind = syType) then RefToType := Syms[s].TypeId
    else RefToType := tyInt;
  end;
end;

function ModeVal(const tok: string): LongInt;
{ The parameter mode a `.routine` mode token stands for. }
begin
  if tok = 'var' then ModeVal := 1
  else if tok = 'const' then ModeVal := 2
  else if tok = 'out' then ModeVal := 3
  else ModeVal := 0;
end;

function OpenUnitKpm(const uname: string; var text: string): Boolean;
{ Read <dir>/<uname>.kpm, name as written then lowercased, from the source directory
  first, then each -U path directory. }
var
  d: LongInt;
  dir: string;
begin
  OpenUnitKpm := False;
  { search the source directory first, then each -U directory, then the built-in standard
    library directory (KP_STDLIB, the install location baked in at build time) so a bare
    `uses strings;` resolves without a -U flag on an installed compiler }
  for d := -1 to High(UnitPath) + 1 do begin
    if d < 0 then dir := UnitSrcDir
    else if d > High(UnitPath) then dir := KP_STDLIB
    else dir := UnitPath[d];
    if dir = '' then Continue;
    text := ReadFileStr(dir + DotToSlash(uname) + '.kpm');
    if text <> '' then Exit(True);
    text := ReadFileStr(dir + DotToSlash(LowerStr(uname)) + '.kpm');
    if text <> '' then Exit(True);
  end;
end;

function UUFind(const uname: string): LongInt;
var
  i: LongInt;
  l: string;
begin
  UUFind := -1;
  l := LowerStr(uname);
  for i := 0 to UUCount - 1 do
    if LowerStr(UUName[i]) = l then Exit(i);
end;

function LoadUnitInterface(node: LongInt; const uname: string): LongInt;
{ Load a dependency's exported symbols from its .kpm .interface into a detached scope,
  recursing through its own .uses to build the closure and detect a cycle. Returns the
  UU index, or -1 with a diagnostic already reported. }
var
  u, savedScope, uscope, pos, dpos, sig, s, ety, idx: LongInt;
  text, line, kw, nm, cls, val, base: string;
  inIntf: Boolean;
begin
  u := UUFind(uname);
  if u >= 0 then begin
    if UUState[u] = 1 then begin
      SemErr(node, 'unit dependency cycle through ''' + uname + '''');
      Exit(-1);
    end;
    Exit(u);
  end;
  if LowerStr(uname) = LowerStr(CompilingUnitName) then begin
    SemErr(node, 'a unit may not use itself');
    Exit(-1);
  end;
  if not OpenUnitKpm(uname, text) then begin
    SemErr(node, 'cannot find unit ''' + uname + ''' on the unit path');
    Exit(-1);
  end;
  u := UUCount;
  SetLength(UUName, u + 1); SetLength(UUScope, u + 1);
  SetLength(UUFingerprint, u + 1); SetLength(UUState, u + 1);
  Inc(UUCount);
  UUName[u] := uname;
  UUFingerprint[u] := 0;
  UUState[u] := 1;                 { visiting: a back-edge to it is a cycle }
  savedScope := CurScope;
  OpenScope;
  uscope := CurScope;
  Scopes[uscope].Parent := -1;    { detached: reached only by qualified lookup or aliasing }
  UUScope[u] := uscope;
  pos := 1;
  inIntf := False;
  while pos <= Length(text) do begin
    line := NextLine(text, pos);
    dpos := 1;
    kw := NextField(line, dpos);
    if kw = '.uses' then begin
      nm := NextField(line, dpos);
      if LoadUnitInterface(node, nm) < 0 then begin
        CurScope := savedScope;
        Exit(-1);
      end;
    end
    else if kw = '.interface' then begin
      NextField(line, dpos);              { the word 'fingerprint' }
      UUFingerprint[u] := ParseI64(NextField(line, dpos));
      inIntf := True;
    end
    else if kw = '.endinterface' then
      inIntf := False
    else if inIntf and (kw = '.type') then begin
      CurScope := uscope;
      nm := NextField(line, dpos);
      cls := NextField(line, dpos);         { the type's kind }
      if cls = 'enum' then begin
        ety := NewSemType(skEnum);
        SemTypes[ety].Name := nm;
        SemTypes[ety].FromUnit := uname;
        idx := 0;
        val := NextField(line, dpos);
        while val <> '' do begin
          AddMember(ety, val, tyInt);
          s := AddSym(val, syEnumLit);        { the member, a compile-time constant }
          Syms[s].TypeId := ety;
          Syms[s].Ordinal := idx;
          Syms[s].Imported := True;
          Inc(idx);
          val := NextField(line, dpos);
        end;
        s := AddSym(nm, syType);              { the type name, for a type reference }
        Syms[s].TypeId := ety;
        Syms[s].Imported := True;
      end
      else if cls = 'opaque' then begin
        { a record whose size and alignment the consumer knows but whose fields it does
          not: reconstruct a fieldless record of that size, so a value copies by memcpy
          and carries no consumer-visible managed members }
        ety := NewSemType(skRecord);
        SemTypes[ety].Name := nm;
        SemTypes[ety].FromUnit := uname;
        SemTypes[ety].Opaque := True;
        SemTypes[ety].Size := ParseI64(NextField(line, dpos));
        SemTypes[ety].Align := ParseI64(NextField(line, dpos));
        s := AddSym(nm, syType);
        Syms[s].TypeId := ety;
        Syms[s].Imported := True;
      end
      else if cls = 'record' then begin
        { a transparent record: reconstruct its fields with their offsets, so the consumer
          accesses fields and a value copy retains any managed field, exactly as a locally
          declared record does }
        ety := NewSemType(skRecord);
        SemTypes[ety].Name := nm;
        SemTypes[ety].FromUnit := uname;
        SemTypes[ety].Size := ParseI64(NextField(line, dpos));
        SemTypes[ety].Align := ParseI64(NextField(line, dpos));
        NextField(line, dpos);                { '(' }
        val := NextField(line, dpos);         { a field name, or ')' }
        while (val <> ')') and (val <> '') do begin
          base := NextField(line, dpos);      { the field type }
          AddMember(ety, val, RefToType(base, uscope));
          SetMemberOff(ety, ParseI64(NextField(line, dpos)));
          val := NextField(line, dpos);
        end;
        s := AddSym(nm, syType);
        Syms[s].TypeId := ety;
        Syms[s].Imported := True;
      end
      else if cls = 'handle' then begin
        { a host handle type: reconstruct each method's name and signature, so the consumer
          emits the .import type vtable and dispatches a call to the right slot. The host
          supplies the implementation; this only carries the type's shape }
        ety := NewSemType(skInterface);
        SemTypes[ety].Name := nm;
        SemTypes[ety].FromUnit := uname;
        NextField(line, dpos);                { '(' }
        val := NextField(line, dpos);         { a method name, or ')' }
        while (val <> ')') and (val <> '') do begin
          sig := NewSemType(skProc);
          NextField(line, dpos);              { '(' }
          cls := NextField(line, dpos);       { a mode, or ')' }
          while (cls <> ')') and (cls <> '') do begin
            base := NextField(line, dpos);    { the parameter type }
            AddSigParam(sig, RefToType(base, uscope), ModeVal(cls));
            cls := NextField(line, dpos);
          end;
          NextField(line, dpos);              { '->' }
          base := NextField(line, dpos);      { the result type }
          SemTypes[sig].RetType := RefToType(base, uscope);
          AddMember(ety, val, sig);
          val := NextField(line, dpos);       { the next method name, or ')' }
        end;
        s := AddSym(nm, syType);
        Syms[s].TypeId := ety;
        Syms[s].Imported := True;
      end;
    end
    else if inIntf and (kw = '.const') then begin
      CurScope := uscope;
      nm := NextField(line, dpos);
      cls := NextField(line, dpos);
      val := NextField(line, dpos);
      s := AddSym(nm, syConst);
      Syms[s].TypeId := RefToType(cls, uscope);
      Syms[s].Imported := True;
      if val = '' then begin
        { a value-less `.const` is a link-time constant: its value is not baked in here but
          resolved by name at link (doc/languages/kobold/kp-units.md) }
        Syms[s].LinkConst := True;
        Syms[s].LinkName := nm;
      end
      else
        Syms[s].Ordinal := ParseI64(val);
    end
    else if inIntf and (kw = '.var') then begin
      CurScope := uscope;
      nm := NextField(line, dpos);
      base := NextField(line, dpos);
      s := AddSym(nm, syVar);
      Syms[s].TypeId := RefToType(base, uscope);
      Syms[s].Imported := True;
      Syms[s].Scope := GlobalScope;        { addressed as a global; linker resolves the name }
    end
    else if inIntf and (kw = '.routine') then begin
      CurScope := uscope;
      nm := NextField(line, dpos);
      sig := NewSemType(skProc);
      NextField(line, dpos);               { '(' }
      cls := NextField(line, dpos);        { a mode token, or ')' }
      while (cls <> ')') and (cls <> '') do begin
        val := NextField(line, dpos);      { the parameter type }
        AddSigParam(sig, RefToType(val, uscope), ModeVal(cls));
        cls := NextField(line, dpos);
      end;
      NextField(line, dpos);               { '->' }
      val := NextField(line, dpos);        { the result type }
      SemTypes[sig].RetType := RefToType(val, uscope);
      if NextField(line, dpos) = 'fails' then SemTypes[sig].Failable := True;
      if SemTypes[sig].RetType >= 0 then s := AddSym(nm, syFunc)
      else s := AddSym(nm, syProc);
      Syms[s].TypeId := sig;
      Syms[s].Imported := True;
    end
    else if inIntf and (kw = '.method') then begin
      CurScope := uscope;
      base := NextField(line, dpos);       { the receiver type }
      ety := RefToType(base, uscope);
      nm := NextField(line, dpos);         { the method name }
      sig := NewSemType(skProc);
      NextField(line, dpos);               { '(' }
      cls := NextField(line, dpos);
      while (cls <> ')') and (cls <> '') do begin
        val := NextField(line, dpos);
        AddSigParam(sig, RefToType(val, uscope), ModeVal(cls));
        cls := NextField(line, dpos);
      end;
      NextField(line, dpos);               { '->' }
      val := NextField(line, dpos);
      SemTypes[sig].RetType := RefToType(val, uscope);
      if NextField(line, dpos) = 'fails' then SemTypes[sig].Failable := True;
      { a symbol only to carry the method's link name <Receiver>.<name> for a cross-unit
        call; kept out of the lookup scope so it is not callable as a free routine }
      if SemTypes[sig].RetType >= 0 then s := AddSym(nm, syFunc)
      else s := AddSym(nm, syProc);
      RemoveLastMember(uscope);
      Syms[s].TypeId := sig;
      Syms[s].Imported := True;
      { the link name is the receiver type's own name, not the possibly unit-qualified
        reference (a.Point.Sum would not match the defining unit's Point.Sum export) }
      if (ety >= 0) and (ety < SemCount) then Syms[s].LinkName := SemTypes[ety].Name + '.' + nm
      else Syms[s].LinkName := base + '.' + nm;
      AddMethod(ety, nm, sig, s);
    end;
  end;
  CurScope := savedScope;
  UUState[u] := 2;                 { done }
  LoadUnitInterface := u;
end;

function QualIndex(const qual: string): LongInt;
{ The consumer's qualifier map entry for `qual`, or -1. }
var
  i: LongInt;
  l: string;
begin
  QualIndex := -1;
  l := LowerStr(qual);
  for i := 0 to QCount - 1 do
    if LowerStr(QName[i]) = l then Exit(i);
end;

procedure AddToScope(scope, s: LongInt);
{ Add an existing symbol id as a member of another scope, aliasing it in without a new
  symbol (so its identity, and for a routine its overload set, stay shared). }
begin
  AddMember(scope, s);
end;

function SelectView(item, u: LongInt): LongInt;
{ Build the scope of names an import makes visible. Without a selective list that is the
  unit's whole export scope. With one, a fresh detached scope holds only the selected
  names, each reused as-is or, when the item renames it, a fresh alias under the local name
  that keeps the export name for linkage. Overloads of a selected name all come in. }
var
  savedScope, viewScope, k, i, m, alias: LongInt;
  ii: LongInt;
  selName, localName: string;
  found: Boolean;
begin
  if High(Nodes[item].Kids) < 0 then begin
    SelectView := UUScope[u];
    Exit;
  end;
  savedScope := CurScope;
  OpenScope;
  viewScope := CurScope;
  Scopes[viewScope].Parent := -1;
  for k := 0 to High(Nodes[item].Kids) do begin
    ii := Nodes[item].Kids[k];
    selName := Nodes[ii].Text;
    if Nodes[ii].A >= 0 then localName := Nodes[Nodes[ii].A].Text else localName := selName;
    found := False;
    for i := 0 to High(Scopes[UUScope[u]].Members) do begin
      m := Scopes[UUScope[u]].Members[i];
      if Syms[m].LowerName = LowerStr(selName) then begin
        found := True;
        if Nodes[ii].A >= 0 then begin
          alias := AddSym(localName, Syms[m].Kind);   { added to viewScope (CurScope) }
          Syms[alias].TypeId := Syms[m].TypeId;
          Syms[alias].Ordinal := Syms[m].Ordinal;
          Syms[alias].ConstStr := Syms[m].ConstStr;
          Syms[alias].ConstIsStr := Syms[m].ConstIsStr;
          Syms[alias].LinkConst := Syms[m].LinkConst;
          Syms[alias].Imported := True;
          Syms[alias].LinkName := LinkNameOf(m);
          if Syms[m].Kind = syVar then Syms[alias].Scope := GlobalScope;
        end
        else
          AddToScope(viewScope, m);
      end;
    end;
    if not found then
      SemErr(item, 'unit ''' + Nodes[item].Text + ''' has no exported ''' + selName + '''');
  end;
  CurScope := savedScope;
  SelectView := viewScope;
end;

function HasKpmExt(const s: string): Boolean;
{ True when s ends with the case-insensitive suffix '.kpm'.  The length guard is a
  separate statement, not an `and` operand: `and` evaluates both sides, so a folded
  guard would still run Copy with a negative index on a short directory entry (a bare
  '.' or '..'), building a malformed string that faults. }
begin
  if Length(s) < 4 then
    HasKpmExt := False
  else
    HasKpmExt := LowerStr(Copy(s, Length(s) - 3, 4)) = '.kpm';
end;

procedure BindUnitNamed(item: LongInt; const uname, qual: string; bare: Boolean);
{ Load the named unit, record it as a direct dependency, and make its selected names visible
  either bare (aliased into the global scope) or under qual. Shared by an ordinary `uses`
  item and each unit a namespace wildcard expands to. A unit already taken as a dependency is
  bound once (so `uses io.*, io.files (...)` does not double it). }
var
  u, i, n, qn, viewScope: LongInt;
begin
  for i := 0 to DepCount - 1 do
    if LowerStr(DepName[i]) = LowerStr(uname) then Exit;
  u := LoadUnitInterface(item, uname);
  if u < 0 then Exit;
  n := DepCount;
  SetLength(DepName, n + 1); SetLength(DepFingerprint, n + 1); Inc(DepCount);
  DepName[n] := uname;
  DepFingerprint[n] := UUFingerprint[u];
  viewScope := SelectView(item, u);
  if bare then
    for i := 0 to High(Scopes[viewScope].Members) do
      AddToScope(GlobalScope, Scopes[viewScope].Members[i])
  else begin
    qn := QCount;
    SetLength(QName, qn + 1); SetLength(QScope, qn + 1); Inc(QCount);
    QName[qn] := qual;
    QScope[qn] := viewScope;
  end;
end;

procedure BindNamespaceWildcard(item: LongInt; const ns: string);
{ Expand `uses ns.*` to every unit found in the namespace directory ns across the unit search
  path (the source directory, each -U directory, then the standard library), binding each
  under its own last-segment qualifier (uses io.* -> files.*, dirs.*, console.*). Names are
  collected unique and sorted, so the dependency order is deterministic regardless of the
  directory's own order, and the first search directory that has a unit wins (as a single
  `uses` would). One level: a unit in a nested namespace directory is not reached. }
var
  d, h, i, j: LongInt;
  dir, entry, base: string;
  names: array of string;
  seen: Boolean;
begin
  SetLength(names, 0);
  for d := -1 to High(UnitPath) + 1 do begin
    if d < 0 then dir := UnitSrcDir
    else if d > High(UnitPath) then dir := KP_STDLIB
    else dir := UnitPath[d];
    if dir = '' then Continue;
    h := kpd_open(dir + DotToSlash(ns));
    if h < 0 then Continue;
    repeat
      entry := kpd_next(h);
      if entry = '' then Break;
      if HasKpmExt(entry) then begin
        base := Copy(entry, 1, Length(entry) - 4);   { strip '.kpm' }
        seen := False;
        for i := 0 to High(names) do
          if LowerStr(names[i]) = LowerStr(base) then begin seen := True; Break; end;
        if not seen then begin
          SetLength(names, Length(names) + 1);
          names[High(names)] := base;
        end;
      end;
    until False;
    kpd_close(h);
  end;
  if Length(names) = 0 then begin
    SemErr(item, 'no units found in namespace ''' + ns + '.*''');
    Exit;
  end;
  for i := 1 to High(names) do begin        { insertion sort for a deterministic dep order }
    base := names[i]; j := i - 1;
    while (j >= 0) and (LowerStr(names[j]) > LowerStr(base)) do begin
      names[j + 1] := names[j]; Dec(j);
    end;
    names[j + 1] := base;
  end;
  for i := 0 to High(names) do
    BindUnitNamed(item, ns + '.' + names[i], names[i], False);
end;

procedure BindUsesItem(item: LongInt);
{ Bind one `uses` item: a namespace wildcard expands to its units; otherwise load the unit
  and make its names visible bare (aliased into the global scope) or under a qualifier. }
var
  qnode: LongInt;
  qual, uname: string;
  bare: Boolean;
begin
  uname := Nodes[item].Text;
  if Nodes[item].Flag = 1 then begin
    BindNamespaceWildcard(item, uname);
    Exit;
  end;
  qnode := Nodes[item].A;
  bare := False;
  qual := LastSegment(uname);
  if qnode >= 0 then
    if Nodes[qnode].Text = '_' then bare := True
    else qual := Nodes[qnode].Text;
  BindUnitNamed(item, uname, qual, bare);
end;

procedure BindUses(usesNode: LongInt);
var
  i: LongInt;
begin
  if usesNode < 0 then Exit;
  for i := 0 to High(Nodes[usesNode].Kids) do
    BindUsesItem(Nodes[usesNode].Kids[i]);
end;

function IsDirectDep(const name: string): Boolean;
var
  i: LongInt;
  l: string;
begin
  IsDirectDep := False;
  l := LowerStr(name);
  for i := 0 to DepCount - 1 do
    if LowerStr(DepName[i]) = l then Exit(True);
end;

procedure ReexportName(depu: LongInt; nameNode: LongInt; const uname: string);
{ Record every export of dependency depu whose name matches nameNode as a re-exported
  symbol of this unit. An empty match is an error. }
var
  i, m: LongInt;
  found: Boolean;
begin
  found := False;
  for i := 0 to High(Scopes[UUScope[depu]].Members) do begin
    m := Scopes[UUScope[depu]].Members[i];
    if Syms[m].LowerName = LowerStr(Nodes[nameNode].Text) then begin
      found := True;
      SetLength(ReexportSym, ReexportCount + 1);
      ReexportSym[ReexportCount] := m;
      Inc(ReexportCount);
    end;
  end;
  if not found then
    SemErr(nameNode, 'unit ''' + uname + ''' has no exported ''' +
      Nodes[nameNode].Text + '''');
end;

procedure ProcessReexports(intf: LongInt);
{ Promote names a unit re-exports from its dependencies into its own interface surface. A
  re-exported name keeps its dependency's definition (and link name); this unit only makes
  it visible to its own consumers. The dependency must be one this unit directly uses. An
  item with no name list re-exports the whole dependency. }
var
  i, k, depu, j, c: LongInt;
  it: LongInt;
begin
  for i := 0 to High(Nodes[intf].Kids) do begin
    k := Nodes[intf].Kids[i];
    if Nodes[k].Kind <> nkReexport then Continue;
    for j := 0 to High(Nodes[k].Kids) do begin
      it := Nodes[k].Kids[j];
      if not IsDirectDep(Nodes[it].Text) then begin
        SemErr(it, 'reexport of ''' + Nodes[it].Text +
          ''' requires it in the unit''s uses clause');
        Continue;
      end;
      depu := UUFind(Nodes[it].Text);
      if depu < 0 then Continue;
      if High(Nodes[it].Kids) < 0 then
        { a bare item re-exports the whole dependency }
        for c := 0 to High(Scopes[UUScope[depu]].Members) do begin
          SetLength(ReexportSym, ReexportCount + 1);
          ReexportSym[ReexportCount] := Scopes[UUScope[depu]].Members[c];
          Inc(ReexportCount);
        end
      else
        for c := 0 to High(Nodes[it].Kids) do
          ReexportName(depu, Nodes[it].Kids[c], Nodes[it].Text);
    end;
  end;
end;

procedure Analyze(prog: LongInt);
begin
  InitSema;
  if prog < 0 then Exit;
  if Nodes[prog].Kind = nkProgram then begin
    CompilingUnitName := Nodes[prog].Text;
    BindUses(Nodes[prog].B);
    AnalyzeBlock(Nodes[prog].A);
    CheckImplements(Nodes[prog].A);   { conformance assertions, after methods are registered }
  end
  else if Nodes[prog].Kind = nkUnit then begin
    CompilingUnitName := Nodes[prog].Text;
    BindUses(Nodes[prog].A);
    AnalyzeUnit(prog);
  end;
end;

{ ---- IR (Skjegg 3AC) and the KPM1 writer ---- }
{ Lowers the analyzed AST to a Skjegg-modeled three-address IR and serializes it
  as a KPM1 text module (doc/languages/kobold/kp-module-format.md, REF/ir.md). This first increment
  covers the integer and boolean scalar language: program globals and routine
  slots, integer arithmetic, bitwise and shift, comparisons, control flow,
  external-routine calls, and integer returns. Reals, strings, sets, records,
  arrays, handles, methods, nested-routine capture, and coroutines are later
  increments. Each instruction is stored as its mnemonic plus a pre-formatted
  operand string, so the writer only lays out lines. }

type
  TIrInsn = record
    Op: string;
    Args: string;
  end;

  TIrFunc = record
    Name: string;
    IsLocal: Boolean;
    Nparams, Ntemps, Nlabels: LongInt;
    SlotSize: array of LongInt;     { one entry per slot; Length = nslots }
    ParamClass: array of LongInt;   { 0 int/pointer, 1 float; one per param }
    ParamFW: array of LongInt;      { 1 = a single-precision (f32) float param, else 0 }
    Insns: array of TIrInsn;
    NInsns: LongInt;
  end;

  TIrGlobal = record
    Name: string;
    BaseType: string;
    ArrSize: LongInt;               { element count, 0 for a scalar }
    HasInit: Boolean;               { an f64 constant-pool entry }
    InitBits: Int64;                { the f64 bit pattern when HasInit }
    HasStr: Boolean;                { a string-literal byte blob }
    InitStr: string;                { the literal bytes when HasStr }
    IsStrObj: Boolean;              { a static string object: the backend emits the
                                      refcount/kind/len header in target endianness, then
                                      InitStr as the text.  Keeps the descriptor endian-correct
                                      on a big-endian target rather than baking it here. }
    InitVals: TInt64Array;          { a typed word array: one .init per value, emitted at
                                      BaseType's width in target endianness }
    Exported: Boolean;              { a unit's exported var, visible to other modules at link }
    ReadOnly: Boolean;             { an immutable global: laid out in a read-only region }
  end;

  TIrMethod = record
    MName: string;
    ParamCls: array of string;      { the declared params; the receiver is implicit }
    RetCls: string;
  end;

  TIrImport = record
    Name: string;
    IsHelper: Boolean;              { a runtime helper vs a host function }
    IsType: Boolean;               { a host handle (interface) type }
    ParamCls: array of string;
    RetCls: string;
    Methods: array of TIrMethod;    { for IsType: the vtable, in slot order }
  end;

var
  IrFuncs: array of TIrFunc;
  IrFuncCount: LongInt;
  IrGlobals: array of TIrGlobal;
  IrGlobalCount: LongInt;
  IrImports: array of TIrImport;
  IrImportCount: LongInt;
  IrExports: array of string;
  IrExportCount: LongInt;
  ModLines: array of string;    { the KPM1 module text, one line per element (no newline) }
  ModLineCount: LongInt;
  NeedGlobalInit: Boolean;      { the program has const-array globals whose setup (__init)
                                  every entry point must run before it touches them }
  ModIsUnit: Boolean;           { the compilation unit is a `unit`, emitted as an object module }
  ModUnitNode: LongInt;         { the nkUnit node when ModIsUnit, for the interface section }
  CurFn: LongInt;               { index into IrFuncs of the function being lowered }
  CurResultSlot: LongInt;       { function result slot, or -1 in a procedure }
  CurCancelLabel: LongInt;      { cancel-unwind cleanup label for a yielding routine,
                                  or -1 when the routine has no yield (cancel-by-unwind) }
  CurExitLabel: LongInt;        { the routine's scope-exit label; `Exit` jumps here so the
                                  handle-local releases and the return run, or -1 outside a body }
  CurExitFunc: LongInt;         { the current function symbol for Exit(value), or -1 }
  CurErrorSlot: LongInt;        { a failable routine's error-result slot (0 = success, set by
                                  `fail`/`or fail`); the epilogue returns it beside the value, -1
                                  in a non-failable routine }
  FailCaptureSlot: LongInt;     { during the lowering of a failable call, the local slot the
                                  callee's error is stored into (CALL2), else -1 }
  CanYield: array of Boolean;   { per routine sym: the body suspends directly or through
                                  a call, so it can sit on a coroutine's suspended stack }
  StmtSuspended: Boolean;       { set while lowering a statement that called a CanYield
                                  routine, so the compound loop adds a cancel check after }
  LoopBreak: array of LongInt;  { break/continue target label stack }
  LoopCont: array of LongInt;
  LoopSP: LongInt;
  LoopDeferBase: array of LongInt; { per loop: open defer-scope count at loop entry, the break/continue unwind floor }
  DeferNodes: array of LongInt;    { flat stack of deferred statement nodes across the open defer scopes }
  DeferCount: LongInt;             { entries in use in DeferNodes }
  DeferScopeBase: array of LongInt; { per open defer scope: its start index in DeferNodes }
  DeferScopeSP: LongInt;           { number of open defer scopes }
  PendingMapInsert: LongInt;    { the nkIndex node of a map assignment target: AddrOf inserts
                                  the key (kp_map_reserve) for exactly that node, else reads it
                                  (kp_map_get); -1 when no map assignment is in progress }
  { Nested-routine capture. RoutineCaptures[rSym] is the ordered list of enclosing
    variables a routine threads as hidden by-pointer parameters. CallsOf[rSym] is
    the routines it calls (for propagating captures across the call graph). CapSlot[v]
    is the hidden pointer slot for a captured variable v in the routine being
    lowered, or -1 when v is not captured here. }
  RoutineCaptures: array of TIntArray;
  CallsOf: array of TIntArray;
  CapSlot: array of LongInt;
  { Deferred lowering of `start begin..end` block bodies. Each is lifted to a
    synthesized parameterless entry function, lowered after the routine that spawns
    it (when the loop state and CurFn are free). The parallel arrays hold the entry
    name and the compound body; StartEntrySeq numbers the synthesized names. }
  StartQueueName: array of string;
  StartQueueBody: array of LongInt;
  StartQueueCount: LongInt;
  StartEntrySeq: LongInt;
  { Deferred lowering of coroutine seed-argument entry thunks. `start worker(args)`
    stores its by-value seed arguments in a small buffer and spawns a synthesized
    thunk whose runtime ABI is entry(vm, argsp, nargs). The thunk reads the buffer
    back into typed values and calls the worker with the routine calling convention,
    bridging the two. The parallel arrays hold the thunk name and the worker symbol. }
  CoThunkName: array of string;
  CoThunkWorker: array of LongInt;
  CoThunkCount: LongInt;

{ Forward declarations for the mutually recursive lowering. }
function LowerExpr(node: LongInt): LongInt; forward;
function IsOwnedExpr(node: LongInt): Boolean; forward;
function AsFloat(node: LongInt): LongInt; forward;
function AsInt64(node: LongInt): LongInt; forward;
function AsStr(node: LongInt): LongInt; forward;
function AddrOf(node: LongInt): LongInt; forward;
function MapSlotAddr(node: LongInt; insert: Boolean): LongInt; forward;
function DynElemAddr(node: LongInt; var baseHandle: LongInt): LongInt; forward;
function AddOff(addr, off: LongInt): LongInt; forward;
procedure CollectHandleOffsets(ty, baseOff: LongInt; var offs: TIntArray); forward;
function LowerResume(callee: LongInt; const argNodes: array of LongInt): LongInt; forward;
function LowerSet(node: LongInt): LongInt; forward;
function LowerSetBinary(node: LongInt): LongInt; forward;
procedure LowerSetInto(node, dst, nwords: LongInt); forward;
function LowerSetValue(node: LongInt): LongInt; forward;
function LowerSetAddr(node: LongInt): LongInt; forward;
procedure LowerStmt(node: LongInt); forward;

{ ---- defer scopes (doc/languages/kobold/kp-defer.md) ----
  A `defer STMT` registers STMT for teardown at the end of its lexical block,
  run LIFO on every orderly exit: block fall-through, exit, break, continue, and
  the failable diverts. A deferred statement is re-lowered at each exit edge
  (there are no block-scoped locals, so this needs no runtime defer stack). A
  trap/panic bypasses the exit edges and so skips defers, by design. }

procedure PushDeferScope;
begin
  if DeferScopeSP > High(DeferScopeBase) then SetLength(DeferScopeBase, DeferScopeSP + 8);
  DeferScopeBase[DeferScopeSP] := DeferCount;
  Inc(DeferScopeSP);
end;

procedure RegisterDefer(stmt: LongInt);
begin
  if DeferCount > High(DeferNodes) then SetLength(DeferNodes, DeferCount + 8);
  DeferNodes[DeferCount] := stmt;
  Inc(DeferCount);
end;

function DeferScopeEnd(i: LongInt): LongInt;
begin
  if i + 1 < DeferScopeSP then DeferScopeEnd := DeferScopeBase[i + 1]
  else DeferScopeEnd := DeferCount;
end;

procedure EmitScopeDefers(i: LongInt);
{ re-lower defer scope i's statements in LIFO (reverse registration) order }
var j: LongInt;
begin
  for j := DeferScopeEnd(i) - 1 downto DeferScopeBase[i] do
    LowerStmt(DeferNodes[j]);
end;

procedure EmitDeferUnwind(toSP: LongInt);
{ emit the defers of every open scope from the innermost down to (and including)
  toSP, for an exit path (break/continue/exit/fail). It does NOT pop: the lexical
  block ends still own the stack and the fall-through path still needs it. }
var i: LongInt;
begin
  for i := DeferScopeSP - 1 downto toSP do
    EmitScopeDefers(i);
end;

procedure PopDeferScope;
{ emit this scope's defers for the fall-through path, then drop the scope }
begin
  EmitScopeDefers(DeferScopeSP - 1);
  Dec(DeferScopeSP);
  DeferCount := DeferScopeBase[DeferScopeSP];
end;
function EmittedRoutineName(s: LongInt): string; forward;
function LowerDirectCall(s: LongInt; const argNodes: array of LongInt;
  wantVal: Boolean): LongInt; forward;
function LowerMethodCall(field: LongInt; const argNodes: array of LongInt;
  wantVal: Boolean): LongInt; forward;

function PadOp(const op: string): string;
begin
  if Length(op) >= 4 then PadOp := op else PadOp := op + Spaces(4 - Length(op));
end;

function IsRealType(ty: LongInt): Boolean;
begin
  IsRealType := (ty >= 0) and (ty < SemCount) and (SemTypes[ty].Kind = skReal);
end;

function IsSingle(ty: LongInt): Boolean;
{ A single-precision real: 4 bytes in memory, loaded and stored through FLS/FSS which widen to
  and narrow from the f64 held in registers. Computation is done in f64. }
begin
  IsSingle := IsRealType(ty) and (SemTypes[ty].FloatBits = 32);
end;

function IsInt64(ty: LongInt): Boolean;
{ A 64-bit integer: 8 bytes in memory, held and computed as a full 64-bit register value
  through the *64 opcodes, unlike the 32-bit `integer`. A subrange never widens to 64 bits. }
begin
  IsInt64 := (ty >= 0) and (ty < SemCount) and
    (SemTypes[ty].Kind = skInteger) and (SemTypes[ty].IntBits = 64);
end;

function Wide64(ty: LongInt): Boolean;
{ A value that occupies a full 64-bit word and travels the 64-bit storage and call path
  (LDL64/STL64/LD64/ST64, ARG64/RETV64, CALL64): a small set bitmask or a 64-bit integer.
  This is only about width, not the arithmetic opcodes, which differ for the two. }
begin
  Wide64 := IsSmallSet(ty) or IsInt64(ty);
end;

function IsDynArray(ty: LongInt): Boolean;
{ A dynamic array: an skArray with no index subranges. Its value is a reference-counted
  handle id, not an inline block. Covers the value `array of T` and the host-backed
  `buffer of T`, which IsBuffer tells apart. }
begin
  IsDynArray := (ty >= 0) and (ty < SemCount) and
    (SemTypes[ty].Kind = skArray) and (Length(SemTypes[ty].Subs) = 0);
end;

function IsBuffer(ty: LongInt): Boolean;
{ A `buffer of T`: a reference dynamic array whose element backing is host-owned, so ARC
  never frees it and the guest cannot resize it. }
begin
  IsBuffer := IsDynArray(ty) and SemTypes[ty].HostBuf;
end;
function IsMap(ty: LongInt): Boolean;
{ A `map[K] of T`: an associative array. Its value is a reference-counted handle id, like a
  dynamic array, with value (eager-copy) assignment semantics. }
begin
  IsMap := (ty >= 0) and (ty < SemCount) and (SemTypes[ty].Kind = skMap);
end;

function MapKeyType(ty: LongInt): LongInt;
{ The key type of a map type (Subs[0]). A string key uses the handle-keyed runtime (kp_map_*);
  any other (ordinal) key uses the value-keyed runtime (kp_imap_*), so MapKeyType = tyStr is the
  one test that distinguishes the two lowerings. Defaults to tyStr defensively. }
begin
  if IsMap(ty) and (Length(SemTypes[ty].Subs) > 0) then MapKeyType := SemTypes[ty].Subs[0]
  else MapKeyType := tyStr;
end;

function BufRank(ty: LongInt): LongInt;
{ A buffer's dimension count: 1 for `buffer of T`, 2 for `buffer[,] of T`, and so on. A
  multidimensional buffer is one strided host region, indexed b[i, j, ...] with as many
  subscripts as its rank. Returns 1 for any non-buffer dynamic array. }
begin
  if IsBuffer(ty) and (SemTypes[ty].Rank > 1) then BufRank := SemTypes[ty].Rank
  else BufRank := 1;
end;

function IsEmptyArrayLit(node: LongInt): Boolean;
{ The empty constructor `[]`, which stands for an empty array when the target is a
  dynamic array (an empty, nil handle) rather than a set. }
begin
  IsEmptyArrayLit := (Nodes[node].Kind = nkSetConstructor) and
    (Length(Nodes[node].Kids) = 0);
end;

function IsHandle(ty: LongInt): Boolean;
{ A reference-counted handle id: an interface, a string, a process, or a dynamic array. }
begin
  IsHandle := ((ty >= 0) and (ty < SemCount) and
    (SemTypes[ty].Kind in [skInterface, skString, skProcess, skMapIter])) or
    IsDynArray(ty) or IsMap(ty);
end;

function IsPtrSized(ty: LongInt): Boolean;
{ A value lowered as one guest pointer/handle word, CurTarget.PtrBytes wide: any
  reference-counted handle, a procedure/function value, or a `label` code address
  (threaded dispatch). These are 4 bytes under ILP32 (rv32/cf/mips) and 8 under
  LP64 (x86-64/arm64), unlike a genuine 32-bit scalar (int/bool/char/enum), which
  stays 4 on every target. A label holds a native code address, so under LP64,
  where the JIT maps guest code anywhere in the 64-bit space, it must be a full
  8-byte word or a stored @name truncates. }
begin
  IsPtrSized := IsHandle(ty) or
    ((ty >= 0) and (ty < SemCount) and
     ((SemTypes[ty].Kind = skProc) or (SemTypes[ty].Kind = skLabel)));
end;

function WideStore(ty: LongInt): Boolean;
{ A value that occupies a full 64-bit word in storage and on the call path, so it
  uses the *64 opcodes (LD64/ST64, LDL64/STL64, ARG64/RETV64, CALL64, an 8-byte
  slot): a Wide64 value (a small set or an Int64, 64-bit on every target) or, under
  LP64, a pointer/handle word (IsPtrSized at PtrBytes = 8). Under ILP32 a handle is
  4 bytes, so this reduces to Wide64 and every site keyed on it is byte-identical. }
begin
  WideStore := Wide64(ty) or (IsPtrSized(ty) and (CurTarget.PtrBytes = 8));
end;

{ ---- Real-literal to binary64, in integer arithmetic ----
  A real constant's f64 bit pattern is computed from its decimal text with the
  TBig helpers below, never through a host Double. On the single-float sandbox
  tier a Double is only 4 bytes, so reinterpreting one as an Int64 read garbage
  high bits; computing the bits with integers makes the result the same on every
  tier and keeps the self-hosting fixed point. The result is correctly rounded
  (round to nearest, ties to even), matching a correct strtod. }

procedure BigNorm(var a: TBig);
begin
  while (a.n > 0) and (a.d[a.n - 1] = 0) do Dec(a.n);
end;

procedure BigSetSmall(var a: TBig; v: LongInt);
begin
  a.n := 0;
  while v > 0 do begin
    a.d[a.n] := v and $FFFF;
    v := v shr 16;
    Inc(a.n);
  end;
end;

procedure BigCopy(var dst: TBig; var src: TBig);
var i: LongInt;
begin
  dst.n := src.n;
  for i := 0 to src.n - 1 do dst.d[i] := src.d[i];
end;

{ a := a * m, where m is small (a single decimal digit's multiplier, <= 10). }
procedure BigMulSmall(var a: TBig; m: LongInt);
var i, carry, p: LongInt;
begin
  carry := 0;
  for i := 0 to a.n - 1 do begin
    p := a.d[i] * m + carry;
    a.d[i] := p and $FFFF;
    carry := p shr 16;
  end;
  while carry > 0 do begin
    a.d[a.n] := carry and $FFFF;
    carry := carry shr 16;
    Inc(a.n);
  end;
end;

{ a := a + v, where v is a single decimal digit (0..9). }
procedure BigAddSmall(var a: TBig; v: LongInt);
var i, s: LongInt;
begin
  i := 0;
  s := v;
  while s > 0 do begin
    if i >= a.n then begin a.d[i] := 0; a.n := i + 1; end;
    s := a.d[i] + s;
    a.d[i] := s and $FFFF;
    s := s shr 16;
    Inc(i);
  end;
end;

procedure BigShlBits(var a: TBig; bits: LongInt);
var limbShift, bitShift, i: LongInt;
begin
  if a.n = 0 then Exit;
  limbShift := bits div 16;
  bitShift := bits mod 16;
  if limbShift > 0 then begin
    for i := a.n - 1 downto 0 do a.d[i + limbShift] := a.d[i];
    for i := 0 to limbShift - 1 do a.d[i] := 0;
    a.n := a.n + limbShift;
  end;
  if bitShift > 0 then begin
    a.d[a.n] := 0;
    for i := a.n downto 1 do
      a.d[i] := ((a.d[i] shl bitShift) or (a.d[i - 1] shr (16 - bitShift))) and $FFFF;
    a.d[0] := (a.d[0] shl bitShift) and $FFFF;
    a.n := a.n + 1;
    BigNorm(a);
  end;
end;

function BigCmp(var a: TBig; var b: TBig): LongInt;
var i: LongInt;
begin
  if a.n <> b.n then begin
    if a.n < b.n then BigCmp := -1 else BigCmp := 1;
    Exit;
  end;
  for i := a.n - 1 downto 0 do
    if a.d[i] <> b.d[i] then begin
      if a.d[i] < b.d[i] then BigCmp := -1 else BigCmp := 1;
      Exit;
    end;
  BigCmp := 0;
end;

{ a := a - b, requires a >= b. }
procedure BigSub(var a: TBig; var b: TBig);
var i, borrow, x: LongInt;
begin
  borrow := 0;
  for i := 0 to a.n - 1 do begin
    x := a.d[i] - borrow;
    if i < b.n then x := x - b.d[i];
    if x < 0 then begin x := x + 65536; borrow := 1; end
    else borrow := 0;
    a.d[i] := x;
  end;
  BigNorm(a);
end;

function BigBitLen(var a: TBig): LongInt;
var top, k: LongInt;
begin
  if a.n = 0 then begin BigBitLen := 0; Exit; end;
  top := a.d[a.n - 1];
  k := 0;
  while top > 0 do begin top := top shr 1; Inc(k); end;
  BigBitLen := (a.n - 1) * 16 + k;
end;

function BigBit(var a: TBig; i: LongInt): LongInt;
var limb, off: LongInt;
begin
  limb := i div 16;
  off := i mod 16;
  if limb >= a.n then BigBit := 0
  else BigBit := (a.d[limb] shr off) and 1;
end;

{ Q := floor(N / D) (which the callers keep below 2^55, so it fits Int64);
  rem := N - Q*D. Bitwise long division, MSB to LSB. }
function BigDivInt(var N: TBig; var D: TBig; var rem: TBig): Int64;
var i, nb: LongInt; Q: Int64;
begin
  rem.n := 0;
  Q := 0;
  nb := BigBitLen(N);
  for i := nb - 1 downto 0 do begin
    BigShlBits(rem, 1);
    if BigBit(N, i) = 1 then begin
      if rem.n = 0 then begin rem.d[0] := 1; rem.n := 1; end
      else rem.d[0] := rem.d[0] or 1;
    end;
    Q := Q shl 1;
    if BigCmp(rem, D) >= 0 then begin
      BigSub(rem, D);
      Q := Q + 1;
    end;
  end;
  BigDivInt := Q;
end;

function RealLitBits(const s: string): Int64;
var
  sig, num, den, numS, denS, rem: TBig;
  i, ln, fd, ex, exSign, decExp, E, c, digit, guard: LongInt;
  inFrac, roundUp: Boolean;
  Q, two52, two53, biased, infbits: Int64;
begin
  two52 := 4503599627370496;    { 2^52 }
  two53 := 9007199254740992;    { 2^53 }

  { parse significand digits (integer and fraction) and the decimal exponent }
  BigSetSmall(sig, 0);
  fd := 0; ex := 0; exSign := 1; inFrac := False;
  i := 1; ln := Length(s);
  while (i <= ln) and (s[i] <> 'e') and (s[i] <> 'E') do begin
    if s[i] = '.' then inFrac := True
    else begin
      digit := Ord(s[i]) - Ord('0');
      BigMulSmall(sig, 10);
      BigAddSmall(sig, digit);
      if inFrac then Inc(fd);
    end;
    Inc(i);
  end;
  if (i <= ln) and ((s[i] = 'e') or (s[i] = 'E')) then begin
    Inc(i);
    if (i <= ln) and (s[i] = '+') then Inc(i)
    else if (i <= ln) and (s[i] = '-') then begin exSign := -1; Inc(i); end;
    while i <= ln do begin
      ex := ex * 10 + (Ord(s[i]) - Ord('0'));
      Inc(i);
    end;
  end;
  ex := ex * exSign;
  decExp := ex - fd;              { value = sig * 10^decExp }

  BigNorm(sig);
  if sig.n = 0 then begin RealLitBits := 0; Exit; end;

  { value = num / den as an exact rational }
  if decExp >= 0 then begin
    BigCopy(num, sig);
    for c := 1 to decExp do BigMulSmall(num, 10);
    BigSetSmall(den, 1);
  end else begin
    BigCopy(num, sig);
    BigSetSmall(den, 1);
    for c := 1 to -decExp do BigMulSmall(den, 10);
  end;

  { choose E so the quotient has 53 bits (normal) or E bottoms out at the
    subnormal floor; value ~= 2^(bitlen(num)-bitlen(den)). }
  E := BigBitLen(num) - BigBitLen(den) - 53;
  Q := 0;
  guard := 0;
  while guard < 16 do begin
    Inc(guard);
    BigCopy(numS, num);
    BigCopy(denS, den);
    if E >= 0 then BigShlBits(denS, E)
    else BigShlBits(numS, -E);
    Q := BigDivInt(numS, denS, rem);
    if Q >= two53 then Inc(E)
    else if (Q < two52) and (E > -1074) then Dec(E)
    else break;
  end;

  { round to nearest, ties to even, using the division remainder }
  BigShlBits(rem, 1);
  BigNorm(rem);
  BigNorm(denS);
  c := BigCmp(rem, denS);
  roundUp := False;
  if c > 0 then roundUp := True
  else if c = 0 then roundUp := ((Q and 1) = 1);
  if roundUp then Q := Q + 1;
  if Q = two53 then begin Q := two52; Inc(E); end;

  biased := E + 1075;
  if biased >= 2047 then begin
    infbits := 2047;
    RealLitBits := infbits shl 52;         { +inf, unreachable for real literals }
    Exit;
  end;
  if Q < two52 then
    RealLitBits := Q                        { subnormal or zero: exponent field 0 }
  else
    RealLitBits := (biased shl 52) or (Q - two52);
end;

function IsAggregate(ty: LongInt): Boolean;
{ An inline value block addressed and copied by assignment: a record, a fixed array, or a
  large set (a 2-4 word blob). A dynamic array is a handle, and a small set is a register
  i64 value, so neither is an aggregate. }
begin
  IsAggregate := (ty >= 0) and (ty < SemCount) and
    ((SemTypes[ty].Kind = skRecord) or
     ((SemTypes[ty].Kind = skArray) and (Length(SemTypes[ty].Subs) > 0)) or
     ((SemTypes[ty].Kind = skSet) and (SetWords(ty) > 1)));
end;

function FailWideResult(sig: LongInt): Boolean;
{ True when a failable routine's result is returned through caller storage (an sret-style
  hidden pointer) rather than the integer value register: a real, a 64-bit value (int64 or a
  small set), or an aggregate (record, fixed array, or large set). The error then returns in
  the ordinary integer register and the value lands in the caller's buffer. An integer-class
  result keeps the two-register RETV2/CALL2 fast path (doc/languages/kobold/kp-errors.md). }
begin
  FailWideResult := False;
  if (sig < 0) or (sig >= SemCount) or (SemTypes[sig].Kind <> skProc) or
     not SemTypes[sig].Failable then Exit;
  if SemTypes[sig].RetType < 0 then Exit;
  FailWideResult := IsRealType(SemTypes[sig].RetType) or WideStore(SemTypes[sig].RetType) or
    IsAggregate(SemTypes[sig].RetType);
end;

function ParamByRef(s: LongInt): Boolean;
{ True when parameter s occupies a pointer slot rather than holding its value: an
  aggregate (addressed in place), or a scalar `var`/`out` parameter (mode 1 or 3). }
begin
  ParamByRef := (Syms[s].Kind = syParam) and
    (IsAggregate(Syms[s].TypeId) or
     (Syms[s].ParamMode = 1) or (Syms[s].ParamMode = 3));
end;

{ ---- aggregate layout ---- }
{ A scalar occupies 4 bytes, a real 8. A record lays its fields out in order,
  each aligned to its own alignment, and rounds its size up to its alignment. An
  array is a dense row-major block of its element type. Forward declared because
  size and alignment recur through records and arrays. }
function RoundUp(x, a: LongInt): LongInt;
begin
  RoundUp := ((x + a - 1) div a) * a;
end;

function TypeAlign(ty: LongInt): LongInt;
var
  i, m: LongInt;
begin
  if (ty >= 0) and (ty < SemCount) and (SemTypes[ty].Align >= 0) then
    begin TypeAlign := SemTypes[ty].Align; Exit; end;   { a reconstructed opaque record }
  if IsSingle(ty) then begin TypeAlign := 4; Exit; end;
  if IsRealType(ty) then begin TypeAlign := 8; Exit; end;
  if IsInt64(ty) then begin TypeAlign := 8; Exit; end;
  if (ty < 0) or (ty >= SemCount) then begin TypeAlign := 4; Exit; end;
  if IsPtrSized(ty) then begin TypeAlign := CurTarget.PtrBytes; Exit; end;   { handle / code pointer }
  case SemTypes[ty].Kind of
    skSet: TypeAlign := 8;   { a small set is an i64 word }
    skArray: TypeAlign := TypeAlign(SemTypes[ty].Base);
    skRecord: begin
      m := 4;
      for i := 0 to High(SemTypes[ty].Subs) do
        if ((i > High(SemTypes[ty].PropGet)) or (SemTypes[ty].PropGet[i] = '')) and
           (TypeAlign(SemTypes[ty].Subs[i]) > m) then   { a computed field has no storage }
          m := TypeAlign(SemTypes[ty].Subs[i]);
      TypeAlign := m;
    end;
  else
    TypeAlign := 4;
  end;
end;

function TypeSize(ty: LongInt): LongInt;
var
  i, off, count, sub: LongInt;
begin
  if (ty >= 0) and (ty < SemCount) and (SemTypes[ty].Size >= 0) then
    begin TypeSize := SemTypes[ty].Size; Exit; end;   { a reconstructed opaque record }
  if IsSingle(ty) then begin TypeSize := 4; Exit; end;
  if IsRealType(ty) then begin TypeSize := 8; Exit; end;
  if IsInt64(ty) then begin TypeSize := 8; Exit; end;
  if (ty < 0) or (ty >= SemCount) then begin TypeSize := 4; Exit; end;
  if IsPtrSized(ty) then begin TypeSize := CurTarget.PtrBytes; Exit; end;   { handle / code pointer }
  case SemTypes[ty].Kind of
    skSet: TypeSize := SetWords(ty) * 8;   { a small set is one i64 word, a large set 2-4 }
    skArray: begin
      count := 1;
      for i := 0 to High(SemTypes[ty].Subs) do begin
        sub := SemTypes[ty].Subs[i];
        count := count * (SemTypes[sub].Hi - SemTypes[sub].Lo + 1);
      end;
      TypeSize := TypeSize(SemTypes[ty].Base) * count;
    end;
    skRecord: begin
      { the record spans to the end of its widest field; with variants that overlay,
        summing sizes would overcount, so use each field's stored offset plus its size }
      off := 0;
      if Length(SemTypes[ty].MemberOff) = Length(SemTypes[ty].Subs) then begin
        for i := 0 to High(SemTypes[ty].Subs) do
          if SemTypes[ty].MemberOff[i] >= 0 then begin   { a computed field has no storage }
            sub := SemTypes[ty].MemberOff[i] + TypeSize(SemTypes[ty].Subs[i]);
            if sub > off then off := sub;
          end;
      end
      else
        for i := 0 to High(SemTypes[ty].Subs) do begin
          off := RoundUp(off, TypeAlign(SemTypes[ty].Subs[i]));
          off := off + TypeSize(SemTypes[ty].Subs[i]);
        end;
      TypeSize := RoundUp(off, TypeAlign(ty));
    end;
  else
    TypeSize := 4;
  end;
end;

function FieldOffset(recTy, m: LongInt): LongInt;
{ Byte offset of field m within its record, from the layout computed at type resolution
  (variant fields overlay, so offsets are stored rather than re-summed here). }
var
  i, off: LongInt;
begin
  if (m >= 0) and (m <= High(SemTypes[recTy].MemberOff)) then begin
    FieldOffset := SemTypes[recTy].MemberOff[m];
    Exit;
  end;
  off := 0;
  for i := 0 to m do begin
    off := RoundUp(off, TypeAlign(SemTypes[recTy].Subs[i]));
    if i = m then begin FieldOffset := off; Exit; end;
    off := off + TypeSize(SemTypes[recTy].Subs[i]);
  end;
  FieldOffset := off;
end;

{ ---- IR builders (operate on the current function) ---- }

function NewTemp: LongInt;
begin
  NewTemp := IrFuncs[CurFn].Ntemps;
  Inc(IrFuncs[CurFn].Ntemps);
end;

function NewLabel: LongInt;
begin
  NewLabel := IrFuncs[CurFn].Nlabels;
  Inc(IrFuncs[CurFn].Nlabels);
end;

function NewSlot(size: LongInt): LongInt;
var
  n: LongInt;
begin
  n := Length(IrFuncs[CurFn].SlotSize);
  SetLength(IrFuncs[CurFn].SlotSize, n + 1);
  IrFuncs[CurFn].SlotSize[n] := size;
  NewSlot := n;
end;

procedure PushInsn(const op, args: string);
var
  n: LongInt;
begin
  n := IrFuncs[CurFn].NInsns;
  SetLength(IrFuncs[CurFn].Insns, n + 1);
  IrFuncs[CurFn].Insns[n].Op := op;
  IrFuncs[CurFn].Insns[n].Args := args;
  Inc(IrFuncs[CurFn].NInsns);
end;

function EmitLIC(imm: Int64): LongInt;
var
  d: LongInt;
begin
  d := NewTemp;
  PushInsn('LIC', 'dst=' + IntToStr(d) + ' imm=' + IntToStr(imm));
  EmitLIC := d;
end;

function EmitLEA(const sym: string): LongInt;
{ A symbol's address. An address is pointer-width, so this is LEA64 under LP64
  (the full 64-bit address) and the narrow LEA under ILP32. Every caller wants an
  address, so the choice lives here rather than at each site. }
var
  d: LongInt;
begin
  d := NewTemp;
  if CurTarget.PtrBytes = 8 then
    PushInsn('LEA64', 'dst=' + IntToStr(d) + ' sym=' + sym)
  else
    PushInsn('LEA', 'dst=' + IntToStr(d) + ' sym=' + sym);
  EmitLEA := d;
end;

function EmitLDL(slot: LongInt): LongInt;
var
  d: LongInt;
begin
  d := NewTemp;
  PushInsn('LDL', 'dst=' + IntToStr(d) + ' slot=' + IntToStr(slot));
  EmitLDL := d;
end;

function EmitADL(slot: LongInt): LongInt;
{ The address of a stack slot. An address is pointer-width, so this is ADL64 under
  LP64 and the narrow ADL under ILP32; every caller wants a slot address. }
var
  d: LongInt;
begin
  d := NewTemp;
  if CurTarget.PtrBytes = 8 then
    PushInsn('ADL64', 'dst=' + IntToStr(d) + ' slot=' + IntToStr(slot))
  else
    PushInsn('ADL', 'dst=' + IntToStr(d) + ' slot=' + IntToStr(slot));
  EmitADL := d;
end;

procedure EmitSTL(a, slot: LongInt);
begin
  PushInsn('STL', 'a=' + IntToStr(a) + ' slot=' + IntToStr(slot));
end;

function EmitLW(a: LongInt): LongInt;
var
  d: LongInt;
begin
  d := NewTemp;
  PushInsn('LW', 'dst=' + IntToStr(d) + ' a=' + IntToStr(a));
  EmitLW := d;
end;

procedure EmitSW(addr, val: LongInt);
begin
  PushInsn('SW', 'a=' + IntToStr(addr) + ' b=' + IntToStr(val));
end;

function EmitLB(a: LongInt): LongInt;
{ Load one byte, zero-extended, from a guest address. Used to read a string character. }
var
  d: LongInt;
begin
  d := NewTemp;
  PushInsn('LB', 'dst=' + IntToStr(d) + ' a=' + IntToStr(a));
  EmitLB := d;
end;

function EmitUn(const op: string; a: LongInt): LongInt;
var
  d: LongInt;
begin
  d := NewTemp;
  PushInsn(op, 'dst=' + IntToStr(d) + ' a=' + IntToStr(a));
  EmitUn := d;
end;

function EmitBin(const op: string; a, b: LongInt): LongInt;
var
  d: LongInt;
begin
  d := NewTemp;
  PushInsn(op, 'dst=' + IntToStr(d) + ' a=' + IntToStr(a) + ' b=' + IntToStr(b));
  EmitBin := d;
end;

function PtrAddOp: string;
{ The address-addition opcode for this target: ADD64 under LP64, so adding a byte
  offset to a 64-bit address keeps all 64 bits, and the narrow 32-bit ADD under
  ILP32. Byte-offset arithmetic on an address goes through this, never a bare ADD. }
begin
  if CurTarget.PtrBytes = 8 then PtrAddOp := 'ADD64' else PtrAddOp := 'ADD';
end;

function AddrAdd(addr, delta: LongInt): LongInt;
{ Add a register byte offset to an address, in address width (ADD64 under LP64).
  The offset comes from 32-bit index arithmetic whose result is zero-extended in
  its register, so a non-negative delta is correct under ADD64. }
begin
  AddrAdd := EmitBin(PtrAddOp, addr, delta);
end;

procedure EmitLabel(l: LongInt);
begin
  PushInsn('LABEL', 'label=' + IntToStr(l));
end;

procedure EmitJmp(l: LongInt);
begin
  PushInsn('JMP', 'label=' + IntToStr(l));
end;

function EmitLabAddr(l: LongInt): LongInt;
{ materialize the address of local code label l into a temp (threaded dispatch) }
var
  d: LongInt;
begin
  d := NewTemp;
  PushInsn('LABADDR', 'dst=' + IntToStr(d) + ' label=' + IntToStr(l));
  EmitLabAddr := d;
end;

procedure EmitIJmp(a: LongInt);
{ an indirect jump through the address in temp a (a computed goto) }
begin
  PushInsn('IJMP', 'a=' + IntToStr(a));
end;

function LowerLabelId(const name: string): LongInt;
{ the IR label id of a routine label, allocating it on first mention so a `name:`
  definition and every `@name` in the routine share one id (forward references
  resolve, since the id is created by whichever comes first) }
var
  i: LongInt;
begin
  i := LabelIntern(name, -1);
  if LabelIrId[i] < 0 then LabelIrId[i] := NewLabel;
  LowerLabelId := LabelIrId[i];
end;

procedure EmitBZ(a, l: LongInt);
begin
  PushInsn('BZ', 'a=' + IntToStr(a) + ' label=' + IntToStr(l));
end;

procedure EmitBNZ(a, l: LongInt);
begin
  PushInsn('BNZ', 'a=' + IntToStr(a) + ' label=' + IntToStr(l));
end;

procedure EmitArg(a: LongInt);
begin
  PushInsn('ARG', 'a=' + IntToStr(a));
end;

procedure EmitLoc(line: LongInt);
{ A -g source-line marker. It emits no code; the backend records it in the
  module's address-to-line table so a trap can name this line. }
begin
  PushInsn('LOC', 'imm=' + IntToStr(line));
end;

procedure EmitRet;
begin
  PushInsn('RET', '');
end;

procedure EmitRetv(a: LongInt);
begin
  PushInsn('RETV', 'a=' + IntToStr(a));
end;

procedure EmitFRetv(a: LongInt; single: Boolean);
begin
  if single then PushInsn('FRETV', 'a=' + IntToStr(a) + ' imm=4')
  else PushInsn('FRETV', 'a=' + IntToStr(a));
end;

procedure EmitRetv2(a, b: LongInt);
{ Return a failable routine's two results: the value in a, the error in b. a and b both go to
  integer return registers (doc/languages/kobold/kp-errors.md: failable function values are integer-class). }
begin
  PushInsn('RETV2', 'a=' + IntToStr(a) + ' b=' + IntToStr(b));
end;

procedure EmitFArgSingle(a: LongInt);
{ Pass a float argument to a single-precision parameter: the JIT narrows it to f32. }
begin
  PushInsn('FARG', 'a=' + IntToStr(a) + ' imm=4');
end;

function EmitFLDL(slot: LongInt): LongInt;
var
  d: LongInt;
begin
  d := NewTemp;
  PushInsn('FLDL', 'dst=' + IntToStr(d) + ' slot=' + IntToStr(slot));
  EmitFLDL := d;
end;

procedure EmitFSTL(a, slot: LongInt);
begin
  PushInsn('FSTL', 'a=' + IntToStr(a) + ' slot=' + IntToStr(slot));
end;

function EmitFLD(a: LongInt): LongInt;
var
  d: LongInt;
begin
  d := NewTemp;
  PushInsn('FLD', 'dst=' + IntToStr(d) + ' a=' + IntToStr(a));
  EmitFLD := d;
end;

procedure EmitFSD(addr, val: LongInt);
begin
  PushInsn('FSD', 'a=' + IntToStr(addr) + ' b=' + IntToStr(val));
end;

function EmitFLS(addr: LongInt): LongInt;
{ Load a single (4-byte f32) from addr, widening to the f64 held in a register. }
var
  d: LongInt;
begin
  d := NewTemp;
  PushInsn('FLS', 'dst=' + IntToStr(d) + ' a=' + IntToStr(addr));
  EmitFLS := d;
end;

procedure EmitFSS(addr, val: LongInt);
{ Store the f64 value narrowed to a single (4-byte f32) at addr. }
begin
  PushInsn('FSS', 'a=' + IntToStr(addr) + ' b=' + IntToStr(val));
end;

procedure EmitFArg(a: LongInt);
begin
  PushInsn('FARG', 'a=' + IntToStr(a));
end;

{ 64-bit helpers, used for small sets (a set is an i64 bitmask). }

function EmitLIC64(imm: Int64): LongInt;
var
  d: LongInt;
begin
  d := NewTemp;
  PushInsn('LIC64', 'dst=' + IntToStr(d) + ' imm=' + IntToStr(imm));
  EmitLIC64 := d;
end;

function EmitLDL64(slot: LongInt): LongInt;
var
  d: LongInt;
begin
  d := NewTemp;
  PushInsn('LDL64', 'dst=' + IntToStr(d) + ' slot=' + IntToStr(slot));
  EmitLDL64 := d;
end;

procedure EmitSTL64(a, slot: LongInt);
begin
  PushInsn('STL64', 'a=' + IntToStr(a) + ' slot=' + IntToStr(slot));
end;

function EmitLD64(a: LongInt): LongInt;
var
  d: LongInt;
begin
  d := NewTemp;
  PushInsn('LD64', 'dst=' + IntToStr(d) + ' a=' + IntToStr(a));
  EmitLD64 := d;
end;

procedure EmitST64(addr, val: LongInt);
begin
  PushInsn('ST64', 'a=' + IntToStr(addr) + ' b=' + IntToStr(val));
end;

function EmitLDLAddr(slot: LongInt): LongInt;
{ Load a pointer-width word (an address or a handle) held in a stack slot: LDL64
  under LP64 (an 8-byte pointer slot), the narrow LDL under ILP32. Used where a slot
  holds a pointer rather than a scalar (a by-reference parameter, a captured
  variable's hidden pointer, an sret buffer pointer, a handle local). }
begin
  if CurTarget.PtrBytes = 8 then EmitLDLAddr := EmitLDL64(slot)
  else EmitLDLAddr := EmitLDL(slot);
end;

procedure EmitSTLAddr(val, slot: LongInt);
{ Store a pointer-width word (an address or a handle) into a stack slot: STL64 under
  LP64, the narrow STL under ILP32. The mirror of EmitLDLAddr. }
begin
  if CurTarget.PtrBytes = 8 then EmitSTL64(val, slot)
  else EmitSTL(val, slot);
end;

function EmitLoadPtr(addr: LongInt): LongInt;
{ Load a pointer-width word from a guest address: LD64 under LP64, LW under ILP32. }
begin
  if CurTarget.PtrBytes = 8 then EmitLoadPtr := EmitLD64(addr)
  else EmitLoadPtr := EmitLW(addr);
end;

procedure EmitStorePtr(addr, val: LongInt);
{ Store a pointer-width word to a guest address: ST64 under LP64, SW under ILP32. }
begin
  if CurTarget.PtrBytes = 8 then EmitST64(addr, val)
  else EmitSW(addr, val);
end;

function EmitLoadScalar(addr, ty: LongInt): LongInt;
{ Load a scalar of type ty from a guest address, choosing the load opcode by scalar
  class: a 64-bit value (Int64 or a set word) through LD64, a single through FLS, a
  real through FLD, else a 32-bit LW. }
begin
  if WideStore(ty) then EmitLoadScalar := EmitLD64(addr)
  else if IsSingle(ty) then EmitLoadScalar := EmitFLS(addr)
  else if IsRealType(ty) then EmitLoadScalar := EmitFLD(addr)
  else EmitLoadScalar := EmitLW(addr);
end;

procedure EmitStoreScalar(addr, val, ty: LongInt);
{ Store scalar val of type ty to a guest address, the mirror of EmitLoadScalar:
  ST64 for a 64-bit value, FSS for a single, FSD for a real, else a 32-bit SW. }
begin
  if WideStore(ty) then EmitST64(addr, val)
  else if IsSingle(ty) then EmitFSS(addr, val)
  else if IsRealType(ty) then EmitFSD(addr, val)
  else EmitSW(addr, val);
end;

procedure EmitArg64(a: LongInt);
begin
  PushInsn('ARG64', 'a=' + IntToStr(a));
end;

procedure EmitArgPtr(a: LongInt);
{ Pass a pointer-width argument (a handle, a receiver, or a hidden sret/args
  pointer): ARG64 under LP64, the 32-bit ARG under ILP32. }
begin
  if CurTarget.PtrBytes = 8 then PushInsn('ARG64', 'a=' + IntToStr(a))
  else PushInsn('ARG', 'a=' + IntToStr(a));
end;

procedure EmitRetv64(a: LongInt);
begin
  PushInsn('RETV64', 'a=' + IntToStr(a));
end;

{ ---- IR program tables ---- }

function AddIrFunc(const name: string; isLocal: Boolean): LongInt;
var
  n: LongInt;
begin
  n := IrFuncCount;
  SetLength(IrFuncs, n + 1);
  IrFuncs[n].Name := name;
  IrFuncs[n].IsLocal := isLocal;
  IrFuncs[n].Nparams := 0;
  IrFuncs[n].Ntemps := 0;
  IrFuncs[n].Nlabels := 0;
  SetLength(IrFuncs[n].SlotSize, 0);
  SetLength(IrFuncs[n].ParamClass, 0);
  SetLength(IrFuncs[n].ParamFW, 0);
  SetLength(IrFuncs[n].Insns, 0);
  IrFuncs[n].NInsns := 0;
  Inc(IrFuncCount);
  AddIrFunc := n;
end;

procedure AddIrGlobalArr(const name, baseType: string; arrSize: LongInt);
var
  n: LongInt;
begin
  n := IrGlobalCount;
  SetLength(IrGlobals, n + 1);
  IrGlobals[n].Name := name;
  IrGlobals[n].BaseType := baseType;
  IrGlobals[n].ArrSize := arrSize;
  IrGlobals[n].HasInit := False;
  IrGlobals[n].InitBits := 0;
  IrGlobals[n].HasStr := False;
  IrGlobals[n].InitStr := '';
  IrGlobals[n].IsStrObj := False;
  SetLength(IrGlobals[n].InitVals, 0);
  IrGlobals[n].Exported := False;
  IrGlobals[n].ReadOnly := False;
  Inc(IrGlobalCount);
end;

procedure AddIrGlobal(const name, baseType: string);
begin
  AddIrGlobalArr(name, baseType, 0);
end;

function AddIrWordArray(const baseType: string; const vals: TInt64Array): string;
{ Reserve a read-only typed word-array global and return its symbol name. Each value is
  emitted as one .init at baseType's width, so the assembler encodes it in the target's
  endianness. This is the endian-correct replacement for packing LE bytes into a .string
  blob, used for the constant-array, large-set, and array-layout images. }
var
  n, i: LongInt;
  nm: string;
begin
  n := IrGlobalCount;
  nm := '_warr' + IntToStr(n);
  SetLength(IrGlobals, n + 1);
  IrGlobals[n].Name := nm;
  IrGlobals[n].BaseType := baseType;
  IrGlobals[n].ArrSize := Length(vals);
  IrGlobals[n].HasInit := False;
  IrGlobals[n].InitBits := 0;
  IrGlobals[n].HasStr := False;
  IrGlobals[n].InitStr := '';
  IrGlobals[n].IsStrObj := False;
  SetLength(IrGlobals[n].InitVals, Length(vals));
  for i := 0 to High(vals) do IrGlobals[n].InitVals[i] := vals[i];
  IrGlobals[n].Exported := False;
  IrGlobals[n].ReadOnly := True;
  Inc(IrGlobalCount);
  AddIrWordArray := nm;
end;

function AddIrStaticStringImage(const name, bytes: string; exported: Boolean): string;
{ Reserve a static string object: a saturated-refcount gheap string laid out in the data image,
  not allocated at run time. Its address is the string value, so a literal or constant lowers to
  a LEA of it with no allocation; retain and release no-op on the saturated count, so it is
  shared freely and never freed (doc/languages/kobold/kp-units.md). The image is the refcount, kind, and len as
  three little-endian words, then the bytes and a trailing NUL, matching struct kp_str
  (src/str_core.c) and the object header (src/obj.h: KP_RC_STATIC refcount, KP_OBJ_STRING kind).
  Every global is laid out at an 8-aligned offset, so the address is low-bit-0 (a gheap object,
  not a host-handle id). An exported image carries a cross-unit string constant, named after the
  const so a consumer references it by name. }
var
  n: LongInt;
begin
  n := IrGlobalCount;
  SetLength(IrGlobals, n + 1);
  IrGlobals[n].Name := name;
  IrGlobals[n].BaseType := 'i8';
  IrGlobals[n].ArrSize := 0;          { size is implicit in the strobj descriptor }
  IrGlobals[n].HasInit := False;
  IrGlobals[n].InitBits := 0;
  IrGlobals[n].HasStr := True;        { InitStr holds the text; the header is strobj's }
  IrGlobals[n].InitStr := bytes;
  IrGlobals[n].IsStrObj := True;      { the backend emits the refcount/kind/len header in
                                        target endianness, then the text and a trailing NUL }
  SetLength(IrGlobals[n].InitVals, 0);
  IrGlobals[n].Exported := exported;
  IrGlobals[n].ReadOnly := True;    { a static string is immutable: never written at run time }
  Inc(IrGlobalCount);
  AddIrStaticStringImage := name;
end;

function AddIrStaticString(const bytes: string): string;
{ A module-private static string, auto-named. }
begin
  AddIrStaticString := AddIrStaticStringImage('_sstr' + IntToStr(IrGlobalCount), bytes, False);
end;

function EmitRealConstBits(bits: Int64): LongInt;
{ Materialize an f64 value from a precomputed bit pattern through an f64 constant-pool
  global, loaded by FLD. The version 1 opcode subset has no float immediate, so the value
  lives in a read-only global initialized with its bits. A single-precision value shares
  this path, since computation is done in the f64 held in a register; the narrowing to f32
  happens only at a store to a single-typed location (FSS). }
var
  n, addr: LongInt;
  nm: string;
begin
  n := IrGlobalCount;
  nm := '_real' + IntToStr(n);
  SetLength(IrGlobals, n + 1);
  IrGlobals[n].Name := nm;
  IrGlobals[n].BaseType := 'f64';
  IrGlobals[n].ArrSize := 0;
  IrGlobals[n].HasInit := True;
  IrGlobals[n].InitBits := bits;
  IrGlobals[n].HasStr := False;
  IrGlobals[n].InitStr := '';
  IrGlobals[n].IsStrObj := False;
  SetLength(IrGlobals[n].InitVals, 0);
  IrGlobals[n].Exported := False;
  IrGlobals[n].ReadOnly := True;    { the f64 constant pool is load-only }
  Inc(IrGlobalCount);
  addr := EmitLEA(nm);
  EmitRealConstBits := EmitFLD(addr);
end;

function EmitRealConst(const litText: string): LongInt;
{ Materialize a real literal. The bit pattern is computed from the literal text in integer
  arithmetic (RealLitBits), not from a host Double, so it is identical on every backend
  including the single-float tier. }
begin
  EmitRealConst := EmitRealConstBits(RealLitBits(litText));
end;

function ClassOf(ty: LongInt): string;
{ ABI value class for a scalar type. A 64-bit integer is its own class so an
  ILP32 host boundary passes it as a register pair; on an LP64 host it is one
  register, the same as the int class. }
begin
  if (ty >= 0) and (SemTypes[ty].Kind = skReal) then ClassOf := 'float'
  else if IsInt64(ty) then ClassOf := 'int64'
  else ClassOf := 'int';
end;

function TypeRef(ty: LongInt): string;
{ The name a type takes in an interface section, so a consumer reconstructs the real type
  rather than only its ABI class. A built-in scalar uses its canonical name; an exported
  enum, record, or handle type uses its own name (the reader resolves it against the .type
  entries read first). A type with no interface form yet (array, set, subrange) falls back to
  its ABI class, which the reader reads as the integer or real class. }
begin
  if ty < 0 then TypeRef := 'void'
  else if ty = tyInt then TypeRef := 'integer'
  else if ty = tyInt64 then TypeRef := 'int64'
  else if ty = tyBool then TypeRef := 'boolean'
  else if ty = tyChar then TypeRef := 'char'
  else if ty = tyStr then TypeRef := 'string'
  else if ty = tySingle then TypeRef := 'single'
  else if IsRealType(ty) then TypeRef := 'real'
  else if (ty < SemCount) and (SemTypes[ty].Kind = skProcess) then TypeRef := 'process'
  else if (ty < SemCount) and (SemTypes[ty].Name <> '') and
          ((SemTypes[ty].Kind = skEnum) or (SemTypes[ty].Kind = skRecord) or
           (SemTypes[ty].Kind = skInterface)) then
    TypeRef := SemTypes[ty].Name
  else TypeRef := ClassOf(ty);
end;

function ModeTok(m: LongInt): string;
{ The interface token for a parameter passing mode. }
begin
  case m of
    1: ModeTok := 'var';
    2: ModeTok := 'const';
    3: ModeTok := 'out';
  else
    ModeTok := 'val';
  end;
end;

procedure AddIrImport(sym: LongInt);
{ Record an external routine as a host import, from its proc signature. }
var
  n, i, sig, np: LongInt;
begin
  n := IrImportCount;
  SetLength(IrImports, n + 1);
  IrImports[n].Name := Syms[sym].Name;
  IrImports[n].IsHelper := False;
  IrImports[n].IsType := False;
  sig := Syms[sym].TypeId;
  np := Length(SemTypes[sig].ParamTypes);
  SetLength(IrImports[n].ParamCls, np);
  for i := 0 to np - 1 do
    IrImports[n].ParamCls[i] := ClassOf(SemTypes[sig].ParamTypes[i]);
  if SemTypes[sig].RetType < 0 then IrImports[n].RetCls := 'void'
  else IrImports[n].RetCls := ClassOf(SemTypes[sig].RetType);
  Inc(IrImportCount);
end;

function LinkNameOf(s: LongInt): string;
{ The external symbol name for emission: a renamed import keeps its export name for
  linkage while its local name (Syms[s].Name) is what source refers to it by. }
begin
  if Syms[s].LinkName <> '' then LinkNameOf := Syms[s].LinkName
  else LinkNameOf := Syms[s].Name;
end;

procedure EnsureImportN(const name: string; isHelper: Boolean; nargs: LongInt;
  const retCls: string);
{ Declare an import once, with `nargs` int-class parameters. A helper resolves to a
  VM runtime helper, a non-helper to a host function through the FFI. Shared by
  EnsureHelper and EnsureFunc, which differ only in that flag. }
var
  n, i: LongInt;
begin
  for i := 0 to IrImportCount - 1 do
    if IrImports[i].Name = name then Exit;
  n := IrImportCount;
  SetLength(IrImports, n + 1);
  IrImports[n].Name := name;
  IrImports[n].IsHelper := isHelper;
  IrImports[n].IsType := False;
  SetLength(IrImports[n].ParamCls, nargs);
  for i := 0 to nargs - 1 do IrImports[n].ParamCls[i] := 'int';
  IrImports[n].RetCls := retCls;
  Inc(IrImportCount);
end;

procedure EnsureHelper(const name: string; nargs: LongInt; const retCls: string);
{ Declare a runtime helper import once, with `nargs` int-class parameters. }
begin
  EnsureImportN(name, True, nargs, retCls);
end;

procedure EnsureHelperI64(const name: string; const retCls: string);
{ Declare a runtime helper import taking one 64-bit integer argument. The class is
  distinct from int so an ILP32 host boundary passes it as a register pair. }
var
  n: LongInt;
begin
  for n := 0 to IrImportCount - 1 do
    if IrImports[n].Name = name then Exit;
  n := IrImportCount;
  SetLength(IrImports, n + 1);
  IrImports[n].Name := name;
  IrImports[n].IsHelper := True;
  IrImports[n].IsType := False;
  SetLength(IrImports[n].ParamCls, 1);
  IrImports[n].ParamCls[0] := 'int64';
  IrImports[n].RetCls := retCls;
  Inc(IrImportCount);
end;

procedure EnsureHelperF(const name: string);
{ Declare a runtime helper import taking one float argument and returning a float,
  for the transcendental math builtins. }
var
  n, i: LongInt;
begin
  for i := 0 to IrImportCount - 1 do
    if IrImports[i].Name = name then Exit;
  n := IrImportCount;
  SetLength(IrImports, n + 1);
  IrImports[n].Name := name;
  IrImports[n].IsHelper := True;
  IrImports[n].IsType := False;
  SetLength(IrImports[n].ParamCls, 1);
  IrImports[n].ParamCls[0] := 'float';
  IrImports[n].RetCls := 'float';
  Inc(IrImportCount);
end;

procedure EnsureFuncIF(const name: string);
{ Declare a host-function import with an (int, float) parameter list and no result,
  for io_write_real: a stream id and a real value. }
var
  n, i: LongInt;
begin
  for i := 0 to IrImportCount - 1 do
    if IrImports[i].Name = name then Exit;
  n := IrImportCount;
  SetLength(IrImports, n + 1);
  IrImports[n].Name := name;
  IrImports[n].IsHelper := False;
  IrImports[n].IsType := False;
  SetLength(IrImports[n].ParamCls, 2);
  IrImports[n].ParamCls[0] := 'int';
  IrImports[n].ParamCls[1] := 'float';
  IrImports[n].RetCls := 'void';
  Inc(IrImportCount);
end;

procedure EnsureFunc(const name: string; nargs: LongInt; const retCls: string);
{ Declare a host-function import once, with `nargs` int-class parameters. Unlike a
  helper, it resolves through the host FFI (kp_register_func), the C/SysV convention. }
begin
  EnsureImportN(name, False, nargs, retCls);
end;

procedure EnsureIrType(ifaceTy: LongInt);
{ Declare a host handle type and its method vtable once, in interface order.
  Each method's slot is its index; the receiver handle is implicit (argument 0)
  and is not part of the declared parameter classes. }
var
  n, i, mi, sig, np, nm: LongInt;
begin
  for i := 0 to IrImportCount - 1 do
    if IrImports[i].IsType and (IrImports[i].Name = SemTypes[ifaceTy].Name) then Exit;
  n := IrImportCount;
  SetLength(IrImports, n + 1);
  IrImports[n].Name := SemTypes[ifaceTy].Name;
  IrImports[n].IsHelper := False;
  IrImports[n].IsType := True;
  nm := Length(SemTypes[ifaceTy].Names);
  SetLength(IrImports[n].Methods, nm);
  for mi := 0 to nm - 1 do begin
    IrImports[n].Methods[mi].MName := SemTypes[ifaceTy].Names[mi];
    sig := SemTypes[ifaceTy].Subs[mi];
    np := Length(SemTypes[sig].ParamTypes);
    SetLength(IrImports[n].Methods[mi].ParamCls, np);
    for i := 0 to np - 1 do
      IrImports[n].Methods[mi].ParamCls[i] := ClassOf(SemTypes[sig].ParamTypes[i]);
    if SemTypes[sig].RetType < 0 then IrImports[n].Methods[mi].RetCls := 'void'
    else IrImports[n].Methods[mi].RetCls := ClassOf(SemTypes[sig].RetType);
  end;
  Inc(IrImportCount);
end;

procedure AddIrExport(const name: string);
var
  n: LongInt;
begin
  n := IrExportCount;
  SetLength(IrExports, n + 1);
  IrExports[n] := name;
  Inc(IrExportCount);
end;

function EmitStrCall1(const name: string; a: LongInt): LongInt;
{ Call a one-argument string runtime helper for an int-class (handle) result. }
var
  d: LongInt;
begin
  EnsureHelper(name, 1, 'int');
  EmitArg(a);
  d := NewTemp;
  PushInsn('CALL', 'dst=' + IntToStr(d) + ' sym=' + name + ' nargs=1');
  EmitStrCall1 := d;
end;

function EmitStrCall1I64(const name: string; a: LongInt): LongInt;
{ Call a one-argument string runtime helper that returns a 64-bit integer. The
  result comes back through CALL64, which captures the full register (a plain
  CALL keeps only the low 32 bits, which truncated Val's Int64 result to zero
  for values whose low word is zero, e.g. 2^52). }
var
  d: LongInt;
begin
  EnsureHelper(name, 1, 'int64');
  EmitArg(a);
  d := NewTemp;
  PushInsn('CALL64', 'dst=' + IntToStr(d) + ' sym=' + name + ' nargs=1');
  EmitStrCall1I64 := d;
end;

function EmitMathCall(const name: string; argNode: LongInt): LongInt;
{ Call a one-argument float runtime helper (a transcendental) for a real result;
  an integer argument is widened to real first. }
var
  d: LongInt;
begin
  EnsureHelperF(name);
  EmitFArg(AsFloat(argNode));
  d := NewTemp;
  PushInsn('FCALL', 'dst=' + IntToStr(d) + ' sym=' + name + ' nargs=1');
  EmitMathCall := d;
end;

function EmitStrCall2(const name: string; a, b: LongInt): LongInt;
{ Call a two-argument string runtime helper for an int-class (handle) result. }
var
  d: LongInt;
begin
  EnsureHelper(name, 2, 'int');
  EmitArg(a);
  EmitArg(b);
  d := NewTemp;
  PushInsn('CALL', 'dst=' + IntToStr(d) + ' sym=' + name + ' nargs=2');
  EmitStrCall2 := d;
end;


function EmitStrCall3(const name: string; a, b, c: LongInt): LongInt;
{ Call a three-argument string runtime helper for an int-class (handle) result. }
var
  d: LongInt;
begin
  EnsureHelper(name, 3, 'int');
  EmitArg(a);
  EmitArg(b);
  EmitArg(c);
  d := NewTemp;
  PushInsn('CALL', 'dst=' + IntToStr(d) + ' sym=' + name + ' nargs=3');
  EmitStrCall3 := d;
end;

function IsStrIndex(node: LongInt): Boolean;
{ True for s[i] where s is a string: the element is a character read from, or written to,
  the string's byte storage rather than a fixed- or dynamic-array element. }
var
  bt: LongInt;
begin
  IsStrIndex := False;
  if Nodes[node].Kind <> nkIndex then Exit;
  bt := Nodes[Nodes[node].A].Ty;
  IsStrIndex := (bt >= 0) and (bt < SemCount) and (SemTypes[bt].Kind = skString);
end;

procedure EmitIndexTrap(lBad, lOk: LongInt);
{ Close a bounds check: on success skip past the trap to lOk, then emit at lBad the
  index-out-of-range trap and the lOk continuation. The range guards branch to lBad
  when they fail. }
begin
  EmitJmp(lOk);
  EmitLabel(lBad);
  EnsureHelper('kp_trap_index', 0, 'void');
  PushInsn('CALL', 'sym=kp_trap_index nargs=0');
  EmitLabel(lOk);
end;

function StrCharAddr(node: LongInt): LongInt;
{ The guest address of character i of a string designator s (s[i]), bounds-checked against
  the runtime length. Pascal indexes from 1, so a valid i runs 1..Length(s); the address is
  kp_str_base(s) + (i - 1). A string has no compile-time extent, so the check is always on,
  as for a dynamic array. }
var
  handle, idx, lenv, base, lBad, lOk, cmp: LongInt;
begin
  handle := LowerExpr(Nodes[node].A);
  idx := LowerExpr(Nodes[node].Kids[0]);
  lenv := EmitStrCall1('kp_str_len', handle);
  lBad := NewLabel;
  lOk := NewLabel;
  cmp := EmitBin('CMPLTS', idx, EmitLIC(1));
  EmitBNZ(cmp, lBad);
  cmp := EmitBin('CMPGTS', idx, lenv);
  EmitBNZ(cmp, lBad);
  EmitIndexTrap(lBad, lOk);
  base := EmitStrCall1('kp_str_base', handle);
  StrCharAddr := AddrAdd(base, EmitBin('SUB', idx, EmitLIC(1)));
end;

function EmitStringValue(const bytes: string): LongInt;
{ Materialize a VM string from a byte blob via kp_str_new, the value a string literal or a
  string constant reads. Each read makes a fresh string, as for a literal. The two arguments
  are staged in a fixed order so the emitted temp numbering does not depend on the host's
  argument-evaluation order (which self-hosting requires to be deterministic). }
begin
  { a string literal or constant is a static string object in the data image: its address is
    the value, with no runtime allocation. The empty string is nil (0), as the runtime treats
    a nil string as empty. }
  if Length(bytes) = 0 then
    EmitStringValue := EmitLIC(0)
  else
    EmitStringValue := EmitLEA(AddIrStaticString(bytes));
end;

function LowerStringLit(node: LongInt): LongInt;
{ A string literal is a static string object; its address is the value (see EmitStringValue). }
begin
  if Length(Nodes[node].Text) = 0 then
    LowerStringLit := EmitLIC(0)
  else
    LowerStringLit := EmitLEA(AddIrStaticString(Nodes[node].Text));
end;

procedure EmitRetain(v: LongInt);
begin
  EnsureHelper('kp_retain', 1, 'void');
  EmitArg(v);
  PushInsn('CALL', 'sym=kp_retain nargs=1');
end;

procedure EmitRelease(v: LongInt);
begin
  EnsureHelper('kp_release', 1, 'void');
  EmitArg(v);
  PushInsn('CALL', 'sym=kp_release nargs=1');
end;

procedure ReleaseIfOwned(node, handle: LongInt);
{ Release a string operand that a helper read by value, when the operand expression
  produced a fresh owned reference (a literal, concatenation, call result, or a char that
  AsStr boxed into a one-character string). A borrowed variable, field, or element read
  keeps its reference and is left alone. This is what stops a chained concatenation, or any
  built-in fed a temporary, from leaking its intermediates on the guest heap. }
begin
  if (Nodes[node].Ty = tyChar) or IsOwnedExpr(node) then EmitRelease(handle);
end;

procedure ReleaseIfOwnedIface(node, handle: LongInt);
{ Release an owned interface temporary a comparison read by value, e.g. getObj = nil. Only
  an interface handle is released here: a string comparison is lowered elsewhere, a process
  handle has drop-is-cancel semantics, and a routine value is not reference-counted, so the
  general comparison path must not release those. }
var
  ty: LongInt;
begin
  ty := Nodes[node].Ty;
  if IsOwnedExpr(node) and (ty >= 0) and (ty < SemCount) and
     (SemTypes[ty].Kind = skInterface) then EmitRelease(handle);
end;

{ ---- variable access ---- }

function IsGlobalVar(s: LongInt): Boolean;
{ A unit-level variable, addressed by its symbol name (EmitLEA) rather than a local slot.
  An imported var lives in another module's globals frame; the linker resolves the name. }
begin
  IsGlobalVar := (Syms[s].Kind = syVar) and not Syms[s].BinderVar and
    ((Syms[s].Scope = GlobalScope) or Syms[s].Imported);
end;

procedure EnsureBinderSlot(s: LongInt);
{ A binder variable (a for-in index or map iterator, a `fails`/self error binder,
  a for-in ignored throwaway) has no var declaration, so AssignBlockSlots never
  gave it a slot. Allocate one on first use, sized by its type. A binder is always
  written before it is read, so the first StoreSym/VarAddr touch allocates it. }
begin
  if (s >= 0) and Syms[s].BinderVar and (Syms[s].Slot < 0) then
    Syms[s].Slot := NewSlot(TypeSize(Syms[s].TypeId));
end;

function VarAddr(s: LongInt): LongInt;
{ The address of variable s in the routine being lowered. A `with` field alias is
  base.field; a captured variable is reached through its hidden pointer parameter;
  a by-reference aggregate parameter through its pointer slot; a global by its
  symbol; a plain local by its slot. }
var
  baseNode, recTy, m, off: LongInt;
begin
  EnsureBinderSlot(s);
  if Syms[s].Kind = syFunc then
    { the current function's aggregate result: its storage is the caller's buffer, reached
      through the hidden sret pointer that CurResultSlot holds }
    VarAddr := EmitLDLAddr(CurResultSlot)
  else if Syms[s].WithBase >= 0 then begin
    baseNode := Syms[s].WithBase;
    recTy := Nodes[baseNode].Ty;
    m := FindMember(recTy, Syms[s].Name);
    if m >= 0 then off := FieldOffset(recTy, m) else off := 0;
    if off = 0 then VarAddr := AddrOf(baseNode)
    else VarAddr := AddOff(AddrOf(baseNode), off);
  end
  else if CapSlot[s] >= 0 then VarAddr := EmitLDLAddr(CapSlot[s])
  else if IsGlobalVar(s) then VarAddr := EmitLEA(LinkNameOf(s))
  else if ParamByRef(s) then VarAddr := EmitLDLAddr(Syms[s].Slot)
  else VarAddr := EmitADL(Syms[s].Slot);
end;

function Addressed(s: LongInt): Boolean;
{ True when a variable's value is reached through an address (a `with` field,
  captured, global, or by-reference parameter) rather than living directly in a
  local slot. }
begin
  Addressed := (Syms[s].WithBase >= 0) or (CapSlot[s] >= 0) or
    IsGlobalVar(s) or ParamByRef(s);
end;

function LoadSym(s: LongInt): LongInt;
{ Produce a temp holding the value of the variable/constant symbol s. }
var
  addr, ty: LongInt;
begin
  EnsureBinderSlot(s);
  { a declaration-level property read is a call to its getter (doc/languages/kobold/kp-property.md) }
  if IsPropertySym(s) then begin
    LoadSym := LowerDirectCall(Nodes[Nodes[Syms[s].Node].B].Sym, [], True);
    Exit;
  end;
  if Syms[s].Kind in [syConst, syEnumLit] then begin
    if Syms[s].ConstIsStr then LoadSym := EmitStringValue(Syms[s].ConstStr)
    { an imported link-time const has no value here: it is an exported read-only global in the
      defining unit, so load it by address, resolved cross-unit at link. The defining unit
      inlines its own known value below (doc/languages/kobold/kp-units.md). }
    else if Syms[s].LinkConst and Syms[s].Imported then
      { a string const is a static object: its address is the value (LEA, no load). A scalar
        const's value is held in the exported global, so load it. }
      if Syms[s].TypeId = tyStr then
        LoadSym := EmitLEA(LinkNameOf(s))
      else
        LoadSym := EmitLoadScalar(EmitLEA(LinkNameOf(s)), Syms[s].TypeId)
    { a named scalar const is a read-only var: read it from its module-local rodata global,
      which the backend folds back to an immediate. An enum literal stays a pure immediate. }
    else if (Syms[s].Kind = syConst)
            and (IsOrdinalType(Syms[s].TypeId) or Wide64(Syms[s].TypeId)) then
      LoadSym := EmitLoadScalar(EmitLEA(ConstGlobalName(s)), Syms[s].TypeId)
    { a real or single const holds its f64 bit pattern in Ordinal; load it as an f64 value
      from the constant pool (a single is narrowed only where it is stored) }
    else if IsRealType(Syms[s].TypeId) then
      LoadSym := EmitRealConstBits(Syms[s].Ordinal)
    else if Wide64(Syms[s].TypeId) then LoadSym := EmitLIC64(Syms[s].Ordinal)
    else LoadSym := EmitLIC(Syms[s].Ordinal);
    Exit;
  end;
  if Syms[s].Kind = syFunc then begin
    { the current function's result variable lives in its own slot, as StoreSym writes it }
    ty := SemTypes[Syms[s].TypeId].RetType;
    if WideStore(ty) then LoadSym := EmitLDL64(CurResultSlot)
    else if IsRealType(ty) then LoadSym := EmitFLDL(CurResultSlot)
    else LoadSym := EmitLDL(CurResultSlot);
    Exit;
  end;
  ty := Syms[s].TypeId;
  if Addressed(s) then begin
    addr := VarAddr(s);
    LoadSym := EmitLoadScalar(addr, ty);
  end
  else if WideStore(ty) then LoadSym := EmitLDL64(Syms[s].Slot)
  else if IsSingle(ty) then LoadSym := EmitFLS(EmitADL(Syms[s].Slot))
  else if IsRealType(ty) then LoadSym := EmitFLDL(Syms[s].Slot)
  else LoadSym := EmitLDL(Syms[s].Slot);
end;

procedure StoreSym(s, val: LongInt);
{ Store temp val into the variable symbol s (or the function result). }
var
  addr, ty: LongInt;
begin
  EnsureBinderSlot(s);
  if Syms[s].Kind = syFunc then begin
    if IsRealType(SemTypes[Syms[s].TypeId].RetType) then EmitFSTL(val, CurResultSlot)
    else if WideStore(SemTypes[Syms[s].TypeId].RetType) then EmitSTL64(val, CurResultSlot)
    else EmitSTL(val, CurResultSlot);
    Exit;
  end;
  ty := Syms[s].TypeId;
  if Addressed(s) then begin
    addr := VarAddr(s);
    EmitStoreScalar(addr, val, ty);
  end
  else if WideStore(ty) then EmitSTL64(val, Syms[s].Slot)
  else if IsSingle(ty) then EmitFSS(EmitADL(Syms[s].Slot), val)
  else if IsRealType(ty) then EmitFSTL(val, Syms[s].Slot)
  else EmitSTL(val, Syms[s].Slot);
end;

{ ---- call lowering ---- }

function IsMethodField(node: LongInt): Boolean;
{ True when an nkField names a method that dispatches, rather than a data field
  that loads: any interface member, or a record member that resolves to a method
  and not to a field. }
var
  bt: LongInt;
begin
  IsMethodField := False;
  if Nodes[node].Kind <> nkField then Exit;
  bt := Nodes[Nodes[node].A].Ty;
  if (bt < 0) or (bt >= SemCount) then Exit;
  if SemTypes[bt].Kind = skInterface then
    { an interface member, or a script method added to or overriding the type }
    IsMethodField := (FindMember(bt, Nodes[node].Text) >= 0) or
                     (FindMethod(bt, Nodes[node].Text) >= 0)
  else if SemTypes[bt].Kind = skRecord then
    IsMethodField := (FindMember(bt, Nodes[node].Text) < 0) and
                     (FindMethod(bt, Nodes[node].Text) >= 0);
end;

procedure ReleaseOwnedArgs(const owned: TIntArray); forward;

procedure EmitTypedCall(d, ret: LongInt; const base, args: string);
{ Emit a value-returning call into temp d, choosing the opcode by result class.
  base is the plain opcode ('CALL' direct, 'CALLI' indirect): a single widens to
  'F'+base with imm=4, a real to 'F'+base, a 64-bit result to base+'64'. }
begin
  if IsSingle(ret) then PushInsn('F' + base, 'dst=' + IntToStr(d) + ' imm=4 ' + args)
  else if IsRealType(ret) then PushInsn('F' + base, 'dst=' + IntToStr(d) + ' ' + args)
  else if WideStore(ret) then PushInsn(base + '64', 'dst=' + IntToStr(d) + ' ' + args)
  else PushInsn(base, 'dst=' + IntToStr(d) + ' ' + args);
end;

procedure ClassifyArg(sig, i, argNode: LongInt; var at, ak: LongInt;
  var owned: TIntArray);
{ Classify one call argument by its parameter type (or, when the call is variadic
  past the declared parameters, by the argument's own type): set at to the lowered
  value and ak to its staging kind (0 int or address, 1 real, 2 Int64 or set, 3
  single). A scalar var/out parameter passes the argument's address. An owned handle
  temporary passed by value is appended to owned so the caller releases it after the
  call: the callee borrows the handle, it does not take ownership. }
var
  np, paramTy, effTy, pmode: LongInt;
begin
  np := 0;
  if (sig >= 0) and (SemTypes[sig].Kind = skProc) then
    np := Length(SemTypes[sig].ParamTypes);
  if i < np then paramTy := SemTypes[sig].ParamTypes[i] else paramTy := -1;
  if i < np then pmode := SemTypes[sig].ParamModes[i] else pmode := 0;
  if paramTy >= 0 then effTy := paramTy else effTy := Nodes[argNode].Ty;
  if ((pmode = 1) or (pmode = 3)) and not IsAggregate(effTy) then begin
    at := AddrOf(argNode);   { a scalar var/out arg passes its address }
    if CurTarget.PtrBytes = 8 then ak := 2 else ak := 0;   { a 64-bit address rides ARG64 }
  end
  else if IsSingle(effTy) then begin
    at := AsFloat(argNode);   { widen an integer argument }
    ak := 3;
  end
  else if IsRealType(effTy) then begin
    at := AsFloat(argNode);   { widen an integer argument }
    ak := 1;
  end
  else if IsSmallSet(effTy) then begin
    at := LowerExpr(argNode);
    ak := 2;
  end
  else if IsInt64(effTy) then begin
    at := AsInt64(argNode);   { sign-extend a 32-bit arg to the Int64 param }
    ak := 2;
  end
  else if IsDynArray(effTy) and IsEmptyArrayLit(argNode) then begin
    at := EmitLIC(0);   { the empty [] passes as an empty (nil) array }
    ak := 0;
  end
  else begin
    at := LowerExpr(argNode);
    { a handle, proc, or aggregate lowers to a pointer-width value, 64-bit under LP64
      (ARG64); a genuine 32-bit scalar stays ARG }
    if (IsPtrSized(effTy) or IsAggregate(effTy)) and (CurTarget.PtrBytes = 8) then ak := 2
    else ak := 0;
    { A value-mode dynamic-array argument is a value type, so the callee gets an
      independent copy it may mutate without the caller seeing it. A borrowed source is
      cloned; an owned temporary is moved in as its copy. const, var, and out borrow or
      alias, so they never clone (use const for a large array read only). The copy, like an
      owned handle temporary, is released after the call. }
    if IsDynArray(effTy) and not IsBuffer(effTy) and (pmode = 0) then begin
      if not IsOwnedExpr(argNode) then at := EmitStrCall1('kp_arr_clone', at);
      SetLength(owned, Length(owned) + 1);
      owned[High(owned)] := at;
    end
    else if IsMap(effTy) and (pmode = 0) then begin
      { a map is a value type like a dynamic array: a borrowed source is cloned, an owned
        temporary is moved in, and the copy is released after the call }
      if not IsOwnedExpr(argNode) then at := EmitStrCall1('kp_map_clone', at);
      SetLength(owned, Length(owned) + 1);
      owned[High(owned)] := at;
    end
    else if IsHandle(effTy) and IsOwnedExpr(argNode) then begin
      SetLength(owned, Length(owned) + 1);
      owned[High(owned)] := at;
    end;
  end;
end;

procedure EmitStagedArgs(const argt, argk: array of LongInt);
{ Emit the classified arguments in declaration order, each by its staging kind. }
var
  i: LongInt;
begin
  for i := 0 to High(argt) do
    case argk[i] of
      1: EmitFArg(argt[i]);
      2: EmitArg64(argt[i]);
      3: EmitFArgSingle(argt[i]);
    else
      EmitArg(argt[i]);
    end;
end;

function LowerMethodCall(field: LongInt; const argNodes: array of LongInt;
  wantVal: Boolean): LongInt;
{ Lower a method call, e.g. e.move(1, 2) or p.scaled. The dispatch worlds share
  one shape: the receiver is argument 0, the declared arguments follow, and the
  call names the symbol `<Type>.<method>`. A host interface method rides the
  value-stack FFI with the receiver handle as argument 0 (the type is an
  `.import type` vtable). A script method (on a record, or defined on an interface
  to add or override a method) is an internal call to a `<Type>.<method>`
  function; a record receiver is passed by reference (its address), a handle
  receiver by value (its id). A module-internal `<Type>.<method>` shadows a host
  vtable entry of the same name, which is how a script method wins. }
var
  recv, bt, m, sig, scriptSig, na, i, ret, d, r0, ownRecv, errSlot: LongInt;
  retbuf, z: LongInt;
  aggRet, wideFail: Boolean;
  argt, argk: array of LongInt;
  owned, roffs: TIntArray;
  args, symName: string;
begin
  LowerMethodCall := -1;
  ownRecv := -1;
  SetLength(owned, 0);
  recv := Nodes[field].A;
  bt := Nodes[recv].Ty;
  if (bt < 0) or (bt >= SemCount) then Exit;
  if SemTypes[bt].Kind = skInterface then begin
    EnsureIrType(bt);   { the host type is declared however the call resolves }
    r0 := LowerExpr(recv);   { the receiver handle id, passed by value }
    { an owned interface temporary is borrowed by the method, so release it after }
    if IsOwnedExpr(recv) then ownRecv := r0;
    scriptSig := FindMethod(bt, Nodes[field].Text);
    if scriptSig >= 0 then begin
      { a script method wins: an internal call to <Type>.<method> }
      sig := scriptSig;
      symName := SemTypes[bt].Name + '.' + FindMethodName(bt, Nodes[field].Text);
    end
    else begin
      m := FindMember(bt, Nodes[field].Text);
      if m < 0 then Exit;
      sig := SemTypes[bt].Subs[m];
      symName := SemTypes[bt].Name + '.' + SemTypes[bt].Names[m];
    end;
  end
  else if SemTypes[bt].Kind = skRecord then begin
    sig := FindMethod(bt, Nodes[field].Text);
    if sig < 0 then Exit;
    r0 := AddrOf(recv);   { the receiver is passed by reference: its address }
    symName := SemTypes[bt].Name + '.' + FindMethodName(bt, Nodes[field].Text);
    { a method defined in another unit is called by name; the linker binds the call to that
      unit's exported <Type>.<method>, so no host import is emitted }
  end
  else
    Exit;
  { a failable method captures its error into FailCaptureSlot via CALL2, taken before the
    declared arguments lower (doc/languages/kobold/kp-errors.md) }
  errSlot := -1;
  if (sig >= 0) and (SemTypes[sig].Kind = skProc) and SemTypes[sig].Failable and
     (FailCaptureSlot >= 0) then begin
    errSlot := FailCaptureSlot;
    FailCaptureSlot := -1;
  end;
  na := Length(argNodes);
  { evaluate arguments left to right (the receiver above came first) }
  SetLength(argt, na);
  SetLength(argk, na);
  for i := 0 to na - 1 do
    ClassifyArg(sig, i, argNodes[i], argt[i], argk[i], owned);
  EmitArgPtr(r0);   { the receiver is argument 0 (a handle id or a record address) }
  EmitStagedArgs(argt, argk);
  ret := SemTypes[sig].RetType;
  { a record result returns through caller storage (sret); a failable real, int64, or record
    result does the same, the error then in the integer return register rather than CALL2's
    second register. The sret buffer is the trailing argument, after the receiver and the
    declared ones, matching the callee's hidden pointer parameter (so a method reaches the same
    wide path a free function does, LowerDirectCall). }
  aggRet := (ret >= 0) and IsAggregate(ret);
  wideFail := (errSlot >= 0) and FailWideResult(sig);
  retbuf := -1;
  if aggRet then begin
    retbuf := NewSlot(TypeSize(ret));
    SetLength(roffs, 0);
    CollectHandleOffsets(ret, 0, roffs);
    if Length(roffs) > 0 then begin
      z := EmitLIC(0);
      for i := 0 to High(roffs) do
        EmitStorePtr(AddOff(EmitADL(retbuf), roffs[i]), z);
    end;
  end
  else if wideFail then
    retbuf := NewSlot(TypeSize(ret));   { a real or 64-bit value buffer (no handle fields) }
  if aggRet or wideFail then EmitArgPtr(EmitADL(retbuf));
  if aggRet or wideFail then
    args := 'sym=' + symName + ' nargs=' + IntToStr(na + 2)
  else
    args := 'sym=' + symName + ' nargs=' + IntToStr(na + 1);
  if wideFail then begin
    { ordinary call: the integer return register holds the error, the value is in retbuf }
    d := NewTemp;
    PushInsn('CALL', 'dst=' + IntToStr(d) + ' ' + args);
    EmitSTL(d, errSlot);
    if wantVal and (ret >= 0) then begin
      if aggRet then LowerMethodCall := EmitADL(retbuf)
      else LowerMethodCall := EmitLoadScalar(EmitADL(retbuf), ret);
    end;
  end
  else if errSlot >= 0 then begin
    { failable integer-class: CALL2 puts the value in dst and the error into errSlot }
    if wantVal and (ret >= 0) then begin
      d := NewTemp;
      PushInsn('CALL2', 'dst=' + IntToStr(d) + ' slot=' + IntToStr(errSlot) + ' ' + args);
      LowerMethodCall := d;
    end
    else
      PushInsn('CALL2', 'dst=-1 slot=' + IntToStr(errSlot) + ' ' + args);
  end
  else if aggRet then begin
    PushInsn('CALL', args);        { the callee fills the buffer; its value is the buffer }
    LowerMethodCall := EmitADL(retbuf);
  end
  else if wantVal and (ret >= 0) then begin
    d := NewTemp;
    EmitTypedCall(d, ret, 'CALL', args);
    LowerMethodCall := d;
  end
  else
    PushInsn('CALL', args);
  ReleaseOwnedArgs(owned);
  if ownRecv >= 0 then EmitRelease(ownRecv);
end;

procedure StageArgs(sig: LongInt; const argNodes: array of LongInt; var owned: TIntArray);
{ Lower and stage each argument for a call, coercing an integer to float where the
  parameter is real, and using ARG/FARG/ARG64 by the argument's class. A by-value handle
  argument that is an owned temporary is recorded in `owned`, so the caller releases it
  after the call: the callee borrows the handle, it does not take ownership. }
var
  na, i: LongInt;
  argt, argk: array of LongInt;
begin
  SetLength(owned, 0);
  na := Length(argNodes);
  SetLength(argt, na);
  SetLength(argk, na);
  { evaluate arguments right-to-left (the order FPC uses), while still emitting them in
    declaration order below. This keeps the compiler's own output identical whether it was
    built by FPC or by itself, which self-hosting's fixed point requires. }
  for i := na - 1 downto 0 do
    ClassifyArg(sig, i, argNodes[i], argt[i], argk[i], owned);
  EmitStagedArgs(argt, argk);
end;

procedure ReleaseOwnedArgs(const owned: TIntArray);
{ Release the owned handle temporaries a call borrowed as by-value arguments, run after
  the call returns so the callee has finished reading them. }
var
  i: LongInt;
begin
  for i := 0 to High(owned) do EmitRelease(owned[i]);
end;

function LowerIndirectCall(fp, sig: LongInt; const argNodes: array of LongInt;
  wantVal: Boolean): LongInt;
{ Call through a code pointer already loaded into temp `fp`, using proc signature
  `sig` for the argument classes and result. A procedural value carries no
  environment, so there are no capture arguments. }
var
  na, ret, d: LongInt;
  args: string;
  owned: TIntArray;
begin
  na := Length(argNodes);
  StageArgs(sig, argNodes, owned);
  ret := -1;
  if (sig >= 0) and (SemTypes[sig].Kind = skProc) then ret := SemTypes[sig].RetType;
  args := 'a=' + IntToStr(fp) + ' nargs=' + IntToStr(na);
  if wantVal and (ret >= 0) then begin
    d := NewTemp;
    EmitTypedCall(d, ret, 'CALLI', args);
    LowerIndirectCall := d;
  end
  else
    PushInsn('CALLI', args);
  ReleaseOwnedArgs(owned);
end;

function ProcFieldSig(field: LongInt): LongInt;
{ The procedural signature of a proc-typed record/interface field designator. }
var
  bt, m: LongInt;
begin
  ProcFieldSig := -1;
  bt := Nodes[Nodes[field].A].Ty;
  if (bt < 0) or (bt >= SemCount) then Exit;
  m := FindMember(bt, Nodes[field].Text);
  if m >= 0 then ProcFieldSig := SemTypes[bt].Subs[m];
end;

function EmitArrLayout(elem: LongInt): LongInt;
{ The layout argument for kp_arr_setlen: 0 when the element holds no handles, else the
  address of a blob (a count then that many handle-field byte offsets) the runtime reads to
  release element handle fields on shrink and reclaim. }
var
  offs: TIntArray;
  vals: TInt64Array;
  i: LongInt;
begin
  offs := nil;
  CollectHandleOffsets(elem, 0, offs);
  if Length(offs) = 0 then begin
    EmitArrLayout := EmitLIC(0);
    Exit;
  end;
  SetLength(vals, Length(offs) + 1);
  vals[0] := Length(offs);
  for i := 0 to High(offs) do vals[i + 1] := offs[i];
  EmitArrLayout := EmitLEA(AddIrWordArray('i32', vals));
end;

procedure LowerSetLength(target, lenNode: LongInt);
{ SetLength(a, n) resizes the dynamic array in the designator `a`. kp_arr_setlen takes the
  element size in bytes and whether an element is a whole handle, and returns an owned
  reference (a fresh array from nil, else the same id retained), so the result is stored
  back and the previous value released, the ordinary handle-assignment discipline. }
var
  cur, lenv, newid, s, old, addr, arrTy, elem: LongInt;
begin
  if Nodes[target].Kind = nkIdent then begin
    s := Nodes[target].Sym;
    if Syms[s].Kind = syFunc then arrTy := SemTypes[Syms[s].TypeId].RetType
    else arrTy := Syms[s].TypeId;
  end
  else arrTy := Nodes[target].Ty;
  if (arrTy < 0) or (arrTy >= SemCount) or not IsDynArray(arrTy) then begin
    SemErr(target, 'SetLength requires a dynamic-array variable');
    Exit;
  end;
  if IsBuffer(arrTy) then begin
    { A buffer's backing is host-owned, so the guest cannot resize it. }
    SemErr(target, 'cannot SetLength a buffer; the host owns its backing');
    Exit;
  end;
  cur := LowerExpr(target);
  lenv := LowerExpr(lenNode);
  { The only resizable dynamic array is the value `array of T`, which resizes copy-on-write:
    a shared array is made unique first. (A buffer is host-owned and rejected above.) }
  elem := SemTypes[arrTy].Base;
  EnsureHelper('kp_arr_setlen', 4, 'int');
  EmitArg(cur);
  EmitArg(lenv);
  EmitArg(EmitLIC(TypeSize(elem)));
  EmitArg(EmitArrLayout(elem));
  newid := NewTemp;
  PushInsn('CALL', 'dst=' + IntToStr(newid) + ' sym=kp_arr_setlen nargs=4');
  { store the owned result back over the previous value; AddrOf reaches a nested array
    element the same way it reaches any other designator }
  if Nodes[target].Kind = nkIdent then begin
    s := Nodes[target].Sym;
    if s >= 0 then begin
      old := LoadSym(s);
      StoreSym(s, newid);
      EmitRelease(old);
    end;
  end
  else begin
    addr := AddrOf(target);
    old := EmitLoadPtr(addr);
    EmitStorePtr(addr, newid);
    EmitRelease(old);
  end;
end;

procedure LowerArrEdit(target, idxNode, cntNode: LongInt; isInsert: Boolean);
{ Delete(a, index, count) removes count elements at index; Insert(a, index, count) opens count
  zero-filled slots at index. Both edit the value `array of T` in the designator copy-on-write
  through kp_arr_delete / kp_arr_insert, which return an owned reference, so the result is
  stored back and the previous value released, exactly as LowerSetLength does. }
var
  cur, idxv, cntv, newid, s, old, addr, arrTy, elem: LongInt;
begin
  if Nodes[target].Kind = nkIdent then begin
    s := Nodes[target].Sym;
    if Syms[s].Kind = syFunc then arrTy := SemTypes[Syms[s].TypeId].RetType
    else arrTy := Syms[s].TypeId;
  end
  else arrTy := Nodes[target].Ty;
  if (arrTy < 0) or (arrTy >= SemCount) or not IsDynArray(arrTy) or IsBuffer(arrTy) then begin
    SemErr(target, 'Delete and Insert require a dynamic-array variable');
    Exit;
  end;
  elem := SemTypes[arrTy].Base;
  cur := LowerExpr(target);
  idxv := LowerExpr(idxNode);
  cntv := LowerExpr(cntNode);
  if isInsert then begin
    { the element size and layout let the helper build a fresh array when the value is nil }
    EnsureHelper('kp_arr_insert', 5, 'int');
    EmitArg(cur);
    EmitArg(idxv);
    EmitArg(cntv);
    EmitArg(EmitLIC(TypeSize(elem)));
    EmitArg(EmitArrLayout(elem));
    newid := NewTemp;
    PushInsn('CALL', 'dst=' + IntToStr(newid) + ' sym=kp_arr_insert nargs=5');
  end
  else begin
    EnsureHelper('kp_arr_delete', 3, 'int');
    EmitArg(cur);
    EmitArg(idxv);
    EmitArg(cntv);
    newid := NewTemp;
    PushInsn('CALL', 'dst=' + IntToStr(newid) + ' sym=kp_arr_delete nargs=3');
  end;
  if Nodes[target].Kind = nkIdent then begin
    s := Nodes[target].Sym;
    if s >= 0 then begin
      old := LoadSym(s);
      StoreSym(s, newid);
      EmitRelease(old);
    end;
  end
  else begin
    addr := AddrOf(target);
    old := EmitLoadPtr(addr);
    EmitStorePtr(addr, newid);
    EmitRelease(old);
  end;
end;

procedure LowerMapDelete(mapDesig, keyNode: LongInt);
{ Delete(m, key) removes a key from the map in the designator. kp_map_del returns an owned
  reference (copy-on-write if the map is shared), stored back over the designator and the
  previous value released, the kp_arr_setlen discipline. }
var
  cur, key, key64, newmap, s, old, maddr: LongInt;
  isStr: Boolean;
  dsym: string;
begin
  isStr := MapKeyType(Nodes[mapDesig].Ty) = tyStr;
  dsym := 'kp_imap_del';
  if isStr then dsym := 'kp_map_del';
  cur := LowerExpr(mapDesig);
  key := -1; key64 := -1;
  if isStr then key := LowerExpr(keyNode) else key64 := AsInt64(keyNode);
  EnsureHelper(dsym, 2, 'int');
  EmitArg(cur);
  if isStr then EmitArg(key) else EmitArg64(key64);
  newmap := NewTemp;
  PushInsn('CALL', 'dst=' + IntToStr(newmap) + ' sym=' + dsym + ' nargs=2');
  if Nodes[mapDesig].Kind = nkIdent then begin
    s := Nodes[mapDesig].Sym;
    old := LoadSym(s);
    StoreSym(s, newmap);
    EmitRelease(old);
  end
  else begin
    maddr := AddrOf(mapDesig);
    old := EmitLoadPtr(maddr);
    EmitStorePtr(maddr, newmap);
    EmitRelease(old);
  end;
  if isStr then ReleaseIfOwned(keyNode, key);   { an int key is a plain value }
end;

procedure StoreHandleDesig(desig, newid: LongInt);
{ Store the owned handle newid over designator desig, releasing the previous value: the
  ordinary handle-assignment store-and-release, used for a builtin that writes a string into
  an output argument (Str). }
var
  s, old, addr: LongInt;
begin
  if Nodes[desig].Kind = nkIdent then begin
    s := Nodes[desig].Sym;
    if s < 0 then Exit;
    old := LoadSym(s);
    StoreSym(s, newid);
    EmitRelease(old);
  end
  else begin
    addr := AddrOf(desig);
    old := EmitLoadPtr(addr);
    EmitStorePtr(addr, newid);
    EmitRelease(old);
  end;
end;

procedure StoreScalarDesig(desig, val: LongInt);
{ Store a scalar (integer or real) value into designator desig, used for a builtin that
  writes an integer, real, or code into an output argument (Val). }
var
  s, addr: LongInt;
begin
  if Nodes[desig].Kind = nkIdent then begin
    s := Nodes[desig].Sym;
    if s >= 0 then StoreSym(s, val);
  end
  else begin
    addr := AddrOf(desig);
    if IsSingle(Nodes[desig].Ty) then EmitFSS(addr, val)
    else if IsRealType(Nodes[desig].Ty) then EmitFSD(addr, val)
    else if Wide64(Nodes[desig].Ty) then EmitST64(addr, val)
    else EmitSW(addr, val);
  end;
end;

procedure LowerVal(sNode, destNode, codeNode: LongInt);
{ Val(s, dest, code) parses s into dest and reports success in code. The value and the code
  are two outputs, so rather than a two-result call the string is parsed once for the value
  (kp_str_val_int or kp_str_val_real, by the destination type) and once for the code
  (kp_str_valcode), which is cheap for a short literal. code is 0 on a full valid parse. }
var
  sv, d, kind: LongInt;
begin
  { kind selects the parse: 0 int32, 1 real, 2 int64. It also picks the valcode variant so
    the code output agrees with the value's range (an Int64 destination accepts a wider one). }
  sv := LowerExpr(sNode);
  if IsRealType(Nodes[destNode].Ty) then begin
    EnsureHelper('kp_str_val_real', 1, 'float');
    EmitArg(sv);
    d := NewTemp;
    PushInsn('FCALL', 'dst=' + IntToStr(d) + ' sym=kp_str_val_real nargs=1');
    StoreScalarDesig(destNode, d);
    kind := 1;
  end
  else if IsInt64(Nodes[destNode].Ty) then begin
    StoreScalarDesig(destNode, EmitStrCall1I64('kp_str_val_int64', sv));
    kind := 2;
  end
  else begin
    StoreScalarDesig(destNode, EmitStrCall1('kp_str_val_int', sv));
    kind := 0;
  end;
  StoreScalarDesig(codeNode, EmitStrCall2('kp_str_valcode', sv, EmitLIC(kind)));
  if IsOwnedExpr(sNode) then EmitRelease(sv);   { a transferred string argument is not kept }
end;

function LowerBuiltin(const bname: string; callee: LongInt;
  const argNodes: array of LongInt; var handled: Boolean): LongInt;
{ Lower a call to a built-in named `bname`, the callee symbol's lowercased name.
  Sets handled True and returns the lowered value (or -1 for a void built-in like
  write or setlength) when the name and argument count match a built-in; leaves
  handled False otherwise, so LowerCallSym falls through to a routine call. }
var
  i, d, na, arg, av, cur, delta, rTy, old, strm, aTy, rawk, kv: LongInt;
  nm: string;
begin
  handled := True;
  LowerBuiltin := -1;
  { the length builtin maps to the string or dynamic-array runtime helper }
  if (bname = 'length') and
     (Length(argNodes) = 1) then begin
    cur := LowerExpr(argNodes[0]);
    if IsDynArray(Nodes[argNodes[0]].Ty) then
      LowerBuiltin := EmitStrCall1('kp_arr_len', cur)
    else if IsMap(Nodes[argNodes[0]].Ty) then
      LowerBuiltin := EmitStrCall1('kp_map_len', cur)
    else
      LowerBuiltin := EmitStrCall1('kp_str_len', cur);
    ReleaseIfOwned(argNodes[0], cur);
    Exit;
  end;
  { high(a) and low(a) on a dynamic array: last index and 0 }
  if (bname = 'high') and
     (Length(argNodes) = 1) then begin
    if IsDynArray(Nodes[argNodes[0]].Ty) then begin
      cur := LowerExpr(argNodes[0]);
      LowerBuiltin := EmitBin('SUB', EmitStrCall1('kp_arr_len', cur), EmitLIC(1));
      ReleaseIfOwned(argNodes[0], cur);
    end
    else begin
      SemErr(callee, 'high is only supported on dynamic arrays');
      LowerBuiltin := EmitLIC(0);
    end;
    Exit;
  end;
  if (bname = 'low') and
     (Length(argNodes) = 1) then begin
    if not IsDynArray(Nodes[argNodes[0]].Ty) then
      SemErr(callee, 'low is only supported on dynamic arrays');
    LowerBuiltin := EmitLIC(0);
    Exit;
  end;
  { ord(c) and chr(i) convert between a character and its code. A character is stored as its
    byte value in an i32, so ord is the identity; chr wraps to a byte, matching the storage a
    string character write masks to. }
  if (bname = 'ord') and
     (Length(argNodes) = 1) then begin
    { a one-character string literal in ord() denotes its char code, e.g. ord('0');
      retyping it to char lowers it as the code rather than a built string handle }
    if IsCharLit(argNodes[0]) then Nodes[argNodes[0]].Ty := tyChar;
    LowerBuiltin := LowerExpr(argNodes[0]);
    Exit;
  end;
  if (bname = 'chr') and
     (Length(argNodes) = 1) then begin
    LowerBuiltin := EmitBin('AND', LowerExpr(argNodes[0]), EmitLIC(255));
    Exit;
  end;
  { fail(code) and errorcode(e) are identities on the int-code error representation: the i32
    flows through unchanged, only its static type differs. See doc/languages/kobold/kp-errors.md. }
  if ((bname = 'fail') or (bname = 'errorcode')) and
     (Length(argNodes) = 1) then begin
    LowerBuiltin := LowerExpr(argNodes[0]);
    Exit;
  end;
  { setlength(a, n) resizes the dynamic array in designator a }
  if (bname = 'setlength') and
     (Length(argNodes) = 2) then begin
    LowerSetLength(argNodes[0], argNodes[1]);
    LowerBuiltin := -1;
    Exit;
  end;
  { delete(m, key) removes a key from a map }
  if (bname = 'delete') and (Length(argNodes) = 2) and
     IsMap(Nodes[argNodes[0]].Ty) then begin
    LowerMapDelete(argNodes[0], argNodes[1]);
    LowerBuiltin := -1;
    Exit;
  end;
  { delete(a, index, count) / insert(a, index, count) edit a dynamic array in place }
  if ((bname = 'delete') or (bname = 'insert')) and
     (Length(argNodes) = 3) then begin
    LowerArrEdit(argNodes[0], argNodes[1], argNodes[2], bname = 'insert');
    LowerBuiltin := -1;
    Exit;
  end;
  { tryget(m, key, out v): copy the value to v and return true, or return false }
  if (bname = 'tryget') and (Length(argNodes) = 3) then begin
    cur := LowerExpr(argNodes[0]);
    av := AddrOf(argNodes[2]);
    if MapKeyType(Nodes[argNodes[0]].Ty) = tyStr then begin
      delta := LowerExpr(argNodes[1]);
      EnsureHelper('kp_map_tryget', 3, 'int');
      EmitArg(cur);
      EmitArg(delta);
      EmitArg(av);
      d := NewTemp;
      PushInsn('CALL', 'dst=' + IntToStr(d) + ' sym=kp_map_tryget nargs=3');
      ReleaseIfOwned(argNodes[1], delta);
    end
    else begin
      EnsureHelper('kp_imap_tryget', 3, 'int');
      EmitArg(cur);
      EmitArg64(AsInt64(argNodes[1]));   { the key by value }
      EmitArg(av);
      d := NewTemp;
      PushInsn('CALL', 'dst=' + IntToStr(d) + ' sym=kp_imap_tryget nargs=3');
    end;
    ReleaseIfOwned(argNodes[0], cur);
    LowerBuiltin := d;
    Exit;
  end;
  { mapfirst(m): a new iterator over the map (an owned handle the caller stores). The iterator
    kind matches the map's key kind so mapnext can dispatch; a string map gets kp_mapiter_new, an
    ordinal map kp_imapiter_new. }
  if (bname = 'mapfirst') and (Length(argNodes) = 1) then begin
    cur := LowerExpr(argNodes[0]);
    if MapKeyType(Nodes[argNodes[0]].Ty) = tyStr then
      LowerBuiltin := EmitStrCall1('kp_mapiter_new', cur)
    else
      LowerBuiltin := EmitStrCall1('kp_imapiter_new', cur);
    ReleaseIfOwned(argNodes[0], cur);
    Exit;
  end;
  { mapnext(it, out k, out v): advance, writing the next key and value; false at the end. The
    iterator is opaque, so dispatch on the out-key's own type: a string key is written as an
    owned handle straight into the designator; an ordinal key is written by the runtime as an
    int64 into a scratch slot, then narrowed into the designator (value-level, so endian-safe). }
  if (bname = 'mapnext') and (Length(argNodes) = 3) then begin
    cur := LowerExpr(argNodes[0]);
    delta := AddrOf(argNodes[2]);   { the value out address }
    if Nodes[argNodes[1]].Ty = tyStr then begin
      av := AddrOf(argNodes[1]);
      EnsureHelper('kp_mapiter_next', 3, 'int');
      EmitArg(cur);
      EmitArg(av);
      EmitArg(delta);
      d := NewTemp;
      PushInsn('CALL', 'dst=' + IntToStr(d) + ' sym=kp_mapiter_next nargs=3');
    end
    else begin
      rawk := NewSlot(8);
      EnsureHelper('kp_imapiter_next', 3, 'int');
      EmitArg(cur);
      EmitArg(EmitADL(rawk));
      EmitArg(delta);
      d := NewTemp;
      PushInsn('CALL', 'dst=' + IntToStr(d) + ' sym=kp_imapiter_next nargs=3');
      kv := EmitLDL64(rawk);          { the raw int64 key }
      av := AddrOf(argNodes[1]);
      if WideStore(Nodes[argNodes[1]].Ty) then
        EmitStoreScalar(av, kv, Nodes[argNodes[1]].Ty)         { an int64 key }
      else
        EmitStoreScalar(av, EmitUn('TRUNC64', kv), Nodes[argNodes[1]].Ty);
    end;
    LowerBuiltin := d;
    Exit;
  end;
  { str(x, s) formats integer x into the string designator s; an Int64 value formats through
    the 64-bit helper so a large value is not truncated to 32 bits }
  if (bname = 'str') and
     (Length(argNodes) = 2) then begin
    if IsInt64(Nodes[argNodes[0]].Ty) then begin
      EnsureHelperI64('kp_str_from_int64', 'int');
      EmitArg64(AsInt64(argNodes[0]));
      d := NewTemp;
      PushInsn('CALL', 'dst=' + IntToStr(d) + ' sym=kp_str_from_int64 nargs=1');
      StoreHandleDesig(argNodes[1], d);
    end
    else
      StoreHandleDesig(argNodes[1],
        EmitStrCall1('kp_str_from_int', LowerExpr(argNodes[0])));
    LowerBuiltin := -1;
    Exit;
  end;
  { val(s, dest, code) parses s into dest and sets code }
  if (bname = 'val') and
     (Length(argNodes) = 3) then begin
    LowerVal(argNodes[0], argNodes[1], argNodes[2]);
    LowerBuiltin := -1;
    Exit;
  end;
  { pos(sub, s) is the 1-based position of sub in s, 0 when it does not occur. The operands
    are staged in a fixed left-to-right order for deterministic emission. }
  if (bname = 'pos') and
     (Length(argNodes) = 2) then begin
    cur := LowerExpr(argNodes[0]);
    delta := LowerExpr(argNodes[1]);
    LowerBuiltin := EmitStrCall2('kp_str_pos', cur, delta);
    ReleaseIfOwned(argNodes[0], cur);
    ReleaseIfOwned(argNodes[1], delta);
    Exit;
  end;
  { copy(s, index, count) is the substring of count characters from a 1-based index }
  if (bname = 'copy') and
     (Length(argNodes) = 3) then begin
    cur := LowerExpr(argNodes[0]);
    delta := LowerExpr(argNodes[1]);
    av := LowerExpr(argNodes[2]);
    LowerBuiltin := EmitStrCall3('kp_str_copy', cur, delta, av);
    ReleaseIfOwned(argNodes[0], cur);
    Exit;
  end;
  { the release builtin drops the caller's reference to a handle (ARC-style); at zero
    the entry's kind reclaims it (see kp-abi.md). When the argument is a local variable,
    release also nils it, so the scope-exit release does not drop the reference a second
    time and a later use of it traps as nil rather than touching a reused id. }
  if (bname = 'release') and
     (Length(argNodes) = 1) then begin
    arg := argNodes[0];
    if (Nodes[arg].Kind = nkIdent) and (Nodes[arg].Sym >= 0) and
       (Syms[Nodes[arg].Sym].Kind = syVar) then begin
      av := Nodes[arg].Sym;
      EmitRelease(LoadSym(av));
      StoreSym(av, EmitLIC(0));
    end
    else
      EmitRelease(LowerExpr(arg));
    LowerBuiltin := -1;
    Exit;
  end;
  { inc(x) / dec(x), optionally by a step, adjust an ordinal designator in place }
  if (Length(argNodes) >= 1) and
     ((bname = 'inc') or (bname = 'dec')) then begin
    arg := argNodes[0];
    cur := LowerExpr(arg);
    if Length(argNodes) >= 2 then delta := LowerExpr(argNodes[1])
    else delta := EmitLIC(1);
    if bname = 'inc' then nm := 'ADD' else nm := 'SUB';
    if IsInt64(Nodes[arg].Ty) then nm := nm + '64';
    StoreScalarDesig(arg, EmitBin(nm, cur, delta));
    LowerBuiltin := -1;
    Exit;
  end;
  { succ(x) / pred(x) are the next and previous ordinal, x +/- 1, yielded as a
    value (unlike inc/dec, which store in place) }
  if (Length(argNodes) = 1) and
     ((bname = 'succ') or (bname = 'pred')) then begin
    arg := argNodes[0];
    cur := LowerExpr(arg);
    if bname = 'succ' then nm := 'ADD' else nm := 'SUB';
    if IsInt64(Nodes[arg].Ty) then nm := nm + '64';
    LowerBuiltin := EmitBin(nm, cur, EmitLIC(1));
    Exit;
  end;
  { odd(x) is true when the low bit is set: (x and 1) <> 0, an i32 boolean }
  if (Length(argNodes) = 1) and
     (bname = 'odd') then begin
    arg := argNodes[0];
    cur := LowerExpr(arg);
    if IsInt64(Nodes[arg].Ty) then
      LowerBuiltin := EmitBin('CMP64NE', EmitBin('AND64', cur, EmitLIC(1)), EmitLIC(0))
    else
      LowerBuiltin := EmitBin('CMPNE', EmitBin('AND', cur, EmitLIC(1)), EmitLIC(0));
    Exit;
  end;
  { abs(x): a real drops its sign bit (FABS); an integer is made non-negative
    branchlessly, (x xor m) - m where m is the sign broadcast by an arithmetic
    shift, so the argument is evaluated once }
  if (Length(argNodes) = 1) and
     (bname = 'abs') then begin
    arg := argNodes[0];
    if IsRealType(Nodes[arg].Ty) then
      LowerBuiltin := EmitUn('FABS', AsFloat(arg))
    else if IsInt64(Nodes[arg].Ty) then begin
      cur := AsInt64(arg);
      delta := EmitBin('SHRS64', cur, EmitLIC(63));
      LowerBuiltin := EmitBin('SUB64', EmitBin('XOR64', cur, delta), delta);
    end
    else begin
      cur := LowerExpr(arg);
      delta := EmitBin('SHRS', cur, EmitLIC(31));
      LowerBuiltin := EmitBin('SUB', EmitBin('XOR', cur, delta), delta);
    end;
    Exit;
  end;
  { sqr(x) is x*x in the argument's own type; the operand is lowered once }
  if (Length(argNodes) = 1) and
     (bname = 'sqr') then begin
    arg := argNodes[0];
    if IsRealType(Nodes[arg].Ty) then begin
      cur := AsFloat(arg);
      LowerBuiltin := EmitBin('FMUL', cur, cur);
    end
    else if IsInt64(Nodes[arg].Ty) then begin
      cur := AsInt64(arg);
      LowerBuiltin := EmitBin('MUL64', cur, cur);
    end
    else begin
      cur := LowerExpr(arg);
      LowerBuiltin := EmitBin('MUL', cur, cur);
    end;
    Exit;
  end;
  { sqrt widens an integer argument to real; round and trunc convert a real to
    an integer, round to nearest and trunc toward zero }
  if (Length(argNodes) = 1) and
     (bname = 'sqrt') then begin
    LowerBuiltin := EmitUn('FSQRT', AsFloat(argNodes[0]));
    Exit;
  end;
  if (Length(argNodes) = 1) and
     (bname = 'round') then begin
    LowerBuiltin := EmitUn('FROUND', AsFloat(argNodes[0]));
    Exit;
  end;
  if (Length(argNodes) = 1) and
     (bname = 'trunc') then begin
    LowerBuiltin := EmitUn('FTOI', AsFloat(argNodes[0]));
    Exit;
  end;
  { the transcendentals each lower to a one-argument float runtime helper }
  if (Length(argNodes) = 1) then begin
    nm := bname;
    if nm = 'sin' then begin
      LowerBuiltin := EmitMathCall('kp_sin', argNodes[0]); Exit;
    end
    else if nm = 'cos' then begin
      LowerBuiltin := EmitMathCall('kp_cos', argNodes[0]); Exit;
    end
    else if nm = 'exp' then begin
      LowerBuiltin := EmitMathCall('kp_exp', argNodes[0]); Exit;
    end
    else if nm = 'ln' then begin
      LowerBuiltin := EmitMathCall('kp_ln', argNodes[0]); Exit;
    end
    else if nm = 'arctan' then begin
      LowerBuiltin := EmitMathCall('kp_arctan', argNodes[0]); Exit;
    end;
  end;
  { exit / exit(v): set the function result, then jump to the scope-exit cleanup }
  if (bname = 'exit') then begin
    if (Length(argNodes) = 1) and (CurExitFunc >= 0) then begin
      rTy := SemTypes[Syms[CurExitFunc].TypeId].RetType;
      arg := argNodes[0];
      if IsHandle(rTy) then begin
        if IsEmptyArrayLit(arg) then cur := EmitLIC(0)
        else begin
          cur := LowerExpr(arg);
          if not IsOwnedExpr(arg) then EmitRetain(cur);
        end;
        old := EmitLDLAddr(CurResultSlot);
        EmitSTLAddr(cur, CurResultSlot);
        EmitRelease(old);
      end
      else if IsRealType(rTy) then EmitFSTL(AsFloat(arg), CurResultSlot)
      else if IsInt64(rTy) then EmitSTL64(AsInt64(arg), CurResultSlot)
      else if IsSmallSet(rTy) then EmitSTL64(LowerExpr(arg), CurResultSlot)
      else EmitSTL(LowerExpr(arg), CurResultSlot);
    end;
    EmitDeferUnwind(0);   { run all pending defers before the routine epilogue }
    if CurExitLabel < 0 then CurExitLabel := NewLabel;
    EmitJmp(CurExitLabel);
    LowerBuiltin := -1;
    Exit;
  end;
  { write(...) / writeln(...): expand into one host primitive call per argument on a
    stream. An optional leading text argument (Output or ErrOutput) selects the stream;
    it defaults to standard output. writeln appends a newline. }
  if (bname = 'write') or (bname = 'writeln') then begin
    na := Length(argNodes);
    i := 0;
    if (na > 0) and (Nodes[argNodes[0]].Ty = tyText) then begin
      strm := LowerExpr(argNodes[0]); i := 1;
    end
    else strm := EmitLIC(1);
    while i < na do begin
      arg := argNodes[i];
      aTy := Nodes[arg].Ty;
      { evaluate the argument value first: it may itself emit a call (a string literal
        materializes through kp_str_new), which must not fall between the two arg stagings }
      if aTy = tyStr then begin
        av := LowerExpr(arg);
        EnsureFunc('io_write_str', 2, 'void');
        EmitArg(strm); EmitArg(av);
        PushInsn('CALL', 'sym=io_write_str nargs=2');
        ReleaseIfOwned(arg, av);   { a written string temporary is not kept }
      end
      else if aTy = tyChar then begin
        av := LowerExpr(arg);
        EnsureFunc('io_write_char', 2, 'void');
        EmitArg(strm); EmitArg(av);
        PushInsn('CALL', 'sym=io_write_char nargs=2');
      end
      else if IsRealType(aTy) then begin
        av := AsFloat(arg);
        EnsureFuncIF('io_write_real');
        EmitArg(strm); EmitFArg(av);
        PushInsn('CALL', 'sym=io_write_real nargs=2');
      end
      else if IsInt64(aTy) then begin
        { format the full 64-bit value as a string and write that; io_write_int is
          32-bit and would truncate a large Int64 }
        EnsureHelperI64('kp_str_from_int64', 'int');
        EmitArg64(AsInt64(arg));
        av := NewTemp;
        PushInsn('CALL', 'dst=' + IntToStr(av) + ' sym=kp_str_from_int64 nargs=1');
        EnsureFunc('io_write_str', 2, 'void');
        EmitArg(strm); EmitArg(av);
        PushInsn('CALL', 'sym=io_write_str nargs=2');
        EmitRelease(av);   { the formatted string temporary is not kept }
      end
      else begin
        av := LowerExpr(arg);
        EnsureFunc('io_write_int', 2, 'void');
        EmitArg(strm); EmitArg(av);
        PushInsn('CALL', 'sym=io_write_int nargs=2');
      end;
      Inc(i);
    end;
    if bname = 'writeln' then begin
      { the trailing newline is a plain character write, the C fputc('\n') shape;
        there is no dedicated newline primitive }
      av := EmitLIC(10);
      EnsureFunc('io_write_char', 2, 'void');
      EmitArg(strm); EmitArg(av);
      PushInsn('CALL', 'sym=io_write_char nargs=2');
    end;
    LowerBuiltin := -1;
    Exit;
  end;
  { read(...) / readln(...): read values from standard input into the target
    designators, one runtime call per argument by type, then readln consumes the
    rest of the current line. There is no stream argument: input is stdin. }
  if (bname = 'read') or (bname = 'readln') then begin
    na := Length(argNodes);
    for i := 0 to na - 1 do begin
      arg := argNodes[i];
      aTy := Nodes[arg].Ty;
      if aTy = tyStr then begin
        EnsureFunc('io_read_str', 0, 'int');
        d := NewTemp;
        PushInsn('CALL', 'dst=' + IntToStr(d) + ' sym=io_read_str nargs=0');
        StoreHandleDesig(arg, d);
      end
      else if IsRealType(aTy) then begin
        EnsureFunc('io_read_real', 0, 'float');
        d := NewTemp;
        PushInsn('FCALL', 'dst=' + IntToStr(d) + ' sym=io_read_real nargs=0');
        StoreScalarDesig(arg, d);
      end
      else if aTy = tyChar then begin
        EnsureFunc('io_read_char', 0, 'int');
        d := NewTemp;
        PushInsn('CALL', 'dst=' + IntToStr(d) + ' sym=io_read_char nargs=0');
        StoreScalarDesig(arg, d);
      end
      else begin
        EnsureFunc('io_read_int', 0, 'int');
        d := NewTemp;
        if IsInt64(aTy) then
          PushInsn('CALL64', 'dst=' + IntToStr(d) + ' sym=io_read_int nargs=0')
        else
          PushInsn('CALL', 'dst=' + IntToStr(d) + ' sym=io_read_int nargs=0');
        StoreScalarDesig(arg, d);
      end;
    end;
    if bname = 'readln' then begin
      EnsureFunc('io_read_ln', 0, 'void');
      PushInsn('CALL', 'sym=io_read_ln nargs=0');
    end;
    LowerBuiltin := -1;
    Exit;
  end;
  { flush(f): flush a text stream, default standard output }
  if (bname = 'flush') then begin
    if Length(argNodes) >= 1 then strm := LowerExpr(argNodes[0]) else strm := EmitLIC(1);
    EnsureFunc('io_flush', 1, 'void');
    EmitArg(strm);
    PushInsn('CALL', 'sym=io_flush nargs=1');
    LowerBuiltin := -1;
    Exit;
  end;
  { halt / halt(code): stop the program with an exit code, default 0 }
  if (bname = 'halt') then begin
    if Length(argNodes) >= 1 then av := LowerExpr(argNodes[0]) else av := EmitLIC(0);
    EnsureFunc('io_halt', 1, 'void');
    EmitArg(av);
    PushInsn('CALL', 'sym=io_halt nargs=1');
    LowerBuiltin := -1;
    Exit;
  end;
  { abort: an unconditional fatal, like a runtime trap (exit 70, a backtrace
    where the host has one) }
  if (bname = 'abort') then begin
    EnsureFunc('kp_abort', 0, 'void');
    PushInsn('CALL', 'sym=kp_abort nargs=0');
    LowerBuiltin := -1;
    Exit;
  end;
  { assert(cond): fatal unless cond holds; the check is in the runtime so no
    branch is emitted here }
  if (bname = 'assert') and (Length(argNodes) = 1) then begin
    EnsureFunc('kp_assert', 1, 'void');
    EmitArg(LowerExpr(argNodes[0]));
    PushInsn('CALL', 'sym=kp_assert nargs=1');
    LowerBuiltin := -1;
    Exit;
  end;
  { paramcount: the number of command-line arguments }
  if (bname = 'paramcount') then begin
    EnsureFunc('ParamCount', 0, 'int');
    d := NewTemp;
    PushInsn('CALL', 'dst=' + IntToStr(d) + ' sym=ParamCount nargs=0');
    LowerBuiltin := d;
    Exit;
  end;
  { paramstr(i): the i-th command-line argument as a string }
  if (bname = 'paramstr') and
     (Length(argNodes) = 1) then begin
    EnsureFunc('ParamStr', 1, 'int');
    EmitArg(LowerExpr(argNodes[0]));
    d := NewTemp;
    PushInsn('CALL', 'dst=' + IntToStr(d) + ' sym=ParamStr nargs=1');
    LowerBuiltin := d;
    Exit;
  end;
  { the name matched no built-in: let the caller lower it as a routine call }
  handled := False;
end;

function LowerDirectCall(s: LongInt; const argNodes: array of LongInt;
  wantVal: Boolean): LongInt;
{ Lower a direct call to routine symbol s. Handles an aggregate result returned
  through caller storage (sret), staged arguments, a nested routine's captured
  variables passed as hidden by-pointer arguments, and result-class call emission. }
var
  i, sig, ret, d, na, retbuf, z, extra, errSlot: LongInt;
  aggRet, wideFail: Boolean;
  roffs, owned: TIntArray;
  args: string;
begin
  LowerDirectCall := -1;
  sig := Syms[s].TypeId;
  na := Length(argNodes);
  { a failable call captures the callee's error register into FailCaptureSlot via CALL2. Consume
    the slot now, before arguments lower, so a handled failable call in an argument gets its own
    slot rather than this one (doc/languages/kobold/kp-errors.md). }
  errSlot := -1;
  if (sig >= 0) and (SemTypes[sig].Kind = skProc) and SemTypes[sig].Failable and
     (FailCaptureSlot >= 0) then begin
    errSlot := FailCaptureSlot;
    FailCaptureSlot := -1;
  end;
  { a cross-unit routine is called by name; the linker binds the call to the defining unit's
    exported symbol, so no host import is emitted for it }
  { calling a routine that can suspend means this statement may return mid-unwind, so
    the compound loop adds a cancel check after it (cancel-by-unwind stage 2) }
  if (s >= 0) and (s <= High(CanYield)) and CanYield[s] then StmtSuspended := True;
  ret := -1;
  if (sig >= 0) and (SemTypes[sig].Kind = skProc) then ret := SemTypes[sig].RetType;
  { an aggregate result returns through caller-provided storage (sret): allocate a result
    buffer, zero its handle fields so a later copy-out and cleanup see nil, pass its address
    as a hidden final argument, and let the call evaluate to that address (an aggregate value
    is its address) }
  aggRet := (ret >= 0) and IsAggregate(ret);
  { a failable real, 64-bit, or record result returns through the same caller buffer (sret),
    with the error in the integer return register rather than the CALL2 second register }
  wideFail := (errSlot >= 0) and FailWideResult(sig);
  retbuf := -1;
  if aggRet then begin
    retbuf := NewSlot(TypeSize(ret));
    SetLength(roffs, 0);
    CollectHandleOffsets(ret, 0, roffs);
    if Length(roffs) > 0 then begin
      z := EmitLIC(0);
      for i := 0 to High(roffs) do
        EmitStorePtr(AddOff(EmitADL(retbuf), roffs[i]), z);
    end;
  end
  else if wideFail then
    retbuf := NewSlot(TypeSize(ret));   { a real or 64-bit value buffer (no handle fields) }
  StageArgs(sig, argNodes, owned);
  { a nested routine's captured variables follow as hidden by-pointer arguments }
  for i := 0 to High(RoutineCaptures[s]) do EmitArg(VarAddr(RoutineCaptures[s][i]));
  extra := Length(RoutineCaptures[s]);
  if aggRet or wideFail then begin EmitArgPtr(EmitADL(retbuf)); Inc(extra); end;
  args := 'sym=' + EmittedRoutineName(s) + ' nargs=' + IntToStr(na + extra);
  if wideFail then begin
    { ordinary call: the integer return register holds the error, the value is in retbuf }
    d := NewTemp;
    PushInsn('CALL', 'dst=' + IntToStr(d) + ' ' + args);
    EmitSTL(d, errSlot);
    if wantVal and (ret >= 0) then begin
      if aggRet then LowerDirectCall := EmitADL(retbuf)
      else LowerDirectCall := EmitLoadScalar(EmitADL(retbuf), ret);
    end;
  end
  else if errSlot >= 0 then begin
    { failable: CALL2 puts the value in dst (integer-class) and the error into errSlot }
    if wantVal and (ret >= 0) then begin
      d := NewTemp;
      PushInsn('CALL2', 'dst=' + IntToStr(d) + ' slot=' + IntToStr(errSlot) + ' ' + args);
      LowerDirectCall := d;
    end
    else
      PushInsn('CALL2', 'dst=-1 slot=' + IntToStr(errSlot) + ' ' + args);
  end
  else if aggRet then begin
    PushInsn('CALL', args);        { the callee fills the buffer; its value is the buffer }
    LowerDirectCall := EmitADL(retbuf);
  end
  else if wantVal and (ret >= 0) then begin
    d := NewTemp;
    EmitTypedCall(d, ret, 'CALL', args);
    LowerDirectCall := d;
  end
  else
    PushInsn('CALL', args);
  ReleaseOwnedArgs(owned);
end;

function LowerCallSym(callee: LongInt; const argNodes: array of LongInt;
  wantVal: Boolean): LongInt;
{ Lower a call whose callee designator is `callee`, classifying it: a process-typed
  callee is a coroutine resume; a field is a method dispatch or a proc-typed field's
  pointer; a type name applied to one argument is a conversion; a built-in name lowers
  through LowerBuiltin; a proc-typed variable or parameter is an indirect call through
  its code pointer; a routine name is a direct call through LowerDirectCall. }
var
  s, cty, arg, r: LongInt;
  handled: Boolean;
  bname: string;
begin
  LowerCallSym := -1;
  { resuming a process, k(v): a callee of process type is a coroutine resume, wherever
    the process comes from -- a variable, parameter, array element, or record field.
    LowerResume loads the id through LowerExpr, so any designator works. An identifier
    callee carries its type on the symbol; an indexed or field callee carries it on the
    node, so consult both. }
  cty := Nodes[callee].Ty;
  if (cty < 0) and (Nodes[callee].Kind = nkIdent) and (Nodes[callee].Sym >= 0) and
     (Syms[Nodes[callee].Sym].Kind in [syVar, syParam]) then
    cty := Syms[Nodes[callee].Sym].TypeId;
  if (cty >= 0) and (cty < SemCount) and (SemTypes[cty].Kind = skProcess) then begin
    LowerCallSym := LowerResume(callee, argNodes);
    Exit;
  end;
  { a field callee is a unit-qualified free call (Flag 1), a method dispatch, or a
    proc-typed field's pointer }
  if Nodes[callee].Kind = nkField then begin
    if Nodes[callee].Flag = 1 then
      LowerCallSym := LowerDirectCall(Nodes[callee].Sym, argNodes, wantVal)
    else if IsMethodField(callee) then
      LowerCallSym := LowerMethodCall(callee, argNodes, wantVal)
    else
      LowerCallSym := LowerIndirectCall(LowerExpr(callee), ProcFieldSig(callee),
        argNodes, wantVal);
    Exit;
  end;
  { a computed designator of procedural type (an array element, table[i], or any
    other non-identifier, non-field callee) holds a code pointer: call it
    indirectly through its value, mirroring the process-resume path above. An
    identifier variable or parameter is handled by the LoadSym path below. }
  if (cty >= 0) and (cty < SemCount) and (SemTypes[cty].Kind = skProc) and
     (Nodes[callee].Kind <> nkIdent) then begin
    LowerCallSym := LowerIndirectCall(LowerExpr(callee), cty, argNodes, wantVal);
    Exit;
  end;
  s := Nodes[callee].Sym;
  if s < 0 then Exit;
  { a built-in name resolves to a symbol with no defining node; bname is its lowercased
    name, or '' for a user symbol (including a cross-unit import), so the dispatch below
    tests one string. }
  if (Syms[s].Node < 0) and not Syms[s].Imported then bname := Syms[s].LowerName
  else bname := '';
  { a type name applied to one argument is a conversion: widen or narrow between integer
    widths, or reinterpret an ordinal of the same width }
  if (Syms[s].Kind = syType) and (Length(argNodes) = 1) then begin
    cty := Syms[s].TypeId;
    arg := argNodes[0];
    if IsRealType(cty) then LowerCallSym := AsFloat(arg)
    else if IsInt64(cty) then LowerCallSym := AsInt64(arg)
    else if IsIntClass(cty) and IsInt64(Nodes[arg].Ty) then
      LowerCallSym := EmitUn('TRUNC64', LowerExpr(arg))
    else
      LowerCallSym := LowerExpr(arg);
    Exit;
  end;
  { a built-in name (write, length, abs, ...) lowers through LowerBuiltin }
  r := LowerBuiltin(bname, callee, argNodes, handled);
  if handled then begin
    LowerCallSym := r;
    Exit;
  end;
  { a variable or parameter callee holds a code pointer: call it indirectly. The
    pointer is evaluated before the arguments stage. }
  if Syms[s].Kind in [syVar, syParam] then begin
    LowerCallSym := LowerIndirectCall(LoadSym(s), Syms[s].TypeId, argNodes, wantVal);
    Exit;
  end;
  { a direct call to a routine }
  LowerCallSym := LowerDirectCall(s, argNodes, wantVal);
end;

function LowerCall(node: LongInt; wantVal: Boolean): LongInt;
{ node is nkCall: A = callee designator, Kids = argument expressions. }
begin
  LowerCall := LowerCallSym(Nodes[node].A, Nodes[node].Kids, wantVal);
end;

{ ---- failable call-site lowering (doc/languages/kobold/kp-errors.md) ---- }

function LowerFailableCall(target: LongInt; wantVal: Boolean; var errTemp: LongInt): LongInt;
{ Lower the call of a failable form: a fresh slot receives the callee's error register (the call
  path emits CALL2 when it sees FailCaptureSlot), the value lands as usual. Returns the value
  temp (or -1) and sets errTemp to the loaded error code. }
var
  errSlot, saved, v: LongInt;
  noArgs: TIntArray;
begin
  errSlot := NewSlot(4);
  saved := FailCaptureSlot;
  FailCaptureSlot := errSlot;
  if Nodes[target].Kind = nkCall then v := LowerCall(target, wantVal)
  else begin
    SetLength(noArgs, 0);
    v := LowerCallSym(target, noArgs, wantVal);   { a bare paramless routine }
  end;
  FailCaptureSlot := saved;
  errTemp := EmitLDL(errSlot);
  LowerFailableCall := v;
end;

procedure EmitFailDivert(flag, err: LongInt);
{ The failure path of an `or exit|break|continue|fail`. exit/break/continue leave with the error
  register still zero (success reported upward); `or fail` forwards the inner error unchanged. }
begin
  case flag of
    1: if LoopSP > 0 then begin
      EmitDeferUnwind(LoopDeferBase[LoopSP - 1]);
      EmitJmp(LoopBreak[LoopSP - 1]);
    end;
    2: if LoopSP > 0 then begin
      EmitDeferUnwind(LoopDeferBase[LoopSP - 1]);
      EmitJmp(LoopCont[LoopSP - 1]);
    end;
    3: begin
      EmitSTL(err, CurErrorSlot);   { forward the callee's error from this failable routine }
      EmitDeferUnwind(0);
      if CurExitLabel < 0 then CurExitLabel := NewLabel;
      EmitJmp(CurExitLabel);
    end;
  else
    { exit }
    EmitDeferUnwind(0);
    if CurExitLabel < 0 then CurExitLabel := NewLabel;
    EmitJmp(CurExitLabel);
  end;
end;

function LowerFailForm(node: LongInt; wantVal: Boolean): LongInt;
{ Lower nkFailsTest (to a boolean), nkOrElse (value, or void for `ignore`), or nkOrDivert
  (value on success, a control transfer on failure). }
var
  v, err, fb, rslot, lEnd, oty: LongInt;
  managed: Boolean;
begin
  LowerFailForm := -1;
  case Nodes[node].Kind of
    nkFailsTest: begin
      LowerFailableCall(Nodes[node].A, False, err);
      if Nodes[node].Sym >= 0 then begin
        { the binder is declared in sema but has no var-decl node, so give it a slot here }
        if Syms[Nodes[node].Sym].Slot < 0 then Syms[Nodes[node].Sym].Slot := NewSlot(4);
        StoreSym(Nodes[node].Sym, err);   { bind the error }
      end;
      LowerFailForm := EmitBin('CMPNE', err, EmitLIC(0));   { true when the call failed }
    end;
    nkOrElse:
      if Nodes[node].Flag = 1 then
        LowerFailableCall(Nodes[node].A, False, err)   { or else ignore: drop value and error }
      else begin
        oty := Nodes[node].Ty;
        if IsAggregate(oty) then begin
          { a record (or large-set) result: the success value is already in the callee's buffer,
            addressed by v. On failure, copy the fallback record into that same buffer with the
            managed-copy ownership an assignment uses, so the buffer holds an owned value on both
            paths and the result (its address) flows out like a plain aggregate return. }
          v := LowerFailableCall(Nodes[node].A, True, err);
          lEnd := NewLabel;
          EmitBZ(err, lEnd);
          CopyAggregateManaged(v, LowerExpr(Nodes[node].B), oty);
          EmitLabel(lEnd);
          LowerFailForm := v;
        end
        else if IsRealType(oty) or Wide64(oty) then begin
          { a real or 64-bit result: both paths round-trip through a value slot of the result's
            width, stored and loaded by class (no managed handles in these types) }
          rslot := NewSlot(TypeSize(oty));
          v := LowerFailableCall(Nodes[node].A, True, err);
          EmitStoreScalar(EmitADL(rslot), v, oty);
          lEnd := NewLabel;
          EmitBZ(err, lEnd);
          { the fallback must reach the result's width before the store: an Int64 result
            sign-extends a 32-bit fallback (SEXT64, else `or else -1` stores 0x00000000FFFFFFFF),
            a real result widens an integer one (ITOF); a set is already 64-bit and passes
            through. The success value v is already the result's width. }
          if IsInt64(oty) then fb := AsInt64(Nodes[node].B)
          else if IsRealType(oty) then fb := AsFloat(Nodes[node].B)
          else fb := LowerExpr(Nodes[node].B);
          EmitStoreScalar(EmitADL(rslot), fb, oty);
          EmitLabel(lEnd);
          LowerFailForm := EmitLoadScalar(EmitADL(rslot), oty);
        end
        else begin
          { or else EXPR: the value on success, the fallback (evaluated only on failure) otherwise.
            The result round-trips through a slot and flows out as an owned transfer (IsOwnedExpr),
            so both paths must leave an owned (+1) reference in it when the type is managed: the
            success value is the callee's owned result, and a borrowed fallback is made owned the
            same way an assignment does (clone a value array/map, retain a reference handle). On
            failure the callee returns a nil value, so overwriting the slot leaks nothing. }
          { a managed handle result is pointer-width (8 bytes under LP64); a plain
            32-bit scalar result keeps a 4-byte slot. Both round-trip through rslot. }
          managed := IsPtrSized(oty);
          if managed then rslot := NewSlot(CurTarget.PtrBytes) else rslot := NewSlot(4);
          v := LowerFailableCall(Nodes[node].A, True, err);
          if managed then EmitSTLAddr(v, rslot) else EmitSTL(v, rslot);
          lEnd := NewLabel;
          EmitBZ(err, lEnd);
          fb := LowerExpr(Nodes[node].B);
          if not IsOwnedExpr(Nodes[node].B) then begin
            if IsDynArray(oty) and not IsBuffer(oty) then
              fb := EmitStrCall1('kp_arr_clone', fb)
            else if IsMap(oty) then
              fb := EmitStrCall1('kp_map_clone', fb)
            else if IsHandle(oty) or (oty = tyStr) then
              EmitRetain(fb);
          end;
          if managed then EmitSTLAddr(fb, rslot) else EmitSTL(fb, rslot);
          EmitLabel(lEnd);
          if managed then LowerFailForm := EmitLDLAddr(rslot) else LowerFailForm := EmitLDL(rslot);
        end;
      end;
    nkOrDivert: begin
      v := LowerFailableCall(Nodes[node].A, wantVal, err);
      lEnd := NewLabel;
      EmitBZ(err, lEnd);        { success: skip the divert, let the value flow out }
      EmitFailDivert(Nodes[node].Flag, err);
      EmitLabel(lEnd);
      LowerFailForm := v;
    end;
  end;
end;

{ ---- coroutine lowering ---- }

function BodyHasYield(node: LongInt): Boolean;
{ True when a routine body suspends directly, through a yield or bind. It does not
  descend into a `start begin..end` block (nkStart): those yields belong to the lifted
  entry, not this routine. A yield reached only through a call is not seen here either,
  so this reports the single-frame case cancel-by-unwind handles (see doc/languages/kobold/kobold.md). }
var
  i: LongInt;
begin
  BodyHasYield := False;
  if node < 0 then Exit;
  case Nodes[node].Kind of
    nkYield, nkBind: Exit(True);
    { a start block's yields belong to its lifted entry, and a nested routine's to
      itself, so neither counts as this routine suspending directly }
    nkStart, nkProcDecl, nkFuncDecl: Exit(False);
  end;
  if BodyHasYield(Nodes[node].A) then Exit(True);
  if BodyHasYield(Nodes[node].B) then Exit(True);
  if BodyHasYield(Nodes[node].C) then Exit(True);
  if BodyHasYield(Nodes[node].D) then Exit(True);
  for i := 0 to High(Nodes[node].Kids) do
    if BodyHasYield(Nodes[node].Kids[i]) then Exit(True);
end;

procedure EmitCancelCheck;
{ After a yield, branch to the routine's cleanup label if the coroutine is being torn
  down. kp_co_cancelling is 0 in normal flow, so this is a not-taken branch then; on a
  cancel-unwind it jumps to the scope-exit releases (cancel-by-unwind, Stage 1). }
var
  c: LongInt;
begin
  if CurCancelLabel < 0 then Exit;
  EnsureHelper('kp_co_cancelling', 0, 'int');
  c := NewTemp;
  PushInsn('CALL', 'dst=' + IntToStr(c) + ' sym=kp_co_cancelling nargs=0');
  EmitBNZ(c, CurCancelLabel);
end;

function LowerYield(node: LongInt): LongInt;
{ yield E: suspend the current coroutine, delivering E (or 0), and evaluate to the
  value the next resume passes back. Lowers to kp_co_yield. }
var
  v, d, vty, vkind: LongInt;
begin
  { Lower the yielded value first (so the instruction order is unchanged), then pass
    it as one coroutine-protocol word.  On LP64 the hosted kp_co_yield takes a full
    int64_t, so a handle crosses pointer-wide and an ordinal/Int64 is widened to 64
    bits; ILP32 keeps the single 32-bit ARG, which matches both the hosted (narrowed)
    and the freestanding i32 value ABIs byte for byte. vkind: 0 = ARG, 1 = ARG ptr,
    2 = ARG64. }
  vkind := 0;
  if Nodes[node].A >= 0 then begin
    vty := Nodes[Nodes[node].A].Ty;
    if CurTarget.PtrBytes <> 8 then v := LowerExpr(Nodes[node].A)
    else if IsPtrSized(vty) then begin v := LowerExpr(Nodes[node].A); vkind := 1; end
    else if IsRealType(vty) or IsAggregate(vty) then v := LowerExpr(Nodes[node].A)
    else begin v := AsInt64(Nodes[node].A); vkind := 2; end;
  end
  else if CurTarget.PtrBytes = 8 then begin v := EmitUn('SEXT64', EmitLIC(0)); vkind := 2; end
  else v := EmitLIC(0);
  EnsureHelper('kp_co_yield', 1, 'int');
  if vkind = 1 then EmitArgPtr(v)
  else if vkind = 2 then EmitArg64(v)
  else EmitArg(v);
  d := NewTemp;
  PushInsn('CALL', 'dst=' + IntToStr(d) + ' sym=kp_co_yield nargs=1');
  EmitCancelCheck;
  LowerYield := d;
end;

function LowerResume(callee: LongInt; const argNodes: array of LongInt): LongInt;
{ k(v): resume the process `callee` with value v (or 0), evaluating to the value it
  yields. The first resume runs the body from the top, so v is ignored then. }
var
  kv, v, d, vty, vkind: LongInt;
begin
  kv := LowerExpr(callee);
  { Lower the resume value up front (unchanged instruction order), then pass it as one
    coroutine-protocol word.  On LP64 the hosted kp_co_resume takes a full int64_t, so
    a handle crosses pointer-wide and an ordinal/Int64 is widened to 64 bits; ILP32
    keeps the single 32-bit ARG, which matches both the hosted (narrowed) and the
    freestanding i32 value ABIs byte for byte. vkind: 0 = ARG, 1 = ARG ptr, 2 = ARG64. }
  vkind := 0;
  if Length(argNodes) >= 1 then begin
    vty := Nodes[argNodes[0]].Ty;
    if CurTarget.PtrBytes <> 8 then v := LowerExpr(argNodes[0])
    else if IsPtrSized(vty) then begin v := LowerExpr(argNodes[0]); vkind := 1; end
    else if IsRealType(vty) or IsAggregate(vty) then v := LowerExpr(argNodes[0])
    else begin v := AsInt64(argNodes[0]); vkind := 2; end;
  end
  else if CurTarget.PtrBytes = 8 then begin v := EmitUn('SEXT64', EmitLIC(0)); vkind := 2; end
  else v := EmitLIC(0);
  EnsureHelper('kp_co_resume', 2, 'int');
  EmitArgPtr(kv);   { the process handle }
  if vkind = 1 then EmitArgPtr(v)
  else if vkind = 2 then EmitArg64(v)
  else EmitArg(v);
  d := NewTemp;
  PushInsn('CALL', 'dst=' + IntToStr(d) + ' sym=kp_co_resume nargs=2');
  LowerResume := d;
end;

function EmitSpawn(entry, argsPtr, na: LongInt): LongInt;
{ Emit kp_co_new(entry, argsPtr, na), evaluating to the new process handle. }
var
  d: LongInt;
begin
  EnsureHelper('kp_co_new', 3, 'int');
  EmitArgPtr(entry);     { a code address }
  EmitArgPtr(argsPtr);   { a buffer address }
  EmitArg(EmitLIC(na));
  d := NewTemp;
  PushInsn('CALL', 'dst=' + IntToStr(d) + ' sym=kp_co_new nargs=3');
  EmitSpawn := d;
end;

function LowerStart(node: LongInt): LongInt;
{ start worker(args): create a suspended coroutine whose entry is `worker` and whose
  by-value seed arguments sit in a small buffer, and evaluate to the process handle.
  start begin..end: the block is lifted to a synthesized parameterless entry, queued
  for lowering after this routine (see LowerPendingStartEntries). }
var
  callExpr, callee, s, na, i, entry, buf, argsPtr, addr: LongInt;
  arg, q: LongInt;
  name: string;
begin
  if Nodes[node].Flag = 1 then begin
    Inc(StartEntrySeq);
    name := '.co.' + IntToStr(StartEntrySeq);
    q := StartQueueCount;
    SetLength(StartQueueName, q + 1);
    SetLength(StartQueueBody, q + 1);
    StartQueueName[q] := name;
    StartQueueBody[q] := Nodes[node].A;   { the compound block body }
    Inc(StartQueueCount);
    LowerStart := EmitSpawn(EmitLEA(name), EmitLIC(0), 0);
    Exit;
  end;
  { the body is a call `worker(args)`, or a bare routine name `worker` with no args }
  callExpr := Nodes[node].A;
  if Nodes[callExpr].Kind = nkCall then begin
    callee := Nodes[callExpr].A;
    na := Length(Nodes[callExpr].Kids);
  end
  else begin
    callee := callExpr;
    na := 0;
  end;
  s := Nodes[callee].Sym;
  if na > 0 then begin
    { spawn a synthesized thunk that unpacks the seed buffer and calls the worker;
      the worker itself uses the routine calling convention, not the entry ABI }
    Inc(StartEntrySeq);
    name := '.coentry.' + IntToStr(StartEntrySeq);
    q := CoThunkCount;
    SetLength(CoThunkName, q + 1);
    SetLength(CoThunkWorker, q + 1);
    CoThunkName[q] := name;
    CoThunkWorker[q] := s;
    Inc(CoThunkCount);
    entry := EmitLEA(name);
    buf := NewSlot(na * 8);
    for i := 0 to na - 1 do begin
      if i = 0 then addr := EmitADL(buf)
      else addr := AddOff(EmitADL(buf), i * 8);
      arg := Nodes[callExpr].Kids[i];
      if IsRealType(Nodes[arg].Ty) then EmitFSD(addr, AsFloat(arg))
      else EmitST64(addr, LowerExpr(arg));
    end;
    argsPtr := EmitADL(buf);
  end
  else begin
    { no seed arguments: the worker reads none, so it can be the entry directly }
    entry := EmitLEA(EmittedRoutineName(s));
    argsPtr := EmitLIC(0);
  end;
  LowerStart := EmitSpawn(entry, argsPtr, na);
end;

function LowerBind(node: LongInt): LongInt;
{ bind k in E: bind k to the current coroutine handle, then suspend delivering E and
  evaluate to the resume value. k is a borrowed handle usable within E (a scheduler
  typically borrows it), so it is neither retained nor released. }
var
  s, selfId, ev, d: LongInt;
begin
  EnsureHelper('kp_co_self', 0, 'int');
  selfId := NewTemp;
  PushInsn('CALL', 'dst=' + IntToStr(selfId) + ' sym=kp_co_self nargs=0');
  s := Nodes[node].Sym;
  if s >= 0 then begin
    Syms[s].Slot := NewSlot(4);
    StoreSym(s, selfId);
  end;
  ev := LowerExpr(Nodes[node].A);
  EnsureHelper('kp_co_yield', 1, 'int');
  EmitArg(ev);
  d := NewTemp;
  PushInsn('CALL', 'dst=' + IntToStr(d) + ' sym=kp_co_yield nargs=1');
  EmitCancelCheck;
  LowerBind := d;
end;

{ ---- expression lowering ---- }

function BinOpName(op: TTokenKind): string;
begin
  case op of
    tkPlus:  BinOpName := 'ADD';
    tkMinus: BinOpName := 'SUB';
    tkStar:  BinOpName := 'MUL';
    tkDiv:   BinOpName := 'DIVS';
    tkMod:   BinOpName := 'MODS';
    tkAnd:   BinOpName := 'AND';
    tkOr:    BinOpName := 'OR';
    tkShl:   BinOpName := 'SHL';
    tkShr:   BinOpName := 'SHRU';
    tkEq:    BinOpName := 'CMPEQ';
    tkNeq:   BinOpName := 'CMPNE';
    tkLt:    BinOpName := 'CMPLTS';
    tkLe:    BinOpName := 'CMPLES';
    tkGt:    BinOpName := 'CMPGTS';
    tkGe:    BinOpName := 'CMPGES';
  else
    BinOpName := '';
  end;
end;

function BinOpName64(op: TTokenKind): string;
{ The 64-bit form of an integer operator, for Int64 operands. `shr` stays logical, like
  the 32-bit SHRU; the compares are signed, matching BinOpName. }
begin
  case op of
    tkPlus:  BinOpName64 := 'ADD64';
    tkMinus: BinOpName64 := 'SUB64';
    tkStar:  BinOpName64 := 'MUL64';
    tkDiv:   BinOpName64 := 'DIVS64';
    tkMod:   BinOpName64 := 'MODS64';
    tkAnd:   BinOpName64 := 'AND64';
    tkOr:    BinOpName64 := 'OR64';
    tkShl:   BinOpName64 := 'SHL64';
    tkShr:   BinOpName64 := 'SHRU64';
    tkEq:    BinOpName64 := 'CMP64EQ';
    tkNeq:   BinOpName64 := 'CMP64NE';
    tkLt:    BinOpName64 := 'CMP64LTS';
    tkLe:    BinOpName64 := 'CMP64LES';
    tkGt:    BinOpName64 := 'CMP64GTS';
    tkGe:    BinOpName64 := 'CMP64GES';
  else
    BinOpName64 := '';
  end;
end;

function IsCmp(op: TTokenKind): Boolean;
begin
  IsCmp := op in [tkEq, tkNeq, tkLt, tkLe, tkGt, tkGe];
end;

function Int64Operands(node: LongInt): Boolean;
{ True when an integer binary operation runs at 64-bit width: an arithmetic result that is
  Int64, or a comparison with an Int64 operand. }
begin
  if IsCmp(Nodes[node].Op) then
    Int64Operands := IsInt64(Nodes[Nodes[node].A].Ty) or
                     IsInt64(Nodes[Nodes[node].B].Ty)
  else
    Int64Operands := IsInt64(Nodes[node].Ty);
end;

function LowerFloatBinary(node: LongInt): LongInt;
{ Lower an arithmetic or comparison whose operand(s) are real. Operands are
  coerced to float; comparisons yield a 0/1 boolean directly. }
var
  a, b, one: LongInt;
begin
  a := AsFloat(Nodes[node].A);
  b := AsFloat(Nodes[node].B);
  case Nodes[node].Op of
    tkPlus:  LowerFloatBinary := EmitBin('FADD', a, b);
    tkMinus: LowerFloatBinary := EmitBin('FSUB', a, b);
    tkStar:  LowerFloatBinary := EmitBin('FMUL', a, b);
    tkSlash: LowerFloatBinary := EmitBin('FDIV', a, b);
    tkEq:    LowerFloatBinary := EmitBin('FCMPEQ', a, b);
    tkNeq: begin
      one := EmitLIC(1);
      LowerFloatBinary := EmitBin('XOR', EmitBin('FCMPEQ', a, b), one);
    end;
    tkLt:    LowerFloatBinary := EmitBin('FCMPLT', a, b);
    tkLe:    LowerFloatBinary := EmitBin('FCMPLE', a, b);
    tkGt:    LowerFloatBinary := EmitBin('FCMPLT', b, a);   { a > b  <=>  b < a }
    tkGe:    LowerFloatBinary := EmitBin('FCMPLE', b, a);   { a >= b <=>  b <= a }
  else
    LowerFloatBinary := EmitLIC(0);
  end;
end;

function FloatOperands(node: LongInt): Boolean;
{ True when a binary node should lower on the float path: a real result, or a
  comparison with a real operand. }
begin
  FloatOperands := IsRealType(Nodes[node].Ty) or
    (Nodes[node].Op = tkSlash) or
    (IsCmp(Nodes[node].Op) and
     (IsRealType(Nodes[Nodes[node].A].Ty) or IsRealType(Nodes[Nodes[node].B].Ty)));
end;

function StrOperands(node: LongInt): Boolean;
{ True when a comparison is between strings, so it compares by value rather than by the
  handle id an integer compare would use. }
begin
  StrOperands := IsCmp(Nodes[node].Op) and
    ((Nodes[Nodes[node].A].Ty = tyStr) or (Nodes[Nodes[node].B].Ty = tyStr));
end;

function LowerStrCompare(node: LongInt): LongInt;
{ A comparison of two strings: kp_str_cmp yields a sign (< 0, 0, > 0) which the
  operator's integer test then compares against zero. A char operand is boxed. The operands
  are staged in a fixed order for deterministic emission. }
var
  c, la, lb: LongInt;
begin
  la := AsStr(Nodes[node].A);
  lb := AsStr(Nodes[node].B);
  c := EmitStrCall2('kp_str_cmp', la, lb);
  ReleaseIfOwned(Nodes[node].A, la);
  ReleaseIfOwned(Nodes[node].B, lb);
  LowerStrCompare := EmitBin(BinOpName(Nodes[node].Op), c, EmitLIC(0));
end;

function LowerShortCircuit(node: LongInt): LongInt;
{ Boolean `and`/`or` evaluate the right operand only when the left does not already
  decide the result, matching Pascal's default short-circuit semantics (an operand may
  have side effects, and a left guard may protect the right, as in
  `(i < n) and (a[i] = x)`). The result flows through a scratch slot because it comes
  from one of two paths. }
var
  sl, a, b, lDone: LongInt;
begin
  sl := NewSlot(4);
  lDone := NewLabel;
  a := LowerExpr(Nodes[node].A);
  EmitSTL(a, sl);
  if Nodes[node].Op = tkAnd then EmitBZ(a, lDone)   { false and B is false }
  else EmitBNZ(a, lDone);                           { true or B is true }
  b := LowerExpr(Nodes[node].B);
  EmitSTL(b, sl);
  EmitLabel(lDone);
  LowerShortCircuit := EmitLDL(sl);
end;

function ComputedFieldGetter(node: LongInt): string;
{ The getter method name if nkField `node` reads a computed record field, else ''
  (doc/languages/kobold/kp-property.md). }
var
  rt, m: LongInt;
begin
  ComputedFieldGetter := '';
  if (Nodes[node].Kind <> nkField) or (Nodes[node].Flag = 1) then Exit;
  rt := Nodes[Nodes[node].A].Ty;
  if (rt < 0) or (rt >= SemCount) or (SemTypes[rt].Kind <> skRecord) then Exit;
  m := FindMember(rt, Nodes[node].Text);
  if (m >= 0) and (SemTypes[rt].PropGet[m] <> '') then
    ComputedFieldGetter := SemTypes[rt].PropGet[m];
end;

function LowerComputedFieldRead(node: LongInt; const getter: string): LongInt;
{ Read a computed record field by calling its getter method: synthesize rec.getter(). }
var
  sf: LongInt;
begin
  sf := NewNode(nkField);
  Nodes[sf].A := Nodes[node].A;
  Nodes[sf].Text := getter;
  LowerComputedFieldRead := LowerMethodCall(sf, [], True);
end;

function LowerToStr(node: LongInt): LongInt;
{ Lower an interpolation hole (nkToStr) to a string value, the same rendering
  write uses: a string is the identity, a char through kp_str_from_char, int64
  through kp_str_from_int64, and everything else (int widths, bool, enum) through
  kp_str_from_int. (A real is rejected in the checker.) }
var
  t, d: LongInt;
begin
  t := Nodes[Nodes[node].A].Ty;
  if t = tyStr then
    LowerToStr := LowerExpr(Nodes[node].A)
  else if t = tyChar then
    LowerToStr := EmitStrCall1('kp_str_from_char', LowerExpr(Nodes[node].A))
  else if IsInt64(t) then begin
    EnsureHelperI64('kp_str_from_int64', 'int');
    EmitArg64(AsInt64(Nodes[node].A));
    d := NewTemp;
    PushInsn('CALL', 'dst=' + IntToStr(d) + ' sym=kp_str_from_int64 nargs=1');
    LowerToStr := d;
  end
  else
    LowerToStr := EmitStrCall1('kp_str_from_int', LowerExpr(Nodes[node].A));
end;

function LowerExpr(node: LongInt): LongInt;
var
  s, a, b, one, r: LongInt;
  nm: string;
begin
  LowerExpr := -1;
  if node < 0 then Exit;
  case Nodes[node].Kind of
    nkIntLit:
      if IsInt64(Nodes[node].Ty) then LowerExpr := EmitLIC64(Nodes[node].IntVal)
      else LowerExpr := EmitLIC(Nodes[node].IntVal);
    nkRealLit: LowerExpr := EmitRealConst(Nodes[node].Text);
    nkLabelAddr:
      { `@name` is the address of a local code label, a label value }
      LowerExpr := EmitLabAddr(LowerLabelId(Nodes[node].Text));
    nkStrLit:
      { a one-character literal retyped to char by its context lowers as a character code }
      if Nodes[node].Ty = tyChar then
        LowerExpr := EmitLIC(Ord(Nodes[node].Text[1]))
      else
        LowerExpr := LowerStringLit(node);
    nkToStr: LowerExpr := LowerToStr(node);
    nkIdent: begin
      s := Nodes[node].Sym;
      if (s >= 0) and (Syms[s].Kind in [syProc, syFunc]) and
         (Nodes[node].Ty >= 0) and (SemTypes[Nodes[node].Ty].Kind = skProc) then
        { a routine named as a value is a bare code pointer }
        LowerExpr := EmitLEA(EmittedRoutineName(s))
      else if (s >= 0) and (Syms[s].Kind = syFunc) and (s = CurFuncSym) then
        { the current function's result read by its name; the result slot holds a scalar or
          a handle id }
        LowerExpr := LoadSym(s)
      else if (s >= 0) and (Syms[s].Kind = syFunc) then
        { a paramless function used as a value is a call }
        LowerExpr := LowerCallSym(node, [], True)
      else if (s >= 0) and IsPropertySym(s) then
        { a property read is a getter call whatever its type; for an aggregate type the
          call returns the value through its sret buffer, whose address LoadSym yields
          (doc/languages/kobold/kp-property.md) }
        LowerExpr := LoadSym(s)
      else if (s >= 0) and IsAggregate(Syms[s].TypeId) then
        { an aggregate value is its address }
        LowerExpr := AddrOf(node)
      else if s >= 0 then
        LowerExpr := LoadSym(s)
      else
        LowerExpr := EmitLIC(0);
    end;
    nkField: begin
      if Nodes[node].Flag = 1 then begin
        { a unit-qualified reference: a routine used as a value is a zero-arg call, a
          const or var loads its symbol directly }
        s := Nodes[node].Sym;
        if (s >= 0) and (Syms[s].Kind in [syProc, syFunc]) then
          LowerExpr := LowerCallSym(node, [], True)
        else
          LowerExpr := LoadSym(s);
      end
      else if ComputedFieldGetter(node) <> '' then
        { a computed record field reads through its getter method }
        LowerExpr := LowerComputedFieldRead(node, ComputedFieldGetter(node))
      else if IsMethodField(node) then
        { a no-argument method named as a value auto-calls, e.g. ok := e.alive }
        LowerExpr := LowerMethodCall(node, [], True)
      else if IsAggregate(Nodes[node].Ty) then LowerExpr := AddrOf(node)
      else LowerExpr := EmitLoadScalar(AddrOf(node), Nodes[node].Ty);
    end;
    nkIndex:
      { AddrOf handles a fixed or dynamic array element uniformly; the element is loaded
        from that address, or, for an aggregate element, its address is the value. A string
        character is a byte read from the string's storage. }
      if IsStrIndex(node) then LowerExpr := EmitLB(StrCharAddr(node))
      else if not IsAggregate(Nodes[node].Ty)
              and IsDynArray(Nodes[Nodes[node].A].Ty)
              and (BufRank(Nodes[Nodes[node].A].Ty) = 1)
              and IsOwnedExpr(Nodes[node].A) then begin
        { indexing an owned dynamic-array temporary: load the element, then release the
          temporary the index borrowed, after the load has read from its storage }
        a := DynElemAddr(node, b);
        r := EmitLoadScalar(a, Nodes[node].Ty);
        EmitRelease(b);
        LowerExpr := r;
      end
      else if IsAggregate(Nodes[node].Ty) then LowerExpr := AddrOf(node)
      else LowerExpr := EmitLoadScalar(AddrOf(node), Nodes[node].Ty);
    nkSetConstructor: LowerExpr := LowerSet(node);
    nkUnary: begin
      case Nodes[node].Op of
        tkPlus:  LowerExpr := LowerExpr(Nodes[node].A);
        tkMinus:
          if IsRealType(Nodes[node].Ty) then
            LowerExpr := EmitUn('FNEG', AsFloat(Nodes[node].A))
          else if IsInt64(Nodes[node].Ty) then
            LowerExpr := EmitUn('NEG64', AsInt64(Nodes[node].A))
          else
            LowerExpr := EmitUn('NEG', LowerExpr(Nodes[node].A));
        tkNot:
          if Nodes[node].Ty = tyBool then begin
            one := EmitLIC(1);
            LowerExpr := EmitBin('XOR', LowerExpr(Nodes[node].A), one);
          end
          else if IsInt64(Nodes[node].Ty) then
            LowerExpr := EmitUn('NOT', AsInt64(Nodes[node].A))
          else LowerExpr := EmitUn('NOT', LowerExpr(Nodes[node].A));
      else
        LowerExpr := LowerExpr(Nodes[node].A);
      end;
    end;
    nkBinary:
      if Nodes[node].Ty = tyStr then begin
        { the only string-valued binary operator is concatenation; the operands are staged
          in a fixed order so emission does not depend on argument-evaluation order }
        a := AsStr(Nodes[node].A);
        b := AsStr(Nodes[node].B);
        r := EmitStrCall2('kp_str_concat', a, b);
        ReleaseIfOwned(Nodes[node].A, a);
        ReleaseIfOwned(Nodes[node].B, b);
        LowerExpr := r;
      end
      else if StrOperands(node) then
        LowerExpr := LowerStrCompare(node)
      else if (Nodes[node].Op in [tkAnd, tkOr]) and (Nodes[node].Ty = tyBool) then
        LowerExpr := LowerShortCircuit(node)
      else if (Nodes[node].Op = tkIn) and IsMap(Nodes[Nodes[node].B].Ty) then begin
        { k in m: membership test on a map key }
        a := LowerExpr(Nodes[node].B);   { the map }
        if MapKeyType(Nodes[Nodes[node].B].Ty) = tyStr then begin
          b := LowerExpr(Nodes[node].A);   { the key handle }
          r := EmitStrCall2('kp_map_has', a, b);
          ReleaseIfOwned(Nodes[node].A, b);
        end
        else begin
          EnsureHelper('kp_imap_has', 2, 'int');
          EmitArg(a);
          EmitArg64(AsInt64(Nodes[node].A));   { the key by value, nothing to release }
          r := NewTemp;
          PushInsn('CALL', 'dst=' + IntToStr(r) + ' sym=kp_imap_has nargs=2');
        end;
        LowerExpr := r;
      end
      else if (Nodes[node].Op = tkIn) or IsSet(Nodes[node].Ty) or
         (IsCmp(Nodes[node].Op) and IsSet(Nodes[Nodes[node].A].Ty)) then
        LowerExpr := LowerSetBinary(node)
      else if FloatOperands(node) then
        LowerExpr := LowerFloatBinary(node)
      else if Int64Operands(node) then begin
        { a 64-bit integer operation: widen each operand to a full Int64 and use the
          *64 opcode. Overflow checking stays 32-bit only, so a checked Int64 add is
          not trapped. A compare yields a 0/1 boolean like the 32-bit form. }
        nm := BinOpName64(Nodes[node].Op);
        if nm = '' then LowerExpr := EmitLIC(0)
        else LowerExpr := EmitBin(nm, AsInt64(Nodes[node].A), AsInt64(Nodes[node].B));
      end
      else begin
        nm := BinOpName(Nodes[node].Op);
        { A checked (Q+) add, subtract, or multiply uses the overflow-trapping
          opcode; the JIT raises OVERFLOW when the signed 32-bit result wraps. }
        if (Nodes[node].Flag = 1) and
           (Nodes[node].Op in [tkPlus, tkMinus, tkStar]) then
          nm := nm + 'O';
        if nm = '' then LowerExpr := EmitLIC(0)
        else begin
          a := LowerExpr(Nodes[node].A);
          b := LowerExpr(Nodes[node].B);
          { the compare opcodes already yield a 0/1 boolean (the JIT sets a byte and
            zero-extends it), matching true = 1, so no normalization is needed }
          r := EmitBin(nm, a, b);
          { an interface comparison borrows its operands, so release an owned temporary
            such as a factory result once the compare has read the handle }
          ReleaseIfOwnedIface(Nodes[node].A, a);
          ReleaseIfOwnedIface(Nodes[node].B, b);
          LowerExpr := r;
        end;
      end;
    nkCall: LowerExpr := LowerCall(node, True);
    nkFailsTest, nkOrElse, nkOrDivert: LowerExpr := LowerFailForm(node, True);
    nkStart: LowerExpr := LowerStart(node);
    nkYield: LowerExpr := LowerYield(node);
    nkBind:  LowerExpr := LowerBind(node);
  else
    LowerExpr := EmitLIC(0);
  end;
end;

function AsFloat(node: LongInt): LongInt;
{ Lower node and, if its value is integer-class, widen it to f64. }
var
  t: LongInt;
begin
  t := LowerExpr(node);
  if not IsRealType(Nodes[node].Ty) then t := EmitUn('ITOF', t);
  AsFloat := t;
end;

function AsInt64(node: LongInt): LongInt;
{ Lower node and, if its value is a 32-bit integer, sign-extend it to a full 64-bit
  Int64. A value already 64-bit passes through; the widening keeps the upper half clean
  so a store or a *64 op sees the whole value. }
var
  t: LongInt;
begin
  t := LowerExpr(node);
  if not IsInt64(Nodes[node].Ty) then t := EmitUn('SEXT64', t);
  AsInt64 := t;
end;

function AsStr(node: LongInt): LongInt;
{ A string handle for a concatenation operand: a char value is boxed into a fresh
  one-character string, a string passes through as its handle. }
begin
  if Nodes[node].Ty = tyChar then
    AsStr := EmitStrCall1('kp_str_from_char', LowerExpr(node))
  else
    AsStr := LowerExpr(node);
end;

function AddOff(addr, off: LongInt): LongInt;
{ Add a constant byte offset to an address, in address width: ADD64 of a 64-bit
  immediate under LP64, the narrow ADD under ILP32. }
begin
  if off = 0 then AddOff := addr
  else if CurTarget.PtrBytes = 8 then AddOff := EmitBin('ADD64', addr, EmitLIC64(off))
  else AddOff := EmitBin('ADD', addr, EmitLIC(off));
end;

function ConstArrayGlobal(s: LongInt): string;
{ The read-only global holding a constant array's static image, built on first use. Each
  element is an ordinal constant emitted as one i32 word (this slice's supported element
  kinds), so the assembler encodes it in the target's endianness. }
var
  agg, i: LongInt;
  ev: TConstVal;
  vals: TInt64Array;
begin
  if Syms[s].ConstAggName <> '' then begin
    ConstArrayGlobal := Syms[s].ConstAggName;
    Exit;
  end;
  agg := Nodes[Syms[s].Node].B;
  SetLength(vals, Length(Nodes[agg].Kids));
  for i := 0 to High(Nodes[agg].Kids) do begin
    ev := EvalConst(Nodes[agg].Kids[i]);
    vals[i] := LongInt(ev.I);
  end;
  Syms[s].ConstAggName := AddIrWordArray('i32', vals);
  ConstArrayGlobal := Syms[s].ConstAggName;
end;

function ConstSetGlobal(s: LongInt): string;
{ The read-only global holding a large constant set's word image, built on first use. Each
  64-bit word is emitted as one i64 .init, the layout the large-set path reads, so the
  assembler encodes it in the target's endianness. }
var
  setTy, nw, i: LongInt;
  w: TSetWords;
  vals: TInt64Array;
begin
  if Syms[s].ConstAggName <> '' then begin
    ConstSetGlobal := Syms[s].ConstAggName;
    Exit;
  end;
  setTy := Syms[s].TypeId;
  nw := SetWords(setTy);
  EvalConstSet(Nodes[Syms[s].Node].B, setTy, w);
  SetLength(vals, nw);
  for i := 0 to nw - 1 do vals[i] := w[i];
  Syms[s].ConstAggName := AddIrWordArray('i64', vals);
  ConstSetGlobal := Syms[s].ConstAggName;
end;

function DynElemAddr(node: LongInt; var baseHandle: LongInt): LongInt;
{ The address of a dynamic-array element s[i]: lower the array handle once, bounds-check the
  index against the runtime length, and return the element's address. The handle is reported
  through baseHandle so a caller that read from an owned array temporary can release it after
  the load; a dynamic array is one-dimensional (nest for more), so there is a single index. }
var
  handle, idx, lenv, lBad, lOk, cmp, base, elemSize, arrTy: LongInt;
begin
  arrTy := Nodes[Nodes[node].A].Ty;
  handle := LowerExpr(Nodes[node].A);
  baseHandle := handle;
  idx := LowerExpr(Nodes[node].Kids[0]);
  lenv := EmitStrCall1('kp_arr_len', handle);
  lBad := NewLabel;
  lOk := NewLabel;
  cmp := EmitBin('CMPLTS', idx, EmitLIC(0));
  EmitBNZ(cmp, lBad);
  cmp := EmitBin('CMPGTS', idx, EmitBin('SUB', lenv, EmitLIC(1)));
  EmitBNZ(cmp, lBad);
  EmitIndexTrap(lBad, lOk);
  base := EmitStrCall1('kp_arr_base', handle);
  elemSize := TypeSize(SemTypes[arrTy].Base);
  if elemSize <> 1 then idx := EmitBin('MUL', idx, EmitLIC(elemSize));
  DynElemAddr := AddrAdd(base, idx);
end;

function BufElemAddr(node: LongInt; var baseHandle: LongInt): LongInt;
{ The address of a multidimensional buffer element b[i0, i1, ...]: lower the handle once, then
  for each axis bounds-check the index against that axis's runtime extent (kp_buf_dim) and add
  index * byte-stride (kp_buf_stride) to the base. A buffer is one strided host region, so a
  pitched row rides on its axis stride and no dimension is a separate handle. Indices are
  zero-based, as for a dynamic array. The rank is fixed by the type, so the subscript count was
  checked in the semantic pass. }
var
  handle, addr, idx, extent, stride, lBad, lOk, cmp, k, rank: LongInt;
begin
  handle := LowerExpr(Nodes[node].A);
  baseHandle := handle;
  rank := BufRank(Nodes[Nodes[node].A].Ty);
  lBad := NewLabel;
  lOk := NewLabel;
  addr := EmitStrCall1('kp_arr_base', handle);
  for k := 0 to rank - 1 do begin
    idx := LowerExpr(Nodes[node].Kids[k]);
    extent := EmitStrCall2('kp_buf_dim', handle, EmitLIC(k));
    cmp := EmitBin('CMPLTS', idx, EmitLIC(0));
    EmitBNZ(cmp, lBad);
    cmp := EmitBin('CMPGTS', idx, EmitBin('SUB', extent, EmitLIC(1)));
    EmitBNZ(cmp, lBad);
    stride := EmitStrCall2('kp_buf_stride', handle, EmitLIC(k));
    addr := AddrAdd(addr, EmitBin('MUL', idx, stride));
  end;
  EmitIndexTrap(lBad, lOk);
  BufElemAddr := addr;
end;

function MapSlotAddr(node: LongInt; insert: Boolean): LongInt;
{ The guest address of a map element's value slot. For a read (insert False) the key must be
  present or kp_map_get traps. For an assignment target (insert True) kp_map_reserve inserts a
  zero-filled slot if the key is absent, creating the map when the variable is nil, and the
  owned map reference it returns is stored back over the designator (the kp_arr_setlen
  discipline), then kp_map_get returns the now-present slot. The slot address is valid only
  until the next structural change to the map, so the caller uses it at once. }
var
  mapDesig, keykid, vt, cur, key, key64, newmap, slot, s, old, maddr: LongInt;
  isStr: Boolean;
  rsym, gsym: string;
begin
  mapDesig := Nodes[node].A;
  keykid := Nodes[node].Kids[0];
  vt := SemTypes[Nodes[mapDesig].Ty].Base;
  { a string key is a handle passed by its id (kp_map_*); an ordinal key is a plain value
    widened to int64 and passed by value (kp_imap_*). Everything else is identical. }
  isStr := MapKeyType(Nodes[mapDesig].Ty) = tyStr;
  if isStr then begin rsym := 'kp_map_reserve'; gsym := 'kp_map_get'; end
  else begin rsym := 'kp_imap_reserve'; gsym := 'kp_imap_get'; end;
  cur := LowerExpr(mapDesig);
  key := -1; key64 := -1;
  if isStr then key := LowerExpr(keykid) else key64 := AsInt64(keykid);
  if insert then begin
    EnsureHelper(rsym, 4, 'int');
    EmitArg(cur);
    if isStr then EmitArg(key) else EmitArg64(key64);
    EmitArg(EmitLIC(TypeSize(vt)));
    EmitArg(EmitArrLayout(vt));
    newmap := NewTemp;
    PushInsn('CALL', 'dst=' + IntToStr(newmap) + ' sym=' + rsym + ' nargs=4');
    { store the owned map back over the designator, releasing the previous handle }
    if Nodes[mapDesig].Kind = nkIdent then begin
      s := Nodes[mapDesig].Sym;
      old := LoadSym(s);
      StoreSym(s, newmap);
      EmitRelease(old);
    end
    else begin
      maddr := AddrOf(mapDesig);
      old := EmitLoadPtr(maddr);   { a map is a pointer-width handle }
      EmitStorePtr(maddr, newmap);
      EmitRelease(old);
    end;
    cur := newmap;
  end;
  EnsureHelper(gsym, 2, 'int');
  EmitArg(cur);
  if isStr then EmitArg(key) else EmitArg64(key64);
  slot := NewTemp;
  PushInsn('CALL', 'dst=' + IntToStr(slot) + ' sym=' + gsym + ' nargs=2');
  if isStr then ReleaseIfOwned(keykid, key);   { an int key is a plain value, nothing to release }
  MapSlotAddr := slot;
end;

function AddrOf(node: LongInt): LongInt;
{ The address of a designator: a variable, a record field, or an array element.
  Aggregates are addressed rather than loaded; a scalar field or element is
  loaded from the address this returns. }
var
  s, base, recTy, arrTy, m, off, i, k, elemSize, stride, idx, sub: LongInt;
  lBad, lOk, cmp, handle: LongInt;
  checked: Boolean;
begin
  case Nodes[node].Kind of
    nkIdent: begin
      s := Nodes[node].Sym;
      if IsPropertySym(s) then begin
        if IsAggregate(Syms[s].TypeId) then
          { an aggregate property has no stored cell, but its getter returns the value through
            an sret buffer; that buffer's address serves as the value's location for a read or
            a const-reference argument (doc/languages/kobold/kp-property.md) }
          AddrOf := LowerExpr(node)
        else begin
          { a scalar or handle property is accessor-backed and has no address }
          SemErr(node, 'a property has no address; it cannot be passed by reference or have its '
            + 'address taken');
          AddrOf := EmitLIC(0);
        end;
      end
      else if s < 0 then AddrOf := EmitLIC(0)
      else if (Syms[s].Kind = syConst) and (Syms[s].ConstAggName <> '') then
        AddrOf := EmitLEA(Syms[s].ConstAggName)  { a string array, filled when main started }
      else if (Syms[s].Kind = syConst) and (Syms[s].TypeId >= 0) and
              (SemTypes[Syms[s].TypeId].Kind = skArray) then
        AddrOf := EmitLEA(ConstArrayGlobal(s))   { an ordinal array's read-only image }
      else if (Syms[s].Kind = syConst) and IsLargeSet(Syms[s].TypeId) then
        AddrOf := EmitLEA(ConstSetGlobal(s))     { a large set's read-only word image }
      else AddrOf := VarAddr(s);
    end;
    nkField:
      if Nodes[node].Flag = 1 then
        AddrOf := VarAddr(Nodes[node].Sym)   { a unit-qualified var, addressed as a global }
      else if ComputedFieldGetter(node) <> '' then begin
        if IsAggregate(Nodes[node].Ty) then
          { an aggregate computed field returns through its getter method's sret buffer; that
            buffer's address is the value's location (doc/languages/kobold/kp-property.md) }
          AddrOf := LowerExpr(node)
        else begin
          { a scalar or handle computed field is accessor-backed and has no storage }
          SemErr(node, 'a computed field has no address; it cannot be passed by reference');
          AddrOf := EmitLIC(0);
        end;
      end
      else begin
        base := AddrOf(Nodes[node].A);
        recTy := Nodes[Nodes[node].A].Ty;
        m := FindMember(recTy, Nodes[node].Text);
        if m >= 0 then off := FieldOffset(recTy, m) else off := 0;
        AddrOf := AddOff(base, off);
      end;
    nkIndex: begin
      { A range-checked access (R+) stamped Flag; when set, each dimension's raw index
        is checked against the declared bounds before it is normalized, branching to a
        shared trap on any failure. }
      arrTy := Nodes[Nodes[node].A].Ty;
      if IsMap(arrTy) then begin
        { a map element address: the assignment target inserts the key (kp_map_reserve, marked
          by PendingMapInsert), every other access reads it (kp_map_get, which traps if absent) }
        if node = PendingMapInsert then begin
          PendingMapInsert := -1;
          AddrOf := MapSlotAddr(node, True);
        end
        else
          AddrOf := MapSlotAddr(node, False);
        Exit;
      end;
      if IsDynArray(arrTy) then begin
        { direct addressing from the array handle, bounds-checked against the runtime extent;
          the handle is not released here (an address context keeps it alive). A
          multidimensional buffer sums a stride per axis; every other dynamic array is 1D. }
        if BufRank(arrTy) > 1 then AddrOf := BufElemAddr(node, handle)
        else AddrOf := DynElemAddr(node, handle);
        Exit;
      end;
      checked := Nodes[node].Flag = 1;
      lBad := -1;
      if checked then lBad := NewLabel;
      base := AddrOf(Nodes[node].A);
      elemSize := TypeSize(SemTypes[arrTy].Base);
      for i := 0 to High(Nodes[node].Kids) do begin
        { row-major stride: element size times the extent of the later dims }
        stride := elemSize;
        for k := i + 1 to High(SemTypes[arrTy].Subs) do begin
          sub := SemTypes[arrTy].Subs[k];
          stride := stride * (SemTypes[sub].Hi - SemTypes[sub].Lo + 1);
        end;
        idx := LowerExpr(Nodes[node].Kids[i]);
        sub := SemTypes[arrTy].Subs[i];
        if checked then begin
          cmp := EmitBin('CMPLTS', idx, EmitLIC(SemTypes[sub].Lo));
          EmitBNZ(cmp, lBad);
          cmp := EmitBin('CMPGTS', idx, EmitLIC(SemTypes[sub].Hi));
          EmitBNZ(cmp, lBad);
        end;
        if SemTypes[sub].Lo <> 0 then
          idx := EmitBin('SUB', idx, EmitLIC(SemTypes[sub].Lo));
        if stride <> 1 then idx := EmitBin('MUL', idx, EmitLIC(stride));
        base := AddrAdd(base, idx);
      end;
      if checked then begin
        lOk := NewLabel;
        EmitIndexTrap(lBad, lOk);
      end;
      AddrOf := base;
    end;
  else
    AddrOf := LowerExpr(node);
  end;
end;

procedure CopyAggregate(dst, src, size: LongInt);
{ Copy size bytes from src to dst, word by word (sizes are a multiple of 4). }
var
  off, t: LongInt;
begin
  off := 0;
  while off < size do begin
    t := EmitLW(AddOff(src, off));
    EmitSW(AddOff(dst, off), t);
    off := off + 4;
  end;
end;

procedure CollectHandleOffsets(ty, baseOff: LongInt; var offs: TIntArray);
{ Append the byte offsets, relative to baseOff, of every handle field within a type: the
  type itself if it is a whole handle, each handle field of a record, or each handle
  element of a fixed array, recursively. A dynamic array is itself a handle, so it appends
  its own offset and is not descended into. Drives handle-field retain/release for an
  aggregate value (copy, scope exit, and the array element layout). }
var
  i, n, cnt, stride, sub: LongInt;
begin
  if IsHandle(ty) then begin
    n := Length(offs);
    SetLength(offs, n + 1);
    offs[n] := baseOff;
    Exit;
  end;
  if (ty < 0) or (ty >= SemCount) then Exit;
  case SemTypes[ty].Kind of
    skRecord:
      for i := 0 to High(SemTypes[ty].Subs) do
        CollectHandleOffsets(SemTypes[ty].Subs[i], baseOff + FieldOffset(ty, i), offs);
    skArray:
      if Length(SemTypes[ty].Subs) > 0 then begin   { fixed array; dynamic is a handle }
        cnt := 1;
        for i := 0 to High(SemTypes[ty].Subs) do begin
          sub := SemTypes[ty].Subs[i];
          cnt := cnt * (SemTypes[sub].Hi - SemTypes[sub].Lo + 1);
        end;
        stride := TypeSize(SemTypes[ty].Base);
        for i := 0 to cnt - 1 do
          CollectHandleOffsets(SemTypes[ty].Base, baseOff + i * stride, offs);
      end;
  end;
end;

procedure CollectHandleKinds(ty, baseOff: LongInt; var offs, kinds: TIntArray);
{ Like CollectHandleOffsets, but records for each handle field its copy category: a value type
  copied by clone when the aggregate copies (kinds=1 a dynamic array, kinds=2 a map) or a
  reference type shared by retain (kinds=0). This drives the member-category rule for aggregate
  copy. }
var
  i, n, cnt, stride, sub: LongInt;
begin
  if IsHandle(ty) then begin
    n := Length(offs);
    SetLength(offs, n + 1);
    SetLength(kinds, n + 1);
    offs[n] := baseOff;
    if IsDynArray(ty) and not IsBuffer(ty) then kinds[n] := 1
    else if IsMap(ty) then kinds[n] := 2
    else kinds[n] := 0;
    Exit;
  end;
  if (ty < 0) or (ty >= SemCount) then Exit;
  case SemTypes[ty].Kind of
    skRecord:
      for i := 0 to High(SemTypes[ty].Subs) do
        CollectHandleKinds(SemTypes[ty].Subs[i], baseOff + FieldOffset(ty, i), offs, kinds);
    skArray:
      if Length(SemTypes[ty].Subs) > 0 then begin   { fixed array; dynamic is a handle }
        cnt := 1;
        for i := 0 to High(SemTypes[ty].Subs) do begin
          sub := SemTypes[ty].Subs[i];
          cnt := cnt * (SemTypes[sub].Hi - SemTypes[sub].Lo + 1);
        end;
        stride := TypeSize(SemTypes[ty].Base);
        for i := 0 to cnt - 1 do
          CollectHandleKinds(SemTypes[ty].Base, baseOff + i * stride, offs, kinds);
      end;
  end;
end;

procedure CopyAggregateManaged(dstAddr, srcAddr, ty: LongInt);
{ Copy an aggregate value from srcAddr to dstAddr with managed-field ownership, the mirror of a
  whole-aggregate assignment: a value field (dynamic array or map) is cloned so the destination
  is independent, a reference field (string, interface, process) is shared by retaining the
  source, and the destination's old fields are released first. A POD aggregate copies plainly.
  dstAddr and srcAddr are temps holding the two addresses; the destination's old handle fields
  must be valid (nil counts). }
var
  aoffs, akinds, clones: TIntArray;
  i: LongInt;
begin
  aoffs := nil; akinds := nil;
  CollectHandleKinds(ty, 0, aoffs, akinds);
  if Length(aoffs) = 0 then begin
    CopyAggregate(dstAddr, srcAddr, TypeSize(ty));
    Exit;
  end;
  clones := nil;
  SetLength(clones, Length(aoffs));
  for i := 0 to High(aoffs) do
    if akinds[i] = 1 then
      clones[i] := EmitStrCall1('kp_arr_clone', EmitLoadPtr(AddOff(srcAddr, aoffs[i])))
    else if akinds[i] = 2 then
      clones[i] := EmitStrCall1('kp_map_clone', EmitLoadPtr(AddOff(srcAddr, aoffs[i])))
    else begin
      clones[i] := -1;
      EmitRetain(EmitLoadPtr(AddOff(srcAddr, aoffs[i])));
    end;
  for i := 0 to High(aoffs) do EmitRelease(EmitLoadPtr(AddOff(dstAddr, aoffs[i])));
  CopyAggregate(dstAddr, srcAddr, TypeSize(ty));
  for i := 0 to High(aoffs) do
    if akinds[i] <> 0 then EmitStorePtr(AddOff(dstAddr, aoffs[i]), clones[i]);
end;

{ ---- sets (a small set is an i64 bitmask; bit n = element with ordinal n) ---- }

function RangeMask(lo, hi: Int64): Int64;
{ An i64 with bits lo..hi set. }
var
  high, low: Int64;
begin
  if hi >= 63 then high := -1 else high := (Int64(1) shl (hi + 1)) - 1;
  low := (Int64(1) shl lo) - 1;
  RangeMask := high and not low;
end;

function LowerSetElemMask(e: LongInt): LongInt;
{ The i64 mask for one set-constructor element: a single ordinal or a range. }
var
  lo, hi: TConstVal;
  allOnes, loPart, hiPart, shamt: LongInt;
begin
  if Nodes[e].B < 0 then begin
    lo := EvalConst(Nodes[e].A);
    if lo.Ok then LowerSetElemMask := EmitLIC64(Int64(1) shl lo.I)
    else LowerSetElemMask := EmitBin('SHL64', EmitLIC64(1), LowerExpr(Nodes[e].A));
  end
  else begin
    lo := EvalConst(Nodes[e].A);
    hi := EvalConst(Nodes[e].B);
    if lo.Ok and hi.Ok then
      LowerSetElemMask := EmitLIC64(RangeMask(lo.I, hi.I))
    else begin
      { bits lo..hi at runtime: (allOnes << lo) & (allOnes >>u (63 - hi)) }
      allOnes := EmitLIC64(-1);
      loPart := EmitBin('SHL64', allOnes, LowerExpr(Nodes[e].A));
      shamt := EmitBin('SUB', EmitLIC(63), LowerExpr(Nodes[e].B));
      hiPart := EmitBin('SHRU64', EmitLIC64(-1), shamt);
      LowerSetElemMask := EmitBin('AND64', loPart, hiPart);
    end;
  end;
end;

{ ---- large sets: 2-4 word blobs addressed in memory, operated on word by word ---- }

procedure EmitSetIncl(dst, nwords, e: LongInt);
{ OR one constructor element e into the large set at dst: a single ordinal, a constant range,
  or a runtime single ordinal indexed by word and bit. A runtime range is not supported yet. }
var
  lo, hi: TConstVal;
  i, wi, bit, addr, ordv, mask, cur: LongInt;
begin
  if Nodes[e].B < 0 then begin
    lo := EvalConst(Nodes[e].A);
    if lo.Ok then begin
      wi := LongInt(lo.I) div 64;
      bit := LongInt(lo.I) mod 64;
      if (wi >= 0) and (wi < nwords) then begin
        addr := AddOff(dst, wi * 8);
        cur := EmitLD64(addr);
        EmitST64(addr, EmitBin('OR64', cur, EmitLIC64(Int64(1) shl bit)));
      end;
    end
    else begin
      ordv := LowerExpr(Nodes[e].A);
      addr := AddrAdd(dst, EmitBin('MUL', EmitBin('SHRU', ordv, EmitLIC(6)),
        EmitLIC(8)));
      mask := EmitBin('SHL64', EmitLIC64(1), EmitBin('AND', ordv, EmitLIC(63)));
      cur := EmitLD64(addr);
      EmitST64(addr, EmitBin('OR64', cur, mask));
    end;
  end
  else begin
    lo := EvalConst(Nodes[e].A);
    hi := EvalConst(Nodes[e].B);
    if lo.Ok and hi.Ok then
      for i := LongInt(lo.I) to LongInt(hi.I) do begin
        wi := i div 64;
        bit := i mod 64;
        if (wi >= 0) and (wi < nwords) then begin
          addr := AddOff(dst, wi * 8);
          cur := EmitLD64(addr);
          EmitST64(addr, EmitBin('OR64', cur, EmitLIC64(Int64(1) shl bit)));
        end;
      end
    else
      SemErr(e, 'a runtime range in a large set constructor is not supported yet');
  end;
end;

procedure LowerSetInto(node, dst, nwords: LongInt);
{ Write the large-set value of expression node into the nwords-word blob at dst. A constructor
  clears then includes each element; a set operator combines the operands word by word; any
  other set value (a designator) is copied word by word. }
var
  w, i, scratch, saddr, dw, sw, res: LongInt;
begin
  case Nodes[node].Kind of
    nkSetConstructor: begin
      for w := 0 to nwords - 1 do EmitST64(AddOff(dst, w * 8), EmitLIC64(0));
      for i := 0 to High(Nodes[node].Kids) do EmitSetIncl(dst, nwords, Nodes[node].Kids[i]);
    end;
    nkBinary: begin
      LowerSetInto(Nodes[node].A, dst, nwords);
      scratch := NewSlot(nwords * 8);
      saddr := EmitADL(scratch);
      LowerSetInto(Nodes[node].B, saddr, nwords);
      for w := 0 to nwords - 1 do begin
        dw := EmitLD64(AddOff(dst, w * 8));
        sw := EmitLD64(AddOff(saddr, w * 8));
        case Nodes[node].Op of
          tkStar:  res := EmitBin('AND64', dw, sw);
          tkMinus: res := EmitBin('AND64', dw, EmitBin('XOR64', sw, EmitLIC64(-1)));
        else
          res := EmitBin('OR64', dw, sw);   { tkPlus }
        end;
        EmitST64(AddOff(dst, w * 8), res);
      end;
    end;
  else
    for w := 0 to nwords - 1 do
      EmitST64(AddOff(dst, w * 8), EmitLD64(AddOff(AddrOf(node), w * 8)));
  end;
end;

function LowerSetValue(node: LongInt): LongInt;
{ A large-set expression as a value: fill a fresh scratch blob and return its address. }
var
  nw, slot, addr: LongInt;
begin
  nw := SetWords(Nodes[node].Ty);
  slot := NewSlot(nw * 8);
  addr := EmitADL(slot);
  LowerSetInto(node, addr, nw);
  LowerSetValue := addr;
end;

function LowerSetAddr(node: LongInt): LongInt;
{ The address of a large-set value: a designator's own address, else a filled scratch. }
begin
  if Nodes[node].Kind in [nkIdent, nkField, nkIndex] then LowerSetAddr := AddrOf(node)
  else LowerSetAddr := LowerSetValue(node);
end;

function LowerLargeSetRel(node: LongInt): LongInt;
{ A large-set relation (=, <>, <=, <, >=, >) reduced word by word to a boolean. }
var
  nw, aAddr, bAddr, w, aw, bw, allEq, contained, notother: LongInt;
begin
  nw := SetWords(Nodes[Nodes[node].A].Ty);
  if nw < SetWords(Nodes[Nodes[node].B].Ty) then nw := SetWords(Nodes[Nodes[node].B].Ty);
  aAddr := LowerSetAddr(Nodes[node].A);
  bAddr := LowerSetAddr(Nodes[node].B);
  allEq := EmitLIC(1);
  contained := EmitLIC(1);   { for <=: a and not b is empty; reused as b and not a for >= }
  for w := 0 to nw - 1 do begin
    aw := EmitLD64(AddOff(aAddr, w * 8));
    bw := EmitLD64(AddOff(bAddr, w * 8));
    allEq := EmitBin('AND', allEq, EmitBin('CMP64EQ', aw, bw));
    if Nodes[node].Op in [tkGe, tkGt] then
      notother := EmitBin('AND64', bw, EmitBin('XOR64', aw, EmitLIC64(-1)))
    else
      notother := EmitBin('AND64', aw, EmitBin('XOR64', bw, EmitLIC64(-1)));
    contained := EmitBin('AND', contained, EmitBin('CMP64EQ', notother, EmitLIC64(0)));
  end;
  case Nodes[node].Op of
    tkEq:  LowerLargeSetRel := allEq;
    tkNeq: LowerLargeSetRel := EmitBin('XOR', allEq, EmitLIC(1));
    tkLe, tkGe: LowerLargeSetRel := contained;
    tkLt, tkGt: LowerLargeSetRel :=
      EmitBin('AND', contained, EmitBin('XOR', allEq, EmitLIC(1)));
  else
    LowerLargeSetRel := EmitLIC(0);
  end;
end;

function LowerSet(node: LongInt): LongInt;
{ A set constructor. A small set ORs each element's i64 mask; a large set fills a blob. }
var
  acc, i: LongInt;
begin
  if IsLargeSet(Nodes[node].Ty) then begin
    LowerSet := LowerSetValue(node);
    Exit;
  end;
  acc := EmitLIC64(0);
  for i := 0 to High(Nodes[node].Kids) do
    acc := EmitBin('OR64', acc, LowerSetElemMask(Nodes[node].Kids[i]));
  LowerSet := acc;
end;

function LowerSetBinary(node: LongInt): LongInt;
{ Set membership, the set operators +/*/-, and the set relations, for a small (i64) or a
  large (word-blob) set. }
var
  a, b, mask, r, notb, nota, sub, sup, bAddr, ordv, waddr, word: LongInt;
begin
  if Nodes[node].Op = tkIn then begin
    { the ordinal; a char written as a one-character string yields its character code }
    if (Nodes[Nodes[node].A].Kind = nkStrLit) and
       (Length(Nodes[Nodes[node].A].Text) = 1) then
      ordv := EmitLIC(Ord(Nodes[Nodes[node].A].Text[1]))
    else
      ordv := LowerExpr(Nodes[node].A);
    if IsLargeSet(Nodes[Nodes[node].B].Ty) then begin
      { x in S: read S's word ord>>6, test bit ord&63 }
      bAddr := LowerSetAddr(Nodes[node].B);
      waddr := AddrAdd(bAddr, EmitBin('MUL', EmitBin('SHRU', ordv, EmitLIC(6)),
        EmitLIC(8)));
      word := EmitLD64(waddr);
      mask := EmitBin('SHL64', EmitLIC64(1), EmitBin('AND', ordv, EmitLIC(63)));
      LowerSetBinary := EmitBin('CMP64NE', EmitBin('AND64', word, mask), EmitLIC64(0));
      Exit;
    end;
    { x in S:  (S and (1 << ord x)) <> 0 }
    b := LowerExpr(Nodes[node].B);   { the set }
    mask := EmitBin('SHL64', EmitLIC64(1), ordv);
    r := EmitBin('AND64', b, mask);
    LowerSetBinary := EmitBin('CMP64NE', r, EmitLIC64(0));
    Exit;
  end;
  { a set-valued result (union, intersection, difference) that is large is a blob }
  if IsLargeSet(Nodes[node].Ty) then begin
    LowerSetBinary := LowerSetValue(node);
    Exit;
  end;
  { a relation between large sets reduces word by word to a boolean }
  if IsLargeSet(Nodes[Nodes[node].A].Ty) or IsLargeSet(Nodes[Nodes[node].B].Ty) then begin
    LowerSetBinary := LowerLargeSetRel(node);
    Exit;
  end;
  a := LowerExpr(Nodes[node].A);
  b := LowerExpr(Nodes[node].B);
  case Nodes[node].Op of
    tkPlus:  LowerSetBinary := EmitBin('OR64', a, b);
    tkStar:  LowerSetBinary := EmitBin('AND64', a, b);
    tkMinus: LowerSetBinary := EmitBin('AND64', a, EmitBin('XOR64', b, EmitLIC64(-1)));
    tkEq:    LowerSetBinary := EmitBin('CMP64EQ', a, b);
    tkNeq:   LowerSetBinary := EmitBin('CMP64NE', a, b);
    tkLe, tkLt: begin   { subset (a and not b) = 0; proper subset also needs a <> b }
      notb := EmitBin('XOR64', b, EmitLIC64(-1));
      sub := EmitBin('CMP64EQ', EmitBin('AND64', a, notb), EmitLIC64(0));
      if Nodes[node].Op = tkLt then
        sub := EmitBin('AND', sub, EmitBin('CMP64NE', a, b));
      LowerSetBinary := sub;
    end;
    tkGe, tkGt: begin   { superset (b and not a) = 0; proper superset also needs a <> b }
      nota := EmitBin('XOR64', a, EmitLIC64(-1));
      sup := EmitBin('CMP64EQ', EmitBin('AND64', b, nota), EmitLIC64(0));
      if Nodes[node].Op = tkGt then
        sup := EmitBin('AND', sup, EmitBin('CMP64NE', a, b));
      LowerSetBinary := sup;
    end;
  else
    LowerSetBinary := EmitLIC64(0);
  end;
end;

{ ---- statement lowering ---- }

procedure PushLoop(contL, breakL: LongInt);
begin
  SetLength(LoopCont, LoopSP + 1);
  SetLength(LoopBreak, LoopSP + 1);
  SetLength(LoopDeferBase, LoopSP + 1);
  LoopCont[LoopSP] := contL;
  LoopBreak[LoopSP] := breakL;
  LoopDeferBase[LoopSP] := DeferScopeSP;
  Inc(LoopSP);
end;

procedure PopLoop;
begin
  Dec(LoopSP);
end;

function IsOwnedExpr(node: LongInt): Boolean;
{ True when a handle-valued expression already owns its reference (a transfer),
  so an assignment must not retain it: a fresh literal, concatenation, call
  result, or nil. A variable, field, or element read is borrowed. A method field
  named as a value auto-calls, so it too transfers a fresh reference. }
begin
  case Nodes[node].Kind of
    nkStrLit, nkCall, nkNil, nkStart: IsOwnedExpr := True;
    { an `or divert` yields the call's result on success (a transfer); on failure it diverts,
      so the value is never used. `or else` also transfers: its lowering leaves an owned
      reference in the result slot on both paths (the callee's owned value on success, a
      cloned/retained fallback on failure, see LowerFailForm). }
    nkOrDivert, nkOrElse: IsOwnedExpr := True;
    nkBinary: IsOwnedExpr := (Nodes[node].Op = tkPlus) and (Nodes[node].Ty = tyStr);
    { a converted hole is a fresh string (owned); a string hole is the operand's own
      ownership, since nkToStr over a string is the identity }
    nkToStr: if Nodes[Nodes[node].A].Ty = tyStr then IsOwnedExpr := IsOwnedExpr(Nodes[node].A)
             else IsOwnedExpr := True;
    { a bare paramless function name auto-calls and so transfers a fresh
      reference, EXCEPT inside the function's own body, where the name is the
      result variable: that is a borrow (loaded from the result slot), so it must
      not be released as a temporary, or `f := f + x` double-frees f (once as the
      operand, once as the assignment's old value). }
    nkIdent: IsOwnedExpr := (Nodes[node].Sym >= 0) and
                            (((Syms[Nodes[node].Sym].Kind = syFunc) and
                              (Nodes[node].Sym <> CurFuncSym))
                             { a property read is a getter call, so it transfers a fresh
                               reference the same way a paramless function name does
                               (doc/languages/kobold/kp-property.md) }
                             or IsPropertySym(Nodes[node].Sym));
    { a method field or a computed record field named as a value both auto-call,
      transferring a fresh reference (the computed field through its getter method) }
    nkField: IsOwnedExpr := IsMethodField(node) or (ComputedFieldGetter(node) <> '');
  else
    IsOwnedExpr := False;
  end;
end;

function CallHandleResult(calleeIdent: LongInt): Boolean;
{ True when a call through this callee designator returns a handle. }
var
  s, sig, bt, m: LongInt;
begin
  CallHandleResult := False;
  if Nodes[calleeIdent].Kind = nkField then begin
    { a method: its result type lives in the resolved member signature }
    if not IsMethodField(calleeIdent) then Exit;
    bt := Nodes[Nodes[calleeIdent].A].Ty;
    { a script method wins over the interface vtable entry of the same name }
    sig := FindMethod(bt, Nodes[calleeIdent].Text);
    if (sig < 0) and (SemTypes[bt].Kind = skInterface) then begin
      m := FindMember(bt, Nodes[calleeIdent].Text);
      if m >= 0 then sig := SemTypes[bt].Subs[m];
    end;
    if (sig >= 0) and (SemTypes[sig].Kind = skProc) then
      CallHandleResult := IsHandle(SemTypes[sig].RetType);
    Exit;
  end;
  if Nodes[calleeIdent].Kind <> nkIdent then Exit;
  s := Nodes[calleeIdent].Sym;
  if s < 0 then Exit;
  sig := Syms[s].TypeId;
  if (sig >= 0) and (SemTypes[sig].Kind = skProc) then
    CallHandleResult := IsHandle(SemTypes[sig].RetType);
end;

function LValueType(node: LongInt): LongInt;
{ The declared type of an assignable designator. }
var
  s: LongInt;
begin
  if Nodes[node].Kind = nkIdent then begin
    s := Nodes[node].Sym;
    if s < 0 then LValueType := -1
    else if Syms[s].Kind = syFunc then LValueType := SemTypes[Syms[s].TypeId].RetType
    else LValueType := Syms[s].TypeId;
  end
  else
    LValueType := Nodes[node].Ty;   { field or element type, set by sema }
end;

function RefsSym(node, sym: LongInt): Boolean;
{ True when the expression at node reads the variable sym anywhere in its subtree. The
  self-append chain uses this to stay sound: once the accumulator x has been grown in place,
  a later operand that reads x would see the half-built value, so such an operand keeps the
  assignment on the plain concat path. }
var
  i: LongInt;
begin
  RefsSym := False;
  if node < 0 then Exit;
  if (Nodes[node].Kind = nkIdent) and (Nodes[node].Sym = sym) then begin
    RefsSym := True;
    Exit;
  end;
  if RefsSym(Nodes[node].A, sym) or RefsSym(Nodes[node].B, sym) or
     RefsSym(Nodes[node].C, sym) or RefsSym(Nodes[node].D, sym) then begin
    RefsSym := True;
    Exit;
  end;
  for i := 0 to High(Nodes[node].Kids) do
    if RefsSym(Nodes[node].Kids[i], sym) then begin
      RefsSym := True;
      Exit;
    end;
end;

function ConcatSpine(n: LongInt; var ops: TIntArray): LongInt;
{ Walk the left-leaning spine of a string concatenation, returning its leftmost leaf and
  appending each right operand to ops in left-to-right order. `((x + a) + b)` yields leaf x
  and ops [a, b]; a leaf that is not a string `+` ends the spine. }
begin
  if (Nodes[n].Kind = nkBinary) and (Nodes[n].Op = tkPlus) and (Nodes[n].Ty = tyStr) then begin
    ConcatSpine := ConcatSpine(Nodes[n].A, ops);
    SetLength(ops, Length(ops) + 1);
    ops[High(ops)] := Nodes[n].B;
  end
  else
    ConcatSpine := n;
end;

function IsSelfAppend(node: LongInt; var ops: TIntArray): Boolean;
{ True when node is the self-append idiom `x := x + e` or a left-leaning chain of it
  (`x := x + a + b + ...`): the target is a plain string variable and it is the leftmost
  leaf of the right-hand concatenation. ops receives the appended operands in order. This is
  the shape a build-a-string loop runs hot; recognizing it lets each step grow the string in
  place (kp_str_append*) rather than allocating and copying the whole left operand (the
  O(n^2) a naive concat chain costs). Restricted to a plain `var`: the function-result name
  and by-reference targets carry reference-ownership subtleties the general path handles.
  A later operand (anything past the first) may not read x: the first append may have grown
  x in place, so a re-read would see the half-built value. The first operand may read x (it
  is consumed before any mutation is observable), which keeps `x := x + x` on the fast path. }
var
  target, leaf, i: LongInt;
begin
  IsSelfAppend := False;
  SetLength(ops, 0);
  target := Nodes[node].A;
  if Nodes[target].Kind <> nkIdent then Exit;
  if (Nodes[target].Sym < 0) or (Syms[Nodes[target].Sym].Kind <> syVar) then Exit;
  leaf := ConcatSpine(Nodes[node].B, ops);
  if Length(ops) = 0 then Exit;            { the right-hand side was not a concatenation }
  { the spine's leftmost leaf must be the target variable itself }
  if (Nodes[leaf].Kind <> nkIdent) or (Nodes[leaf].Sym <> Nodes[target].Sym) then begin
    SetLength(ops, 0);
    Exit;
  end;
  for i := 1 to High(ops) do
    if RefsSym(ops[i], Nodes[target].Sym) then begin
      SetLength(ops, 0);
      Exit;
    end;
  IsSelfAppend := True;
end;

procedure LowerSelfAppend(target: LongInt; const ops: TIntArray);
{ Lower `x := x + a + b + ...` to a run of in-place appends. Each append helper consumes the
  running reference (the slot's value for the first operand, then the owned intermediate) and
  returns the grown value, so the slot is simply overwritten at the end: no retain of x, no
  separate release of the old value. The first append grows x in place when it is uniquely
  owned; the intermediates are uniquely owned by construction, so they always grow in place. }
var
  s, h, ov, i: LongInt;
begin
  s := Nodes[target].Sym;
  h := LoadSym(s);
  for i := 0 to High(ops) do
    if Nodes[ops[i]].Ty = tyChar then
      h := EmitStrCall2('kp_str_append_char', h, LowerExpr(ops[i]))
    else begin
      ov := LowerExpr(ops[i]);
      h := EmitStrCall2('kp_str_append', h, ov);
      ReleaseIfOwned(ops[i], ov);   { a fresh string operand (a call result, a nested concat) is consumed }
    end;
  StoreSym(s, h);
end;

procedure LowerAssign(node: LongInt);
var
  target, v, s, tt, addr, old, i, rt, m, sf: LongInt;
  aoffs, akinds, clones, argv, aops: TIntArray;
begin
  target := Nodes[node].A;
  tt := LValueType(target);
  if (tt = tyStr) and IsSelfAppend(node, aops) then begin
    LowerSelfAppend(target, aops);
    Exit;
  end;
  { a property write becomes a call to its setter accessor (doc/languages/kobold/kp-property.md).
    A declaration-level property's setter is a free routine; a computed record field's is a
    method of the record, synthesized here as rec.setter(value). }
  if (Nodes[target].Kind = nkIdent) and IsPropertySym(Nodes[target].Sym) then begin
    SetLength(argv, 1);
    argv[0] := Nodes[node].B;
    LowerDirectCall(Nodes[Nodes[Syms[Nodes[target].Sym].Node].C].Sym, argv, False);
    Exit;
  end;
  if Nodes[target].Kind = nkField then begin
    rt := Nodes[Nodes[target].A].Ty;
    if (rt >= 0) and (rt < SemCount) and (SemTypes[rt].Kind = skRecord) then begin
      m := FindMember(rt, Nodes[target].Text);
      if (m >= 0) and (SemTypes[rt].PropGet[m] <> '') then begin
        sf := NewNode(nkField);
        Nodes[sf].A := Nodes[target].A;
        Nodes[sf].Text := SemTypes[rt].PropSet[m];
        SetLength(argv, 1);
        argv[0] := Nodes[node].B;
        LowerMethodCall(sf, argv, False);
        Exit;
      end;
    end;
  end;
  { a map element target inserts its key: mark the node so AddrOf uses kp_map_reserve for it
    (and kp_map_get for every other access, including a map read in the right-hand side) }
  if (Nodes[target].Kind = nkIndex) and IsMap(Nodes[Nodes[target].A].Ty) then
    PendingMapInsert := target;
  if IsLargeSet(tt) then begin
    { lower the right-hand set expression straight into the destination blob }
    LowerSetInto(Nodes[node].B, AddrOf(target), SetWords(tt));
    Exit;
  end;
  if IsAggregate(tt) then begin
    { whole-aggregate assignment copies the value, keyed on each managed field's category: a
      reference field (string, interface, process) is shared by retaining the source; a value
      field (a dynamic array) is copied by cloning, so the destination is independent. A POD
      aggregate copies plainly. The old destination fields are released. Ordering keeps a
      self-assignment safe: clones are taken before any release, and every source retain
      precedes every destination release. }
    aoffs := nil; akinds := nil;
    CollectHandleKinds(tt, 0, aoffs, akinds);
    if Length(aoffs) = 0 then
      CopyAggregate(AddrOf(target), AddrOf(Nodes[node].B), TypeSize(tt))
    else begin
      addr := AddrOf(target);
      v := AddrOf(Nodes[node].B);
      clones := nil;
      SetLength(clones, Length(aoffs));
      for i := 0 to High(aoffs) do
        if akinds[i] = 1 then
          clones[i] := EmitStrCall1('kp_arr_clone', EmitLoadPtr(AddOff(v, aoffs[i])))
        else if akinds[i] = 2 then
          clones[i] := EmitStrCall1('kp_map_clone', EmitLoadPtr(AddOff(v, aoffs[i])))
        else begin
          clones[i] := -1;
          EmitRetain(EmitLoadPtr(AddOff(v, aoffs[i])));
        end;
      for i := 0 to High(aoffs) do EmitRelease(EmitLoadPtr(AddOff(addr, aoffs[i])));
      CopyAggregate(addr, v, TypeSize(tt));
      { a value field (dynamic array or map) is independent: replace the copied (shared) id
        with its clone }
      for i := 0 to High(aoffs) do
        if akinds[i] <> 0 then EmitStorePtr(AddOff(addr, aoffs[i]), clones[i]);
    end;
    Exit;
  end;
  if IsHandle(tt) then begin
    { retain a borrowed value (a transfer already owns its reference), store, and
      release the previous owner }
    if IsEmptyArrayLit(Nodes[node].B) then
      v := EmitLIC(0)   { [] assigned to a dynamic array is an empty (nil) array }
    else begin
      v := LowerExpr(Nodes[node].B);
      if not IsOwnedExpr(Nodes[node].B) then begin
        { A value array copies eagerly, so the destination is independent of the source; a
          reference handle (string, interface, process, ref array, buffer) shares by
          retaining. An owned right-hand side is moved either way, so it is skipped here. }
        if IsDynArray(tt) and not IsBuffer(tt) then v := EmitStrCall1('kp_arr_clone', v)
        else if IsMap(tt) then v := EmitStrCall1('kp_map_clone', v)
        else EmitRetain(v);
      end;
    end;
    if Nodes[target].Kind = nkIdent then begin
      s := Nodes[target].Sym;
      if s >= 0 then begin
        { the function result lives in its own slot, not a variable slot }
        if Syms[s].Kind = syFunc then old := EmitLDLAddr(CurResultSlot)
        else old := LoadSym(s);
        StoreSym(s, v);
        EmitRelease(old);
      end;
    end
    else begin
      addr := AddrOf(target);
      old := EmitLoadPtr(addr);
      EmitStorePtr(addr, v);
      EmitRelease(old);
    end;
    Exit;
  end;
  if IsRealType(tt) then v := AsFloat(Nodes[node].B)   { widen an integer RHS }
  else if IsInt64(tt) then v := AsInt64(Nodes[node].B) { sign-extend a 32-bit RHS }
  else v := LowerExpr(Nodes[node].B);
  if Nodes[target].Kind = nkIdent then begin
    s := Nodes[target].Sym;
    if s >= 0 then StoreSym(s, v);
  end
  else begin
    addr := AddrOf(target);
    EmitStoreScalar(addr, v, tt);
  end;
end;

procedure LowerCallStmt(node: LongInt);
var
  d, cs: LongInt;
begin
  d := Nodes[node].A;
  { a statement-position `fail(code)` returns failure from the enclosing failable routine: set
    its error slot and jump to the shared exit, which runs the handle-release cleanup then the
    RETV2 (doc/languages/kobold/kp-errors.md) }
  if (Nodes[d].Kind = nkCall) and (Nodes[Nodes[d].A].Kind = nkIdent) then begin
    cs := Nodes[Nodes[d].A].Sym;
    if (cs >= 0) and (Syms[cs].Node < 0) and (Syms[cs].LowerName = 'fail')
       and (Length(Nodes[d].Kids) = 1) and (CurErrorSlot >= 0) then begin
      EmitSTL(LowerExpr(Nodes[d].Kids[0]), CurErrorSlot);
      if CurExitLabel < 0 then CurExitLabel := NewLabel;
      EmitJmp(CurExitLabel);
      Exit;
    end;
  end;
  if Nodes[d].Kind = nkCall then begin
    { a discarded handle result must be released: the callee transferred it }
    if CallHandleResult(Nodes[d].A) then EmitRelease(LowerCall(d, True))
    else LowerCall(d, False);
  end
  else begin
    if CallHandleResult(d) then EmitRelease(LowerCallSym(d, [], True))
    else LowerCallSym(d, [], False);   { bare designator = zero-arg call }
  end;
end;

procedure LowerIf(node: LongInt);
var
  c, lElse, lEnd: LongInt;
begin
  c := LowerExpr(Nodes[node].A);
  lElse := NewLabel;
  EmitBZ(c, lElse);
  LowerStmt(Nodes[node].B);
  if Nodes[node].C >= 0 then begin
    lEnd := NewLabel;
    EmitJmp(lEnd);
    EmitLabel(lElse);
    LowerStmt(Nodes[node].C);
    EmitLabel(lEnd);
  end
  else
    EmitLabel(lElse);
end;

procedure LowerWhile(node: LongInt);
var
  c, lTop, lEnd: LongInt;
begin
  lTop := NewLabel;
  lEnd := NewLabel;
  EmitLabel(lTop);
  c := LowerExpr(Nodes[node].A);
  EmitBZ(c, lEnd);
  PushLoop(lTop, lEnd);
  LowerStmt(Nodes[node].B);
  PopLoop;
  EmitJmp(lTop);
  EmitLabel(lEnd);
end;

procedure LowerRepeat(node: LongInt);
var
  c, lTop, lCont, lEnd, i: LongInt;
begin
  lTop := NewLabel;
  lCont := NewLabel;
  lEnd := NewLabel;
  EmitLabel(lTop);
  PushLoop(lCont, lEnd);
  for i := 0 to High(Nodes[node].Kids) do LowerStmt(Nodes[node].Kids[i]);
  PopLoop;
  EmitLabel(lCont);
  c := LowerExpr(Nodes[node].A);
  EmitBZ(c, lTop);   { repeat while the until-condition is still false }
  EmitLabel(lEnd);
end;

procedure LowerFor(node: LongInt);
var
  s, startv, limit, limSlot, lTop, lCont, lEnd: LongInt;
  iv, lim, c, nextv, one: LongInt;
  down: Boolean;
begin
  s := Nodes[node].Sym;
  down := Nodes[node].Flag = 1;
  startv := LowerExpr(Nodes[node].A);
  if s >= 0 then StoreSym(s, startv);
  limit := LowerExpr(Nodes[node].B);
  limSlot := NewSlot(4);
  EmitSTL(limit, limSlot);
  lTop := NewLabel;
  lCont := NewLabel;
  lEnd := NewLabel;
  EmitLabel(lTop);
  if s >= 0 then iv := LoadSym(s) else iv := EmitLIC(0);
  lim := EmitLDL(limSlot);
  if down then c := EmitBin('CMPGES', iv, lim)
  else c := EmitBin('CMPLES', iv, lim);
  EmitBZ(c, lEnd);
  PushLoop(lCont, lEnd);
  LowerStmt(Nodes[node].C);
  PopLoop;
  EmitLabel(lCont);
  if s >= 0 then begin
    nextv := LoadSym(s);
    one := EmitLIC(1);
    if down then nextv := EmitBin('SUB', nextv, one)
    else nextv := EmitBin('ADD', nextv, one);
    StoreSym(s, nextv);
  end;
  EmitJmp(lTop);
  EmitLabel(lEnd);
end;

procedure LowerForIn(node: LongInt);
{ Each for-in backing was desugared in AnalyzeForIn into an ordinary statement
  tree stored in node.D (a counted loop for array/string, a MapFirst/MapNext pump
  for a map); lower that. The desugar's hidden binder vars (index, iterator,
  ignored throwaways) get their slots lazily through EnsureBinderSlot. }
begin
  LowerStmt(Nodes[node].D);
end;

procedure LowerCase(node: LongInt);
var
  sel, selSlot, lEnd, lDefault: LongInt;
  i, j, k, ll, lab, ne: LongInt;
  bodyL: array of LongInt;
  lov, hiv, s2, c1, c2, cc, cv, labv, eq, selTy: LongInt;
  lo, hi: TConstVal;
  strSel, ownedSel: Boolean;
begin
  selTy := Nodes[Nodes[node].A].Ty;
  strSel := (selTy >= 0) and (selTy < SemCount) and (SemTypes[selTy].Kind = skString);
  sel := LowerExpr(Nodes[node].A);
  { a string selector built by the selector expression (a call result, concatenation, or
    literal) owns its reference and must be released once; a borrowed variable, field, or
    constant is left alone (same rule as a string comparison operand). }
  ownedSel := strSel and IsOwnedExpr(Nodes[node].A);
  { a string selector is a handle (pointer-width); an ordinal selector is one word }
  if strSel then selSlot := NewSlot(CurTarget.PtrBytes) else selSlot := NewSlot(4);
  if strSel then EmitSTLAddr(sel, selSlot) else EmitSTL(sel, selSlot);
  ne := Length(Nodes[node].Kids);
  SetLength(bodyL, ne);
  for i := 0 to ne - 1 do bodyL[i] := NewLabel;
  lEnd := NewLabel;
  { a trailing nkCompound child is the else block }
  if (ne > 0) and (Nodes[Nodes[node].Kids[ne - 1]].Kind = nkCompound) then
    lDefault := bodyL[ne - 1]
  else
    lDefault := lEnd;
  { dispatch: test each label, branch to the matching body }
  for i := 0 to ne - 1 do begin
    k := Nodes[node].Kids[i];
    if Nodes[k].Kind = nkCaseElement then begin
      ll := Nodes[k].A;
      for j := 0 to High(Nodes[ll].Kids) do begin
        lab := Nodes[ll].Kids[j];
        lo := EvalConst(Nodes[lab].A);
        if strSel then cv := EmitLDLAddr(selSlot) else cv := EmitLDL(selSlot);
        if strSel then begin
          { a string label matches by value through kp_str_cmp (sign, 0 on equal). The label
            is a static string, so it is not owned and needs no release. }
          labv := EmitStringValue(lo.S);
          eq := EmitBin('CMPEQ', EmitStrCall2('kp_str_cmp', cv, labv), EmitLIC(0));
          EmitBNZ(eq, bodyL[i]);
        end
        else if Nodes[lab].B >= 0 then begin
          hi := EvalConst(Nodes[lab].B);
          lov := EmitLIC(lo.I);
          hiv := EmitLIC(hi.I);
          c1 := EmitBin('CMPGES', cv, lov);
          s2 := EmitLDL(selSlot);
          c2 := EmitBin('CMPLES', s2, hiv);
          cc := EmitBin('AND', c1, c2);
          EmitBNZ(cc, bodyL[i]);
        end
        else begin
          lov := EmitLIC(lo.I);
          c1 := EmitBin('CMPEQ', cv, lov);
          EmitBNZ(c1, bodyL[i]);
        end;
      end;
    end;
  end;
  { no label matched: an owned string selector with no else block is released here, on the one
    path that skips every body (each body releases it in its own prologue below, so there is
    exactly one release per path) }
  if ownedSel and (lDefault = lEnd) then EmitRelease(EmitLDLAddr(selSlot));
  EmitJmp(lDefault);
  { bodies }
  for i := 0 to ne - 1 do begin
    k := Nodes[node].Kids[i];
    EmitLabel(bodyL[i]);
    { release the owned string selector once, before the body runs, so an early break,
      continue, return, or fail out of the body cannot leak it }
    if ownedSel then EmitRelease(EmitLDLAddr(selSlot));
    if Nodes[k].Kind = nkCaseElement then LowerStmt(Nodes[k].B)
    else LowerStmt(k);   { the else compound }
    EmitJmp(lEnd);
  end;
  EmitLabel(lEnd);
end;

procedure LowerAsm(node: LongInt);
{ Lower an inline-asm statement. The basic form carries only verbatim text. The
  extended form (nkAsmOp children) carries operands: lower each input and inout
  value to a temp, give each plain output a fresh temp, then emit one ASM
  instruction whose arguments describe the operands (outputs first, then inputs)
  and the clobbers, and finally store each output temp back to its lvalue. The
  KPM line is `ASM nout=.. nin=.. vol=1 o<k>=role,constraint,temp,size ...
  c<k>=reg ... "template"`; the quoted template stays last so the reader can take
  it with the first and last quote on the line (the simple subset's register
  constraints and register names carry no quote). The simple subset allows only
  integer-class operands and the `r`, `=r`, and `+r` constraints. }
var
  k, kid, nout, nin, nclob, t, sz: LongInt;
  outTemps, outDesigs: array of LongInt;
  args, role: string;
begin
  if Length(Nodes[node].Kids) = 0 then begin
    PushInsn('ASM', EscapeStr(Nodes[node].Text));
    Exit;
  end;
  { count operands by role }
  nout := 0; nin := 0; nclob := 0;
  for k := 0 to High(Nodes[node].Kids) do
    case Nodes[Nodes[node].Kids[k]].Flag of
      1, 2: Inc(nout);
      0:    Inc(nin);
      3:    Inc(nclob);
    end;
  SetLength(outTemps, nout);
  SetLength(outDesigs, nout);
  args := 'nout=' + IntToStr(nout) + ' nin=' + IntToStr(nin) + ' vol=1';
  { outputs first in the operand list: an inout reads its lvalue into the temp
    the asm both reads and writes; a plain output gets a fresh write-only temp }
  nout := 0;
  for k := 0 to High(Nodes[node].Kids) do begin
    kid := Nodes[node].Kids[k];
    if not (Nodes[kid].Flag in [1, 2]) then Continue;
    if Nodes[kid].Flag = 2 then begin role := 'b'; t := LowerExpr(Nodes[kid].A); end
    else begin role := 'o'; t := NewTemp; end;
    outTemps[nout] := t;
    outDesigs[nout] := Nodes[kid].A;
    sz := 4;   { an integer-class ordinal lives in one GP register }
    args := args + ' o' + IntToStr(nout) + '=' + role + ',' + Nodes[kid].Text +
      ',' + IntToStr(t) + ',' + IntToStr(sz);
    Inc(nout);
  end;
  { then the inputs, numbered after the outputs }
  nin := nout;
  for k := 0 to High(Nodes[node].Kids) do begin
    kid := Nodes[node].Kids[k];
    if Nodes[kid].Flag <> 0 then Continue;
    t := LowerExpr(Nodes[kid].A);
    args := args + ' o' + IntToStr(nin) + '=i,' + Nodes[kid].Text + ',' +
      IntToStr(t) + ',4';
    Inc(nin);
  end;
  { clobbers }
  nclob := 0;
  for k := 0 to High(Nodes[node].Kids) do begin
    kid := Nodes[node].Kids[k];
    if Nodes[kid].Flag <> 3 then Continue;
    args := args + ' c' + IntToStr(nclob) + '=' + Nodes[kid].Text;
    Inc(nclob);
  end;
  args := args + ' ' + EscapeStr(Nodes[node].Text);
  PushInsn('ASM', args);
  { store each output (and inout) result temp back to its lvalue }
  for k := 0 to nout - 1 do
    StoreScalarDesig(outDesigs[k], outTemps[k]);
end;

procedure LowerStmt(node: LongInt);
var
  i: LongInt;
begin
  if node < 0 then Exit;
  if OptDebug and (Nodes[node].Kind <> nkCompound) and
     (Nodes[node].Kind <> nkEmpty) and (Nodes[node].Line > 0) then
    EmitLoc(Nodes[node].Line);
  case Nodes[node].Kind of
    nkCompound:
      { after a statement that called a routine which can suspend, a cancel-unwind may
        be in progress on return, so branch to the routine's cleanup and skip the rest.
        The check sits at a statement boundary, where no owned temporary is live, so it
        never abandons one (cancel-by-unwind stage 2). }
      begin
        PushDeferScope;
        for i := 0 to High(Nodes[node].Kids) do begin
          StmtSuspended := False;
          LowerStmt(Nodes[node].Kids[i]);
          if StmtSuspended and (CurCancelLabel >= 0) then EmitCancelCheck;
        end;
        PopDeferScope;   { fall-through: run this block's defers, then drop the scope }
      end;
    nkEmpty: ;
    nkDefer: RegisterDefer(Nodes[node].A);
    nkAssign: LowerAssign(node);
    nkCallStmt: LowerCallStmt(node);
    nkFailsTest, nkOrElse, nkOrDivert: LowerFailForm(node, False);
    nkIf: LowerIf(node);
    nkWhile: LowerWhile(node);
    nkRepeat: LowerRepeat(node);
    nkFor: LowerFor(node);
    nkForIn: LowerForIn(node);
    nkCase: LowerCase(node);
    nkBreak:
      if LoopSP > 0 then begin
        EmitDeferUnwind(LoopDeferBase[LoopSP - 1]);
        EmitJmp(LoopBreak[LoopSP - 1]);
      end;
    nkContinue:
      if LoopSP > 0 then begin
        EmitDeferUnwind(LoopDeferBase[LoopSP - 1]);
        EmitJmp(LoopCont[LoopSP - 1]);
      end;
    nkAsm:
      { inline asm. The basic form emits the verbatim text; the extended form adds
        operand and clobber metadata. The text is carried as a C-escaped quoted
        string, the same encoding the module's .string data uses, so the KPM reader
        decodes it back verbatim (doc/languages/kobold/kp-grammar.md). }
      LowerAsm(node);
    nkLabelStmt: begin
      { a `name:` label marks a jump target: emit its IR label here, then the
        statement it labels }
      EmitLabel(LowerLabelId(Nodes[node].Text));
      LowerStmt(Nodes[node].A);
    end;
    nkGoto:
      { a computed jump through the label value the operand evaluates to }
      EmitIJmp(LowerExpr(Nodes[node].A));
    nkWith:
      { the field aliases resolve to base.field through their WithBase link, so
        the body lowers directly }
      LowerStmt(Nodes[node].A);
    nkStart:
      { statement form: the coroutine is spawned but its handle is not kept, so it
        is released at once (the body never runs; see kp-grammar.md) }
      EmitRelease(LowerStart(node));
    nkYield:
      { statement form discards the resume value }
      LowerYield(node);
    nkBind:
      { statement form discards the resume value }
      LowerBind(node);
  end;
end;

{ ---- routine lowering ---- }

function FindBody(node: LongInt): LongInt;
var
  i: LongInt;
begin
  FindBody := -1;
  for i := 0 to High(Nodes[node].Kids) do
    if Nodes[Nodes[node].Kids[i]].Kind = nkBlock then FindBody := Nodes[node].Kids[i];
end;

function RoutineEmitted(k: LongInt): Boolean;
{ True when k is a routine that is lowered to a `.func` body in this module (as opposed
  to an external import or an unresolved forward), so its emitted symbol is ours to name. }
begin
  RoutineEmitted := (k >= 0) and (Syms[k].Kind in [syProc, syFunc]) and
    (Syms[k].Node >= 0) and (FindBody(Syms[k].Node) >= 0);
end;

function EmittedRoutineName(s: LongInt): string;
{ The IR symbol for a call to, or definition of, routine s. A script routine keeps its
  plain declared name unless another script routine overloads that name, in which case
  each overload takes a distinct suffix so the module carries one symbol per body, as the
  ABI requires. Names that cross the FFI (an external import or an export) stay plain,
  since overloading is not visible across that boundary. }
var
  i, cnt, ord: LongInt;
  l: string;
begin
  EmittedRoutineName := LinkNameOf(s);
  if not RoutineEmitted(s) then Exit;
  for i := 0 to IrExportCount - 1 do
    if IrExports[i] = Syms[s].Name then Exit;
  { The overload suffix depends only on the symbol table, which is stable once
    emission starts, so it is resolved once per routine and cached.  This turns
    the per-call-site O(SymCount) scan (run per reference to the routine) into a
    single scan per routine.  The export check above stays live, since exports
    are registered as emission proceeds. }
  if not Syms[s].DisambDone then begin
    l := Syms[s].LowerName;
    cnt := 0;
    ord := 0;
    for i := 0 to SymCount - 1 do
      if RoutineEmitted(i) and (Syms[i].LowerName = l) then begin
        if i = s then ord := cnt;
        Inc(cnt);
      end;
    if cnt > 1 then Syms[s].DisambName := Syms[s].Name + '$' + IntToStr(ord)
    else Syms[s].DisambName := '';
    Syms[s].DisambDone := True;
  end;
  if Syms[s].DisambName <> '' then EmittedRoutineName := Syms[s].DisambName;
end;

function RoutineLinkName(node: LongInt): string;
{ The emitted symbol for a routine declaration: a method is <ReceiverType>.<name>, a free
  routine its EmittedRoutineName. Shared by the definition, its export, and its call sites. }
var
  s, rsym: LongInt;
begin
  s := Nodes[node].Sym;
  RoutineLinkName := EmittedRoutineName(s);
  if Nodes[node].A >= 0 then begin
    rsym := Nodes[Nodes[node].A].Sym;
    if rsym >= 0 then
      RoutineLinkName := SemTypes[Syms[rsym].TypeId].Name + '.' + Syms[s].Name;
  end;
end;

function BodyCompound(block: LongInt): LongInt;
var
  i: LongInt;
begin
  BodyCompound := -1;
  for i := 0 to High(Nodes[block].Kids) do
    if Nodes[Nodes[block].Kids[i]].Kind = nkCompound then
      BodyCompound := Nodes[block].Kids[i];
end;

function SlotBytes(ty: LongInt): LongInt;
{ Byte size of a slot: the value's size (a real is 8, a scalar 4, an aggregate
  its full byte size). }
begin
  SlotBytes := TypeSize(ty);
end;

procedure AssignBlockSlots(block: LongInt);
{ Give each local variable declared in this block a slot, in declaration order. }
var
  i, j, dcl, sym, sl: LongInt;
begin
  for i := 0 to High(Nodes[block].Kids) do begin
    dcl := Nodes[block].Kids[i];
    if Nodes[dcl].Kind = nkVarDecl then
      for j := 0 to High(Nodes[dcl].Kids) do begin
        sym := Nodes[Nodes[dcl].Kids[j]].Sym;
        if sym >= 0 then begin
          sl := NewSlot(SlotBytes(Syms[sym].TypeId));
          Syms[sym].Slot := sl;
        end;
      end;
  end;
end;

procedure CollectHandleLocals(block: LongInt; var slots, offs: TIntArray);
{ Every owning handle reference held by the block's local variables, as parallel (slot,
  offset) pairs: a whole-handle local contributes its slot at offset 0, and a record or
  fixed-array local contributes one pair per handle field, so scope exit releases them all. }
var
  i, j, k, dcl, sym, n: LongInt;
  foffs: TIntArray;
begin
  for i := 0 to High(Nodes[block].Kids) do begin
    dcl := Nodes[block].Kids[i];
    if Nodes[dcl].Kind = nkVarDecl then
      for j := 0 to High(Nodes[dcl].Kids) do begin
        sym := Nodes[Nodes[dcl].Kids[j]].Sym;
        if sym < 0 then continue;
        foffs := nil;
        CollectHandleOffsets(Syms[sym].TypeId, 0, foffs);
        for k := 0 to High(foffs) do begin
          n := Length(slots);
          SetLength(slots, n + 1);
          SetLength(offs, n + 1);
          slots[n] := Syms[sym].Slot;
          offs[n] := foffs[k];
        end;
      end;
  end;
end;

procedure LowerRoutine(node: LongInt);
{ node is nkProcDecl or nkFuncDecl with a body. }
var
  isFunc, realRet, wideRet, byref, failRet, failWide: Boolean;
  s, i, j, prm, sym, sl, block, comp, pty, retTy, z, rsym, savedFunc, failPtrSlot: LongInt;
  savedLabelBase: LongInt;
  fname: string;
  hslots, hoffs: TIntArray;
begin
  block := FindBody(node);
  if block < 0 then Exit;   { forward or external: no body to lower }
  s := Nodes[node].Sym;
  isFunc := Nodes[node].Kind = nkFuncDecl;
  failRet := (Syms[s].TypeId >= 0) and SemTypes[Syms[s].TypeId].Failable;
  { a bare function name in the body denotes the result variable; lowering reads and writes
    the result slot when it sees CurFuncSym, so track the routine being lowered }
  savedFunc := CurFuncSym;
  if isFunc then CurFuncSym := s else CurFuncSym := -1;
  retTy := SemTypes[Syms[s].TypeId].RetType;
  realRet := IsRealType(retTy);
  wideRet := WideStore(retTy);   { a 64-bit result: a small set, an Int64, or an LP64 handle }
  { a failable function returns a real, 64-bit, or aggregate result through a hidden caller
    buffer (sret); a non-aggregate wide result additionally keeps a local value slot that is
    stored through the hidden pointer at the single return site (FailWideResult) }
  failWide := isFunc and FailWideResult(Syms[s].TypeId);
  { a method is emitted as <ReceiverType>.<name>, matching its call sites and
    keeping it out of the free-function namespace }
  fname := RoutineLinkName(node);
  rsym := -1;
  if Nodes[node].A >= 0 then rsym := Nodes[Nodes[node].A].Sym;
  CurFn := AddIrFunc(fname, True);
  CurResultSlot := -1;
  CurErrorSlot := -1;
  failPtrSlot := -1;
  FailCaptureSlot := -1;
  LoopSP := 0;
  DeferScopeSP := 0; DeferCount := 0;
  PendingMapInsert := -1;
  { open this routine's label-id scope (threaded dispatch): @name and a `name:`
    definition share one IR label id, allocated on first mention }
  savedLabelBase := LabelBase;
  LabelBase := LabelCount;
  { parameters occupy the first slots, in declaration order }
  prm := 0;
  { a method receiver is parameter 0, passed by reference: its slot holds a
    pointer to the receiver }
  if rsym >= 0 then begin
    Syms[rsym].Slot := NewSlot(CurTarget.PtrBytes);   { holds the receiver's address }
    SetLength(IrFuncs[CurFn].ParamClass, prm + 1);
    IrFuncs[CurFn].ParamClass[prm] := 0;
    SetLength(IrFuncs[CurFn].ParamFW, prm + 1);
    IrFuncs[CurFn].ParamFW[prm] := 0;
    Inc(prm);
  end;
  for i := 0 to High(Nodes[node].Kids) do
    if Nodes[Nodes[node].Kids[i]].Kind = nkParam then
      for j := 0 to High(Nodes[Nodes[node].Kids[i]].Kids) do begin
        sym := Nodes[Nodes[Nodes[node].Kids[i]].Kids[j]].Sym;
        if sym >= 0 then pty := Syms[sym].TypeId else pty := -1;
        { a by-reference parameter (an aggregate, or a scalar var/out) is passed as
          a pointer: its slot holds the address, and the pointer travels in a
          general register even when the pointee is real or single }
        byref := (sym >= 0) and ParamByRef(sym);
        if byref then sl := NewSlot(CurTarget.PtrBytes) else sl := NewSlot(SlotBytes(pty));
        if sym >= 0 then Syms[sym].Slot := sl;
        SetLength(IrFuncs[CurFn].ParamClass, prm + 1);
        if (not byref) and IsRealType(pty) then IrFuncs[CurFn].ParamClass[prm] := 1
        else IrFuncs[CurFn].ParamClass[prm] := 0;
        SetLength(IrFuncs[CurFn].ParamFW, prm + 1);
        if (not byref) and IsSingle(pty) then IrFuncs[CurFn].ParamFW[prm] := 1
        else IrFuncs[CurFn].ParamFW[prm] := 0;
        Inc(prm);
      end;
  { captured enclosing variables are hidden by-pointer parameters after the
    declared ones; each holds an address (pointer-width, int class) }
  for i := 0 to High(RoutineCaptures[s]) do begin
    sl := NewSlot(CurTarget.PtrBytes);   { holds the captured variable's address }
    CapSlot[RoutineCaptures[s][i]] := sl;
    SetLength(IrFuncs[CurFn].ParamClass, prm + 1);
    IrFuncs[CurFn].ParamClass[prm] := 0;
    SetLength(IrFuncs[CurFn].ParamFW, prm + 1);
    IrFuncs[CurFn].ParamFW[prm] := 0;
    Inc(prm);
  end;
  { an aggregate result is returned through caller storage (sret): a hidden final pointer
    parameter carries the caller's buffer address, and the result is addressed through it. A
    failable real or 64-bit result takes the same hidden pointer (failPtrSlot), with its value
    held in a local slot and stored through the pointer at the return. }
  if isFunc and IsAggregate(retTy) then begin
    CurResultSlot := NewSlot(CurTarget.PtrBytes);   { the sret buffer address }
    SetLength(IrFuncs[CurFn].ParamClass, prm + 1);
    IrFuncs[CurFn].ParamClass[prm] := 0;
    SetLength(IrFuncs[CurFn].ParamFW, prm + 1);
    IrFuncs[CurFn].ParamFW[prm] := 0;
    Inc(prm);
  end
  else if failWide then begin
    failPtrSlot := NewSlot(CurTarget.PtrBytes);   { the hidden sret-style result pointer }
    SetLength(IrFuncs[CurFn].ParamClass, prm + 1);
    IrFuncs[CurFn].ParamClass[prm] := 0;
    SetLength(IrFuncs[CurFn].ParamFW, prm + 1);
    IrFuncs[CurFn].ParamFW[prm] := 0;
    Inc(prm);
  end;
  IrFuncs[CurFn].Nparams := prm;
  AssignBlockSlots(block);
  if isFunc and not IsAggregate(retTy) then begin
    if realRet or wideRet then CurResultSlot := NewSlot(8)
    else CurResultSlot := NewSlot(4);
  end;
  { a failable routine reports its error beside the value; the slot defaults to 0 (success),
    and `fail` / `or fail` set it before jumping to the shared exit (doc/languages/kobold/kp-errors.md) }
  if failRet then begin
    CurErrorSlot := NewSlot(4);
    EmitSTL(EmitLIC(0), CurErrorSlot);
  end;
  { handle locals own a reference: zero them on entry (so the first assignment's
    release sees nil), and release them on exit. The result is not released, since
    a returned handle transfers to the caller. Parameters are borrowed. }
  SetLength(hslots, 0);
  SetLength(hoffs, 0);
  CollectHandleLocals(block, hslots, hoffs);
  if (Length(hslots) > 0) or (isFunc and IsHandle(retTy)) then begin
    z := EmitLIC(0);
    for i := 0 to High(hslots) do
      if hoffs[i] = 0 then EmitSTLAddr(z, hslots[i])
      else EmitStorePtr(AddOff(EmitADL(hslots[i]), hoffs[i]), z);
    if isFunc and IsHandle(retTy) then EmitSTLAddr(z, CurResultSlot);
  end;
  { an exported routine may be the host's entry instead of main, so it runs the shared
    global-init first (main and an export never both run in one process, so one call is
    enough and no guard is needed) }
  if (Nodes[node].Exported = 1) and NeedGlobalInit then
    PushInsn('CALL', 'sym=__init nargs=0');
  comp := BodyCompound(block);
  { A routine that can suspend (yields, or calls something that can) gets a cleanup
    label, so a cancel-unwind (dropping a suspended coroutine) can jump straight to the
    scope-exit releases below. Normal control falls through the label into the same
    releases, so a routine that never suspends needs none. }
  if CanYield[s] then CurCancelLabel := NewLabel else CurCancelLabel := -1;
  { `Exit` jumps to CurExitLabel, allocated lazily when the body first uses Exit, so a
    routine without Exit emits no extra label and its IR is unchanged }
  CurExitLabel := -1;
  if isFunc then CurExitFunc := s else CurExitFunc := -1;
  LowerStmt(comp);
  if CurCancelLabel >= 0 then EmitLabel(CurCancelLabel);
  if CurExitLabel >= 0 then EmitLabel(CurExitLabel);
  for i := 0 to High(hslots) do
    if hoffs[i] = 0 then EmitRelease(EmitLDLAddr(hslots[i]))
    else EmitRelease(EmitLoadPtr(AddOff(EmitADL(hslots[i]), hoffs[i])));
  if failRet then begin
    if failWide then begin
      { a real or 64-bit value is stored through the caller's hidden buffer pointer here; an
        aggregate was already written through CurResultSlot (the hidden pointer). The error
        then returns alone in the integer register. }
      if not IsAggregate(retTy) then begin
        if realRet then EmitStoreScalar(EmitLDLAddr(failPtrSlot), EmitFLDL(CurResultSlot), retTy)
        else EmitStoreScalar(EmitLDLAddr(failPtrSlot), EmitLDL64(CurResultSlot), retTy);
      end;
      EmitRetv(EmitLDL(CurErrorSlot));
    end
    { an integer-class failable function returns the value and the error in the register pair }
    else if isFunc then EmitRetv2(EmitLDL(CurResultSlot), EmitLDL(CurErrorSlot))
    else EmitRetv2(EmitLIC(0), EmitLDL(CurErrorSlot));
  end
  else if isFunc then
    if realRet then EmitFRetv(EmitFLDL(CurResultSlot), IsSingle(retTy))
    else if wideRet then EmitRetv64(EmitLDL64(CurResultSlot))
    else EmitRetv(EmitLDL(CurResultSlot))
  else EmitRet;
  CurCancelLabel := -1;
  CurExitLabel := -1;
  CurExitFunc := -1;
  CurErrorSlot := -1;
  CurFuncSym := savedFunc;
  { close this routine's label-id scope }
  LabelCount := LabelBase;
  LabelBase := savedLabelBase;
  { the capture mapping is scoped to this routine's body }
  for i := 0 to High(RoutineCaptures[s]) do CapSlot[RoutineCaptures[s][i]] := -1;
end;

{ ---- capture analysis ---- }

function IsEnclosingVar(v, bodyScope: LongInt): Boolean;
{ True when variable v belongs to a routine that strictly encloses the routine
  whose body scope is bodyScope. A global (GlobalScope) is reached by its symbol, not
  captured, and the system scope (0) holds no variables. }
begin
  IsEnclosingVar := (Syms[v].Kind in [syVar, syParam]) and (Syms[v].Scope <> 0) and
    (Syms[v].Scope <> GlobalScope) and IsAncestorScope(Syms[v].Scope, bodyScope);
end;

procedure AddCapture(var acc: TIntArray; v: LongInt);
{ Insert v into acc keeping it sorted and unique, so a call site and the callee
  agree on the order of the hidden parameters. }
var
  i, n, pos: LongInt;
begin
  n := Length(acc);
  pos := n;   { append at the end unless a larger element is found }
  for i := 0 to n - 1 do begin
    if acc[i] = v then Exit;
    if acc[i] > v then begin pos := i; Break; end;
  end;
  SetLength(acc, n + 1);
  for i := n downto pos + 1 do acc[i] := acc[i - 1];
  acc[pos] := v;
end;

procedure ScanBody(node, bodyScope: LongInt; var caps, calls: TIntArray);
{ Scan a routine's own body (stopping at nested routine declarations, which are
  separate routines): gather the enclosing variables it references directly and
  the routines it calls. }
var
  i, s: LongInt;
begin
  if node < 0 then Exit;
  if Nodes[node].Kind in [nkProcDecl, nkFuncDecl] then Exit;
  { start spawns a coroutine: the target is not a call of this routine (it does not
    make the spawner suspend), and a start begin..end block is a separate lifted
    function. Only a call-form's seed arguments are evaluated here, so scan just those. }
  if Nodes[node].Kind = nkStart then begin
    if (Nodes[node].Flag <> 1) and (Nodes[node].A >= 0) and
       (Nodes[Nodes[node].A].Kind = nkCall) then
      for i := 0 to High(Nodes[Nodes[node].A].Kids) do
        ScanBody(Nodes[Nodes[node].A].Kids[i], bodyScope, caps, calls);
    Exit;
  end;
  s := Nodes[node].Sym;
  if s >= 0 then
    if IsEnclosingVar(s, bodyScope) then AddCapture(caps, s)
    else if Syms[s].Kind in [syProc, syFunc] then AddCapture(calls, s);
  ScanBody(Nodes[node].A, bodyScope, caps, calls);
  ScanBody(Nodes[node].B, bodyScope, caps, calls);
  ScanBody(Nodes[node].C, bodyScope, caps, calls);
  ScanBody(Nodes[node].D, bodyScope, caps, calls);
  for i := 0 to High(Nodes[node].Kids) do
    ScanBody(Nodes[node].Kids[i], bodyScope, caps, calls);
end;

procedure GatherRoutineList(block: LongInt; var list: TIntArray);
{ Collect every routine (with a body) declared at or below this block. }
var
  i, k, rSym, body: LongInt;
begin
  for i := 0 to High(Nodes[block].Kids) do begin
    k := Nodes[block].Kids[i];
    if Nodes[k].Kind in [nkProcDecl, nkFuncDecl] then begin
      rSym := Nodes[k].Sym;
      body := FindBody(k);
      if (rSym >= 0) and (body >= 0) then begin
        AddCapture(list, rSym);
        GatherRoutineList(body, list);
      end;
    end;
  end;
end;

procedure ComputeCaptures(block: LongInt);
{ Compute each nested routine's captured-variable list. A routine captures an
  enclosing variable it references directly, plus any enclosing variable one of
  its callees needs threaded (a call-graph fixpoint, since a routine forwards to
  a sibling what that sibling captures). }
var
  routines, caps, calls: TIntArray;
  r, c, v, ri, ci, vi, rSym, before: LongInt;
  changed: Boolean;
begin
  SetLength(routines, 0);
  GatherRoutineList(block, routines);
  { seed with direct references and record the call graph }
  for ri := 0 to High(routines) do begin
    rSym := routines[ri];
    SetLength(caps, 0);
    SetLength(calls, 0);
    ScanBody(FindBody(Syms[rSym].Node), Syms[rSym].BodyScope, caps, calls);
    RoutineCaptures[rSym] := caps;
    CallsOf[rSym] := calls;
  end;
  { propagate to a fixpoint: a caller threads whatever a callee captures that is
    still enclosing to the caller }
  repeat
    changed := False;
    for ri := 0 to High(routines) do begin
      r := routines[ri];
      for ci := 0 to High(CallsOf[r]) do begin
        c := CallsOf[r][ci];
        for vi := 0 to High(RoutineCaptures[c]) do begin
          v := RoutineCaptures[c][vi];
          if IsEnclosingVar(v, Syms[r].BodyScope) then begin
            before := Length(RoutineCaptures[r]);
            AddCapture(RoutineCaptures[r], v);
            if Length(RoutineCaptures[r]) <> before then changed := True;
          end;
        end;
      end;
    end;
  until not changed;
  { can-yield fixpoint over the same call graph: a routine can suspend if it yields
    directly or calls a routine that can (cancel-by-unwind stage 2). Indirect calls
    through a procedure value are not in CallsOf, so they stay stage-1 (leak-free but
    the caller runs its between-yield code). }
  for ri := 0 to High(routines) do begin
    r := routines[ri];
    CanYield[r] := BodyHasYield(BodyCompound(FindBody(Syms[r].Node)));
  end;
  repeat
    changed := False;
    for ri := 0 to High(routines) do begin
      r := routines[ri];
      if CanYield[r] then Continue;
      for ci := 0 to High(CallsOf[r]) do
        if CanYield[CallsOf[r][ci]] then begin
          CanYield[r] := True;
          changed := True;
          Break;
        end;
    end;
  until not changed;
end;

{ ---- Suspend-position restriction ----

  A suspend point (yield, bind, or a call to a routine that can transitively yield) may
  appear only at statement position: as a whole statement, or as the entire right-hand
  side of an assignment. Nesting one inside an expression is rejected here. This keeps
  the cancel-by-unwind check both prompt (a suspend in a loop or branch condition could
  otherwise run unbounded before the next statement-boundary check) and leak-free (a
  suspend mid-expression could otherwise abandon an owned temporary when it unwinds). }

function SuspendReason(node: LongInt): string;
{ Non-empty when node is a suspend point; the text names it for the diagnostic. }
var
  s, cal: LongInt;
begin
  SuspendReason := '';
  if node < 0 then Exit;
  case Nodes[node].Kind of
    nkYield: SuspendReason := '''yield''';
    nkBind:  SuspendReason := '''bind''';
    nkCall, nkIdent: begin
      if Nodes[node].Kind = nkCall then cal := Nodes[node].A else cal := node;
      if (cal >= 0) and (Nodes[cal].Kind = nkIdent) then begin
        s := Nodes[cal].Sym;
        if (s >= 0) and (s <= High(CanYield)) and
           (Syms[s].Kind in [syProc, syFunc]) and CanYield[s] then
          SuspendReason := 'a call to ''' + Syms[s].Name + ''' (which can yield)';
      end;
    end;
  end;
end;

procedure CheckExprNoSuspend(node: LongInt); forward;
procedure CheckStmtSuspend(node: LongInt); forward;

procedure CheckLValue(node: LongInt);
{ A designator used as a target or callee: its head name is not an expression, so only
  an embedded index expression can hide a suspend. }
var
  i: LongInt;
begin
  if node < 0 then Exit;
  case Nodes[node].Kind of
    nkField: CheckLValue(Nodes[node].A);
    nkIndex: begin
      CheckLValue(Nodes[node].A);
      for i := 0 to High(Nodes[node].Kids) do CheckExprNoSuspend(Nodes[node].Kids[i]);
    end;
  end;
end;

procedure CheckStart(node: LongInt);
{ start does not itself suspend. A start begin..end block is a separate routine, so its
  statements are checked as statements; a call-form's seed arguments are expressions. }
var
  i, cal: LongInt;
begin
  if Nodes[node].Flag = 1 then CheckStmtSuspend(Nodes[node].A)
  else begin
    cal := Nodes[node].A;
    if (cal >= 0) and (Nodes[cal].Kind = nkCall) then
      for i := 0 to High(Nodes[cal].Kids) do CheckExprNoSuspend(Nodes[cal].Kids[i]);
  end;
end;

procedure CheckSuspendOperands(node: LongInt);
{ node is a suspend point allowed at statement position; its own operands are still
  expressions and may not contain a further suspend. }
var
  i: LongInt;
begin
  case Nodes[node].Kind of
    nkYield, nkBind: CheckExprNoSuspend(Nodes[node].A);
    nkCall:
      for i := 0 to High(Nodes[node].Kids) do CheckExprNoSuspend(Nodes[node].Kids[i]);
  end;
end;

procedure CheckExprNoSuspend(node: LongInt);
{ node is in an expression position: no suspend point may occur anywhere within it. }
var
  i: LongInt;
  r: string;
begin
  if node < 0 then Exit;
  if Nodes[node].Kind = nkStart then begin CheckStart(node); Exit; end;
  r := SuspendReason(node);
  if r <> '' then
    SemErr(node, r + ' may not appear inside an expression; write it as its own ' +
      'statement or the whole right-hand side of an assignment');
  if Nodes[node].Kind = nkCall then begin
    CheckLValue(Nodes[node].A);
    for i := 0 to High(Nodes[node].Kids) do CheckExprNoSuspend(Nodes[node].Kids[i]);
    Exit;
  end;
  CheckExprNoSuspend(Nodes[node].A);
  CheckExprNoSuspend(Nodes[node].B);
  CheckExprNoSuspend(Nodes[node].C);
  CheckExprNoSuspend(Nodes[node].D);
  for i := 0 to High(Nodes[node].Kids) do CheckExprNoSuspend(Nodes[node].Kids[i]);
end;

procedure CheckStmtSuspend(node: LongInt);
{ Walk a statement, allowing a suspend point only at statement position. }
var
  i, k: LongInt;
begin
  if node < 0 then Exit;
  case Nodes[node].Kind of
    nkCompound:
      for i := 0 to High(Nodes[node].Kids) do CheckStmtSuspend(Nodes[node].Kids[i]);
    nkAssign: begin
      CheckLValue(Nodes[node].A);
      if SuspendReason(Nodes[node].B) <> '' then CheckSuspendOperands(Nodes[node].B)
      else CheckExprNoSuspend(Nodes[node].B);
    end;
    nkCallStmt:
      if SuspendReason(Nodes[node].A) <> '' then CheckSuspendOperands(Nodes[node].A)
      else CheckExprNoSuspend(Nodes[node].A);
    nkFailsTest, nkOrElse, nkOrDivert:
      { the embedded failable call and any `or else` fallback are expression positions }
      CheckExprNoSuspend(node);
    nkYield, nkBind: CheckSuspendOperands(node);
    nkStart: CheckStart(node);
    nkIf: begin
      CheckExprNoSuspend(Nodes[node].A);
      CheckStmtSuspend(Nodes[node].B);
      CheckStmtSuspend(Nodes[node].C);
    end;
    nkWhile: begin
      CheckExprNoSuspend(Nodes[node].A);
      CheckStmtSuspend(Nodes[node].B);
    end;
    nkFor: begin
      CheckExprNoSuspend(Nodes[node].A);
      CheckExprNoSuspend(Nodes[node].B);
      CheckStmtSuspend(Nodes[node].C);
    end;
    nkRepeat: begin
      for i := 0 to High(Nodes[node].Kids) do CheckStmtSuspend(Nodes[node].Kids[i]);
      CheckExprNoSuspend(Nodes[node].A);
    end;
    nkCase: begin
      CheckExprNoSuspend(Nodes[node].A);
      for i := 0 to High(Nodes[node].Kids) do begin
        k := Nodes[node].Kids[i];
        if Nodes[k].Kind = nkCaseElement then CheckStmtSuspend(Nodes[k].B)
        else CheckStmtSuspend(k);
      end;
    end;
    nkWith: begin
      for i := 0 to High(Nodes[node].Kids) do CheckLValue(Nodes[node].Kids[i]);
      CheckStmtSuspend(Nodes[node].A);
    end;
  end;
end;

procedure CheckSuspendBlock(block: LongInt);
{ Check the block's own body and every routine declared in it, recursively. }
var
  i, k, body: LongInt;
begin
  CheckStmtSuspend(BodyCompound(block));
  for i := 0 to High(Nodes[block].Kids) do begin
    k := Nodes[block].Kids[i];
    if Nodes[k].Kind in [nkProcDecl, nkFuncDecl] then begin
      body := FindBody(k);
      if body >= 0 then CheckSuspendBlock(body);
    end;
  end;
end;

procedure GatherAndLower(block: LongInt);
{ Walk a block: external routines become imports, routines with bodies are
  lowered (recursing into their own nested routines first collected here). }
var
  i, k: LongInt;
begin
  for i := 0 to High(Nodes[block].Kids) do begin
    k := Nodes[block].Kids[i];
    if Nodes[k].Kind in [nkProcDecl, nkFuncDecl] then begin
      if Nodes[k].Flag = 2 then
        AddIrImport(Nodes[k].Sym)          { external: a host import }
      else if FindBody(k) >= 0 then begin
        { record the export before lowering, so the body emits its link name (a method as
          <ReceiverType>.<name>) }
        if (Nodes[k].Exported = 1) and (Nodes[k].Sym >= 0) then
          AddIrExport(RoutineLinkName(k));
        LowerRoutine(k);
        GatherAndLower(FindBody(k));       { nested routines }
      end;
    end;
  end;
end;

procedure LowerPendingStartEntries;
{ Lower each queued `start begin..end` block as a synthesized parameterless entry
  function. Draining may queue more entries (a block that itself spawns a block), so
  the loop advances with the growing queue. Each entry is lowered as its own
  top-level function with fresh loop state; the no-capture rule means a block body
  reaches only globals and its own statements, so there are no parameters or
  captures. }
var
  q: LongInt;
begin
  q := 0;
  while q < StartQueueCount do begin
    CurFn := AddIrFunc(StartQueueName[q], True);
    IrFuncs[CurFn].Nparams := 0;
    CurResultSlot := -1;
    LoopSP := 0;
    DeferScopeSP := 0; DeferCount := 0;
    { a start block declares no locals (no-capture rule), so it owns no frame handles
      and needs no cancel-unwind cleanup; its yields emit no cancel check }
    CurCancelLabel := -1;
    LowerStmt(StartQueueBody[q]);
    EmitRet;
    Inc(q);
  end;
end;

procedure LowerCoThunks;
{ Emit each queued coroutine seed-argument thunk. co_run calls a coroutine entry with
  the runtime ABI entry(vm, argsp, nargs): parameter 0 is the vm, parameter 1 is the
  seed buffer, parameter 2 is the count. A worker routine, however, reads its own
  parameters by the routine calling convention. The thunk reconciles the two: it takes
  the three entry parameters, loads each seed cell back at the worker's parameter type,
  and calls the worker, returning the worker's result as the coroutine completion value.
  A worker with captured variables cannot be seeded this way and is not spawned here. }
var
  q, s, sig, np, i, argspSlot, pbase, addr, d, ret: LongInt;
  pty: LongInt;
  wname: string;
begin
  q := 0;
  while q < CoThunkCount do begin
    s := CoThunkWorker[q];
    sig := Syms[s].TypeId;
    wname := EmittedRoutineName(s);
    np := Length(SemTypes[sig].ParamTypes);
    CurFn := AddIrFunc(CoThunkName[q], True);
    CurResultSlot := -1;
    LoopSP := 0;
    DeferScopeSP := 0; DeferCount := 0;
    CurCancelLabel := -1;
    { three entry parameters: vm (pointer), argsp (pointer), nargs (int); slots 0, 1, 2 }
    NewSlot(CurTarget.PtrBytes);
    argspSlot := NewSlot(CurTarget.PtrBytes);
    NewSlot(4);
    SetLength(IrFuncs[CurFn].ParamClass, 3);
    for i := 0 to 2 do IrFuncs[CurFn].ParamClass[i] := 0;
    IrFuncs[CurFn].Nparams := 3;
    pbase := EmitLDLAddr(argspSlot);
    for i := 0 to np - 1 do begin
      if i = 0 then addr := pbase
      else addr := AddOff(pbase, i * 8);
      pty := SemTypes[sig].ParamTypes[i];
      if IsRealType(pty) then EmitFArg(EmitFLD(addr))
      else if WideStore(pty) then EmitArg64(EmitLD64(addr))
      else EmitArg(EmitLD64(addr));
    end;
    ret := SemTypes[sig].RetType;
    if (Syms[s].Kind = syFunc) and (ret >= 0) and not IsRealType(ret) then begin
      d := NewTemp;
      if WideStore(ret) then begin
        PushInsn('CALL64', 'dst=' + IntToStr(d) + ' sym=' + wname +
          ' nargs=' + IntToStr(np));
        EmitRetv64(d);
      end
      else begin
        PushInsn('CALL', 'dst=' + IntToStr(d) + ' sym=' + wname +
          ' nargs=' + IntToStr(np));
        EmitRetv(d);
      end;
    end
    else begin
      { a procedure worker, or a real-returning one whose value cannot ride the
        int64 completion channel: call and complete with zero }
      PushInsn('CALL', 'sym=' + wname + ' nargs=' + IntToStr(np));
      EmitRetv(EmitLIC(0));
    end;
    Inc(q);
  end;
end;

procedure EmitStrConstArrayInits;
{ At the start of main, give each string constant array a zeroed global slot array and fill
  it: create each element string and store its handle into a slot. The array owns those
  strings for the program's lifetime; the teardown sweep reclaims them. Run before the
  program body and before any routine is lowered, so a reference finds ConstAggName set. }
var
  i, s, agg, extent, base, j, v: LongInt;
  nm: string;
  ev: TConstVal;
begin
  for i := 0 to StrConstArrayCount - 1 do begin
    s := StrConstArrays[i];
    agg := Nodes[Syms[s].Node].B;
    extent := Length(Nodes[agg].Kids);
    nm := '_carr' + IntToStr(IrGlobalCount);
    { each element is a string handle, pointer-width: an i64 array under LP64 }
    if CurTarget.PtrBytes = 8 then AddIrGlobalArr(nm, 'i64', extent)
    else AddIrGlobalArr(nm, 'i32', extent);
    Syms[s].ConstAggName := nm;
    base := EmitLEA(nm);
    for j := 0 to extent - 1 do begin
      ev := EvalConst(Nodes[agg].Kids[j]);
      v := EmitStringValue(ev.S);   { value staged before the address, for determinism }
      EmitStorePtr(AddOff(base, j * CurTarget.PtrBytes), v);
    end;
  end;
end;

function RealBitsFromConst(valNode: LongInt): Int64;
{ The f64 bit pattern of a real constant element: a real literal carries its own bits, an
  integer constant is promoted by building the bits from its decimal text (the magnitude
  through RealLitBits, the sign applied separately since RealLitBits reads digits only). }
var
  ev: TConstVal;
  bits: Int64;
  neg: Boolean;
begin
  ev := EvalConst(valNode);
  if ev.IsReal then
    RealBitsFromConst := ev.RBits
  else begin
    neg := ev.I < 0;
    if neg then bits := RealLitBits(IntToStr(-ev.I))
    else bits := RealLitBits(IntToStr(ev.I));
    if neg then bits := bits or (Int64(1) shl 63);
    RealBitsFromConst := bits;
  end;
end;

procedure EmitConstValueAt(ty, valNode, base, off: LongInt); forward;

procedure EmitConstArray(arrTy, dim, node, base, off: LongInt);
{ Fill one dimension of a fixed-array constant into the blob, row-major. The stride of this
  dimension is the element size times the extents of every deeper dimension, so a nested list
  lands at the flat offset the array-indexing lowering computes. }
var
  i, d, stride: LongInt;
begin
  stride := TypeSize(SemTypes[arrTy].Base);
  for d := dim + 1 to High(SemTypes[arrTy].Subs) do
    stride := stride * (SemTypes[SemTypes[arrTy].Subs[d]].Hi -
                        SemTypes[SemTypes[arrTy].Subs[d]].Lo + 1);
  for i := 0 to High(Nodes[node].Kids) do
    if dim < High(SemTypes[arrTy].Subs) then
      EmitConstArray(arrTy, dim + 1, Nodes[node].Kids[i], base, off + i * stride)
    else
      EmitConstValueAt(SemTypes[arrTy].Base, Nodes[node].Kids[i], base, off + i * stride);
end;

procedure EmitConstValueAt(ty, valNode, base, off: LongInt);
{ Store a constant value of type ty, described by valNode, into the blob at byte off: a string
  its freshly created handle, a record its fields at their offsets, a fixed array its elements
  row-major, a real its f64 bit pattern, an int64 a 64-bit immediate, any other ordinal a
  32-bit immediate. The value is staged before its address, the deterministic order the other
  const initializers use. }
var
  f, fi, m, v: LongInt;
  ev: TConstVal;
begin
  if SemTypes[ty].Kind = skString then begin
    ev := EvalConst(valNode);
    v := EmitStringValue(ev.S);
    EmitStorePtr(AddOff(base, off), v);   { a string handle is pointer-width }
  end
  else if SemTypes[ty].Kind = skRecord then
    for f := 0 to High(Nodes[valNode].Kids) do begin
      fi := Nodes[valNode].Kids[f];
      m := FindMember(ty, Nodes[fi].Text);
      EmitConstValueAt(SemTypes[ty].Subs[m], Nodes[fi].A, base, off + FieldOffset(ty, m));
    end
  else if (SemTypes[ty].Kind = skArray) and (Length(SemTypes[ty].Subs) > 0) then
    EmitConstArray(ty, 0, valNode, base, off)
  else if IsSingle(ty) then begin
    { a single element is 4 bytes: load the f64 value from the constant pool and store it
      narrowed to f32 (FSS), the same narrowing a single store uses at runtime }
    v := EmitRealConstBits(RealBitsFromConst(valNode));
    EmitFSS(AddOff(base, off), v);
  end
  else if IsRealType(ty) then begin
    v := EmitLIC64(RealBitsFromConst(valNode));
    EmitST64(AddOff(base, off), v);
  end
  else if Wide64(ty) then begin
    ev := EvalConst(valNode);
    v := EmitLIC64(ev.I);
    EmitST64(AddOff(base, off), v);
  end
  else begin
    ev := EvalConst(valNode);
    v := EmitLIC(ev.I);
    EmitSW(AddOff(base, off), v);
  end;
end;

procedure EmitRecConstArrayInits;
{ At the start of main, give each blob constant (a record, a record or multi-dimensional array,
  or any array with non-32-bit-ordinal elements) a global blob and fill it: a string element
  gets a freshly created string handle, a scalar its immediate value, recursively. Any owned
  strings live for the program's lifetime; the teardown sweep reclaims them. Runs before the
  program body so a reference finds ConstAggName set. }
var
  i, s, base: LongInt;
  nm: string;
begin
  for i := 0 to RecConstArrayCount - 1 do begin
    s := RecConstArrays[i];
    nm := '_rarr' + IntToStr(IrGlobalCount);
    { under LP64 the blob holds pointer-width handle fields at 8-aligned offsets, so
      declare it as i64 words (8-aligned, and large enough) }
    if CurTarget.PtrBytes = 8 then
      AddIrGlobalArr(nm, 'i64', (TypeSize(Syms[s].TypeId) + 7) div 8)
    else
      AddIrGlobalArr(nm, 'i32', (TypeSize(Syms[s].TypeId) + 3) div 4);
    Syms[s].ConstAggName := nm;
    base := EmitLEA(nm);
    EmitConstValueAt(Syms[s].TypeId, Nodes[Syms[s].Node].B, base, 0);
  end;
end;

function GlobalBaseType(ty: LongInt): string;
{ The KPM1 base-type string a scalar global (or interface var) is stored as. }
begin
  if IsSet(ty) then GlobalBaseType := 'i64'
  else if IsInt64(ty) then GlobalBaseType := 'i64'
  else if IsSingle(ty) then GlobalBaseType := 'f32'
  else if IsRealType(ty) then GlobalBaseType := 'f64'
  else if IsPtrSized(ty) and (CurTarget.PtrBytes = 8) then GlobalBaseType := 'i64'
  else GlobalBaseType := 'i32';
end;

function ConstGlobalName(s: LongInt): string;
{ The module-local read-only global that holds a named scalar const's value. A link-time const
  already has its exported global (LowerLinkConsts); a plain const gets a private `_const<n>`
  rodata global created once, on first value read. The backend folds a load of it back to an
  immediate and drops the global if nothing else references it, so this costs no image space
  unless the const's address is actually taken. }
var
  nm: string;
begin
  if Syms[s].LinkConst then begin
    ConstGlobalName := LinkNameOf(s);
    Exit;
  end;
  if Syms[s].ConstGName <> '' then begin
    ConstGlobalName := Syms[s].ConstGName;
    Exit;
  end;
  nm := '_const' + IntToStr(IrGlobalCount);
  AddIrGlobal(nm, GlobalBaseType(Syms[s].TypeId));
  IrGlobals[IrGlobalCount - 1].HasInit := True;
  IrGlobals[IrGlobalCount - 1].InitBits := Syms[s].Ordinal;
  IrGlobals[IrGlobalCount - 1].ReadOnly := True;
  Syms[s].ConstGName := nm;
  ConstGlobalName := nm;
end;

procedure ResetLoweringTables;
{ Clear the IR module tables and the capture-analysis arrays for a fresh lowering. }
var
  i: LongInt;
begin
  IrFuncCount := 0; SetLength(IrFuncs, 0);
  IrGlobalCount := 0; SetLength(IrGlobals, 0);
  IrImportCount := 0; SetLength(IrImports, 0);
  IrExportCount := 0; SetLength(IrExports, 0);
  StartQueueCount := 0; SetLength(StartQueueName, 0); SetLength(StartQueueBody, 0);
  StartEntrySeq := 0;
  CoThunkCount := 0; SetLength(CoThunkName, 0); SetLength(CoThunkWorker, 0);
  LoopSP := 0;
  LabelBase := 0; LabelCount := 0;   { the per-routine label table (threaded dispatch) }
  PendingMapInsert := -1;
  SetLength(RoutineCaptures, SymCount);
  SetLength(CallsOf, SymCount);
  SetLength(CapSlot, SymCount);
  SetLength(CanYield, SymCount);
  for i := 0 to SymCount - 1 do begin
    SetLength(RoutineCaptures[i], 0);
    SetLength(CallsOf[i], 0);
    CapSlot[i] := -1;
    CanYield[i] := False;
  end;
end;

procedure LowerGlobalVars(listNode: LongInt; exported: Boolean);
{ Each var declaration in listNode becomes an IR global: an aggregate as a word blob,
  a scalar under its base type. Shared by a program's block and a unit's interface and
  implementation parts. When `exported` (a unit's interface vars), each global is marked
  visible to other modules so a consumer's cross-unit reference resolves at link. }
var
  i, j, dcl, sym: LongInt;
begin
  for i := 0 to High(Nodes[listNode].Kids) do begin
    dcl := Nodes[listNode].Kids[i];
    if Nodes[dcl].Kind = nkVarDecl then
      for j := 0 to High(Nodes[dcl].Kids) do begin
        sym := Nodes[Nodes[dcl].Kids[j]].Sym;
        if sym >= 0 then begin
          if IsAggregate(Syms[sym].TypeId) then
            AddIrGlobalArr(Syms[sym].Name, 'i32', TypeSize(Syms[sym].TypeId) div 4)
          else
            AddIrGlobal(Syms[sym].Name, GlobalBaseType(Syms[sym].TypeId));
          IrGlobals[IrGlobalCount - 1].Exported := exported;
        end;
      end;
  end;
end;

procedure LowerLinkConsts(intfNode: LongInt);
{ Each link-time constant (a value-less interface const, valued in the implementation) becomes
  an exported read-only global holding its value, resolved cross-unit through the exported-global
  table (doc/languages/kobold/kp-units.md). A consumer references it by name (LEA + load); the defining unit
  inlines its own known value. The value is not in the interface, so it is out of the
  fingerprint and changing it needs only a relink. }
var
  i, dcl, sym: LongInt;
begin
  for i := 0 to High(Nodes[intfNode].Kids) do begin
    dcl := Nodes[intfNode].Kids[i];
    if (Nodes[dcl].Kind = nkConstDecl) and (Nodes[dcl].Sym >= 0) and
       Syms[Nodes[dcl].Sym].LinkConst then begin
      sym := Nodes[dcl].Sym;
      if Syms[sym].ConstIsStr then
        { a string link const: an exported static string object named after the const, so a
          consumer references it by address (its address is the value) }
        AddIrStaticStringImage(Syms[sym].Name, Syms[sym].ConstStr, True)
      else begin
        AddIrGlobal(Syms[sym].Name, GlobalBaseType(Syms[sym].TypeId));
        IrGlobals[IrGlobalCount - 1].Exported := True;
        IrGlobals[IrGlobalCount - 1].HasInit := True;
        IrGlobals[IrGlobalCount - 1].InitBits := Syms[sym].Ordinal;
        IrGlobals[IrGlobalCount - 1].ReadOnly := True;   { a const is read-only }
      end;
    end;
  end;
end;

procedure LowerProgram(prog: LongInt);
var
  block, comp, initFlag, initDone, errBefore: LongInt;
begin
  errBefore := ErrCount;
  ResetLoweringTables;
  block := Nodes[prog].A;
  ComputeCaptures(block);
  { reject a suspend point nested in an expression before emitting any IR }
  CheckSuspendBlock(block);
  if ErrCount <> errBefore then Exit;
  { program-level variables become IR globals (a program exports none) }
  LowerGlobalVars(block, False);
  { const-array globals are set up once, in __init, so any entry point (main, or an
    exported routine an embedding host calls instead of main) can run it before it reads
    them. A program with no such globals keeps its previous shape exactly. __init is
    emitted first so the const-array globals exist and each array's ConstAggName is set
    before any reference to them, in main or a routine, is lowered. }
  NeedGlobalInit := (StrConstArrayCount > 0) or (RecConstArrayCount > 0);
  if NeedGlobalInit then begin
    AddIrGlobal('__initdone', 'i32');   { 0 until __init has run once }
    CurFn := AddIrFunc('__init', True);
    CurResultSlot := -1;
    CurCancelLabel := -1;
    CurExitLabel := -1;
    CurExitFunc := -1;
    { run at most once: main and any export call __init on entry, so a program whose
      main calls one of its own exports would otherwise set the const arrays up twice,
      leaking the first set. Guard on the __initdone flag, set it, then initialize. }
    initFlag := EmitLEA('__initdone');
    initDone := NewLabel;
    EmitBNZ(EmitLW(initFlag), initDone);
    EmitSW(initFlag, EmitLIC(1));
    EmitStrConstArrayInits;
    EmitRecConstArrayInits;
    EmitLabel(initDone);
    EmitRet;
  end;
  { the program body is `main` }
  AddIrExport('main');
  CurFn := AddIrFunc('main', False);
  CurResultSlot := -1;
  CurCancelLabel := -1;   { the main program body cannot yield, so it never unwinds }
  CurExitLabel := -1;     { `Exit` in the program body jumps to the final return }
  CurExitFunc := -1;
  if NeedGlobalInit then PushInsn('CALL', 'sym=__init nargs=0')
  else begin
    EmitStrConstArrayInits;
    EmitRecConstArrayInits;
  end;
  comp := BodyCompound(block);
  LowerStmt(comp);
  if CurExitLabel >= 0 then EmitLabel(CurExitLabel);
  EmitRet;
  CurExitLabel := -1;
  { external imports and internal routines }
  GatherAndLower(block);
  { synthesized entries for start begin..end blocks, lowered last }
  LowerPendingStartEntries;
  LowerCoThunks;
end;

procedure LowerUnit(u: LongInt);
{ Lower a self-contained unit (no `uses`) to an object module: interface and
  implementation globals, the const-array __init, then the routine bodies. A routine
  whose heading appears in the interface is exported so a consumer can link to it; the
  implementation body node was pointed at that heading's symbol by CompleteForward, so
  marking its body node Exported before GatherAndLower makes it emit under its plain
  name. There is no `main`. }
var
  intf, impl, i, h, s, bn, initFlag, initDone, errBefore: LongInt;
begin
  errBefore := ErrCount;
  ResetLoweringTables;
  intf := Nodes[u].B;
  impl := Nodes[u].C;
  ComputeCaptures(impl);
  CheckSuspendBlock(impl);
  if ErrCount <> errBefore then Exit;
  { both parts contribute unit-level globals; interface vars are exported so a consumer
    can reach them at link, implementation vars stay module-private }
  LowerGlobalVars(intf, True);
  LowerGlobalVars(impl, False);
  LowerLinkConsts(intf);
  NeedGlobalInit := (StrConstArrayCount > 0) or (RecConstArrayCount > 0);
  if NeedGlobalInit then begin
    AddIrGlobal('__initdone', 'i32');
    CurFn := AddIrFunc('__init', True);
    CurResultSlot := -1;
    CurCancelLabel := -1;
    CurExitLabel := -1;
    CurExitFunc := -1;
    initFlag := EmitLEA('__initdone');
    initDone := NewLabel;
    EmitBNZ(EmitLW(initFlag), initDone);
    EmitSW(initFlag, EmitLIC(1));
    EmitStrConstArrayInits;
    EmitRecConstArrayInits;
    EmitLabel(initDone);
    EmitRet;
  end;
  { export each interface routine: its implementation body node carries the shared
    symbol, so mark that node before it is lowered }
  for i := 0 to High(Nodes[intf].Kids) do begin
    h := Nodes[intf].Kids[i];
    if Nodes[h].Kind in [nkProcDecl, nkFuncDecl] then begin
      s := Nodes[h].Sym;
      if s >= 0 then begin
        bn := Syms[s].Node;
        if (bn >= 0) and (bn <> h) then Nodes[bn].Exported := 1;
      end;
    end;
  end;
  GatherAndLower(impl);
  LowerPendingStartEntries;
  LowerCoThunks;
end;

{ ---- KPM1 writer ---- }

procedure EmitLine(const s: string);
{ Append one line of module text to the in-memory buffer. The buffer holds the whole
  module so the core is a pure source-to-module routine: the driver decides where the
  bytes go (stdout here, an in-memory string for an embedding host). }
begin
  if ModLineCount >= Length(ModLines) then begin
    if Length(ModLines) = 0 then SetLength(ModLines, 256)
    else SetLength(ModLines, Length(ModLines) * 2);
  end;
  ModLines[ModLineCount] := s;
  Inc(ModLineCount);
end;

procedure WriteInsns(fi: LongInt);
var
  i: LongInt;
begin
  for i := 0 to IrFuncs[fi].NInsns - 1 do
    if IrFuncs[fi].Insns[i].Args = '' then
      EmitLine('    ' + IrFuncs[fi].Insns[i].Op)
    else
      EmitLine('    ' + PadOp(IrFuncs[fi].Insns[i].Op) + '  ' +
        IrFuncs[fi].Insns[i].Args);
end;

procedure WriteFunc(fi: LongInt);
var
  i, ns: LongInt;
  hdr, line: string;
  anyFW: Boolean;
begin
  ns := Length(IrFuncs[fi].SlotSize);
  hdr := '.func ' + IrFuncs[fi].Name;
  if IrFuncs[fi].IsLocal then hdr := hdr + ' local';
  hdr := hdr + ' params ' + IntToStr(IrFuncs[fi].Nparams) +
    ' slots ' + IntToStr(ns) +
    ' temps ' + IntToStr(IrFuncs[fi].Ntemps) +
    ' labels ' + IntToStr(IrFuncs[fi].Nlabels);
  EmitLine(hdr);
  if ns > 0 then begin
    line := '    .slotsize';
    for i := 0 to ns - 1 do line := line + ' ' + IntToStr(IrFuncs[fi].SlotSize[i]);
    EmitLine(line);
  end;
  if IrFuncs[fi].Nparams > 0 then begin
    line := '    .paramclass';
    for i := 0 to IrFuncs[fi].Nparams - 1 do
      line := line + ' ' + IntToStr(IrFuncs[fi].ParamClass[i]);
    EmitLine(line);
  end;
  if (IrFuncs[fi].Nparams > 0) and
     (Length(IrFuncs[fi].ParamFW) = IrFuncs[fi].Nparams) then begin
    anyFW := False;
    for i := 0 to IrFuncs[fi].Nparams - 1 do
      if IrFuncs[fi].ParamFW[i] <> 0 then anyFW := True;
    if anyFW then begin
      line := '    .paramfw';
      for i := 0 to IrFuncs[fi].Nparams - 1 do
        line := line + ' ' + IntToStr(IrFuncs[fi].ParamFW[i]);
      EmitLine(line);
    end;
  end;
  WriteInsns(fi);
  EmitLine('.endfunc');
end;

function StrHash32(const s: string): Int64;
{ A 32-bit multiply-add rolling hash over the bytes of s. The interface fingerprint is
  this hash of the rendered interface entries, so a consumer built against an older
  interface can be told at link time that the object it links no longer matches. The
  masking keeps every intermediate within 32 bits, so the same value is produced on any
  host. FNV-1a would need xor, which the dialect does not have. }
var
  i: LongInt;
  h, c: Int64;
begin
  h := 2166136261;
  for i := 1 to Length(s) do begin
    c := Ord(s[i]);
    h := ((h * 16777619) + c) and $FFFFFFFF;
  end;
  StrHash32 := h;
end;

function ProcSigRef(sig: LongInt): string;
{ The `( <mode> <type>... ) -> <type>` tail shared by a routine, a method, and a handle
  type's method entry. }
var
  p, np: LongInt;
  line: string;
begin
  line := '(';
  np := Length(SemTypes[sig].ParamTypes);
  for p := 0 to np - 1 do
    line := line + ' ' + ModeTok(SemTypes[sig].ParamModes[p]) +
      ' ' + TypeRef(SemTypes[sig].ParamTypes[p]);
  line := line + ' ) -> ' + TypeRef(SemTypes[sig].RetType);
  if SemTypes[sig].Failable then line := line + ' fails';
  ProcSigRef := line;
end;

function InterfaceEntryFromSym(s: LongInt; sharedFlag: Boolean): string;
{ Render one interface entry from a symbol: an enum, record, or handle type with its members,
  a const with its value, a var with its type (and `shared`), or a routine signature with
  parameter modes. Returns '' for a symbol with no interface form yet (a string const).
  Shared by the native declarations and the re-exported names. }
var
  ety, m: LongInt;
  line: string;
begin
  InterfaceEntryFromSym := '';
  case Syms[s].Kind of
    syType: begin
      ety := Syms[s].TypeId;
      if (ety >= 0) and (ety < SemCount) and (SemTypes[ety].Kind = skEnum) then begin
        line := '    .type ' + Syms[s].Name + ' enum';
        for m := 0 to High(SemTypes[ety].Names) do
          line := line + ' ' + SemTypes[ety].Names[m];
        InterfaceEntryFromSym := line;
      end
      else if (ety >= 0) and (ety < SemCount) and SemTypes[ety].Opaque then
        { an opaque record: the consumer gets the size and alignment, never the fields }
        InterfaceEntryFromSym := '    .type ' + Syms[s].Name + ' opaque ' +
          IntToStr(TypeSize(ety)) + ' ' + IntToStr(TypeAlign(ety))
      else if (ety >= 0) and (ety < SemCount) and (SemTypes[ety].Kind = skRecord) then begin
        { a transparent record: the consumer gets the size, alignment, and every field's
          name, type, and byte offset, so it accesses fields and copies the value with the
          same layout the defining unit uses }
        line := '    .type ' + Syms[s].Name + ' record ' +
          IntToStr(TypeSize(ety)) + ' ' + IntToStr(TypeAlign(ety)) + ' (';
        for m := 0 to High(SemTypes[ety].Names) do
          line := line + ' ' + SemTypes[ety].Names[m] + ' ' +
            TypeRef(SemTypes[ety].Subs[m]) + ' ' + IntToStr(SemTypes[ety].MemberOff[m]);
        InterfaceEntryFromSym := line + ' )';
      end
      else if (ety >= 0) and (ety < SemCount) and (SemTypes[ety].Kind = skInterface) then begin
        { a host handle type: the consumer gets each method's name and signature, enough to
          emit the .import type vtable and dispatch a call to the right slot. The host still
          provides the implementation; the interface only carries the type's shape }
        line := '    .type ' + Syms[s].Name + ' handle (';
        for m := 0 to High(SemTypes[ety].Names) do
          line := line + ' ' + SemTypes[ety].Names[m] + ' ' + ProcSigRef(SemTypes[ety].Subs[m]);
        InterfaceEntryFromSym := line + ' )';
      end;
    end;
    syConst:
      if Syms[s].LinkConst then
        { a link-time const carries no value in the interface, so changing its value forces a
          relink, not a consumer recompile (the value is in the module's .linkconst directive) }
        InterfaceEntryFromSym := '    .const ' + Syms[s].Name + ' ' + TypeRef(Syms[s].TypeId)
      else if not Syms[s].ConstIsStr then
        InterfaceEntryFromSym := '    .const ' + Syms[s].Name + ' ' +
          TypeRef(Syms[s].TypeId) + ' ' + IntToStr(Syms[s].Ordinal);
    syVar: begin
      line := '    .var ' + Syms[s].Name + ' ' + TypeRef(Syms[s].TypeId);
      if sharedFlag then line := line + ' shared';
      InterfaceEntryFromSym := line;
    end;
    syProc, syFunc:
      InterfaceEntryFromSym := '    .routine ' + Syms[s].Name + ' ' +
        ProcSigRef(Syms[s].TypeId);
  end;
end;

function ReceiverRef(recvTy: LongInt): string;
{ How a method entry names its receiver type. A type this unit defines is named plainly; a
  type imported from a dependency is qualified by that unit (`a.Point`), so a downstream
  consumer resolves it to the same type through the closure and can dispatch the method on
  its own values of that type. }
begin
  if (recvTy >= 0) and (recvTy < SemCount) and (SemTypes[recvTy].FromUnit <> '') then
    ReceiverRef := SemTypes[recvTy].FromUnit + '.' + SemTypes[recvTy].Name
  else
    ReceiverRef := TypeRef(recvTy);
end;

function MethodEntry(node: LongInt): string;
{ Render an exported method heading: its receiver type, name, parameter modes and types,
  and result type. The receiver is not counted among the parameters. }
begin
  MethodEntry := '    .method ' + ReceiverRef(Nodes[Nodes[node].A].Ty) + ' ' +
    Syms[Nodes[node].Sym].Name + ' ' + ProcSigRef(Syms[Nodes[node].Sym].TypeId);
end;

procedure EmitInterfaceSection;
{ Emit the `.interface` section of an object module: the exported types, consts, vars, and
  routine signatures a consumer compiles against, plus the names re-exported from a
  dependency, prefixed by a fingerprint over the section text. Type entries come first so a
  routine or const that references an exported type resolves when the consumer reads it in
  order. }
var
  intf, i, s, vk, pass: LongInt;
  ent: array of string;
  ne: LongInt;
  line, blob: string;
  wantType: Boolean;
begin
  intf := Nodes[ModUnitNode].B;
  ne := 0; SetLength(ent, 0);
  { pass 0 emits type entries, pass 1 the rest, so a forward type reference is defined
    before it is used when the consumer reads the section top to bottom }
  for pass := 0 to 1 do begin
    wantType := pass = 0;
    for i := 0 to High(Nodes[intf].Kids) do begin
      s := Nodes[intf].Kids[i];
      if (Nodes[s].Kind = nkTypeDecl) = wantType then
        case Nodes[s].Kind of
          nkTypeDecl, nkConstDecl:
            if Nodes[s].Sym >= 0 then begin
              line := InterfaceEntryFromSym(Nodes[s].Sym, False);
              if line <> '' then begin SetLength(ent, ne + 1); ent[ne] := line; Inc(ne); end;
            end;
          nkProcDecl, nkFuncDecl:
            if Nodes[s].Sym >= 0 then begin
              if Nodes[s].A >= 0 then line := MethodEntry(s)
              else line := InterfaceEntryFromSym(Nodes[s].Sym, False);
              if line <> '' then begin SetLength(ent, ne + 1); ent[ne] := line; Inc(ne); end;
            end;
          nkVarDecl:
            for vk := 0 to High(Nodes[s].Kids) do
              if Nodes[Nodes[s].Kids[vk]].Sym >= 0 then begin
                line := InterfaceEntryFromSym(Nodes[Nodes[s].Kids[vk]].Sym, Nodes[s].Flag = 1);
                if line <> '' then begin SetLength(ent, ne + 1); ent[ne] := line; Inc(ne); end;
              end;
        end;
    end;
    { names promoted from a dependency into this unit's surface }
    for i := 0 to ReexportCount - 1 do
      if (Syms[ReexportSym[i]].Kind = syType) = wantType then begin
        line := InterfaceEntryFromSym(ReexportSym[i], False);
        if line <> '' then begin SetLength(ent, ne + 1); ent[ne] := line; Inc(ne); end;
      end;
  end;
  blob := '';
  for i := 0 to ne - 1 do blob := blob + ent[i] + #10;
  EmitLine('');
  EmitLine('.interface fingerprint ' + IntToStr(StrHash32(blob)));
  for i := 0 to ne - 1 do EmitLine(ent[i]);
  EmitLine('.endinterface');
end;

procedure BuildModuleLines;
{ Render the lowered IR into the in-memory line buffer. It writes no output itself, so a
  caller can send the module to stdout, to a file, or take it as a string in memory. }
var
  i, j, k: LongInt;
  line: string;
begin
  ModLineCount := 0;
  EmitLine('.kpm 1');
  { The target tag, authoritative (not a hint). A unit is bound to one target:
    its opcodes bake in the guest pointer width, and it carries native-code and
    ABI assumptions beyond that, so the reader rejects a module built for another
    target. A binary built for a specific architecture stamps it ('rv32', 'cf',
    'x86-64', 'arm64'); otherwise the module carries only the pointer-width class
    (ilp32 for rv32/cf/mips, lp64 for x86-64/arm64), the legacy width-only tag. }
  if CurTarget.Arch <> '' then
    EmitLine('.target ' + CurTarget.Arch)
  else if CurTarget.PtrBytes = 8 then
    EmitLine('.target lp64')
  else
    EmitLine('.target ilp32');
  { A compiled program is a linked executable image whose entry is `main`; a unit is an
    object module a consumer links against, with no entry. }
  if ModIsUnit then
    EmitLine('.module object ' + CompilingUnitName)
  else begin
    EmitLine('.module executable');
    EmitLine('.entry main');
  end;
  { the direct dependencies and the interface fingerprint each was compiled against, so a
    link can traverse the graph and reject a stale interface (doc/languages/kobold/kp-units.md) }
  for i := 0 to DepCount - 1 do
    EmitLine('.uses ' + DepName[i] + ' fingerprint ' + IntToStr(DepFingerprint[i]));
  if OptDebug then
    EmitLine('.file "' + SrcName + '"');
  if IrImportCount > 0 then begin
    EmitLine('');
    for i := 0 to IrImportCount - 1 do begin
      if IrImports[i].IsType then begin
        EmitLine('.import type ' + IrImports[i].Name + ' methods ' +
          IntToStr(Length(IrImports[i].Methods)));
        for j := 0 to High(IrImports[i].Methods) do begin
          line := '    .method ' + IntToStr(j) + ' ' +
            IrImports[i].Methods[j].MName + ' (';
          for k := 0 to High(IrImports[i].Methods[j].ParamCls) do
            line := line + ' ' + IrImports[i].Methods[j].ParamCls[k];
          line := line + ' ) -> ' + IrImports[i].Methods[j].RetCls;
          EmitLine(line);
        end;
      end
      else begin
        if IrImports[i].IsHelper then line := '.import helper ' + IrImports[i].Name + ' ('
        else line := '.import func ' + IrImports[i].Name + ' (';
        for j := 0 to High(IrImports[i].ParamCls) do
          line := line + ' ' + IrImports[i].ParamCls[j];
        line := line + ' ) -> ' + IrImports[i].RetCls;
        EmitLine(line);
      end;
    end;
  end;
  if IrExportCount > 0 then begin
    EmitLine('');
    for i := 0 to IrExportCount - 1 do EmitLine('.export ' + IrExports[i]);
  end;
  if IrGlobalCount > 0 then begin
    EmitLine('');
    for i := 0 to IrGlobalCount - 1 do begin
      line := '.global ' + IrGlobals[i].Name + ' ' + IrGlobals[i].BaseType;
      if IrGlobals[i].ArrSize > 0 then
        line := line + ' array ' + IntToStr(IrGlobals[i].ArrSize);
      if IrGlobals[i].Exported then line := line + ' export'
      else line := line + ' local';   { module-private: local linkage so two modules'
                                         auto-named globals (_const<n>, _str<n>) do not
                                         collide at link }
      if IrGlobals[i].ReadOnly then line := line + ' rodata';
      if IrGlobals[i].IsStrObj then line := line + ' strobj';
      EmitLine(line);
      if IrGlobals[i].HasInit then
        EmitLine('    .init ' + IntToStr(IrGlobals[i].InitBits));
      for j := 0 to High(IrGlobals[i].InitVals) do
        EmitLine('    .init ' + IntToStr(IrGlobals[i].InitVals[j]));
      if IrGlobals[i].HasStr then
        EmitLine('    .string ' + EscapeStr(IrGlobals[i].InitStr));
      EmitLine('.endglobal');
    end;
  end;
  if ModIsUnit then EmitInterfaceSection;
  for i := 0 to IrFuncCount - 1 do begin
    EmitLine('');
    WriteFunc(i);
  end;
end;

function JoinModuleLines(lo, hi: LongInt): string;
{ Concatenate lines [lo, hi], each with its trailing newline, by a balanced split so the
  total copying is O(n log k) rather than the O(n^2) of a left-to-right append. }
var
  mid: LongInt;
begin
  if lo = hi then
    JoinModuleLines := ModLines[lo] + #10
  else begin
    mid := (lo + hi) div 2;
    JoinModuleLines := JoinModuleLines(lo, mid) + JoinModuleLines(mid + 1, hi);
  end;
end;

function AssembleModuleText: string;
{ The whole module as one string, newline-terminated per line. Empty when there are no
  lines (nothing was built). }
begin
  if ModLineCount = 0 then AssembleModuleText := ''
  else AssembleModuleText := JoinModuleLines(0, ModLineCount - 1);
end;

{ ---- Driver ---- }

function StartBlockCaptures(node: LongInt): Boolean;
{ True when a start begin..end block references an enclosing local (a non-global
  variable or a parameter). Such a capture would escape with the coroutine, which
  the no-closure rule forbids, so data must reach the coroutine through a started
  routine's by-value arguments instead. }
var
  i, s: LongInt;
begin
  StartBlockCaptures := False;
  if node < 0 then Exit;
  if Nodes[node].Kind = nkIdent then begin
    s := Nodes[node].Sym;
    if (s >= 0) and (Syms[s].Kind in [syVar, syParam]) and not IsGlobalVar(s) then
      Exit(True);
  end;
  if StartBlockCaptures(Nodes[node].A) then Exit(True);
  if StartBlockCaptures(Nodes[node].B) then Exit(True);
  if StartBlockCaptures(Nodes[node].C) then Exit(True);
  if StartBlockCaptures(Nodes[node].D) then Exit(True);
  for i := 0 to High(Nodes[node].Kids) do
    if StartBlockCaptures(Nodes[node].Kids[i]) then Exit(True);
end;

function FirstUnlowerable(node: LongInt; var why: string): LongInt;
{ The first node the IR lowering cannot yet emit valid code for, or -1. Guards
  `--emit-kpm` so an unsupported construct is rejected with a diagnostic instead of
  emitting wrong or malformed IR. Covers a start begin..end block that captures an
  enclosing local (forbidden by the no-closure rule) and a method call on an
  anonymous interface type (which has no name to form the `<Type>.<method>`
  symbol). }
var
  i, r, bt: LongInt;
begin
  FirstUnlowerable := -1;
  if node < 0 then Exit;
  if Nodes[node].Kind = nkStart then
    if (Nodes[node].Flag = 1) and StartBlockCaptures(Nodes[node].A) then begin
      why := 'a start begin..end block may not use an enclosing local; pass data ' +
        'as arguments to a started routine instead';
      Exit(node);
    end;
  if (Nodes[node].Kind = nkField) and IsMethodField(node) then begin
    bt := Nodes[Nodes[node].A].Ty;
    if (bt >= 0) and (bt < SemCount) and (SemTypes[bt].Kind = skInterface) and
       (SemTypes[bt].Name = '') then begin
      why := 'a method call requires a named interface type';
      Exit(node);
    end;
  end;
  r := FirstUnlowerable(Nodes[node].A, why); if r >= 0 then Exit(r);
  r := FirstUnlowerable(Nodes[node].B, why); if r >= 0 then Exit(r);
  r := FirstUnlowerable(Nodes[node].C, why); if r >= 0 then Exit(r);
  r := FirstUnlowerable(Nodes[node].D, why); if r >= 0 then Exit(r);
  for i := 0 to High(Nodes[node].Kids) do begin
    r := FirstUnlowerable(Nodes[node].Kids[i], why); if r >= 0 then Exit(r);
  end;
end;

procedure Usage;
begin
  WriteLn('usage: kpcom [-o outfile] [-U dir] [-g] [-v] [-d] [--dump-ast] [-h] file...');
  WriteLn;
  WriteLn('  -o outfile         write the emitted KPM1 module here (default stdout)');
  WriteLn('  -U dir             a directory to search for a used unit''s .kpm');
  WriteLn('  -g, --debug        emit source-line debug info in the KPM module');
  WriteLn('  -v, --verbose      report progress on standard error');
  WriteLn('  -d, --dump-tokens  print the token stream and stop');
  WriteLn('  --dump-ast         parse and print the syntax tree');
  WriteLn('  --emit-kpm         parse, analyze, and write the KPM1 module');
  WriteLn('  -h, --help         show this help and exit');
  WriteLn;
  WriteLn('kobold-pascal ', KP_VERSION);
end;

function CompileSource(const srcName, srcText: string; debug: Boolean;
  var moduleText: string): Boolean;
{ The compiler core: parse, analyze, and lower srcText, returning the KPM1 module in
  moduleText. It reads no file and writes no output, so an embedding host can feed source
  in and take the module out in memory. Returns True on a clean compile; on an error it
  returns False with moduleText empty and the diagnostics already reported. }
var
  prog, parseErrs, blocker: LongInt;
  why: string;
begin
  CompileSource := False;
  moduleText := '';
  OptDebug := debug;
  ModLineCount := 0;
  UnitSrcDir := DirOf(srcName);   { a dependency .kpm is searched here first }
  InitScanner(srcName, srcText);
  if OptVerbose then
    WriteLn(ErrOutput, 'kpcom: reading ', srcName, ' (', SrcLen, ' bytes)');
  InitParser;
  NextToken;              { load the first token }
  parseErrs := ErrCount;
  prog := ParseCompilationUnit;
  if ErrCount <> parseErrs then Exit;
  ModIsUnit := Nodes[prog].Kind = nkUnit;
  ModUnitNode := -1;
  if ModIsUnit then ModUnitNode := prog;
  { only run semantic analysis on a clean parse, to avoid cascades }
  Analyze(prog);
  if ErrCount <> parseErrs then Exit;
  blocker := FirstUnlowerable(prog, why);
  if blocker >= 0 then begin
    SemErrCode(blocker, 'E0005', why);
    Exit;
  end;
  if ModIsUnit then LowerUnit(prog) else LowerProgram(prog);
  if ErrCount <> parseErrs then Exit;
  BuildModuleLines;
  moduleText := AssembleModuleText;
  CompileSource := True;
end;

procedure InitTarget;
{ Establish the active target ABI. Called at every compilation entry so CurTarget
  is authoritative before any type is sized: the native driver's main and the
  `compile` export (which never runs the program body). The width is this binary's
  compile-time native width (KpNativePtrBytes); there is no runtime choice. }
begin
  CurTarget.PtrBytes := KpNativePtrBytes;
  { The target architecture, baked at build time the way the width is. One
    compiler per target (Plan 9 style): a KP_TARGET_* define selects it, so the
    module stamps a Target-bound `.target <arch>` tag. Left empty when no define
    was given, in which case the writer falls back to the width-only tag. }
  CurTarget.Arch := '';
  {$IFDEF KP_TARGET_RV}    CurTarget.Arch := 'rv32';   {$ENDIF}
  {$IFDEF KP_TARGET_CF}    CurTarget.Arch := 'cf';     {$ENDIF}
  {$IFDEF KP_TARGET_X64}   CurTarget.Arch := 'x86-64'; {$ENDIF}
  {$IFDEF KP_TARGET_ARM64} CurTarget.Arch := 'arm64';  {$ENDIF}
end;

function compile(const srcName, srcText: string): string; export;
{ The module entry an embedding host calls across the FFI: compile srcText and
  return the KPM1 module text, or the empty string on a compile error (the
  diagnostics went to standard error). The target is this binary's native width,
  so the export sets it itself (unlike the native driver, it never runs the
  program body). This is the two-stage boot's hand-off, so the host neither writes
  a temporary file nor forks the front end. }
var
  moduleText: string;
begin
  InitTarget;
  if CompileSource(srcName, srcText, False, moduleText) then compile := moduleText
  else compile := '';
end;

procedure EmitModuleText(const moduleText: string);
{ Write the module. With -o it goes to that file; otherwise to standard output.
  The text already carries a trailing newline per line, so write it as is. }
begin
  if OptOut <> '' then begin
    if WriteFileStr(OptOut, moduleText) = 0 then begin
      WriteLn(ErrOutput, 'kpcom: cannot write ', OptOut);
      Inc(ErrCount);
    end;
  end
  else begin
    Write(Output, moduleText);
    Flush(Output);
  end;
end;

procedure ProcessFile(const path: string);
var
  text, moduleText: string;
  prog, parseErrs: LongInt;
begin
  if not ReadWholeFile(path, text) then begin
    WriteLn(ErrOutput, 'kpcom: cannot read ', path);
    Inc(ErrCount);
    Exit;
  end;
  UnitSrcDir := DirOf(path);   { a dependency .kpm is searched here first }
  if OptEmitKpm then begin
    if CompileSource(path, text, OptDebug, moduleText) then
      EmitModuleText(moduleText);
    Exit;
  end;
  InitScanner(path, text);
  if OptVerbose then
    WriteLn(ErrOutput, 'kpcom: reading ', path, ' (', SrcLen, ' bytes)');
  if OptDump then begin
    { lexer only: dump the token stream }
    repeat
      NextToken;
      DumpToken(Tok);
    until Tok.Kind = tkEOF;
    Exit;
  end;
  InitParser;
  NextToken;              { load the first token }
  parseErrs := ErrCount;
  prog := ParseCompilationUnit;
  if OptDumpAst then begin
    DumpTree(prog);
    Exit;
  end;
  if (ErrCount = parseErrs) and
     (Nodes[prog].Kind in [nkProgram, nkUnit]) then Analyze(prog);
end;

var
  i, fileCount, n: LongInt;
  arg, dir: string;

begin
  OptVerbose := False;
  OptDump := False;
  OptDumpAst := False;
  OptEmitKpm := False;
  OptDebug := False;
  OptOut := '';
  InitTarget;   { the active target ABI is this binary's compile-time native width }
  ErrCount := 0;
  fileCount := 0;
  SetLength(MainFiles, 0);
  SetLength(CmdDefines, 0);
  UnitSrcDir := '';
  CompilingUnitName := '';
  SetLength(UnitPath, 0);

  i := 1;
  while i <= ParamCount do begin
    arg := ParamStr(i);
    if (arg = '--help') or (arg = '-h') then begin
      Usage;
      Halt(0);
    end
    else if (arg = '-v') or (arg = '--verbose') then
      OptVerbose := True
    else if (arg = '-d') or (arg = '--dump-tokens') then
      OptDump := True
    else if arg = '--dump-ast' then
      OptDumpAst := True
    else if arg = '--emit-kpm' then
      OptEmitKpm := True
    else if (arg = '-g') or (arg = '--debug') then
      OptDebug := True
    else if arg = '-o' then begin
      Inc(i);
      if i > ParamCount then begin
        WriteLn(ErrOutput, 'kpcom: -o needs an argument');
        Halt(2);
      end;
      OptOut := ParamStr(i);
    end
    else if (Length(arg) >= 2) and (arg[1] = '-') and (arg[2] = 'D') then begin
      { -D<sym> or -D <sym>: define a conditional-compilation symbol, as skj-pc's
        -d does, so a seed build can select the target (-D KP_TARGET_X64) }
      if Length(arg) > 2 then dir := Copy(arg, 3, Length(arg) - 2)
      else begin
        Inc(i);
        if i > ParamCount then begin
          WriteLn(ErrOutput, 'kpcom: -D needs a symbol');
          Halt(2);
        end;
        dir := ParamStr(i);
      end;
      n := Length(CmdDefines);
      SetLength(CmdDefines, n + 1);
      CmdDefines[n] := dir;
    end
    else if (Length(arg) >= 2) and (arg[1] = '-') and (arg[2] = 'U') then begin
      { -U<dir> or -U <dir>: a directory to search for a dependency's .kpm }
      if Length(arg) > 2 then dir := Copy(arg, 3, Length(arg) - 2)
      else begin
        Inc(i);
        if i > ParamCount then begin
          WriteLn(ErrOutput, 'kpcom: -U needs a directory');
          Halt(2);
        end;
        dir := ParamStr(i);
      end;
      if (Length(dir) > 0) and (dir[Length(dir)] <> '/') then dir := dir + '/';
      n := Length(UnitPath);
      SetLength(UnitPath, n + 1);
      UnitPath[n] := dir;
    end
    else if (Length(arg) > 0) and (arg[1] = '-') and (arg <> '-') then begin
      WriteLn(ErrOutput, 'kpcom: unknown option ', arg);
      Usage;
      Halt(2);
    end
    else begin
      { collect the file; files are compiled after the whole argument scan }
      n := Length(MainFiles);
      SetLength(MainFiles, n + 1);
      MainFiles[n] := arg;
      Inc(fileCount);
    end;
    Inc(i);
  end;

  if fileCount = 0 then begin
    WriteLn(ErrOutput, 'kpcom: no input files');
    Usage;
    Halt(2);
  end;

  for i := 0 to fileCount - 1 do
    ProcessFile(MainFiles[i]);

  if ErrCount > 0 then
    Halt(1);
end.
