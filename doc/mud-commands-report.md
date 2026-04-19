# MUD Codebase Command Set Research

Survey of player-facing commands across 6 major MUD codebase families:
DikuMUD, CircleMUD, ROM, LambdaMOO, TinyMUCK, and LPmud.

Goal: identify a near-universal command set for a minimum viable product.

---

## Per-Codebase Command Lists

### DikuMUD (Original)

- **Movement:** north, south, east, west, up, down, enter, leave
- **Communication:** say, tell, whisper, shout, ask
- **Information:** look, examine, score, who, where, inventory, equipment,
  exits, help, time, weather, news, levels, brief, compact, commands, info,
  users
- **Combat:** kill, hit, kick, bash, rescue, flee, backstab, cast, consider
- **Object Interaction:** get/take, drop, put, give, wear, wield, remove, eat,
  drink, sip, taste, open, close, lock, unlock, buy, sell, quaff, recite, use,
  pour, grab, write, read
- **Socials:** smile, kiss, bounce, french (plus many more)
- **Character Management:** save, quit, offer, rent, practice, follow, group,
  rest, sit, stand, sleep, wake, order
- **Utility:** bug, typo, idea

### CircleMUD

- **Movement:** north, south, east, west, up, down, enter, leave, follow
- **Communication:** say/', tell, whisper, shout, holler, gossip, gsay/gtell,
  ask, reply, qsay, emote/:, page, auction
- **Information:** look, examine, score, who, whoami, where, inventory,
  equipment, exits, help, time, weather, news, levels, commands, credits, info,
  diagnose, display, toggle, date, version, uptime, socials, color/colour
- **Combat:** kill, hit, murder, flee, kick, bash, backstab, rescue, cast,
  consider, assist
- **Object Interaction:** get/take, drop, put, give, wear, wield, hold, remove,
  eat, drink, sip, taste, open, close, lock, unlock, buy, sell, list, quaff,
  recite, use, pour, fill, grab, read, write, donate, junk
- **Socials:** 100+ socials including smile, laugh, nod, wave, hug, kiss, bow,
  clap, cry, dance, grin, groan, shrug, sigh, wink, yawn, etc.
- **Character Management:** save, quit, rent, offer, practice, rest, sit,
  stand, sleep, wake, follow, group, split, report, order, brief, compact,
  prompt, title, visible, wimpy, autoexit
- **Utility:** bug, typo, idea, mail

### ROM (Rivers of MUD) 2.4

- **Movement:** north, south, east, west, up, down, enter, go, follow, recall
- **Communication:** say/', tell, shout, yell, gossip/,, gtell/;, reply,
  replay, emote, pmote, answer, question, quote, pose, note, quiet, deaf, afk,
  music, grats
- **Information:** look, examine, score, who, whois, where, inventory,
  equipment, exits, help, time, weather, commands, credits, info, areas,
  wizlist, worth, report, socials, affects, skills, spells, groups, count,
  read, rules, story, motd, autolist
- **Combat:** kill, hit, murder, flee, kick, bash, backstab/bs, rescue, cast,
  consider, disarm, trip, berserk, dirt, envenom, surrender
- **Object Interaction:** get/take, drop, put, give, wear, wield, hold, remove,
  eat, drink, fill, pour, buy, sell, list, value, quaff, recite, brandish, zap,
  sacrifice/junk/tap, compare, heal, open, close, lock, unlock, pick
- **Socials:** loaded from social file; standard Diku-derived set
- **Character Management:** save, quit, rent, practice, train, rest, sit,
  stand, sleep, wake, follow, group, split, visible, wimpy, gain, play, outfit,
  order, sneak, hide, steal
- **Configuration:** alias/unalias, brief, colour/color, combine, compact,
  description, nofollow, noloot, nosummon, password, prompt, scroll, telnetga,
  title, autoassist, autoexit, autogold, autoloot, autosac, autosplit, autoall

### LambdaMOO (LambdaCore)

- **Movement:** go, home, @go, @join
- **Communication:** say/", whisper, page, emote/:, news, @gripe, @typo, @bug,
  @idea, @suggest, @comment
- **Information:** look, inventory, @examine, @contents, @locations, @parents,
  @find, @who, @lastlog, @version, @memory, @uptime, whereis
- **Object Interaction:** get/take, drop/throw, put/insert, give/hand, @move,
  @eject, read, write, erase, delete, encrypt, decrypt, burn
- **Socials:** emote (freeform), plus MOO-specific verbs on objects
- **Character Management:** @quit, @describe, @gender, @password, @sethome,
  @rename, @wrap, @linelength, @more, @pagelength
- **Building:** @dig, @create, @recycle, @recreate, @quota, @count, @audit,
  @add-exit, @remove-exit, @exits, @entrances, @lock, @unlock, @edit, @notedit
- **Mail:** @send, @answer, @mail, @read, @next, @prev, @forward, @rmmail,
  @unrmmail, @renumber, @mail-option, @rn, @subscribe, @skip, @unsubscribe
- **Privacy:** @gag, @ungag, @listgag, @paranoid, @check, @sweep

### TinyMUCK / TinyMUD / TinyMUSH

- **Movement:** go/move, home, leave (plus exits defined as actions)
- **Communication:** say, whisper, page, pose (emote equivalent), gripe,
  outputprefix, outputsuffix, @wall
- **Information:** look, examine, inventory, score, who, man, help, news,
  information, read
- **Object Interaction:** get/take, drop, put, give, throw, rob, kill
- **Character Management:** quit, @password, @newpassword
- **Building:** @action, @attach, @create, @describe, @dig, @drop, @fail,
  @find, @force, @link, @list, @lock, @name, @odrop, @ofail, @open,
  @osuccess, @owned, @pcreate, @program/prog, @recycle, @set, @success,
  @teleport, @toad, @trace, @unlink, @unlock, @stats, @chown, @boot, @edit,
  @shutdown, @dump

Note: TinyMUCK/MUSH systems have fewer built-in commands because
functionality is added through in-database programming (MUF/MPI in MUCK,
softcode in MUSH). There is no built-in combat, equipment, or spell system.

### LPmud (MudOS/FluffOS/DGD)

Commands are defined entirely by the mudlib, not the driver. Using Discworld
MUD as a representative example:

- **Movement:** north, south, east, west, up, down, northeast, northwest,
  southeast, southwest, enter, leave, go, follow, unfollow, crawl, crouch
- **Communication:** say, sayto, tell, whisper, shout, emote, remote, converse
- **Information:** look, glance, examine, score, who, whois, qwho, inventory,
  help, time, weather, commands, users, map, consider, appraise, identify,
  locate, condition, burden, money, finger, idle, age, achievements, languages
- **Combat:** kill, stop, surrender, pursue, defend, tactics, wimpy (plus
  learned combat commands: bash, kick, stab, slash, etc.)
- **Object Interaction:** get/take, drop, put, give, wear, remove, hold,
  unhold, eat, drink, read, draw, sheathe, throw, keep, unkeep, offer, accept,
  reject
- **Socials:** hundreds of "soul" commands: nod, smile, hug, slap, dance, etc.
- **Character Management:** save, quit, password, brief, verbose, alias,
  unalias, options, prompt, title, describe, colours/colors, afk
- **Utility:** bug, typo, idea, mail, friends, ignore, monitor, history, queue,
  stop, term, rows

---

## Cross-Codebase Comparison

Commands present in all 6 codebases:

| Command    | Purpose                    |
|------------|----------------------------|
| look       | View room/object/player    |
| examine    | Detailed inspection        |
| say        | Speak to the room          |
| whisper    | Private message in-room    |
| get/take   | Pick up items              |
| drop       | Drop items                 |
| put        | Place item in container    |
| give       | Give item to someone       |
| inventory  | List carried items         |
| who        | List connected players     |
| help       | In-game help               |
| quit       | Exit the game              |
| kill       | Initiate combat            |
| go         | Move through an exit       |
| read       | Read text on an object     |

Commands present in 4-5 of 6 codebases:

| Command    | Count | Notes                              |
|------------|-------|------------------------------------|
| n/s/e/w/u/d| 4     | Direction shortcuts (Diku + LP)    |
| exits      | 4     | List available exits               |
| tell       | 4     | Private message to any player      |
| emote      | 5     | Freeform action (pose in MUCK)     |
| shout/yell | 4     | Broadcast to wider area            |
| score      | 5     | Character stats                    |
| wear       | 4     | Equip armor                        |
| remove     | 4     | Unequip                            |
| eat/drink  | 4     | Consume food/drinks                |
| open/close | 4     | Doors and containers               |
| lock/unlock| 5     | Lock mechanisms                    |
| follow     | 4     | Follow another player              |
| save       | 4     | Persist character                  |
| time       | 4     | In-game time                       |
| weather    | 4     | Current weather                    |
| consider   | 3     | Evaluate difficulty                |
| flee       | 3     | Escape combat                      |

---

## Recommended MVP Command Set (~69 commands)

### Movement (10)

north, south, east, west, up, down, go, enter, leave, exits

### Communication (7)

say, tell, whisper, shout, emote, reply, gtell

### Information (12)

look, examine, inventory, equipment, score, who, where, exits, help, commands,
consider, affects

### Combat (5)

kill, flee, cast, rescue, wimpy

### Object Interaction (18)

get, drop, put, give, wear, remove, wield, hold, eat, drink, open, close,
lock, unlock, buy, sell, list, read

### Socials (10 minimum)

smile, laugh, nod, wave, shrug, sigh, bow, clap, cry, wink

### Character Management (8)

save, quit, password, follow, group, rest, sleep/wake, stand/sit

### Utility (4)

bug, typo, idea, brief

---

## Key Observations

- The Diku family (Diku/Circle/ROM) shares the most commands -- nearly
  identical core sets. Implementing one basically covers all three.

- TinyMUCK/MUSH and LambdaMOO have far fewer built-in commands because they
  rely on in-database programming for extensibility. No built-in combat,
  equipment, or spells.

- LPmud commands are defined entirely by the mudlib, not the driver, so they
  vary wildly between implementations. Discworld's command set closely
  resembles the Diku family.

- The Diku family's command vocabulary has become the de facto standard that
  players expect. The MVP list above is essentially "Diku core" minus the
  rarely-used commands.
