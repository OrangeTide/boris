# Plan: Open Boris to Builders

Near-term roadmap for turning Boris from an operator-only world into one
where trusted **Builders** create rooms, items, and NPCs from inside the
game, using a menu-based On-Line Creation (OLC) editor.

This is a planning document. Decisions marked **PROPOSED** are defaults
that still need sign-off. Open questions are collected at the end. Cards
referenced as `#N` are the GitLab-synced kanban files in `kanban/`.

## 1. Goals

1. **A Builder-open MUD.** A player granted the Builder role can create
   and edit rooms, items, and NPCs that persist to the world store, and
   can do so without operator shell access or a server restart.
2. **A menu-based OLC.** Building happens through an interactive,
   menu-driven editor (README calls it "an interactive wizard provides
   menu-based building"), not by hand-editing JSON or by memorizing a
   large `@`-command vocabulary. The editor is the primary Builder
   surface and must be friendly to non-programmers.

## 2. Sub-goals (things the top-line goals imply)

These are the parts that are easy to leave implicit and expensive to
retrofit. Each is expanded in the phases below.

- **A Builder role and permission checks.** Today no command checks
  privilege (`#2`, `#3`). The ACS layer (`src/acs.c`, level + flag
  bitset) exists but is unenforced. Opening building to non-operators
  requires that gate to actually close.
- **An ownership / scope model.** Which rooms may a given Builder edit?
  The room schema already carries `creator` and `owner`. We settled on
  open editing with `creator` recorded (section 4); we still need the
  stamping, not just the fields.
- **Protection against lost builder data.** The moment non-operators
  create content, that content is worth backing up. We need in-game
  commands to snapshot / checkpoint / export the world so a bad edit,
  a wipe, or a crash does not cost a builder their work. Design already
  exists in `doc/snapshot-proposal.md`.
- **A grouping unit for content (zones/areas).** `dig` "from a zone
  template" (`#6`), per-Builder quotas, and "edit only my area" all lean
  on a grouping concept that does not exist yet.
- **Safe creation primitives.** `room_create()`, exit linking, and
  validation (target exists, no duplicate id) do not exist. `char set`
  corruption (`#3`) shows what unchecked creation costs.
- **A single save choke point.** Needed so validation, ownership
  checks, and later versioning (`#14`) hook in one place instead of
  being scattered.
- **Round-trip confidence.** Entity/room load-save tests (`#12`) before
  we let untrusted content authors write to the store.
- **A spec-first, test-backed working method.** Each feature here is new
  surface with data-loss and regression risk. We write a design spec and
  ship tests with the code rather than after (section 5).

## 3. Where we are today

Grounding for the plan (from a source survey):

- **Commands** are a static `command_table[]` in `src/cmd/cmd.c`;
  dispatch is a case-insensitive linear match. No permission check runs
  on any command.
- **Permissions**: `struct acs_info` (`src/acs.h`) holds an unsigned
  `level` (0-255) and a flag bitset; `acs_check(ai, "s6fB")` tests
  "level >= 6 AND flag B". Persisted per user as `acs.level`. No named
  roles, no command enforces it.
- **Editing**: `@edit` / `@view` (`src/cmd/edit.c`) edit a single
  property of an existing room via the web editor or MCP simpleedit
  (`#49`, done). There is no editor that creates objects or walks a
  Builder through the fields of one.
- **Menus/forms**: `src/menu.c` (numbered-item callback menus) and
  `src/form.c` (field-by-field forms with per-field validation and a
  close callback) exist and drive the login menu and account creation,
  but they are fragile and do not fit an OLC. Details below; this is
  the critical path for the menu editor.
- **Objects**: game objects are OBJ (copy-on-write JSON). Rooms live in
  domain `objs` under key `rooms/<id>`; `%`-prefixed metadata such as
  `%parent` is protected from player edits. Exits are
  `exit.<dir>.to` / `exit.<dir>.desc`. Prototype inheritance via
  `%parent` resolves up to 5 levels (`templates` domain,
  `src/entity/`).
- **No zone concept, no `room_create()`, no builder commands** beyond
  property editing. Entity (PC/NPC/creature) system exists but is not
  wired to any command.

The infrastructure is largely present. The missing pieces are the
**role gate**, the **creation/editing commands**, and the **menu OLC**
that ties the interactive UI layer to the object model. That UI layer
itself needs a rebuild first (next section).

### 3a. Why menu.c / form.c must be reworked first

The menu and form modules were built for a fixed login flow. An OLC
asks different things of them, and the current design does not stretch
that far:

- **Type-unsafe callback ABI.** Menu actions are
  `void (*func)(void*, long, void*)` with `extra2` / `extra3`
  (menu.c:70). `DESCRIPTOR_DATA *` is passed as `void *` and cast back
  at every call site (menu.c:177). Forms bolt onto the same signature
  (`form_start(void *p, long, void *form)`).
- **Global, single-instance state.** There is one static
  `form_newuser_app`, and `form_module_init` attaches validators by
  reaching in by field *name* (form.c:702-728). Menus are static
  `struct menuinfo` shared by every session. An OLC needs a
  *per-session* editor whose fields come from the object being edited,
  not from a compile-time struct.
- **Display and selection numbering can desync.** `form_menu_show`
  skips invisible items while advancing both the printed number and the
  list cursor (form.c:214-231); `form_menu_lineinput` skips them
  differently on selection (form.c:324-332). The number a user sees and
  the item they select can diverge.
- **Unchecked allocations, incomplete lifecycle.** `menu_create` /
  `menu_additem` do not check `malloc` / `strdup`; the duplicate-key
  check is a `LOG_TODO` (menu.c:76); form close-out is a `LOG_TODO`
  (form.c:306). These are the open `#29` and `#39` (form.c:306) items.
- **No nesting, cancel, or context.** Editing a room means
  "room menu -> exits sub-menu -> one exit -> back", suspending to
  `@edit` for a long description and resuming, and freeing cleanly if
  the client disconnects mid-edit. None of this exists today.

### 3b. Protocol options for interactive menus and forms

The rebuilt UI layer should render one abstract model across clients of
different capability. What the wire already offers:

- **MXP (MUD eXtensible Protocol)** — HTML-like inline markup with
  clickable commands (`<send>`), right-click popup menus, and links.
  Menu-friendly, weak on text-input fields. Rendered by Mudlet,
  MUSHclient, zMUD/cMUD. Already present but disabled in MTH
  (`{"MXP", 0}` at mth.c:211), so enabling it is a small lift.
- **GMCP** — JSON packages over TELNET option 201. Not a form protocol
  itself; it is the transport for client-rendered UI (a Mudlet/custom
  package draws panels from server JSON). MTH already announces GMCP;
  `#27` is the unfinished game-side wiring.
- **MSDP** — key/value + tables, implemented in MTH (`msdp.c`), but a
  telemetry/status channel, not a form layer.
- **MCP 2.1** — already implemented and already used for `@edit`
  (dns-org-mud-moo-simpleedit). Extensible packages make a custom
  menu/form package possible, but native client support is narrow
  (MUSHclient/TinyFugue/MOO; not Mudlet). Good for text editing, weak
  as a cross-client form layer.
- **Web / SSE client** — boris owns both ends and already runs its own
  SSE message protocol, so it is not bound to any legacy MUD protocol.
  A new structured UI message type can carry a menu/form spec as JSON
  and render native HTML widgets. This is the largest and cleanest win,
  and it aligns with the `web-client-ui` card (`#11`, "interaction
  panels", "display type:data packets in a side pane").

MSSP is crawler metadata only; Pueblo is effectively dead. Neither
applies.

## 4. Design decisions

Most decisions below are settled; a few remain PROPOSED and are called
out as such. Settled items are also listed in section 9.

- **DECIDED: Builder role = ACS flag `B` plus a minimum level.** Reuse
  the existing ACS layer rather than invent a role enum. Building
  commands guard on `acs_check(&u->acs, "sNfB")`. Operators/wizards get
  a higher flag (`W`) that implies Builder. Rationale: flags are precise
  and already persisted; no new storage.
- **DECIDED: open edit scope, creator recorded but not enforced.** The
  only gate on building is the `B` flag: any Builder may edit any
  object. Creation stamps `creator` (username) for provenance, and this
  is the one ownership fact recorded; it is never rewritten. `owner` may
  still be stored for display, but no command enforces per-object
  ownership. This keeps v1 simple and social; per-object enforcement can
  be layered on later (and aligns with the eventual sandbox `world:` /
  `area:` write model, `#53`, if we ever want it) without reworking the
  data, since `creator` is already captured.
- **DECIDED: introduce a light Zone record.** A zone is a small OBJ in
  `objs` (key `zones/<id>`) holding: title, creator, id-prefix, and a
  default-template reference for `dig`. Room ids inside a zone are
  namespaced (`<zone>/<room>`). This is the grouping unit for `dig`
  templates and quotas. Kept deliberately minimal; not the ColdFire
  sandbox area model.
- **DECIDED: step-wizard editor per object type, rooms first.** `redit`
  (rooms) first, then `oedit` (items), then `medit` (NPCs). The default
  creation flow is a **step wizard** that walks the object's fields in
  sequence, not a full-object numbered menu. The same field set is
  reachable out of order for editing (via the `List` action below).
  Long free-text fields (`desc.long`) hand off to `@edit` / MCP / web
  editor; short fields prompt inline. This is the "menu-based building"
  surface, rendered per client (text, MXP, or web form).
- **DECIDED: two-namespace wizard input model.** Every wizard/menu on
  the rebuilt UI layer splits input into two non-overlapping key spaces:
  - **Numbers (`1`..`N`)** select among an *enumerated, variable* set
    the current step offers (a template list, exit directions, matching
    rooms). Positional and context-dependent.
  - **Letters and symbols** are *fixed, universal* actions, identical on
    every step and in every editor. Reserved set (extensible):
    `(N)ext`, `(P)revious`, `(Q)uit`, `(?)Help`, `(S)ubmit`, `(U)ndo`,
    `(R)efresh`, `(L)ist`, ...
  Because variable choices are always digits and actions are always
  alpha/symbol, both can share one prompt with no collision, and an
  enumerated choice is never assigned a reserved letter. Input dispatch
  parses a leading digit as a positional choice, otherwise a
  letter/symbol as an action. This is part of the UI layer's input
  contract so all editors share one dispatch and one help.
- **All writes go through one save path.** A `builder_save()` choke
  point performs: `B`-flag check, field validation, exit-target
  existence check, `creator` stamping on new objects, then commit. No
  per-object ownership check (see open edit scope above). Versioning
  (`#14`) and audit logging hook here later.
- **Rework menu.c / form.c into one per-session, data-driven UI
  layer** before building the OLC on top. **DECIDED: full rebuild**,
  not incremental hardening. Rationale: a rebuild avoids the churn of a
  patchwork of reactionary changes and lets us review the UI design as
  a whole before the OLC commits to it. Target shape: a per-session
  UI state owned by the descriptor holding a small navigation stack of
  frames; a typed field model (`{label, type, get/set, validate,
  flags}`) where `type` covers string, int, enum, room-ref, and
  long-text (hand off to `@edit`); a backing-store binding so a form
  can drive either a fixed struct (login/account) or an OBJ property
  set (the OLC case); a single typed context pointer replacing
  `(void*, long, void*)`; one render path and one input path with
  consistent numbering; and explicit open / suspend / commit / cancel /
  free-on-disconnect lifecycle. The existing login menu and newuser
  form must be ported to it so we do not carry two UI systems.
  The field model is **protocol-neutral**, with a per-transport
  renderer chosen by negotiated client capability. Three renderers ship
  in v1: plain TELNET numbered text (universal fallback), MXP clickable
  menus/links (DECIDED: up front, not deferred; MXP is already
  half-wired in MTH), and the web/SSE client via a new structured UI
  message type rendering native HTML forms. GMCP can later carry the
  same spec as a JSON package for Mudlet-class clients. A form such as
  `redit` is declared once; each client gets the best rendering it can
  do. See section 3b.
  Caveat: menu and form drive the live new-user application and login
  flow, so this rework touches a user-facing path in production. It is
  a net win but pays an added test cost. The `make smoke` /
  `make smoke-cas` expect-based login tests are the regression net and
  must be extended to cover the newuser application end to end before
  and after the port.
- **DECIDED: in-game world backup commands.** Builders and operators
  can protect and export the world without shell access. First cut:
  `@checkpoint <label>` (named snapshot before risky work) and a world
  export/dump command that writes the muddb store as JSON records (the
  `muddb-tool import/export` format). Full snapshot / rollback / gc /
  diff follow the existing `doc/snapshot-proposal.md` design. This is a
  distinct concern from the ColdFire `sandbox-snapshot` card (`#56`),
  which is emulator task state, not the world DB. NEW card needed.
- **The near-term OLC is independent of the ColdFire sandbox.** The
  sandbox track (`doc/mud-cf-sandbox-design.md`, `#50`/`#53`/others)
  is a separate, longer-horizon effort for in-world programmable
  objects. Nothing in this plan blocks on it.

## 5. Working method (spec-first, test-backed)

These are process decisions, applied to every feature below.

- **Spec before implementation.** Each significant feature gets a design
  spec in `doc/` reviewed before code is written, in the style of the
  existing `doc/room-schema.md` and `doc/snapshot-proposal.md`. A spec
  states the data model, command/UI surface, failure modes, and test
  plan. Specs to write, one per major workstream: the UI layer
  (`doc/ui-layer-spec.md`), the OLC editors (`doc/olc-spec.md`), the
  zone model (`doc/zone-spec.md`), and world backup commands
  (extend `doc/snapshot-proposal.md` with the in-game command surface).
  A phase does not start coding until its spec is agreed.
- **Tests ship with the code, not after.** Every new module carries unit
  tests wired through its `module.mk` (`EXECUTABLES +=` /
  `TEST_TARGETS +=` / `<name>_TESTCMD`), the pattern the existing suites
  already use. The rebuilt UI layer especially needs coverage, since
  menu.c / form.c have none today. Round-trip and validation paths
  (`builder_save`, zone, snapshot) get tests as acceptance criteria, not
  follow-ups.
- **Better test infrastructure and CI where it is thin.** The current
  `.gitlab-ci.yml` runs build, unit, smoke, and valgrind on the default
  branch and merge requests. Gaps to close as this work lands: run
  `make smoke-cas` (cas backend is untested in CI), register each new
  suite so it runs automatically, add an end-to-end OLC/wizard test
  harness (drive a build session, assert the saved OBJ), and consider an
  ARM cross-build job given the `.env` cross-compile hazard. Invest in
  shared test helpers (a scripted client driver) rather than
  copy-pasting expect scripts.

## 6. Phased delivery

Each phase is shippable and testable on its own. Existing kanban cards
are noted; new cards to cut are marked **NEW**.

### Phase 0 — Foundations (permissions + safety)

Close the gate before opening the door.

- Add privilege enforcement to the command dispatcher or per-handler
  guard, driven by ACS. (`#2`, `#3`)
- Fix `char set` corruption and duplicate `char new` (`#3`, `#2`) so we
  are not shipping a known data-corruption path into a creation
  workflow.
- Room/character load-save round-trip tests (`#12`).
- **NEW**: `builder_save()` / `room_create()` primitive with validation
  (unique id, required fields, exit targets resolve) and `creator`
  stamping. Ships with unit tests as acceptance criteria.
- **NEW**: world backup safety net before builders write at scale.
  In-game `@checkpoint <label>` (named snapshot) and a world export/dump
  command over the `muddb-tool` JSON-record format. Full snapshot /
  rollback / gc / diff are deferred to Phase 5; this phase just
  guarantees a builder's work can be captured and restored. NEW card.
- **CI/test infra**: add `make smoke-cas` to `.gitlab-ci.yml` and wire
  the new suites so they run on every MR (section 5).

### Phase 1 — Command-driven building (bootstrap the world)

The `@`-command layer that the menu editor will later call into. Useful
on its own for power users and for testing.

- **Spec first**: `doc/zone-spec.md` before coding (section 5).
- **NEW**: light Zone record (`zones/<id>`: title, creator, id-prefix,
  default `dig` template) and `<zone>/<room>` id namespacing. This lands
  in Phase 1 because `dig` and quotas build on it. Ships with round-trip
  tests.
- `dig <dir> <id>`: create a room from the current zone's template,
  link the exit both ways, place the new room. (`#6`)
- `return`: send the Builder back to their previous location. (`#6`)
- **NEW**: `@create` (item/NPC from template), `@link` / `@unlink`
  (exits), `@set <prop> <value>` (`B`-flag guarded property edit),
  `@destroy`.
- Wire these to `builder_save()` (flag check + validation + `creator`
  stamping; no per-object ownership enforcement).

### Phase 2 — Interactive UI rearchitecture (critical path for the OLC)

Rebuild menu.c / form.c into the per-session, data-driven, type-safe UI
layer described in section 4. The OLC cannot be built cleanly on the
current modules, so this comes before the editors.

- **Spec first**: `doc/ui-layer-spec.md` (field model, frame stack,
  input contract, renderer interface) before coding (section 5).
- **NEW**: per-session UI state + navigation-stack frames, typed field
  model, backing-store binding (fixed struct or OBJ), typed context
  pointer, unified render/input with consistent numbering, and full
  open/suspend/commit/cancel/free lifecycle.
- **NEW**: protocol-neutral renderer split (section 3b). Ship three
  renderers in v1: plain TELNET text, **MXP** clickable menus/links
  (enable the option that sits disabled in MTH, mth.c:211), and the
  **web/SSE structured UI message type** (native HTML forms). GMCP
  remains a later add. Relates to `#11` (web client UI), `#27` (GMCP),
  and a new MXP-enable card.
- Fold in the existing small fixes: menu duplicate-key check and
  freelist bridge/grow cases (`#29`), form close-out callback
  (form.c:306, part of `#39`).
- **Port the login menu and newuser form** to the new layer.
- **Testing gate**: extend `make smoke` / `make smoke-cas` to exercise
  the newuser application and login flow end to end. These must pass
  unchanged in behavior across the port. This is the added test cost
  the rework incurs.

### Phase 3 — The menu OLC (the Builder-friendly surface)

- **Spec first**: `doc/olc-spec.md` (field sets per object type, wizard
  step flow, validation rules) before coding (section 5).
- **NEW**: `redit` room step wizard on the new UI layer, walking the
  fields (name, glance, short desc, long desc, exits, creator note) with
  the two-namespace key model: universal actions as letters
  (`(N)ext`/`(P)revious`/`(S)ubmit`/`(L)ist`/`(U)ndo`/`(Q)uit`/`(?)`),
  enumerated choices as numbers (exit directions, template picks). Exit
  add/remove is a sub-step. Long text suspends to `@edit` and resumes.
- **NEW**: `oedit` (items) and `medit` (NPCs) on the same pattern once
  `redit` shape is proven.
- Finish `show_room` so builders see their work: entity list, exit
  summary, posed objects (`#34`).

### Phase 4 — Builder experience and guardrails

- **NEW**: `@grant` / `@revoke` builder role (sets/clears the `B` flag,
  wizard-only), so operators promote players in-game instead of editing
  the store.
- **NEW**: per-Builder room/zone quota (creation limit by `creator`
  count). Advisory guardrail, not access control; edit scope stays open.
- Communication commands finished so builders can coordinate:
  say/pose/emote wiring, aliases, directed speech (`#25`).
- Account/login completeness for a multi-user builder community:
  lockout, last-logins, session counters (`#39`).

### Phase 5 — Persistence quality of life (later)

- Full snapshot system beyond the Phase 0 safety net: `snap`,
  `rollback`, `gc`, `diff` in `muddb-tool` and their in-game
  equivalents, per `doc/snapshot-proposal.md` (blob depot, manifests,
  named refs). Automatic periodic snapshots on a timer.
- Object versioning / edit history for templates and rooms (`#14`),
  hooked into the Phase 0 save choke point.
- Import-format decision if builders want to author offline (`#18`).

## 7. Explicitly out of scope (near term)

- The ColdFire in-world programming sandbox and its capability/ABI work
  (`#50`, `#53`, `#54`, and the other `sandbox-*` cards). Separate
  track.
- Combat, RPG stat systems, and machine programs on objects.
- A bespoke web building IDE beyond the OLC form renderer. The web/SSE
  renderer draws the same declared forms as every other client; a
  hand-built graphical map/room editor is out of scope for now.

## 8. Open questions

None blocking. All prior questions are resolved in section 9. New
questions will accrue here as phases are cut into cards.

## 9. Resolved decisions

- **UI rework scope: full rebuild.** menu.c / form.c are rebuilt into
  one unified per-session UI layer (Phase 2), not hardened in place.
  This avoids churn from a patchwork of reactionary changes and lets us
  review the UI design as a whole before the OLC commits to it. Login
  and newuser are ported onto it, guarded by extended smoke tests. See
  sections 4 and Phase 2.
- **Builder role = ACS flag `B`** (plus a minimum level), reusing the
  existing ACS layer; no new role storage. See section 4.
- **Edit scope: open.** The `B` flag is the only gate; any Builder may
  edit any object. Creation records `creator` for provenance, but no
  per-object ownership is enforced. See section 4.
- **Zones: in scope now.** A light zone record lands in Phase 1 as the
  grouping unit for `dig` templates and quotas. See section 4 and
  Phase 1.
- **Transport reach: MXP up front.** Three renderers ship in v1 (plain
  TELNET text, MXP, web/SSE HTML forms); GMCP is a later add. See
  sections 3b and 4 and Phase 2.
- **First OLC target: rooms first**, then items (`oedit`) and NPCs
  (`medit`) once the `redit` shape is proven. See Phase 3.
- **Builders minted via wizard `@grant` / `@revoke`** (sets/clears the
  `B` flag, wizard-only). Not an application queue or config allowlist
  for v1. See Phase 4.
- **OLC style: step wizard**, not a full-object numbered menu. Input
  uses the two-namespace key model: numbers for enumerated variable
  choices, letters/symbols for fixed universal actions
  (`(N)ext`/`(P)revious`/`(Q)uit`/`(?)Help`/`(S)ubmit`/`(U)ndo`/`(R)efresh`/`(L)ist`,
  ...). See section 4.
- **Spec-first, test-backed working method.** Every feature gets a
  reviewed design spec in `doc/` before code, and ships unit/round-trip
  tests as acceptance criteria, not follow-ups. See section 5.
- **Invest in test infrastructure and CI.** Add `make smoke-cas` and the
  new suites to `.gitlab-ci.yml`, build an end-to-end OLC test harness,
  and consider an ARM cross-build job. See section 5.
- **In-game world backup commands.** `@checkpoint <label>` and a world
  export/dump land in Phase 0 as a data-loss safety net; full
  snapshot/rollback/gc/diff (`doc/snapshot-proposal.md`) follow in
  Phase 5. Distinct from the ColdFire `sandbox-snapshot` card (`#56`).
