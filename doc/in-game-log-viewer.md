# In-Game Log Viewer and Help Hyperlinks

Two distinctive items from mworld's `TODO.txt` that age well as
generic MUD-server features and that boris does not yet cover.

## Queryable in-game log

The server already writes structured log lines. The idea is to make
those logs browsable and searchable from inside the game by
privileged users, without shelling out to the host.

Minimum useful scope:

 - Every log line has a timestamp, subsystem tag, severity, and
   message. Boris's `log.h` already provides this shape.
 - An admin command exposes a filtered view:
     - by time range (absolute or relative: "last 30m")
     - by subsystem (login, command, channel, ...)
     - by severity floor
     - by substring / regex match on the message
 - Results paginate through the pager interface (see below).
 - Logs worth surfacing beyond errors: every `say`, every admin
   command, every login and logout, every account lockout. These
   are the queries operators actually ask for after an incident.

Implementation notes:

 - A ring of recent lines in memory serves the common "last N"
   queries without touching disk.
 - Older queries fall through to the on-disk log. Memory-map the
   file and scan; do not read line-by-line into a fixed buffer.
 - Filtering runs in the admin's session, not the log writer's
   path, so a slow query never stalls the server.
 - The filter surface is the contract; the backing store
   (in-memory ring, on-disk file, external sink) is an
   implementation detail.

## Help hyperlinks

Help topics cross-reference each other. Today that means "see also:
FOO" as plain text the user has to re-type. Hyperlinks make those
references clickable-or-equivalent.

Rendering by client:

 - Web client: real `<a>` tags that invoke `help FOO` through the
   existing command channel.
 - Telnet with MXP or similar: emit the MXP link tags around the
   topic name.
 - Plain telnet: render as the topic name in the "link" palette
   color. The user still has to type `help FOO`, but the visual cue
   is there and the authored source is the same.

Authoring syntax (proposed): a token embedded in help text that
names a topic, for example `[[FOO]]` or `{help FOO}`. The renderer
picks the appropriate output form per client. Authors write once;
the help system handles per-client expansion alongside the color
macro pass (see `text-macros.md`).

## Related small items

From the same list, worth tracking but smaller:

 - Editable help files through an in-game editor (touches the
   privilege model more than the storage).
 - Per-user aliases (expansion happens before symbol-command
   dispatch; see `input-filtering.md`).
 - Pager interface for any long output (help, logs, wizlist,
   who-list). One implementation serves all of them.
 - Light/dark palette selection, which falls out of the macro
   system in `text-macros.md`.
