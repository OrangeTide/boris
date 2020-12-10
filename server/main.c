/*
 * Copyright (c) 2020 Jon Mayo <jon@rm-f.net>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

#define ERR (-1)
#define OK (0)

////////////////////////////////////////////////////////////////////////
// Main

#include <stdio.h>
#include <errno.h>

#include <unistd.h>

#include "daemonize.h"
#include "server.h"

static int foreground_mode = 1;

static struct server_info *telnet_server, *http_server;

static void
usage(void)
{
	fprintf(stderr, "%s [-h] [-f | -d] [-T <port>] [-H <port>]\n",
		program_invocation_short_name);
}

static int
process_args(int argc, char *argv[])
{
	int telnet_server_added = 0;

	while (1) {
		switch (getopt(argc, argv, "dfhH:T:")) {
		case -1:
			// apply a default settings.
			if (!telnet_server_added) {
				log_info("%s():result=%d", __func__, OK);
				if (server_add(telnet_server, "127.0.0.1/4000"))
					return ERR;
			}


			return OK;
		case '?':
		case 'h':
			usage();
			return ERR;
		case 'd': /* detached mode (daemon) */
			foreground_mode = 0;
			break;
		case 'f': /* foreground mode */
			foreground_mode = 1;
			break;
		case 'T': // TELNET port
			if (server_add(telnet_server, optarg))
				return ERR;
			telnet_server_added = 1;
			break;
		case 'H': // HTTP port
			// TODO: don't register HTTP listen ports with core network service
			// instead, handle them sequentially with accept()-read_header() threads
			// move parsed headers and connections onto worker threads with epoll system (socket_xxx API)
			if (server_add(http_server, optarg))
				return ERR;

			break;
		}
	}
}

int
main(int argc, char *argv[])
{
	telnet_server = server_new();
	http_server = server_new();

	if (process_args(argc, argv))
		return 1;

	if (!foreground_mode)
		daemonize();

	// TODO: load configuration - but don't override command-line settings

	// TODO: daemonize & drop privileges

	// TODO: load and access the game database
	// TODO: start the auth service thread (or optionally an external auth)

	// TODO: open default listening ports, if none were provided
	// TODO: start socket_loop thread
	// TODO: start web_loop thread
	// TODO: start vm_worker_loop thread

	if (telnet_server)
		server_start(telnet_server);

	if (http_server)
		server_start(http_server);

	// TODO: wait for threads to finish - main becomes a monitor thread

	return 0;
}

/*
 * "Alright you Primitive Screwheads, listen up! You see this? This... is my
 * boomstick! The twelve-gauge double-barreled Remington. S-Mart's top of the
 * line. You can find this in the sporting goods department. That's right, this
 * sweet baby was made in Grand Rapids, Michigan. Retails for about a hundred
 * and nine, ninety five. It's got a walnut stock, cobalt blue steel, and a
 * hair trigger. That's right. Shopsmart. Shop S-Mart. You got that?"
 */
