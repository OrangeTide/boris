# Input Filtering and Symbol Commands

Inspiration taken from mworld's `FEATURES.txt`. Two small UX rules
for the command parser.

## Input filtering

All input is filtered before dispatch:

 - Strip control characters that are not part of the line protocol.
 - Normalize whitespace at the head and tail of the line.
 - Reject or replace bytes that would corrupt downstream rendering
   (bare escape sequences, unpaired UTF-8 continuation bytes).

This is distinct from telnet option negotiation, which happens at the
socket layer. Filtering here is about what the command parser is
willing to accept as a "line of text."

## Symbol commands

A small set of punctuation characters act as single-token commands
and do not require a space separator after them. Typing a symbol
immediately enters the corresponding verb; the rest of the line is
the argument.

Examples:

    'hello world     -> say hello world
    "hello world     -> shout hello world (or whisper, etc.)
    :waves           -> emote waves

Rationale: these verbs are the most frequently typed, and removing
the required space shaves a keystroke off every utterance. The rule
applies only to a fixed list of punctuation prefixes, so it does not
interfere with normal command dispatch.

## Parser contract

 - If the first non-whitespace byte is a registered symbol prefix,
   the remainder of the line (after optionally skipping one space)
   is the argument. The verb is looked up by the symbol, not by a
   word match.
 - Otherwise the line is split at the first whitespace; the first
   token is the verb, the remainder is the argument.
 - Empty lines are a no-op, not an error.

The symbol table is a property of the command registry, not a
hard-coded branch in the parser.
