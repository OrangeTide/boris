/* jsh.c - Jon's Shell */
/* Copyright (c) 2026 Jon Mayo - MIT-0 OR Public Domain */
/* Introduction
 * ============
 *
 * A subset of Bourne shell for tiny systems.
 * Roughly Unix V7 sh, plus &&/|| and $() arithmetic.
 * Implemented as a hand-written recursive descent parser.
 *
 * Grammar
 * -------
 *
 * program      = list? EOF
 * list         = simple_list (';' simple_list)* ';'?
 * list = simple_list ( terminator simple_list )* terminator?
 * terminator = ';' | '\n'
 * simple_list  = pipeline ( ('&&' | '||') pipeline )*
 * pipeline     = command ( '|' command )*
 * command      = simple_cmd | compound_cmd | funcdef
 * simple_cmd   = (assignment)* (word)* (redir)*
 * compound_cmd = if_cmd | while_cmd | for_cmd | case_cmd
 *              | '{' list '}' | '(' list ')'
 *
 * if_cmd       = 'if' list 'then' list
 *                ('elif' list 'then' list )*
 *                ('else' list )? 'fi'
 * while_cmd    = 'while' list 'do' list 'done'
 * for_cmd      = 'for' NAME ('in' word*)? ';' 'do' list 'done'
 * case_cmd     = 'case' word 'in' (pattern ')' list ';;')* 'esac'
 *
 * funcdef      = NAME '(' ')' '{' list '}'
 * assignment   = NAME '=' word
 * redir        = ('<' | '>' | '>>' | '<<') word
 *              | NUMBER ('<' | '>' | '>>') word
 * word         = (CHAR | '$' NAME | '${' NAME '}' | '$(' list ')'
 *              | '\'' ... '\'' | '"' ... '"' | '\\' CHAR)+
 * pattern      = word ('|' word)*
 *
 * Tokens
 * ------
 *
 * Two-character tokens emitted by the lexer as single units:
 *   ${  $(  $((  ))  &&  ||  >>  <<  ;;
 * Single-character tokens:
 *   |  ;  <  >  (  )  {  }  \n
 * Everything else is a WORD or NUMBER.
 *
 * Arithmetic - $(( expr ))
 * ------------------------
 *
 * Integer-only expression evaluator using shunting-yard.
 * The shell lexer sees $(( as a single token and scans for the
 * matching )) by tracking paren depth (start at 2, ( increments,
 * ) decrements, done at 0). The inner string is handed to the
 * arithmetic evaluator as an opaque expression. Bare identifiers
 * are implicitly treated as $NAME variable references.
 *
 * Operator precedence (high to low):
 *   unary -
 *   * / %
 *   + -
 *   < <= > >=
 *   == !=
 *   = += -= *= /= %=       (right-associative)
 *
 * Word expansion order
 * --------------------
 *
 * 1. ${var} variable substitution (and $var, $?, $@, $1, etc.)
 * 2. $(cmd) command substitution
 * 3. $((expr)) arithmetic substitution
 * 4. Field splitting (IFS)
 * 5. Pathname expansion (glob)
 *
 * Single quotes suppress all expansion.
 * Double quotes suppress field splitting and globbing but allow $
 * expansions.
 *
 * What we include (over V6 Thompson shell)
 * -----------------------------------------
 *
 * - Variables ($var, $1, $@, $#, $?, $$)
 * - Control flow (if/elif/else/fi, while/do/done, for/in/do/done,
 *   case/esac)
 * - Functions (NAME() { list; })
 * - && / || short-circuit lists
 * - Here-documents (<<WORD)
 * - Subshells ( list )
 * - Brace groups { list; }
 * - Command substitution $(cmd)
 * - Arithmetic expansion $((expr))
 *
 * What we skip (vs POSIX sh / bash)
 * ----------------------------------
 *
 * - Backquote `cmd` substitution (use $() instead)
 * - [[ ]] extended test
 * - Arrays
 * - select
 * - Process substitution <(...)
 * - Tilde expansion
 * - Most set/shopt options
 *
 * Internal Design
 * ---------------
 *
 * General principle: parser calls next_token [lexer], lexer calls reader [xgetline].
 *
 * Bugs
 * ----
 *
 * [ ] Syntax errors in function definitions can leak memory.
 * [x] Keywords should only be parsed in command positions. A reserved word past
 *     the command name is now an ordinary argument (echo done prints "done").
 *
 * TODO
 * ----
 *
 * [x] call functions, with positional parameters ($1..$9, $@, $#, $0) swapped
 *     for the call's arguments and a local-variable frame per call
 * [x] variables, both global and local (the `local` built-in declares names in
 *     the current function frame)
 * [ ] remaining built-ins: export, set, eval, exec, dot (.), colon (:), test/[
 *     (break, continue, return, local and kill are done)
 *
 * References
 * ----------
 *
 * [IEEE Std 1003.1-2017, Shell Command Language](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html)
 *
 */

#ifdef JOS
/*
 * JOS build. The kernel has no POSIX layer, so pull in the JOS user API
 * (u.h) plus the extended libc (clib.h: string, malloc, printf, setjmp),
 * then shim the few POSIX names this file still refers to. The process and
 * terminal layers are handled separately, guarded by JOS below: there is no
 * fork (fork constructs degrade to spawn), and the console is cooked in the
 * kernel, so the terminal calls are stubbed to no-ops via isatty() == 0.
 */
#include "u.h"
#include "clib.h"

typedef int pid_t;

#define STDIN_FILENO	0
#define STDOUT_FILENO	1
#define STDERR_FILENO	2

/* await() reports success as an empty exit string; encode it as a wstatus so
 * the shared status helpers keep working. */
#define WIFEXITED(s)	1
#define WEXITSTATUS(s)	((s) >> 8)
#define WIFSIGNALED(s)	0
#define WTERMSIG(s)	0

/* Terminal control is a no-op here: isatty() returns 0, so init_term and the
 * raw/restore pair below take their early returns and never touch these. */
struct termios {
	int	c_lflag;
	int	c_cc[8];
};
#define ICANON		0000002
#define ECHO		0000010
#define VMIN		6
#define VTIME		5
#define TCSANOW		0

static int isatty(int fd) { (void)fd; return 0; }
static int tcgetattr(int fd, struct termios *t) { (void)fd; (void)t; return 0; }
static int tcsetattr(int fd, int act, const struct termios *t)
	{ (void)fd; (void)act; (void)t; return 0; }

#elif defined(SKJEGG)
/*
 * skjegg build. jsh runs as a guest under skj-run, one sandbox per process,
 * over skjegg's freestanding libc and the fs/ layer. Like JOS there is no
 * fork: a command spawns a fresh sandbox (SKJ_SYS_SPAWNV) and the shell waits
 * on its handle (SKJ_SYS_WAIT). A child inherits no fds; its 0/1/2 come from an
 * fd map the shell fills from its own descriptors, a pipe, or a redirect. The
 * console is line-cooked by the host, so the terminal calls are no-ops and
 * isatty() returns 0, taking the cooked reader path shared with JOS.
 */
#include <ctype.h>
#include <errno.h>
#include <fcntl.h>
#include <limits.h>
#include <setjmp.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <dirent.h>
#include <unistd.h>
#include "fs.h"

typedef int pid_t;

#define STDIN_FILENO	0
#define STDOUT_FILENO	1
#define STDERR_FILENO	2

/* skj_wait() returns the child's exit code; encode it as a wstatus so the
 * shared status helpers keep working, with the two high sentinels mapped by the
 * wait wrapper before they ever reach these. */
#define WIFEXITED(s)	1
#define WEXITSTATUS(s)	((s) >> 8)
#define WIFSIGNALED(s)	0
#define WTERMSIG(s)	0

/* Terminal control is a no-op: the host console is cooked, so isatty() is 0 and
 * init_term/restore_term take their early returns and never touch these. */
struct termios {
	int	c_lflag;
	int	c_cc[8];
};
#define ICANON		0000002
#define ECHO		0000010
#define VMIN		6
#define VTIME		5
#define TCSANOW		0

static int isatty(int fd) { (void)fd; return 0; }
static int tcgetattr(int fd, struct termios *t) { (void)fd; (void)t; return 0; }
static int tcsetattr(int fd, int act, const struct termios *t)
	{ (void)fd; (void)act; (void)t; return 0; }

/* No process namespace: a "pid" is a spawn handle, and $$ is a fixed id. */
static int getpid(void) { return 1; }

/* cd moves the current mount's directory through the fs/ layer. */
static int chdir(const char *path) { return fs_chdir(path); }

/* The emulator-private lifecycle calls and the fd primitives, from the per-arch
 * syscall seam and the fs/ layer. */
extern unsigned skj_spawnv(const void *req);
extern unsigned skj_wait(unsigned handle);
extern unsigned skj_kill(unsigned handle, unsigned status);
extern int sched_yield(void);
int pipe(int fd[2]);

/* The spawn/wait ABI constants, as the emulator defines them (emu/sched.h).
 * A guest knows the values; it does not include the emulator-private header. */
#define SKJ_SPAWN_FLAG_SHARE_MOUNTS 0x1u
#define SKJ_WAIT_BADHANDLE          0xffffffffu
#define SKJ_WAIT_WOULDBLOCK         0xfffffffeu

/* When >= 0, a spawned command's stdout (its default slot 1, if not otherwise
 * placed) is sent to this fd. Command substitution uses it for the compound
 * body path, so a spawned command's output reaches the capture pipe without a
 * dup2 the model lacks. */
static int cmdsub_out_fd = -1;

/* Which shell fd becomes a spawned child's slot k; -1 means the shell's own fd
 * k. Redirections and pipe ends fill this and the spawn turns it into the fd
 * map. Defined here so command substitution can build one too. */
struct fdplan {
    int fd[3];
};

static void
fdplan_init(struct fdplan *p)
{
    p->fd[0] = p->fd[1] = p->fd[2] = -1;
}

#else
#include <ctype.h>
#include <errno.h>
#include <fcntl.h>
#include <limits.h>
#include <setjmp.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <termios.h>
#include <unistd.h>
#endif

/*****************************************************************************
 * Macros
 ****************************************************************************/

#define ARENA_SIZE 16384
#define MAXVARNAME 32
#define MAXLINE 2048
#define MAXARGS  64
/* No job table (jobs/fg/bg): `cmd &` runs fire-and-forget, reaped at the
 * prompt (POSIX) or at shell exit (the skj-run sandbox, which has no process
 * suspension, so stop/resume job control does not apply). */

#ifndef _PATH_BSHELL
#define _PATH_BSHELL    "/bin/sh"
#endif

/*****************************************************************************
 * Type definitions
 ****************************************************************************/

/* token types */
enum toktype {
    T_EOF = 0,
    T_WORD,     /* unquoted or quoted word */
    T_NEWLINE,  /* \n */
    T_SEMI,     /* ; */
    T_DSEMI,    /* ;; */
    T_PIPE,     /* | */
    T_AND,      /* && */
    T_OR,       /* || */
    T_AMP,      /* & */
    T_LESS,     /* < */
    T_GREAT,    /* > */
    T_DGREAT,   /* >> */
    T_DLESS,    /* << */
    T_LPAREN,   /* ( */
    T_RPAREN,   /* ) */
    T_LBRACE,   /* { */
    T_RBRACE,   /* } */
    T_BANG,     /* ! */
    T_IF,
    T_ELSE,
    T_THEN,
    T_ELIF,
    T_FI,
    T_FOR,
    T_IN,
    T_WHILE,
    T_DO,
    T_DONE,
    T_CASE,
    T_ESAC,
    /* ${ $( $(( are handled during word expansion, not as tokens */
};

struct token {
    int type;
    char *str;  /* points into linebuf, null-terminated */
};

/* AST node types */
enum nodetype {
    N_CMD,      /* simple command: argv + redirs */
    N_PIPE,     /* left | right */
    N_LIST,     /* left ; right  or  left && right  or  left || right */
    N_BACK,     /* cmd & */
    N_REDIR,    /* redir wrapping a cmd */
    N_SUBSHELL, /* ( list ) */
    N_IF,       /* if/elif/else/fi */
    N_WHILE,    /* while/do/done */
    N_FOR,      /* for/in/do/done */
    N_CASE,     /* case/in/esac */
    N_ASSIGN,   /* NAME=value (optionally prefixing a command) */
};

struct node;

struct node_cmd {
    int type;       /* N_CMD */
    char **argv;
    int argc;
};

struct node_pipe {
    int type;       /* N_PIPE */
    struct node *left;
    struct node *right;
};

struct node_list {
    int type;       /* N_LIST */
    int op;         /* T_SEMI, T_AND, T_OR */
    struct node *left;
    struct node *right;
};

struct node_back {
    int type;       /* N_BACK */
    struct node *cmd;
};

struct node_redir {
    int type;       /* N_REDIR */
    int rtype;      /* T_LESS, T_GREAT, T_DGREAT, T_DLESS */
    int fd;         /* file descriptor (-1 = default) */
    char *file;
    struct node *cmd;
};

struct node_subshell {
    int type;       /* N_SUBSHELL */
    struct node *body;
};

struct node_if {
    int type;       /* N_IF */
    struct node *cond;
    struct node *then_body;
    struct node *else_body; /* NULL or another N_IF for elif */
};

struct node_while {
    int type;       /* N_WHILE */
    struct node *cond;
    struct node *body;
};

struct node_for {
    int type;       /* N_FOR */
    char *var;
    char **words;
    int nwords;
    struct node *body;
};

struct node_assign {
    int type;       /* N_ASSIGN */
    char *var;
    char *value;
    struct node *cmd; /* NULL for bare assignment, else points to a chain of N_ASSIGN to an N_CMD */
};

/* one clause of a case: alternative patterns and the body to run on a match */
struct node_case_item {
    char **patterns;            /* NULL-terminated list of glob patterns */
    struct node *body;
    struct node_case_item *next;
};

struct node_case {
    int type;       /* N_CASE */
    char *word;     /* the word matched against each clause's patterns */
    struct node_case_item *items;
};

struct node {
    union {
        int type;
        struct node_cmd cmd;
        struct node_pipe pipe;
        struct node_list list;
        struct node_back back;
        struct node_redir redir;
        struct node_subshell subshell;
        struct node_if if_;
        struct node_while while_;
        struct node_for for_;
        struct node_assign assign;
        struct node_case case_;
    };
};

enum builtin {
    B_EXIT,
    B_CD,
    B_BREAK,
    B_CONTINUE,
    B_RETURN,
    B_LOCAL,
    B_KILL,
};

/* function definition */
struct func {
    char *name;
    struct node *body;
    struct func *next;
};

/* variable definition - immutable strings "var\0value\0" */
struct var {
    struct var *next;
    char data[];
};

struct var_frame {
    // TODO: Question: can we arena-allocate local variables?
    struct var *head;
    struct var_frame *next;
};

/*****************************************************************************
 * Prototypes
 ****************************************************************************/

extern char **environ;
static jmp_buf j_parser_top;
static void die(const char *res);
static void die_p(const char *res);
static void drain_background(void);
static void announce_bg(int pid);
static void init_term(void);
#if !defined(JOS) && !defined(SKJEGG)
static void raw_term(void);
#endif
static void restore_term(void);
static int xgetline(void);
static void *arena_alloc(int size);
static void arena_reset(void);
static void *node_alloc(int size);
static char *xstrdup(const char *s);
#ifdef SKJEGG
struct fdplan;
static unsigned sk_spawn(int argc, char **argv, struct fdplan *pl);
static unsigned sk_spawn_stage(struct node *stage, struct fdplan *base);
#endif
static struct node *p_program(void);
static struct node *p_list(void);
static struct node *p_simple_list(void);
static struct node *p_pipeline(void);
static struct node *p_command(void);
static struct node *p_simple_cmd_or_funcdef(void);
static struct node *p_compound_cmd(void);
static struct node *p_if_cmd(void);
static struct node *p_while_cmd(void);
static struct node *p_for_cmd(void);
static struct node *p_case_cmd(void);
static int next_token(void);
static int peek_token(void);
static void expect(int type, const char *reason);
static struct func *newfunc(const char *name, struct node *body);
static struct func *findfunc(const char *name);
static void freefunc(struct func *func);
static int delfunc(const char *name);
#if !defined(JOS) && !defined(SKJEGG)
static pid_t spawn(int argc, char *argv[], int forked_flag);
#endif
static int execute_tree(struct node *n, int forked_flag);
static struct var_frame var_frame_global, *var_frame_head = &var_frame_global;

/*****************************************************************************
 * Globals
 ****************************************************************************/

static char crlf[3] = "\r\n";
static const char * const prompt = "$ "; /* TODO: make this run-time configurable */
static const char * const builtin_list[] = {
    [B_EXIT] = "exit", [B_CD] = "cd",
    [B_BREAK] = "break", [B_CONTINUE] = "continue",
    [B_RETURN] = "return", [B_LOCAL] = "local",
    [B_KILL] = "kill",
/* Not yet implemented:
 * [B_COLON] = ":",
 * [B_DOT] = ".",
 * [B_EXPORT] = "export",
 * [B_EVAL] = "eval",
 * [B_EXEC] = "exec",
 * [B_TEST] = "test",
 * [B_BRACKET] = "[", // but not bash's "[[" syntax
 */
};
static char linebuf[MAXLINE];
static unsigned linebuf_len;
static int last_line; /* xgetline() has seen an EOF, or user has typed "exit" */
static int terminal_mode; /* true if we can use terminal functions */
static struct termios original_term;
static struct termios rawterm;
static int term_initialized;
static struct token cur_tok;    /* current token */
static struct token peek_tok;   /* look-ahead token */
static int have_peek; /* is peek_tok valid? */
static char *lexpos; /* current position in linebuf for lexer */
static int in_funcdef; /* set/clear when entering/leaving funcdef. this changes the allocation between arena and malloc/calloc. */
static struct func *func_head;
static int last_status; /* holds most recent exit status from execute_tree */
#if !defined(JOS) && !defined(SKJEGG)
static char filename_buf[PATH_MAX]; /* output of padvance */
#endif
static int silent_command_count; /* 0 = show return status */

/*
 * Set while an N_BACK runs its command, so N_CMD spawns it in the background
 * (no wait) instead of foreground. Only a simple command is backgrounded;
 * compound constructs run in the foreground, since there is no fork to isolate
 * them. The flag is consumed at the leaf so it does not leak into a function
 * body run for the same command.
 */
static int bg_pending;

/*
 * Loop control for break/continue. A builtin sets loop_ctl and loop_ctl_count;
 * the enclosing loop in execute_tree consumes it. A count above 1 breaks or
 * continues that many enclosing loops, so the signal is left set (count
 * decremented) for the outer loop to see. loop_depth guards the builtins so a
 * break or continue outside any loop is reported rather than leaking.
 */
enum { LC_NONE = 0, LC_BREAK = 1, LC_CONTINUE = 2 };
static int loop_ctl;        /* LC_NONE, LC_BREAK, or LC_CONTINUE */
static int loop_ctl_count;  /* number of enclosing loops still to act on */
static int loop_depth;      /* dynamic nesting of for/while loops */

/*
 * return control. func_return is set by the return builtin and unwinds the
 * running function body, skipping the rest of lists and stopping any enclosing
 * loops, until the call in execute_tree consumes it. func_depth guards the
 * builtin so a return outside any function is reported.
 */
static int func_return;         /* set to unwind the current function body */
static int func_return_status;  /* status the function returns with */
static int func_depth;          /* dynamic nesting of function calls */

/*
 * Positional parameters. pos_params[0] is $1, pos_nparams is $#, pos_zero is
 * $0. Set from the shell's own argv at startup and swapped for a function's
 * arguments while its body runs. $@ and $* expand to all of them.
 */
static char **pos_params;
static int pos_nparams;
static char *pos_zero = "jsh";

/****************************************************************************/

int
main(int argc, char *argv[])
{
    /* the shell's own arguments become the initial positional parameters */
    if (argc > 0) {
        pos_zero = argv[0];
        pos_params = argv + 1;
        pos_nparams = argc - 1;
    }

    init_term();
#if !defined(JOS) && !defined(SKJEGG)
    atexit(restore_term);
#endif

    while (!last_line) {
        drain_background();	/* collect finished background jobs */
        write(STDOUT_FILENO, prompt, strlen(prompt));
        if (xgetline() < 0) {
            break;
        }
        if (linebuf_len) {
            lexpos = linebuf;
            have_peek = 0;
            struct node *tree = p_program();
            execute_tree(tree, 0);
            arena_reset();
        }
    }

    return last_status;
}

#ifdef JOS
/* JOS entry point: the loader and the built-in registry call jshmain. */
int
jshmain(int argc, char **argv)
{
    return main(argc, argv);
}
#endif

/****************************************************************************/

static void
die(const char *reason)
{
    restore_term();
    puts(reason);
    exit(1);
}

/*
 * Announce a job started in the background by printing "[pid]\n". Built with a
 * small backward fill so it needs no printf, which keeps it usable on JOS.
 */
static void
announce_bg(int pid)
{
    char buf[16];
    unsigned v = (unsigned)pid;
    int i = (int)sizeof buf;

    buf[--i] = '\n';
    buf[--i] = ']';
    do {
        buf[--i] = (char)('0' + v % 10);
        v /= 10;
    } while (v);
    buf[--i] = '[';
    write(STDOUT_FILENO, buf + i, (long)(sizeof buf - i));
}

static void
die_p(const char *reason)
{
    restore_term();
    perror(reason);
    exit(1);
}

static void
syntaxerror(const char *reason)
{
    puts(reason);
    longjmp(j_parser_top, 1);
}

/****************************************************************************/

static void
init_term(void)
{
    terminal_mode = isatty(STDIN_FILENO);
    if (!terminal_mode) return;

    if (tcgetattr(STDIN_FILENO, &original_term)) die_p("tcgetattr");

    rawterm = original_term;
    rawterm.c_lflag &= ~(ICANON | ECHO); /* clear canonical mode, disable echo */
    rawterm.c_cc[VMIN] = 1;
    rawterm.c_cc[VTIME] = 0;
}

#if !defined(JOS) && !defined(SKJEGG)
static void
raw_term(void)
{
    if (!terminal_mode) return;
    if(tcsetattr(STDIN_FILENO, TCSANOW, &rawterm)) die_p("tcsetattr");
    term_initialized = 1;
}
#endif

static void
restore_term(void)
{
    if (!terminal_mode) return;
    if (!term_initialized) return;
    write(STDOUT_FILENO, crlf, 1); /* write CR before going to cooked mode */
    if (tcsetattr(STDIN_FILENO, TCSANOW, &original_term))
        die_p("tcsetattr");
    term_initialized = 0;
}

/*****************************************************************************
 * getline implementation
 ****************************************************************************/

#if defined(JOS) || defined(SKJEGG)
/*
 * JOS reader. The kernel console is cooked: it echoes input and handles line
 * editing, and read() returns at a newline. So collect bytes into linebuf
 * without switching to raw mode or echoing here (that would double up). EOF
 * with nothing pending ends the shell.
 */
static int
xgetline(void)
{
    unsigned len = 0;
    int e;
    char c;

    for (;;) {
        e = read(STDIN_FILENO, &c, 1);
        if (e < 0)
            die_p("read");
        if (e == 0) {			/* EOF */
            last_line = 1;
            if (len == 0)
                return -1;
            break;
        }
        if (c == '\n' || c == '\r')
            break;
        if (c == '\b' || c == 127) {	/* editing fallback */
            if (len > 0)
                len--;
            continue;
        }
        if (len < MAXLINE - 1)
            linebuf[len++] = c;
    }
    linebuf[len] = '\0';
    linebuf_len = len;
    return (int)len;
}
#else
/* return <0 on error, length in buffer on success */
static int
xgetline(void)
{
    unsigned len;
    int e;
    char c;
    char *p = linebuf;

    raw_term();
    for (len = 0; len < MAXLINE; ) {
        e = read(STDIN_FILENO, &c, 1);
        if (e < 0) die_p("read");
        /* end the line on EOF, CR, or LF */
        if (e == 0 || c == '\n' || c == '\r') { /* CR/LF */
            if (e == 0) last_line = 1;
            write(STDOUT_FILENO, crlf, 2);
            linebuf_len = len;
            *p = 0;
            restore_term();
            return len;
        }
        if (c == '\b' || c == 127) { /* Backspace/Delete */
            if (len > 0) {
                len--;
                write(STDOUT_FILENO, "\b \b", 3); /* destructive erase */
            }
            continue;
        }
        write(STDOUT_FILENO, &c, 1);
        *p++ = c;
        len++;
    }
    restore_term();

    die("overflow!");

    return -1;
}
#endif

/*****************************************************************************
 * Bump Allocator
 ****************************************************************************/

static char arena[ARENA_SIZE];
static int arena_off;

static void *
arena_alloc(int size)
{
    void *p;
    size = (size + 3) & ~3; /* align to 4 */
    if (arena_off + size > ARENA_SIZE) {
        die("arena overflow");
        return NULL;
    }
    p = &arena[arena_off];
    arena_off += size;
    return p;
}

static void
arena_reset(void)
{
    arena_off = 0;
}

/* allocates from malloc/calloc in funcdef path, else from arena. */
static void *
node_alloc(int size)
{
    if (in_funcdef)
        return calloc(1, size);  /* lives forever */
    return arena_alloc(size);
}

/*
 * freetree
 *
 * WARNING: this should only be called on funcdef path allocated trees.
 *
 */
static void
freetree(struct node *n)
{
    int i;
    if (!n) return;

    /* check if our node is in the arena space */
    if ((char *)n >= arena && (char *)n < arena + ARENA_SIZE)
        die("BUG: freetree called on arena node");

    switch (n->type) {
    case N_CMD:
        /* NOTE: we require cmd.argv[] strings to be malloc() when in_funcdef */
        /* there's a hidden slot before the pointer, adjust */
        for (i = -1; i < n->cmd.argc; i++)
            free(n->cmd.argv[i]);
        free(n->cmd.argv - 1);
        break;
    case N_PIPE:
        freetree(n->pipe.left);
        n->pipe.left = NULL;
        freetree(n->pipe.right);
        n->pipe.right = NULL;
        break;
    case N_LIST:
        freetree(n->list.left);
        n->list.left = NULL;
        freetree(n->list.right);
        n->list.right = NULL;
        break;
    case N_BACK:
        freetree(n->back.cmd);
        n->back.cmd = NULL;
        break;
    case N_REDIR:
        /* NOTE: we require cmd.file string to be malloc() when in_funcdef */
        free(n->redir.file);
        freetree(n->redir.cmd);
        n->redir.cmd = NULL;
        break;
    case N_SUBSHELL:
        freetree(n->subshell.body);
        n->subshell.body = NULL;
        break;
    case N_IF:
        freetree(n->if_.cond);
        n->if_.cond = NULL;
        freetree(n->if_.then_body);
        n->if_.then_body = NULL;
        freetree(n->if_.else_body);
        n->if_.else_body = NULL;
        break;
    case N_WHILE:
        freetree(n->while_.cond);
        n->while_.cond = NULL;
        freetree(n->while_.body);
        n->while_.body = NULL;
        break;
    case N_FOR:
        /* NOTE: we require for_.var and for_.word to be allocated through
         * malloc() / node_alloc() respectively when in_funcdef. */
        free(n->for_.var);
        for (i = 0; i < n->for_.nwords; i++)
            free(n->for_.words[i]);
        free(n->for_.words);
        freetree(n->for_.body);
        n->for_.body = NULL;
        break;
    case N_ASSIGN:
        /* var and value share one allocation ("name\0value"); free once. */
        free(n->assign.var);
        freetree(n->assign.cmd);
        n->assign.cmd = NULL;
        break;
    case N_CASE: {
        struct node_case_item *it = n->case_.items, *nx;
        int j;

        free(n->case_.word);
        while (it != NULL) {
            nx = it->next;
            for (j = 0; it->patterns[j] != NULL; j++)
                free(it->patterns[j]);
            free(it->patterns);
            freetree(it->body);
            free(it);
            it = nx;
        }
        n->case_.items = NULL;
        break;
    }
    }

    free(n);
}

/*****************************************************************************
 * Utility functions
 ****************************************************************************/

static char *
xstrdup(const char *s)
{
    unsigned n = strlen(s) + 1;
    char *out = malloc(n);
    memcpy(out, s, n);
    return out;
}

#if !defined(JOS) && !defined(SKJEGG)
/*
 * padvance - PATH advance utility
 *
 * writes the next entry at pathp to filename_buf, appends cmd.
 *
 * TODO: return -1 on an error.
 */
static int
padvance(const char **pathp, const char *cmd)
{
    static const char *colon = ":";
    int len, cmdlen;
    const char *start = *pathp, *cur;

    len = strcspn(start, colon);
    cur = start + len;
    *pathp = *cur == ':' ? cur + 1 : NULL;

    cmdlen = strlen(cmd);

    if (len + 1 + cmdlen >= PATH_MAX) {
        errno = ENAMETOOLONG;
        return -1;
    }

    memcpy(filename_buf, start, len);
    if (len && filename_buf[len - 1] != '/') { /* append / if the path element lacks one */
        filename_buf[len++] = '/';
    }
    memcpy(filename_buf + len, cmd, cmdlen + 1); // include \0

    return len + cmdlen;
}
#endif /* !JOS */

/*****************************************************************************
 * Parser
 *
 * Each p_* function returns a struct node * allocated from the arena.
 * Returns NULL for empty productions.
 ****************************************************************************/

static int
is_redir(int tok)
{
    return tok == T_LESS || tok == T_GREAT || tok == T_DLESS || tok == T_DGREAT;
}

static int
is_terminator_keyword(int tok)
{
    return tok == T_THEN || tok == T_ELSE || tok == T_ELIF || tok == T_FI
        || tok == T_DO || tok == T_DONE || tok == T_ESAC || tok == T_RBRACE
        || tok == T_RPAREN || tok == T_EOF;
}

/*
 * A reserved word is only special in command position. Once a command name has
 * been read, a following reserved word is an ordinary argument (echo done
 * prints "done"), so the argument scanner accepts these as words. The lexer
 * left the word text in tok->str.
 */
static int
is_keyword_tok(int tok)
{
    return tok == T_IF || tok == T_THEN || tok == T_ELSE || tok == T_ELIF
        || tok == T_FI || tok == T_FOR || tok == T_IN || tok == T_WHILE
        || tok == T_DO || tok == T_DONE || tok == T_CASE || tok == T_ESAC;
}

/*
 * p_program - top-level entry point
 *
 * program = ( list terminator )* EOF
 * terminator = '\n' | ';'
 *
 * In interactive mode, xgetline already consumed the newline,
 * so we parse lists separated by ';' until T_EOF.
 */
static struct node *
p_program(void)
{
    struct node *n;

    /* escape hatch for syntax errors
     * It probably leaks memory on some code paths!
     */
    if (setjmp(j_parser_top)) {
        return NULL;
    }

    n = p_list();

    expect(T_EOF, 0);

    return n;
}

/* Wrap a list in an N_BACK node, marking it to run in the background. */
static struct node *
node_back(struct node *cmd)
{
    struct node *n = node_alloc(sizeof(struct node_back));

    n->type = N_BACK;
    n->back.cmd = cmd;
    return n;
}

/*
 * p_list - compound list is composed of simple lists
 *
 * list         = simple_list ( terminator simple_list )* terminator?
 * terminator   = ';' | '&' | '\n'
 *
 * '&' terminates its list like ';' but marks it to run in the background: the
 * preceding simple_list is wrapped in an N_BACK node.
 */
static struct node *
p_list(void)
{
    int tok;
    struct node *left, *n;

    /*
     * A simple_list may be NULL without ending the list: a function definition
     * parses to no node (it registers the function as a side effect). Keep
     * going so the rest of the line, such as a call after "funcdef ; name", is
     * still parsed. A NULL node executes as a no-op.
     */
    left = p_simple_list();

    while ((tok = peek_token()) == T_SEMI || tok == T_NEWLINE ||
           tok == T_AMP) {
        next_token();
        if (tok == T_AMP)
            left = node_back(left);	/* run the preceding list async */
        if (is_terminator_keyword(peek_token()))
            break; /* trailing separator before keyword, don't build a list */
        n = node_alloc(sizeof(struct node_list));
        n->type = N_LIST;
        n->list.op = T_SEMI;
        n->list.left = left;
        n->list.right = p_simple_list();
        left = n;
        // do we need? if (!n->list.right) break;
    }

    return left;
}

/*
 * p_simple_list -
 *
 * simple_list  = pipeline ( ('&&' | '||') pipeline )*
 */
static struct node *
p_simple_list(void)
{
    struct node *left, *n;
    int tok;

    left = p_pipeline();

    while ((tok = peek_token()) == T_AND || tok == T_OR) {
        next_token();
        n = node_alloc(sizeof(struct node_list));
        n->type = N_LIST;
        n->list.op = tok;
        n->list.left = left;
        n->list.right = p_pipeline();
        left = n;
    }

    return left;
}

/*
 * p_pipeline -
 *
 * pipeline     = command ( '|' command )*
 *
 */
static struct node *
p_pipeline(void)
{
    struct node *left, *n;

    left = p_command();

    while (peek_token() == T_PIPE) {
        next_token();
        n = node_alloc(sizeof(struct node_pipe));
        n->type = N_PIPE;
        n->pipe.left = left;
        n->pipe.right = p_command();
        left = n;
    }

    return left;
}

/*
 * p_command -
 *
 * command      = simple_cmd | compound_cmd | funcdef
 *
 */
static struct node *
p_command(void)
{
    struct node *n = p_compound_cmd();
    if (!n)
        n = p_simple_cmd_or_funcdef();

    return n;
}

/*
 * p_simple_cmd_or_funcdef - simple_cmd, assignment, and funcdef in one function.
 *
 * simple_cmd   = (assignment)* (word)* (redir)*
 * assignment   = NAME '=' word
 * funcdef      = NAME '(' ')' '{' list '}'
 *
 */
/* Is w a NAME=value assignment word? NAME is a portable variable name. */
static int
is_assignment_word(const char *w)
{
    int i;

    if (w == NULL || !(isalpha((unsigned char)w[0]) || w[0] == '_'))
        return 0;
    for (i = 1; isalnum((unsigned char)w[i]) || w[i] == '_'; i++)
        ;
    return w[i] == '=';
}

/*
 * Parse a simple command given its first word (argv[0]) already in hand, plus
 * its arguments and redirections. Returns the head node: an N_CMD, possibly
 * wrapped in one or more N_REDIR nodes.
 */
static struct node *
p_simple_cmd_from(char *first)
{
    struct node_cmd *cmd;
    struct node *head;
    int tok, fd = -1;

    cmd = node_alloc(sizeof(*cmd));
    head = (struct node *)cmd;
    cmd->type = N_CMD;
    cmd->argc = 1;
    cmd->argv = node_alloc(sizeof(*cmd->argv) * (MAXARGS + 2));
    /* there's a secret empty slot at the beginning for a /bin/sh prefix */
    cmd->argv[0] = NULL;
    cmd->argv++;
    cmd->argv[0] = first;

    for (;;) {
        tok = peek_token();
        if (tok == T_WORD && isdigit(peek_tok.str[0])) {
            next_token();
            char *numstr = cur_tok.str;
            if (is_redir(peek_token())) {
                fd = atoi(numstr);
                tok = peek_token();
                goto redir;
            }
            /* not a redirect number, treat it as an argument. */
            if (cmd->argc < MAXARGS - 1)
                cmd->argv[cmd->argc++] = numstr;
        } else if (tok == T_WORD || is_keyword_tok(tok)) {
            /* a reserved word past the command name is a plain argument */
            next_token();
            if (cmd->argc < MAXARGS - 1)
                cmd->argv[cmd->argc++] = cur_tok.str;
        } else if (is_redir(tok)) {

        /* build redirection chain while we parse command arguments:
         *
         * redir        = ('<' | '>' | '>>' | '<<') word
         *              | NUMBER ('<' | '>' | '>>') word
         *
         *
         * this inserts N_REDIR and wraps the current head (N_CMD or N_REDIR)
         */
redir:
            next_token();
            expect(T_WORD, 0);
            char *file = cur_tok.str;

            struct node_redir *redir = node_alloc(sizeof(*redir));
            redir->type = N_REDIR;
            redir->rtype = tok;
            redir->fd = fd;
            redir->file = file;
            redir->cmd = head;
            head = (struct node *)redir;
            fd = -1;
        } else {
            break;
        }
    }
    cmd->argv[cmd->argc] = NULL;

    return head;
}

static struct node *
p_simple_cmd_or_funcdef(void)
{
    char *first;
    int tok;

    if (peek_token() != T_WORD) return NULL;
    next_token();
    first = cur_tok.str;

    tok = peek_token();

    /* funcdef - NAME '(' is the start of a funcdef */
    if (tok == T_LPAREN) {
        /* first is a stable, terminated copy from the lexer, so "name()"
         * written with no space works without patching linebuf here. */
        next_token();
        expect(T_RPAREN, 0);
        expect(T_LBRACE, 0);
        in_funcdef = 1;
        newfunc(first, p_list());
        expect(T_RBRACE, 0);
        in_funcdef = 0;
        return NULL;
    }

    /*
     * Leading assignments: one or more NAME=value words in command position,
     * then an optional command. Build a chain of N_ASSIGN whose innermost cmd
     * is that command, or NULL for a bare assignment. Executed, each sets a
     * shell variable; a trailing command then runs with them in effect.
     */
    if (is_assignment_word(first)) {
        struct node *head = NULL;
        struct node **tail = &head;
        char *w = first;

        for (;;) {
            char *eq = strchr(w, '=');
            struct node_assign *a = node_alloc(sizeof(*a));

            *eq = '\0';		/* split the owned word copy: "name\0value" */
            a->type = N_ASSIGN;
            a->var = w;
            a->value = eq + 1;
            a->cmd = NULL;
            *tail = (struct node *)a;
            tail = &a->cmd;

            if (peek_token() == T_WORD && is_assignment_word(peek_tok.str)) {
                next_token();
                w = cur_tok.str;
                continue;
            }
            break;
        }
        /* an optional command follows the assignments */
        tok = peek_token();
        if (tok == T_WORD || is_keyword_tok(tok)) {
            next_token();
            *tail = p_simple_cmd_from(cur_tok.str);
        }
        return head;
    }

    return p_simple_cmd_from(first);
}

/*
 * p_compound_cmd -
 *
 * compound_cmd = if_cmd | while_cmd | for_cmd | case_cmd
 *              | '{' list '}' | '(' list ')'
 *
 */
static struct node *
p_compound_cmd(void)
{
    int tok = peek_token();

    if (tok == T_IF) { return p_if_cmd(); }
    else if (tok == T_WHILE) { return p_while_cmd(); }
    else if (tok == T_FOR) { return p_for_cmd(); }
    else if (tok == T_CASE) { return p_case_cmd(); }
    else if (tok == T_LBRACE) {
        next_token();
        struct node *n = p_list();
        expect(T_RBRACE, 0);
        return n;
    } else if (tok == T_LPAREN) {
        next_token();
        struct node *n = node_alloc(sizeof(struct node_subshell));
        n->type = N_SUBSHELL;
        n->subshell.body = p_list();
        expect(T_RPAREN, 0);
        return n;
    }
    return NULL;
}

/*
 * p_subbody_if - helper function for p_if_cmd
 *
 * effectively we've altered the grammar in this way:
 *
 * if_subbody   = list ';' 'then' list ';'
 * if_cmd       = 'if' if_subbody
 *                ('elif' if_subbody)*
 *                ('else' list ';')? 'fi'
 */
static struct node *
p_subbody_if(void)
{
    struct node *cond = p_list();
    expect(T_THEN, 0);
    struct node *body = p_list();

    struct node *n = node_alloc(sizeof(struct node_if));
    n->type = N_IF;
    n->if_.cond = cond;
    n->if_.then_body = body;
    n->if_.else_body = NULL;

    return n;
}

/*
 * p_if_cmd - if statements.
 *
 * if_cmd       = 'if' list ';' 'then' list ';'
 *                ('elif' list ';' 'then' list ';')*
 *                ('else' list ';')? 'fi'
 * if list ; then list ; fi
 * if list ; then list ; else list ; fi
 * if list ; then list ; elif list ; then list ; fi
 * if list ; then list ; elif list ; then list ; else list ; fi
 *
 */
static struct node *
p_if_cmd(void)
{
    int tok = peek_token();

    if (tok != T_IF) return NULL; /* not an if statement */
    next_token();

    /* for 'elif', chain T_IF like a linked list */
    struct node *head, *tail;
    head = tail = p_subbody_if();

    while ((tok = peek_token()) == T_ELIF) {
        next_token();
        struct node *elif = p_subbody_if();
        tail->if_.else_body = elif;
        tail = elif;
    }

    if (tok == T_ELSE) {
        next_token();
        tail->if_.else_body = p_list();
    }

    expect(T_FI, 0);

    return head;
}

/*
 * p_while_cmd - while loops.
 *
 * while_cmd    = 'while' list ';' 'do' list ';' 'done'
 *
 */
static struct node *
p_while_cmd(void)
{
    int tok = peek_token();

    if (tok != T_WHILE) return NULL; /* not a while statement */
    next_token();

    struct node *cond = p_list();
    expect(T_DO, "missing do in while");
    struct node *body = p_list();
    expect(T_DONE, "missing done in while");

    struct node *n = node_alloc(sizeof(struct node_while));
    n->type = N_WHILE;
    n->while_.cond = cond;
    n->while_.body = body;

    return n;
}

/*
 * p_for_cmd - for loops....
 *
 * for_cmd      = 'for' NAME ('in' word*)? ';' 'do' list ';' 'done'
 *
 */
static struct node *
p_for_cmd(void)
{
    int tok = peek_token();

    if (tok != T_FOR) return NULL; /* not a while statement */
    next_token();

    /* This shell plays a little loose with the rules.
     * NAME should only be a valid identified, so "ab" is not something we
     * should have supported, but we do.
     * What doesn't work is are keywords, you can use identifies like if,
     * while, do, done, ...
     */

    expect(T_WORD, "no valid identifier in for");
    char *name = cur_tok.str;

    // TODO: make 'in' optional? is that really necessary?
    expect(T_IN, 0);

    char **words = node_alloc(sizeof(*words) * MAXARGS);
    int nwords = 0;

    while (nwords < MAXARGS && (tok = peek_token()) == T_WORD) {
        next_token();
        words[nwords++] = cur_tok.str;
    }

    expect(T_SEMI, "missing ; in for");
    expect(T_DO, "missing do in for");
    struct node *body = p_list();
    expect(T_DONE, "missing done in for");

    struct node *n = node_alloc(sizeof(struct node_for));
    n->type = N_FOR;
    n->for_.var = name;
    n->for_.words = words;
    n->for_.nwords = nwords;
    n->for_.body = body;

    return n;
}

/*
 * p_case_cmd - case/esac statement.
 *
 * case_cmd     = 'case' word 'in' (pattern ')' list ';;')* 'esac'
 *
 */
static struct node *
p_case_cmd(void)
{
    struct node *n;
    struct node_case_item *items = NULL, **itail = &items;
    char *word;
    int tok;

    next_token();			/* consume 'case' */
    expect(T_WORD, "case: expected word");
    word = cur_tok.str;
    expect(T_IN, "case: expected 'in'");

    while ((tok = peek_token()) == T_SEMI || tok == T_NEWLINE)
        next_token();

    /* clause = ['('] pattern ('|' pattern)* ')' list [';;'] */
    while ((tok = peek_token()) != T_ESAC && tok != T_EOF) {
        struct node_case_item *item = node_alloc(sizeof(*item));
        char **pats = node_alloc(sizeof(char *) * (MAXARGS + 1));
        int np = 0;

        item->next = NULL;
        item->body = NULL;
        item->patterns = pats;

        if (peek_token() == T_LPAREN)	/* optional leading '(' */
            next_token();

        for (;;) {
            tok = peek_token();
            if (tok != T_WORD && !is_keyword_tok(tok))
                break;
            next_token();
            if (np < MAXARGS)
                pats[np++] = cur_tok.str;
            if (peek_token() == T_PIPE) {
                next_token();
                continue;
            }
            break;
        }
        pats[np] = NULL;
        expect(T_RPAREN, "case: expected ')'");

        item->body = p_list();		/* runs until ';;' or 'esac' */

        *itail = item;
        itail = &item->next;

        if (peek_token() == T_DSEMI) {
            next_token();
            while ((tok = peek_token()) == T_SEMI || tok == T_NEWLINE)
                next_token();
        } else {
            break;			/* last clause may drop ';;' before esac */
        }
    }

    expect(T_ESAC, "case: expected 'esac'");

    n = node_alloc(sizeof(struct node_case));
    n->type = N_CASE;
    n->case_.word = word;
    n->case_.items = items;
    return n;
}

/*****************************************************************************
 * Lexer
 *
 * Scans linebuf via lexpos.  Tokens point into linebuf - words are
 * null-terminated in place (we can mutate linebuf since xgetline
 * already copied the input).
 ****************************************************************************/

static int
is_meta(char c)
{
    return c == '|' || c == '&' || c == ';' || c == '<' || c == '>'
        || c == '(' || c == ')' || c == '{' || c == '}' || c == '\n';
}

/*
 * lex_one - scan one token starting at lexpos, fill in tok.
 * Returns the token type.
 */
static enum toktype
lex_one(struct token *tok)
{
    char *s;

    /* skip whitespace (but not newline) */
    while (*lexpos == ' ' || *lexpos == '\t')
        lexpos++;

    s = lexpos;

    if (*s == '\0') {
        tok->type = T_EOF;
        tok->str = NULL;
        return T_EOF;
    }

    /* two-character tokens - check these first */
    if (s[0] == '&' && s[1] == '&') {
        tok->type = T_AND;
        tok->str = s;
        lexpos += 2;
        return T_AND;
    }
    if (s[0] == '|' && s[1] == '|') {
        tok->type = T_OR;
        tok->str = s;
        lexpos += 2;
        return T_OR;
    }
    if (s[0] == ';' && s[1] == ';') {
        tok->type = T_DSEMI;
        tok->str = s;
        lexpos += 2;
        return T_DSEMI;
    }
    if (s[0] == '>' && s[1] == '>') {
        tok->type = T_DGREAT;
        tok->str = s;
        lexpos += 2;
        return T_DGREAT;
    }
    if (s[0] == '<' && s[1] == '<') {
        tok->type = T_DLESS;
        tok->str = s;
        lexpos += 2;
        return T_DLESS;
    }

    /* single-character tokens */
    switch (*s) {
    case '|':  tok->type = T_PIPE;    tok->str = s; lexpos++; return T_PIPE;
    case '&':  tok->type = T_AMP;     tok->str = s; lexpos++; return T_AMP;
    case ';':  tok->type = T_SEMI;    tok->str = s; lexpos++; return T_SEMI;
    case '<':  tok->type = T_LESS;    tok->str = s; lexpos++; return T_LESS;
    case '>':  tok->type = T_GREAT;   tok->str = s; lexpos++; return T_GREAT;
    case '(':  tok->type = T_LPAREN;  tok->str = s; lexpos++; return T_LPAREN;
    case ')':  tok->type = T_RPAREN;  tok->str = s; lexpos++; return T_RPAREN;
    case '{':  tok->type = T_LBRACE;  tok->str = s; lexpos++; return T_LBRACE;
    case '}':  tok->type = T_RBRACE;  tok->str = s; lexpos++; return T_RBRACE;
    case '!':  tok->type = T_BANG;    tok->str = s; lexpos++; return T_BANG;
    case '\n': tok->type = T_NEWLINE; tok->str = s; lexpos++; return T_NEWLINE;
    }

    /* word - collect until whitespace or metacharacter */
    tok->type = T_WORD;
    tok->str = s;
    while (*lexpos && *lexpos != ' ' && *lexpos != '\t' && !is_meta(*lexpos)) {
        if (*lexpos == '$' && lexpos[1] == '(') {
            /*
             * $(...) and $((...)) hold parens that are ordinary metacharacters
             * elsewhere, so absorb the whole construct into the word by depth
             * rather than letting the '(' end it. Expansion handles it later.
             */
            int depth = 1;
            lexpos += 2;
            if (*lexpos == '(') { lexpos++; depth = 2; }
            while (*lexpos && depth > 0) {
                if (*lexpos == '(') depth++;
                else if (*lexpos == ')') depth--;
                lexpos++;
            }
        } else if (*lexpos == '$' && lexpos[1] == '{') {
            /* ${NAME}: absorb through the closing brace */
            lexpos += 2;
            while (*lexpos && *lexpos != '}')
                lexpos++;
            if (*lexpos == '}')
                lexpos++;
        } else if (*lexpos == '\\' && lexpos[1]) {
            lexpos += 2;    /* skip escaped char */
        } else if (*lexpos == '\'') {
            lexpos++;   /* skip opening quote */
            while (*lexpos && *lexpos != '\'')
                lexpos++;
            if (*lexpos == '\'')
                lexpos++;
        } else if (*lexpos == '"') {
            lexpos++;   /* skip opening quote */
            while (*lexpos && *lexpos != '"') {
                if (*lexpos == '\\' && lexpos[1])
                    lexpos++;
                lexpos++;
            }
            if (*lexpos == '"')
                lexpos++;
        } else {
            lexpos++;
        }
    }

    int len = lexpos - s;

    /*
     * Copy the word to stable storage rather than pointing into linebuf.
     * A word that abuts a metacharacter, as the "cond" in "cond; then",
     * then keeps its own terminator without clobbering the metacharacter the
     * next token still needs. node_alloc draws from the arena, or from malloc
     * inside a funcdef, matching how the rest of the tree is owned. The
     * delimiter is left in place; the next scan skips leading whitespace.
     */
    tok->str = node_alloc(len + 1);
    memcpy(tok->str, s, len);
    tok->str[len] = '\0';

    /* check for keywords. quoted strings won't match these keywords. */
    if (len == 2 && !memcmp(s, "if", 2)) {
        return tok->type = T_IF;
    } else if (len == 4 && !memcmp(s, "then", 4)) {
        return tok->type = T_THEN;
    } else if (len == 4 && !memcmp(s, "else", 4)) {
        return tok->type = T_ELSE;
    } else if (len == 4 && !memcmp(s, "elif", 4)) {
        return tok->type = T_ELIF;
    } else if (len == 2 && !memcmp(s, "fi", 2)) {
        return tok->type = T_FI;
    } else if (len == 3 && !memcmp(s, "for", 3)) {
        return tok->type = T_FOR;
    } else if (len == 2 && !memcmp(s, "in", 2)) {
        return tok->type = T_IN;
    } else if (len == 5 && !memcmp(s, "while", 5)) {
        return tok->type = T_WHILE;
    } else if (len == 4 && !memcmp(s, "case", 4)) {
        return tok->type = T_CASE;
    } else if (len == 4 && !memcmp(s, "esac", 4)) {
        return tok->type = T_ESAC;
    } else if (len == 2 && !memcmp(s, "do", 2)) {
        return tok->type = T_DO;
    } else if (len == 4 && !memcmp(s, "done", 4)) {
        return tok->type = T_DONE;
    }

    return T_WORD;
}

/*
 * next_token - advance to the next token, return its type.
 * The token is stored in cur_tok.
 */
static int
next_token(void)
{
    if (have_peek) {
        cur_tok = peek_tok;
        have_peek = 0;
        return cur_tok.type;
    }
    return lex_one(&cur_tok);
}

/*
 * peek_token - look at the next token without consuming it.
 * Returns the token type.
 */
static int
peek_token(void)
{
    if (!have_peek) {
        lex_one(&peek_tok);
        have_peek = 1;
    }
    return peek_tok.type;
}

/*
 * expect - consume a token of the given type, or die
 */
static void
expect(int type, const char *reason)
{
    next_token();
    if (cur_tok.type != type)
        syntaxerror(reason ? reason : "expected token is missing");
}

/*****************************************************************************
 * Symbol table - functions, etc
 ****************************************************************************/

static struct func *
newfunc(const char *name, struct node *body)
{
    struct func *f = malloc(sizeof(*f));
    f->name = xstrdup(name);
    f->body = body;
    delfunc(name);
    f->next = func_head;
    return func_head = f;
}

static struct func *
findfunc(const char *name)
{
    struct func *cur = func_head;
    while (cur) {
        if (strcmp(cur->name, name) == 0) return cur;
        cur = cur->next;
    }
    return NULL;
}

static void
freefunc(struct func *func)
{
    free(func->name);
    func->name = NULL;
    freetree(func->body);
    func->body = NULL;
    free(func);
}

static int
delfunc(const char *name)
{
    struct func **last = &func_head, *cur;

    while ((cur = *last)) {
        if (strcmp(cur->name, name) == 0) {
            *last = cur->next;
            cur->next = NULL;
            freefunc(cur);
            return 1;
        }
        last = &(*last)->next;
    }

    return 0; /* not found */
}

/*****************************************************************************
 * Variables and environment
 ****************************************************************************/

static struct var *
alloc_var(const char *var, const char *value)
{
    size_t varlen = strlen(var) + 1;
    size_t valuelen = strlen(value) + 1;
    struct var *v = malloc(sizeof(*v) + varlen + valuelen);
    v->next = NULL;
    memcpy(v->data, var, varlen);
    memcpy(v->data + varlen, value, valuelen);
    return v;
}

static void
free_var(struct var *v)
{
    free(v);
}

static inline void
extract_var(struct var *v, const char **var_out, const char **value_out)
{
    const char *data = v->data;
    if (var_out) *var_out = data;
    size_t varlen = strlen(data);
    if (value_out) *value_out = data + varlen + 1;
}

/*
 *
 */
static void
push_local_var_frame(void)
{
    if (!var_frame_head) { die("bug in var_frame"); return; }
    struct var_frame *frame = malloc(sizeof(*frame));
    frame->head = NULL;
    frame->next = var_frame_head;
    var_frame_head = frame;
}

/*
 *
 */
static void
pop_local_var_frame(void)
{
    struct var_frame *frame = var_frame_head;
    if (frame == &var_frame_global) return; /* refuse to destroy global frame */
    if (!var_frame_head) { die("bug in var_frame"); return; }

    var_frame_head = frame->next; /* unlink */
    frame->next = NULL;

    /* free vars */
    struct var *var;
    while ((var = frame->head)) {
        struct var *next = var->next;
        free_var(var);
        frame->head = next;
    }
    free(frame);
}

/*
 * _set_frame_var - internal function to set a variable in a frame.
 */
static void
_set_frame_var(const char *var, const char *value, struct var_frame *frame)
{
    struct var **last = &frame->head, *cur;
    const char *name;
    struct var *newvar = alloc_var(var, value);

    while ((cur = *last)) {
        extract_var(cur, &name, NULL);
        if (strcmp(name, var) == 0) {
            /* replace cur with newvar */
            *last = newvar;
            newvar->next = cur->next;
            cur->next = NULL;
            free_var(cur);
            return;
        }
        last = &(*last)->next;
    }

    /* not found - so we can insert it into the frame. */
    newvar->next = frame->head;
    frame->head = newvar;
}

/*
 * set_local_var - write variable to the local frame
 */
static void
set_local_var(const char *var, const char *value)
{
    _set_frame_var(var, value, var_frame_head);
}

/*
 * get_var - walk frames and find a variable's value.
 *
 * return NULL if the variable is not found.
 */
static const char *
get_var(const char *var)
{
    struct var_frame *frame;

    for (frame = var_frame_head; frame; frame = frame->next) {
        struct var *v;
        for (v = frame->head; v; v = v->next) {
            const char *name, *value;
            extract_var(v, &name, &value);
            if (strcmp(name, var) == 0)
                return value;
        }
    }

    return NULL;
}

/*
 * find_var_frame - the innermost frame that already defines var, or NULL.
 */
static struct var_frame *
find_var_frame(const char *var)
{
    struct var_frame *frame;

    for (frame = var_frame_head; frame; frame = frame->next) {
        struct var *v;
        for (v = frame->head; v; v = v->next) {
            const char *name;
            extract_var(v, &name, NULL);
            if (strcmp(name, var) == 0)
                return frame;
        }
    }

    return NULL;
}

/*
 * set_var - assign to var where it is already defined, else create it global.
 *
 * A plain assignment updates a variable in the nearest frame that already
 * holds it, so an assignment after "local x" writes the local rather than a
 * global. A name not declared anywhere lands in the global frame, so ordinary
 * assignments outside a function stay global as before.
 */
static void
set_var(const char *var, const char *value)
{
    struct var_frame *frame = find_var_frame(var);

    _set_frame_var(var, value, frame ? frame : &var_frame_global);
}

/*****************************************************************************
 * Arithmetic evaluation for $(( expr ))
 *
 * A small recursive-descent integer evaluator. Precedence, high to low:
 * unary +/-, * / %, binary + -, relational < <= > >=, equality == !=.
 * A bare identifier is a variable reference (its value read with get_var and
 * parsed as an integer, 0 if unset). Division or modulo by zero yields 0.
 * Parsing stops at the first character it cannot consume, e.g. the ')' that
 * closes the expression, so the caller need not pre-terminate the substring.
 ****************************************************************************/
static const char *arith_p;

static void
arith_skip(void)
{
    while (*arith_p == ' ' || *arith_p == '\t')
        arith_p++;
}

static int arith_expr(void);

static int
arith_primary(void)
{
    int v;

    arith_skip();
    if (*arith_p == '(') {
        arith_p++;
        v = arith_expr();
        arith_skip();
        if (*arith_p == ')')
            arith_p++;
        return v;
    }
    if (*arith_p == '-') {
        arith_p++;
        return -arith_primary();
    }
    if (*arith_p == '+') {
        arith_p++;
        return arith_primary();
    }
    if (isdigit((unsigned char)*arith_p)) {
        v = 0;
        while (isdigit((unsigned char)*arith_p)) {
            v = v * 10 + (*arith_p - '0');
            arith_p++;
        }
        return v;
    }
    if (isalpha((unsigned char)*arith_p) || *arith_p == '_') {
        char name[MAXVARNAME];
        int i = 0;
        const char *val;

        while ((isalnum((unsigned char)*arith_p) || *arith_p == '_')
               && i < MAXVARNAME - 1)
            name[i++] = *arith_p++;
        name[i] = '\0';
        val = get_var(name);
        return val ? atoi(val) : 0;
    }
    return 0;
}

static int
arith_mul(void)
{
    int v = arith_primary(), d;

    for (;;) {
        arith_skip();
        if (*arith_p == '*') {
            arith_p++;
            v *= arith_primary();
        } else if (*arith_p == '/') {
            arith_p++;
            d = arith_primary();
            v = d ? v / d : 0;
        } else if (*arith_p == '%') {
            arith_p++;
            d = arith_primary();
            v = d ? v % d : 0;
        } else
            break;
    }
    return v;
}

static int
arith_add(void)
{
    int v = arith_mul();

    for (;;) {
        arith_skip();
        if (*arith_p == '+') {
            arith_p++;
            v += arith_mul();
        } else if (*arith_p == '-') {
            arith_p++;
            v -= arith_mul();
        } else
            break;
    }
    return v;
}

static int
arith_rel(void)
{
    int v = arith_add();

    for (;;) {
        arith_skip();
        if (arith_p[0] == '<' && arith_p[1] == '=') {
            arith_p += 2;
            v = v <= arith_add();
        } else if (arith_p[0] == '>' && arith_p[1] == '=') {
            arith_p += 2;
            v = v >= arith_add();
        } else if (arith_p[0] == '<') {
            arith_p++;
            v = v < arith_add();
        } else if (arith_p[0] == '>') {
            arith_p++;
            v = v > arith_add();
        } else
            break;
    }
    return v;
}

static int
arith_expr(void)
{
    int v = arith_rel();

    for (;;) {
        arith_skip();
        if (arith_p[0] == '=' && arith_p[1] == '=') {
            arith_p += 2;
            v = v == arith_rel();
        } else if (arith_p[0] == '!' && arith_p[1] == '=') {
            arith_p += 2;
            v = v != arith_rel();
        } else
            break;
    }
    return v;
}

static int
arith_eval(const char *expr)
{
    arith_p = expr;
    return arith_expr();
}

/*****************************************************************************
 * Command substitution $(command)
 ****************************************************************************/
#define CMDSUB_MAX 4096

/*
 * Run shell text and capture its stdout, for $(command). The text is parsed
 * into a tree (the lexer no longer mutates its input, so it can scan this
 * string directly), then run with fd 1 redirected into a pipe. The output is
 * capped at CMDSUB_MAX bytes with trailing newlines stripped, as command
 * substitution requires. It runs synchronously, so a command whose output
 * exceeds the pipe buffer before it exits would hang; substitutions are meant
 * to be small.
 */
static char *
capture_command(const char *text)
{
    char *save_lexpos = lexpos;
    struct token save_cur = cur_tok, save_peek = peek_tok;
    int save_have = have_peek;
    struct node *tree;
    char *out;
    int p[2], total = 0, r;

    /* parse the substitution text with a saved/restored lexer state */
    lexpos = (char *)text;
    have_peek = 0;
    tree = p_list();
    lexpos = save_lexpos;
    cur_tok = save_cur;
    peek_tok = save_peek;
    have_peek = save_have;

    out = arena_alloc(CMDSUB_MAX);
    out[0] = '\0';
    if (pipe(p) < 0)
        return out;

#if defined(SKJEGG)
    {
        struct node *inner = tree;
        char chunk[512];

        while (inner != NULL && inner->type == N_REDIR)
            inner = inner->redir.cmd;
        if (inner != NULL && inner->type == N_CMD) {
            /*
             * The common case, a simple command: spawn it with its stdout on
             * the pipe and drain the pipe as the child writes, keeping the
             * first CMDSUB_MAX bytes and discarding the rest. Draining as we go
             * means a child with large output never blocks on a full pipe while
             * the shell waits, so there is no deadlock at any output size.
             */
            struct fdplan pl;
            unsigned h;

            fdplan_init(&pl);
            pl.fd[1] = p[1];
            h = sk_spawn_stage(tree, &pl);
            close(p[1]);
            while ((r = read(p[0], chunk, sizeof chunk)) > 0) {
                int room = CMDSUB_MAX - 1 - total;
                if (room > 0) {
                    int nb = r < room ? r : room;
                    memcpy(out + total, chunk, (unsigned)nb);
                    total += nb;
                }
            }
            close(p[0]);
            if (h)
                jsh_wait_for((int)h);
        } else {
            /*
             * A compound body (a list or pipeline): route each spawned
             * command's stdout through the cmdsub_out_fd hook and run it
             * synchronously. The output must fit the pipe buffer here, since the
             * shell waits before reading. Save and restore the hook so a nested
             * $() cannot clobber this capture.
             */
            int saved = cmdsub_out_fd;

            cmdsub_out_fd = p[1];
            execute_tree(tree, 0);
            cmdsub_out_fd = saved;
            close(p[1]);
            while (total < CMDSUB_MAX - 1 &&
                   (r = read(p[0], out + total, CMDSUB_MAX - 1 - total)) > 0)
                total += r;
            close(p[0]);
        }
    }
#else
    {
        int save1 = dup(1);
        close(1);
        dup(p[1]);		/* fd 1 -> pipe write end */
        close(p[1]);

        execute_tree(tree, 0);

        close(1);		/* drop the write end so the reader sees EOF */
        dup(save1);
        close(save1);
    }

    while (total < CMDSUB_MAX - 1 &&
           (r = read(p[0], out + total, CMDSUB_MAX - 1 - total)) > 0)
        total += r;
    close(p[0]);
#endif

    while (total > 0 && out[total - 1] == '\n')
        total--;			/* strip trailing newlines */
    out[total] = '\0';
    return out;
}

/*
 * expand_string - expand variables and process quoting in a word.
 *
 * Quoting rules:
 * - Single quotes '...' — copy literally, no expansion
 * - Double quotes "..." — expand $var inside, literal everything else
 * - Backslash \x — copy x literally (outside single quotes)
 * - $NAME, ${NAME} — expand variable
 * - $? — last exit status
 * - $$ — shell pid
 * - $0-$9, ${N} — positional parameters ($0 is the shell or function name)
 * - $#, ${#} — number of positional parameters
 * - $@ / $* — all positional parameters (field-split when unquoted; emitted
 *   directly rather than through a single value, since they span several words)
 * - $(cmd) — command substitution; $((expr)) — arithmetic
 * - $NAME, ${NAME} — shell variable
 * - Everything else — copy through
 *
 * Returns arena-allocated expanded string.
 */
static char *
expand_core(const char *start, char **maskp)
{
    unsigned baselen = 256, plen;
    char *base, *mask, *p;
    const char *s;
    unsigned quoting; /* 0 = no quote, 1 = single quote, 2 = double quote */
    char name_buf[MAXVARNAME];
    char num_buf[12]; /* enough for "-2147483648\0" */
    const char *value;
    int namelen;

restart:
    s = start;
    base = arena_alloc(baselen);
    mask = maskp ? arena_alloc(baselen) : NULL;
    p = base;
    plen = baselen;
    quoting = 0;
    /*
     * EMITF records, alongside each byte, whether it may be split on IFS:
     * only bytes from an unquoted expansion (flag 1). Literal and quoted bytes
     * (flag 0) never split. Callers that do not split pass maskp NULL.
     */
#define NEED(n) do { if (plen <= (unsigned)(n)) { baselen *= 2; goto restart; } } while(0)
#define EMITF(c, f) do { NEED(1); if (mask) mask[p - base] = (f); *p++ = (c); plen--; } while(0)
#define EMIT(c) EMITF((c), 0)

    while (*s) {
        /* single quote toggle — not inside double quotes */
        if (*s == '\'' && quoting != 2) {
            quoting = (quoting == 1) ? 0 : 1;
            s++;
        } else if (*s == '"' && quoting != 1) { /* double quote toggle — not inside single quotes */
            quoting = (quoting == 2) ? 0 : 2;
            s++;
        } else if (quoting == 1) { /* inside single quotes, everything is literal */
            EMIT(*s);
            s++;
        } else if (*s == '\\' && s[1]) { /* backslash escape — outside single quotes */
            s++;
            EMIT(*s);
            s++;
        } else if (*s == '$') { /* variable expansion */
            s++;
            value = NULL;

            if (*s == '?') {
                /* $? — last exit status */
                snprintf(num_buf, sizeof(num_buf), "%d", last_status);
                value = num_buf;
                s++;
            } else if (*s == '$') {
                /* $$ — shell pid */
                snprintf(num_buf, sizeof(num_buf), "%d", (int)getpid());
                value = num_buf;
                s++;
            } else if (s[0] == '(' && s[1] == '(') {
                /* $((expr)) — arithmetic. Evaluate, then skip past the
                 * matching )) by tracking paren depth from 2. */
                int depth = 2;
                s += 2;
                snprintf(num_buf, sizeof(num_buf), "%d", arith_eval(s));
                value = num_buf;
                while (*s && depth > 0) {
                    if (*s == '(') depth++;
                    else if (*s == ')') depth--;
                    s++;
                }
            } else if (*s == '(') {
                /* $(cmd) — command substitution: run cmd, insert its output */
                int depth = 1;
                const char *cstart;
                char *ctext;
                int clen;

                s++;			/* past '(' */
                cstart = s;
                while (*s && depth > 0) {
                    if (*s == '(') depth++;
                    else if (*s == ')') { if (--depth == 0) break; }
                    s++;
                }
                clen = s - cstart;
                ctext = arena_alloc(clen + 1);
                memcpy(ctext, cstart, clen);
                ctext[clen] = '\0';
                if (*s == ')') s++;	/* consume ')' */
                value = capture_command(ctext);
            } else if (*s == '#') {
                /* $# — number of positional parameters */
                snprintf(num_buf, sizeof(num_buf), "%d", pos_nparams);
                value = num_buf;
                s++;
            } else if (*s == '@' || *s == '*') {
                /* $@ / $* — all positional parameters, space separated */
                int k, f = (quoting == 0) ? 1 : 0;

                for (k = 0; k < pos_nparams; k++) {
                    const char *pp = pos_params[k];

                    if (k > 0) EMITF(' ', f);
                    while (*pp) { EMITF(*pp, f); pp++; }
                }
                s++;
                continue;		/* emitted directly, nothing to append */
            } else if (isdigit((unsigned char)*s)) {
                /* $0 is the shell/function name; $1..$9 are positional */
                int idx = *s - '0';

                s++;
                value = (idx == 0) ? pos_zero
                    : (idx <= pos_nparams ? pos_params[idx - 1] : NULL);
            } else if (*s == '{') {
                /* ${NAME}, ${N}, ${#}, ${@} */
                s++;
                const char *ns = s;
                while (*s && *s != '}')
                    s++;
                namelen = s - ns;
                if (namelen >= MAXVARNAME) namelen = MAXVARNAME - 1;
                memcpy(name_buf, ns, namelen);
                name_buf[namelen] = '\0';
                if (*s == '}') s++;
                if (name_buf[0] == '#') {
                    snprintf(num_buf, sizeof(num_buf), "%d", pos_nparams);
                    value = num_buf;
                } else if (name_buf[0] == '@' || name_buf[0] == '*') {
                    int k, f = (quoting == 0) ? 1 : 0;

                    for (k = 0; k < pos_nparams; k++) {
                        const char *pp = pos_params[k];

                        if (k > 0) EMITF(' ', f);
                        while (*pp) { EMITF(*pp, f); pp++; }
                    }
                    continue;
                } else if (isdigit((unsigned char)name_buf[0])) {
                    int idx = atoi(name_buf);

                    value = (idx == 0) ? pos_zero
                        : (idx <= pos_nparams ? pos_params[idx - 1] : NULL);
                } else {
                    value = get_var(name_buf);
                }
            } else if (isalpha(*s) || *s == '_') {
                /* $NAME */
                const char *ns = s;
                while (isalnum(*s) || *s == '_')
                    s++;
                namelen = s - ns;
                if (namelen >= MAXVARNAME) namelen = MAXVARNAME - 1;
                memcpy(name_buf, ns, namelen);
                name_buf[namelen] = '\0';
                value = get_var(name_buf);
            } else {
                /* bare $ at end or before non-name char — literal $ */
                EMIT('$');
                continue;
            }

            if (value) {
                int vlen = strlen(value), vi;
                int f = (quoting == 0) ? 1 : 0;

                for (vi = 0; vi < vlen; vi++)
                    EMITF(value[vi], f);
            }
        } else {
            /* ordinary character */
            EMIT(*s);
            s++;
        }
    }

    NEED(0); /* ensure room for nul */
    *p = '\0';
    if (mask)
        mask[p - base] = 0;

#undef NEED
#undef EMITF
#undef EMIT

    if (maskp)
        *maskp = mask;
    return base;
}

/* expand a word to a single joined string (no field splitting) */
static char *
expand_string(const char *s)
{
    return expand_core(s, NULL);
}

/* the current field-splitting set: $IFS, or space/tab/newline by default */
static const char *
cur_ifs(void)
{
    const char *v = get_var("IFS");

    return v != NULL ? v : " \t\n";
}

static int
is_ifs(char c, const char *ifs)
{
    return c != '\0' && strchr(ifs, c) != NULL;
}

/*
 * Expand s and split the result into fields on IFS, appending each to argv.
 * Only bytes from an unquoted expansion may split, so quoted or literal IFS
 * characters stay within a field. A word that expands to nothing yields no
 * field, except one written with quotes ("" and "$empty" still give one empty
 * field). Runs of splittable IFS collapse and bound the fields.
 */
static void
expand_fields(const char *s, char **argv, int *argc, int max)
{
    char *mask, *exp;
    const char *ifs;
    int i = 0, produced = 0;

    exp = expand_core(s, &mask);
    ifs = cur_ifs();

    while (exp[i]) {
        int start;

        while (exp[i] && mask[i] && is_ifs(exp[i], ifs))
            i++;			/* skip a run of splittable IFS */
        if (!exp[i])
            break;
        start = i;
        while (exp[i] && !(mask[i] && is_ifs(exp[i], ifs)))
            i++;
        if (*argc < max) {
            int len = i - start;
            char *w = arena_alloc(len + 1);

            memcpy(w, exp + start, len);
            w[len] = '\0';
            argv[(*argc)++] = w;
            produced = 1;
        }
    }

    /* a quoted word that expanded to empty is still one (empty) field */
    if (!produced && exp[0] == '\0' &&
        (strchr(s, '"') != NULL || strchr(s, '\'') != NULL) && *argc < max)
        argv[(*argc)++] = exp;
}

/*
 * expand_args - process variable expansion on all arguments
 *
 * updated argv[] in-place. This function won't free() any arguments it replaces.
 *
 * return 0 on success, -1 on failure.
 * return new NULL-terminated argv on success. (allocated from arena)
 * updated argc with new count.
 *
 */
static char **
expand_args(int *argcp, char **argv_in)
{
    int i, argc_in = *argcp, argc = 0;
    char **base, **out;

    /*
     * Expand into a fresh array, leaving the input (the AST node's argv)
     * untouched. A command re-run in a loop body must expand its $vars again
     * each pass, so the template with "$x" cannot be overwritten in place.
     * Each input word may split into several fields on IFS, so size for
     * MAXARGS. base[0] is the spare slot the exec path may fill with /bin/sh.
     */
    base = node_alloc(sizeof(*base) * (MAXARGS + 2));
    out = base + 1;
    base[0] = NULL;
    for (i = 0; i < argc_in && argc < MAXARGS; i++)
        expand_fields(argv_in[i], out, &argc, MAXARGS);
    out[argc] = NULL;
    *argcp = argc;
    return out;
}

/*****************************************************************************
 * Task launcher and job manager
 ****************************************************************************/
static int
lookup_builtin(const char *cmd)
{
    int i;
    for (i = 0; i < (int)(sizeof(builtin_list) / sizeof(*builtin_list)); i++) {
        if (strcmp(builtin_list[i], cmd) == 0) {
            return i;
        }
    }
    /* Functions are not built-ins: execute_tree resolves a defined function
     * (findfunc) after this returns -1, so a function shadows an external
     * command but not a built-in. */
    return -1;
}

static int
try_builtin(char *argv[])
{
    int id = lookup_builtin(argv[0]);
    if (id < 0) return 0; /* not a built-in */

    switch ((enum builtin)id) {
    case B_EXIT: /* built-in command: exit [n] */
        last_status = argv[1] ? atoi(argv[1]) : 0;
        last_line = 1;
        break;
    case B_CD: /* built-in command: cd */
        if (argv[1]) {
            if (chdir(argv[1]) < 0) {
                perror(argv[1]);
                last_status = 1;
            }
        } else {
            puts("usage: cd <directory>");
        }
        break;
    case B_BREAK:    /* break [n]: exit the n innermost enclosing loops */
    case B_CONTINUE: /* continue [n]: skip to the next pass of the nth loop */
        if (loop_depth == 0) {
            write(STDOUT_FILENO, argv[0], (long)strlen(argv[0]));
            puts(": only meaningful in a loop");
            last_status = 1;
        } else {
            int n = argv[1] ? atoi(argv[1]) : 1;
            if (n < 1)
                n = 1;
            if (n > loop_depth)
                n = loop_depth;
            loop_ctl = (id == B_BREAK) ? LC_BREAK : LC_CONTINUE;
            loop_ctl_count = n;
            last_status = 0;
        }
        break;
    case B_RETURN: /* return [n]: leave the current function with status n */
        if (func_depth == 0) {
            write(STDOUT_FILENO, argv[0], (long)strlen(argv[0]));
            puts(": only meaningful in a function");
            last_status = 1;
        } else {
            /* no argument returns the status of the last command run */
            func_return_status = argv[1] ? atoi(argv[1]) : last_status;
            func_return = 1;
            last_status = func_return_status;
        }
        break;
    case B_LOCAL: /* local NAME[=value] ...: declare vars in the function frame */
        if (func_depth == 0) {
            write(STDOUT_FILENO, argv[0], (long)strlen(argv[0]));
            puts(": only meaningful in a function");
            last_status = 1;
        } else {
            int i;
            for (i = 1; argv[i]; i++) {
                char *eq = strchr(argv[i], '=');
                if (eq) {
                    *eq = '\0';                     /* split NAME from value */
                    set_local_var(argv[i], eq + 1);
                    *eq = '=';                      /* leave the word intact */
                } else {
                    set_local_var(argv[i], "");     /* declare, shadow, empty */
                }
            }
            last_status = 0;
        }
        break;
    case B_KILL: /* kill HANDLE [status]: terminate a child the shell spawned */
#ifdef SKJEGG
        if (argv[1]) {
            unsigned status = argv[2] ? (unsigned)atoi(argv[2]) : 1u;
            skj_kill((unsigned)atoi(argv[1]), status);
            last_status = 0;
        } else {
            puts("usage: kill handle [status]");
            last_status = 1;
        }
#else
        puts("kill: not supported in this build");
        last_status = 1;
#endif
        break;
    }

    return 1;
}

#ifdef JOS
/*
 * On JOS there is no fork/exec: a command runs by spawning a fresh program
 * image (the kernel resolves a bare name against /bin, else the built-in
 * registry). jsh_launch starts one and jsh_wait_one reaps a child, returning
 * a synthetic wstatus so the shared status helpers keep working. await reaps
 * any child, which is all a synchronous foreground command needs.
 */
static pid_t
jsh_launch(char **argv)
{
    int pid = spawn(argv[0], argv);

    if (pid < 0) {
        write(STDOUT_FILENO, argv[0], (long)strlen(argv[0]));
        puts(": not found");
    }
    return pid;
}

static int
jsh_wait_one(void)
{
    char status[128];
    int pid = await(status, sizeof status);

    if (pid < 0)
        return 0;
    return status[0] ? (1 << 8) : 0;	/* nonempty exit string = failure */
}

/*
 * Wait for one specific foreground child, reaping any background jobs that
 * finish first. await reaps whichever child is ready, so loop until the wanted
 * pid comes back and drop the others; they were backgrounded and the shell does
 * not report their status here. Returns a synthetic wstatus for the wanted pid.
 */
static int
jsh_wait_for(int pid)
{
    char status[128];
    int got;

    for (;;) {
        got = await(status, sizeof status);
        if (got < 0)
            return 0;	/* no children left, or a note woke us */
        if (got == pid)
            return status[0] ? (1 << 8) : 0;
    }
}

/* Collect any finished background jobs without blocking (called at the prompt) */
static void
drain_background(void)
{
    while (reap() > 0)
        ;
}
#elif defined(SKJEGG)
/*
 * skjegg: spawn a fresh sandbox per command. There is no fork and no fd
 * inheritance, so a child's 0/1/2 come from an explicit fd map the shell fills
 * from its own descriptors. The program image is read from a file (a bare name
 * resolves against the bin: mount) into a buffer the host marshals into the new
 * sandbox. SKJ_SPAWN_FLAG_SHARE_MOUNTS hands the child the shell's namespace so
 * a spawned tool can reach the same files.
 */
/*
 * The spawn descriptor is a row of pointer-width words, so an address field
 * (image, argv, fdmap) holds a guest pointer on either an ILP32 or an LP64
 * guest; the host reads each field at the guest's pointer width. Scalars just
 * occupy a word. `unsigned long` is the pointer width on every target here
 * (4 bytes on rv/cf/mips, 8 on x86-64/arm64).
 */
struct spawn_req {
    unsigned long size;
    unsigned long image;
    unsigned long image_len;
    unsigned long argv;
    unsigned long argc;
    unsigned long flags;
    unsigned long fdmap;
    unsigned long fdmap_n;
};

/* One fd-map entry: the capability index backing a shell fd, and the id the
 * child should see it as. Matches the host's {gfd, dst} wire layout. */
struct fdent {
    unsigned gfd;
    unsigned dst;
};

/* Read a whole file into a malloc'd buffer. Returns the buffer and sets *len,
 * or NULL on any error. The caller frees it after the spawn. */
static void *
slurp_image(const char *path, unsigned *len)
{
    struct stat st;
    char *buf;
    int fd, off = 0, n;

    fd = open(path, O_RDONLY, 0);
    if (fd < 0)
        return NULL;
    if (fstat(fd, &st) < 0 || st.st_size <= 0) {
        close(fd);
        return NULL;
    }
    buf = malloc((unsigned)st.st_size);
    if (!buf) {
        close(fd);
        return NULL;
    }
    while (off < (int)st.st_size &&
           (n = read(fd, buf + off, (int)st.st_size - off)) > 0)
        off += n;
    close(fd);
    if (off != (int)st.st_size) {
        free(buf);
        return NULL;
    }
    *len = (unsigned)st.st_size;
    return buf;
}

/* Resolve a command name to a program-image path. A name that names a mount
 * (has a ':' selector) or starts at a root ('/') is used as is; a bare name is
 * looked up in the bin: mount. */
static const char *
resolve_cmd(const char *name, char *buf, int cap)
{
    int i = 0, j = 0;

    if (strchr(name, ':') || name[0] == '/')
        return name;
    while (j < cap - 1 && "bin:"[j]) {
        buf[j] = "bin:"[j];
        j++;
    }
    while (j < cap - 1 && name[i])
        buf[j++] = name[i++];
    buf[j] = '\0';
    return buf;
}

/* Spawn one simple command with the given fd plan. Returns the child handle,
 * or 0 on failure. A NULL plan gives the child the shell's own 0/1/2. */
static unsigned
sk_spawn(int argc, char **argv, struct fdplan *pl)
{
    char pathbuf[FS_PATH_MAX];
    const char *path;
    struct spawn_req req;
    struct fdent map[3];
    struct fdplan def;
    void *img;
    unsigned len, h;
    int n = 0, k;

    if (!pl) {
        fdplan_init(&def);
        pl = &def;
    }
    path = resolve_cmd(argv[0], pathbuf, sizeof pathbuf);
    img = slurp_image(path, &len);
    if (!img)
        return 0;

    for (k = 0; k < 3; k++) {
        int pfd, gfd;

        if (pl->fd[k] >= 0)
            pfd = pl->fd[k];                /* a redirect or pipe placed it */
        else if (k == 1 && cmdsub_out_fd >= 0)
            pfd = cmdsub_out_fd;            /* capturing stdout for $(...) */
        else
            pfd = k;                        /* the shell's own descriptor */

        if (fs_fd_backing(pfd, &gfd) == 0) {
            map[n].gfd = (unsigned)gfd;
            map[n].dst = (unsigned)k;
            n++;
        }
    }

    req.size = sizeof req;
    req.image = (unsigned long)img;
    req.image_len = len;
    req.argv = (unsigned long)argv;
    req.argc = (unsigned long)argc;
    req.flags = SKJ_SPAWN_FLAG_SHARE_MOUNTS;
    req.fdmap = (unsigned long)map;
    req.fdmap_n = (unsigned long)n;
    h = skj_spawnv(&req);
    free(img);
    return h;
}

static pid_t
jsh_launch(int argc, char **argv)
{
    unsigned h = sk_spawn(argc, argv, NULL);

    if (h == 0) {
        write(STDOUT_FILENO, argv[0], (long)strlen(argv[0]));
        puts(": not found");
        return -1;
    }
    return (pid_t)h;
}

/*
 * Wait for one specific child and return a synthetic wstatus. On the parking
 * cores skj_wait blocks until the child exits; on a core that cannot park it
 * reports WOULDBLOCK, so retry after yielding. A stale handle reads as success.
 */
static int
jsh_wait_for(int h)
{
    for (;;) {
        unsigned st = skj_wait((unsigned)h);

        if (st == SKJ_WAIT_WOULDBLOCK) {
            sched_yield();
            continue;
        }
        if (st == SKJ_WAIT_BADHANDLE)
            return 0;
        return (int)((st & 0xffu) << 8);
    }
}

/* No non-blocking reap in this model; a backgrounded child is cleaned up when
 * the shell exits. The prompt-time drain is therefore a no-op. */
static void
drain_background(void)
{
}
#else
/*
 * tryexec - tries to execute a program then again as a shell script
 *
 * if your argv[0] = "/usr/bin/prog", the first step is to execute that file directly.
 *   execve("/usr/bin/prog", { "/usr/bin/prog", NULL }, environ);
 * failing that, it prefixes with /bin/sh :
 *   execve("/bin/sh", { "/bin/sh", "/usr/bin/prog", NULL }, environ);
 *
 * return: this function does not return on success (it exec's).
 *
 * WARNING: this function assumes you have an extra argv[] entry allocated so you can prefix /bin/sh to it
 */
static void
tryexec(const char *file, char **argv, char **envp)
{
    static const char * const sh = _PATH_BSHELL;

    execve(file, argv, envp ? envp : environ);
    if (errno == ENOEXEC) {
        /* prepend /bin/sh to argv and try again */
        *argv-- = (char*)file;
        *argv = (char*)sh;
        execve(sh, argv, envp ? envp : environ);
    }
}

/*
 * shellexec - search PATH, executing programs, stopping at the first successful exec()
 *
 * return: this function does not return on success (it exec's).
 *
 */
static void
shellexec(char **argv, const char *path)
{
    if (!path) { errno = EINVAL; return; }

    /* do not search paths if filename already includes a directory part */
    if (strchr(argv[0], '/')) {
        tryexec(argv[0], argv, environ);
        return;
    }

    while (path && padvance(&path, argv[0]) >= 0)
        tryexec(filename_buf, argv, environ);

    if (!errno) errno = ENOENT;
}

/*
 * spawn - fork/execv
 *
 * returns child process id (pid).
 */
static pid_t
spawn(int argc, char *argv[], int forked_flag)
{
    pid_t child;

    (void)argc;

    if (forked_flag)
        child = getpid();
    else
        child = fork();

    if (child < 0) {
        perror("fork()");
    } else if (!child || forked_flag) {
        const char *path = getenv("PATH");
        shellexec(argv, path);
        perror(argv[0]);
        _exit(127);
    }
    return child;
}

/* Collect any finished background jobs without blocking (called at the prompt) */
static void
drain_background(void)
{
    int status;

    while (waitpid(-1, &status, WNOHANG) > 0)
        ;
}
#endif /* !JOS */

static void
report_status(pid_t pid, int wstatus)
{
    if (silent_command_count) return;
    if (WIFEXITED(wstatus)) {
        if (WEXITSTATUS(wstatus))
            printf("(process %d failed with status: %u)\n", (int)pid, WEXITSTATUS(wstatus));
    } else {
        printf("(process %d exited with signal %u)\n", (int)pid, (int)WTERMSIG(wstatus));
    }
}

static int
update_last_status(pid_t pid, int wstatus)
{
    report_status(pid, wstatus);
    return last_status = WIFEXITED(wstatus) ? WEXITSTATUS(wstatus) : 128 + WTERMSIG(wstatus);
}

static int
redir_default_fd(int rtype)
{
    int default_fd;
    switch (rtype) {
    case T_GREAT:
        default_fd = STDOUT_FILENO;
        break;
    case T_DGREAT:
        default_fd = STDOUT_FILENO;
        break;
    case T_LESS:
        default_fd = STDIN_FILENO;
        break;
    case T_DLESS:
        die("<< not supported");
        return -1;
    default:
        die("unsupported redirection");
        return -1;
    }
    return default_fd;
}

#ifdef JOS
/*
 * JOS redirection. No dup2 and no open flags: open with the JOS modes, then
 * bind the result onto the target fd with the close-then-dup trick (dup
 * returns the lowest free fd, which is the target once it is closed, since
 * the shell keeps 0-2 open). '>' truncates by remove+create because QEMU's
 * Tcreate does not truncate an existing file; '>>' seeks to end. This mutates
 * the shell's own fds, so the caller must save and restore around it.
 */
static int
do_redir(struct node *n)
{
    int target, f;

    if (!n->redir.file) {
        puts("no filename");
        return -1;
    }
    switch (n->redir.rtype) {
    case T_GREAT:
        target = n->redir.fd < 0 ? STDOUT_FILENO : n->redir.fd;
        remove(n->redir.file);
        f = create(n->redir.file, OWRITE, 0644);
        break;
    case T_DGREAT:
        target = n->redir.fd < 0 ? STDOUT_FILENO : n->redir.fd;
        f = create(n->redir.file, OWRITE, 0644);
        if (f < 0)
            f = open(n->redir.file, OWRITE);
        break;
    case T_LESS:
        target = n->redir.fd < 0 ? STDIN_FILENO : n->redir.fd;
        f = open(n->redir.file, OREAD);
        break;
    case T_DLESS:
        die("<< not supported");
        return -1;
    default:
        die("unsupported redirection");
        return -1;
    }
    if (f < 0) {
        perror(n->redir.file);
        return -1;
    }
    if (f != target) {
        close(target);
        dup(f);			/* lands on target: the lowest free fd */
        close(f);
    }
    if (n->redir.rtype == T_DGREAT)
        seek(target, 0, 2);	/* append: SEEK_END */
    return 0;
}
#elif defined(SKJEGG)
/*
 * skjegg redirection. There is no dup2 and a child does not inherit the shell's
 * fds, so a redirect is not applied to the shell. Instead the target file is
 * opened here and the fd, with the child slot it binds, is threaded into the
 * child's fd plan at spawn. '>' truncates, '>>' appends (the backend honors
 * O_APPEND per write), '<' reads. Only slots 0, 1 and 2 can be placed. Returns
 * the opened fd and sets *slot, or returns -1 on error.
 */
static int
sk_open_redir(struct node *n, int *slot)
{
    int target, f;

    if (!n->redir.file) {
        puts("no filename");
        return -1;
    }
    switch (n->redir.rtype) {
    case T_GREAT:
        target = n->redir.fd < 0 ? STDOUT_FILENO : n->redir.fd;
        f = open(n->redir.file, O_WRONLY | O_CREAT | O_TRUNC, 0644);
        break;
    case T_DGREAT:
        target = n->redir.fd < 0 ? STDOUT_FILENO : n->redir.fd;
        f = open(n->redir.file, O_WRONLY | O_CREAT | O_APPEND, 0644);
        break;
    case T_LESS:
        target = n->redir.fd < 0 ? STDIN_FILENO : n->redir.fd;
        f = open(n->redir.file, O_RDONLY, 0);
        break;
    case T_DLESS:
        puts("jsh: << not supported");
        return -1;
    default:
        puts("jsh: unsupported redirection");
        return -1;
    }
    if (f < 0) {
        perror(n->redir.file);
        return -1;
    }
    if (target < 0 || target > 2) {
        puts("jsh: redirect fd out of range");
        close(f);
        return -1;
    }
    *slot = target;
    return f;
}
#else
static int
do_redir(struct node *n)
{
    int default_fd;
    int newfd = -1;

    if (!n->redir.file) {
        puts("no filename");
        return -1;
    }
    switch (n->redir.rtype) {
    case T_GREAT:
        default_fd = STDOUT_FILENO;
        newfd = open(n->redir.file, O_CREAT | O_WRONLY | O_TRUNC, 0666);
        break;
    case T_DGREAT:
        default_fd = STDOUT_FILENO;
        newfd = open(n->redir.file, O_CREAT | O_WRONLY | O_APPEND, 0666);
        break;
    case T_LESS:
        default_fd = STDIN_FILENO;
        newfd = open(n->redir.file, O_RDONLY, 0666);
        break;
    case T_DLESS:
        die("<< not supported");
        return -1;
    default:
        die("unsupported redirection");
        return -1;
    }
    if (newfd < 0) {
        perror(n->redir.file);
        return -1;
    }

    if (dup2(newfd, n->redir.fd < 0 ? default_fd : n->redir.fd) < 0) {
        perror(n->redir.file);
        close(newfd);
        return -1;
    }

    close(newfd);
    return 0;
}
#endif /* JOS */

#if !defined(JOS) && !defined(SKJEGG)
static int
is_special_builtin(struct node *n)
{
    while (n && n->type == N_REDIR)
        n = n->redir.cmd;
    if (!n || n->type != N_CMD)
        return 0;
    const char *name = n->cmd.argv[0];
    return lookup_builtin(name) >= 0;
}
#endif

#if defined(JOS) || defined(SKJEGG)
/*
 * Flatten a pipe tree into stages in left-to-right order. The parser may nest
 * pipes either way, so recurse both sides rather than assuming a direction.
 * Returns the new stage count.
 */
static int
collect_pipe_stages(struct node *n, struct node **stages, int max, int ns)
{
    if (n == NULL)
        return ns;
    if (n->type == N_PIPE) {
        ns = collect_pipe_stages(n->pipe.left, stages, max, ns);
        ns = collect_pipe_stages(n->pipe.right, stages, max, ns);
        return ns;
    }
    if (ns < max)
        stages[ns++] = n;
    return ns;
}

#ifdef JOS
/*
 * Spawn one pipeline stage. in/out are shell fds to become the stage's stdin
 * and stdout (or -1 to keep the shell's own). The shell rebinds its own fd 0
 * and 1 around the spawn, since a spawned child inherits fds 0-2, then
 * restores them. File redirs wrapping the stage are applied after the pipe
 * fds so an explicit redirect wins. Without fork, a stage must reduce to a
 * simple command; a compound stage is rejected. Returns pid, or -1.
 */
static int
jsh_spawn_stage(struct node *n, int in, int out)
{
    int save0 = -1, save1 = -1, pid;
    struct node *cmd = n;

    if (in >= 0) { save0 = dup(0); close(0); dup(in); }
    if (out >= 0) { save1 = dup(1); close(1); dup(out); }

    while (cmd != NULL && cmd->type == N_REDIR) {
        if (do_redir(cmd) < 0) {
            cmd = NULL;		/* redir failed: abandon this stage */
            break;
        }
        cmd = cmd->redir.cmd;
    }
    if (cmd == NULL) {
        pid = -1;
    } else if (cmd->type != N_CMD) {
        puts("jsh: pipeline stage must be a simple command");
        pid = -1;
    } else {
        int eargc = cmd->cmd.argc;
        char **eargv = expand_args(&eargc, cmd->cmd.argv);
        pid = jsh_launch(eargv);
    }

    if (out >= 0) { close(1); dup(save1); close(save1); }
    if (in >= 0) { close(0); dup(save0); close(save0); }
    return pid;
}
#elif defined(SKJEGG)
/*
 * Walk a stage's N_REDIR chain, opening each target and recording the fd and
 * the slot it binds into the plan. The opened fds are collected so the caller
 * can close them after the spawn. Returns the inner N_CMD node, or NULL on a
 * failed redirect or a non-simple stage.
 */
static struct node *
sk_apply_redirs(struct node *n, struct fdplan *pl, int *openfds, int *nopen)
{
    while (n != NULL && n->type == N_REDIR) {
        int slot, f = sk_open_redir(n, &slot);

        if (f < 0)
            return NULL;
        pl->fd[slot] = f;
        openfds[(*nopen)++] = f;
        n = n->redir.cmd;
    }
    if (n == NULL || n->type != N_CMD) {
        if (n != NULL)
            puts("jsh: pipeline stage must be a simple command");
        return NULL;
    }
    return n;
}

/*
 * Spawn one pipeline stage with the plan the pipe set up (its stdin/stdout
 * bound to the surrounding pipe ends). Stage-local redirects layer on top and
 * win. Returns the child handle, or 0.
 */
static unsigned
sk_spawn_stage(struct node *stage, struct fdplan *base)
{
    struct fdplan pl = *base;
    int openfds[3], nopen = 0, i, eargc;
    struct node *cmd;
    char **eargv;
    unsigned h;

    cmd = sk_apply_redirs(stage, &pl, openfds, &nopen);
    if (cmd == NULL) {
        for (i = 0; i < nopen; i++)
            close(openfds[i]);
        return 0;
    }
    eargc = cmd->cmd.argc;
    eargv = expand_args(&eargc, cmd->cmd.argv);
    h = sk_spawn(eargc, eargv, &pl);
    for (i = 0; i < nopen; i++)
        close(openfds[i]);
    return h;
}
#endif
#endif

/*
 * glob_match - shell pattern match for case patterns.
 *
 * Supports '*' (any run), '?' (one char), and '[...]' sets with ranges and a
 * leading '!' or '^' negation. Anything else matches literally. Returns 1 on
 * a full match of str.
 */
static int
glob_match(const char *pat, const char *str)
{
    while (*pat) {
        if (*pat == '*') {
            pat++;
            if (*pat == '\0')
                return 1;		/* trailing '*' matches the rest */
            while (*str) {
                if (glob_match(pat, str))
                    return 1;
                str++;
            }
            return glob_match(pat, str);	/* try the empty tail */
        } else if (*pat == '?') {
            if (*str == '\0')
                return 0;
            pat++;
            str++;
        } else if (*pat == '[') {
            const char *p = pat + 1;
            int neg = 0, matched = 0;

            if (*p == '!' || *p == '^') {
                neg = 1;
                p++;
            }
            while (*p && *p != ']') {
                if (p[1] == '-' && p[2] && p[2] != ']') {
                    if ((unsigned char)*str >= (unsigned char)p[0] &&
                        (unsigned char)*str <= (unsigned char)p[2])
                        matched = 1;
                    p += 3;
                } else {
                    if (*str == *p)
                        matched = 1;
                    p++;
                }
            }
            if (*p == ']')
                p++;
            if (*str == '\0' || matched == neg)
                return 0;
            pat = p;
            str++;
        } else {
            if (*pat != *str)
                return 0;
            pat++;
            str++;
        }
    }
    return *str == '\0';
}

/*
 * At an enclosing loop, act on a pending break/continue. Returns nonzero if
 * this loop should stop iterating: a break aimed here, or any control aimed at
 * an outer loop (this loop stops and the signal is left set, its count
 * decremented, for the outer loop to see). Returns zero to keep iterating: no
 * signal pending, or a continue aimed at this loop (the signal is cleared).
 */
static int
loop_ctl_stop(void)
{
    int ctl;

    if (loop_ctl == LC_NONE)
        return 0;
    if (loop_ctl_count > 1) {
        loop_ctl_count--;	/* aimed at an outer loop: stop, keep the signal */
        return 1;
    }
    ctl = loop_ctl;
    loop_ctl = LC_NONE;
    loop_ctl_count = 0;
    return ctl == LC_BREAK;
}

/*
 * execute_tree - walks the AST, processing elements.
 *
 * forked_flag is set if we have fork()'d inside an N_REDIR, this prevents the
 * chained N_REDIR or N_CMD from doing an additional fork().
 *
 * return 0 on success, non-zero on error.
 * 127 is an internal error for the shell.
 *
 */
static int
execute_tree(struct node *n, int forked_flag)
{
#if !defined(JOS) && !defined(SKJEGG)
    int pfd[2];
    int wstatus2;
    pid_t pid2;
#endif
    int wstatus;
    pid_t child;
    int rc, body_rc;
    int i;
    struct func *f;

    if (!n) return 0; /* do nothing on an empty tree */

    switch (n->type) {
    case N_CMD: {
        /*
         * A pending & runs this command in the background. Consume the flag at
         * the leaf so it applies only to this command and never leaks into a
         * function body or a re-run loop iteration. Only external commands are
         * backgrounded; a builtin or a function runs in the foreground.
         */
        int bg = bg_pending;
        bg_pending = 0;
        /*
         * Expand into a local argv, leaving the node's template intact so a
         * command re-run in a loop body re-expands its $vars each pass.
         */
        int eargc = n->cmd.argc;
        char **eargv = expand_args(&eargc, n->cmd.argv);

        /* try built-in commands: exit, cd, ... */
        if (try_builtin(eargv))
            return 0;
        /*
         * A defined function shadows an external command of the same name. Run
         * its body as an ordinary list (forked_flag 0): the body is not a single
         * leaf that may exec in place, and if we are already in a forked context
         * (a pipe or subshell child) it still needs each command to fork.
         */
        if (eargv[0] && (f = findfunc(eargv[0])) != NULL) {
            /* run the body with the call's arguments as $1..$n, $0 the name */
            char **save_p = pos_params;
            int save_n = pos_nparams;
            char *save_0 = pos_zero;
            int save_depth = loop_depth;
            int rc;

            pos_zero = eargv[0];
            pos_params = eargv + 1;
            pos_nparams = eargc - 1;
            /* a loop in the body is its own scope; break/continue must not
             * escape into a loop the caller is running */
            loop_depth = 0;
            func_depth++;
            /* a fresh frame holds this call's "local" variables; popping it
             * on return drops them and unshadows the caller's variables */
            push_local_var_frame();
            rc = execute_tree(f->body, 0);
            pop_local_var_frame();
            /* return unwinds to here and sets the function's exit status */
            if (func_return) {
                rc = func_return_status;
                func_return = 0;
            }
            func_depth--;
            loop_ctl = LC_NONE;
            loop_ctl_count = 0;
            loop_depth = save_depth;
            pos_params = save_p;
            pos_nparams = save_n;
            pos_zero = save_0;
            return last_status = rc;
        }
#ifdef JOS
        (void)forked_flag;
        child = jsh_launch(eargv);
        if (child >= 0) {
            if (bg) {
                announce_bg(child);
                return last_status = 0;
            }
            wstatus = jsh_wait_for(child);
            update_last_status(child, wstatus);
            return last_status;
        }
        return 127;
#elif defined(SKJEGG)
        (void)forked_flag;
        child = jsh_launch(eargc, eargv);
        if (child > 0) {
            if (bg) {
                announce_bg(child);
                return last_status = 0;
            }
            wstatus = jsh_wait_for(child);
            update_last_status(child, wstatus);
            return last_status;
        }
        return 127;
#else
        child = spawn(eargc, eargv, forked_flag);
        if (child > 0) {
            if (bg) {
                announce_bg(child);
                return last_status = 0;
            }
            if (waitpid(child, &wstatus, 0) < 0) {
                perror("waitpid()");
                return 0;
            }
            update_last_status(child, wstatus);
            return last_status;
        }
        return 127;
#endif
    }

    case N_LIST:
        last_status = execute_tree(n->list.left, forked_flag);
        /* a pending break/continue/return skips the rest of the list */
        if (loop_ctl || func_return)
            return last_status;
        /* short-circuit && and ||, the fall-through case is for ; and if the
         * &&/|| is not short circuited */
        if (n->list.op == T_AND && last_status != 0)
            return last_status;
        if (n->list.op == T_OR && last_status == 0)
            return last_status;
        return last_status = execute_tree(n->list.right, forked_flag);

    case N_ASSIGN:
        /*
         * Set the variable (value expanded now), then run the command the
         * assignments prefix, if any. Without env passing to spawn, prefixed
         * assignments set shell variables rather than only for the command; a
         * bare assignment (cmd NULL) just sets the variable. The write lands
         * in a matching "local" frame if one exists, else the global frame.
         */
        set_var(n->assign.var, expand_string(n->assign.value));
        if (n->assign.cmd != NULL)
            return last_status = execute_tree(n->assign.cmd, forked_flag);
        return last_status = 0;

    case N_PIPE:
#ifdef JOS
        /*
         * No fork: flatten the right-nested pipe chain and spawn each stage
         * with its stdin/stdout bound to the surrounding pipes, like the
         * simple shell does. Each stage must be a simple command. The exit
         * status is taken from the last child reaped, which for a synchronous
         * pipeline is close enough to the last stage.
         */
        {
            struct node *stages[16];
            int ns, k, p[2], prev = -1, nsp = 0;

            ns = collect_pipe_stages(n, stages, 16, 0);

            for (k = 0; k < ns; k++) {
                int out = -1;

                if (k < ns - 1) {
                    if (pipe(p) < 0) {
                        perror("pipe()");
                        break;
                    }
                    out = p[1];
                }
                if (jsh_spawn_stage(stages[k], prev, out) >= 0)
                    nsp++;
                if (prev >= 0)
                    close(prev);
                if (out >= 0)
                    close(out);
                prev = (k < ns - 1) ? p[0] : -1;
            }
            if (prev >= 0)
                close(prev);

            wstatus = 0;
            for (k = 0; k < nsp; k++)
                wstatus = jsh_wait_one();
            return last_status = WEXITSTATUS(wstatus);
        }
#elif defined(SKJEGG)
        /*
         * No fork: flatten the pipe chain and bind each stage's stdin and
         * stdout to the surrounding pipe ends through its fd plan. The shell
         * holds every pipe fd and closes its own copy as soon as a stage is
         * spawned, so a writer child's exit is what finally closes the write
         * end and the reader sees EOF. Each stage must be a simple command.
         */
        {
            struct node *stages[16];
            int handles[16], nh = 0;
            int ns, k, rfd = -1, pe[2];

            ns = collect_pipe_stages(n, stages, 16, 0);
            for (k = 0; k < ns; k++) {
                struct fdplan pl;
                int wr = -1;
                unsigned h;

                fdplan_init(&pl);
                if (rfd >= 0)
                    pl.fd[0] = rfd;
                if (k < ns - 1) {
                    if (pipe(pe) != 0) {
                        perror("pipe()");
                        break;
                    }
                    wr = pe[1];
                    pl.fd[1] = wr;
                }
                h = sk_spawn_stage(stages[k], &pl);
                if (rfd >= 0)
                    close(rfd);
                if (wr >= 0)
                    close(wr);
                if (h > 0 && nh < 16)
                    handles[nh++] = (int)h;
                rfd = (k < ns - 1) ? pe[0] : -1;
            }
            if (rfd >= 0)
                close(rfd);

            wstatus = 0;
            for (k = 0; k < nh; k++)
                wstatus = jsh_wait_for(handles[k]);
            return last_status = WEXITSTATUS(wstatus);
        }
#else
        // 1. create pipe
        if (pipe(pfd) == -1) {
            perror("pipe()");
            return 127;
        }

        child = fork();
        if (child == 0) {
            close(pfd[0]);
            dup2(pfd[1], STDOUT_FILENO);
            close(pfd[1]);
            execute_tree(n->pipe.left, 1);
            _exit(last_status);
        } else if (child < 0) {
            perror("fork()");
        }

        pid2 = fork();
        if (pid2 == 0) {
            close(pfd[1]);
            dup2(pfd[0], STDIN_FILENO);
            close(pfd[0]);
            execute_tree(n->pipe.right, 1);
            _exit(last_status);
        } else if (pid2 < 0) {
            perror("fork()");
        }

        close(pfd[0]);
        close(pfd[1]);
        waitpid(child, &wstatus, 0);
        report_status(child, wstatus);
        waitpid(pid2, &wstatus2, 0);
        return update_last_status(pid2, wstatus2);
#endif

    case N_IF:
        last_status = 0;
        silent_command_count++; /* hide if's cond command */
        rc = execute_tree(n->if_.cond, forked_flag);
        silent_command_count--;
        if (rc == 0) {
            return execute_tree(n->if_.then_body, forked_flag);
        } else {
            return execute_tree(n->if_.else_body, forked_flag);
        }

    case N_REDIR:
#ifdef JOS
        /*
         * No fork: apply the redirect to the shell's own fds around running
         * the inner command, then restore. An external command spawned inside
         * inherits the redirected fd; a builtin runs with it too. dup after a
         * close lands on the just-freed target, the lowest free fd.
         */
        {
            int target = n->redir.fd < 0 ?
                redir_default_fd(n->redir.rtype) : n->redir.fd;
            int saved = dup(target);

            (void)forked_flag;
            if (do_redir(n)) {
                if (saved >= 0) {
                    close(target);
                    dup(saved);
                    close(saved);
                }
                return last_status = 127;
            }
            rc = execute_tree(n->redir.cmd, 0);
            close(target);
            if (saved >= 0) {
                dup(saved);
                close(saved);
            }
            return last_status = rc;
        }
#elif defined(SKJEGG)
        /*
         * No fork and no fd inheritance: collect the redirect chain into an fd
         * plan and spawn the inner command with it. A redirect may wrap only a
         * simple command.
         */
        {
            struct node *inner = n;
            struct fdplan pl;
            int openfds[3], nopen = 0, i, eargc;
            struct node *cmd;
            char **eargv;
            unsigned h;

            (void)forked_flag;

            /* Find the inner command before opening anything. */
            while (inner != NULL && inner->type == N_REDIR)
                inner = inner->redir.cmd;
            if (inner == NULL || inner->type != N_CMD) {
                puts("jsh: redirection only on a simple command");
                return last_status = 127;
            }
            /*
             * A builtin or function runs in the shell process and cannot have
             * its in-process output redirected (there is no dup2). Detect it on
             * the raw command word and run it without opening the target, so a
             * redirect on a builtin does not truncate the file as a side effect.
             */
            if (inner->cmd.argv[0] != NULL &&
                (lookup_builtin(inner->cmd.argv[0]) >= 0 ||
                 findfunc(inner->cmd.argv[0]) != NULL))
                return last_status = execute_tree(inner, 0);

            /* External command: open the redirects into the plan and spawn. */
            fdplan_init(&pl);
            cmd = sk_apply_redirs(n, &pl, openfds, &nopen);
            if (cmd == NULL) {
                for (i = 0; i < nopen; i++)
                    close(openfds[i]);
                return last_status = 127;
            }
            eargc = cmd->cmd.argc;
            eargv = expand_args(&eargc, cmd->cmd.argv);
            h = sk_spawn(eargc, eargv, &pl);
            for (i = 0; i < nopen; i++)
                close(openfds[i]);
            if (h == 0)
                return last_status = 127;
            wstatus = jsh_wait_for((int)h);
            update_last_status((int)h, wstatus);
            return last_status;
        }
#else
        if (!forked_flag && is_special_builtin(n)) {
            /* save the fd, apply redirect, run builtin, restore */
            int target = n->redir.fd < 0 ? redir_default_fd(n->redir.rtype) : n->redir.fd;
            int saved = dup(target);
            if (do_redir(n)) return 127;
            rc = execute_tree(n->redir.cmd, 0);
            dup2(saved, target);
            close(saved);
            return rc;
        }
        /* non-builtin: fork as before */
        if (!forked_flag) {
            child = fork();
            if (child < 0) {
                die_p("fork()");
            }
            if (!child) {
                if (do_redir(n)) _exit(127);
                _exit(execute_tree(n->redir.cmd, 1));
            }
            waitpid(child, &wstatus, 0);
            return update_last_status(child, wstatus);
        }
        if (do_redir(n)) _exit(127);
        return execute_tree(n->redir.cmd, 1);
#endif

    case N_SUBSHELL:
#if defined(JOS) || defined(SKJEGG)
        /*
         * No fork means no isolation: run the body in this same process. A
         * cd or variable change inside the subshell leaks to the parent. This
         * is the accepted degrade for a no-fork kernel.
         */
        (void)forked_flag;
        return last_status = execute_tree(n->subshell.body, 0);
#else
        child = fork();
        if (child < 0) {
            perror("fork()");
            return 127;
        }
        if (!child)
            /*
             * The fork above is the subshell's isolation; the body is a whole
             * list, so run it normally (forked_flag 0) and let each command
             * fork as usual. Passing 1 here would make the first command exec
             * in place and replace the subshell, so the rest never ran.
             */
            _exit(execute_tree(n->subshell.body, 0));
        waitpid(child, &wstatus, 0);

        return update_last_status(child, wstatus);
#endif

    case N_WHILE:
        body_rc = 0;
        loop_depth++;
        while (1) {
            silent_command_count++;
            rc = execute_tree(n->while_.cond, forked_flag);
            silent_command_count--;
            if (rc) break;
            body_rc = execute_tree(n->while_.body, forked_flag);
            if (func_return) break;
            if (loop_ctl_stop()) break;
        }
        loop_depth--;
        return last_status = body_rc;

    case N_FOR: {
        /*
         * The 'in' words are expanded and split on IFS into the iteration
         * list. With no 'in', iterate the positional parameters, as
         * "for x in $@" does.
         */
        char *fwords[MAXARGS];
        int fn = 0;

        if (n->for_.words) {
            for (i = 0; i < n->for_.nwords && fn < MAXARGS; i++)
                expand_fields(n->for_.words[i], fwords, &fn, MAXARGS);
        } else {
            for (i = 0; i < pos_nparams && fn < MAXARGS; i++)
                fwords[fn++] = pos_params[i];
        }

        body_rc = 0;
        loop_depth++;
        push_local_var_frame();
        for (i = 0; i < fn; i++) {
            set_local_var(n->for_.var, fwords[i]);
            body_rc = execute_tree(n->for_.body, forked_flag);
            if (func_return) break;
            if (loop_ctl_stop()) break;
        }
        pop_local_var_frame();
        loop_depth--;
        return last_status = body_rc;
    }

    case N_CASE: {
        /*
         * Expand the subject word, then the first clause with a matching
         * pattern runs and the statement stops. Patterns are expanded too, so
         * a $var in a pattern works; glob metacharacters come from the literal.
         */
        char *w = expand_string(n->case_.word);
        struct node_case_item *it;
        int i;

        for (it = n->case_.items; it != NULL; it = it->next)
            for (i = 0; it->patterns[i] != NULL; i++)
                if (glob_match(expand_string(it->patterns[i]), w))
                    return last_status = execute_tree(it->body, forked_flag);
        return last_status = 0;		/* no clause matched */
    }

    case N_BACK:
        /*
         * Run the wrapped command in the background. With no fork only a simple
         * command can be detached, so set bg_pending for the N_CMD leaf to spawn
         * without waiting. A pipe or compound construct cannot be backgrounded,
         * so it runs in the foreground; the & then only means "return 0 once it
         * has been started". Either way the shell does not wait, so the status
         * of a backgrounded command is 0.
         */
        if (n->back.cmd && n->back.cmd->type == N_CMD)
            bg_pending = 1;
        execute_tree(n->back.cmd, forked_flag);
        bg_pending = 0;
        return last_status = 0;

    default:
        die("not supported");
    }

    /* we should not get here */
    abort();
}
