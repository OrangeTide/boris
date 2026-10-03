/* cc.h : skj-cc C compiler front-end declarations */

#ifndef CC_H
#define CC_H

#include "ir.h"
#include <stdio.h>

/****************************************************************
 * Target data model
 *
 * LP64 (8-byte long and pointers) is selected at compile time for the 64-bit
 * targets by defining CC_LP64; the 32-bit targets stay ILP32 (4-byte long and
 * pointers).  See doc/lp64.md.
 ****************************************************************/

#ifdef CC_LP64
#define CC_PTR_SIZE  8
#define CC_LONG_SIZE 8
#else
#define CC_PTR_SIZE  4
#define CC_LONG_SIZE 4
#endif

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
    TOK_VOID, TOK_CHAR, TOK_SHORT, TOK_INT, TOK_LONG,
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
    long ival;
    double fval;
    char *sval;
    int slen;
    int line;
    int is_float;
    int is_half;
    int is_long;    /* integer literal with an l/L suffix or too big for int */
    int is_llong;   /* integer literal with an ll/LL suffix */
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
    ND_ASM,         /* basic inline asm: verbatim text in sval/slen */

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
};

struct cc_node {
    int kind;
    int op;
    int line;
    struct cc_type *type;

    struct cc_node *a, *b, *c, *d;
    struct cc_node *next;
    struct cc_node *body;

    char *name;
    long ival;
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

/****************************************************************
 * Parser
 ****************************************************************/

struct cc_node *cc_parse_program(struct arena *a);

/****************************************************************
 * Lowering
 ****************************************************************/

struct ir_program *cc_lower_program(struct arena *a, struct cc_node *ast);

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
int cc_type_is_ptr(struct cc_type *t);
int cc_type_is_scalar(struct cc_type *t);

#endif /* CC_H */
