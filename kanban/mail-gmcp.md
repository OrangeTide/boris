---
title: Mail GMCP binding (Mudlet)
status: backlog
gitlab-sync:
---

GMCP transport binding for the mail feature, the path for Mudlet and other
GMCP clients. Implemented against the formal spec doc/gmcp/POST_mail.txt.
Depends on mail-core and on the base GMCP option support (see the gmcp card)
and the shared spec format (see gmcp-module-specs).

Module `Post.Mail`, capability token `Post.Mail 1`, carrying the shared mail
JSON schema. Server emits Post.Mail.* only to clients that advertise it.

## Tasks

- [ ] Client->server: Post.Mail.Mailboxes/Stat/List/Fetch/Flag/Send/Delete/
      Expunge/Undo/Block/Unblock/Prefs (mailbox selector on message ops).
- [ ] Server->client: Post.Mail.Boxes/Box/Index/Message/Sent/Prefs/Ok/Notify/
      Error.
- [ ] Gate on the Post.Mail capability from Core.Supports.
- [ ] Reuse the shared JSON schema; no field remapping.
