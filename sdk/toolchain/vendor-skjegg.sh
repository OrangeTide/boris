#!/bin/sh
# vendor-skjegg.sh — vendor selected skjegg compiler components
#
# Copy this script into your project and edit ORIGIN below if needed.
# Running it generates update-skjegg.sh with your component selection
# baked in for easy re-vendoring.
#
# Usage: vendor-skjegg.sh [-d DIR] [-r REF] [-u DIR] component ...
#        update-skjegg.sh                      (re-vendor)
#
# Backends:  coldfire  riscv  mips
# Frontends: tinc  scheme  moo  pascal  cc
# Tools:     as  ld  cpp
# Emulators: emu-cf  emu-rv  emu-mips
# Kobold:    kp

set -eu

ORIGIN="https://github.com/OrangeTide/skjegg-compiler-suite.git"
COMPONENTS=""
DEST="skjegg"
REF="main"
UPDATE_DIR="."

die() { printf 'error: %s\n' "$*" >&2; exit 1; }

usage() {
    cat <<'USAGE'
Usage: vendor-skjegg.sh [-d DIR] [-r REF] [-u DIR]
                        [--arch LIST] [--frontend LIST] [--with LIST]
                        [component ...]
       update-skjegg.sh                      (re-vendor)

Selection axes (comma- or space-separated; repeatable).  Each expands into
the flat component tokens listed further down, so pick a target and the
features you want and the right tools come along:

  --arch LIST       target architectures:  coldfire  riscv  mips  x86-64  aarch64
                      (x86-64 and aarch64 are the hardware-virtualization
                      targets: with --with emulator they build the HV core, run
                      natively under the host hypervisor, not an emulated CPU)
  --frontend LIST   language front ends:   tinc  scheme  moo  pascal  cc  kobold
  --with LIST       per-target or standalone features:
                      toolchain   in-tree assembler + linker (+ ar) for each
                                  selected --arch
                      emulator    the skj-run CPU core for each selected --arch
                                  (an emulated core for coldfire/riscv/mips; the
                                  KVM hardware-virtualization core for x86-64/
                                  aarch64)
                      runtime     the hosted libc + crt (needs cc and toolchain)
                      sandbox     build the hosted libc confined: its fd I/O
                                  (open/read/write/lseek/close) routes through
                                  the capability fs/ layer (needs runtime)
                      cpp         the standalone C preprocessor

Example:
  vendor-skjegg.sh --arch riscv,mips --frontend cc --with toolchain,emulator

Flat components (the axes expand to these; still accepted directly, so an
older update-skjegg.sh keeps working):

Backends:  coldfire  riscv  mips  x86-64  arm64
             (x86-64/arm64 are the LP64 cc backends; pair with their toolchain
              and runtime for a self-contained 64-bit C target)
Frontends: tinc  scheme  moo  pascal  cc
Tools:     as  ld  as-rv  ld-rv  as-mips  ld-mips  ar  cpp  addr2line
           as-x86-64  ld-x86-64  as-aarch64  ld-arm64
             (as-rv/ld-rv: the RISC-V RV32 toolchain; as-mips/ld-mips: the
              MIPS I toolchain, ld-mips writes ELF and PlayStation PS-EXE;
              ar: a target-neutral archive tool for any of the linkers;
              addr2line: the offline DWARF symbolizer, maps a backtrace's
              addresses back to file:line, independent of any backend;
              as-x86-64/ld-x86-64 and as-aarch64/ld-arm64: the 64-bit ELF64
              assembler and linker pairs, so a consumer assembles and links
              x86-64 or AArch64 objects with no external binutils)
Emulators: emu-cf  emu-rv  emu-mips
             (skj-run; any mix, or none.  emu-cf is the ColdFire core,
              emu-rv the RV32 core, emu-mips the little-endian MIPS I core.)
Kobold:    kp                (the Kobold-Pascal AOT path: the native front end
             skj-kpc and the KPM1 compiler skj-kp over the bootstrap seed, plus
             the runtime libkpaot.a; add riscv for the KPM1->RV32 compiler)

Usage docs for the selected tools and languages are vendored into DIR/doc
(README.md always, plus the per-component reference, e.g. the whole Kobold
doc set with kp).

Options:
  -d DIR   destination directory (default: skjegg)
  -r REF   git ref: branch or tag (default: main)
  -u DIR   install update-skjegg.sh to DIR (default: cwd)
  -h       show this help
USAGE
    exit 1
}

# ---- option parsing ----
#
# Two interfaces, which compose.  The axes (--arch, --frontend, --with) are the
# documented interface; each expands into the flat component tokens below, which
# remain accepted as positional arguments so an older update-skjegg.sh keeps
# working.  update-skjegg.sh re-vendors through the expanded token list.

_u_explicit=0
_archs="" _frontends="" _features=""

while [ $# -gt 0 ]; do
    case "$1" in
        -d) DEST="$2"; shift 2 ;;
        -d*) DEST="${1#-d}"; shift ;;
        -r) REF="$2"; shift 2 ;;
        -r*) REF="${1#-r}"; shift ;;
        -u) UPDATE_DIR="$2"; _u_explicit=1; shift 2 ;;
        -u*) UPDATE_DIR="${1#-u}"; _u_explicit=1; shift ;;
        --arch) _archs="$_archs $(echo "$2" | tr ',' ' ')"; shift 2 ;;
        --arch=*) _archs="$_archs $(echo "${1#--arch=}" | tr ',' ' ')"; shift ;;
        --frontend) _frontends="$_frontends $(echo "$2" | tr ',' ' ')"; shift 2 ;;
        --frontend=*) _frontends="$_frontends $(echo "${1#--frontend=}" | tr ',' ' ')"; shift ;;
        --with) _features="$_features $(echo "$2" | tr ',' ' ')"; shift 2 ;;
        --with=*) _features="$_features $(echo "${1#--with=}" | tr ',' ' ')"; shift ;;
        -h|--help) usage ;;
        --) shift; while [ $# -gt 0 ]; do COMPONENTS="$COMPONENTS $1"; shift; done ;;
        -*) die "unknown option: $1 (see -h)" ;;
        *) COMPONENTS="$COMPONENTS $1"; shift ;;      # legacy positional token
    esac
done

# Expand the architecture axis into backend tokens.
for _a in $_archs; do
    case "$_a" in
        cf|coldfire|m68k)   COMPONENTS="$COMPONENTS coldfire" ;;
        rv|rv32|riscv)      COMPONENTS="$COMPONENTS riscv" ;;
        mips|mipsel)        COMPONENTS="$COMPONENTS mips" ;;
        x86-64|x86_64|amd64) COMPONENTS="$COMPONENTS x86-64" ;;
        aarch64|arm64)      COMPONENTS="$COMPONENTS arm64" ;;
        *) die "unknown --arch: $_a (coldfire riscv mips x86-64 aarch64)" ;;
    esac
done

# Expand the front-end axis.
for _f in $_frontends; do
    case "$_f" in
        tinc|scheme|moo|pascal|cc) COMPONENTS="$COMPONENTS $_f" ;;
        kobold|kp)                 COMPONENTS="$COMPONENTS kp" ;;
        *) die "unknown --frontend: $_f (tinc scheme moo pascal cc kobold)" ;;
    esac
done

# Expand the feature axis.  toolchain and emulator are per-architecture, so they
# read which backends were selected above.
_sel() { case " $COMPONENTS " in *" $1 "*) return 0 ;; esac; return 1; }
for _w in $_features; do
    case "$_w" in
        toolchain)
            _sel coldfire && COMPONENTS="$COMPONENTS as ld"
            _sel riscv    && COMPONENTS="$COMPONENTS as-rv ld-rv"
            _sel mips     && COMPONENTS="$COMPONENTS as-mips ld-mips"
            _sel x86-64   && COMPONENTS="$COMPONENTS as-x86-64 ld-x86-64"
            _sel arm64    && COMPONENTS="$COMPONENTS as-aarch64 ld-arm64"
            COMPONENTS="$COMPONENTS ar" ;;
        emulator|emu)
            _sel coldfire && COMPONENTS="$COMPONENTS emu-cf"
            _sel riscv    && COMPONENTS="$COMPONENTS emu-rv"
            _sel mips     && COMPONENTS="$COMPONENTS emu-mips"
            { _sel x86-64 || _sel arm64 || _sel hv-x86 || _sel hv-arm64; } \
                && COMPONENTS="$COMPONENTS emu-hv" ;;
        runtime)  COMPONENTS="$COMPONENTS ar" ;;
        sandbox)  COMPONENTS="$COMPONENTS ar sandbox" ;;   # the confined libc needs ar
        cpp)      COMPONENTS="$COMPONENTS cpp" ;;
        frontend=*)
            for _f in $(echo "${_w#frontend=}" | tr ',' ' '); do
                case "$_f" in
                    tinc|scheme|moo|pascal|cc) COMPONENTS="$COMPONENTS $_f" ;;
                    kobold|kp)                 COMPONENTS="$COMPONENTS kp" ;;
                    *) die "unknown frontend: $_f" ;;
                esac
            done ;;
        *) die "unknown --with feature: $_w (toolchain emulator runtime sandbox cpp)" ;;
    esac
done

# Collapse duplicate tokens so the baked COMPONENTS (and the skjegg.mk header)
# read cleanly; the has_* flags are idempotent, so this is only cosmetic.
COMPONENTS=$(printf '%s\n' $COMPONENTS | awk '!seen[$0]++' | tr '\n' ' ')
COMPONENTS=${COMPONENTS% }

if [ -z "$COMPONENTS" ]; then
    die "nothing selected (see -h)"
fi

# ---- parse and validate components ----

has_cf=0 has_rv=0 has_mips=0 has_x64_be=0 has_a64_be=0
has_tinc=0 has_scheme=0 has_moo=0 has_pascal=0 has_cc=0
has_as=0 has_ld=0 has_cpp=0
has_as_rv=0 has_ld_rv=0
has_as_mips=0 has_ld_mips=0 has_ar=0
has_as_x64=0 has_ld_x64=0 has_as_a64=0 has_ld_a64=0
has_emu_cf=0 has_emu_rv=0 has_emu_mips=0 has_emu_hv=0
has_hv_x86=0 has_hv_arm64=0
has_kp=0 has_sandbox=0 has_addr2line=0

for comp in $COMPONENTS; do
    case "$comp" in
        coldfire) has_cf=1 ;;
        riscv)    has_rv=1 ;;
        x86-64)   has_x64_be=1 ;;
        arm64)    has_a64_be=1 ;;
        mips)     has_mips=1 ;;
        tinc)     has_tinc=1 ;;
        scheme)   has_scheme=1 ;;
        moo)      has_moo=1 ;;
        pascal)   has_pascal=1 ;;
        cc)       has_cc=1 ;;
        as)       has_as=1 ;;
        ld)       has_ld=1 ;;
        as-rv)    has_as_rv=1 ;;
        ld-rv)    has_ld_rv=1 ;;
        as-mips)  has_as_mips=1 ;;
        ld-mips)  has_ld_mips=1 ;;
        as-x86-64) has_as_x64=1 ;;
        ld-x86-64) has_ld_x64=1 ;;
        as-aarch64) has_as_a64=1 ;;
        ld-arm64) has_ld_a64=1 ;;
        ar)       has_ar=1 ;;
        cpp)      has_cpp=1 ;;
        emu-cf)   has_emu_cf=1 ;;
        emu-rv)   has_emu_rv=1 ;;
        emu-mips) has_emu_mips=1 ;;
        hv-x86)   has_hv_x86=1 ;;
        hv-arm64) has_hv_arm64=1 ;;
        emu-hv)   has_emu_hv=1 ;;
        kp|kobold) has_kp=1 ;;
        sandbox)  has_sandbox=1 ;;
        addr2line) has_addr2line=1 ;;
        *)        die "unknown component: $comp" ;;
    esac
done

has_fe=$((has_tinc + has_scheme + has_moo + has_pascal + has_cc))
has_be=$((has_cf + has_rv + has_mips + has_x64_be + has_a64_be))

if [ "$has_fe" -gt 0 ] && [ "$has_be" -eq 0 ]; then
    die "frontends require at least one backend"
fi

need_cpp_lib=0
if [ "$has_cc" -eq 1 ] || [ "$has_cpp" -eq 1 ]; then
    need_cpp_lib=1
fi

# The cross driver (skjcc) ships with cc.  It is useful for a target only when
# that target's in-tree assembler and linker are also vendored, since the driver
# runs the binutils-free skj-as*/skj-ld* pipeline (the ColdFire path uses
# skj-as/skj-ld, not m68k-linux-gnu-as/ld).  Stage a target's crt/runtime only
# when its whole in-tree toolchain is present.
drv_cf=0 drv_rv=0 drv_mips=0 drv_x64=0 drv_a64=0
if [ "$has_cc" -eq 1 ]; then
    [ "$has_cf" -eq 1 ]   && [ "$has_as" -eq 1 ]      && [ "$has_ld" -eq 1 ]      && drv_cf=1
    [ "$has_rv" -eq 1 ]   && [ "$has_as_rv" -eq 1 ]   && [ "$has_ld_rv" -eq 1 ]   && drv_rv=1
    [ "$has_mips" -eq 1 ] && [ "$has_as_mips" -eq 1 ] && [ "$has_ld_mips" -eq 1 ] && drv_mips=1
    [ "$has_x64_be" -eq 1 ] && [ "$has_as_x64" -eq 1 ] && [ "$has_ld_x64" -eq 1 ] && drv_x64=1
    [ "$has_a64_be" -eq 1 ] && [ "$has_as_a64" -eq 1 ] && [ "$has_ld_a64" -eq 1 ] && drv_a64=1
fi
has_driver=0
[ $((drv_cf + drv_rv + drv_mips + drv_x64 + drv_a64)) -gt 0 ] && has_driver=1

# The hosted libc (printf/malloc/stdio/... plus the coroutine primitive and the
# cooperative threads.h subset over it) ships
# with the driver when skj-ar is also vendored, since its on-demand libc.a is
# built with skj-ar.  Without ar the driver stays freestanding (the crt plus the
# runtime helpers), as before.
has_libc=0
[ "$has_driver" -eq 1 ] && [ "$has_ar" -eq 1 ] && has_libc=1
if [ "$has_driver" -eq 1 ] && [ "$has_ar" -eq 0 ]; then
    printf 'note: add the "ar" component for a hosted libc; the driver is freestanding without it\n' >&2
fi

# The sandbox feature builds that hosted libc confined (its fd I/O routes through
# the fs/ capability layer), so it needs the libc: a backend, cc, that backend's
# in-tree toolchain, and ar.
if [ "$has_sandbox" -eq 1 ] && [ "$has_libc" -eq 0 ]; then
    die "the sandbox feature confines the hosted libc, so it needs one: add cc, a backend, that backend's toolchain (as/ld) and ar (e.g. --frontend cc --with toolchain,runtime,sandbox)"
fi

# ---- fetch ----

command -v git >/dev/null || die "git is required"

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

printf 'Fetching %s (ref: %s) ...\n' "$ORIGIN" "$REF"
git clone --quiet --depth 1 --branch "$REF" "$ORIGIN" "$tmpdir/src"
commit=$(git -C "$tmpdir/src" rev-parse --short HEAD)
printf '  commit %s\n' "$commit"

S="$tmpdir/src"

# ---- copy files ----

rm -rf "$DEST"

# version (always present; the tools' --version reads it, and it must come
# from skjegg rather than from the consuming project's git tags)
mkdir -p "$DEST"
cp "$S/version.mk" "$DEST/"

# release notes (always present), so a consuming project carries the history of
# what it pulled in; re-copied by update-skjegg.sh on each re-vendoring
cp "$S/CHANGELOG.md" "$DEST/"

# IR core (always present)
mkdir -p "$DEST/ir"
cp "$S/ir/ir.c" "$S/ir/ir.h" "$S/ir/util.c" "$S/ir/util.h" \
   "$S/ir/arena.c" "$S/ir/arena.h" "$S/ir/target.h" "$DEST/ir/"

# backends
if [ "$has_cf" -eq 1 ]; then
    mkdir -p "$DEST/backend" "$DEST/runtime"
    cp "$S/backend/cf_emit.c" "$S/backend/regalloc_cf.c" "$DEST/backend/"
    # start.S .includes crt_entry_cf.S (argv/entry) and syscall_cf.S (the shared
    # syscall seam), so all three ship.
    cp "$S/runtime/start.S" "$S/runtime/crt_entry_cf.S" \
       "$S/runtime/syscall_cf.S" "$DEST/runtime/"
fi
if [ "$has_rv" -eq 1 ]; then
    mkdir -p "$DEST/backend" "$DEST/runtime"
    cp "$S/backend/rv_select.c" "$S/backend/rv_mc_text.c" \
       "$S/backend/rv_mc.h" "$S/backend/rv_select.h" "$S/backend/rv_mc_text.h" \
       "$S/backend/regalloc_rv.c" "$DEST/backend/"
    # start_rv.S .includes crt_entry_rv.S (argv/entry), syscall_rv.S (the shared
    # syscall seam) and i64_rv.S (64-bit integer helpers), so all ship.
    cp "$S/runtime/start_rv.S" "$S/runtime/crt_entry_rv.S" \
       "$S/runtime/syscall_rv.S" "$S/runtime/i64_rv.S" "$DEST/runtime/"
fi
if [ "$has_mips" -eq 1 ]; then
    # The Linux crt (start_mips.S), plus what MIPS I specifically needs: half.c
    # (no hardware _Float16, so IR_FLH/FSH lower to these helpers) and
    # softfloat.c (the FPU-less soft-float path, for skj-cc-mips-sf and the
    # PlayStation R3051).  start_psx.S is the BIOS-TTY crt for the PS-EXE that
    # skj-ld-mips writes.
    mkdir -p "$DEST/backend" "$DEST/runtime"
    cp "$S/backend/mips_emit.c" "$S/backend/regalloc_mips.c" "$DEST/backend/"
    cp "$S/runtime/start_mips.S" "$S/runtime/start_psx.S" \
       "$S/runtime/half.c" "$S/runtime/softfloat.c" "$DEST/runtime/"
fi
# The 64-bit (LP64) cc backends: the shared instruction selector over the GAS
# text sink.  x86-64 adds the AOT sink and half.c (_Float16 softfloat, via the
# SysV register ABI); AArch64 has a native fcvt and needs no half helper.  The
# SysV crt (start_x86_64_sysv.s) and AAPCS crt (start_arm64_aapcs.S), and the
# varargs helper per ABI, round out the hosted dev/test runtime these targets
# link (there is no libc on this tier).
if [ "$has_x64_be" -eq 1 ]; then
    mkdir -p "$DEST/backend" "$DEST/runtime"
    cp "$S/backend/regalloc_x86.c" "$S/backend/x86_select.c" \
       "$S/backend/mc_text.c" "$S/backend/x86_aot.c" \
       "$S/backend/mc.h" "$S/backend/mc_text.h" "$S/backend/x86_select.h" \
       "$DEST/backend/"
    cp "$S/runtime/start_x86_64_sysv.s" "$S/runtime/va_x86_64.c" \
       "$S/runtime/half.c" "$DEST/runtime/"
fi
if [ "$has_a64_be" -eq 1 ]; then
    mkdir -p "$DEST/backend" "$DEST/runtime"
    cp "$S/backend/regalloc_arm64.c" "$S/backend/arm64_select.c" \
       "$S/backend/arm64_mc_text.c" \
       "$S/backend/arm64_mc.h" "$S/backend/arm64_select.h" \
       "$S/backend/arm64_mc_text.h" "$DEST/backend/"
    cp "$S/runtime/start_arm64_aapcs.S" "$S/runtime/va_aarch64.c" "$DEST/runtime/"
fi

# frontends
if [ "$has_tinc" -eq 1 ]; then
    mkdir -p "$DEST/tinc"
    cp "$S"/tinc/*.c "$S"/tinc/*.h "$DEST/tinc/"
fi
if [ "$has_scheme" -eq 1 ]; then
    mkdir -p "$DEST/scheme"
    cp "$S/scheme/lex.c" "$S/scheme/parse.c" "$S/scheme/print.c" \
       "$S/scheme/lower.c" "$S/scheme/main.c" "$S/scheme/gc.c" \
       "$S/scheme/gc.h" "$S/scheme/scheme.h" "$DEST/scheme/"
fi
if [ "$has_moo" -eq 1 ]; then
    mkdir -p "$DEST/moo" "$DEST/runtime"
    cp "$S"/moo/*.c "$S"/moo/*.h "$DEST/moo/"
    for f in "$S"/moo/*.md "$S"/moo/*.ebnf; do
        [ -e "$f" ] && cp "$f" "$DEST/moo/"
    done
    cp "$S/runtime/str.c" "$S/runtime/list.c" \
       "$S/runtime/host_stub.c" "$S/runtime/toy_host.c" "$DEST/runtime/"
fi
if [ "$has_pascal" -eq 1 ]; then
    mkdir -p "$DEST/pascal" "$DEST/runtime"
    cp "$S"/pascal/*.c "$S"/pascal/*.h "$DEST/pascal/"
    cp "$S/runtime/pascal_rt.c" "$DEST/runtime/"
fi
if [ "$has_cc" -eq 1 ]; then
    mkdir -p "$DEST/cc"
    cp "$S"/cc/*.c "$S"/cc/*.h "$DEST/cc/"
    # The portable C headers skj-cc owns (<stdarg.h>), on skj-cc's default
    # include search path (baked in as SKJ_INCLUDE_DIR on the tool build), plus
    # the varargs runtime helper (__va_arg), one file per backend ABI.  A cc
    # program using <stdarg.h> links the matching va_*.o.
    mkdir -p "$DEST/include" "$DEST/runtime"
    cp "$S/include/stdarg.h" "$DEST/include/"
    [ "$has_cf" -eq 1 ]   && cp "$S/runtime/va_cf.c" "$DEST/runtime/"
    [ "$has_rv" -eq 1 ]   && cp "$S/runtime/va_rv.c" "$DEST/runtime/"
    [ "$has_mips" -eq 1 ] && cp "$S/runtime/va_mips.c" "$DEST/runtime/"
fi

# cross driver (skjcc): one command over the per-target cc -> as -> ld pipeline.
# Ships with cc, for the targets whose in-tree toolchain is also vendored.  The
# ColdFire driver links half.o (the _Float16 helper), so half.c comes along;
# the MIPS backend already copied it, RISC-V uses native Zfh and needs none.
if [ "$has_driver" -eq 1 ]; then
    mkdir -p "$DEST/driver" "$DEST/runtime"
    cp "$S/driver/main.c" "$DEST/driver/"
    [ "$drv_cf" -eq 1 ] && cp "$S/runtime/half.c" "$DEST/runtime/"
fi

# The hosted libc: its C sources and the public headers skj-cc resolves from the
# baked-in include dir, the coroutine context switch for each driver target, and
# the 64-bit divide helpers (soft64.c, divide-only) the rv/mips libc needs for
# 64-bit printf.  Archived into a per-target libc.a the driver links on demand.
if [ "$has_libc" -eq 1 ]; then
    mkdir -p "$DEST/libc" "$DEST/include" "$DEST/include/sys" "$DEST/runtime"
    cp "$S"/libc/*.c "$S"/libc/*.h "$DEST/libc/"
    cp "$S"/include/*.h "$DEST/include/"
    cp "$S"/include/sys/*.h "$DEST/include/sys/"
    # rand.c draws on the shared fast generator in runtime/rng.c.
    cp "$S/runtime/rng.c" "$S/runtime/rng.h" "$DEST/runtime/"
    [ "$drv_cf" -eq 1 ]   && cp "$S/runtime/co_switch_cf.S" "$DEST/runtime/"
    [ "$drv_rv" -eq 1 ]   && cp "$S/runtime/co_switch_rv.S" "$DEST/runtime/"
    [ "$drv_mips" -eq 1 ] && cp "$S/runtime/co_switch_mips.S" "$DEST/runtime/"
    { [ "$drv_rv" -eq 1 ] || [ "$drv_mips" -eq 1 ]; } && cp "$S/runtime/soft64.c" "$DEST/runtime/"
fi

# The capability fs/ layer, the guest side of the sandbox: fdio.c (already in
# libc/, copied above) is the libc interposition seam, and these are the backend
# it routes to.  hostfs.c is the host-only test backend, not a guest source.
if [ "$has_sandbox" -eq 1 ]; then
    mkdir -p "$DEST/fs"
    cp "$S/fs/fs.c" "$S/fs/fs.h" "$S/fs/fs_internal.h" \
       "$S/fs/ramfs.c" "$S/fs/ramfs.h" \
       "$S/fs/ambientfs.c" "$S/fs/ambientfs.h" \
       "$S/fs/hostcap.c" "$S/fs/hostcap.h" \
       "$S/fs/devfs.c" "$S/fs/devfs.h" \
       "$S/fs/romfs.c" "$S/fs/romfs.h" \
       "$S/fs/ninefs.c" "$S/fs/ninefs.h" \
       "$S/fs/p9_guest.c" "$S/fs/p9_guest.h" "$S/fs/p9_wire.h" "$S/fs/wire.h" "$DEST/fs/"
fi

# cpp library (needed by cc and cpp tool)
if [ "$need_cpp_lib" -eq 1 ]; then
    mkdir -p "$DEST/cpp"
    cp "$S/cpp/tok.c" "$S/cpp/macro.c" "$S/cpp/cond.c" "$S/cpp/dir.c" \
       "$S/cpp/cpp.h" "$S/cpp/internal.h" "$DEST/cpp/"
fi
if [ "$has_cpp" -eq 1 ]; then
    cp "$S/cpp/main.c" "$DEST/cpp/"
fi

# assembler.  The arch-neutral skeleton (asm_lex + asm_obj) is shared by the
# ColdFire assembler (as), the RISC-V one (as-rv) and the MIPS one (as-mips);
# each front end plus its standalone tool is taken separately, like the two
# emulator cores.
if [ "$has_as" -eq 1 ] || [ "$has_as_rv" -eq 1 ] || [ "$has_as_mips" -eq 1 ] \
   || [ "$has_as_x64" -eq 1 ] || [ "$has_as_a64" -eq 1 ]; then
    mkdir -p "$DEST/as" "$DEST/dwarf"
    cp "$S/as/asm_lex.c" "$S/as/asm_obj.c" \
       "$S/as/asm_lex.h" "$S/as/asm_obj.h" "$DEST/as/"
    # every assembler emits DWARF line tables for -g, so the dwarf builder ships.
    cp "$S/dwarf/dwarf.c" "$S/dwarf/dwarf.h" "$DEST/dwarf/"
fi
if [ "$has_as" -eq 1 ]; then                    # ColdFire front end + tool
    cp "$S/as/parse.c" "$S/as/encode.c" "$S/as/elf.c" \
       "$S/as/as.h" "$S/as/main.c" "$DEST/as/"
fi
if [ "$has_as_rv" -eq 1 ]; then                 # RISC-V front end + tool
    cp "$S/as/rv_parse.c" "$S/as/rv_encode.c" "$S/as/rv_elf.c" \
       "$S/as/rv_macro.c" "$S/as/rv.h" "$S/as/rv_main.c" "$DEST/as/"
fi
if [ "$has_as_mips" -eq 1 ]; then               # MIPS front end + tool
    cp "$S/as/mips_parse.c" "$S/as/mips_encode.c" "$S/as/mips_elf.c" \
       "$S/as/mips_sched.c" "$S/as/mips.h" "$S/as/mips_main.c" "$DEST/as/"
fi
if [ "$has_as_x64" -eq 1 ]; then                # x86-64 front end + tool
    cp "$S/as/x86_64_parse.c" "$S/as/x86_64_encode.c" "$S/as/x86_64_elf.c" \
       "$S/as/x86_64.h" "$S/as/x86_64_main.c" "$DEST/as/"
fi
if [ "$has_as_a64" -eq 1 ]; then                # AArch64 front end + tool
    cp "$S/as/aarch64_parse.c" "$S/as/aarch64_encode.c" "$S/as/aarch64_elf.c" \
       "$S/as/aarch64_macho.c" "$S/as/aarch64.h" "$S/as/aarch64_main.c" \
       "$DEST/as/"
fi

# linker.  The layout core, script parser and mapfile reader (link/script/
# mapfile) are shared by the ColdFire linker (ld), the RISC-V one (ld-rv) and
# the MIPS one (ld-mips); each target's ELF I/O plus its tool is taken
# separately.
if [ "$has_ld" -eq 1 ] || [ "$has_ld_rv" -eq 1 ] || [ "$has_ld_mips" -eq 1 ] \
   || [ "$has_ld_x64" -eq 1 ] || [ "$has_ld_a64" -eq 1 ]; then
    mkdir -p "$DEST/ld"
    cp "$S/ld/script.c" "$S/ld/link.c" "$S/ld/mapfile.c" \
       "$S/ld/ld.h" "$S/ld/mapfile.h" "$DEST/ld/"
fi
# The ELF64 reader, writer and ar support are shared by the x86-64 linker
# (ld-x86-64) and the AArch64 one (ld-arm64); each tool's relocation applier and
# driver come separately.
if [ "$has_ld_x64" -eq 1 ] || [ "$has_ld_a64" -eq 1 ]; then
    mkdir -p "$DEST/ld"
    cp "$S/ld/elf64_read.c" "$S/ld/elf64_write.c" "$S/ld/elf64_archive.c" \
       "$S/ld/elf64_ld.h" "$DEST/ld/"
fi
if [ "$has_ld_x64" -eq 1 ]; then                # x86-64 reloc applier + tool
    cp "$S/ld/x86_64_link.c" "$S/ld/x86_64_main.c" "$DEST/ld/"
fi
if [ "$has_ld_a64" -eq 1 ]; then                # AArch64 reloc applier + tool
    cp "$S/ld/aarch64_link.c" "$S/ld/aarch64_main.c" "$DEST/ld/"
fi
if [ "$has_ld" -eq 1 ]; then                    # ColdFire ELF I/O + tool
    cp "$S/ld/elf_read.c" "$S/ld/elf_write.c" "$S/ld/archive.c" \
       "$S/ld/main.c" "$DEST/ld/"
fi
if [ "$has_ld_rv" -eq 1 ]; then                 # RISC-V ELF I/O + reloc + tool
    cp "$S/ld/rv_elf_read.c" "$S/ld/rv_link.c" "$S/ld/rv_elf_write.c" \
       "$S/ld/rv_archive.c" "$S/ld/rv_ld.h" "$S/ld/rv_main.c" "$DEST/ld/"
fi
if [ "$has_ld_mips" -eq 1 ]; then               # MIPS ELF+PS-EXE I/O + reloc + tool
    cp "$S/ld/mips_elf_read.c" "$S/ld/mips_link.c" "$S/ld/mips_elf_write.c" \
       "$S/ld/mips_psexe_write.c" "$S/ld/mips_archive.c" "$S/ld/mips_ld.h" \
       "$S/ld/mips_main.c" "$DEST/ld/"
fi

# skj-ar, a target-neutral archive tool.  It needs only the mapfile reader from
# ld/, so a bare "ar" selection stays minimal; the copy is idempotent when a
# linker already brought mapfile in.
if [ "$has_ar" -eq 1 ]; then
    mkdir -p "$DEST/ld" "$DEST/ar"
    cp "$S/ld/mapfile.c" "$S/ld/mapfile.h" "$DEST/ld/"
    cp "$S/ar/main.c" "$DEST/ar/"
fi

# emulator (skj-run).  The CPU cores are independent: a project that
# runs only ColdFire guests takes emu-cf and never carries the RV32 or
# MIPS cores.
if [ "$has_emu_cf" -eq 1 ] || [ "$has_emu_rv" -eq 1 ] || \
   [ "$has_emu_mips" -eq 1 ] || [ "$has_emu_hv" -eq 1 ]; then
    mkdir -p "$DEST/emu" "$DEST/fs"
    cp "$S/emu/main.c" "$S/emu/guest.c" "$S/emu/guest.h" \
       "$S/emu/elf32.c" "$S/emu/elf32.h" \
       "$S/emu/elf64.c" "$S/emu/elf64.h" "$S/emu/run_reason.h" \
       "$S/emu/sched.c" "$S/emu/sched.h" \
       "$S/emu/hostplat.c" "$S/emu/hostplat.h" "$DEST/emu/"
    # guest.c reads the fs/ mount-table layout and, for the --9p doorbell, drives
    # the host-side 9P2000 server; reaches host facilities through hostplat.
    # sched.c is the arch-neutral process sandbox every core's *_user.c binds to.
    cp "$S/fs/fs.h" "$S/fs/ninefs.h" "$S/fs/p9_wire.h" "$S/fs/wire.h" \
       "$S/fs/p9_server.c" "$S/fs/p9_server.h" "$DEST/fs/"
    # The vDSO image source (pure leaf functions plus the host-updated system
    # page) and its ABI header.  skj-run already supports --vdso through the emu
    # base above; these let a consumer with the matching skj toolchain build the
    # image.  The per-core linker script ships beside each core below.  The HV
    # images are not built in a vendored tree (the x86-64/arm64 C toolchain is
    # host-only), so their scripts are not shipped.
    mkdir -p "$DEST/include"
    cp "$S/runtime/vdso.c" "$DEST/runtime/"
    cp "$S/include/skj_vdso.h" "$DEST/include/"
fi
if [ "$has_emu_cf" -eq 1 ]; then
    cp "$S/emu/coldfire.c" "$S/emu/coldfire.h" "$S/emu/cf_user.c" "$DEST/emu/"
    cp "$S/runtime/vdso_cf.ld" "$DEST/runtime/"
fi
if [ "$has_emu_rv" -eq 1 ]; then
    cp "$S/emu/rv32.c" "$S/emu/rv32.h" "$S/emu/rv_user.c" "$DEST/emu/"
    cp "$S/emu/rv_gdb.c" "$S/emu/rv_gdb.h" "$DEST/emu/"     # --gdb PORT stub
    cp "$S/runtime/vdso_rv.ld" "$DEST/runtime/"
fi
if [ "$has_emu_mips" -eq 1 ]; then
    cp "$S/emu/mips32.c" "$S/emu/mips32.h" "$S/emu/mips_user.c" "$DEST/emu/"
    cp "$S/emu/mips_gdb.c" "$S/emu/mips_gdb.h" "$DEST/emu/"  # --gdb PORT stub
    cp "$S/runtime/vdso_mips.ld" "$DEST/runtime/"
fi
# The hardware-virtualization core: one body (hvcore.c) serves both x86-64 and
# aarch64 guests, over the backend-neutral VMM seam (vmm.h) with one backend per
# host hypervisor: Linux KVM (vmm_kvm.c) and macOS Hypervisor.framework
# (vmm_hvf.c); hv_gdb.c is its --gdb stub.  The guest arch equals the host's, so
# a given host exercises one arch and one backend; all sources are shipped since
# they are shared and the consumer's Makefile fragment picks the backend by host
# OS.  skj_hv_abi.h is the guest/host doorbell contract.
if [ "$has_emu_hv" -eq 1 ]; then
    cp "$S/emu/hvcore.c" "$S/emu/hvcore.h" \
       "$S/emu/vmm.h" "$S/emu/vmm_kvm.c" "$S/emu/vmm_hvf.c" \
       "$S/emu/hv_gdb.c" "$S/emu/hv_gdb.h" \
       "$S/emu/skj_hv_abi.h" "$DEST/emu/"
fi
# The DWARF line/symbol reader behind the symbolized fault backtrace on the
# emulated cores (gated by SKJ_DWARF_BACKTRACE in rv/cf/mips_user.c).  It needs
# only ir/arena (copied above), not dwarf/dwarf.c.
if [ "$has_emu_cf" -eq 1 ] || [ "$has_emu_rv" -eq 1 ] || [ "$has_emu_mips" -eq 1 ]; then
    mkdir -p "$DEST/dwarf"
    cp "$S/dwarf/dwread.c" "$S/dwarf/dwread.h" "$DEST/dwarf/"
fi
# skj-addr2line: the offline symbolizer, for resolving a backtrace's addresses
# or inspecting symbols by hand against a guest ELF.  It is the standalone CLI
# over the same DWARF reader, so it brings dwread (shared with the backtrace
# above; the cp is idempotent) and needs only ir/arena+util (copied above).
if [ "$has_addr2line" -eq 1 ]; then
    mkdir -p "$DEST/dwarf"
    cp "$S/dwarf/addr2line_main.c" "$S/dwarf/dwread.c" "$S/dwarf/dwread.h" \
       "$DEST/dwarf/"
fi

# Kobold-Pascal AOT path (kobold).  The front end kpcom is in-tree Pascal source
# (kobold/kpcom.pas); this carries the KPM1 reader and runtime (kobold/), the
# x86-64 selector the host tools build on, and the jit/ call trampoline libkpaot
# links.  There is no committed seed: the x86-64 bootstrap seed is generated at
# vendor time from source (skjegg's own build) and shipped under prebuild/, so a
# consumer AOT-compiles it with skj-kp without needing skj-pc or fpc.  With riscv
# also selected it adds the jit/ pieces the RV32 runtime needs.  The freestanding
# runtime and its libkpaot*-free rules arrive with a later step.
if [ "$has_kp" -eq 1 ]; then
    mkdir -p "$DEST/kobold" "$DEST/backend" "$DEST/jit" "$DEST/prebuild" "$DEST/runtime"
    cp "$S"/kobold/*.c "$S"/kobold/*.h "$S"/kobold/*.S "$DEST/kobold/"
    # The coroutine context switches live in runtime/ (beside start*.S); the
    # Kobold runtime links the one for each selected backend.
    cp "$S/runtime/co_switch_x86.S" "$S/runtime/co_switch_rv.S" \
       "$S/runtime/co_switch_arm64.S" "$DEST/runtime/"
    cp "$S/kobold/kpcom.pas" "$S/kobold/version.inc" "$S/kobold/stdlib.inc" \
       "$DEST/kobold/"
    cp "$S/backend/regalloc_x86.c" "$S/backend/x86_select.c" \
       "$S/backend/mc_text.c" "$S/backend/x86_aot.c" \
       "$S/backend/mc.h" "$S/backend/mc_text.h" "$S/backend/x86_select.h" \
       "$DEST/backend/"
    cp "$S/jit/call_guest_x86.S" "$DEST/jit/"
    if [ "$has_rv" -eq 1 ]; then
        cp "$S/jit/call_guest_rv.S" "$S/jit/rv_jit_i64.S" "$DEST/jit/"
    fi
    # No committed seed: generate the x86-64 (LP64) seed from source now and ship
    # it as prebuild/kpcom.kpm.  skjegg's own build builds the host front end from
    # kpcom.pas via skj-pc and emits this module; the consumer's skjegg.mk then
    # AOT-compiles it with skj-kp (x86-64) into skj-kpc.
    make -s -C "$S" build/kpcom-x86-64.kpm
    cp "$S/build/kpcom-x86-64.kpm" "$DEST/prebuild/kpcom.kpm"
fi

# Documentation.  Vendor the usage docs for each selected tool and language, so
# a consuming project carries the reference for what it actually took.
# README.md is the toolkit overview (the tool list and how each is invoked); the
# rest are per-component and copied only when that component is selected.
mkdir -p "$DEST/doc"
cp "$S/README.md" "$DEST/doc/"

if [ "$has_cc" -eq 1 ]; then
    cp "$S/doc/languages/c.md" "$DEST/doc/"
fi
if [ "$has_pascal" -eq 1 ]; then
    cp "$S/doc/languages/pascal.md" "$DEST/doc/"
fi
# MooScript and TinScheme share the scripting overview
if [ "$has_moo" -eq 1 ] || [ "$has_scheme" -eq 1 ]; then
    cp "$S/doc/languages/game-scripting.md" "$DEST/doc/"
fi
if [ "$has_mips" -eq 1 ]; then
    cp "$S/doc/tools/mips.md" "$DEST/doc/"
fi
# the assembler/linker/archiver family: one toolchain manual covers how they
# fit the pipeline, so any of them pulls it
if [ "$has_as" -eq 1 ] || [ "$has_ld" -eq 1 ] || [ "$has_ar" -eq 1 ] \
   || [ "$has_as_rv" -eq 1 ] || [ "$has_ld_rv" -eq 1 ] \
   || [ "$has_as_mips" -eq 1 ] || [ "$has_ld_mips" -eq 1 ] \
   || [ "$has_as_x64" -eq 1 ] || [ "$has_ld_x64" -eq 1 ] \
   || [ "$has_as_a64" -eq 1 ] || [ "$has_ld_a64" -eq 1 ]; then
    cp "$S/doc/tools/toolchain.md" "$DEST/doc/"
fi
# The emulator (skj-run): how to run guests and embed the scheduler, how the
# --gdb debugger and the symbolized fault backtrace work.  Any core pulls all
# three, since the debugger and backtrace ride in the same skj-run.
if [ "$has_emu_cf" -eq 1 ] || [ "$has_emu_rv" -eq 1 ] || [ "$has_emu_mips" -eq 1 ] \
   || [ "$has_emu_hv" -eq 1 ]; then
    cp "$S/doc/tools/emulator.md" "$S/doc/tools/process-model.md" \
       "$S/doc/tools/debugger.md" "$DEST/doc/"
fi
if [ "$has_libc" -eq 1 ]; then
    cp "$S/doc/tools/libc.md" "$DEST/doc/"
fi
# Kobold-Pascal: the whole language doc set (guide, tutorial, grammar,
# semantics, builtins, embedding, sandbox, ...), which is how to use the
# language and its toolchain.
if [ "$has_kp" -eq 1 ]; then
    mkdir -p "$DEST/doc/kobold"
    cp "$S"/doc/languages/kobold/*.md "$DEST/doc/kobold/"
    # the JIT ships with Kobold, so its manual rides along
    cp "$S/doc/tools/jit.md" "$DEST/doc/"
fi

# LICENSE
if [ -f "$S/LICENSE" ]; then
    cp "$S/LICENSE" "$DEST/"
fi

# ---- generate update-skjegg.sh ----

if [ -n "$UPDATE_DIR" ]; then
    _upd_dir="$UPDATE_DIR"
else
    _upd_dir="$(dirname "$0")"
fi

if [ "$_u_explicit" -eq 1 ]; then
    _baked_upd="$UPDATE_DIR"
else
    _baked_upd=""
fi

tmp_upd=$(mktemp)
sed -e "s|^ORIGIN=.*|ORIGIN=\"$ORIGIN\"|" \
    -e "s|^COMPONENTS=\"\"|COMPONENTS=\"$COMPONENTS\"|" \
    -e "s|^DEST=.*|DEST=\"$DEST\"|" \
    -e "s|^REF=.*|REF=\"$REF\"|" \
    -e "s|^UPDATE_DIR=.*|UPDATE_DIR=\"$_baked_upd\"|" \
    "$0" > "$tmp_upd"
chmod +x "$tmp_upd"
mkdir -p "$_upd_dir"
mv "$tmp_upd" "$_upd_dir/update-skjegg.sh"

# ---- generate skjegg.mk ----

MK="$DEST/skjegg.mk"

emit_compiler() {
    _name="$1"; _fe="$2"; _be="$3"; _inc="$4"; _extra="${5:-}"
    if [ -n "$_extra" ]; then
        _all_src="\$(SKJ_IR) \$($_be) \$($_fe) $_extra"
    else
        _all_src="\$(SKJ_IR) \$($_be) \$($_fe)"
    fi
    {
        printf '\nSKJ_ALL += $(BUILD)/%s\n' "$_name"
        printf '$(BUILD)/%s: %s | $(BUILD)\n' "$_name" "$_all_src"
        printf '\t$(CC) $(CFLAGS) %s -o $@ %s\n' "$_inc" "$_all_src"
    } >> "$MK"
}

# header
cat > "$MK" <<EOF
# skjegg.mk — vendored skjegg compiler toolkit
# Origin: $ORIGIN ($commit)
# Components: $COMPONENTS
# Generated: $(date -u +%Y-%m-%d)
#
# Include from your Makefile:
#   include $DEST/skjegg.mk
#
# Then build with:
#   make skjegg

SKJEGG := \$(dir \$(lastword \$(MAKEFILE_LIST)))
BUILD  ?= build

CC     ?= cc
CFLAGS ?= -std=c99 -O2 -Wall -Wextra -Wpedantic -Wno-unused-parameter
CFLAGS += -I\$(BUILD)

# The vendored skjegg version.  Fixed at vendoring time; deliberately not
# derived from git, since git here is your project, not skjegg.
#
# SKJ_VERSION names the release.  The commit is baked in beside it because
# a vendored tree may come from a ref that has moved past that release, and
# a bare release number would then overstate what you actually have.
include \$(SKJEGG)version.mk
SKJ_VENDOR_REF    := $REF
SKJ_VENDOR_COMMIT := $commit
SKJ_FULL_VERSION  := \$(SKJ_VERSION)\$(if \$(SKJ_VENDOR_COMMIT),+g\$(SKJ_VENDOR_COMMIT))
EOF

# cross-toolchain variables
if [ "$has_cf" -eq 1 ]; then
    cat >> "$MK" <<'MK'

M68K_CC ?= m68k-linux-gnu-gcc
M68K_AS ?= m68k-linux-gnu-as
M68K_LD ?= m68k-linux-gnu-ld
MK
fi
if [ "$has_rv" -eq 1 ]; then
    cat >> "$MK" <<'MK'

RV_AS ?= riscv64-linux-gnu-as
RV_LD ?= riscv64-linux-gnu-ld
RV_CC ?= riscv64-linux-gnu-gcc
MK
fi
if [ "$has_mips" -eq 1 ]; then
    cat >> "$MK" <<'MK'

MIPS_CC ?= mipsel-none-elf-gcc
MIPS_AS ?= mipsel-none-elf-as
MIPS_LD ?= mipsel-none-elf-ld
MK
fi

# source variables
{
    printf '\n# sources\n'
    printf 'SKJ_IR := $(SKJEGG)ir/ir.c $(SKJEGG)ir/util.c $(SKJEGG)ir/arena.c\n'
} >> "$MK"

if [ "$has_cf" -eq 1 ]; then
    printf 'SKJ_CF := $(SKJEGG)backend/regalloc_cf.c $(SKJEGG)backend/cf_emit.c\n' >> "$MK"
fi
if [ "$has_rv" -eq 1 ]; then
    printf 'SKJ_RV := $(SKJEGG)backend/regalloc_rv.c $(SKJEGG)backend/rv_select.c $(SKJEGG)backend/rv_mc_text.c\n' >> "$MK"
fi
if [ "$has_mips" -eq 1 ]; then
    printf 'SKJ_MIPS := $(SKJEGG)backend/regalloc_mips.c $(SKJEGG)backend/mips_emit.c\n' >> "$MK"
fi
if [ "$has_x64_be" -eq 1 ]; then
    printf 'SKJ_X64 := $(SKJEGG)backend/regalloc_x86.c $(SKJEGG)backend/x86_select.c $(SKJEGG)backend/mc_text.c $(SKJEGG)backend/x86_aot.c\n' >> "$MK"
fi
if [ "$has_a64_be" -eq 1 ]; then
    printf 'SKJ_A64 := $(SKJEGG)backend/regalloc_arm64.c $(SKJEGG)backend/arm64_select.c $(SKJEGG)backend/arm64_mc_text.c\n' >> "$MK"
fi

if [ "$has_tinc" -eq 1 ]; then
    cat >> "$MK" <<'MK'
SKJ_TINC := $(SKJEGG)tinc/lex.c $(SKJEGG)tinc/parse.c \
            $(SKJEGG)tinc/lower.c $(SKJEGG)tinc/main.c
MK
fi
if [ "$has_scheme" -eq 1 ]; then
    cat >> "$MK" <<'MK'
SKJ_SCHEME := $(SKJEGG)scheme/lex.c $(SKJEGG)scheme/parse.c \
              $(SKJEGG)scheme/print.c $(SKJEGG)scheme/lower.c \
              $(SKJEGG)scheme/main.c $(SKJEGG)scheme/gc.c
MK
fi
if [ "$has_moo" -eq 1 ]; then
    cat >> "$MK" <<'MK'
SKJ_MOO := $(SKJEGG)moo/lex.c $(SKJEGG)moo/parse.c $(SKJEGG)moo/typecheck.c \
           $(SKJEGG)moo/lower.c $(SKJEGG)moo/main.c
MK
fi
if [ "$has_pascal" -eq 1 ]; then
    cat >> "$MK" <<'MK'
SKJ_PASCAL := $(SKJEGG)pascal/lex.c $(SKJEGG)pascal/parse.c \
              $(SKJEGG)pascal/lower.c $(SKJEGG)pascal/main.c
MK
fi
if [ "$has_cc" -eq 1 ]; then
    cat >> "$MK" <<'MK'
SKJ_CC := $(SKJEGG)cc/lex.c $(SKJEGG)cc/parse.c $(SKJEGG)cc/type.c \
          $(SKJEGG)cc/lower.c $(SKJEGG)cc/main.c
MK
fi
if [ "$need_cpp_lib" -eq 1 ]; then
    cat >> "$MK" <<'MK'
SKJ_CPP_LIB := $(SKJEGG)cpp/tok.c $(SKJEGG)cpp/macro.c \
               $(SKJEGG)cpp/cond.c $(SKJEGG)cpp/dir.c
MK
fi
if [ "$has_as" -eq 1 ]; then
    cat >> "$MK" <<'MK'
SKJ_AS_LIB := $(SKJEGG)as/asm_lex.c $(SKJEGG)as/asm_obj.c \
              $(SKJEGG)as/parse.c $(SKJEGG)as/encode.c $(SKJEGG)as/elf.c \
              $(SKJEGG)dwarf/dwarf.c
MK
fi
if [ "$has_ld" -eq 1 ]; then
    cat >> "$MK" <<'MK'
SKJ_LD_LIB := $(SKJEGG)ld/elf_read.c $(SKJEGG)ld/script.c \
              $(SKJEGG)ld/link.c $(SKJEGG)ld/elf_write.c \
              $(SKJEGG)ld/mapfile.c $(SKJEGG)ld/archive.c
MK
fi
if [ "$has_as_rv" -eq 1 ]; then
    cat >> "$MK" <<'MK'
SKJ_AS_RV_LIB := $(SKJEGG)as/asm_lex.c $(SKJEGG)as/asm_obj.c \
                 $(SKJEGG)as/rv_parse.c $(SKJEGG)as/rv_encode.c \
                 $(SKJEGG)as/rv_macro.c $(SKJEGG)as/rv_elf.c \
                 $(SKJEGG)dwarf/dwarf.c
MK
fi
if [ "$has_ld_rv" -eq 1 ]; then
    cat >> "$MK" <<'MK'
SKJ_LD_RV_LIB := $(SKJEGG)ld/rv_elf_read.c $(SKJEGG)ld/rv_link.c \
                 $(SKJEGG)ld/rv_elf_write.c $(SKJEGG)ld/rv_archive.c \
                 $(SKJEGG)ld/link.c $(SKJEGG)ld/script.c $(SKJEGG)ld/mapfile.c
MK
fi
if [ "$has_as_mips" -eq 1 ]; then
    cat >> "$MK" <<'MK'
SKJ_AS_MIPS_LIB := $(SKJEGG)as/asm_lex.c $(SKJEGG)as/asm_obj.c \
                   $(SKJEGG)as/mips_parse.c $(SKJEGG)as/mips_encode.c \
                   $(SKJEGG)as/mips_elf.c $(SKJEGG)as/mips_sched.c \
                   $(SKJEGG)dwarf/dwarf.c
MK
fi
if [ "$has_ld_mips" -eq 1 ]; then
    cat >> "$MK" <<'MK'
SKJ_LD_MIPS_LIB := $(SKJEGG)ld/mips_elf_read.c $(SKJEGG)ld/mips_link.c \
                   $(SKJEGG)ld/mips_elf_write.c $(SKJEGG)ld/mips_psexe_write.c \
                   $(SKJEGG)ld/mips_archive.c $(SKJEGG)ld/link.c \
                   $(SKJEGG)ld/script.c $(SKJEGG)ld/mapfile.c
MK
fi
if [ "$has_as_x64" -eq 1 ]; then
    cat >> "$MK" <<'MK'
SKJ_AS_X64_LIB := $(SKJEGG)as/asm_lex.c $(SKJEGG)as/asm_obj.c \
                  $(SKJEGG)as/x86_64_parse.c $(SKJEGG)as/x86_64_encode.c \
                  $(SKJEGG)as/x86_64_elf.c
MK
fi
if [ "$has_as_a64" -eq 1 ]; then
    cat >> "$MK" <<'MK'
SKJ_AS_A64_LIB := $(SKJEGG)as/asm_lex.c $(SKJEGG)as/asm_obj.c \
                  $(SKJEGG)as/aarch64_parse.c $(SKJEGG)as/aarch64_encode.c \
                  $(SKJEGG)as/aarch64_elf.c $(SKJEGG)as/aarch64_macho.c \
                  $(SKJEGG)dwarf/dwarf.c
MK
fi
if [ "$has_ld_x64" -eq 1 ]; then
    cat >> "$MK" <<'MK'
SKJ_LD_X64_LIB := $(SKJEGG)ld/elf64_read.c $(SKJEGG)ld/x86_64_link.c \
                  $(SKJEGG)ld/elf64_write.c $(SKJEGG)ld/elf64_archive.c \
                  $(SKJEGG)ld/link.c $(SKJEGG)ld/script.c $(SKJEGG)ld/mapfile.c
MK
fi
if [ "$has_ld_a64" -eq 1 ]; then
    cat >> "$MK" <<'MK'
SKJ_LD_A64_LIB := $(SKJEGG)ld/elf64_read.c $(SKJEGG)ld/aarch64_link.c \
                  $(SKJEGG)ld/elf64_write.c $(SKJEGG)ld/elf64_archive.c \
                  $(SKJEGG)ld/link.c $(SKJEGG)ld/script.c $(SKJEGG)ld/mapfile.c
MK
fi

# compiler binary rules (frontend x backend)
printf '\nSKJ_ALL :=\n' >> "$MK"

if [ "$has_tinc" -eq 1 ] && [ "$has_cf" -eq 1 ]; then
    emit_compiler skj-tinc SKJ_TINC SKJ_CF '-I$(SKJEGG)ir -I$(SKJEGG)tinc'
fi
if [ "$has_tinc" -eq 1 ] && [ "$has_rv" -eq 1 ]; then
    emit_compiler skj-tinc-rv SKJ_TINC SKJ_RV '-I$(SKJEGG)ir -I$(SKJEGG)tinc'
fi
if [ "$has_tinc" -eq 1 ] && [ "$has_mips" -eq 1 ]; then
    emit_compiler skj-tinc-mips SKJ_TINC SKJ_MIPS '-I$(SKJEGG)ir -I$(SKJEGG)tinc'
fi
if [ "$has_scheme" -eq 1 ] && [ "$has_cf" -eq 1 ]; then
    emit_compiler skj-sc SKJ_SCHEME SKJ_CF '-I$(SKJEGG)scheme -I$(SKJEGG)ir'
fi
if [ "$has_scheme" -eq 1 ] && [ "$has_rv" -eq 1 ]; then
    emit_compiler skj-sc-rv SKJ_SCHEME SKJ_RV '-I$(SKJEGG)scheme -I$(SKJEGG)ir'
fi
if [ "$has_scheme" -eq 1 ] && [ "$has_mips" -eq 1 ]; then
    emit_compiler skj-sc-mips SKJ_SCHEME SKJ_MIPS '-I$(SKJEGG)scheme -I$(SKJEGG)ir'
fi
if [ "$has_moo" -eq 1 ] && [ "$has_cf" -eq 1 ]; then
    emit_compiler skj-mooc SKJ_MOO SKJ_CF '-I$(SKJEGG)moo -I$(SKJEGG)ir'
fi
if [ "$has_moo" -eq 1 ] && [ "$has_rv" -eq 1 ]; then
    emit_compiler skj-mooc-rv SKJ_MOO SKJ_RV '-I$(SKJEGG)moo -I$(SKJEGG)ir'
fi
if [ "$has_moo" -eq 1 ] && [ "$has_mips" -eq 1 ]; then
    emit_compiler skj-mooc-mips SKJ_MOO SKJ_MIPS '-I$(SKJEGG)moo -I$(SKJEGG)ir'
fi
if [ "$has_pascal" -eq 1 ] && [ "$has_cf" -eq 1 ]; then
    emit_compiler skj-pc SKJ_PASCAL SKJ_CF '-I$(SKJEGG)pascal -I$(SKJEGG)ir'
fi
if [ "$has_pascal" -eq 1 ] && [ "$has_rv" -eq 1 ]; then
    emit_compiler skj-pc-rv SKJ_PASCAL SKJ_RV '-I$(SKJEGG)pascal -I$(SKJEGG)ir'
fi
if [ "$has_pascal" -eq 1 ] && [ "$has_mips" -eq 1 ]; then
    emit_compiler skj-pc-mips SKJ_PASCAL SKJ_MIPS '-I$(SKJEGG)pascal -I$(SKJEGG)ir'
fi
# The cc tools bake in the default include search path (the vendored
# include/ holding <stdarg.h>), so `#include <stdarg.h>` resolves with no -I
# from the consumer; SKJ_CC_INCLUDE still overrides it at run time.
cc_inc='-I$(SKJEGG)cc -I$(SKJEGG)cpp -I$(SKJEGG)ir -DSKJ_INCLUDE_DIR='\''"$(abspath $(SKJEGG)include)"'\'
if [ "$has_cc" -eq 1 ] && [ "$has_cf" -eq 1 ]; then
    emit_compiler skj-cc SKJ_CC SKJ_CF \
        "-DCC_M68K $cc_inc" '$(SKJ_CPP_LIB)'
fi
if [ "$has_cc" -eq 1 ] && [ "$has_rv" -eq 1 ]; then
    # The RISC-V C compiler emits the standard ILP32 psABI (a0..a7) so its
    # output interlinks with gcc; it pairs with the standalone RV toolchain
    # (as-rv/ld-rv) and runtime/start_rv_psabi_cc.S.
    emit_compiler skj-cc-rv SKJ_CC SKJ_RV \
        "-DCC_RISCV $cc_inc" '$(SKJ_CPP_LIB)'
fi
if [ "$has_cc" -eq 1 ] && [ "$has_mips" -eq 1 ]; then
    emit_compiler skj-cc-mips SKJ_CC SKJ_MIPS \
        "-DCC_MIPS $cc_inc" '$(SKJ_CPP_LIB)'
    # The soft-float build: same sources with -DMIPS_SOFTFLOAT, emitting no
    # coprocessor-1 instruction and lowering every float op to a runtime/
    # softfloat.c call, for the FPU-less R3051 (the PlayStation).
    emit_compiler skj-cc-mips-sf SKJ_CC SKJ_MIPS \
        "-DCC_MIPS -DMIPS_SOFTFLOAT $cc_inc" '$(SKJ_CPP_LIB)'
fi
if [ "$has_cc" -eq 1 ] && [ "$has_x64_be" -eq 1 ]; then
    # LP64, SysV psABI, struct-by-value ABI; the selector needs backend/ headers.
    emit_compiler skj-cc-x86-64 SKJ_CC SKJ_X64 \
        "-DX86_BITS=64 -DSKJ_LP64=1 -DCC_PSABI -DCC_STRUCT_ABI -I\$(SKJEGG)backend $cc_inc" \
        '$(SKJ_CPP_LIB)'
fi
if [ "$has_cc" -eq 1 ] && [ "$has_a64_be" -eq 1 ]; then
    emit_compiler skj-cc-arm64 SKJ_CC SKJ_A64 \
        "-DSKJ_LP64=1 -DCC_PSABI -DCC_ARM64 $cc_inc" '$(SKJ_CPP_LIB)'
fi

# tool binary rules
if [ "$has_cpp" -eq 1 ]; then
    {
        printf '\nSKJ_ALL += $(BUILD)/skj-cpp\n'
        printf '$(BUILD)/skj-cpp: $(SKJEGG)cpp/main.c $(SKJ_CPP_LIB) $(SKJEGG)ir/util.c $(SKJEGG)ir/arena.c | $(BUILD)\n'
        printf '\t$(CC) $(CFLAGS) -I$(SKJEGG)cpp -I$(SKJEGG)ir -o $@ $(SKJEGG)cpp/main.c $(SKJ_CPP_LIB) $(SKJEGG)ir/util.c $(SKJEGG)ir/arena.c\n'
    } >> "$MK"
fi
if [ "$has_as" -eq 1 ]; then
    {
        printf '\nSKJ_ALL += $(BUILD)/skj-as\n'
        printf '$(BUILD)/skj-as: $(SKJEGG)as/main.c $(SKJ_AS_LIB) $(SKJEGG)ir/util.c $(SKJEGG)ir/arena.c | $(BUILD)\n'
        printf '\t$(CC) $(CFLAGS) -I$(SKJEGG)as -I$(SKJEGG)ir -I$(SKJEGG)dwarf -o $@ $(SKJEGG)as/main.c $(SKJ_AS_LIB) $(SKJEGG)ir/util.c $(SKJEGG)ir/arena.c\n'
    } >> "$MK"
fi
if [ "$has_ld" -eq 1 ]; then
    {
        printf '\nSKJ_ALL += $(BUILD)/skj-ld\n'
        printf '$(BUILD)/skj-ld: $(SKJEGG)ld/main.c $(SKJ_LD_LIB) $(SKJEGG)ir/util.c $(SKJEGG)ir/arena.c | $(BUILD)\n'
        printf '\t$(CC) $(CFLAGS) -I$(SKJEGG)ld -I$(SKJEGG)ir -o $@ $(SKJEGG)ld/main.c $(SKJ_LD_LIB) $(SKJEGG)ir/util.c $(SKJEGG)ir/arena.c\n'
    } >> "$MK"
fi
if [ "$has_as_rv" -eq 1 ]; then
    {
        printf '\nSKJ_ALL += $(BUILD)/skj-as-rv\n'
        printf '$(BUILD)/skj-as-rv: $(SKJEGG)as/rv_main.c $(SKJ_AS_RV_LIB) $(SKJEGG)ir/util.c $(SKJEGG)ir/arena.c | $(BUILD)\n'
        printf '\t$(CC) $(CFLAGS) -I$(SKJEGG)as -I$(SKJEGG)ir -I$(SKJEGG)dwarf -o $@ $(SKJEGG)as/rv_main.c $(SKJ_AS_RV_LIB) $(SKJEGG)ir/util.c $(SKJEGG)ir/arena.c\n'
    } >> "$MK"
fi
if [ "$has_ld_rv" -eq 1 ]; then
    {
        printf '\nSKJ_ALL += $(BUILD)/skj-ld-rv\n'
        printf '$(BUILD)/skj-ld-rv: $(SKJEGG)ld/rv_main.c $(SKJ_LD_RV_LIB) $(SKJEGG)ir/util.c $(SKJEGG)ir/arena.c | $(BUILD)\n'
        printf '\t$(CC) $(CFLAGS) -I$(SKJEGG)ld -I$(SKJEGG)ir -o $@ $(SKJEGG)ld/rv_main.c $(SKJ_LD_RV_LIB) $(SKJEGG)ir/util.c $(SKJEGG)ir/arena.c\n'
    } >> "$MK"
fi
if [ "$has_as_mips" -eq 1 ]; then
    {
        printf '\nSKJ_ALL += $(BUILD)/skj-as-mips\n'
        printf '$(BUILD)/skj-as-mips: $(SKJEGG)as/mips_main.c $(SKJ_AS_MIPS_LIB) $(SKJEGG)ir/util.c $(SKJEGG)ir/arena.c | $(BUILD)\n'
        printf '\t$(CC) $(CFLAGS) -I$(SKJEGG)as -I$(SKJEGG)ir -I$(SKJEGG)dwarf -o $@ $(SKJEGG)as/mips_main.c $(SKJ_AS_MIPS_LIB) $(SKJEGG)ir/util.c $(SKJEGG)ir/arena.c\n'
    } >> "$MK"
fi
if [ "$has_ld_mips" -eq 1 ]; then
    {
        printf '\nSKJ_ALL += $(BUILD)/skj-ld-mips\n'
        printf '$(BUILD)/skj-ld-mips: $(SKJEGG)ld/mips_main.c $(SKJ_LD_MIPS_LIB) $(SKJEGG)ir/util.c $(SKJEGG)ir/arena.c | $(BUILD)\n'
        printf '\t$(CC) $(CFLAGS) -I$(SKJEGG)ld -I$(SKJEGG)ir -o $@ $(SKJEGG)ld/mips_main.c $(SKJ_LD_MIPS_LIB) $(SKJEGG)ir/util.c $(SKJEGG)ir/arena.c\n'
    } >> "$MK"
fi
if [ "$has_as_x64" -eq 1 ]; then
    {
        printf '\nSKJ_ALL += $(BUILD)/skj-as-x86-64\n'
        printf '$(BUILD)/skj-as-x86-64: $(SKJEGG)as/x86_64_main.c $(SKJ_AS_X64_LIB) $(SKJEGG)ir/util.c $(SKJEGG)ir/arena.c | $(BUILD)\n'
        printf '\t$(CC) $(CFLAGS) -I$(SKJEGG)as -I$(SKJEGG)ir -o $@ $(SKJEGG)as/x86_64_main.c $(SKJ_AS_X64_LIB) $(SKJEGG)ir/util.c $(SKJEGG)ir/arena.c\n'
    } >> "$MK"
fi
if [ "$has_ld_x64" -eq 1 ]; then
    {
        printf '\nSKJ_ALL += $(BUILD)/skj-ld-x86-64\n'
        printf '$(BUILD)/skj-ld-x86-64: $(SKJEGG)ld/x86_64_main.c $(SKJ_LD_X64_LIB) $(SKJEGG)ir/util.c $(SKJEGG)ir/arena.c | $(BUILD)\n'
        printf '\t$(CC) $(CFLAGS) -I$(SKJEGG)ld -I$(SKJEGG)ir -o $@ $(SKJEGG)ld/x86_64_main.c $(SKJ_LD_X64_LIB) $(SKJEGG)ir/util.c $(SKJEGG)ir/arena.c\n'
    } >> "$MK"
fi
if [ "$has_as_a64" -eq 1 ]; then
    {
        printf '\nSKJ_ALL += $(BUILD)/skj-as-aarch64\n'
        printf '$(BUILD)/skj-as-aarch64: $(SKJEGG)as/aarch64_main.c $(SKJ_AS_A64_LIB) $(SKJEGG)ir/util.c $(SKJEGG)ir/arena.c | $(BUILD)\n'
        printf '\t$(CC) $(CFLAGS) -I$(SKJEGG)as -I$(SKJEGG)ir -I$(SKJEGG)dwarf -o $@ $(SKJEGG)as/aarch64_main.c $(SKJ_AS_A64_LIB) $(SKJEGG)ir/util.c $(SKJEGG)ir/arena.c\n'
    } >> "$MK"
fi
if [ "$has_ld_a64" -eq 1 ]; then
    {
        printf '\nSKJ_ALL += $(BUILD)/skj-ld-arm64\n'
        printf '$(BUILD)/skj-ld-arm64: $(SKJEGG)ld/aarch64_main.c $(SKJ_LD_A64_LIB) $(SKJEGG)ir/util.c $(SKJEGG)ir/arena.c | $(BUILD)\n'
        printf '\t$(CC) $(CFLAGS) -I$(SKJEGG)ld -I$(SKJEGG)ir -o $@ $(SKJEGG)ld/aarch64_main.c $(SKJ_LD_A64_LIB) $(SKJEGG)ir/util.c $(SKJEGG)ir/arena.c\n'
    } >> "$MK"
fi
if [ "$has_ar" -eq 1 ]; then
    {
        printf '\nSKJ_ALL += $(BUILD)/skj-ar\n'
        printf '$(BUILD)/skj-ar: $(SKJEGG)ar/main.c $(SKJEGG)ld/mapfile.c $(SKJEGG)ir/util.c $(SKJEGG)ir/arena.c | $(BUILD)\n'
        printf '\t$(CC) $(CFLAGS) -I$(SKJEGG)ld -I$(SKJEGG)ir -o $@ $(SKJEGG)ar/main.c $(SKJEGG)ld/mapfile.c $(SKJEGG)ir/util.c $(SKJEGG)ir/arena.c\n'
    } >> "$MK"
fi
if [ "$has_addr2line" -eq 1 ]; then
    # The offline DWARF symbolizer: resolve a guest address (or a backtrace) to
    # function + file:line against the program's own ELF.
    {
        printf '\nSKJ_ALL += $(BUILD)/skj-addr2line\n'
        printf '$(BUILD)/skj-addr2line: $(SKJEGG)dwarf/addr2line_main.c $(SKJEGG)dwarf/dwread.c $(SKJEGG)ir/arena.c $(SKJEGG)ir/util.c | $(BUILD)\n'
        printf '\t$(CC) $(CFLAGS) -I$(SKJEGG)dwarf -I$(SKJEGG)ir -o $@ $(SKJEGG)dwarf/addr2line_main.c $(SKJEGG)dwarf/dwread.c $(SKJEGG)ir/arena.c $(SKJEGG)ir/util.c\n'
    } >> "$MK"
fi

# cross driver (skjcc).  The driver links each target's crt and runtime helpers
# from <libdir>/<target>/; the build stages that layout under $(BUILD)/lib from
# the already-built runtime objects, and bakes its absolute path in as the
# default lib dir (SKJ_CC_LIB overrides it at run time).  The staged files are
# prerequisites so `make skjegg` produces a working driver; the sub-tools it
# execs (skj-cc*, skj-as*, skj-ld*) are in SKJ_ALL already.
# Emit the per-target libc.a (with the archived co_switch) and fini.o rules into
# the generated Makefile.  $1 lib-dir name, $2 skj-cc, $3 skj-as, $4 co_switch
# source under runtime/.  LIBC_SRCS is defined once below.
emit_libc_rules() {
    _d=$1; _cc=$2; _as=$3; _csw=$4
    {
        printf '\n$(BUILD)/lib/%s/obj/co_switch.o: $(SKJEGG)%s $(BUILD)/%s | $(BUILD)\n' "$_d" "$_csw" "$_as"
        printf '\t@mkdir -p $(BUILD)/lib/%s/obj\n' "$_d"
        printf '\t@$(BUILD)/%s -o $@ $(SKJEGG)%s\n' "$_as" "$_csw"
        printf '$(BUILD)/lib/%s/libc.a: $(BUILD)/%s $(BUILD)/%s $(BUILD)/skj-ar $(BUILD)/lib/%s/obj/co_switch.o | $(BUILD)\n' "$_d" "$_cc" "$_as" "$_d"
        printf '\t@mkdir -p $(BUILD)/lib/%s/obj\n' "$_d"
        printf '\t@for s in $(LIBC_SRCS); do \\\n'
        printf '\t    $(BUILD)/%s -DSKJ_LIBC_FLOAT $(LIBC_FSFLAGS) -I$(SKJEGG)include -I$(SKJEGG)libc -o $(BUILD)/lib/%s/obj/$$s.s $(SKJEGG)libc/$$s.c && \\\n' "$_cc" "$_d"
        printf '\t    $(BUILD)/%s -o $(BUILD)/lib/%s/obj/$$s.o $(BUILD)/lib/%s/obj/$$s.s || exit 1; \\\n' "$_as" "$_d" "$_d"
        printf '\tdone\n'
        # runtime/ sources that join the archive (rng.c, for rand.c)
        printf '\t@for s in $(RT_SRCS); do \\\n'
        printf '\t    $(BUILD)/%s -DSKJ_LIBC_FLOAT $(LIBC_FSFLAGS) -I$(SKJEGG)include -I$(SKJEGG)libc -o $(BUILD)/lib/%s/obj/$$s.s $(SKJEGG)runtime/$$s.c && \\\n' "$_cc" "$_d"
        printf '\t    $(BUILD)/%s -o $(BUILD)/lib/%s/obj/$$s.o $(BUILD)/lib/%s/obj/$$s.s || exit 1; \\\n' "$_as" "$_d" "$_d"
        printf '\tdone\n'
        if [ "$has_sandbox" -eq 1 ]; then
            # the capability fs/ backend fdio.c routes to, compiled from fs/
            printf '\t@for s in $(FS_SRCS); do \\\n'
            printf '\t    $(BUILD)/%s -DSKJ_LIBC_FLOAT $(LIBC_FSFLAGS) -I$(SKJEGG)include -I$(SKJEGG)libc -o $(BUILD)/lib/%s/obj/$$s.s $(SKJEGG)fs/$$s.c && \\\n' "$_cc" "$_d"
            printf '\t    $(BUILD)/%s -o $(BUILD)/lib/%s/obj/$$s.o $(BUILD)/lib/%s/obj/$$s.s || exit 1; \\\n' "$_as" "$_d" "$_d"
            printf '\tdone\n'
        fi
        printf '\t@rm -f $@\n'
        printf '\t@$(BUILD)/skj-ar rcs $@ $(addprefix $(BUILD)/lib/%s/obj/,$(addsuffix .o,$(LIBC_SRCS) $(RT_SRCS) $(FS_SRCS))) $(BUILD)/lib/%s/obj/co_switch.o\n' "$_d" "$_d"
        printf '$(BUILD)/lib/%s/fini.o: $(BUILD)/%s $(BUILD)/%s | $(BUILD)\n' "$_d" "$_cc" "$_as"
        printf '\t@mkdir -p $(BUILD)/lib/%s\n' "$_d"
        printf '\t@$(BUILD)/%s -I$(SKJEGG)include -o $(BUILD)/lib/%s/fini.s $(SKJEGG)libc/fini.c\n' "$_cc" "$_d"
        printf '\t@$(BUILD)/%s -o $@ $(BUILD)/lib/%s/fini.s\n' "$_as" "$_d"
    } >> "$MK"
}

if [ "$has_driver" -eq 1 ]; then
    drv_lib=""
    if [ "$has_libc" -eq 1 ]; then
        # The implemented hosted-libc set (mirrors tests/run-libc-tests.sh's
        # LIBC_DEFAULT): printf's float formatter (numfmt), buffered stdio
        # (stdio_core holds fflush, which the crt's fini.o pulls), and the
        # file/dir ops (stat/fileops/dirent).  getenv.c defines environ, which
        # the crt fills from envp and the vDSO entry walk (and getenv) read; the
        # emulated vDSO image finds its table only through it.  rng is RT_SRCS
        # (runtime/); fini.o is force-linked by the driver, not archived.
        _libc_srcs="string ctype stdlib printf numfmt stdio_core stdio assert malloc sbrk errno strerror rand strtod scanf coro threads stat fileops dirent getenv"
        _fs_srcs=""
        _libc_fsflags=""
        if [ "$has_sandbox" -eq 1 ]; then
            # fdio.c is the libc fd-I/O seam (guarded by SKJ_FS_INTERPOSE); the
            # fs/ sources are the capability backend it routes to.
            _libc_srcs="$_libc_srcs fdio"
            _fs_srcs="fs ramfs ambientfs hostcap devfs romfs ninefs p9_guest"
            _libc_fsflags='-DSKJ_FS_INTERPOSE -DFS_WITH_AMBIENT -DFS_WITH_HOSTCAP -DFS_WITH_DEV -DFS_WITH_ROM -DFS_WITH_9P -I$(SKJEGG)fs'
        fi
        {
            printf '\nLIBC_SRCS := %s\n' "$_libc_srcs"
            printf 'RT_SRCS := rng\n'           # runtime/rng.c, used by rand.c
            printf 'FS_SRCS := %s\n' "$_fs_srcs"
            printf 'LIBC_FSFLAGS := %s\n' "$_libc_fsflags"
        } >> "$MK"
    fi
    if [ "$drv_cf" -eq 1 ]; then
        {
            printf '\n$(BUILD)/lib/coldfire/crt0.o: $(BUILD)/start.o\n\t@mkdir -p $(@D) && cp $< $@\n'
            printf '$(BUILD)/lib/coldfire/half.o: $(BUILD)/half.o\n\t@mkdir -p $(@D) && cp $< $@\n'
            printf '$(BUILD)/lib/coldfire/va_cf.o: $(BUILD)/va_cf.o\n\t@mkdir -p $(@D) && cp $< $@\n'
        } >> "$MK"
        drv_lib="$drv_lib \$(BUILD)/lib/coldfire/crt0.o \$(BUILD)/lib/coldfire/half.o \$(BUILD)/lib/coldfire/va_cf.o"
        if [ "$has_libc" -eq 1 ]; then
            emit_libc_rules coldfire skj-cc skj-as runtime/co_switch_cf.S
            drv_lib="$drv_lib \$(BUILD)/lib/coldfire/libc.a \$(BUILD)/lib/coldfire/fini.o"
        fi
    fi
    if [ "$drv_rv" -eq 1 ]; then
        {
            printf '\n$(BUILD)/lib/riscv/crt0.o: $(BUILD)/start_rv.o\n\t@mkdir -p $(@D) && cp $< $@\n'
            printf '$(BUILD)/lib/riscv/va_rv.o: $(BUILD)/va_rv.o\n\t@mkdir -p $(@D) && cp $< $@\n'
        } >> "$MK"
        drv_lib="$drv_lib \$(BUILD)/lib/riscv/crt0.o \$(BUILD)/lib/riscv/va_rv.o"
        if [ "$has_libc" -eq 1 ]; then
            # The rv libc needs the 64-bit divide helpers (divide-only soft64) its
            # 64-bit printf uses; the rv crt does not carry them.
            printf '\n$(BUILD)/lib/riscv/soft64_div.o: $(SKJEGG)runtime/soft64.c | $(BUILD)\n\t@mkdir -p $(@D)\n\t$(RV_CC) -std=c99 -O2 -Wall -ffreestanding -march=rv32imfd -mabi=ilp32 -DSOFT64_NO_MULSHIFT -c -o $@ $<\n' >> "$MK"
            emit_libc_rules riscv skj-cc-rv skj-as-rv runtime/co_switch_rv.S
            drv_lib="$drv_lib \$(BUILD)/lib/riscv/soft64_div.o \$(BUILD)/lib/riscv/libc.a \$(BUILD)/lib/riscv/fini.o"
        fi
    fi
    if [ "$drv_mips" -eq 1 ]; then
        {
            printf '\n$(BUILD)/lib/mips/crt0.o: $(BUILD)/start_mips.o\n\t@mkdir -p $(@D) && cp $< $@\n'
            printf '$(BUILD)/lib/mips/half.o: $(BUILD)/half_mips.o\n\t@mkdir -p $(@D) && cp $< $@\n'
            printf '$(BUILD)/lib/mips/va_mips.o: $(BUILD)/va_mips.o\n\t@mkdir -p $(@D) && cp $< $@\n'
        } >> "$MK"
        drv_lib="$drv_lib \$(BUILD)/lib/mips/crt0.o \$(BUILD)/lib/mips/half.o \$(BUILD)/lib/mips/va_mips.o"
        if [ "$has_libc" -eq 1 ]; then
            printf '\n$(BUILD)/lib/mips/soft64_div.o: $(SKJEGG)runtime/soft64.c | $(BUILD)\n\t@mkdir -p $(@D)\n\t$(MIPS_CC) -march=mips1 -EL -G 0 -std=c99 -O2 -Wall -ffreestanding -DSOFT64_NO_MULSHIFT -c -o $@ $<\n' >> "$MK"
            emit_libc_rules mips skj-cc-mips skj-as-mips runtime/co_switch_mips.S
            drv_lib="$drv_lib \$(BUILD)/lib/mips/soft64_div.o \$(BUILD)/lib/mips/libc.a \$(BUILD)/lib/mips/fini.o"
        fi
    fi
    if [ "$drv_x64" -eq 1 ]; then
        # Self-hosted: skj-as-x86-64 assembles the SysV crt; skj-cc-x86-64 plus
        # skj-as-x86-64 build the varargs (va) and _Float16 (half) helpers.  No
        # external compiler on this hosted tier (there is no libc to archive).
        {
            printf '\n$(BUILD)/lib/x86-64/crt0.o: $(SKJEGG)runtime/start_x86_64_sysv.s $(BUILD)/skj-as-x86-64 | $(BUILD)\n'
            printf '\t@mkdir -p $(@D)\n'
            printf '\t$(BUILD)/skj-as-x86-64 -o $@ $(SKJEGG)runtime/start_x86_64_sysv.s\n'
            printf '$(BUILD)/lib/x86-64/va.o: $(SKJEGG)runtime/va_x86_64.c $(BUILD)/skj-cc-x86-64 $(BUILD)/skj-as-x86-64 | $(BUILD)\n'
            printf '\t@mkdir -p $(@D)\n'
            printf '\t$(BUILD)/skj-cc-x86-64 -o $(BUILD)/lib/x86-64/va.s $(SKJEGG)runtime/va_x86_64.c\n'
            printf '\t$(BUILD)/skj-as-x86-64 -o $@ $(BUILD)/lib/x86-64/va.s\n'
            printf '$(BUILD)/lib/x86-64/half.o: $(SKJEGG)runtime/half.c $(BUILD)/skj-cc-x86-64 $(BUILD)/skj-as-x86-64 | $(BUILD)\n'
            printf '\t@mkdir -p $(@D)\n'
            printf '\t$(BUILD)/skj-cc-x86-64 -o $(BUILD)/lib/x86-64/half.s $(SKJEGG)runtime/half.c\n'
            printf '\t$(BUILD)/skj-as-x86-64 -o $@ $(BUILD)/lib/x86-64/half.s\n'
        } >> "$MK"
        drv_lib="$drv_lib \$(BUILD)/lib/x86-64/crt0.o \$(BUILD)/lib/x86-64/half.o \$(BUILD)/lib/x86-64/va.o"
    fi
    if [ "$drv_a64" -eq 1 ]; then
        {
            printf '\n$(BUILD)/lib/arm64/crt0.o: $(SKJEGG)runtime/start_arm64_aapcs.S $(BUILD)/skj-as-aarch64 | $(BUILD)\n'
            printf '\t@mkdir -p $(@D)\n'
            printf '\t$(BUILD)/skj-as-aarch64 -o $@ $(SKJEGG)runtime/start_arm64_aapcs.S\n'
            printf '$(BUILD)/lib/arm64/va.o: $(SKJEGG)runtime/va_aarch64.c $(BUILD)/skj-cc-arm64 $(BUILD)/skj-as-aarch64 | $(BUILD)\n'
            printf '\t@mkdir -p $(@D)\n'
            printf '\t$(BUILD)/skj-cc-arm64 -o $(BUILD)/lib/arm64/va.s $(SKJEGG)runtime/va_aarch64.c\n'
            printf '\t$(BUILD)/skj-as-aarch64 -o $@ $(BUILD)/lib/arm64/va.s\n'
        } >> "$MK"
        drv_lib="$drv_lib \$(BUILD)/lib/arm64/crt0.o \$(BUILD)/lib/arm64/va.o"
    fi
    {
        printf '\nSKJ_ALL += $(BUILD)/skjcc\n'
        printf '$(BUILD)/skjcc: $(SKJEGG)driver/main.c%s | $(BUILD)\n' "$drv_lib"
        printf '\t$(CC) $(CFLAGS) -DSKJ_LIB_DIR='\''"$(abspath $(BUILD))/lib"'\'' -o $@ $(SKJEGG)driver/main.c\n'
    } >> "$MK"
fi

# Kobold-Pascal AOT path: the host front end skj-kpc (the seed AOT-compiled) and
# the KPM1 backend compiler skj-kp, plus the hosted runtime libkpaot.a.  With riscv
# also selected, skj-kp-rv compiles KPM1 to RV32 asm (its target runtime, hosted
# libkpaot-rv and the freestanding tier, arrives with a later step).
if [ "$has_kp" -eq 1 ]; then
    cat >> "$MK" <<'MK'

AR      ?= ar
# The x86-64 assembler.  The vendored backend emits GNU `.intel_syntax noprefix`
# assembly, so the default is the host GNU `as` (intel mode via --64).
X64_ASM      ?= as
X64_ASMFLAGS ?= --64

SKJ_BE_X64 := $(SKJEGG)backend/regalloc_x86.c $(SKJEGG)backend/x86_select.c \
              $(SKJEGG)backend/mc_text.c $(SKJEGG)backend/x86_aot.c
SKJ_KP_AOT_RT := $(SKJEGG)kobold/aot_rt.c $(SKJEGG)kobold/kp_host.c $(SKJEGG)kobold/kp_io.c \
                 $(SKJEGG)libc/numfmt.c $(SKJEGG)kobold/str_core.c \
                 $(SKJEGG)kobold/str_fmt.c $(SKJEGG)kobold/dynarr.c $(SKJEGG)kobold/map.c \
                 $(SKJEGG)kobold/rt_host.c $(SKJEGG)kobold/co_shim.c \
                 $(SKJEGG)runtime/co_switch_x86.S $(SKJEGG)jit/call_guest_x86.S
SKJ_KP_CFLAGS := $(CFLAGS) -DX86_BITS=64 -DKP_FREESTANDING -DKP_REAL=double \
                 -I$(SKJEGG)ir -I$(SKJEGG)jit -I$(SKJEGG)backend -I$(SKJEGG)kobold

# skj-kp: the x86-64 KPM1 AOT compiler (reads a .kpm, writes GNU intel assembly).
SKJ_ALL += $(BUILD)/skj-kp
$(BUILD)/skj-kp: $(SKJEGG)kobold/aot_main.c $(SKJEGG)kobold/kpm.c $(SKJ_IR) $(SKJ_BE_X64) | $(BUILD)
	$(CC) $(CFLAGS) -DX86_BITS=64 -I$(SKJEGG)ir -I$(SKJEGG)backend -I$(SKJEGG)kobold -o $@ $(SKJEGG)kobold/aot_main.c $(SKJEGG)kobold/kpm.c $(SKJ_IR) $(SKJ_BE_X64)

# co.c carries Kobold's own warning set (no -Wpedantic), so it is a separate object.
$(BUILD)/kp_co.o: $(SKJEGG)kobold/co.c | $(BUILD)
	$(CC) -std=c99 -O2 -Wall -Wextra -Wno-unused-parameter -I$(SKJEGG)ir -I$(SKJEGG)jit -I$(SKJEGG)backend -I$(SKJEGG)kobold -c $(SKJEGG)kobold/co.c -o $@

# libkpaot.a: the hosted Kobold runtime an AOT program links against.
$(BUILD)/libkpaot.a: $(SKJ_KP_AOT_RT) $(BUILD)/kp_co.o | $(BUILD)
	@rm -rf $(BUILD)/aot && mkdir -p $(BUILD)/aot
	@for f in $(SKJ_KP_AOT_RT); do o=$(BUILD)/aot/`basename $$f | sed 's/\.[cS]$$/.o/'`; $(CC) $(SKJ_KP_CFLAGS) -c $$f -o $$o || exit 1; done
	$(AR) rcs $@ $(BUILD)/aot/*.o $(BUILD)/kp_co.o

# skj-kpc: the Kobold-Pascal front end as a native x86-64 binary.  The vendor-time
# x86-64 seed (prebuild/kpcom.kpm) is AOT-compiled by skj-kp and linked against
# libkpaot.a, so 'skj-kpc --emit-kpm foo.pas' turns Kobold source into a KPM1
# module with no fpc.
SKJ_ALL += $(BUILD)/skj-kpc
$(BUILD)/kpcom.s: $(SKJEGG)prebuild/kpcom.kpm $(BUILD)/skj-kp | $(BUILD)
	$(BUILD)/skj-kp $(SKJEGG)prebuild/kpcom.kpm -o $@
$(BUILD)/kpcom.o: $(BUILD)/kpcom.s | $(BUILD)
	$(X64_ASM) $(X64_ASMFLAGS) $< -o $@
$(BUILD)/skj-kpc: $(BUILD)/kpcom.o $(BUILD)/libkpaot.a | $(BUILD)
	$(CC) -no-pie $(BUILD)/kpcom.o $(BUILD)/libkpaot.a -o $@ -lm
MK
    if [ "$has_rv" -eq 1 ]; then
        cat >> "$MK" <<'MK'

# skj-kp-rv: the KPM1 -> RV32 asm AOT compiler, a host binary.  Link its output with
# the freestanding runtime tier (a later step) or the hosted libkpaot-rv.
SKJ_ALL += $(BUILD)/skj-kp-rv
$(BUILD)/skj-kp-rv: $(SKJEGG)kobold/aot_main.c $(SKJEGG)kobold/kpm.c $(SKJ_IR) $(SKJ_RV) | $(BUILD)
	$(CC) $(CFLAGS) -DKP_AOT_RV -I$(SKJEGG)ir -I$(SKJEGG)backend -I$(SKJEGG)kobold -o $@ $(SKJEGG)kobold/aot_main.c $(SKJEGG)kobold/kpm.c $(SKJ_IR) $(SKJ_RV)
MK
    fi
fi

# emulator driver
if [ "$has_emu_cf" -eq 1 ] || [ "$has_emu_rv" -eq 1 ] || \
   [ "$has_emu_mips" -eq 1 ] || [ "$has_emu_hv" -eq 1 ]; then
    _emu_src='$(SKJEGG)emu/main.c $(SKJEGG)emu/guest.c $(SKJEGG)emu/elf32.c $(SKJEGG)emu/elf64.c $(SKJEGG)emu/hostplat.c $(SKJEGG)emu/sched.c $(SKJEGG)fs/p9_server.c'
    # Extra flags: the per-core gdb stubs (--gdb PORT) and the DWARF backtrace.
    _emu_flags=""
    if [ "$has_emu_cf" -eq 1 ]; then
        _emu_src="$_emu_src \$(SKJEGG)emu/coldfire.c \$(SKJEGG)emu/cf_user.c"
    fi
    if [ "$has_emu_rv" -eq 1 ]; then
        _emu_src="$_emu_src \$(SKJEGG)emu/rv32.c \$(SKJEGG)emu/rv_user.c \$(SKJEGG)emu/rv_gdb.c"
        _emu_flags="$_emu_flags -DSKJ_RV_GDB"
    fi
    if [ "$has_emu_mips" -eq 1 ]; then
        _emu_src="$_emu_src \$(SKJEGG)emu/mips32.c \$(SKJEGG)emu/mips_user.c \$(SKJEGG)emu/mips_gdb.c"
        _emu_flags="$_emu_flags -DSKJ_MIPS_GDB"
    fi
    # The HV core is one shared body plus the gdb stub; the VMM backend itself
    # is picked by host OS below, since it cannot be chosen at vendoring time.
    if [ "$has_emu_hv" -eq 1 ]; then
        _emu_src="$_emu_src \$(SKJEGG)emu/hvcore.c \$(SKJEGG)emu/hv_gdb.c"
        _emu_flags="$_emu_flags -DSKJ_HV_GDB"
    fi
    # The symbolized fault backtrace on the emulated cores: the DWARF reader plus
    # the arena it uses, and the flag that turns the code on in *_user.c.
    if [ "$has_emu_cf" -eq 1 ] || [ "$has_emu_rv" -eq 1 ] || [ "$has_emu_mips" -eq 1 ]; then
        _emu_src="$_emu_src \$(SKJEGG)dwarf/dwread.c \$(SKJEGG)ir/arena.c"
        _emu_flags="$_emu_flags -DSKJ_DWARF_BACKTRACE -I\$(SKJEGG)dwarf -I\$(SKJEGG)ir"
    fi
    {
        printf '\n# skj-run: the guest runner.  The architectures compiled in\n'
        printf '# are fixed at vendoring time; skj-run reads the ELF header to\n'
        printf '# pick between them.\n'
        printf 'SKJ_EMU := %s\n' "$_emu_src"
        printf 'SKJ_EMU_LDLIBS :=\n'
        if [ "$has_emu_hv" -eq 1 ]; then
            printf '# The VMM backend is picked by host OS, not at vendoring time:\n'
            printf '# macOS uses Hypervisor.framework, every other host Linux KVM.\n'
            printf '# Each carries a stub for a host without its hypervisor.\n'
            printf 'ifeq ($(shell uname -s),Darwin)\n'
            printf 'SKJ_EMU += $(SKJEGG)emu/vmm_hvf.c\n'
            printf 'SKJ_EMU_LDLIBS := -framework Hypervisor\n'
            printf 'else\n'
            printf 'SKJ_EMU += $(SKJEGG)emu/vmm_kvm.c\n'
            printf '# The KVM backend drives a per-vcpu preemption timer\n'
            printf '# (timer_create) and uses pthread_sigmask: link pthread and\n'
            printf '# rt (both empty on glibc 2.34+).\n'
            printf 'SKJ_EMU_LDLIBS := -lpthread -lrt\n'
            printf 'endif\n'
        fi
        printf 'SKJ_ALL += $(BUILD)/skj-run\n'
        printf '$(BUILD)/skj-run: $(SKJ_EMU) | $(BUILD)\n'
        printf '\t$(CC) $(CFLAGS) -DEMU_COLDFIRE=%s -DEMU_RV32=%s -DEMU_MIPS32=%s -DEMU_HV=%s%s -I$(SKJEGG)emu -I$(SKJEGG)fs -o $@ $(SKJ_EMU) -lm $(SKJ_EMU_LDLIBS)\n' \
            "$has_emu_cf" "$has_emu_rv" "$has_emu_mips" "$has_emu_hv" "$_emu_flags"
    } >> "$MK"
fi

# The vDSO image, one per emulated core whose skj toolchain is also vendored.
# vdso.c compiles to the image linked at a fixed guest VA; skj-run injects it
# with --vdso.  A rule is emitted only when the core (emu-*) and its cc/as/ld
# are all present, since the image is built with the target's own toolchain.
# emit_vdso <tag> <cc> <as> <ld> <ldscript>
emit_vdso() {
    _vt=$1 _vcc=$2 _vas=$3 _vld=$4 _vlds=$5
    {
        printf '\nSKJ_VDSO += $(BUILD)/vdso-%s.elf\n' "$_vt"
        printf 'SKJ_ALL += $(BUILD)/vdso-%s.elf\n' "$_vt"
        printf '$(BUILD)/vdso-%s.o: $(SKJEGG)runtime/vdso.c $(SKJEGG)include/skj_vdso.h $(BUILD)/%s $(BUILD)/%s | $(BUILD)\n' \
            "$_vt" "$_vcc" "$_vas"
        printf '\t$(BUILD)/%s -I$(SKJEGG)include -o $(BUILD)/vdso-%s.s $(SKJEGG)runtime/vdso.c\n' "$_vcc" "$_vt"
        printf '\t$(BUILD)/%s -o $@ $(BUILD)/vdso-%s.s\n' "$_vas" "$_vt"
        printf '$(BUILD)/vdso-%s.elf: $(BUILD)/vdso-%s.o $(SKJEGG)runtime/%s $(BUILD)/%s\n' \
            "$_vt" "$_vt" "$_vlds" "$_vld"
        printf '\t$(BUILD)/%s -T $(SKJEGG)runtime/%s -o $@ $(BUILD)/vdso-%s.o\n' "$_vld" "$_vlds" "$_vt"
    } >> "$MK"
}
if [ "$has_emu_cf" -eq 1 ] && [ "$has_cc" -eq 1 ] && [ "$has_cf" -eq 1 ] && \
   [ "$has_as" -eq 1 ] && [ "$has_ld" -eq 1 ]; then
    emit_vdso cf skj-cc skj-as skj-ld vdso_cf.ld
fi
if [ "$has_emu_rv" -eq 1 ] && [ "$has_cc" -eq 1 ] && [ "$has_rv" -eq 1 ] && \
   [ "$has_as_rv" -eq 1 ] && [ "$has_ld_rv" -eq 1 ]; then
    emit_vdso rv skj-cc-rv skj-as-rv skj-ld-rv vdso_rv.ld
fi
if [ "$has_emu_mips" -eq 1 ] && [ "$has_cc" -eq 1 ] && [ "$has_mips" -eq 1 ] && \
   [ "$has_as_mips" -eq 1 ] && [ "$has_ld_mips" -eq 1 ]; then
    emit_vdso mips skj-cc-mips skj-as-mips skj-ld-mips vdso_mips.ld
fi

# cross-compiled runtime objects
if [ "$has_cf" -eq 1 ]; then
    # start.S .includes crt_entry_cf.S and syscall_cf.S (bare names), resolved
    # through -I<staged runtime>.
    {
        printf '\n$(BUILD)/start.o: $(SKJEGG)runtime/start.S $(SKJEGG)runtime/crt_entry_cf.S $(SKJEGG)runtime/syscall_cf.S | $(BUILD)\n'
        printf '\t$(M68K_AS) -I$(SKJEGG)runtime -o $@ $(SKJEGG)runtime/start.S\n'
    } >> "$MK"
fi
if [ "$has_rv" -eq 1 ]; then
    # start_rv.S .includes crt_entry_rv.S and syscall_rv.S (bare) plus
    # runtime/i64_rv.S (runtime/-prefixed), so both -I$(SKJEGG) (for the
    # prefixed form) and -I$(SKJEGG)runtime (for the bare ones) are needed.
    {
        printf '\n$(BUILD)/start_rv.o: $(SKJEGG)runtime/start_rv.S $(SKJEGG)runtime/crt_entry_rv.S $(SKJEGG)runtime/syscall_rv.S $(SKJEGG)runtime/i64_rv.S | $(BUILD)\n'
        printf '\t$(RV_AS) -I$(SKJEGG) -I$(SKJEGG)runtime -march=rv32im -mabi=ilp32 -o $@ $(SKJEGG)runtime/start_rv.S\n'
    } >> "$MK"
fi
if [ "$has_pascal" -eq 1 ] && [ "$has_cf" -eq 1 ]; then
    {
        printf '\n$(BUILD)/pascal_rt.o: $(SKJEGG)runtime/pascal_rt.c | $(BUILD)\n'
        printf '\t$(M68K_CC) -std=c99 -O2 -Wall -ffreestanding -c -o $@ $<\n'
    } >> "$MK"
fi
if [ "$has_moo" -eq 1 ] && [ "$has_cf" -eq 1 ]; then
    {
        printf '\n$(BUILD)/str.o: $(SKJEGG)runtime/str.c | $(BUILD)\n'
        printf '\t$(M68K_CC) -std=c99 -O2 -Wall -ffreestanding -c -o $@ $<\n'
        printf '\n$(BUILD)/list.o: $(SKJEGG)runtime/list.c | $(BUILD)\n'
        printf '\t$(M68K_CC) -std=c99 -O2 -Wall -ffreestanding -c -o $@ $<\n'
        printf '\n$(BUILD)/host_stub.o: $(SKJEGG)runtime/host_stub.c | $(BUILD)\n'
        printf '\t$(M68K_CC) -std=c99 -O2 -Wall -ffreestanding -c -o $@ $<\n'
        printf '\n$(BUILD)/toy_host.o: $(SKJEGG)runtime/toy_host.c | $(BUILD)\n'
        printf '\t$(M68K_CC) -std=c99 -O2 -Wall -ffreestanding -c -o $@ $<\n'
    } >> "$MK"
fi
# The cc varargs runtime helper (__va_arg), linked when a cc program uses
# <stdarg.h>.  One per backend ABI; the object name matches the in-tree build.
if [ "$has_cc" -eq 1 ] && [ "$has_cf" -eq 1 ]; then
    {
        printf '\n$(BUILD)/va_cf.o: $(SKJEGG)runtime/va_cf.c | $(BUILD)\n'
        printf '\t$(M68K_CC) -std=c99 -O2 -Wall -ffreestanding -c -o $@ $<\n'
    } >> "$MK"
fi
if [ "$has_cc" -eq 1 ] && [ "$has_rv" -eq 1 ]; then
    {
        printf '\n$(BUILD)/va_rv.o: $(SKJEGG)runtime/va_rv.c | $(BUILD)\n'
        printf '\t$(RV_CC) -std=c99 -O2 -Wall -ffreestanding -march=rv32imfd -mabi=ilp32 -c -o $@ $<\n'
    } >> "$MK"
fi
if [ "$has_cc" -eq 1 ] && [ "$has_mips" -eq 1 ]; then
    {
        printf '\n$(BUILD)/va_mips.o: $(SKJEGG)runtime/va_mips.c | $(BUILD)\n'
        printf '\t$(MIPS_CC) -march=mips1 -EL -G 0 -std=c99 -O2 -Wall -ffreestanding -c -o $@ $<\n'
    } >> "$MK"
fi

# The _Float16 helper (half.c) and the MIPS crt the cross driver links.  half.o
# is linked for ColdFire and MIPS cc programs (IR_FLH/FSH lower to these calls,
# no hardware _Float16); start_mips.o is the MIPS Linux crt, GNU-assembled like
# the RISC-V and ColdFire crts above (skj-ld-mips reads GNU objects).
if [ "$drv_cf" -eq 1 ]; then
    {
        printf '\n$(BUILD)/half.o: $(SKJEGG)runtime/half.c | $(BUILD)\n'
        printf '\t$(M68K_CC) -std=c99 -O2 -Wall -ffreestanding -c -o $@ $<\n'
    } >> "$MK"
fi
if [ "$drv_mips" -eq 1 ]; then
    {
        printf '\n$(BUILD)/start_mips.o: $(SKJEGG)runtime/start_mips.S | $(BUILD)\n'
        printf '\t$(MIPS_AS) -march=mips1 -EL -o $@ $<\n'
        printf '\n$(BUILD)/half_mips.o: $(SKJEGG)runtime/half.c | $(BUILD)\n'
        printf '\t$(MIPS_CC) -march=mips1 -EL -G 0 -std=c99 -O2 -Wall -ffreestanding -c -o $@ $<\n'
    } >> "$MK"
fi

# version header, phony and directory targets
cat >> "$MK" <<'MK'

# Every tool's main.c includes "version.h", so generate it from the release
# number plus the commit this tree was vendored from.
$(BUILD)/version.h: $(SKJEGG)version.mk $(SKJEGG)skjegg.mk | $(BUILD)
	@printf '#ifndef SKJ_VERSION_H\n#define SKJ_VERSION_H\n#define SKJ_VERSION "%s"\n#endif\n' '$(SKJ_FULL_VERSION)' > $@

$(SKJ_ALL): $(BUILD)/version.h

skjegg: $(SKJ_ALL)
.PHONY: skjegg

$(BUILD):
	mkdir -p $@
MK

# ---- summary ----

printf '\nVendored into %s/ (%s)\n' "$DEST" "$commit"
printf 'Components: %s\n' "$COMPONENTS"
printf 'Docs:       %s/doc/\n' "$DEST"
printf 'Generated:  %s/skjegg.mk\n' "$DEST"
printf 'Update:     %s/update-skjegg.sh\n' "$_upd_dir"
