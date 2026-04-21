# Boris RPG System — Design

Distilled from *Wizards & Lizards* (W&L), a tabletop RPG, and adapted for a
multi-user server where the software must adjudicate every roll.

This document is the authoritative reference for developers, admins, and
builders. A player-facing introduction will be derived from it later.

## 1. Scope & translation principles

W&L is a fiction-first, GM-mediated game. A MUD has no human GM at the table:
the server must resolve every roll deterministically from state it already
knows. We keep what the server can evaluate and drop what only a human can.

Kept and ported directly:

- Four attributes, sixteen actions, rank 0-4 (+ heroic 5-6).
- d6 pool, 3+ = hit for skill rolls, 4+ = hit for combat.
- Traitor dice at rank < 1.
- Exploding pairs of 6s.
- Stress (9-box track), harm (2/2/1 across three levels).
- Resistance rolls (attribute score dice, cost = 6 - highest).
- Push yourself, assist, protect, group action.
- Position (controlled / risky / desperate) and difficulty (1-5).
- Adjective ladder (-3 Terrible .. +3 Superb) as a shared vocabulary.
- Scene tags (discussed in detail; treated as a first-class MUD mechanic).
- Fortune rolls (1d6 vs TN) for morale, reaction, discipline, and generic
  chance.
- Clocks (progress, danger, opposed) for timed activities.
- Playbooks (Fighter, Priest, Mage, Thief) and ancestries as character
  archetypes.

Kept with MUD-specific adaptation:

- **Position** is computed by the server from character state + room state +
  opponent state rather than narrated by a GM.
- **Difficulty** is attached to the target (lock, mob, terrain) by the
  builder.
- **Scene tags** are first-class data on rooms, mobs, items, and characters.
  Tags drive position/difficulty modifiers mechanically.
- **GM actions** (apply harm, worsen position, introduce complication, etc.)
  become server reactions selected from a table when a roll produces a
  consequence.

Deferred or out of scope for the MUD core:

- Lifepath character creation as played at the table. Lifepath *results* can
  still drive starting ranks/items; the flow is replaced with menu-driven
  character creation.
- Freeform fiction-first adjudication of novel actions. The MUD exposes a
  fixed verb set. Tags, position, and difficulty are how the world nudges
  outcomes without requiring freeform input.
- Downtime, retirement at 4 conditions, and long-term campaign structure.
  These are a later addition.

Vocabulary note: W&L uses "action" for its sixteen skills. The word "action"
is also loaded in a MUD context (a command entered by the player). This doc
uses **action** for the skill (Fight, Study, etc.) and **command** for what a
player types. When ambiguity matters, we say "skill action" or "player
command."

## 2. Attributes and actions

Every character has four attributes; each attribute contains four actions,
one per role: **Force**, **Explore**, **Protect**, **Change**.

| Attribute | Force   | Explore | Protect | Change |
|-----------|---------|---------|---------|--------|
| Body      | Fight   | Move    | Endure  | Brawn  |
| Finesse   | Shoot   | Prowl   | Nimble  | Tinker |
| Mind      | Hunt    | Study   | Survey  | Attune |
| Presence  | Command | Consort | Judge   | Sway   |

Action summaries (keep the W&L vocabulary verbatim — same words mean the
same thing in the MUD as at the table):

- **Fight** — close combat, melee, grappling, shield work.
- **Move** — athletics, climb, swim, run, jump, dodge.
- **Endure** — toughness, stamina, resist pain/poison/exhaustion.
- **Brawn** — raw force: lift, break, bend, haul.
- **Shoot** — ranged combat: bows, crossbows, thrown.
- **Prowl** — stealth, sneak, tail, hide.
- **Nimble** — sleight of hand, pickpocket, palm, fine dexterity.
- **Tinker** — craft, repair, disable, build; locks, traps, mechanisms.
- **Hunt** — track, search, navigate, pursue.
- **Study** — research, recall lore, analyze, read, identify.
- **Survey** — perception, spot danger, notice what is out of place.
- **Attune** — sense the supernatural; magic, spirits, wards.
- **Command** — lead, intimidate, rally, compel.
- **Consort** — socialize, blend in, gather rumors, carouse.
- **Judge** — read people, sense motives, detect lies.
- **Sway** — persuade, deceive, negotiate, seduce.

### 2.1 Ranks

Each action has a rank 0-4 (plus heroic 5-6 granted by advancement in one or
two chosen actions per character).

| Rank | Meaning   | Notes                                             |
|------|-----------|---------------------------------------------------|
| 0    | Untrained | Traitor dice: roll 2, both must show 3+ (max 1).  |
| 1    | Novice    | Basic competence. 67% to hit at D1.               |
| 2    | Competent | Reliable professional. 89% to get at least 1 hit. |
| 3    | Expert    | Among the best in a community.                    |
| 4    | Master    | Peak of mundane ability.                          |
| 5    | Heroic    | Beyond mortal limits; advancement only.           |
| 6    | Legendary | Demigods.                                         |

Starting characters are capped at rank 2 in any action.

### 2.2 Attribute scores (derived)

An attribute's **score** is the sum of its four action ranks. Scores are
never assigned directly; they update whenever a component rank changes.
Uses:

- **Resistance rolls** use the attribute score as the dice pool.
- **Inventory slots** equal `5 + Body score`.
- **NPC statblocks** may use attribute scores directly in place of action
  rolls for simple encounters.

## 3. The action roll

Every risky skill check follows the same procedure. The server owns every
step after the player's command is parsed.

1. **Resolve the action.** The command maps to an action (look → Survey,
   pick lock → Tinker, sneak → Prowl, attack → Fight/Shoot, etc.).
2. **Determine position.** From character + room + target state. Default is
   **risky**.
3. **Determine difficulty.** From target state (lock difficulty, mob
   defense, terrain). Default is **1 (Standard)**.
4. **Build the dice pool.** Start with the action rank. Apply tag modifiers,
   harm penalties, assist dice, push-yourself dice, ability bonuses.
5. **Roll d6s.** Count dice showing **3+** as hits (4+ in combat).
6. **Apply exploding dice.** For each pair of unmatched 6s in the final
   pool, roll one bonus die at the same threshold; new 6s can pair with
   leftovers to chain.
7. **Compare hits to difficulty.**

| Hits vs difficulty | Outcome                                                        |
|--------------------|----------------------------------------------------------------|
| hits > difficulty  | Full success. Excess hits intensify the result.                |
| hits = difficulty  | Partial success. Goal met, but a consequence fires.            |
| hits < difficulty  | Bad outcome. Goal missed or achieved at a heavy cost.          |

### 3.1 Traitor dice

If effective rank drops below 1 (rank 0, or rank 1 with a -1D penalty),
roll `2 - rank` dice. **All** must show 3+ for a single hit; any 1 or 2
ruins the roll. Max 1 hit.

- Rank  0: 2 dice, need both → 44%.
- Rank -1: 3 dice, need all → 30%.
- Rank -2: 4 dice, need all → 20%.

### 3.2 Exploding dice

After counting hits, pair unmatched 6s. Each pair spawns one bonus die
rolled at the same threshold. Bonus 6s can pair with any remaining
unpaired 6s (original or bonus) to chain further. Stops when no new
pairs form.

### 3.3 Excess hits

Hits beyond the difficulty. Outside combat they intensify the narrated
result and, if a progress clock is attached, tick one extra segment
each. In combat they become **momentum** (see combat doc, later).

### 3.4 When not to roll

The server should not call for a roll when:

- The outcome is certain (rank > difficulty + 3 with no penalty and
  default position — just succeed).
- The outcome is impossible (e.g., picking a lock with no tools, an
  action forbidden by the current state).

Routine commands (walking into an adjacent safe room, looking at an
object in a lit room) resolve without a roll.

## 4. Position and difficulty

Position says how bad a bad outcome gets. Difficulty says how many hits
full success requires. The server chooses both from state.

### 4.1 Position

| Position   | Bad-outcome severity                                                |
|------------|---------------------------------------------------------------------|
| Controlled | Minor: lose opportunity, minor complication, rarely harm.           |
| Risky      | Meaningful: harm, complication, lost ground. **Default.**           |
| Desperate  | Severe: serious harm, capture, death, catastrophic failure.         |

Position is computed from: relevant room tags, opponent tags, character
status (harm, stress, stealth, restraint), and the action being
attempted. Tag sum shifts position up or down from risky by one tier per
full ±1 of tag sum (see §5). Position clamps to [controlled, desperate].

### 4.2 Difficulty

| Difficulty | Name        | Benchmark                                                     |
|------------|-------------|---------------------------------------------------------------|
| 1          | Standard    | Default. Novice has a chance; competent is reliable.          |
| 2          | Challenging | Rank 2 struggles; rank 3 finds it a real test.                |
| 3          | Hard        | Rank 3-4 territory; needs luck or help.                       |
| 4          | Extreme     | Near mortal limits; needs large pools.                        |
| 5          | Heroic      | Virtually impossible without extraordinary talent.            |

Difficulty is a property of the target — a lock, a trap, a mob's
defense, a terrain feature — set by builders. Some tags raise or lower
it instead of position (see §5.1).

### 4.3 Trade

A player may trade position for difficulty or vice versa where it makes
sense. Mechanically this is a command option, e.g. `pick lock careful`
(controlled, +1 difficulty) vs. `pick lock fast` (risky/desperate, -1
difficulty, min 1).

## 5. Scene tags

Tags are the bridge between fiction and mechanics and the primary
extension point for builders. Every tag has:

- a **name** (short string, e.g. `poor_footing`, `good_vantage`),
- a **value** on the adjective ladder (-3..+3),
- a **relevance predicate** — which actions or circumstances it affects,
- a **mode**: `position` (default) or `difficulty`.

The adjective ladder:

| Value | Keyword  | Meaning                            |
|-------|----------|------------------------------------|
| -3    | Terrible | Worst realistic case.              |
| -2    | Poor     | Well below average.                |
| -1    | Mediocre | Below average.                     |
|  0    | Fair     | Baseline. No tag needed.           |
| +1    | Good     | Meaningful advantage.              |
| +2    | Great    | Well above average.                |
| +3    | Superb   | Best realistic case.               |

### 5.1 How tags apply

When the player initiates an action, the server collects all tags that
pass the relevance predicate for that action, sums their values, and
applies the result.

- Tags with **mode = position** shift position one tier per ±1 of sum.
  Risky is baseline; clamp to controlled / desperate.
- Tags with **mode = difficulty** shift difficulty by their value,
  clamped to [1, 5]. Positive tags *lower* difficulty (helpful tool),
  negative tags *raise* it (shoddy gear).

Default mode is `position` — most tags describe how safe or dangerous
the situation is. Use `difficulty` for tags that describe the quality
of a tool, weapon, or resource (a *superb* lockpick, a *terrible* rusty
knife).

### 5.2 Tag sources

Tags attach to entities the builder/world controls:

- **Room tags** — `dark`, `slippery`, `cramped`, `high_ground`,
  `sanctified`. Fixed by the builder; may be toggled by events (e.g.
  lighting a torch clears `dark`).
- **Object tags** — equipment quality and traits: `sharp`,
  `well-balanced`, `rusted`, `masterwork`, `enchanted_flame`.
- **Mob tags** — `armored`, `wounded`, `prone`, `surprised`,
  `fanatical`.
- **Character state tags** — `hidden`, `prone`, `restrained`, `on_fire`,
  `inspired`.
- **Weather / time tags** — attached to the zone or room: `foggy`,
  `storm`, `night`.

Tags are mutable. Clearing the loose scree removes `poor_footing`.
Sneaking up successfully grants the actor `hidden` until they break
stealth.

### 5.3 Fiction-over-numbers

A tag applies *only* if its predicate says it makes sense for the
action. `good_vantage` helps Shoot and Survey; it does not help Tinker
on a lock at your feet. Predicates are author-supplied; the core
engine provides a small standard library (by-attribute, by-action,
by-opposition, by-command-keyword).

### 5.4 Why this matters for MUDs

Tags give builders a coherent, typed language for world flavor that
actually *does* something. A "slippery stone floor" in a room
description is only atmosphere; a `slippery(-1, mode=position,
affects=Move+Fight)` tag makes the room mechanically distinct. This is
the primary aesthetic link between the MUD and W&L.

## 6. Stress and harm

### 6.1 Stress

- Track: 9 boxes, starts at 0.
- Spend to:
  - **Push yourself** — 2 stress for +1D, *or* 2 stress to reduce
    difficulty by 1 (min 1). Declared before or after roll.
  - **Resist a consequence** — see §7.
  - **Assist an ally** — 1 stress for +1D on the ally's roll.
  - **Fuel special abilities** — per ability.
- **Overwhelmed.** When the track fills, gain a **condition** (a
  persistent psychological mark) and reset stress to 0. Four conditions
  retire the character. (Retirement may be softened for MUD play; TBD.)

### 6.2 Harm

Three levels; a box filled means "I am currently carrying this level of
injury."

| Level | Label    | Boxes | Mechanical effect                                 |
|-------|----------|-------|---------------------------------------------------|
| 1     | Minor    | 2     | None.                                             |
| 2     | Moderate | 2     | -1D on actions the injury would plausibly impair. |
| 3     | Severe   | 1     | Need treatment soon or die.                       |

If a level is full when new harm of that level arrives, the harm
escalates to the next level. Level 3 full + new severe harm → dying.

Harm heals during downtime. (Specifics — resting, healing kits, priest
abilities — deferred to the combat/downtime doc.)

## 7. Resistance rolls

When the server is about to inflict a consequence on a character, the
player may resist:

1. Pick the attribute that best matches the threat (Body / Finesse /
   Mind / Presence).
2. Roll d6s equal to that **attribute score**.
3. Stress cost = `6 - highest die`.
4. If two or more 6s show, *clear* 1 stress instead.

Resistance never fully cancels a consequence; it reduces severity. A
Level 2 harm becomes Level 1, "you drop your sword" becomes "your grip
slips but you hold on." The server picks a reduced form from the same
consequence family.

## 8. Teamwork

### 8.1 Assist

Another PC spends 1 stress to add +1D to an acting character's roll. The
assister must be fictionally positioned to help (in the same room, or
able to observe and communicate, depending on action). Multiple
assistants stack.

### 8.2 Protect

A PC absorbs a consequence aimed at another character. They now face
the consequence and may resist it. No stress to declare, but the
resulting harm/stress is theirs.

### 8.3 Group action

One leader; every participant rolls. The **best** result is the
group's result. Every participant who rolled a bad outcome inflicts
1 stress on the leader.

## 9. Fortune rolls

For outcomes driven by chance rather than character skill. Roll 1d6
against a target number from the **likelihood scale**:

| Likelihood | TN  | Probability |
|------------|-----|-------------|
| Certain    | 1+  | automatic   |
| Likely     | 2+  | 5/6         |
| Probable   | 3+  | 4/6         |
| Even odds  | 4+  | 3/6         |
| Unlikely   | 5+  | 2/6         |
| Remote     | 6+  | 1/6         |
| Impossible | 7+  | never       |

Modifiers ±1 (rarely ±2) shift the TN, not the die.

Standard MUD applications:

- **Morale** — when an NPC faction takes a hit (leader down, first
  casualty, half strength). Fail → break, flee, surrender.
- **Reaction** — when a PC meets an NPC with no predetermined
  disposition. Degrees: Friendly / Favorable / Neutral / Unfavorable /
  Hostile.
- **Discipline** — does an NPC group act tactically or blunder this
  round.
- **Weather, random encounters, loot extras.**

## 10. Clocks

A clock is a finite counter of segments that ticks toward resolution.

- **Progress clocks** — ticked by successful rolls on a complex task
  (navigate a forest, decipher a ward, repair a ship). Partial success
  = +1, full success = +1 +(excess hits).
- **Danger clocks** — ticked by the server as time passes, noise is
  made, or complications fire. Fill = the threat arrives
  (reinforcements, ritual completes, bridge collapses).
- **Opposed clocks** — a progress/danger pair racing each other.

Segment sizes: 4 (short / simple), 6 (moderate), 8 (major). Larger
clocks (10-16) exist for epic undertakings.

Clocks are the MUD's main tool for *duration* — any activity that
cannot be resolved in a single command tick is a clock.

## 11. Server-side GM actions

When a roll produces a consequence (partial success or bad outcome),
the server picks one or more responses appropriate to the position
(controlled → nuisance, risky → real problem, desperate → potentially
catastrophic). The vocabulary:

- **Apply harm** (scaled to position and source).
- **Worsen position** on the next related roll.
- **Use up a resource** (arrows, torch, potion, spell slot).
- **Offer a hard choice** (player must pick between two bad options).
- **Introduce a complication** (new mob arrives, alarm raised, floor
  gives way).
- **Tick a clock** (danger clock advances).
- **Demand a response** (forces a reactive roll: Endure, Move, etc.).
- **Turn their action against them** (their own attempt made things
  worse).
- **Separate them** (split party, cut escape).
- **Reveal an unwelcome truth** (new knowledge that changes plans).
- **Threaten an absence** (something valued is at risk if they delay).

Builders attach consequence tables to mobs, traps, hazards, and
encounters. The engine exposes the vocabulary as primitives; specific
outcomes are authored content.

## 12. Playbooks

Four archetypes. Each defines starting rank distribution, allowed
special abilities, and flavor. Full ability lists deferred.

- **Fighter** — warriors, soldiers, knights, rangers. Steel and
  tactics.
- **Priest** — clerics, druids, shamans, paladins. Faith and ritual.
- **Mage** — wizards, seers, arcane scholars. Study and formulae.
- **Thief** — rogues, scouts, assassins, bards. Cunning and escape.

### 12.1 Starting budget

- 2 free ranks (player assigns, cap rank 2 per action).
- 5 lifepath ranks (from playbook tables; rolled result may exceed cap
  2, chosen result may not).
- +1 ancestry rank (humans) OR equivalent traits/bonuses/drawbacks
  (non-humans).
- 1 starting special ability from playbook list.
- Starting gear from playbook + lifepath.
- Stress 0 / 9, harm empty.

MUD character creation replaces tabletop lifepath *play* with a menu
that presents each table's options; results are the same but without
the dice ritual. A "surprise me" option may roll for the player.

## 13. Ancestries

Ancestry is chosen at creation and sets innate traits, situational
bonuses, and drawbacks. W&L defines five core (Human, Dwarf, Elf,
Halfling, Half-Orc), three extended (Reptilian, Winged Folk, Darkspawn),
and seven uncommon (Kobold, Goblin, Fae-Touched, Half-Giant, Beast
Folk, Sea Elf, Ironforged).

Boris ships the five core ancestries in the base data set. Extended
and uncommon ancestries are opt-in per zone/campaign via configuration.

Mechanical pieces the engine must support:

- Flat bonus ranks (humans, dwarves, half-orcs, half-giants).
- Situational +1D or -1D on specific actions given tag predicates
  (elves on Notice-for-hidden, halflings on Move-to-sneak, beast folk
  on Hunt-by-scent, etc.). These are tags on the character.
- **Traits** — capabilities: darkvision, flight, waterbreathing,
  natural armor, lucky (once-per-session reroll), enchantment
  resistance, etc. Each is a flag with engine-specific behavior.
- **Drawbacks** — always-on constraints: small size (weapon/armor
  restrictions, reduced slots), distrusted (social -1D with
  strangers), cold-blooded, iron vulnerability, dehydration, etc.
- Extra harm boxes at a level (half-orcs: +1 Level-1 box).
- Ancestry-specific sub-tables (Darkspawn Gifts 1d6).

Per-session abilities (halfling Lucky, darkspawn Hellfire) need a
"session" concept in the MUD. Provisional mapping: a **session** is
one login up to a disconnect/idle threshold, or one in-game day,
whichever is shorter. Final choice deferred.

## 14. Design invariants

These are the properties we commit to preserving across implementation.

1. **Same vocabulary as W&L.** Action names, attribute names, position
   labels, the adjective ladder, the likelihood scale, "stress",
   "harm", "hits", "clocks" — all carried over verbatim. A W&L player
   should feel at home; a boris player should recognize the tabletop
   edition.
2. **3+ hits, pairs-of-6 explode, traitor dice below 1.** The dice
   math is the identity of the system. Do not drift.
3. **Risky + difficulty 1 is the default.** Builders and the engine
   only deviate when the fiction (tags, state) says so.
4. **Tags are first-class.** Builders express flavor through tags,
   not through custom code per room.
5. **Consequences are reduced, not canceled.** Resistance trades
   stress for a reduction; failure always costs something.
6. **Starting characters cap at rank 2.** Rank 3+ is earned.

## 15. Open questions

Resolve before or during implementation planning.

- **Session boundary** for once-per-session abilities.
- **Condition and retirement** — soften for MUD campaign length, or
  keep as-is?
- **Downtime and harm healing cadence** — real-time minutes, in-game
  days, or action-triggered?
- **Combat threshold (4+)** vs skill threshold (3+) — confirm boris
  combat adopts the 4+ variant, and document in the combat doc.
- **Momentum** from excess combat hits — spec lives in the combat
  doc; reference here for completeness.
- **Advancement** — XP source (quest completion? action use?) and
  cost curve; heroic rank unlocks.
- **Player command → action mapping** — the canonical table from
  verbs to actions (attack → Fight or Shoot based on wielded weapon,
  climb → Move, listen → Survey, etc.). Builders should be able to
  override per object/room.

## 16. Not in this document

- Combat turn structure, attack/defense values, momentum — separate
  combat doc.
- Downtime, long-term advancement, campaign structure.
- Full playbook lifepath tables and ability lists.
- Full ancestry mechanical implementations.
- Magic system (spell lists, rituals, Priest/Mage subsystems).
- Economy, encumbrance detail, item quality tables.

Each becomes its own design note once this core is agreed.

## Appendix A: Reference notes from 6mud (HERO-system sketch)

Preserved from the author's earlier MUD project (`6mud/combat.txt`) as
research material. This is **not** the boris system — boris is W&L-based
(see sections above). These notes are kept here so a future session can
mine them when fleshing out combat, derived stats, and campaign-tier
budgets. Full integration deferred.

### A.1 Characteristics / ability scores

| Code | Name          | Description                                            |
|------|---------------|--------------------------------------------------------|
| INT  | Intelligence  | General mental ability and awareness.                  |
| WILL | Willpower     | Ability to overcome stressful situations.              |
| PRE  | Presence      | Influence through character and charisma.              |
| TECH | Technique     | Manual dexterity manipulating things with hands.       |
| REF  | Reflexes      | Respond, aim, and hit things in combat.                |
| DEX  | Dexterity     | Bodily agility; move in combat and avoid being hit.    |
| CON  | Constitution  | Overall healthiness and immunity.                      |
| STR  | Strength      | Ability at applying physical force.                    |
| BODY | Body          | Ability to resist physical harm.                       |
| MOVE | Movement      | Speed of chosen locomotion.                            |

### A.2 Derived characteristics

| Code | Name             | Formula                                                |
|------|------------------|--------------------------------------------------------|
| STUN | Stun             | BODY * 5                                               |
| HP   | Hits             | BODY * 5                                               |
| SD   | Stun Defense     | CON * 2                                                |
| REC  | Recovery         | STR + CON                                              |
| RUN  | Combat Movement  | MOVE * 2 m                                             |
|      | Non-combat       | Sprint MOVE\*3m; Swim MOVE\*1m; Leap MOVE\*1m.         |
| RES  | Resistance       | WILL * 3 (mental hits)                                 |
| LUCK | Luck (optional)  | INT + REF                                              |
| END  | Endurance        | CON * 10                                               |
| ED   | Energy Defense   | CON * 2                                                |
| SPD  | Speed            | REF / 2                                                |
| HUM  | Humanity         | WILL * 10                                              |

### A.3 Characteristic point rating

| Score | Tier                 |
|-------|----------------------|
| < 1   | Child-like           |
| 1-2   | Ordinary             |
| 3-4   | Competent / bright   |
| 5-6   | Heroic               |
| 7-8   | Incredible / Olympic |
| 9-10  | Legendary            |
| 10+   | Superhero / godlike  |

### A.4 Campaign-style point budgets

| Campaign style         | Characteristic points | Option points |
|------------------------|-----------------------|---------------|
| Everyday / Realistic   | 20                    | 25            |
| Elite / Semi-realistic | 30                    | 35            |
| Heroic                 | 50                    | 45            |
| Incredible             | 60                    | 55            |
| Legendary              | 80                    | 65            |
| Superheroic            | 90+                   | 75+           |

### A.5 How this relates to boris

- W&L's four attributes (Body / Finesse / Mind / Presence) and sixteen
  actions replace the ten HERO characteristics. Don't graft both sets
  on; pick one vocabulary and stick with it.
- The derived-stat pattern (STUN/HP/SD as multiples of a base
  characteristic) is worth stealing conceptually. Boris currently
  derives attribute scores from action ranks (§2.2); a similar pattern
  could define HP, defenses, and endurance from Body/Finesse without
  adding player-facing stats.
- The campaign-tier point budgets are a possible knob for zone or
  server difficulty scaling — a "Heroic" zone might allow higher rank
  caps or larger starting pools than an "Everyday" one.

