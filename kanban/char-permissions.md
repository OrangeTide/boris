---
title: "char" Command Permissions
status: backlog
gitlab-sync: OrangeTide/boris#2
---

"char new" and "char set" have no permission checking and can be
run multiple times. "char get" reveals too much to normal players.

- [ ] add permission checks to char new, char set
- [ ] prevent duplicate char new calls
- [ ] restrict char get output for non-admin players
