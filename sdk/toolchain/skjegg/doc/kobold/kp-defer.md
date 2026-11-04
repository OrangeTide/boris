# Kobold-Pascal defer (scoped teardown)

This note describes `defer`: a statement that registers teardown to run when its
enclosing block exits. It gives a routine a single, local place to pair a release
with its acquisition, instead of repeating the cleanup before every `exit` and on
every error path.

> Status: implemented. `defer STMT` is a statement anywhere a statement is legal.
> Deferred statements run LIFO on every orderly exit from their block, and are
> skipped by a trap.

## What it does

`defer STMT` does not run `STMT` where it is written. It registers `STMT` to run
later, at the end of the block that contains the `defer`, in last-registered /
first-run (LIFO) order. The block is the lexical statement block: a routine body,
a loop body, an `if`/`else` branch, or any `begin`..`end`. To defer more than one
statement, defer a block:

```pascal
defer begin
  Close(f);
  emit(done);
end;
```

## When the deferred statements run

They run on every **orderly** exit from the block:

- falling off the end of the block;
- `exit` or `exit(v)` (the result `v` is computed first, then the teardown runs,
  then the routine returns);
- `break` and `continue` (the loop body's defers run before control leaves the
  body; `continue` runs them before the next iteration);
- a failable divert (`or exit`, `or break`, `or continue`, `or fail`).

A deferred statement in a loop body runs at the end of **each** iteration, because
the body is a block entered once per iteration.

They do **not** run on a trap (panic, assertion, bounds, nil dispatch,
divide-by-zero, overflow). A trap unwinds straight to the program's single landing
pad and exits 70; teardown that must survive a fault is not what `defer` is for.

## Example

```pascal
procedure withResource;
begin
  Acquire;
  defer Release;        { runs however this routine leaves: fall-through, exit, or a failed step }
  step1() or fail;      { on failure, Release runs, then the error forwards }
  if done then exit;    { Release runs here too }
  step2();
end;                    { and here, on fall-through }
```

LIFO lets acquisitions nest correctly:

```pascal
A; defer releaseA;
B; defer releaseB;
{ block end runs releaseB, then releaseA }
```

## Restrictions

The deferred statement runs during teardown, so it may not itself transfer control
out of its own block. These are compile errors inside a `defer`:

- `exit` and `fail`,
- `break` and `continue`,
- `yield`,
- `goto`,
- a failable divert (`or exit`/`or break`/`or continue`/`or fail`),
- a nested `defer`.

A failable call inside a deferred statement must still handle its own error (for
example `cleanup() or else ignore`), the same rule that applies anywhere.

## Interaction with coroutines

A `yield` suspends a coroutine; it is not an exit, so it does not run defers.
Dropping a coroutine while it is suspended does not run its pending defers in this
version; place teardown that must survive a cancel outside the coroutine.

## Lowering (for maintainers)

`defer` is a front-end feature with no runtime support: the compiler re-lowers the
deferred statement at each exit edge of its block, LIFO, so a trap (which does not
take an exit edge) naturally skips it and a routine with no `defer` is unchanged.
Because Kobold has no block-scoped locals and only a restricted routine-local
computed `goto`, every exit edge is statically known, so no runtime defer stack is
needed.
