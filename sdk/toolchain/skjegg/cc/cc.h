/* cc.h : skj-cc C compiler front-end declarations */

#ifndef CC_H
#define CC_H

#include "ir.h"
#include "target.h"
#include <stdio.h>

/****************************************************************
 * Target data model
 *
 * LP64 (8-byte long and pointers) is selected for the 64-bit targets by the
 * shared SKJ_LP64 width axis (target.h); the 32-bit targets stay ILP32 (4-byte
 * long and pointers).  See doc/internals/lp64.md.
 ****************************************************************/

#define CC_PTR_SIZE  SKJ_PTR_BYTES
#define CC_LONG_SIZE SKJ_LONG_BYTES

/****************************************************************
 * Tokens
 ****************************************************************/

enum cc_tok {
    TOK_EOF = 0,

    /* literals */
    TOK_INTLIT, TOK_FLOATLIT, TOK_STRLIT, TOK_CHARLIT,

    /* identifier */
    TOK_IDENT,

    /* keywords — types */
    TOK_VOID, TOK_BOOL, TOK_CHAR, TOK_SHORT, TOK_INT, TOK_LONG,
    TOK_FLOAT16, TOK_FLOAT, TOK_DOUBLE, TOK_SIGNED, TOK_UNSIGNED,
    TOK_STRUCT, TOK_UNION, TOK_ENUM, TOK_TYPEDEF,
    TOK_CONST, TOK_VOLATILE, TOK_RESTRICT, TOK_INLINE,

    /* keywords — storage */
    TOK_EXTERN, TOK_STATIC, TOK_AUTO, TOK_REGISTER,

    /* keywords — control */
    TOK_IF, TOK_ELSE, TOK_WHILE, TOK_DO, TOK_FOR,
    TOK_SWITCH, TOK_CASE, TOK_DEFAULT,
    TOK_BREAK, TOK_CONTINUE, TOK_RETURN, TOK_GOTO,

    /* keywords — misc */
    TOK_SIZEOF,
    TOK_ALIGNOF,
    TOK_ALIGNAS,
    TOK_STATIC_ASSERT,
    TOK_GENERIC,
    TOK_ASM,

    /* punctuation */
    TOK_LPAREN, TOK_RPAREN,
    TOK_LBRACE, TOK_RBRACE,
    TOK_LBRACK, TOK_RBRACK,
    TOK_SEMI, TOK_COMMA, TOK_DOT, TOK_ARROW,
    TOK_ELLIPSIS,

    /* operators */
    TOK_ASSIGN,
    TOK_PLUS_EQ, TOK_MINUS_EQ, TOK_STAR_EQ, TOK_SLASH_EQ,
    TOK_PERCENT_EQ, TOK_AMP_EQ, TOK_PIPE_EQ, TOK_CARET_EQ,
    TOK_SHL_EQ, TOK_SHR_EQ,
    TOK_PLUS, TOK_MINUS, TOK_STAR, TOK_SLASH, TOK_PERCENT,
    TOK_AMP, TOK_PIPE, TOK_CARET, TOK_TILDE, TOK_BANG,
    TOK_ANDAND, TOK_OROR,
    TOK_EQ, TOK_NE, TOK_LT, TOK_LE, TOK_GT, TOK_GE,
    TOK_SHL, TOK_SHR,
    TOK_INC, TOK_DEC,
    TOK_QUESTION, TOK_COLON,
};

struct cc_token {
    int kind;
    long long ival;     /* 64-bit: a host where long is 32-bit (the rv32-hosted
                           JIT) must still carry a long long literal intact */
    double fval;
    char *sval;
    int slen;
    int line;
    int col;
    int is_float;
    int is_half;
    int is_long;    /* integer literal with an l/L suffix or too big for int */
    int is_llong;   /* integer literal with an ll/LL suffix */
    int is_unsigned;/* integer literal that resolves to an unsigned type */
};

/****************************************************************
 * Type system
 ****************************************************************/

enum cc_type_kind {
    TY_VOID,
    TY_CHAR,
    TY_SHORT,
    TY_INT,
    TY_LONG,
    TY_LONG_LONG,
    TY_FLOAT16,
    TY_FLOAT,
    TY_DOUBLE,
    TY_LDOUBLE,         /* long double: a distinct type, but unsupported for
                           codegen (rejected at any ABI crossing / use) */
    TY_PTR,
    TY_ARRAY,
    TY_FUNC,
    TY_STRUCT,
    TY_UNION,
    TY_ENUM,
};

struct cc_type {
    int kind;
    int is_unsigned;
    int is_const;
    int is_bool;                /* _Bool: a 1-byte unsigned integer (kind
                                   TY_CHAR) that holds only 0 or 1; a conversion
                                   to it normalizes any nonzero value to 1 */

    struct cc_type *base;       /* PTR target, ARRAY element, FUNC return */

    int array_len;              /* ARRAY: element count, -1 if [] */

    /* FUNC */
    struct cc_param *params;
    int is_variadic;

    /* STRUCT/UNION */
    struct cc_field *fields;
    char *tag;
    int size;
    int align;

    struct cc_type *next;       /* for linked lists */
};

struct cc_param {
    char *name;
    struct cc_type *type;
    struct cc_param *next;
};

struct cc_field {
    char *name;
    struct cc_type *type;
    int offset;
    int bits;        /* bit-field width, 0 = ordinary field */
    int bit_off;     /* bit position within the storage unit at `offset` */
    struct cc_field *next;
};

/****************************************************************
 * AST
 ****************************************************************/

enum cc_node_kind {
    /* top level */
    ND_PROGRAM,
    ND_FUNC_DEF,
    ND_GLOBAL_DECL,

    /* statements */
    ND_BLOCK,
    ND_IF,
    ND_WHILE,
    ND_DO_WHILE,
    ND_FOR,
    ND_SWITCH,
    ND_CASE,
    ND_DEFAULT,
    ND_BREAK,
    ND_CONTINUE,
    ND_RETURN,
    ND_GOTO,
    ND_LABEL,
    ND_EXPR_STMT,
    ND_LOCAL_DECL,
    ND_ASM,         /* inline asm: template in sval/slen. Basic if a/b/c all
                       null; extended carries output(a)/input(b)/clobber(c)
                       operand lists (chained via ->next) and ival=is_volatile */
    ND_ASM_OP,      /* one extended-asm operand: sval/slen=constraint, a=expr;
                       or one clobber: sval/slen=clobber name, a=null */

    /* expressions */
    ND_BINOP,
    ND_UNOP,
    ND_ASSIGN,
    ND_COMPOUND_ASSIGN,
    ND_TERNARY,
    ND_COMMA,
    ND_CALL,
    ND_CAST,
    ND_SIZEOF,
    ND_INDEX,
    ND_MEMBER,
    ND_DEREF,
    ND_ADDR,
    ND_LABELADDR,   /* GNU labels as values: &&label; name = the label, type void* */
    ND_POST_INC,
    ND_POST_DEC,
    ND_PRE_INC,
    ND_PRE_DEC,

    /* leaf */
    ND_VAR,
    ND_INTLIT,
    ND_FLOATLIT,
    ND_STRLIT,
    ND_INIT_LIST,
    ND_DESIG,       /* designated init element: name (.field) or ival ([index]), a = value */
    ND_COMPOUND_LIT,/* compound literal (type){init}: decl_type is the type, a is the init list */
    ND_GENERIC,     /* _Generic(a, assoc-list in b): each assoc is a node whose
                       decl_type is the type-name (NULL = default) and a is the
                       result expression, chained by next; selected at lowering */
};

struct cc_node {
    int kind;
    int op;
    int line;
    int col;                /* 1-based source column, for -g debug info (0 = none) */
    const char *file;       /* defining source file (set on a function-def node) */
    struct cc_type *type;

    struct cc_node *a, *b, *c, *d;
    struct cc_node *next;
    struct cc_node *body;

    char *name;
    long long ival;     /* 64-bit; see the note on cc_token.ival */
    double fval;
    char *sval;
    int slen;

    /* for declarations */
    struct cc_type *decl_type;
    int is_static;
    int is_extern;
    int is_inline;
    int align;          /* _Alignas requested alignment (0 = default) */
};

/****************************************************************
 * Lexer
 ****************************************************************/

void cc_lex_init(struct arena *a, const char *src, const char *filename);
struct cc_token cc_lex_next(void);
struct cc_token cc_lex_peek(void);
int cc_lex_line(void);
int cc_lex_col(void);
const char *cc_lex_file(void);
const char *cc_tok_name(int kind);
void cc_lex_print_context(int n, int before);

/****************************************************************
 * Parser
 ****************************************************************/

struct cc_node *cc_parse_program(struct arena *a);

/* Fold an integer constant expression (dies if not constant). */
long long cc_const_eval(struct cc_node *n);

/* Typing hook for sizeof/_Alignof of an expression operand in a constant
   expression.  The parser does not type expressions, so const_eval cannot size
   `sizeof expr` on its own.  Lowering (where symbol types are known) points
   this at its type resolver for the duration of the lowering pass; it stays
   NULL at parse time, so parse-time const_eval keeps its prior behavior. */
extern struct cc_type *(*cc_const_sizeof_typer)(struct cc_node *n);

/****************************************************************
 * Lowering
 ****************************************************************/

struct ir_program *cc_lower_program(struct arena *a, struct cc_node *ast);

/* Debug info (-g): when cc_debug is set, lowering emits an IR_LOC per statement
   and records cc_src_file on each function for the line table.  Set by the
   driver before cc_lower_program. */
extern int cc_debug;
extern const char *cc_src_file;

/****************************************************************
 * Type helpers
 ****************************************************************/

struct cc_type *cc_type_int(void);
struct cc_type *cc_type_long(void);
struct cc_type *cc_type_long_long(void);
struct cc_type *cc_type_char(void);
struct cc_type *cc_type_void(void);
struct cc_type *cc_type_ptr(struct arena *a, struct cc_type *base);
struct cc_type *cc_type_array(struct arena *a, struct cc_type *base, int len);
struct cc_type *cc_type_func(struct arena *a, struct cc_type *ret);
int cc_type_size(struct cc_type *t);
int cc_type_align(struct cc_type *t);
int cc_type_is_integer(struct cc_type *t);
int cc_type_is_arith(struct cc_type *t);
struct cc_type *cc_type_promote(struct cc_type *t);
struct cc_type *cc_type_usual_arith(struct cc_type *a, struct cc_type *b);
int cc_type_is_ptr(struct cc_type *t);
int cc_type_is_scalar(struct cc_type *t);

#endif /* CC_H */
