# User Accounts

This document describes the user-account layer: what an account
is, how it is stored, and what the API surface looks like. Fields
that are not yet implemented are marked **(future)**.

An **account** is distinct from a **character**. An account is the
login identity (name + password + contact info + permissions). A
character is an in-world persona owned by an account. One account
may own several characters. Characters live in a separate LMDB
domain and are covered in their own code path.

## Storage

Accounts are stored in the `users` LMDB domain (`DOMAIN_USER`),
keyed by username. Each value is an `OBJ` serialized to JSON. See
`DEV.md` for the muddb domain table and API.

Access is through `src/user.c`:

 - `user_lookup(name)` -- load and refcount an account by username.
 - `user_create(name, password, email)` -- create a new account.
 - `user_password_check(u, cleartext)` -- verify a password.
 - `user_get` / `user_put` -- refcount management.
 - `user_init` / `user_shutdown` -- subsystem lifecycle; preloads
   the in-memory user index from the `users` domain at startup.

## Current fields

`struct user` in `src/user.c` holds:

 - `id` -- numeric id, allocated from a freelist.
 - `username` -- login name; also the muddb key.
 - `password_crypt` -- hashed password (sha1crypt today; see
   `src/crypt/`). Never stored or logged in cleartext.
 - `email` -- contact address.
 - `acs` -- access-control flags (level + flag bits).
 - `extra_values` -- open attribute bag for fields not yet
   promoted to struct members. Serialized alongside the named
   fields in the JSON blob.

## Proposed fields (future)

Inspired by mworld's account schema. These can land in
`extra_values` first and be promoted to named struct fields only
if they prove load-bearing. Tracked in TODO.md under "user account
schema."

 - **LOCKOUT** (future) -- boolean operator-set lockout.
   Recoverable state, distinct from an ACS permission change: an
   operator flips it to block a login path without editing the
   account's privileges.
 - **LOCKOUTTEXT** (future) -- human-readable reason shown to the
   user at login when LOCKOUT is set. Lets operators communicate
   cause ("pending email verification", "security review") without
   the user having to guess.
 - **LASTLOGINS** (future) -- fixed-size ring of the last N
   logins, each entry `{time, ip, success}`. Two consumers: show
   the user their last successful login on next login, and give
   operators an audit trail without needing log-file access.
 - **LOGINCOUNT** (future) -- current active session count.
   Incremented on login, decremented on logout. Answers "is this
   account in use right now."
 - **TOTALLOGIN** (future) -- lifetime successful-login counter.
   Answers "how established is this account." Kept separate from
   LOGINCOUNT because the two questions have different answers.
 - **SINCE** (future) -- account creation timestamp. Useful for
   display ("member since ...") and for age-based policy.

## Security

 - Passwords are stored hashed. The crypt implementation lives in
   `src/crypt/`; see sha1crypt.c. New hashes use the current
   default; verification supports whatever the stored hash
   identifies itself as.
 - Usernames go through `user_illegal()` before any storage lookup
   to reject names that would collide with protocol tokens or
   filesystem paths.
 - The user index is refcounted. Callers must pair `user_lookup`
   or `user_get` with `user_put`.

## Account vs. character linkage (future)

Today a user does not carry an explicit list of owned character
ids. Character ownership is inferred from a field on the character
record. A future `CHARACTERS` attribute on the user record would
make the reverse direction directly queryable without iterating
the `chars` domain. This is not urgent -- preflight iteration at
startup already builds the index in memory -- but it is the
natural place for that data if the iteration cost ever matters.
