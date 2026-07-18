---
title: Mail MCP 2.1 binding (Birdie)
status: backlog
gitlab-sync:
---

MCP 2.1 transport binding for the mail feature, the near-term path for
Birdie (which speaks MCP today; its GMCP support is planned but not built).
See doc/mail-protocol-proposal.md "Transport binding A". Depends on
mail-core.

Every message carries a single multiline `json*` value holding the shared
mail JSON schema, rather than mapping fields onto flat MCP keys. This keeps
one schema across all bindings and is friendly to a scripted client.

## Tasks

- [ ] Register package `dns-org-mud-boris-mail` 1.0 in the mcp-negotiate-can
      list and the input_message() dispatch.
- [ ] Messages: -mailboxes/-boxes/-stat/-box/-list/-index/-fetch/-message/
      -flag/-send/-sent/-delete/-expunge/-undo/-block/-unblock/-prefs/-notify/
      -error, each a `json*` multiline payload (mailbox selector on message
      ops).
- [ ] Keep MAIL_BODY_MAX below MCP_CONTENT_MAX (64 KiB).
- [ ] Reuse the existing MCP per-message auth key; no new auth path.
