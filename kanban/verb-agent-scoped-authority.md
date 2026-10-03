---
title: Scoped Agent Authority
status: done
gitlab-sync:
---

From the agent-authority review of the [[vm-object-model]] card. Resident agent
tasks run with no effective owner, so verb_may_modify never checks them: an
agent can write, move, recycle, or create against any object. This is accepted
today because only the administrator launches agents (the vm.resident config and
the supervisor in boris; no guest or player path spawns one), but it is the one
structural weakness in the authority model. A buggy or confused-deputy agent
acts with unrestricted authority.

This is a model change, not a bug fix, so it is deferred. The idea: run an agent
as the owner of its self object (its %owner) rather than as the system, so its
authority is bounded to one identity. An agent that needs more would elevate
with sys_setpriv the same way a verb does.

Started. Key finding from investigation: nothing stamps %owner on program
objects (programs/<id>); only hc_create/obj_set_owner set %owner, and those act
on guest-created world objects. A resident agent's self IS a program object, so
it has no %owner. Seating eff_owner from self.%owner therefore leaves every
resident agent at NULL (system) -- unchanged -- and only scopes agents launched
on an owned object (today just the launch_image path). So item 2 (the no-%owner
case) is the decision that determines whether this change bounds real agents.

Decisions (from review):
- No-%owner program objects become unlaunchable as agents. A program must carry
  an %owner to run as an agent, so every agent is bounded by an identity.
- sys_setpriv AS_CALLER for an agent resets to its own launch identity (its
  self object's owner), never to NULL/system.

- [x] seat the agent's effective owner from its self object's %owner at
      agent_start, instead of leaving it NULL (system), in src/verb/verb_agent.c
- [x] refuse to launch an agent whose self object has no %owner
- [x] AS_CALLER for an agent resets to its own owner (real_owner), not NULL;
      WIZ_ON gated by the owner's account; AS_OWNER resets to the owner
- [x] update the agent-authority guidance in doc/mud-vm-design.md once the model
      changes

Done. test_verb_dispatch stamps %owner on its agent selves and asserts an
owner-less self is refused. Operational note: resident programs listed in
vm.resident must now carry an %owner, or they will not launch as agents.
