/* setverb.c : @setverb -- attach (or clear) a command verb on an object.
 *
 * A command verb is the property verb.<word> on an object; its value is the
 * packed "<prog-id>\t<argspec>" the dispatcher resolves in the actor's scope
 * (see verb_model.c). `@setverb <object> <word> <prog-id> [argspec]` sets it;
 * `@setverb <object> <word> -` clears it. The program is a bound program
 * object programs/<prog-id> (for example one produced by @compile); the argspec
 * is the verb_spec pattern the rest of the typed command is matched against.
 * This manages the object's own verb property, not one inherited from a
 * prototype. Wizard only. */

#include "command.h"
#include <boris.h>
#include <obj.h>
#include <user.h>
#include <telnetclient.h>
#include <util.h>

#include <verb_model.h>         /* VERB_WORD_MAX */
#include <verb_spec.h>          /* VERB_SPEC_BUF_MAX, verb_spec_parse */

#include <ctype.h>
#include <stdio.h>
#include <string.h>

/* A verb word becomes part of the property name verb.<word> and is typed as a
 * single command token, so keep it to letters, digits, dash and underscore. */
static int
word_ok(const char *w)
{
	const char *p;

	if (!*w || strlen(w) > VERB_WORD_MAX)
		return 0;
	for (p = w; *p; p++)
		if (!isalnum((unsigned char)*p) && *p != '-' && *p != '_')
			return 0;
	return 1;
}

/* Copy the rest-of-line argspec into out, trimming surrounding whitespace.
 * rest may be NULL (no spec given). */
static void
spec_trim(const char *rest, char *out, size_t outsz)
{
	size_t n;

	out[0] = '\0';
	if (!rest)
		return;
	while (isspace((unsigned char)*rest))
		rest++;
	snprintf(out, outsz, "%s", rest);
	n = strlen(out);
	while (n > 0 && isspace((unsigned char)out[n - 1]))
		out[--n] = '\0';
}

int
command_do_setverb(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd,
	const char *arg)
{
	char objid[OBJ_PATH_MAX], word[128], prog[OBJ_PATH_MAX];
	char spec[VERB_SPEC_BUF_MAX], propname[5 + VERB_WORD_MAX + 1];
	char progkey[OBJ_PATH_MAX];
	char packed[OBJ_PATH_MAX + VERB_SPEC_BUF_MAX];
	OBJ *o;

	if (!user_is_wizard(telnetclient_user(cl))) {
		telnetclient_puts(cl, "Permission denied.\n");
		return 0;
	}

	arg = util_getword(arg, objid, sizeof objid);
	if (arg)
		arg = util_getword(arg, word, sizeof word);
	else
		word[0] = 0;
	if (arg)
		arg = util_getword(arg, prog, sizeof prog);
	else
		prog[0] = 0;

	if (!objid[0] || !word[0] || !prog[0]) {
		telnetclient_printf(cl,
			"usage: %s <object> <word> <prog-id> [argspec]\n", cmd);
		telnetclient_printf(cl,
			"       %s <object> <word> -   (clear the verb)\n", cmd);
		return 0;
	}

	if (!word_ok(word)) {
		telnetclient_puts(cl,
			"A verb word is letters, digits, dash or underscore.\n");
		return 0;
	}
	snprintf(propname, sizeof propname, "verb.%s", word);

	o = obj_get(objid);
	if (!o) {
		telnetclient_printf(cl, "No such object: %s\n", objid);
		return 0;
	}

	/* Clear form: "@setverb <object> <word> -". */
	if (strcmp(prog, "-") == 0) {
		if (!obj_prop_get(o, propname)) {
			obj_release(o);
			telnetclient_printf(cl, "No verb '%s' on %s.\n", word, objid);
			return 0;
		}
		obj_prop_delete(o, propname);
		obj_mark_dirty(o);
		obj_save(objid);
		obj_release(o);
		telnetclient_printf(cl, "Cleared verb '%s' on %s.\n", word, objid);
		return 1;
	}

	/* Set form. The program id is a bare name the dispatcher resolves under
	 * programs/, so reject a path and require the program to exist. */
	if (strchr(prog, '/')) {
		obj_release(o);
		telnetclient_puts(cl, "A program id is a single name, with no '/'.\n");
		return 0;
	}
	snprintf(progkey, sizeof progkey, "programs/%s", prog);
	{
		OBJ *p = obj_get(progkey);

		if (!p) {
			obj_release(o);
			telnetclient_printf(cl, "No such program: %s\n", progkey);
			return 0;
		}
		obj_release(p);
	}

	spec_trim(arg, spec, sizeof spec);
	if (spec[0]) {
		struct verb_spec vs;

		if (verb_spec_parse(spec, &vs) != 0) {
			obj_release(o);
			telnetclient_printf(cl, "Bad argument spec: %s\n", spec);
			return 0;
		}
		snprintf(packed, sizeof packed, "%s\t%s", prog, spec);
	} else {
		snprintf(packed, sizeof packed, "%s", prog);
	}

	if (obj_prop_set(o, propname, packed) != OBJ_OK) {
		obj_release(o);
		telnetclient_puts(cl, "Could not set the verb.\n");
		return 0;
	}
	obj_mark_dirty(o);
	obj_save(objid);
	obj_release(o);

	if (spec[0])
		telnetclient_printf(cl, "Set verb '%s' on %s -> %s (%s).\n",
			word, objid, prog, spec);
	else
		telnetclient_printf(cl, "Set verb '%s' on %s -> %s.\n",
			word, objid, prog);
	return 1;
}
