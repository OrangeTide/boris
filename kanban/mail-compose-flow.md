---
title: Mail compose flow (text form + GMCP window)
status: backlog
gitlab-sync:
---

The two compose paths that meet at one send, because GMCP cannot prompt. See
doc/mail-design.md "Compose in detail" and doc/mail-implementation.md
"Compose: two paths". Depends on mail-ui-controller and mail-core.

Composing from a mailbox fixes the sender identity and class (the mailbox is the
identity); the player never types an address for a reply.

## Tasks

- [ ] Text path: a callback form (src/mail/mail_form.c) collecting recipient,
      subject, multi-line body (terminate on a lone "."), optional attachment;
      then call the send operation. Reuse the login/character-creation form
      pattern.
- [ ] GMCP path: client owns the compose window and sends one Post.Mail.Send;
      server runs no form, validates and replies Sent or Error.
- [ ] Controller picks the path from the session capability flag on a compose
      trigger.
- [ ] Reply pre-fills recipient from the message from and subject with "Re:";
      IC replies to the character, OOC to the handle.
- [ ] Recipient help from contacts on both paths (list confirmed contacts /
      address-book picker); plain name/handle entry always works.
- [ ] Apply the mailbox signature when composing from that mailbox.
