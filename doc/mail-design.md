# BorisMUD Mail System Design: End-User Experience

Audience: developers building the mail and contacts feature in Boris. This
document walks through what a player actually does, screen by screen, and how to
deliver the best experience across clients that support GMCP and clients that do
not. The wire protocol lives in the GMCP specs (`doc/gmcp/POST_mail.txt`,
`doc/gmcp/POST_contacts.txt`); the bindings and storage live in the two protocol
proposals. This document is about the human at the keyboard.

## Two access points, matched to the fiction

Mail has two entry points, and the choice is deliberate: the access surface
matches whether the mail is in-character or out-of-character.

- The account menu (OOC). After login, the account menu gains a "Mail" and a
  "Contacts" entry. This is the out-of-character surface: you are the player, not
  a character, managing your account. It reaches your OOC mailbox (addressed by
  your handle) and gives an overview of every mailbox you own.
- A mailbox object in the world (IC). A physical mailbox, for example at the town
  post office or in a player's home, carries a verb that opens mail for the
  character standing at it. This is the in-character surface: you are Gandalf, at
  a mailbox, reading Gandalf's letters. It reaches that one character's mailbox.

The rule: out-of-character mail is a menu (outside the fiction); in-character
mail is a place you walk to (inside the fiction). A developer should resist
adding a global `mail` verb that works anywhere; the location and the menu are
the design, and they reinforce which identity you are acting as.

Both entry points drive the same mail controller and the same operations; they
differ only in which mailbox they select and whether the framing is IC or OOC.

## Two surfaces, one trigger

Every client reaches mail through the same trigger (a menu selection or the
mailbox verb). What differs is the surface the server presents:

- Text baseline. On any telnet client, mail is a text menu and form flow, built
  on Boris's existing callback state-machine menu/form UIs. This always works and
  requires nothing from the client.
- GMCP-enhanced. A client that advertised `Post.Mail` gets a real mail window:
  Birdie renders a Eudora-style pane set, Mudlet a Geyser layout. The same
  trigger makes the server emit GMCP so the client opens or focuses its window.

The baseline is never removed; GMCP only adds to it. A bare-client player is
never stranded, and a rich-client player is never stuck reading a text menu they
cannot use.

## The GMCP constraint, and why the UX is shaped around it

GMCP is out-of-band and invisible to the player. It carries structured data to a
capable client; it cannot print to the screen, cannot prompt, and cannot block
waiting for an answer. Three consequences drive the design:

1. No prompts over GMCP. The server cannot ask "subject?" over GMCP and wait. So
   composition has two distinct paths (below): a server-driven form for text
   clients, and a client-driven window for GMCP clients that collects everything
   locally and sends one complete message.
2. Additive, never load-bearing. Because a plain client sees no GMCP at all, the
   text surface must be able to do everything on its own. GMCP only ever upgrades
   an interaction that already works as text.
3. Fire-and-forget, reconciled by counters. GMCP messages are not a
   request/response transaction. The client keeps its window current by folding
   in server pushes and re-reading when a counter shows a gap (`modseq`/`gen` for
   mail, `seq` for contacts). The server sends GMCP only to clients that
   advertised the module.

## Which mailbox you are in

A player has several mailboxes: one OOC mailbox for the account and one per
character. The entry point picks the starting mailbox, and the identity you send
as follows from the mailbox you are in.

- From the account menu, you land on an overview of all your mailboxes and can
  open any of them. Composing from the OOC mailbox sends OOC as your handle;
  composing from a character's mailbox sends IC as that character.
- From a post office mailbox, you land directly in the current character's IC
  mailbox, and composing sends IC as that character.

There is no separate "send as" picker to get wrong. The mailbox is the identity.

## Use cases

Each use case shows the trigger, the text-client flow, and the GMCP-client
behavior. Sample text screens are illustrative, not a required layout.

### Setup: become OOC-addressable

IC mailboxes exist automatically, one per character, keyed by the character. To
receive OOC mail you pick a public handle once. The first time you open Contacts
or the OOC mailbox without a handle set, the menu offers to set one.

Text:

```
--- Mail : OOC ---
You have no OOC handle yet, so no one can send you out-of-character mail.
Set one now? Enter a handle (letters, digits, - and _), or blank to skip.
> greywizard
Your OOC handle is now ~greywizard.
```

GMCP: the client's settings pane writes it directly.

    C: Post.Mail.Prefs { "handle": "greywizard" }
    S: Post.Mail.Prefs { "handle": "greywizard" }

In text, an OOC handle is shown with a leading `~` (for example `~greywizard`)
to tell it apart from a character name. The `~` is a display sigil only: it is
not part of the handle. Input tolerates it, but the stored value and the wire
carry the bare name.

### Read: check mail from the account menu (OOC framing)

Trigger: account menu, select Mail.

Text:

```
--- Mail ---
  1) [OOC] ~greywizard        2 unread
  2) [IC]  Gandalf            -
  3) [IC]  Mithrandir         1 unread
Open a mailbox by number, (c)ompose, (s)ettings, (q)uit
> 1

--- ~greywizard : OOC (2 unread) ---
   #  From            Subject                      When
   3  ~frodo          Re: the meeting              2h ago   *
   2  ~samwise        rope                         1d ago   *
   1  ~bilbo          party                        6d ago
Read #, (c)ompose, (d)elete #, (u)ndo, (q)back
> 3
```

GMCP: selecting Mail makes the server enumerate mailboxes and the client opens
its window; the text menu is replaced by a one-line "Opening mail..." notice.

    S: Post.Mail.Boxes { "mailboxes": [ {mailbox:"ooc", ...}, {mailbox:"Gandalf", ...}, ... ] }
    C: Post.Mail.List { "mailbox": "ooc" }
    S: Post.Mail.Index { "mailbox": "ooc", "messages": [ ... ] }

### Read: check mail at the post office (IC framing)

Trigger: standing in the post office, use the mailbox object.

```
> open mailbox
You unlock the brass mailbox marked "Gandalf" and thumb through the letters.

--- Gandalf's mail (1 unread) ---
   #  From            Subject                      When
   1  Frodo           the ring                     3h ago   *
Read #, (c)ompose, (d)elete #, (q)close
> read 1

Frodo writes:
  Keep it secret. Keep it safe.

(marked read)
```

GMCP: the verb triggers the same `Post.Mail.List { "mailbox": "Gandalf" }` flow
and the client opens the window scoped to Gandalf's mailbox. The room still
prints a short IC line ("You open the mailbox marked Gandalf.") so the moment
stays in the fiction even for window users.

### Compose and send

This is the interaction GMCP most changes; see "Compose in detail" below. The
trigger is `(c)ompose` from a mailbox, or a compose button in the window.

Text (server-driven form):

```
> c
Compose from ~greywizard (OOC).
To (name or handle, comma-separated): ~frodo
Subject: lunch?
Enter your message. End with a single "." on its own line.
| Want to get lunch after the council?
| .
Attach an object? (name or blank): 
Send to ~frodo? (y/n) y
Sent. (#4 in your OOC mailbox)
```

GMCP (client-driven window): the client collects recipient, subject, body, and
optional attachment locally, then sends one message. No server prompts occur.

    C: Post.Mail.Send { "mailbox": "ooc", "to": ["frodo"], "subject": "lunch?",
                         "body": "Want to get lunch after the council?" }
    S: Post.Mail.Sent { "mailbox": "ooc", "id": "4" }

If the recipient is unknown, blocked, or accepting contacts-only mail from
strangers, both surfaces report the same refusal. Text prints "That person is
not accepting your mail."; GMCP returns `Post.Mail.Error { code: not_permitted }`
or `not_found`, which the window shows in place.

The "Attach an object?" step and the `attach` field arrive with the escrow
phase; earlier phases compose text-only mail and omit them.

### Reply

Trigger: `(r)eply` on an open message, or the window's reply button. Reply
pre-fills the recipient from the message's `from` and the subject with "Re:",
then runs the same compose flow. IC replies go back to the character; OOC replies
to the handle. The player never types the address.

### Delete and undo

```
> d 2
Deleted #2. (Undo with "u".)
> u
Restored your mailbox to before the delete.
```

Delete is soft. Undo reverts the mailbox to its previous state and is itself
recorded, so a second undo is safe. GMCP: `Post.Mail.Delete` then
`Post.Mail.Undo`, each answered with `Post.Mail.Box`; the window re-lists on the
new `gen`. On a server with no history, undo is unavailable and the menu omits
it; GMCP returns `unsupported`.

### Per-mailbox settings: signature and receive mode

Each mailbox carries its own settings, because the mailbox is the identity.

```
--- Mail : Gandalf : Settings ---
  Signature:    "-- Gandalf the Grey"
  Receive mode: open        (contacts-only requires contacts)
Change (s)ignature, (m)ode, (q)back
> m
Receive mode for Gandalf: (o)pen or (c)ontacts-only?
> c
Gandalf now accepts mail only from your confirmed contacts.
```

So a player can leave a character's IC mailbox open for roleplay while setting
the OOC mailbox to contacts-only against spam. GMCP:
`Post.Mail.Prefs { mailbox: "Gandalf", receive_mode: "contacts-only" }`.

### Contacts: address book, requests, presence, blocking

Contacts is reached from the account menu, and it enriches composing (pick a
recipient from your list instead of typing a name).

```
--- Contacts ---
  * Frodo        (online)   confirmed
  * ~samwise     (offline)  confirmed
  ~ Pippin                  request sent
  ! Sauron                  blocked
Add, (r)equest, (a)ccept, (b)lock, (q)back
> r
Send a contact request to (name or handle): Merry
Request sent to Merry.
```

- Adding and requesting take the name the game already exposes (a character name
  or a handle). No hidden identifiers.
- Presence rides live: when Frodo logs in, a confirmed contact's line flips to
  online. Text clients see it on the next open; GMCP clients get a
  `Post.Contacts.Delta { kind: presence }` and update in place.
- Blocking is account-level and silent. Unfriending offers a block on the
  confirmation, so a clean cut is one step.
- Confirmation is per identity: befriending Frodo does not reveal that Frodo and
  Pippin are the same account.

### A notification arrives while you are playing

New mail should reach a player who is out in the world, not buried in a menu.

- Text: a brief line, framed to the surface. IC delivery reads "A courier hands
  Gandalf a sealed letter." OOC delivery reads "[OOC] New mail from ~frodo."
- GMCP: `Post.Mail.Notify { mailbox, unseen, latest }` so the client updates a
  badge or unread count without opening anything.

The player then walks to a mailbox (IC) or opens the account menu (OOC) to read.

## Compose in detail: the two paths

Composition is where "no prompts over GMCP" forces two implementations. Build
both; they meet at a single send.

- Text path (server-driven form). A callback form state machine collects
  recipient, subject, body (multi-line, terminated by a lone "."), and optional
  attachment, then calls `send`. This reuses the same form machinery as login and
  character creation. The player answers one prompt at a time.
- GMCP path (client-driven window). The client owns the compose UI. It gathers
  every field locally and sends one `Post.Mail.Send`. The server issues no
  prompts and runs no form; it validates and replies `Post.Mail.Sent` or
  `Post.Mail.Error`.

Detecting which path: check whether the session advertised `Post.Mail` in
`Core.Supports`. If yes, on a compose trigger the server tells the client to open
its compose window (or the client already did, from its own button) and does not
start a text form. If no, the server starts the text form. A player on a GMCP
client never sees the form; a player on a plain client never waits on a window
that will not appear.

Recipient entry benefits from contacts on both paths: the text form accepts a
name or handle and can list confirmed contacts on request; the window offers an
address-book picker.

## Developer guidance

- One controller, two selectors. Route the account-menu entry and the mailbox
  object verb into the same mail controller. The account menu passes the account
  (OOC plus a character list); the object passes the acting character. Everything
  downstream keys off the `mailbox` selector.
- Do not add a global verb. Keep access to the menu and the object. It preserves
  the IC/OOC framing and avoids a `mail` verb colliding with player-defined
  object verbs.
- Gate GMCP on capability. Emit `Post.Mail.*` only to sessions that advertised
  the module. Never assume a window exists.
- Keep the text surface complete. Every operation must be reachable and usable
  as text. Treat GMCP as a rendering upgrade of an already-working flow.
- Suppress redundant text for window users. When a GMCP client opens a mail
  window, replace the text menu with a short notice rather than dumping a menu
  the player will not read. Keep the one IC line for in-world flavor.
- Reconcile, do not assume. The window folds in `Notify` and `Delta` pushes and
  re-lists when `modseq`/`gen`/`seq` show a gap. Do not treat a push as an
  acknowledged transaction.
- Notifications reach the world. Deliver the new-mail notice to the player
  wherever they are, framed IC or OOC to match the mailbox, in addition to the
  GMCP `Notify`.

## Graceful degradation, summarized

| Player is on...          | Reads mail via            | Composes via              |
|--------------------------|---------------------------|---------------------------|
| A GMCP client            | mail window (pushed data) | client compose window     |
| A plain telnet client    | text menu / mailbox object| server-driven text form   |

Same triggers, same operations, same storage. The only difference is the surface
the server presents, decided by one capability check.

## Open questions

1. Where do IC mailbox objects live: only a central post office, or also
   placeable personal mailboxes in player housing? The design supports both; it
   is a content decision.
2. Should the account menu expose a combined "all unread across mailboxes" view,
   or always drill in per mailbox first?
3. Whether OOC-mail delivery should notify only at the account menu, or also
   interrupt in-world play with an `[OOC]` line (the draft assumes the latter,
   quietly).
