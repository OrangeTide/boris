---
title: User Accounts & Login
status: backlog
gitlab-sync: OrangeTide/boris#39
---

Complete user account schema and login flow. See doc/user-accounts.md.

- [ ] LOCKOUT/LOCKOUTTEXT -- operator-set lockout flag with reason shown at login
- [ ] LASTLOGINS -- fixed-size ring of {time, ip, success} entries
- [ ] LOGINCOUNT/TOTALLOGIN -- active session vs. lifetime counters
- [ ] SINCE -- account creation timestamp
- [ ] complete login process (login.c:46)
- [ ] form close-out callback (form.c:306)
- [ ] user creation flow and approvable system disconnect (form.c:498/508)
- [ ] disconnect logging -- determine if connection was logged in before cleanup (telnetclient.c:269)
