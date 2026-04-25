#!/bin/sh

set -e

usage() {
	cat <<-EOF
	Usage: $(basename "$0") [OPTIONS] [-- BORIS_ARGS...]

	Start boris for local development.

	Options:
	  -f        Reset database from sample data before starting
	  -v        Run under valgrind (leak check)
	  -g PORT   Run under gdbserver on PORT (e.g. -g 9999)
	  -h        Show this help

	Daemonization is handled by server.daemonize in boris.cfg.
	EOF
	exit 0
}

FRESH=0
VALGRIND=0
GDBSERVER_PORT=

while getopts "fvg:h" opt; do
	case "$opt" in
		f) FRESH=1 ;;
		v) VALGRIND=1 ;;
		g) GDBSERVER_PORT="$OPTARG" ;;
		h) usage ;;
		*) usage ;;
	esac
done
shift $((OPTIND - 1))

if [ "$VALGRIND" -eq 1 ] && [ -n "$GDBSERVER_PORT" ]; then
	echo "Error: -v and -g are mutually exclusive" >&2
	exit 1
fi

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
PROJECT_DIR=$(cd "$SCRIPT_DIR/.." && pwd)

# load .env (same variables the Makefile reads)
if [ -f "$PROJECT_DIR/.env" ]; then
	while IFS= read -r line || [ -n "$line" ]; do
		case "$line" in
			''|\#*) continue ;;
		esac
		eval "export $line"
	done < "$PROJECT_DIR/.env"
fi

BINDIR=$(cd "$PROJECT_DIR" && make -s show-BINDIR)

if [ ! -d "$BINDIR" ]; then
	echo "Error: BINDIR not found: $BINDIR" >&2
	echo "Run 'make -j' first." >&2
	exit 1
fi

if [ "$FRESH" -eq 1 ]; then
	echo "Importing sample database..."
	"$BINDIR/muddb-tool" import "$PROJECT_DIR/data/muddb" "$PROJECT_DIR/sample/"
fi

WRAPPER=
if [ "$VALGRIND" -eq 1 ]; then
	WRAPPER="valgrind --leak-check=full --track-origins=yes --show-leak-kinds=all"
elif [ -n "$GDBSERVER_PORT" ]; then
	WRAPPER="gdbserver :$GDBSERVER_PORT"
fi

exec $WRAPPER "$BINDIR/boris" "$@"
