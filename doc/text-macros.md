# Text Macros and Color Palette

Inspiration taken from mworld's `MACROS.txt`. A tiny substitution
layer for MOTD, help files, room descriptions, and system messages so
text can reference a named color palette without baking ANSI escapes
into the data.

## Syntax

 - `${!NAME}` -- expands to the palette entry `NAME`.
 - `$$`       -- literal `$` (escape).

Unknown names expand to empty (or are left literal behind a config
flag, for debugging authoring mistakes). Expansion is one-pass and
non-recursive: the replacement text is not re-scanned.

The leading `!` inside the braces is a namespace sigil. Plain
`${NAME}` is already a variable lookup (see `shvar_eval` in
`src/common.c`); the sigil disambiguates palette entries from
variables and leaves room for future namespaces (e.g. `${@topic}`
for help cross-references, `${#msg-id}` for canned messages)
without inventing a second top-level escape form. Parser change is
small: after reading the key, dispatch on `key[0]` -- `!` routes to
the palette, no sigil routes to the variable table.

mworld's `$${NAME}` and `$$$$`-for-literal rules do not apply here:
in boris `$$` already means a single literal `$`.

## Palette

The palette is a table of name -> replacement string. For terminal
clients the replacement is an ANSI SGR sequence; for the web client
it can be an HTML `<span class="c-red">` open/close pair or a
stylesheet-driven equivalent. The same authored text renders
correctly on both.

Base palette (mirrors mworld so existing content ports cleanly):

    BLACK    CRIMSON  FOREST   BROWN
    NAVY     VIOLET   AQUA     GRAY
    GLOOM    RED      GREEN    YELLOW
    BLUE     PURPLE   CYAN     WHITE
    NORMAL   ORIGINAL

`NORMAL` resets to the default foreground. `ORIGINAL` resets to
whatever was active before the enclosing substitution started (useful
for nested fragments).

## Scope of use

Apply macro expansion to:

 - help files
 - MOTD / welcome / goodbye banners
 - channel formatting templates
 - room descriptions and object text
 - admin-authored system messages

Do not apply expansion to:

 - untrusted user input (say, whisper, chat) -- expansion runs
   before the text is emitted, so allowing it from players would let
   them spoof colors or control sequences.
 - passwords or any credential path.

## Theming

The palette is a named binding, not a fixed table. A "light" and
"dark" palette can map the same names to different SGR sequences so
the same authored text adapts to the client's scheme. Per-account
palette selection is a natural extension (stored on the account
object).

## Relation to boris today

Boris currently mixes literal ANSI sequences and ad-hoc formatting
in the code and data files. Moving to `${!NAME}` tokens centralizes
the palette, enables per-client rendering (telnet vs. web), and
makes colorless output a single palette swap rather than a code
change.
