---
title: Formal GMCP module spec format
status: backlog
gitlab-sync: OrangeTide/boris#80
---

A formal, publishable specification format for the GMCP modules Boris defines,
since GMCP has no central registry and expects each server to document its own
packages. See doc/gmcp/README.md. Modeled on Khronos OpenGL extension specs.

These specs are the publishable, self-contained authority for their wire
protocol (each carries its own Data Model; storage is out of scope). Boris
implementation, HTTP/MCP bindings, and storage stay in the project proposal
docs. The first two specs, POST_mail.txt and POST_contacts.txt, exist as
drafts at Revision 1.

## Tasks

- [ ] Maintain the spec template and conventions in doc/gmcp/README.md
      (vendor-neutral Post. suite, PascalCase Package.Message, integer
      Core.Supports versions, self-contained Data Model per spec).
- [ ] Keep each spec self-contained and free of Boris-internal storage details.
- [ ] Hold revisions at 1 until first publish; advance the revision number only
      after publishing.
- [ ] Keep the module registry table current as modules are added.
- [ ] Review POST_mail.txt and POST_contacts.txt against the format before
      implementation; resolve their Issues sections.
- [ ] Decide where published specs are served to third-party client authors
      (repo doc/gmcp vs a docs site).
