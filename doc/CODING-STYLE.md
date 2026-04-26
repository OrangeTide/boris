# Coding Conventions

## Overview

 * C99 or newer; freely use `//` for short one-line comments.
 * No K&R-style function declarations or definitions (always include parameter types).
 * Upstream code is treated as read-only.
 * Hard tabs for indentation, no leading spaces before a tab.
 * K&R braces for control flow, own-line braces for function definitions.
 * Return type on a separate line from the function name in definitions.
 * Target 78 columns, up to 120 when breaking would hurt readability.
 * Every file starts with a `/* file.x : description */` tag, followed by a copyright section.
 * Comment blocks use `/* */`, `/** */` for function docs, and
   `/**** ****/` for section headers - all prose, no `@param` tags.
 * `snake_case` names, `UPPER_CASE` constants, module prefix on exports.
 * Own header included first (`#include "foo.h"` before `<stdio.h>`).
 * Trailing comma after the last element in arrays, enums, and initializer lists.
 * Prefer `OK` (0) / `ERR` (-1) for success/failure returns.
 * No trailing whitespace; files end with a newline, no extra blank lines.

## Language Standard

Prefer C99 or newer. Use C99 features freely: `//` comments,
mixed declarations and code, designated initializers, `for`-loop
declarations, `<stdint.h>` types, etc.

Never use K&R-style (untyped) function declarations or definitions.
Every parameter must have an explicit type:

    /* wrong - K&R style */
    int foo(x, y)
        int x;
        int y;
    {

    /* right */
    int
    foo(int x, int y)
    {

Empty parameter lists use `void`, not `()`:

    int bar(void);    /* right */
    int bar();        /* wrong - means unspecified args in C */

## Source Formatting

### Indentation

Hard tabs, displayed at 8 spaces. No spaces for indentation.

### Braces

Opening braces go on the same line for control statements:

    if (x) {
        ...
    }

    while (cond) {
        ...
    }

    for (int i = 0; i < n; i++) {
        ...
    }

Opening braces go on their own line for function definitions:

    static int
    foo(int x)
    {
        return x + 1;
    }

Single-statement bodies may omit braces:

    if (!fp) return ERR;

    for (int i = 0; i < n; i++)
        h = ((h << 5) + h) ^ buf[i];

### Return type

The return type and any qualifiers go on a separate line from
the function name in definitions:

    static char *
    dag_strdup(const char *s)
    {

    void
    dag_init(struct dag *g)
    {

### Spacing

Spaces around binary operators:

    h = ((h << 5) + h) ^ buf[i];
    if (a->mtime_sec == b->mtime_sec && a->size == b->size)

No space between a function name and its argument list:

    snprintf(buf, sizeof(buf), "%d", count);

Space after control keywords:

    if (x)
    while (cond)
    for (...)

### Blank lines

Use blank lines to separate logical groups within a function.
Do not insert blank lines between sequential assignments to the
same struct or closely related variables:

    /* good */
    n->id = g->count;
    n->type = type;
    n->state = STATE_CLEAN;
    n->name = dag_strdup(name);

    /* bad */
    n->id = g->count;

    n->type = type;

    n->state = STATE_CLEAN;

### Automated Formatters: indent, astyle, etc

astyle command that produces output close to this style:

    astyle --style=linux -xB -t8 -f -p

NOTE: manual cleanup may be needed (particularly removing excess
      blank lines it inserts between assignments).

## Line Width

Target line width is **78 characters**. Lines may extend up to
**120 characters** when breaking a long identifier, function
signature, or complex expression would hurt readability.

### Wrapping Long Lines

Break long expressions so the operator ends the line:

    if (a->mtime_sec == b->mtime_sec &&
        a->mtime_nsec == b->mtime_nsec &&
        a->size == b->size)

Align continuation lines with the expression they belong to:

    } else if (strcmp(argv[i], "-n") == 0 ||
               strcmp(argv[i], "--dry-run") == 0) {

For function calls, align wrapped arguments past the opening
parenthesis:

    snprintf(buf, sizeof(buf), "%s:%d: rule '%s': no command",
             filename, line, name);

For function definitions, if the parameter list is too long,
break after a comma and indent the continuation with spaces
to align past the opening parenthesis:

    static int
    dfs_visit(struct dag *g, int id, int *stack, int *sp,
              int *cycle_node)

## File Header

Every source file starts with two comment lines - a filename tag
and a copyright notice:

    /* filename.x : one-line description */
    /* Copyright (c) YYYY Author Name <email>
     * Licensed under <license> */

For headers, the include guard follows immediately after.

## Comment Blocks

### Section headers

Use asterisk-bordered blocks for non-function section dividers
and general documentation:

    /***************************************************************
     * Section name or description
     **************************************************************/

### Multi-line comments

Use the simplest form for most multi-line comments:

    /*
     * This is a regular multi-line comment explaining
     * some implementation detail.
     */

### Function documentation

Function doc comments use godoc style: the first sentence begins
with the function name and describes what it does. Write plain
English prose -- no Doxygen tags (`@param`, `@return`, `@file`,
etc.). The first sentence serves as the summary.

Place the comment immediately before the function definition
using `/*`:

    /* dag_topo_sort performs a DFS-based topological sort.
     * Returns 0 on success or -1 if a cycle is detected, in which
     * case cycle_node is set to the id of a node involved in the cycle.
     */
    int
    dag_topo_sort(struct dag *g, int *cycle_node)

Most of the project currently uses Doxygen-style comments (`/**`,
`@param`, `@return`, etc.). New and modified code should use the
godoc style described here; existing files will be updated over
time.

For short descriptions a single-line comment is fine:

    /* telnetclient_close closes the client's connection. */
    void
    telnetclient_close(DESCRIPTOR_DATA *cl)

### Code snippets in comments

Code examples within comments may optionally be delimited with
scissor lines:

    --->8------>8------>8------>8---

### Inline comments

Use `//` for short one-line comments:

    n->visited = 0; // 0=unvisited, 1=in-progress, 2=done

`/* */` is also fine, especially for end-of-line comments on
preprocessor directives or closing braces:

    #endif /* KILN_DAG_H */

## Naming

- Functions and variables use `snake_case`.
- Struct and enum types use `snake_case`.
- Constants and enum values use `UPPER_CASE`.
- Exported symbols are prefixed with their module name.
- Static/internal functions have no prefix.

## Include Guards

Use a project-specific prefix:

    #ifndef PROJECT_MODULE_H
    #define PROJECT_MODULE_H
    ...
    #endif

## Include Ordering

If a source file has an associated header, include that header
first:

    /* mylib.c : my library */
    #include "mylib.h"
    #include <stdio.h>

## Trailing Commas

Always include a trailing comma after the last element in arrays,
enums, and initializer lists. This makes diffs cleaner and
reordering easier:

    enum node_type {
        NODE_FILE,
        NODE_CMD,
    };

    static const char *names[] = {
        "alpha",
        "beta",
        "gamma",
    };

## Macro Guards

Wrap multi-statement macros in `do { } while (0)`.
Parenthesize macro arguments to avoid precedence surprises:

    #define MYMAC(a,b) do { \
        printf("%s", (a)); \
        printf(" %d\n", (b)); \
    } while (0)

## Error Handling

Use `fprintf(stderr, ...)` for error messages.

### OK / ERR return convention

Functions that return success or failure use:

    #define OK  (0)
    #define ERR (-1)

For a standalone program or small project, a single pair of
defines in a common header is sufficient. Prefix with a module
name (`MYLIB_OK` / `MYLIB_ERR`) only when the defines are
exported as part of a library's public API.

    int
    mylib_open(const char *path)
    {
        if (!path) return ERR;
        ...
        return OK;
    }

    if (mylib_open(path) != OK)
        handle_error();

Optionally, a typedef or enum may be used instead of defines
(e.g. `enum status`, `status_t`).

### Bubbling up external conventions

When wrapping an external API, prefer to bubble up the lower
level's return convention rather than translating it. Only use
our own OK/ERR when the function processes or combines the
return values of multiple calls, significantly modifying the
meaning.

## Punctuation

Use ASCII punctuation in all C source and header files:

- `--` not em-dash
- `"quotes"` not smart quotes
- `'apostrophe'` not curly apostrophe
- `...` not ellipsis character

This keeps comments, strings, and Makefiles readable in plain
terminals and avoids encoding surprises in diffs. Unicode is
acceptable only where it is part of program data (e.g., a string
containing a user-facing name with diacritics).

## Memory

Free everything on cleanup paths. Although program may be short-lived, it
should still be valgrind-clean.
