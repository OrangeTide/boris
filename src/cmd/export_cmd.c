/* export_cmd.c : @export -- in-game world JSON dump (world-backup-commands) */
/* PUBLIC DOMAIN (CC0-1.0) or MIT-0 -- See LICENSE for details. */

#include "command.h"
#include <boris.h>
#include "util.h"
#include "user.h"
#include "acs.h"
#include "obj.h"
#include "muddb_export.h"

#include <stdio.h>
#include <string.h>
#include <time.h>

#define EXPORT_MAX_DOMAINS 8

/* report one domain's record count to the player (muddb_export callback) */
static void
export_report(const char *domain, int count, void *ctx)
{
	DESCRIPTOR_DATA *cl = ctx;

	telnetclient_printf(cl, "  %s: %d objects\n", domain, count);
}

/*
 * @export [<domain> ...] -- dump the live world to a timestamped directory
 * under data/export/ in the muddb-tool JSON-record format (one .json per
 * object). Wizard-only: it writes to the server filesystem and reads every
 * domain. With no argument it exports the well-known domains (users, objs,
 * chars); otherwise only the named ones.
 */
int
command_do_export(DESCRIPTOR_DATA *cl, struct user *u UNUSED,
	const char *cmd UNUSED, const char *arg)
{
	const struct acs_info *acs = user_acs(telnetclient_user(cl));
	char dombuf[EXPORT_MAX_DOMAINS][64];
	const char *domains[EXPORT_MAX_DOMAINS];
	char outdir[256], when[32];
	size_t ndom = 0;
	struct muddb *db;
	time_t now;
	struct tm *tmv;

	if (!acs || !acs_check((struct acs_info *)acs, "fW")) {
		telnetclient_puts(cl, "Only wizards may export the world.\n");
		return 0;
	}
	db = obj_db();
	if (!db) {
		telnetclient_puts(cl, "The object store is not available.\n");
		return 0;
	}

	/* optional explicit domain list */
	while (ndom < EXPORT_MAX_DOMAINS && arg && *arg) {
		arg = util_getword(arg, dombuf[ndom], sizeof dombuf[ndom]);
		if (!dombuf[ndom][0])
			break;
		domains[ndom] = dombuf[ndom];
		ndom++;
	}

	/* flush dirty cached objects so the dump reflects live edits */
	obj_sync();

	now = time(NULL);
	tmv = localtime(&now);
	if (tmv)
		strftime(when, sizeof when, "%Y%m%d-%H%M%S", tmv);
	else
		snprintf(when, sizeof when, "%ld", (long)now);
	if ((size_t)snprintf(outdir, sizeof outdir, "data/export/%s", when)
		>= sizeof outdir) {
		telnetclient_puts(cl, "Export path too long.\n");
		return 0;
	}

	telnetclient_printf(cl, "Exporting world to %s ...\n", outdir);
	if (muddb_export(db, outdir, domains, ndom, export_report, cl) != 0) {
		telnetclient_printf(cl, "Export failed; could not create %s.\n",
			outdir);
		return 0;
	}
	telnetclient_printf(cl, "Export complete: %s\n", outdir);
	return 1;
}
