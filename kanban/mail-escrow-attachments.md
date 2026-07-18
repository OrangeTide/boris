---
title: Mail object attachments via escrow service
status: backlog
gitlab-sync: OrangeTide/boris#85
---

Object attachments for mail, delegated to a hypothetical escrow service.
See doc/mail-protocol-proposal.md "Attachments: delegate to an escrow
service". Depends on mail-core. Advanced / later phase.

Mail never carries the object. An attachment descriptor holds
`{name, desc, escrow:{service, token, expires}}`. The escrow service owns
custody, claim, expiry, and return-to-sender. Because the escrow reference
is inside the immutable content blob, reading/flagging/moving mail never
touches it.

No escrow service exists yet. The claim/return contract mail depends on is
pinned in doc/mail-protocol-proposal.md "Escrow service contract (pinned)";
build mail against that interface. The service itself is separate work.

## Tasks

- [ ] Attachment descriptor schema `{name, desc, escrow:{service, token,
      expires}}` in the shared mail schema.
- [ ] On send: deposit the object with the escrow service, record the
      returned token in the descriptor.
- [ ] On claim: recipient presents the token to the escrow service.
- [ ] Return-to-sender on token expiry (escrow-service responsibility;
      mail depends on the pinned contract, not the implementation).
- [ ] Open sub-question, not blocking: in-process vs separate service, and
      bearer vs identity-bound claims (see proposal open question 1).
