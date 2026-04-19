# Command Grammar — Design Notes

Reference notes for evolving boris's command parser. A tester has already
flagged the current parser as weak; these notes collect grammar sketches
to draw from when redesigning. See also `doc/input-filtering.md` and
`doc/mud-commands-report.md`.

## 1. Word classes

The parser recognizes these classes (from `6mud/nlp.txt`):

- **NOUN** — things the player can refer to: objects, mobs, rooms, exits.
- **VERB** — commands: `look`, `get`, `drop`, `go`, `attack`.
- **PREPOSITION** — relational words: `in`, `on`, `under`, `at`, `with`,
  `to`, `from`.
- **ADJECTIVE** — disambiguators and tag words: `red`, `large`, `rusty`.
- **ADVERB** — verb modifiers: `quietly`, `carefully`, `quickly`.
- **ARTICLE** — `a`, `an`, `the`. Always discarded.
- **CONJUNCTION** — `and`, `then`. Joins phrases.

## 2. Tokenizer loop

Base algorithm:

1. Get next word.
2. If word is an article, discard and loop.
3. Iterate through candidate items (inventory, room contents, known
   verbs), matching against every word in the token stream that could
   belong to that item's name.
4. A matched object yields a type (VERB, NOUN, ...).

The key property is that item matching is **multi-word**: "rusty iron
sword" should match a single object whose keywords include `rusty`,
`iron`, `sword`, not three separate lookups.

## 3. Grammar sketch (EBNF-ish)

```
noun-phrase:
    NOUN
  | ADJECTIVE noun-phrase
  | ADVERB     noun-phrase
  | NOUN PREPOSITION noun-phrase

verb-phrase:
    VERB
  | ADVERB VERB
  | ADVERB CONJUNCTION verb-phrase     // "quickly and quietly runs"

sentence:
    VERB noun-phrase
  | sentence CONJUNCTION noun-phrase   // "get sword and shield"
  | noun-phrase verb-phrase noun-phrase
```

Note: the third `sentence` form (subject-verb-object) is only useful if
the parser supports addressing NPCs imperatively ("guard, attack orc").
If boris doesn't want that, drop it and keep parsing verb-initial.

## 4. Disambiguation

Adjectives exist to disambiguate nouns when multiple candidates match:

```
> get sword
You see two swords here. Which one? (rusty / shining)
> get rusty sword
```

Ordinal selectors are the common fallback: `get 2.sword`, `get second sword`.

## 5. Open questions for boris

- **Does the tokenizer need to know word classes up front**, or can it
  match greedily against known object/verb vocabularies? Greedy matching
  against live game state avoids maintaining a global dictionary.
- **Conjunction handling**: is `get sword and shield` worth supporting,
  or does it just encourage brittle input? Most modern MUDs support it.
- **Prepositions as part of verb identity** (`look at`, `look in`,
  `pick up`) vs. prepositions as separators of noun phrases. Both are
  valid designs; pick one and be consistent.
- **Quoting / multi-word names** — "pick up `silver chalice`" vs
  keyword-based matching on any of `silver`, `chalice`.

## 6. Prior art to mine

- **LPMud / TinyMUSH** — verb-initial with preposition-aware parsing
  (`add_action` / attributes).
- **Inform 7 / TADS** — the most sophisticated IF-style parsers; worth
  reading for adjective disambiguation and scope rules even though boris
  won't adopt their complexity.
- **DikuMUD family** — simpler, keyword-based. Closer to boris today.

---

## Appendix: original 6mud note (verbatim)

```
iterator

NOUN
VERB
PREPOSITION
ADJECTIVE
ADVERB
ARTICLE
CONJUNCTION

1. get next word
2. if word is an article, discard and go to #1
3. iterate through items, looking for a match. match all the words in the item
4. a matched object yields a type


VERB:
    ...

ADJECTIVE:
    ...

NOUN-PHRASE:
    NOUN
    ADJECTIVE NOUN-PHRASE
    ADVERB NOUN-PHRASE
    NOUN PREPOSITION NOUN-PHRASE

VERB-PHRASE:
    VERB                                    # runs
    ADVERB VERB                             # quietly runs
    ADVERB CONJUNCTION VERB-PHRASE          # quickly and quietly runs

SENTENCE:
    VERB NOUN-PHRASE
    SENTENCE CONJUNCTION NOUN-PHRASE
    NOUN-PHRASE VERB-PHRASE NOUN-PHRASE
```
