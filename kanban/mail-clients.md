---
title: Mail client extensions (Birdie, Mudlet, Blightmud)
status: backlog
gitlab-sync:
---

Client-side mail user agents over the mail bindings. See
doc/mail-protocol-proposal.md "Client targets". Priority: Birdie and Mudlet
first, Blightmud a stretch goal.

The shared JSON schema and coarse-grained, one-document-per-message
operations are chosen so a Lua author (Mudlet, Blightmud) and a C author
(Birdie) write the same logic against the same schema.

## Tasks

- [ ] Birdie MUA (highest priority): three-pane Eudora/Claws-style client
      over the MCP binding using birdie-gui widgets (data table, message
      pane, compose). Move to GMCP when Birdie's GMCP support lands.
- [ ] Mudlet package (highest priority): GMCP event handlers
      (gmcp.Post.Mail.Index/Message/Notify), sendGMCP requests, Geyser UI.
- [ ] Blightmud plugin (stretch): thin Lua layer over the GMCP binding.
