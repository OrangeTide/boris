---
title: Mail UI controller (account menu + mailbox object)
status: backlog
gitlab-sync:
---

The in-game access layer for mail and contacts: the account-menu entries and the
in-world mailbox object, both routed into one mail controller. See
doc/mail-design.md (experience) and doc/mail-implementation.md (controller and
integration). Depends on mail-core; parallels the web MUA (mail-http-web).

Access matches the fiction: out-of-character mail is a menu item; in-character
mail is a physical mailbox you walk to (e.g. the town post office). No global
`mail` verb.

## Tasks

- [ ] Account-menu "Mail" and "Contacts" entries that enter the controller with
      the account context and the full mailbox list (OOC + owned characters).
- [ ] Mailbox object with a verb that enters the controller scoped to the acting
      character's IC mailbox; place one in a post office room.
- [ ] Controller context: authenticated account, selected mailbox, session
      capability flags; one controller serving text and GMCP surfaces.
- [ ] Capability flag set when a session advertises Post.Mail/Post.Contacts;
      gate all GMCP emission and choose window-vs-text on it.
- [ ] Text menu/list surface (callback state machine) for read/delete/undo/
      settings; suppress redundant text (one-line notice) when a GMCP window is
      open, keep the IC flavor line.
- [ ] Notification path on delivery: text notice framed IC (courier line) or OOC
      ([OOC] line) to connected recipient sessions, plus Post.Mail.Notify to
      advertised sessions.
