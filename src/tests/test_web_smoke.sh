#!/bin/bash
# test_web_smoke.sh : smoke test for web login and invite code system
#
# Starts the server on temporary ports, exercises the SSE/web login
# flow via curl, then shuts down and reports results.
#
# Made by a machine. PUBLIC DOMAIN (CC0-1.0)

set -u

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
BORIS="$PROJECT_DIR/bin/boris"
MUDDB_TOOL="$PROJECT_DIR/bin/muddb-tool"

TELNET_PORT=14445
WEB_PORT=18081
PASS=0
FAIL=0
TOTAL=0
TMPDIR=""
SERVER_PID=""
SSE_PID=""

cleanup()
{
    if [ -n "$SSE_PID" ] && kill -0 "$SSE_PID" 2>/dev/null; then
        kill "$SSE_PID" 2>/dev/null
        wait "$SSE_PID" 2>/dev/null
    fi
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

pass()
{
    TOTAL=$((TOTAL + 1))
    PASS=$((PASS + 1))
    echo "ok   $1"
}

fail()
{
    TOTAL=$((TOTAL + 1))
    FAIL=$((FAIL + 1))
    echo "FAIL $1"
}

check_prereqs()
{
    if ! command -v curl >/dev/null 2>&1; then
        die "curl not found"
    fi

    if [ ! -x "$BORIS" ]; then
        die "server binary not found at $BORIS -- run 'make install' first"
    fi

    if [ ! -x "$MUDDB_TOOL" ]; then
        die "muddb-tool not found at $MUDDB_TOOL -- run 'make install' first"
    fi
}

setup_testenv()
{
    TMPDIR="$(mktemp -d /tmp/boris-web-smoke.XXXXXX)"

    cp -a "$PROJECT_DIR/data" "$TMPDIR/data"
    mkdir -p "$TMPDIR/bin"
    cp -a "$PROJECT_DIR/bin/www" "$TMPDIR/bin/www"

    mkdir -p "$TMPDIR/data/muddb"
    "$MUDDB_TOOL" import "$TMPDIR/data/muddb" "$PROJECT_DIR/sample/" >/dev/null 2>&1

    cat > "$TMPDIR/boris.cfg" <<-EOF
	server.name	=	WEBSMOKE
	server.port	=	$TELNET_PORT
	webserver.port	=	$WEB_PORT
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
	msg.usermin3	=	min 3 chars!
	msg.useralphanumeric	=	alphanumeric only!
	msg.userexists	=	Username already exists!
	msg.usercreatesuccess	=	Account successfully created!
	msgfile.welcome	=	data/text/welcome.txt
	newuser.level	=	5
	newuser.flags	=	0x2
	newuser.allowed	=	1
	eventlog.filename	=	boris.log
	eventlog.timeformat	=	%y%m%d-%H%M
	channels.default	=	@system,chat
	form.newuser.filename	=	data/forms/newuser.form
	security.landlock	=	0
	security.seccomp	=	0
	EOF
}

start_server()
{
    cd "$TMPDIR"
    "$BORIS" >"$TMPDIR/server.log" 2>&1 &
    SERVER_PID=$!
    cd "$PROJECT_DIR"

    local tries=0
    while ! curl -s -o /dev/null "http://127.0.0.1:$WEB_PORT/" 2>/dev/null; do
        tries=$((tries + 1))
        if [ $tries -ge 50 ]; then
            echo "--- server log ---"
            cat "$TMPDIR/server.log" >&2
            die "server did not start listening on port $WEB_PORT"
        fi
        if ! kill -0 "$SERVER_PID" 2>/dev/null; then
            echo "--- server log ---"
            cat "$TMPDIR/server.log" >&2
            die "server process exited prematurely"
        fi
        sleep 0.1
    done
}

# Open a persistent SSE connection. Sets SSE_FILE and SID.
open_sse()
{
    SSE_FILE="$TMPDIR/sse-$$.txt"
    > "$SSE_FILE"
    curl -s -N "http://127.0.0.1:$WEB_PORT/events" > "$SSE_FILE" 2>/dev/null &
    SSE_PID=$!

    local tries=0
    while [ ! -s "$SSE_FILE" ]; do
        tries=$((tries + 1))
        if [ $tries -ge 30 ]; then
            die "SSE connection did not produce output"
        fi
        sleep 0.1
    done

    SID="$(head -1 "$SSE_FILE" | sed 's/^data: I//')"
    if [ -z "$SID" ]; then
        die "could not extract session ID from SSE stream"
    fi
}

close_sse()
{
    if [ -n "$SSE_PID" ] && kill -0 "$SSE_PID" 2>/dev/null; then
        kill "$SSE_PID" 2>/dev/null
        wait "$SSE_PID" 2>/dev/null
    fi
    SSE_PID=""
}

send_cmd()
{
    curl -s -X POST -d "${SID} $1" "http://127.0.0.1:$WEB_PORT/cmd"
}

# Wait for a pattern to appear in the SSE output.
# Returns 0 on match, 1 on timeout.
wait_sse()
{
    local pattern="$1"
    local max="${2:-30}"
    local tries=0
    while ! grep -q "$pattern" "$SSE_FILE" 2>/dev/null; do
        tries=$((tries + 1))
        if [ $tries -ge "$max" ]; then
            return 1
        fi
        sleep 0.1
    done
    return 0
}

# --- tests ---

test_page_serves()
{
    local status
    status="$(curl -s -o /dev/null -w "%{http_code}" "http://127.0.0.1:$WEB_PORT/")"
    if [ "$status" = "200" ]; then
        pass "page serves index.html"
    else
        fail "page serves index.html (got HTTP $status)"
    fi
}

test_invite_route()
{
    local status
    status="$(curl -s -o /dev/null -w "%{http_code}" "http://127.0.0.1:$WEB_PORT/invite/ABCD-EFGH-IJKL")"
    if [ "$status" = "200" ]; then
        pass "invite route serves index.html"
    else
        fail "invite route serves index.html (got HTTP $status)"
    fi
}

test_sse_session()
{
    open_sse
    if [ -n "$SID" ] && [ ${#SID} -ge 16 ]; then
        pass "SSE connection returns session ID"
    else
        fail "SSE connection returns session ID (got '$SID')"
    fi
    close_sse
}

test_bad_login()
{
    open_sse

    send_cmd "connect nosuchuser wrongpass" >/dev/null
    if wait_sse '!Invalid'; then
        pass "bad login returns error"
    else
        fail "bad login returns error"
    fi

    close_sse
}

test_bad_command()
{
    open_sse

    send_cmd "foobar whatever" >/dev/null
    if wait_sse "!Use 'connect"; then
        pass "unknown pre-login command returns usage hint"
    else
        fail "unknown pre-login command returns usage hint"
    fi

    close_sse
}

test_create_account()
{
    open_sse

    send_cmd "create websmoke testpass99" >/dev/null
    if wait_sse '^data: +'; then
        pass "create account succeeds"
    else
        fail "create account succeeds"
        close_sse
        return
    fi

    close_sse
}

test_login()
{
    open_sse

    send_cmd "connect websmoke testpass99" >/dev/null
    if wait_sse '^data: +'; then
        pass "login with created account"
    else
        fail "login with created account"
        close_sse
        return
    fi

    close_sse
}

test_game_command()
{
    open_sse
    send_cmd "connect websmoke testpass99" >/dev/null
    wait_sse '^data: +' || { fail "game command: login failed"; close_sse; return; }

    send_cmd "look" >/dev/null
    if wait_sse 'Tower Entrance'; then
        pass "game command produces output"
    else
        fail "game command produces output"
    fi

    close_sse
}

test_no_password_echo()
{
    open_sse
    send_cmd "connect websmoke testpass99" >/dev/null
    wait_sse '^data: +' || { fail "no password echo: login failed"; close_sse; return; }

    if grep -q 'testpass99' "$SSE_FILE"; then
        fail "password echoed in SSE stream"
    else
        pass "password not echoed in SSE stream"
    fi

    close_sse
}

test_create_duplicate()
{
    open_sse

    send_cmd "create websmoke anotherpass" >/dev/null
    if wait_sse '!That name is already taken'; then
        pass "duplicate account rejected"
    else
        fail "duplicate account rejected"
    fi

    close_sse
}

test_create_bad_name()
{
    open_sse

    send_cmd "create x pw1234" >/dev/null
    if wait_sse '!Name must be'; then
        pass "short name rejected"
    else
        fail "short name rejected"
    fi

    close_sse
}

test_create_short_password()
{
    open_sse

    send_cmd "create goodname ab" >/dev/null
    if wait_sse '!Password must be'; then
        pass "short password rejected"
    else
        fail "short password rejected"
    fi

    close_sse
}

test_clean_shutdown()
{
    # open several SSE connections, one with an active login
    local sse_pids=""
    local sse_files=""

    for i in 1 2 3; do
        local f="$TMPDIR/sse-shutdown-$i.txt"
        > "$f"
        curl -s -N "http://127.0.0.1:$WEB_PORT/events" > "$f" 2>/dev/null &
        sse_pids="$sse_pids $!"
        sse_files="$sse_files $f"
    done

    # wait for all connections to get session IDs
    sleep 0.5

    # log in on the first connection
    local sid
    sid="$(head -1 "$TMPDIR/sse-shutdown-1.txt" | sed 's/^data: I//')"
    if [ -n "$sid" ]; then
        curl -s -X POST -d "${sid} connect websmoke testpass99" \
            "http://127.0.0.1:$WEB_PORT/cmd" >/dev/null
        sleep 0.3
    fi

    # send SIGINT -- same as Ctrl-C
    kill -INT "$SERVER_PID" 2>/dev/null
    wait "$SERVER_PID" 2>/dev/null
    local rc=$?

    # clean up background curl processes
    for p in $sse_pids; do
        kill "$p" 2>/dev/null
        wait "$p" 2>/dev/null
    done

    # 130 = killed by SIGINT (128+2), 0 = clean exit
    if [ "$rc" -eq 0 ] || [ "$rc" -eq 130 ]; then
        pass "clean shutdown with active web clients (exit=$rc)"
    else
        fail "clean shutdown with active web clients (exit=$rc)"
    fi

    # server is already gone; prevent cleanup() from trying to kill it
    SERVER_PID=""
}

# --- main ---

echo "%%%%%%%%%%%% START-TEST : web-smoke"

check_prereqs
setup_testenv
start_server

test_page_serves
test_invite_route
test_sse_session
test_bad_login
test_bad_command
test_create_account
test_login
test_game_command
test_no_password_echo
test_create_duplicate
test_create_bad_name
test_create_short_password
test_clean_shutdown

echo "%%%%%%%%%%%% END-TEST : $PASS passed, $FAIL failed (of $TOTAL)"

if [ "$FAIL" -gt 0 ]; then
    echo "--- server log (last 50 lines) ---"
    tail -50 "$TMPDIR/server.log" 2>/dev/null
    exit 1
fi

exit 0
