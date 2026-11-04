/* pascal.h : Compact Pascal front-end declarations */

#ifndef PASCAL_H
#define PASCAL_H

#include "ir.h"

/****************************************************************
 * Lexer
 ****************************************************************/

enum tok {
    T_EOF = 0,
    T_PROGRAM, T_BEGIN, T_END,
    T_VAR, T_CONST, T_TYPE,
    T_PROCEDURE, T_FUNCTION, T_FORWARD,
    T_IF, T_THEN, T_ELSE,
    T_WHILE, T_DO,
    T_FOR, T_TO, T_DOWNTO,
    T_REPEAT, T_UNTIL,
    T_CASE, T_OF,
    T_WITH,
    T_BREAK, T_CONTINUE,
    T_AND, T_OR, T_NOT, T_IN,
    T_DIV, T_MOD, T_SET, T_SIZEOF,
    T_SHL, T_SHR,
    T_TRUE, T_FALSE,
    T_INTEGER, T_BOOLEAN, T_CHAR, T_BYTE, T_WORD,
    T_IDENT, T_NUMBER, T_REAL, T_STRING,
    T_LPAREN, T_RPAREN,
    T_LBRACK, T_RBRACK,
    T_COMMA, T_SEMI, T_COLON, T_DOT,
    T_DOTDOT,
    T_ASSIGN,
    T_PLUS, T_MINUS, T_STAR, T_SLASH,
    T_EQ, T_NE, T_LT, T_LE, T_GT, T_GE,
    T_CARET,
    T_AND_THEN, T_OR_ELSE,
};

struct token {
    int kind;
    long nval;
    double fval;
    char *sval;
    char *raw;      /* identifier's original-case spelling (for external names) */
    int slen;
    int line;
};

void lex_init(struct arena *a, const char *src, const char *filename);
void lex_define(const char *name);
struct token lex_next(void);
struct token lex_peek(void);

extern int lex_align;
extern int lex_rangechecks;
extern int lex_overflowchecks;

/****************************************************************
 * AST
 ****************************************************************/

enum node_kind {
    N_PROGRAM,
    N_VARDECL, N_CONSTDECL,
    N_PROCDECL, N_FUNCDECL,
    N_PARAM,
    N_BLOCK, N_COMPOUND,
    N_IF, N_WHILE, N_FOR, N_REPEAT,
    N_BREAK, N_CONTINUE, N_CASE, N_CASEARM, N_CASELABEL, N_WITH,
    N_ASSIGN, N_CALL, N_EXPR_STMT,
    N_BINOP, N_UNOP,
    N_NAME, N_NUM, N_REAL, N_STR, N_BOOL,
    N_TYPEDEF, N_FIELDDECL,
    N_DOT, N_INDEX,
    N_INITLIST,
    N_SET, N_SETRANGE,
    N_SIZEOF,
    N_VARIANTPART,
};

struct node {
    int kind;
    int op;
    int line;

    struct node *a, *b, *c, *d;
    struct node *next;

    char *name;
    char *raw_name;     /* original-case spelling of name (for external symbols) */
    long ival;
    double fval;
    char *sval;
    int slen;

    int is_forward;
    int is_external;
    int downto;
};

struct node *parse_program(struct arena *a);

/****************************************************************
 * Lowering
 ****************************************************************/

struct ir_program *lower_program(struct arena *a, struct node *ast);

/* Debug info (-g): when pascal_debug is set, lowering emits an IR_LOC per
   statement and records pascal_src_file on each function for the line table.
   Set by the driver before lower_program. */
extern int pascal_debug;
extern const char *pascal_src_file;

#endif /* PASCAL_H */
