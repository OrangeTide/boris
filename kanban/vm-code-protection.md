---
title: VM Code Write-Protection and Decoded-Instruction Cache
status: backlog
gitlab-sync: OrangeTide/boris#103
---

Investigate giving the task memory image a read/write/execute protection map
(the read-only code map skjegg's core assumes), then enabling the vendored
decoded-instruction cache on top of it. Deferred: the runtime works without
it, and the cache is unsafe until the protection exists.

## Why

The skjegg RV32 core ships a decoded-instruction cache
(`rv_dec_enable`/`rv_dec_free`, `RV_DEC_BITS = 16`). It is a direct-mapped
predecode table keyed by guest PC with no invalidation: its fast path serves
`d->insn` without re-reading memory, on the stated invariant that "guest code
never changes". skjegg holds that invariant with per-segment
read/write/execute page protection. Our `src/vm/` image does not: `bus_probe`
only bounds-checks, and the bus write callbacks write to any in-range address
including the program's own `.text`. So enabling the cache today would let a
guest that overwrites its code run stale decodes, a correctness and isolation
hole. Write-protecting code is also defense in depth on its own.

## Consequences to weigh

- Correctness: without immutable code, a cache hit runs the old decode. The
  cache has no dirty tracking or flush; the memory map must guarantee code
  is not writable.
- Memory: `RV_DEC_SIZE` (65536) * `sizeof(rv_dec)` (12 bytes) is ~768 KB per
  task, about 6x the 128 KB RAM image. Cheap for a few long-lived tasks,
  expensive at scale on the Raspberry Pi target.

## Runtime policy idea

Make the cache a per-task choice, not always-on:

- Enable it for full programs with a main procedure that are complex or
  long-running (resident agents, long tasks), where the fill cost and the
  768 KB amortize.
- Skip it for verbs thawed from an object, run once, and released, where a
  cache that never sees a re-execution is pure overhead.

## Tasks

- [ ] Track per-region protection in the task image, seeded from the ELF
      segment flags (`elf32` already parses `PF_R`/`PF_W`/`PF_X`).
- [ ] Make `bus_probe` fault a write to a read-only or executable region, so
      guest code cannot be modified. Add a test that a store into `.text`
      faults.
- [ ] Enable `rv_dec_enable` per task under that invariant; `rv_dec_free` in
      `vm_task_free`. Add a cache-on vs cache-off parity test.
- [ ] Add the per-task enable policy (long-lived program vs short verb) and a
      way to select it at spawn.
