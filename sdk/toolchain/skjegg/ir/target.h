/* target.h : one source of truth for the target data model.
 *
 * The pointer-width axis is a single fact, SKJ_LP64 (1 for the 64-bit guests,
 * 0 for the 32-bit ones), and every width fact derives from it here, so no tool
 * re-derives pointer size or re-spells "is this LP64". Before this header the
 * same choice lived in three parallel families (cc's CC_LP64, pascal's PC_LP64,
 * kobold's KP_LP64), plus an X86_BITS==64 proxy in the KPM reader; a mismatch
 * between them read a pointer at the wrong width.
 *
 * Width is NOT an independent opt-in: it DERIVES from the instruction-set
 * selector, so selecting a 64-bit ISA makes the tool LP64 and selecting a
 * 32-bit ISA makes it ILP32. That makes a width mismatch impossible to build:
 * a tool can no longer name the x86-64 backend yet stay ILP32 and then reject
 * the LP64 modules it is handed (the bug that bit skj-kp-jit). A tool may still
 * pass -DSKJ_LP64 explicitly, but a value that contradicts the ISA is a compile
 * error (the checks below).
 *
 * The 64-bit ISAs are x86-64 (X86_BITS==64) and AArch64; the 32-bit ISAs are
 * x86-32 (X86_BITS==32), RISC-V RV32 (CC_RISCV), ColdFire/m68k (CC_M68K), and
 * MIPS (CC_MIPS). AArch64 is named by CC_ARM64 in the cc and Excelsior tools;
 * the tinc/scheme/pascal arm64 tools select it by compiling backend/arm64_emit.c
 * (which asserts LP64 itself) and pass -DSKJ_LP64=1.
 *
 * AArch64 is always LP64 in this tree (there is no ILP32 arm64 build), so the
 * arm64 selector uses a uniform 64-bit integer-register home unconditionally
 * (INT_HOME_X in backend/arm64_select.c) rather than a per-build opt-in. Width
 * there derives from the ISA selector (CC_ARM64) like every other target.
 */

#ifndef SKJ_TARGET_H
#define SKJ_TARGET_H

/* Derive the width from the instruction-set selector (unless a tool set it
   explicitly). A 64-bit ISA is LP64; everything else is ILP32. */
#ifndef SKJ_LP64
#  if (defined(X86_BITS) && (X86_BITS == 64)) || defined(CC_ARM64)
#    define SKJ_LP64 1
#  else
#    define SKJ_LP64 0
#  endif
#endif

/* An explicit (or derived) width must not contradict the ISA selector, so a
   wrong -DSKJ_LP64 fails the build instead of silently reading pointers at the
   wrong width. The arm64 emitter front ends (tinc/scheme/pascal) carry no ISA
   macro here; backend/arm64_emit.c asserts LP64 for them. */
#if defined(X86_BITS) && (X86_BITS == 64) && !SKJ_LP64
#  error "x86-64 target must be LP64: an ILP32 x86-64 tool would reject LP64 modules"
#endif
#if defined(X86_BITS) && (X86_BITS == 32) && SKJ_LP64
#  error "x86-32 target must be ILP32, not LP64"
#endif
#if defined(CC_ARM64) && !SKJ_LP64
#  error "arm64 target must be LP64"
#endif
#if (defined(CC_RISCV) || defined(CC_M68K) || defined(CC_MIPS)) && SKJ_LP64
#  error "RV32/ColdFire/MIPS target must be ILP32, not LP64"
#endif

#if SKJ_LP64
#define SKJ_PTR_BYTES  8
#define SKJ_LONG_BYTES 8
#else
#define SKJ_PTR_BYTES  4
#define SKJ_LONG_BYTES 4
#endif

/* The KPM pointer-width class a backend emits and accepts (see kobold/kpm.c):
   the 64-bit guests are "lp64", the 32-bit ones "ilp32". */
#define SKJ_KPM_TARGET (SKJ_LP64 ? "lp64" : "ilp32")

/* The target ARCHITECTURE a backend emits and accepts unit modules for. Unlike
   the width class above, this binds a unit to one ISA/ABI: a Kobold unit carries
   native-code assumptions beyond pointer width, so an rv32 unit is not valid for
   ColdFire even though both are ilp32. One backend per target (Plan 9 style), so
   the build passes SKJ_KPM_ARCH per binary; this is a best-effort fallback from
   the ISA selectors for any tool that does not set it explicitly. */
#ifndef SKJ_KPM_ARCH
#  if defined(X86_BITS) && (X86_BITS == 64)
#    define SKJ_KPM_ARCH "x86-64"
#  elif defined(X86_BITS) && (X86_BITS == 32)
#    define SKJ_KPM_ARCH "x86-32"
#  elif defined(CC_ARM64)
#    define SKJ_KPM_ARCH "arm64"
#  elif defined(KP_AOT_RV) || defined(CC_RISCV)
#    define SKJ_KPM_ARCH "rv32"
#  elif defined(CC_MIPS)
#    define SKJ_KPM_ARCH "mips"
#  elif defined(CC_M68K)
#    define SKJ_KPM_ARCH "cf"
#  elif SKJ_LP64
#    define SKJ_KPM_ARCH "arm64"   /* an LP64 kobold tool with no X86_BITS is the arm64 backend */
#  else
#    define SKJ_KPM_ARCH "ilp32"   /* unknown 32-bit ISA: a width string, never matches an arch tag */
#  endif
#endif

#endif /* SKJ_TARGET_H */
