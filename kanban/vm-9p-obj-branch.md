---
title: Read-only /obj branch of the in-world 9P server
status: backlog
---

The in-world 9P server (`src/vfs/p9_vfs.c`) serves the content-addressed VFS
to guests. Add a read-only `/obj` branch so a guest can read object state
(for example `/obj/<id>` as the object's JSON), with writes refused (EACCES or
EROFS).

This lets a game program inspect objects through the filesystem rather than
only through the host-call band, keeping the capability surface small.

## Tasks

- [ ] Special-case an `/obj` path prefix in the 9P walk/open handlers.
- [ ] Serve `/obj/<id>` read-only from the object store (object JSON).
- [ ] Refuse writes and creates under `/obj`.
- [ ] A unit test: walk/open/read `/obj/<id>`, assert writes fail.
