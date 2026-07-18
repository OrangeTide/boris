# Boris GMCP Module Specifications

GMCP has no central registry. The specification states plainly that "each MUD
server is expected to define and document its own packages." This directory is
where Boris does that: one formal specification file per GMCP module we publish,
written to a fixed template so a client author can implement against a stable
document.

These specs are the publishable, self-contained authority for their wire
protocol. Each `<MODULE>.txt` stands on its own: any server may implement it and
any client may consume it, with no dependency on Boris internals. Storage is out
of scope in every spec; a server decides how it stores its data. The Boris MUD
implementation, its storage layout, and its HTTP and MCP bindings are documented
separately in the Boris project docs (`doc/mail-protocol-proposal.md`,
`doc/contacts-protocol-proposal.md`), which are project-internal planning, not
part of the published protocol.

The template is modeled on the Khronos Group's OpenGL extension specifications,
which have served the same purpose (a third party implementing against a
documented extension) for decades.

## GMCP conventions Boris follows

These apply to every module spec here.

- Transport. `IAC SB GMCP <Package.Message> <json> IAC SE` over telnet option
  201. The `<json>` payload is UTF-8. JSON key names are case-sensitive; package
  and message names are case-insensitive but written in PascalCase.
- Namespace. The modules live under a neutral `Post.` suite (`Post.Mail`,
  `Post.Contacts`) rather than a name tied to one MUD, so any server can advertise
  them without collision. Messages are `Post.<Module>.<Message>`, for example
  `Post.Mail.Index`. Mudlet exposes these to scripts as `gmcp.Post.Mail.Index`.
- Negotiation. The client advertises support with
  `Core.Supports.Set [ "Post.Mail 1", "Post.Contacts 1" ]`. Versions are
  integers. A later-sent version supersedes an earlier one. The server sends a
  module's messages only to a client that advertised it.
- Versioning. The integer after the module name in `Core.Supports` is the module
  version. A backward-incompatible change increments it. Additive,
  backward-compatible messages or fields do not.
- Self-contained. Each spec defines its own Data Model (the JSON payload shapes)
  so it can be read and implemented without any other document. Boris's other
  bindings reuse that same schema.
- Revisions. A module stays at Revision 1 while unpublished; the revision number
  starts advancing only once a spec is published and changes afterward.

## Specification template

Each `<MODULE>.txt` file uses these sections, in order:

```
Name
    The module name, e.g. Post.Mail.

Name String
    The Core.Supports token, e.g. "Post.Mail 1".

Status
    Draft | Proposed | Complete, and where it is implemented.

Version
    Last modified date and revision number.

Number
    The module's number in this registry (this directory).

Dependencies
    GMCP (telnet 201), Core.Supports, and any other modules required.

Overview
    What the module does; self-contained, with storage out of scope.

Data Model
    The JSON payload shapes the messages carry.

Negotiation
    The Core.Supports token and any handshake specifics.

Messages: Client to Server
    Each message: name, JSON payload schema, semantics, errors.

Messages: Server to Client
    Each message, including server-initiated events.

Errors
    The error message shape and the defined error codes.

Issues
    Open questions, numbered, with resolutions recorded inline.

Revision History
    Dated list of changes.
```

## Registry

| Number | Module          | File                 | Boris implementation notes |
|--------|-----------------|----------------------|----------------------------|
| 1      | Post.Mail      | `POST_mail.txt`     | doc/mail-protocol-proposal.md |
| 2      | Post.Contacts  | `POST_contacts.txt` | doc/contacts-protocol-proposal.md |
