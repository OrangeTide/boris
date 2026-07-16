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
Sync is **one-way**: the card drives the GitLab issue. For a linked card, CI
syncs both its status and its title. CI does not sync the card body after it
creates the issue.

| `gitlab-sync` value       | Behavior                                                    |
|---------------------------|-------------------------------------------------------------|
| `OrangeTide/boris#123`    | Links to an existing issue. CI syncs status and title.      |
| *(empty)*                 | CI links to an existing issue by title, else creates one.   |
| `none`                    | Explicitly opted out. CI never touches it.                  |

Status mapping when a card changes:

- `done` -> CI closes the GitLab issue.
- `active` or `backlog` -> CI reopens the GitLab issue.

### The issue id is the stable key

CI addresses a linked card by its issue id, never by its title. This is what
makes a card **safe to rename**: rename a card that already has a
`gitlab-sync` ref and CI retitles that same issue. Do not rename a card that
has no ref yet: with no id to key on, CI matches by title, misses the old
issue, and creates a duplicate. Link the card first (let CI populate the ref),
then rename.

### Creating and re-linking

For a card with an empty `gitlab-sync` field, CI searches existing issues,
both open and closed, for an exact title match. On a match it links the card
to that issue and picks the lowest number; otherwise it creates a new issue.
This title lookup keeps the sync idempotent. A card whose ref was lost, for
example when a force-push rewound the write-back commit, re-links to its
existing issue instead of spawning a duplicate.

When CI creates or links an issue, it writes the ref back into the card and
commits with `[skip ci]` so the write-back does not re-trigger the pipeline.

### Write-back to a protected branch

CI pushes the write-back commit to the default branch. If that branch is
protected and the `sync:kanban` job cannot push to it, GitLab rejects the
push. The job logs a warning and still succeeds; it does not fail the
pipeline. The refs do not persist that run, but nothing duplicates: the title
lookup re-links the issues on the next run. To persist refs automatically,
allow the job's identity to push to the protected branch.

### Job details

The sync runs through `scripts/kanban-sync.sh` in the `sync:kanban` CI job. It
triggers only on pushes to the default branch that modify `kanban/*.md` or the
script itself. The script requires `GITLAB_TOKEN` (the CI job token works) and
`CI_PROJECT_ID`, both provided by the CI environment.
