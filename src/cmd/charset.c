#include "command.h"
#include <boris.h>
#include <charset.h>
#include <user.h>

static void
charset_save_preference(DESCRIPTOR_DATA *cl, const char *name)
{
	struct user *u = telnetclient_user(cl);
	if (!u)
		return;
	user_extra_set(u, "charset", name);
	user_save(u);
}

int
command_do_charset(DESCRIPTOR_DATA *cl, struct user *u UNUSED,
	const char *cmd UNUSED, const char *arg)
{
	if (!arg || !*arg) {
		struct charset *cs = telnetclient_get_encoding(cl);
		telnetclient_printf(cl, "Current encoding: %s\n",
			cs ? charset_name(cs) : "UTF-8 (default)");
		telnetclient_puts(cl,
			"Usage: charset <name>  -- set encoding (e.g. cp437, latin1, cp1252)\n"
			"       charset utf8    -- reset to UTF-8 (no conversion)\n");
		return 1;
	}

	char norm[32];
	size_t j = 0;
	for (size_t i = 0; arg[i] && j < sizeof(norm) - 1; i++) {
		char c = arg[i];
		if (c == '-' || c == '_' || c == ' ')
			continue;
		if (c >= 'a' && c <= 'z')
			c -= 32;
		norm[j++] = c;
	}
	norm[j] = '\0';

	if (!strcmp(norm, "UTF8") || !strcmp(norm, "NONE") || !strcmp(norm, "DEFAULT")) {
		telnetclient_set_encoding(cl, NULL);
		charset_save_preference(cl, "utf8");
		telnetclient_puts(cl, "Encoding set to UTF-8 (no conversion).\n");
		return 1;
	}

	struct charset *cs = charset_load(arg);
	if (!cs) {
		telnetclient_printf(cl, "Unknown charset: %s\n", arg);
		telnetclient_puts(cl,
			"Available: cp437, cp737, cp850, cp860, cp863, "
			"cp1250, cp1252, latin1, iso-8859-1, "
			"iso-8859-10, koi8-r, koi8-u\n");
		return 0;
	}

	telnetclient_set_encoding(cl, cs);
	charset_save_preference(cl, charset_name(cs));
	telnetclient_printf(cl, "Encoding set to %s.\n", charset_name(cs));
	return 1;
}

int
command_do_chartest(DESCRIPTOR_DATA *cl, struct user *u UNUSED,
	const char *cmd UNUSED, const char *arg UNUSED)
{
	struct charset *cs = telnetclient_get_encoding(cl);

	telnetclient_printf(cl, "Encoding: %s\n",
		cs ? charset_name(cs) : "UTF-8 (default)");
	telnetclient_puts(cl, "\n");
	telnetclient_puts(cl, "--- Accented characters ---\n");
	telnetclient_puts(cl, "\xc3\xa0\xc3\xa1\xc3\xa2\xc3\xa3\xc3\xa4\xc3\xa5"
		" \xc3\xa8\xc3\xa9\xc3\xaa\xc3\xab"
		" \xc3\xac\xc3\xad\xc3\xae\xc3\xaf"
		" \xc3\xb2\xc3\xb3\xc3\xb4\xc3\xb5\xc3\xb6"
		" \xc3\xb9\xc3\xba\xc3\xbb\xc3\xbc"
		"\n");
	/* above: a-grave a-acute a-circ a-tilde a-uml a-ring,
	   e-grave e-acute e-circ e-uml, i-grave i-acute i-circ i-uml,
	   o-grave o-acute o-circ o-tilde o-uml, u-grave u-acute u-circ u-uml */

	telnetclient_puts(cl, "\xc3\x80\xc3\x81\xc3\x82\xc3\x83\xc3\x84\xc3\x85"
		" \xc3\x88\xc3\x89\xc3\x8a\xc3\x8b"
		" \xc3\x8c\xc3\x8d\xc3\x8e\xc3\x8f"
		" \xc3\x92\xc3\x93\xc3\x94\xc3\x95\xc3\x96"
		" \xc3\x99\xc3\x9a\xc3\x9b\xc3\x9c"
		"\n");
	/* uppercase versions */

	telnetclient_puts(cl, "\xc3\xa7 \xc3\xb1 \xc3\x9f \xc3\x86 \xc3\xa6 \xc3\x98 \xc3\xb8\n");
	/* c-cedilla, n-tilde, sharp-s, AE, ae, O-stroke, o-stroke */

	telnetclient_puts(cl, "\n--- Box drawing (light) ---\n");
	/* U+250C U+2500 U+2510 */
	telnetclient_puts(cl, "\xe2\x94\x8c\xe2\x94\x80\xe2\x94\x80\xe2\x94\x80"
		"\xe2\x94\x80\xe2\x94\x80\xe2\x94\x80\xe2\x94\x80\xe2\x94\x80"
		"\xe2\x94\x80\xe2\x94\x80\xe2\x94\x90\n");
	/* U+2502 ... U+2502 */
	telnetclient_puts(cl, "\xe2\x94\x82  Hello  \xe2\x94\x82\n");
	/* U+2514 U+2500 U+2518 */
	telnetclient_puts(cl, "\xe2\x94\x94\xe2\x94\x80\xe2\x94\x80\xe2\x94\x80"
		"\xe2\x94\x80\xe2\x94\x80\xe2\x94\x80\xe2\x94\x80\xe2\x94\x80"
		"\xe2\x94\x80\xe2\x94\x80\xe2\x94\x98\n");

	telnetclient_puts(cl, "\n--- Quotation marks ---\n");
	/* left/right double quotes U+201C U+201D */
	telnetclient_puts(cl, "\xe2\x80\x9c" "Hello" "\xe2\x80\x9d\n");
	/* left/right single quotes U+2018 U+2019 */
	telnetclient_puts(cl, "\xe2\x80\x98" "Hello" "\xe2\x80\x99\n");
	/* guillemets U+00AB U+00BB */
	telnetclient_puts(cl, "\xc2\xab" "Hello" "\xc2\xbb\n");

	telnetclient_puts(cl, "\n--- Currency and symbols ---\n");
	/* euro U+20AC, pound U+00A3, yen U+00A5, cent U+00A2, degree U+00B0 */
	telnetclient_puts(cl, "\xe2\x82\xac \xc2\xa3 \xc2\xa5 \xc2\xa2 \xc2\xb0\n");
	/* copyright U+00A9, registered U+00AE, section U+00A7, pilcrow U+00B6 */
	telnetclient_puts(cl, "\xc2\xa9 \xc2\xae \xc2\xa7 \xc2\xb6\n");

	return 1;
}
