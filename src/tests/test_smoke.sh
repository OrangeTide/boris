#!/bin/bash
# test_smoke.sh : smoke test harness for boris server
#
# Starts the server on a temporary port, exercises basic telnet
# functionality via expect, then shuts down and reports results.

set -u

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
BORIS="$PROJECT_DIR/bin/boris"
MUDDB_TOOL="$PROJECT_DIR/bin/muddb-tool"
SMOKE_EXP="$SCRIPT_DIR/smoke.exp"

PORT=4445
PASS=0
FAIL=0
TOTAL=0
TMPDIR=""
SERVER_PID=""
USE_VALGRIND="${USE_VALGRIND:-0}"
VALGRIND_EXIT=0

cleanup()
{
	if [ -n "$SERVER_PID" ] && kill -0 "$SERVER_PID" 2>/dev/null; then
		kill "$SERVER_PID" 2>/dev/null
		wait "$SERVER_PID" 2>/dev/null
		local server_rc=$?
		if [ "$USE_VALGRIND" = "1" ] && [ "$server_rc" -eq 99 ]; then
			VALGRIND_EXIT=1
		fi
	fi
	if [ "$USE_VALGRIND" = "1" ] && [ -f "$TMPDIR/valgrind.log" ]; then
		echo ""
		echo "--- valgrind summary ---"
		# show the summary block (everything from ERROR SUMMARY onward)
		grep -A5 "ERROR SUMMARY" "$TMPDIR/valgrind.log" || true
		if [ "$VALGRIND_EXIT" -ne 0 ]; then
			echo ""
			echo "--- full valgrind log ---"
			cat "$TMPDIR/valgrind.log"
		fi
	fi
	if [ -n "$TMPDIR" ] && [ -d "$TMPDIR" ]; then
		rm -rf "$TMPDIR"
	fi
}

trap cleanup EXIT

die()
{
	echo "FATAL: $1" >&2
	exit 1
}

check_prereqs()
{
	if ! command -v expect >/dev/null 2>&1; then
		die "expect not found -- install with: apt install expect"
	fi

	if [ ! -x "$BORIS" ]; then
		die "server binary not found at $BORIS -- run 'make' first"
	fi

	if [ ! -x "$MUDDB_TOOL" ]; then
		die "muddb-tool not found at $MUDDB_TOOL -- run 'make' first"
	fi

	if [ ! -f "$SMOKE_EXP" ]; then
		die "expect script not found at $SMOKE_EXP"
	fi

	if [ "$USE_VALGRIND" = "1" ] && ! command -v valgrind >/dev/null 2>&1; then
		die "valgrind not found -- install with: apt install valgrind"
	fi
}

setup_testenv()
{
	TMPDIR="$(mktemp -d /tmp/boris-smoke.XXXXXX)"

	# copy data files the server needs
	cp -a "$PROJECT_DIR/data" "$TMPDIR/data"

	# initialize muddb with sample world data
	mkdir -p "$TMPDIR/data/muddb"
	"$MUDDB_TOOL" import "$TMPDIR/data/muddb" "$PROJECT_DIR/sample/" >/dev/null 2>&1

	# write a test config with our port
	cat > "$TMPDIR/boris.cfg" <<-EOF
	server.name	=	SMOKETEST
	server.port	=	$PORT
	prompt.menu	=	Choose:
	prompt.form	=	Pick:
	msg.unsupported	=	Not supported!
	msg.invalidselection	=	Invalid selection!
	msgfile.noaccount	=	data/text/invalidlogin.txt
	msgfile.badpassword	=	data/text/invalidlogin.txt
	msg.invalidusername	=	Invalid username!
	msg.invalidcommand	=	Invalid command!
	msg.tryagain	=	Try again!
	msg.errormain	=	ERROR: going back to main menu!
	msg.usermin3	=	Username must contain at least 3 characters!
	msg.useralphanumeric	=	Username must only contain alphanumeric characters and must start with a letter!
	msg.userexists	=	Username already exists!
	msg.usercreatesuccess	=	Account successfully created!
	msgfile.welcome	=	data/text/welcome.txt
	newuser.level	=	5
	newuser.flags	=	0x2
	newuser.allowed	=	1
	eventlog.filename	=	boris.log
	eventlog.timeformat	=	%y%m%d-%H%M
	channels.default	=	@system,@wiz,OOC,auction,chat,newbie
	webserver.port	=	0
	form.newuser.filename	=	data/forms/newuser.form
	EOF
}

start_server()
{
	cd "$TMPDIR"
	if [ "$USE_VALGRIND" = "1" ]; then
		valgrind \
			--leak-check=full \
			--show-leak-kinds=all \
			--track-origins=yes \
			--error-exitcode=99 \
			--log-file="$TMPDIR/valgrind.log" \
			"$BORIS" >"$TMPDIR/server.log" 2>&1 &
	else
		"$BORIS" >"$TMPDIR/server.log" 2>&1 &
	fi
	SERVER_PID=$!
	cd "$PROJECT_DIR"

	# wait for server to start listening (valgrind is slower)
	local max_tries=50
	if [ "$USE_VALGRIND" = "1" ]; then
		max_tries=150
	fi
	local tries=0
	while ! nc -z 127.0.0.1 "$PORT" 2>/dev/null; do
		tries=$((tries + 1))
		if [ $tries -ge $max_tries ]; then
			die "server did not start listening on port $PORT"
		fi
		if ! kill -0 "$SERVER_PID" 2>/dev/null; then
			die "server process exited prematurely"
		fi
		sleep 0.1
	done
}

run_test()
{
	local name="$1"
	local result

	TOTAL=$((TOTAL + 1))
	result="$(expect "$SMOKE_EXP" "$PORT" "$name" 2>&1)"

	if echo "$result" | grep -q "^PASS:"; then
		echo "$result"
		PASS=$((PASS + 1))
	else
		echo "$result"
		FAIL=$((FAIL + 1))
	fi
}

# --- main ---

echo "%%%%%%%%%%%% START-TEST : smoke"

check_prereqs
setup_testenv
start_server

run_test menu_quit
run_test bad_login
run_test new_user
run_test enter_game
run_test charset_command

echo "%%%%%%%%%%%% END-TEST : $PASS passed, $FAIL failed (of $TOTAL)"

if [ "$FAIL" -gt 0 ]; then
	echo "--- server log (last 50 lines) ---"
	tail -50 "$TMPDIR/server.log" 2>/dev/null
	exit 1
fi

# cleanup runs in the EXIT trap, which checks valgrind results
exit 0
