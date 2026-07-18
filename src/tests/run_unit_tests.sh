#!/bin/sh
# run_unit_tests.sh - run each unit-test binary and total the pass/fail counts.
#
# Usage: run_unit_tests.sh <test-binary> [<test-binary> ...]
#
# Each binary is expected to print a summary line understood by ctest.h:
#     ## CTEST-SUMMARY <suite> pass=<N> fail=<M>
# Binaries without that line are scored by exit status alone (a crash or
# non-zero exit counts as one failed suite).
#
# Exits non-zero if any check failed or any binary did not exit cleanly.

set -u

total_pass=0
total_fail=0
suites=0
bad_suites=0

# color only when writing to a terminal.
if [ -t 1 ]; then
	c_red=$(printf '\033[31m'); c_grn=$(printf '\033[32m')
	c_yel=$(printf '\033[33m'); c_rst=$(printf '\033[0m')
else
	c_red=; c_grn=; c_yel=; c_rst=
fi

for bin in "$@"; do
	name=$(basename "$bin")
	suites=$((suites + 1))

	out=$("$bin" 2>&1)
	rc=$?

	summary=$(printf '%s\n' "$out" | grep '^## CTEST-SUMMARY' | tail -n 1)

	if [ -n "$summary" ]; then
		p=$(printf '%s\n' "$summary" | sed -n 's/.*pass=\([0-9]*\).*/\1/p')
		f=$(printf '%s\n' "$summary" | sed -n 's/.*fail=\([0-9]*\).*/\1/p')
		total_pass=$((total_pass + p))
		total_fail=$((total_fail + f))
		if [ "$f" -eq 0 ] && [ "$rc" -eq 0 ]; then
			printf '%s  %-28s %s%s\n' "${c_grn}PASS${c_rst}" "$name" "$p passed" ""
		else
			bad_suites=$((bad_suites + 1))
			printf '%s  %-28s %s\n' "${c_red}FAIL${c_rst}" "$name" "$p passed, $f failed (exit $rc)"
			printf '%s\n' "$out" | grep -E '^FAIL|expected|  at |  FAIL' | sed 's/^/       /'
		fi
	else
		# no machine-readable summary; judge by exit status only.
		if [ "$rc" -eq 0 ]; then
			total_pass=$((total_pass + 1))
			printf '%s  %-28s %s\n' "${c_grn}PASS${c_rst}" "$name" "(no summary, exit 0)"
		else
			total_fail=$((total_fail + 1))
			bad_suites=$((bad_suites + 1))
			printf '%s  %-28s %s\n' "${c_red}FAIL${c_rst}" "$name" "(no summary, exit $rc)"
			printf '%s\n' "$out" | tail -n 5 | sed 's/^/       /'
		fi
	fi
done

echo "--------------------------------------------------------------"
if [ "$total_fail" -eq 0 ] && [ "$bad_suites" -eq 0 ]; then
	printf '%sTOTAL: %d passed, %d failed across %d suites%s\n' \
		"$c_grn" "$total_pass" "$total_fail" "$suites" "$c_rst"
	exit 0
else
	printf '%sTOTAL: %d passed, %d failed across %d suites (%d suite(s) with failures)%s\n' \
		"$c_yel" "$total_pass" "$total_fail" "$suites" "$bad_suites" "$c_rst"
	exit 1
fi
