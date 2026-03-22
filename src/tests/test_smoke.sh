#!/bin/bash
# test_smoke.sh : smoke test harness for boris server
#
# Starts the server on a temporary port, exercises basic telnet
# functionality via expect, then shuts down and reports results.

set -u

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
BORIS="$PROJECT_DIR/bin/boris"
SMOKE_EXP="$SCRIPT_DIR/smoke.exp"

PORT=4445
PASS=0
FAIL=0
TOTAL=0
TMPDIR=""
SERVER_PID=""

cleanup()
{
	if [ -n "$SERVER_PID" ] && kill -0 "$SERVER_PID" 2>/dev/null; then
		kill "$SERVER_PID" 2>/dev/null
		wait "$SERVER_PID" 2>/dev/null
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

	if [ ! -f "$SMOKE_EXP" ]; then
		die "expect script not found at $SMOKE_EXP"
	fi
}

setup_testenv()
{
	TMPDIR="$(mktemp -d /tmp/boris-smoke.XXXXXX)"

	# copy data files the server needs
	cp -a "$PROJECT_DIR/data" "$TMPDIR/data"

	# create muddb directory for LMDB
	mkdir -p "$TMPDIR/data/muddb"

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
	"$BORIS" >"$TMPDIR/server.log" 2>&1 &
	SERVER_PID=$!
	cd "$PROJECT_DIR"

	# wait for server to start listening
	local tries=0
	while ! nc -z 127.0.0.1 "$PORT" 2>/dev/null; do
		tries=$((tries + 1))
		if [ $tries -ge 50 ]; then
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

echo "%%%%%%%%%%%% END-TEST : $PASS passed, $FAIL failed (of $TOTAL)"

if [ "$FAIL" -gt 0 ]; then
	echo "--- server log (last 50 lines) ---"
	tail -50 "$TMPDIR/server.log" 2>/dev/null
	exit 1
fi
exit 0
