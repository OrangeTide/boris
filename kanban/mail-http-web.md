---
title: Mail HTTP/JSON binding and web MUA
status: backlog
gitlab-sync: OrangeTide/boris#87
---

HTTP/JSON REST binding for the mail feature plus a mail user agent view in
the in-house web client. See doc/mail-protocol-proposal.md "Transport
binding C". Depends on mail-core and mail-store-muddb. This is the phase-1
end-to-end path since it runs entirely on infrastructure that exists.

Reuses the existing 32-char SSE session token for auth (no second login),
resolved via webclient_find_session() to the account.

## Tasks

- [ ] Routes in webserver.c dispatch: GET /mail (enumerate mailboxes),
      GET/POST /mail/{box}, GET/PATCH/DELETE /mail/{box}/{id}, POST
      /mail/{box}/expunge, POST /mail/{box}/undo, GET/PUT /mail/{box}/prefs
      (per-mailbox receive_mode + signature), GET/PUT /mail/prefs (account
      handle), POST/DELETE /mail/blocks. {box} is "ooc" or an owned character
      name. Full parity with GMCP.
- [ ] Compose by POST /mail/{box} with to:[name]; 403 when blocked,
      contacts-only-refused, or the account does not own {box}.
- [ ] Bearer-token auth from the existing web session; 401/403/404/409/413/501
      as specified.
- [ ] Push `notify` over the existing /events SSE stream (reserve a prefix
      or named SSE event line for mail).
- [ ] Web client MUA: header list, message pane, compose, IC/OOC class and
      per-character filtering, live refresh on notify.
