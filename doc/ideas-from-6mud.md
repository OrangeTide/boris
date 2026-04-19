# Ideas from 6mud

Raw brainstorm notes carried over from the author's earlier MUD project
(`6mud/IDEAS.txt`). Preserved here for future evaluation; not decisions.

## Original notes (verbatim)

- OOC chat system censors users saying the name of their own character.

- shadow objects. builders can create/modify objects and they exist as
  shadows. once a shadow has been approved it appears in the actual system.
  (i don't know how this could work unless every object supports revision
  history)

- simple "builder port". A free for all on the builder port. then entire
  lists of object ids can be imported to the system by the admin. only has
  builder accounts installed. ( release code + builder db )

- "coder port" is the current CVS version of the system running the devel db.
  ( devel code + devel db )

## Commentary

- **OOC name censor** — cheap anti-metagaming nudge. Low-effort to
  prototype on top of the existing channel subsystem.
- **Shadow objects** — workflow idea: builder edits live as pending
  overlays until an admin approves. Ties naturally to the JSON
  copy-on-write obj representation; a "shadow" is a diff layer over the
  base object. Non-trivial, but aligns with existing infrastructure.
- **Builder port / coder port** — the "run multiple instances with
  different ports, configs, and DBs" pattern. Already partially
  supported by boris's config system; mainly a deployment/ops convention.
- **CVS** — replace with git in any modern implementation.
