# History pruning and sparse references

How smolvfs bounds depot growth for a mutation-heavy ref, and the
reference contract that makes it safe. This documents behavior that
exists in code, in `cas-tree.c`.

Made by a machine. PUBLIC DOMAIN (CC0-1.0)

## The problem

Each ref keeps a `.log`: an append-only list of every root it has ever
committed. Garbage collection marks reachable objects by walking every
entry of every ref's log, not just the current `.root`. So every
snapshot a ref ever committed stays reachable forever, and `gc` can only
reclaim objects that were never committed. On a ref that commits often,
the depot grows without bound: each commit adds roughly its churn in new
objects and nothing is ever collectable.

The lever is the log. If old log entries are removed, the snapshots they
named stop being reachable, and `gc` can reclaim the objects those
snapshots alone held. Depot size then converges to roughly the live
world plus the retained snapshots' churn.

## Reachability model

This is the key fact behind everything else:

**A ref's live tree is protected from `gc` only by its log entries, not
by `.root`.** `cas_tree_gc` computes reachability by walking each ref's
log. It does not read `.root`. The current root is protected because it
is also the newest log entry (`cas_tree_ref_commit` appends the log
entry, then writes `.root`).

The consequence: emptying a ref's log, or dropping its newest entry,
would make `gc` treat the live world as unreachable and delete it. Log
truncation must never remove the newest entry. The code enforces this.

## Sparse references

A ref may be sparse: its log can name objects the depot no longer
stores. This is legal, not just tolerated. It is the shape a partial
replica takes (a node holding an index of content it does not have), and
it is the state a depot is in after pruning and before the next `gc`.

`gc` marking treats a missing object as a boundary. When the mark phase
loads a tree and gets `CAS_ENOTFOUND`, it stops descending there and
keeps going, rather than aborting the whole collection. The absent
object's hash stays marked, which is harmless because there is nothing
to sweep.

A missing object is distinct from a broken one. Any error other than
`CAS_ENOTFOUND`, including `CAS_ETYPE` for an object of the wrong type
and `CAS_EIO` for a read failure, still aborts the mark and fails the
collection. Pruning is expected to produce absent objects. It is not
expected to produce corrupt ones, so corruption remains a hard error.

Note what this means for objects under a missing subtree. If a subtree
object is gone, `gc` cannot enumerate its children, so any child
reachable only through that subtree becomes unreachable and is swept.
You cannot protect content you can no longer walk to. Content shared
with a still-walkable snapshot stays reachable through that other path.

## Log truncation

```c
int
cas_tree_log_truncate(struct cas_tree *ct, const char *name,
                      int keep_count, time_t keep_since, int *removed);
```

Prunes a ref's log. An entry survives if any of these hold:

- it is among the last `keep_count` entries, when `keep_count > 0`
- its commit time is at least `keep_since`, when `keep_since > 0`
- it is the newest entry (always kept, see the reachability model)

The two bounds form a union. Passing both keeps the more generous
result, for example "keep at least the last 100 snapshots, and also keep
everything from the last day." A call with neither bound set is refused
with `CAS_ERR`, because it would ask to keep nothing.

The log is rewritten atomically: kept lines are written to a temporary
file, flushed and fsynced, then renamed over the old log, and the refs
directory is fsynced. The whole operation holds the ref's `.lock` with
`flock`, the same locking `cas_tree_ref_commit` uses, so truncation and
commit cannot interleave.

`*removed`, when non-NULL, receives the number of dropped entries.
Returns `CAS_OK` on success, `CAS_ENOTFOUND` if the ref has no log,
`CAS_ERR` on a bad name or an unset bound, and `CAS_EIO` on I/O failure.

### Removal, not tombstones

Pruned entries are removed from the log outright. The log format is
unchanged. An alternative was to leave a tombstone marker recording that
history existed, which would suit a log that doubles as an audit trail.
That was not worth the added format complexity for the bounded-growth
goal, so pruned lines simply disappear.

## fsck

`cas_tree_fsck` needs no special mode for a pruned depot. It walks each
ref's live `.root` only, never its history, so it never visits a pruned
snapshot and never reports a pruned object as missing. Its contract is
"verify the live root of every ref." After pruning and `gc`, a depot is
incomplete by design but its live roots are intact, and fsck verifies
clean.

## Command line

`castool` exposes both halves of the workflow:

```
castool prune <ref> <keep-count>   drop all but the last keep-count log entries
castool gc [--now]                 collect unreachable objects; --now ignores the grace period
```

`prune` requires `keep-count` of at least 1, consistent with always
keeping the newest entry. Plain `gc` keeps a one hour grace period that
protects freshly written objects, so immediately after a prune it may
reclaim nothing. `gc --now` drops the grace period and collects the
objects the prune freed.

The maintenance cycle for a mutation-heavy ref:

```sh
castool prune main 100
castool gc --now
```

## What this does not change

- Objects shared between refs stay reachable as long as any ref's
  retained log still walks to them. Pruning one ref does not delete
  another ref's content.
- The grace period still applies. `gc` without `--now` will not collect
  objects younger than one hour even if they are unreachable.
- The on-disk formats in [FORMAT.md](FORMAT.md) are unchanged. Only the
  reference contract is relaxed: a ref's log may now name absent
  objects.
