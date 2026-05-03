---
title: Remove Per-File Version Headers
status: backlog
---

34 source files still have per-file @version headers. Global version
is tracked in boris.h (BORIS_VERSION_MAJ/MIN/PAT). Remove per-file
headers, keep only boris.h as the single source of truth.

- [ ] remove @version headers from 34 source files
- [ ] verify boris.h BORIS_VERSION is the sole version source
