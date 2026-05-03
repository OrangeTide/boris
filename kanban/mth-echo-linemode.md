---
title: MTH Echo/Linemode Cleanup
status: backlog
gitlab-sync: OrangeTide/boris#31
---

Replace dead dyad_write calls in #if 0 blocks with MTH-based
echo and linemode negotiation.

- [ ] replace dead echo negotiation (telnetclient.c:621)
- [ ] replace dead linemode negotiation (telnetclient.c:646)
