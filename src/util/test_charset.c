#include "charset.h"

#include <stdio.h>
#include <string.h>

static int failures;

static void
check_str(const char *label, const char *got, const char *want)
{
	if (!got || strcmp(got, want) != 0) {
		fprintf(stderr, "FAIL %s: got \"%s\" want \"%s\"\n",
			label, got ? got : "(null)", want);
		failures++;
	} else {
		printf("ok   %s\n", label);
	}
}

static void
check_bytes(const char *label, const char *got, int got_len,
	    const unsigned char *want, int want_len)
{
	if (got_len != want_len || memcmp(got, want, want_len) != 0) {
		fprintf(stderr, "FAIL %s: len got=%d want=%d\n",
			label, got_len, want_len);
		if (got_len == want_len) {
			for (int i = 0; i < got_len; i++) {
				if ((unsigned char)got[i] != want[i])
					fprintf(stderr, "  byte %d: got 0x%02x want 0x%02x\n",
						i, (unsigned char)got[i], want[i]);
			}
		}
		failures++;
	} else {
		printf("ok   %s\n", label);
	}
}

static void
check_int(const char *label, int got, int want)
{
	if (got != want) {
		fprintf(stderr, "FAIL %s: got %d want %d\n", label, got, want);
		failures++;
	} else {
		printf("ok   %s\n", label);
	}
}

static void
test_load(void)
{
	struct charset *cs;

	cs = charset_load(NULL);
	check_int("load NULL returns NULL", cs == NULL, 1);

	cs = charset_load("");
	check_int("load empty returns NULL", cs == NULL, 1);

	cs = charset_load("NONEXISTENT-ENCODING-99");
	check_int("load unknown returns NULL", cs == NULL, 1);

	cs = charset_load("cp437");
	check_int("load cp437", cs != NULL, 1);
	if (cs) {
		check_str("cp437 name normalized", charset_name(cs), "CP437");
		charset_free(cs);
	}
}

static void
test_name_aliases(void)
{
	struct charset *cs;

	cs = charset_load("latin1");
	check_int("load latin1", cs != NULL, 1);
	if (cs) {
		check_str("latin1 normalized", charset_name(cs), "LATIN1");
		charset_free(cs);
	}

	cs = charset_load("iso-8859-1");
	check_int("load iso-8859-1", cs != NULL, 1);
	if (cs) {
		check_str("iso-8859-1 normalized", charset_name(cs), "ISO88591");
		charset_free(cs);
	}

	cs = charset_load("windows-1252");
	check_int("load windows-1252", cs != NULL, 1);
	if (cs) {
		check_str("windows-1252 normalized", charset_name(cs), "WINDOWS1252");
		charset_free(cs);
	}

	cs = charset_load("KOI8-R");
	check_int("load KOI8-R", cs != NULL, 1);
	if (cs) {
		check_str("KOI8-R normalized", charset_name(cs), "KOI8R");
		charset_free(cs);
	}
}

static void
test_cache(void)
{
	struct charset *cs1 = charset_load("cp437");
	struct charset *cs2 = charset_load("cp437");
	check_int("cache returns same pointer", cs1 == cs2, 1);
	charset_free(cs1);
}

static void
test_ascii_passthrough(void)
{
	struct charset *cs = charset_load("cp437");
	if (!cs) { failures++; return; }

	char out[64];
	int n;

	n = charset_to_utf8(cs, "Hello", 5, out, sizeof(out));
	check_str("ascii to_utf8", out, "Hello");
	check_int("ascii to_utf8 len", n, 5);

	n = charset_from_utf8(cs, "Hello", 5, out, sizeof(out));
	check_str("ascii from_utf8", out, "Hello");
	check_int("ascii from_utf8 len", n, 5);

	charset_free(cs);
}

static void
test_cp437_to_utf8(void)
{
	struct charset *cs = charset_load("cp437");
	if (!cs) { failures++; return; }

	char out[64];
	int n;

	/* CP437 0x01 = U+263A SMILEY -- but 0x01 < 0x80, ASCII passthrough */
	/* CP437 0x80 = U+00C7 LATIN CAPITAL LETTER C WITH CEDILLA */
	unsigned char legacy_c_cedilla[] = { 0x80 };
	n = charset_to_utf8(cs, (const char *)legacy_c_cedilla, 1, out, sizeof(out));
	/* U+00C7 in UTF-8 is 0xC3 0x87 */
	unsigned char want_c_cedilla[] = { 0xC3, 0x87 };
	check_bytes("cp437 0x80 -> U+00C7", out, n, want_c_cedilla, 2);

	/* CP437 0xDA = U+250C BOX DRAWINGS LIGHT DOWN AND RIGHT */
	unsigned char legacy_box[] = { 0xDA };
	n = charset_to_utf8(cs, (const char *)legacy_box, 1, out, sizeof(out));
	/* U+250C in UTF-8 is 0xE2 0x94 0x8C */
	unsigned char want_box[] = { 0xE2, 0x94, 0x8C };
	check_bytes("cp437 0xDA -> U+250C box", out, n, want_box, 3);

	charset_free(cs);
}

static void
test_cp437_from_utf8(void)
{
	struct charset *cs = charset_load("cp437");
	if (!cs) { failures++; return; }

	char out[64];
	int n;

	/* U+00C7 (C with cedilla) -> CP437 0x80 */
	n = charset_from_utf8(cs, "\xC3\x87", 2, out, sizeof(out));
	unsigned char want_80[] = { 0x80 };
	check_bytes("U+00C7 -> cp437 0x80", out, n, want_80, 1);

	/* U+250C (box) -> CP437 0xDA */
	n = charset_from_utf8(cs, "\xE2\x94\x8C", 3, out, sizeof(out));
	unsigned char want_da[] = { 0xDA };
	check_bytes("U+250C -> cp437 0xDA", out, n, want_da, 1);

	/* unmapped codepoint -> '?' */
	/* U+4E16 (CJK) has no CP437 mapping */
	n = charset_from_utf8(cs, "\xE4\xB8\x96", 3, out, sizeof(out));
	check_bytes("unmapped -> ?", out, n, (const unsigned char *)"?", 1);

	charset_free(cs);
}

static void
test_latin1_roundtrip(void)
{
	struct charset *cs = charset_load("latin1");
	if (!cs) { failures++; return; }

	char out1[64], out2[64];
	int n;

	/* Latin1 0xE9 = U+00E9 LATIN SMALL LETTER E WITH ACUTE */
	unsigned char legacy[] = { 0xE9 };
	n = charset_to_utf8(cs, (const char *)legacy, 1, out1, sizeof(out1));
	/* U+00E9 in UTF-8 = 0xC3 0xA9 */
	unsigned char want_utf8[] = { 0xC3, 0xA9 };
	check_bytes("latin1 0xE9 -> UTF-8", out1, n, want_utf8, 2);

	n = charset_from_utf8(cs, out1, 2, out2, sizeof(out2));
	check_bytes("latin1 roundtrip", out2, n, legacy, 1);

	charset_free(cs);
}

static void
test_cp1252_undefined(void)
{
	struct charset *cs = charset_load("cp1252");
	if (!cs) { failures++; return; }

	char out[64];
	int n;

	/* CP1252 0x81 is UNDEFINED -- should produce '?' */
	unsigned char legacy[] = { 0x81 };
	n = charset_to_utf8(cs, (const char *)legacy, 1, out, sizeof(out));
	check_bytes("cp1252 0x81 undefined -> ?", out, n,
		    (const unsigned char *)"?", 1);

	/* CP1252 0x80 = U+20AC EURO SIGN */
	unsigned char legacy_euro[] = { 0x80 };
	n = charset_to_utf8(cs, (const char *)legacy_euro, 1, out, sizeof(out));
	/* U+20AC in UTF-8 = 0xE2 0x82 0xAC */
	unsigned char want_euro[] = { 0xE2, 0x82, 0xAC };
	check_bytes("cp1252 0x80 -> euro sign", out, n, want_euro, 3);

	charset_free(cs);
}

static void
test_mixed_string(void)
{
	struct charset *cs = charset_load("cp437");
	if (!cs) { failures++; return; }

	char out[256];
	int n;

	/* mixed ASCII + high bytes */
	unsigned char legacy[] = { 'H', 'i', ' ', 0xDA, 0xC4, 0xBF };
	n = charset_to_utf8(cs, (const char *)legacy, 6, out, sizeof(out));
	check_int("mixed to_utf8 len > input", n > 6, 1);
	/* first 3 bytes should be "Hi " */
	check_int("mixed starts with ascii", memcmp(out, "Hi ", 3) == 0, 1);

	/* round-trip the result back */
	char back[256];
	int n2 = charset_from_utf8(cs, out, n, back, sizeof(back));
	check_bytes("mixed roundtrip", back, n2, legacy, 6);

	charset_free(cs);
}

static void
test_empty_input(void)
{
	struct charset *cs = charset_load("cp437");
	if (!cs) { failures++; return; }

	char out[64];
	int n;

	n = charset_to_utf8(cs, "", 0, out, sizeof(out));
	check_int("empty to_utf8", n, 0);
	check_int("empty to_utf8 null term", out[0], 0);

	n = charset_from_utf8(cs, "", 0, out, sizeof(out));
	check_int("empty from_utf8", n, 0);
	check_int("empty from_utf8 null term", out[0], 0);

	charset_free(cs);
}

static void
test_charset_name_null(void)
{
	check_str("charset_name(NULL)", charset_name(NULL), "UTF8");
}

static void
test_shutdown(void)
{
	charset_load("cp437");
	charset_load("latin1");
	charset_shutdown();
	/* loading again after shutdown should work */
	struct charset *cs = charset_load("cp437");
	check_int("reload after shutdown", cs != NULL, 1);
	charset_shutdown();
}

int
main(void)
{
	test_load();
	test_name_aliases();
	test_cache();
	test_ascii_passthrough();
	test_cp437_to_utf8();
	test_cp437_from_utf8();
	test_latin1_roundtrip();
	test_cp1252_undefined();
	test_mixed_string();
	test_empty_input();
	test_charset_name_null();
	test_shutdown();

	if (failures) {
		fprintf(stderr, "%d test(s) failed\n", failures);
		return 1;
	}
	printf("all tests passed\n");
	return 0;
}
