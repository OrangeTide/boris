/* muddb_export.h : export muddb domains as JSON-record directories */
/* PUBLIC DOMAIN (CC0-1.0) or MIT-0 -- See LICENSE for details. */
#ifndef MUDDB_EXPORT_H_
#define MUDDB_EXPORT_H_

#include <stddef.h>

struct muddb;

/*
 * Progress callback: invoked once per exported domain with the number of
 * records written. Optional (pass NULL).
 */
typedef void (*muddb_export_progress_fn)(const char *domain, int count,
	void *ctx);

/*
 * Export muddb domains under outdir, one "<outdir>/<domain>/<key>.json" file
 * per record (the muddb-tool JSON-record format). Hierarchical keys become
 * nested directories; unsafe keys ("..", empty components, backslashes) are
 * skipped. outdir and its parents are created.
 *
 * domains/ndomains names the domains to export; ndomains == 0 exports the
 * well-known set (users, objs, chars). progress, when non-NULL, is called once
 * per domain with its record count.
 *
 * Shared by the muddb-tool `export` subcommand and the in-game `@export`
 * command, so both produce identical output. Reads committed store state, so
 * a live caller should flush its object cache first (obj_sync).
 *
 * Returns 0 on success, or -1 if outdir could not be created.
 */
int muddb_export(struct muddb *db, const char *outdir,
	const char *const *domains, size_t ndomains,
	muddb_export_progress_fn progress, void *ctx);

#endif
