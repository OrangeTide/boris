---
title: Eventlog Rename
status: backlog
gitlab-sync: OrangeTide/boris#26
---

Rename boris.log to boris.eventlog, use boris.log for log.c output.

- [ ] rename eventlog file boris.log -> boris.eventlog
- [ ] fix trailing newline in default eventlog filename (common.c:1383)
- [ ] wire log.c output to boris.log
