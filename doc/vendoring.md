# Vendoring Third-Party Libraries

Third-party code lives under `src/thirdparty/<lib>/`. We vendor (commit
the source into our own tree) rather than using git submodules. Submodules
add friction for contributors (extra `git submodule update` step, detached
HEADs, opaque pinning) and make offline builds and release tarballs more
fragile. Vendoring keeps the dependency visible in `git log`, lets us
audit upstream changes via diff, and ships a self-contained source tree.

This document describes how to add a new vendored library and how to
refresh an existing one.

## Layout

Each vendored library is a directory under `src/thirdparty/`:

```
src/thirdparty/<lib>/
    <source files>          # only what we actually compile/include
    LICENSE                 # upstream license, verbatim
    README.md               # upstream README (optional but encouraged)
    UPSTREAM                # provenance (see below)
```

The top-level `module.mk` adds `-Isrc/thirdparty/<lib>` to `INCLUDES`. If
the library has `.c` files we compile, append them to `BORIS_SRCS` (and
`MKPASS_SRCS` if needed) from a `src/thirdparty/<lib>/module.mk`.

### What to keep

Keep only what we use. Strip upstream tests, examples, CI config,
language bindings, build files, editor configs, etc. The vendored copy
is not a fork; it is a snapshot of the headers and translation units we
actually link against.

For header-only libraries (jsmn, tiny-aes-style), this is usually just
the header(s) plus `LICENSE` and `README.md`.

### The `UPSTREAM` file

Every vendored library has an `UPSTREAM` file recording where the snapshot
came from. This is the contract that lets us reproduce or refresh the
vendoring later. Format:

```
repo:   <git URL>
commit: <full sha>
ref:    <branch-or-tag> (<git describe>)
date:   <YYYY-MM-DD of the commit>

Vendored files: <comma-separated list>
Update with: scripts/update-<lib>.sh
```

The update script (below) regenerates this file, so do not hand-edit it
after the initial bootstrap unless you also adjust the script.

## Adding a new vendored library

1. **Pick a snapshot.** Prefer the latest tagged release; fall back to
   the upstream default branch if there are no tags or the tags are stale.
2. **Clone into a scratch directory** and identify the minimum set of
   files needed to build against it.
3. **Create `src/thirdparty/<lib>/`** and copy in only those files plus
   `LICENSE` and (optionally) `README.md`.
4. **Write `src/thirdparty/<lib>/UPSTREAM`** by hand for the initial
   import, using the format above.
5. **Wire it into the build.** Add `-Isrc/thirdparty/<lib>` to the
   `INCLUDES` list in the top-level `module.mk`. If the library has
   `.c` files we compile, drop a `module.mk` in the library directory
   that appends them to `BORIS_SRCS`.
6. **Write `scripts/update-<lib>.sh`** (see template below) so future
   refreshes are mechanical.
7. **Verify** with `make -j` and any relevant tests.
8. **Commit** in two logical pieces if the diff is large: the import
   itself, then any local glue/build wiring.

## The update script

Each vendored library gets a paired `scripts/update-<lib>.sh`. The
script clones upstream into a temp directory, checks out the requested
ref (default: upstream's main branch), copies the kept files into
`src/thirdparty/<lib>/`, and rewrites `UPSTREAM`.

Template (adapt the repo URL, default ref, and the file list):

```sh
#!/bin/sh
# Update the vendored copy of <lib> from upstream.
#
# Usage:
#   scripts/update-<lib>.sh           # fetch latest <default-branch>
#   scripts/update-<lib>.sh <ref>     # fetch a specific tag/branch/commit

set -eu

REPO="https://github.com/<owner>/<lib>.git"
REF="${1:-master}"

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
root_dir=$(CDPATH= cd -- "$script_dir/.." && pwd)
dest="$root_dir/src/thirdparty/<lib>"

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

git clone --quiet --depth 50 "$REPO" "$tmp/src"
git -C "$tmp/src" checkout --quiet "$REF"

commit=$(git -C "$tmp/src" rev-parse HEAD)
described=$(git -C "$tmp/src" describe --tags --always 2>/dev/null || echo "$commit")
date=$(git -C "$tmp/src" log -1 --format=%cs)

mkdir -p "$dest"
install -m 0644 "$tmp/src/<file>"    "$dest/<file>"
install -m 0644 "$tmp/src/LICENSE"   "$dest/LICENSE"
install -m 0644 "$tmp/src/README.md" "$dest/README.md"

cat > "$dest/UPSTREAM" <<EOF
repo:   $REPO
commit: $commit
ref:    $REF ($described)
date:   $date

Vendored files: <file>, LICENSE, README.md
Update with: scripts/update-<lib>.sh
EOF

echo "Updated <lib> to $described ($commit)"
```

Keep the script POSIX `sh` (no bashisms). It must be re-runnable and
idempotent: running it twice in a row with the same ref should produce
no diff.

## Refreshing an existing library

```sh
scripts/update-<lib>.sh           # latest default branch
scripts/update-<lib>.sh v1.2.3    # specific tag
```

Then:

1. `git diff src/thirdparty/<lib>/` -- read the upstream changes; do
   not skip this. Look for license changes, new files we now need, files
   we kept that were removed upstream, and any behavioral changes that
   affect our callers.
2. `make -j && make tests` -- confirm the build still works and tests
   still pass.
3. Commit the refresh as its own commit, with the upstream `git describe`
   in the commit message so the bump is searchable later.

## Migrating a submodule to vendored

If a library is currently a submodule and we want to vendor it instead:

1. Back up the files we want to keep (`jsmn.h`, `LICENSE`, `README.md`,
   etc.) outside the working tree.
2. Remove the submodule:
   ```sh
   git submodule deinit -f src/thirdparty/<lib>
   git rm -f src/thirdparty/<lib>
   rm -rf .git/modules/src/thirdparty/<lib>
   ```
   If this was the only submodule, also `git rm .gitmodules`.
3. `mkdir -p src/thirdparty/<lib>` and copy the kept files back in.
4. Write `UPSTREAM` and `scripts/update-<lib>.sh` as described above.
5. Verify the build and commit.

The `jsmn` migration (commit history under `src/thirdparty/jsmn/`) is the
worked example.
