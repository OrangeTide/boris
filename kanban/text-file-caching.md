---
title: Text File Caching Consolidation
status: backlog
gitlab-sync: OrangeTide/boris#17
---

Wire welcome.txt and other data/text consumers to use the same
cache/invalidation pattern as help.c (string-keyed hash table,
SIGHUP invalidation via help_cache_invalidate).

- [ ] identify all text file consumers (welcome.txt, etc.)
- [ ] wire consumers to help.c cache system
