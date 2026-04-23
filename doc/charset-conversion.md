# Character Encoding Conversion

Boris stores all text internally as UTF-8. Some MUD clients --
particularly older telnet clients, terminals using Code Page 437,
or systems configured for Latin-1/Windows-1252 -- cannot display
UTF-8. This module converts between UTF-8 and legacy single-byte
encodings at the I/O boundary so that these clients get readable
output and their input is correctly interpreted.

Non-UTF-8 support is best-effort, not first-class. Characters that
have no mapping in the target encoding are replaced with `?`.

## Supported encodings

Encoding data comes from Unicode Consortium mapping files stored
in `data/unicode/`. Each file maps byte values 0x80--0xFF to
Unicode codepoints. The currently shipped files are:

 - CP437, CP737, CP850, CP860, CP863 (DOS code pages)
 - CP1250, CP1252 (Windows code pages)
 - ISO 8859-1 (Latin-1), ISO 8859-10
 - KOI8-R, KOI8-U (Cyrillic)

Adding a new encoding requires only dropping the mapping file into
`data/unicode/` and adding an alias entry in the `charset_aliases`
table in `src/util/charset.c`.

## Architecture

### Data structures

`struct charset` (opaque, defined in `src/util/charset.c`):

 - `name` -- normalized charset name (uppercase, no hyphens/underscores).
 - `to_unicode[128]` -- forward table. Index by `(byte - 0x80)` to
   get a Unicode codepoint. Bytes 0x00--0x7F are ASCII and passed
   through without table lookup.
 - `from_unicode[]` -- reverse table. Sorted array of
   `{codepoint, byte}` pairs, searched with binary search.
 - `nr_from` -- number of entries in the reverse table.

A global cache holds up to 16 loaded charsets. Once loaded, a
charset stays in the cache until `charset_shutdown()`.

### API (`src/util/charset.h`)

```c
struct charset *charset_load(const char *name);
void charset_free(struct charset *cs);
const char *charset_name(struct charset *cs);
int charset_to_utf8(struct charset *cs,
    const char *src, int srclen, char *dst, int dstlen);
int charset_from_utf8(struct charset *cs,
    const char *src, int srclen, char *dst, int dstlen);
void charset_shutdown(void);
```

 - `charset_load` -- load by name or alias; returns cached copy if
   already loaded. Returns NULL on failure.
 - `charset_to_utf8` -- convert legacy bytes to UTF-8.
 - `charset_from_utf8` -- convert UTF-8 to legacy bytes.
 - `charset_shutdown` -- free all cached charsets (called at server
   shutdown).

Name normalization strips hyphens, underscores, and spaces, then
uppercases. So `iso-8859-1`, `ISO_8859_1`, and `iso88591` all
resolve to the same charset.

### I/O hooks (`src/telnetclient.c`)

Conversion happens at two points in the telnet I/O path:

 - **Output** (`telnetclient_puts`, `telnetclient_vprintf`): when
   `cl->encoding` is set, UTF-8 text is converted to legacy bytes
   via `charset_from_utf8()` before being written to the socket.
 - **Input** (`telnetclient_on_data`): after telopt processing,
   legacy bytes are converted to UTF-8 via `charset_to_utf8()`
   before being committed to the line buffer.

Both paths use a 2048-byte stack buffer. Messages longer than that
are sent/processed unconverted.

### Encoding selection

There are two mechanisms:

1. **`charset` command** -- a logged-in user can type `charset cp437`
   to switch their session encoding, or `charset utf8` to reset.
   The choice is saved to the user account (as the `charset`
   extra_value) and persisted to disk immediately.

2. **Login restore** -- when a user authenticates, `login.c` reads
   the `charset` extra_value from their account and applies it to
   the session automatically.

Telnet CHARSET negotiation (RFC 2066) is handled by the MTH
library (`src/thirdparty/mth/telopt.c`), but it only offers UTF-8.
If the client accepts, no conversion is needed. If the client
rejects, the user can manually select an encoding with the
`charset` command.

## Admin notes

### Adding mapping files

1. Download the `.TXT` file from the Unicode Consortium.
2. Place it in `data/unicode/`.
3. Add an alias entry to `charset_aliases[]` in
   `src/util/charset.c` mapping the normalized name to the filename.
4. Rebuild.

The mapping file format is one line per byte:
`0xNN<tab>0xNNNN<tab>#NAME`. Lines with `#UNDEFINED` or no
codepoint mapping are skipped (those byte values produce `?` on
output).

### Commands

 - `charset` -- show current encoding, or set a new one.
 - `charset <name>` -- set encoding (e.g. `cp437`, `latin1`).
 - `charset utf8` -- reset to UTF-8 (no conversion).
 - `chartest` -- print test patterns: accented characters, box
   drawing, quotation marks, currency symbols. Useful for verifying
   that a client's encoding is working correctly.

### Troubleshooting

If a user sees `?` characters, their client's encoding probably
does not have a mapping for those codepoints. Box-drawing
characters (U+2500 range) are available in CP437 but not in
Latin-1, for example. Currency symbols like the euro sign
(U+20AC) are in CP1252 but not CP1250.

If a user sees garbled multi-byte sequences, their session is
probably set to UTF-8 but their terminal is using a legacy
encoding. They should run `charset <name>` to match their
terminal's actual encoding.
