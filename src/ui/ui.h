/* ui.h : interactive UI layer -- model and controller (doc/ui-layer-spec.md) */
/* PUBLIC DOMAIN (CC0-1.0) or MIT-0 -- See LICENSE for details. */
#ifndef UI_H_
#define UI_H_

#include <stddef.h>

struct descriptor_data;		/* DESCRIPTOR_DATA; renderer-only, model stays client-free */
struct ui_session;
struct ui_frame;
struct ui_field;

/* --- limits ---------------------------------------------------------- */

#define UI_MAX_DEPTH  10	/* navigation stack bound (spec 5.5) */
#define UI_VALUE_MAX  1024	/* max staged field value length */
#define UI_LIST_PAGE  10	/* generated-list page size (spec 6) */

/* --- value types (spec 5.1) ------------------------------------------ */

enum ui_type {
	UI_STRING,	/* short single line; one-line prompt */
	UI_INT,		/* signed integer */
	UI_BOOL,	/* yes/no toggle */
	UI_ENUM,	/* one of a fixed named choice set */
	UI_OBJREF,	/* object id, entered as a string, validated */
	UI_TEXT,	/* long multi-line; online string editor (deferred) */
	UI_SUBFRAME,	/* selecting it pushes a child frame */
	UI_ACTION,	/* selecting it runs on_select (menu item) */
};

/* --- field flags (spec 5.2) ------------------------------------------ */

#define UI_F_HIDDEN    (1u << 0)	/* render value as <hidden> (passwords) */
#define UI_F_READONLY  (1u << 1)	/* show value, no edit; set is NULL */
#define UI_F_REQUIRED  (1u << 2)	/* blocks Submit while empty */

/* --- universal actions (spec 6) -------------------------------------- */

enum ui_action {
	UI_ACT_NEXT,	/* wizard: next step */
	UI_ACT_PREV,	/* wizard: previous step */
	UI_ACT_SUBMIT,	/* validate all, run on_submit */
	UI_ACT_UNDO,	/* revert current field's staged edit */
	UI_ACT_REFRESH,	/* redraw */
	UI_ACT_LIST,	/* present a selection set */
	UI_ACT_QUIT,	/* leave, keeping the edit context */
	UI_ACT_DISCARD,	/* confirmed: drop edits, end context */
	UI_ACT_HELP,	/* help for the current frame/field */
	UI_ACT_COUNT
};

#define UI_A(a)  (1u << (a))	/* action bit for a frame's action_mask */

/* reserved letter for an action, and its display name (spec 6 table) */
char        ui_action_key(enum ui_action a);
const char *ui_action_name(enum ui_action a);

/* --- field descriptor (spec 5.2) ------------------------------------- */

struct ui_field {
	const char *label;		/* shown to the user */
	const char *key;		/* stable id: struct member or OBJ prop */
	enum ui_type type;
	unsigned flags;

	/* backing-store accessors; ctx is the frame's binding.
	 * get() writes into buf, returns length written or -1.
	 * set() returns 0 on success, -1 on failure; NULL if readonly. */
	int (*get)(void *ctx, const char *key, char *buf, size_t buflen);
	int (*set)(void *ctx, const char *key, const char *value);

	/* UI_ENUM only */
	const char *const *choices;
	unsigned nr_choices;

	/* optional; run before set(); returns 0 on ok, else sets *err */
	int (*validate)(void *ctx, const char *value, const char **err);

	/* UI_SUBFRAME only: build the child frame on demand */
	struct ui_frame *(*open_child)(struct ui_session *s, void *ctx);

	/* UI_ACTION only: run when the item is selected. It may end the
	 * session (e.g. hand the descriptor to another flow), so the
	 * controller touches nothing after calling it. */
	void (*on_select)(struct ui_session *s, void *ctx);

	/* optional: run after this field's value is successfully set, with the
	 * session, so the change can refresh the frame (e.g. reveal
	 * type-dependent fields). A handler that rebuilds the frame's fields[]
	 * in place must call ui_fields_rebuilt(); it must NOT move the array or
	 * change the edited field's index (see ui_fields_rebuilt). */
	void (*on_change)(struct ui_session *s, void *ctx);
};

/* --- frame (spec 5.3) ------------------------------------------------ */

struct ui_frame {
	const char *title;
	struct ui_field *fields;
	unsigned nr_fields;
	unsigned action_mask;		/* enabled universal actions */
	int wizard;			/* step wizard: auto-prompt fields in order (spec 4) */
	void *binding;			/* passed as ctx to accessors */

	/* 0 to accept (frame pops), -1 to stay (error already shown) */
	int (*on_submit)(struct ui_session *s, void *binding);
	void (*on_cancel)(struct ui_session *s, void *binding);

	/* free anything this frame owns; NULL if it owns nothing */
	void (*free)(struct ui_frame *f);
};

/* --- renderer vtable (spec 8) ---------------------------------------- */

struct ui_renderer {
	const char *name;
	void *(*open)(struct descriptor_data *cl);	/* per-session ctx; may be NULL */
	void  (*close)(void *render_ctx);		/* may be NULL */
	void  (*render)(struct ui_session *s, const struct ui_frame *f);
	void  (*enter_field)(struct ui_session *s, const struct ui_field *f);
	/* edit a UI_TEXT field out of band (string editor / SSE editor); calls
	 * ui_text_result when done. NULL -> UI_TEXT edits as a single line. */
	void  (*edit_text)(struct ui_session *s, const struct ui_field *f);
	void  (*notify)(struct ui_session *s, const char *text);
};

/* --- session (spec 5.5) ---------------------------------------------- */

enum ui_mode { UI_MODE_BROWSING, UI_MODE_EDITING, UI_MODE_SUSPENDED };

struct ui_session {
	struct ui_frame *stack[UI_MAX_DEPTH];
	unsigned depth;
	unsigned cursor;		/* field being edited in the top frame */
	int dirty;			/* staged, uncommitted edits exist */
	enum ui_mode mode;
	const struct ui_renderer *renderer;
	void *render_ctx;
	void (*on_close)(struct descriptor_data *cl);
	struct descriptor_data *cl;
};

/* --- controller ------------------------------------------------------ */

/*
 * Create a session over an injected renderer, push the first frame, and draw
 * it. render_ctx is obtained from renderer->open(cl) if set. cl is stored for
 * the renderer's use and may be NULL in tests. on_close (may be NULL) is
 * called when the last frame pops. Returns NULL on allocation failure.
 */
struct ui_session *ui_session_new(const struct ui_renderer *renderer,
	struct descriptor_data *cl,
	void (*on_close)(struct descriptor_data *cl), struct ui_frame *frame);

/* Free the session: pop every frame through its free hook (no user
 * callbacks run), then free the session. */
void ui_session_free(struct ui_session *s);

/* Push a child frame (0 ok, -1 if the stack is full). Redraws. */
int ui_push(struct ui_session *s, struct ui_frame *child);

/* Pop the top frame through its free hook. Popping the last frame ends the
 * session's stack and runs on_close (the caller then frees the session). */
void ui_pop(struct ui_session *s);

/* Replace the top frame with fresh (freeing the old through its free hook) and
 * redraw. Used to refresh a dynamically-built frame (e.g. an exit list) in
 * place after its underlying data changed. No-op if the stack is empty. */
void ui_swap_top(struct ui_session *s, struct ui_frame *fresh);

/* An on_change handler that rebuilt the top frame's fields[] in place calls
 * this to publish the new field count and keep the cursor in range. Unlike
 * ui_swap_top, nothing is freed and the cursor/wizard position is preserved,
 * so the wizard walks into any newly-revealed field. Requirements on the
 * caller: rebuild into the SAME fields buffer (do not move it), and keep the
 * field currently being edited at its index (fields after it may change). */
void ui_fields_rebuilt(struct ui_session *s, unsigned nr_fields);

/* Top (current) frame, or NULL if the stack is empty. */
struct ui_frame *ui_top(struct ui_session *s);

/* Feed one raw input line to the controller (dispatch per spec 6). */
void ui_input_line(struct ui_session *s, const char *line);

/* Read field idx of the top frame into buf (through its get()); returns the
 * length, or -1 if idx is out of range or the field has no get(). */
int ui_field_get(struct ui_session *s, unsigned idx, char *buf, size_t buflen);

/*
 * Called by a renderer's edit_text when out-of-band UI_TEXT editing finishes:
 * applies result to the current field (when changed) and resumes -- advancing
 * a wizard or returning to browsing. After it returns, s->mode is SUSPENDED
 * only if it handed off to another out-of-band editor.
 */
void ui_text_result(struct ui_session *s, const char *result, int changed);

/* --- renderers ------------------------------------------------------- */

/* Plain TELNET text renderer (spec 8.2); the universal fallback. It writes
 * through the session's descriptor, so its open() returns NULL. */
extern const struct ui_renderer ui_render_text;

/* --- telnetclient integration (spec 10) ------------------------------ */

/*
 * Open a UI session on a descriptor: pick the capability-matched renderer,
 * create the session over frame, install the controller as the line-input
 * handler, and register free-on-disconnect. on_close (may be NULL) runs when
 * the last frame pops, to restore the descriptor's prior flow.
 */
void ui_open(struct descriptor_data *cl, struct ui_frame *frame,
	void (*on_close)(struct descriptor_data *cl));

/* Re-install the UI controller's line input on cl after an out-of-band editor
 * (e.g. the string editor) returned control. */
void ui_resume_input(struct descriptor_data *cl);

#endif
