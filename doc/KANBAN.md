# Kanban Board

Work items live in `kanban/` as one Markdown file per card. There is no
database and no external tool. The board is the set of files in that
directory, versioned with the rest of the repository.

## Card format

Each card is a Markdown file with a YAML frontmatter block followed by the
card body:

```markdown
---
title: GMCP Protocol
status: backlog
gitlab-sync: OrangeTide/boris#27
---

Generic MUD Communication Protocol. Structured data channel between
server and client for out-of-band game state.

- [ ] implement GMCP telnet option negotiation
- [ ] define initial message packages (Char, Room, etc.)
```

### Frontmatter fields

- `title` -- human-readable card name.
- `status` -- one of `backlog`, `active`, or `done`.
- `gitlab-sync` -- links the card to a GitLab work item (see below).

### Body

The body is free-form Markdown. The convention is a short paragraph
describing the work, followed by a task checklist. Check the boxes as you
complete each task.

## Status values

| Status    | Meaning                                            |
|-----------|----------------------------------------------------|
| `backlog` | Not yet started. Queued for future work.           |
| `active`  | Currently being worked on.                         |
| `done`    | Complete. All task boxes should be checked.        |

The file name (without the `.md` extension) is the card's slug, for example
`kanban/gmcp.md` has the slug `gmcp`.

## Working the board

List cards by status with `grep`:

```sh
# list backlog cards
grep -l 'status: backlog' kanban/*.md | sed 's|kanban/||;s|\.md||'

# list active cards
grep -l 'status: active' kanban/*.md | sed 's|kanban/||;s|\.md||'
```

Lifecycle of a card:

1. Create a new file in `kanban/` with `status: backlog` and a task list.
   Leave `gitlab-sync:` empty to have CI create a matching GitLab issue.
2. When you start the work, set `status: active`.
3. As tasks complete, check their boxes.
4. When finished, set `status: done` and check all remaining boxes. The
   commit that completes the work should also flip the card status in the
   same change.

Keep cards focused on a single concern. Split unrelated fixes into separate
cards rather than growing one card into a catch-all.

## GitLab sync

Each card carries a `gitlab-sync` field that links it to a GitLab work item.
Sync is **one-way and status-only**: card status drives the GitLab issue
state. Card contents are never synced in either direction.

| `gitlab-sync` value       | Behavior                                          |
|---------------------------|---------------------------------------------------|
| `OrangeTide/boris#123`    | Linked to an existing issue. Status is synced.    |
| *(empty)*                 | CI creates a new issue and writes the ref back.   |
| `none`                    | Explicitly opted out. Never synced.               |

Status mapping when a card changes:

- `done` -> CI closes the GitLab issue.
- `active` or `backlog` -> CI reopens the GitLab issue.

The sync runs through `scripts/kanban-sync.sh` in the `sync:kanban` CI job.
It triggers only on pushes to the default branch that modify `kanban/*.md`.
New issues that CI creates are committed back with `[skip ci]` in the commit
message so the write-back does not re-trigger the pipeline.

The script requires `GITLAB_TOKEN` (the CI job token works) and
`CI_PROJECT_ID`, both provided by the CI environment.
