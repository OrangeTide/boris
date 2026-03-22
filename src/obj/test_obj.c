/* unit test for obj.c */
#define LOG_SUBSYSTEM "test_obj"

/* include the source directly for unit testing */
#include "obj.c"

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

static int pass_count;
static int fail_count;

static inline void
check(const char *description, bool e)
{
	if (e) {
		LOG_INFO("%s: PASSED", description);
		pass_count++;
	} else {
		LOG_ERROR("%s: FAILED", description);
		fail_count++;
	}
}

/* output buffer for debug_dump */
static char *dump_buf;
static unsigned dump_pos, dump_alloc;

static void
dump_append(const char *s)
{
	unsigned n = strlen(s);

	if (dump_alloc < dump_pos + n + 1) {
		if (!dump_alloc)
			dump_alloc = 64;
		while (dump_alloc < dump_pos + n + 1)
			dump_alloc *= 2;
		char *newbuf = realloc(dump_buf, dump_alloc);
		check("expand dump buffer", newbuf != NULL);
		dump_buf = newbuf;
	}
	memcpy(dump_buf + dump_pos, s, n + 1);
	dump_pos += n;
}

static void
dump_rewind(void)
{
	dump_pos = 0;
}

static const char *house_json =
	"{ \"name\": \"A white house\", \"color\": \"white\" }";
static const char *chair_json =
	"{ \"name\": \"A green overstuffed chair\", \"color\": \"green\" }";

static void
test_create_and_read(void)
{
	OBJ *house = obj_new_from_json("house", house_json);
	check("create house from json", house != NULL);

	OBJ *chair = obj_new_from_json("chair", chair_json);
	check("create chair from json", chair != NULL);

	char *name;

	name = obj_prop_get(house, "name");
	check("house name not null", name != NULL);
	if (name)
		check("house name value", strcmp(name, "A white house") == 0);

	name = obj_prop_get(chair, "name");
	check("chair name not null", name != NULL);
	if (name)
		check("chair name value",
			strcmp(name, "A green overstuffed chair") == 0);

	char *color = obj_prop_get(house, "color");
	check("house color not null", color != NULL);
	if (color)
		check("house color value", strcmp(color, "white") == 0);

	/* nonexistent property */
	check("missing prop returns null",
		obj_prop_get(house, "bogus") == NULL);

	obj_free(chair);
	obj_free(house);
}

static void
test_get_json_unmodified(void)
{
	OBJ *obj = obj_new_from_json("test", house_json);
	check("create for get_json", obj != NULL);

	char buf[1024];
	int result = obj_get_json(obj, buf, sizeof(buf));
	check("get_json ok", result == OBJ_OK);
	LOG_INFO("get_json unmodified: %s", buf);

	/* verify it round-trips -- parse the output */
	OBJ *obj2 = obj_new_from_json("test2", buf);
	check("round-trip parse", obj2 != NULL);

	char *name = obj_prop_get(obj2, "name");
	check("round-trip name", name != NULL && strcmp(name, "A white house") == 0);

	obj_free(obj2);
	obj_free(obj);
}

static void
test_prop_set_new(void)
{
	OBJ *obj = obj_new_from_json("test", house_json);
	check("create for set_new", obj != NULL);

	int rc = obj_prop_set(obj, "size", "\"large\"");
	check("set new prop", rc == OBJ_OK);

	char *val = obj_prop_get(obj, "size");
	check("get new prop", val != NULL && strcmp(val, "\"large\"") == 0);

	/* original props still accessible */
	char *name = obj_prop_get(obj, "name");
	check("original prop after set", name != NULL);

	/* serialize and verify */
	char buf[1024];
	int result = obj_get_json(obj, buf, sizeof(buf));
	check("get_json with new prop", result == OBJ_OK);
	LOG_INFO("get_json after set new: %s", buf);

	/* verify round-trip */
	OBJ *obj2 = obj_new_from_json("test2", buf);
	check("round-trip after set", obj2 != NULL);
	val = obj_prop_get(obj2, "size");
	check("round-trip new prop", val != NULL && strcmp(val, "large") == 0);

	obj_free(obj2);
	obj_free(obj);
}

static void
test_prop_set_override(void)
{
	OBJ *obj = obj_new_from_json("test", house_json);
	check("create for override", obj != NULL);

	int rc = obj_prop_set(obj, "color", "\"blue\"");
	check("override existing prop", rc == OBJ_OK);

	char *val = obj_prop_get(obj, "color");
	check("get overridden prop", val != NULL && strcmp(val, "\"blue\"") == 0);

	/* name should be unchanged */
	char *name = obj_prop_get(obj, "name");
	check("other prop unchanged after override",
		name != NULL && strcmp(name, "A white house") == 0);

	/* serialize */
	char buf[1024];
	int result = obj_get_json(obj, buf, sizeof(buf));
	check("get_json with override", result == OBJ_OK);
	LOG_INFO("get_json after override: %s", buf);

	/* verify round-trip reads the new value */
	OBJ *obj2 = obj_new_from_json("test2", buf);
	check("round-trip override parse", obj2 != NULL);
	val = obj_prop_get(obj2, "color");
	check("round-trip override value", val != NULL && strcmp(val, "blue") == 0);

	obj_free(obj2);
	obj_free(obj);
}

static void
test_prop_delete(void)
{
	OBJ *obj = obj_new_from_json("test", house_json);
	check("create for delete", obj != NULL);

	int rc = obj_prop_delete(obj, "color");
	check("delete prop", rc == OBJ_OK);

	check("deleted prop returns null",
		obj_prop_get(obj, "color") == NULL);

	/* name should still be accessible */
	char *name = obj_prop_get(obj, "name");
	check("other prop after delete", name != NULL);

	/* serialize -- deleted prop should be absent */
	char buf[1024];
	int result = obj_get_json(obj, buf, sizeof(buf));
	check("get_json after delete", result == OBJ_OK);
	LOG_INFO("get_json after delete: %s", buf);

	/* verify deleted prop is gone from serialized form */
	OBJ *obj2 = obj_new_from_json("test2", buf);
	check("round-trip delete parse", obj2 != NULL);
	check("deleted prop absent after round-trip",
		obj_prop_get(obj2, "color") == NULL);
	name = obj_prop_get(obj2, "name");
	check("surviving prop after delete round-trip",
		name != NULL && strcmp(name, "A white house") == 0);

	obj_free(obj2);
	obj_free(obj);
}

static void
test_compact(void)
{
	OBJ *obj = obj_new_from_json("test", house_json);
	check("create for compact", obj != NULL);

	obj_prop_set(obj, "color", "\"red\"");
	obj_prop_set(obj, "size", "\"big\"");
	obj_prop_delete(obj, "name");

	int rc = obj_compact(obj);
	check("compact ok", rc == OBJ_OK);

	/* after compact, dirty flag is cleared and values persist */
	check("compact clears dirty", obj->dirty == false);

	char *color = obj_prop_get(obj, "color");
	check("compacted color", color != NULL && strcmp(color, "red") == 0);

	char *size = obj_prop_get(obj, "size");
	check("compacted size", size != NULL && strcmp(size, "big") == 0);

	check("compacted deleted prop gone",
		obj_prop_get(obj, "name") == NULL);

	obj_free(obj);
}

static void
test_prop_set_int(void)
{
	OBJ *obj = obj_new_from_json("test", house_json);
	check("create for set_int", obj != NULL);

	int rc = obj_prop_set_int(obj, "rooms", 42);
	check("set_int ok", rc == OBJ_OK);

	char *val = obj_prop_get(obj, "rooms");
	check("get_int prop", val != NULL && strcmp(val, "42") == 0);

	/* serialize and round-trip */
	char buf[1024];
	int result = obj_get_json(obj, buf, sizeof(buf));
	check("get_json with int prop", result == OBJ_OK);
	LOG_INFO("get_json after set_int: %s", buf);

	OBJ *obj2 = obj_new_from_json("test2", buf);
	check("round-trip int parse", obj2 != NULL);
	val = obj_prop_get(obj2, "rooms");
	check("round-trip int value", val != NULL && strcmp(val, "42") == 0);

	obj_free(obj2);
	obj_free(obj);
}

static void
test_empty_object(void)
{
	OBJ *obj = obj_new("empty");
	check("create empty obj", obj != NULL);

	check("empty obj prop returns null",
		obj_prop_get(obj, "anything") == NULL);

	/* set a property on empty obj */
	int rc = obj_prop_set(obj, "hello", "\"world\"");
	check("set on empty obj", rc == OBJ_OK);

	char *val = obj_prop_get(obj, "hello");
	check("get from empty+set", val != NULL && strcmp(val, "\"world\"") == 0);

	obj_free(obj);
}

static void
test_debug_dump(void)
{
	OBJ *obj = obj_new_from_json("test", house_json);
	check("create for dump", obj != NULL);

	dump_rewind();
	obj_debug_dump(obj, dump_append);
	check("debug dump produced output", dump_pos > 0);
	LOG_INFO("debug dump: %.*s", dump_pos, dump_buf);

	obj_free(obj);
}

static void
test_buffer_too_small(void)
{
	OBJ *obj = obj_new_from_json("test", house_json);
	check("create for small buf", obj != NULL);

	char buf[4];
	int result = obj_get_json(obj, buf, sizeof(buf));
	check("small buffer returns NOMEM", result == OBJ_ERR_NOMEM);

	obj_free(obj);
}

static void
test_iter_basic(void)
{
	OBJ *obj = obj_new_from_json("test", house_json);
	check("iter: create obj", obj != NULL);

	OBJ_ITER *it = obj_iter_begin(obj);
	check("iter: begin", it != NULL);

	const char *key, *value;
	int count = 0;
	int found_name = 0, found_color = 0;

	while (obj_iter_next(it, &key, &value)) {
		if (strcmp(key, "name") == 0) {
			check("iter: name value",
				strcmp(value, "A white house") == 0);
			found_name = 1;
		} else if (strcmp(key, "color") == 0) {
			check("iter: color value",
				strcmp(value, "white") == 0);
			found_color = 1;
		}
		count++;
	}
	obj_iter_end(it);

	check("iter: count == 2", count == 2);
	check("iter: found name", found_name == 1);
	check("iter: found color", found_color == 1);

	obj_free(obj);
}

static void
test_iter_with_overrides(void)
{
	OBJ *obj = obj_new_from_json("test", house_json);
	check("iter_ov: create obj", obj != NULL);

	obj_prop_set(obj, "color", "blue");
	obj_prop_set(obj, "size", "large");
	obj_prop_delete(obj, "name");

	OBJ_ITER *it = obj_iter_begin(obj);
	check("iter_ov: begin", it != NULL);

	const char *key, *value;
	int count = 0;
	int found_color = 0, found_size = 0, found_name = 0;

	while (obj_iter_next(it, &key, &value)) {
		if (strcmp(key, "color") == 0) {
			check("iter_ov: color overridden",
				strcmp(value, "blue") == 0);
			found_color = 1;
		} else if (strcmp(key, "size") == 0) {
			check("iter_ov: size new prop",
				strcmp(value, "large") == 0);
			found_size = 1;
		} else if (strcmp(key, "name") == 0) {
			found_name = 1; /* should not happen */
		}
		count++;
	}
	obj_iter_end(it);

	check("iter_ov: count == 2", count == 2);
	check("iter_ov: found color", found_color == 1);
	check("iter_ov: found size", found_size == 1);
	check("iter_ov: name deleted", found_name == 0);

	obj_free(obj);
}

static void
test_iter_empty(void)
{
	OBJ *obj = obj_new("empty");
	check("iter_empty: create", obj != NULL);

	OBJ_ITER *it = obj_iter_begin(obj);
	check("iter_empty: begin", it != NULL);

	const char *key, *value;
	check("iter_empty: no props", obj_iter_next(it, &key, &value) == 0);
	obj_iter_end(it);

	/* add a prop and iterate */
	obj_prop_set(obj, "hello", "world");

	it = obj_iter_begin(obj);
	int count = 0;
	while (obj_iter_next(it, &key, &value)) {
		check("iter_empty: key is hello", strcmp(key, "hello") == 0);
		check("iter_empty: value is world", strcmp(value, "world") == 0);
		count++;
	}
	obj_iter_end(it);
	check("iter_empty: count == 1", count == 1);

	obj_free(obj);
}

int
main(void)
{
	LOG_INFO("%%%%%%%%%%%% START-TEST : obj.c");

	test_create_and_read();
	test_get_json_unmodified();
	test_prop_set_new();
	test_prop_set_override();
	test_prop_delete();
	test_compact();
	test_prop_set_int();
	test_empty_object();
	test_debug_dump();
	test_buffer_too_small();
	test_iter_basic();
	test_iter_with_overrides();
	test_iter_empty();

	LOG_INFO("%%%%%%%%%%%% END-TEST : %d passed, %d failed",
		pass_count, fail_count);

	free(dump_buf);

	return fail_count ? EXIT_FAILURE : EXIT_SUCCESS;
}
