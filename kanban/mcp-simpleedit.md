---
title: MCP Client-Side Editing
status: done
gitlab-sync: OrangeTide/boris#49
---

Implement the MUD Client Protocol (MCP 2.1) so telnet clients can edit
server-side text in a local editor via the dns-org-mud-moo-simpleedit
package. The @edit command now works from MCP-capable telnet clients in
addition to the web client.

- [x] MCP 2.1 out-of-band message parsing and version negotiation (src/mcp.c)
- [x] mcp-negotiate package with client capability tracking
- [x] dns-org-mud-moo-simpleedit send (content offer) and receive (set)
- [x] only references handed out on the same connection are accepted back
- [x] hook into telnet line input, banner on connect, state freed on close
- [x] @edit dispatches to web SSE editor or MCP simpleedit by client type
- [x] unit tests (test_mcp) and end-to-end verification against the server
