/* stred.h : online string editor (doc/string-editor-spec.md) */
/* PUBLIC DOMAIN (CC0-1.0) or MIT-0 -- See LICENSE for details. */
#ifndef STRED_H_
#define STRED_H_

#include <stddef.h>

struct descriptor_data;

#define STRED_MAX_LINES 256
#define STRED_LINE_MAX  512
#define STRED_BUF_MAX   16384	/* assembled buffer cap */

enum stred_mode { STRED_SINGLE, STRED_MULTI };
enum stred_status { STRED_CONTINUE, STRED_SAVED, STRED_ABORTED };

/* --- core editor (no I/O; testable) ---------------------------------- */

struct stred;

/*
 * Create an editor seeded from current (may be NULL). out() receives lines
 * to show the user (list, help); NULL runs the editor silently (tests). ctx
 * is passed to out().
 */
struct stred *stred_new(const char *current, enum stred_mode mode,
	void (*out)(void *ctx, const char *text), void *ctx);
void stred_free(struct stred *s);

/*
 * Feed one input line. Content lines are appended (single-line mode replaces
 * the one line); lines beginning with '/' are commands (spec 4); a line
 * beginning with '//' is content with one leading slash removed. Returns
 * STRED_CONTINUE, or STRED_SAVED / STRED_ABORTED when the session ends.
 */
enum stred_status stred_feed(struct stred *s, const char *line);

/* Assembled buffer (lines joined by '\n'), valid after STRED_SAVED. */
const char *stred_result(struct stred *s);
/* The value the editor started from (for STRED_ABORTED). Never NULL. */
const char *stred_original(struct stred *s);
/* Nonzero if the saved buffer differs from the original. */
int stred_changed(struct stred *s);

/* --- telnetclient entry (spec 3) ------------------------------------- */

/*
 * Take over the descriptor's line input and edit current. On finish, call
 * done with the result (saved buffer or, on abort, the original) and the
 * changed flag, then the editor session is torn down. done is responsible
 * for restoring the caller's line input (the suspend/resume bracket).
 */
void stred_start(struct descriptor_data *cl, const char *current,
	enum stred_mode mode,
	void (*done)(struct descriptor_data *cl, const char *result,
		int changed, void *ctx),
	void *ctx);

#endif
