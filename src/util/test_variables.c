/**
 * @file test_variables.c
 *
 * Unit tests for variables.c / expand_string().
 *
 * Copyright (c) 2026 Jon Mayo <jon@rm-f.net>
 */

#include "variables.h"

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

static const char *
lookup_kv(void *user, const char *name)
{
	const char *const *kv = user;
	int i;
	for (i = 0; kv[i]; i += 2) {
		if (strcmp(kv[i], name) == 0) return kv[i + 1];
	}
	return NULL;
}

static int failures;

static void
check_eq(const char *label, const char *got, const char *want)
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
run(const char *label, const char *in, const struct var_ctx *ctx,
    const char *want)
{
	char *got = expand_string(in, ctx);
	check_eq(label, got, want);
	free(got);
}

int
main(void)
{
	const char *kv[] = {
		"name",   "frodo",
		"room",   "shire",
		"empty",  "",
		NULL
	};
	struct var_ctx ctx = {
		.lookup = lookup_kv,
		.user = (void *)kv,
		.last_status = 42,
	};

	/* plain passthrough */
	run("plain", "hello world", &ctx, "hello world");

	/* named variables */
	run("bare $NAME", "hi $name!", &ctx, "hi frodo!");
	run("${NAME}", "room=${room}.", &ctx, "room=shire.");
	run("undefined", "x=$missing!", &ctx, "x=!");
	run("empty var", "[$empty]", &ctx, "[]");

	/* $? */
	run("status", "rc=$?", &ctx, "rc=42");

	/* $$ */
	{
		char want[32];
		char *got = expand_string("$$", &ctx);
		snprintf(want, sizeof(want), "%d", (int)getpid());
		check_eq("pid", got, want);
		free(got);
	}

	/* quoting */
	run("single-quote literal",
	    "'no $name here'", &ctx, "no $name here");
	run("double-quote expands",
	    "\"hi $name\"", &ctx, "hi frodo");
	run("mixed",
	    "'$a'\"$name\"", &ctx, "$afrodo");
	run("backslash escape",
	    "a\\$b\\\\c", &ctx, "a$b\\c");
	run("backslash inside single stays literal",
	    "'a\\b'", &ctx, "a\\b");

	/* bare '$' at end / before non-name */
	run("trailing $", "cost: $", &ctx, "cost: $");
	run("$ before digit-ish punct", "$-1", &ctx, "$-1");

	/* $(cmd) not supported -- literal $ then '(' */
	run("dollar-paren literal", "$(date)", &ctx, "$(date)");

	/* positional params */
	{
		const char *argv[] = {"meow", "to", "the", "moon"};
		struct var_ctx pctx = {
			.lookup = lookup_kv,
			.user = (void *)kv,
			.argc = 4,
			.argv = argv,
			.argstr = "to the moon",
		};
		run("$0 cmd name",  "cmd=$0",    &pctx, "cmd=meow");
		run("$1",           "w1=$1",     &pctx, "w1=to");
		run("$3",           "w3=$3",     &pctx, "w3=moon");
		run("$4 missing",   "[$4]",      &pctx, "[]");
		run("$# count",     "n=$#",      &pctx, "n=3");
		run("$* joined",    "all=[$*]",  &pctx, "all=[to the moon]");
		run("$@ joined",    "all=[$@]",  &pctx, "all=[to the moon]");
	}

	/* NULL ctx: only $? ($?==0) and $$ work; named/positional empty */
	run("null ctx plain",  "just text", NULL, "just text");
	run("null ctx status", "rc=$?",     NULL, "rc=0");
	run("null ctx name",   "[$name]",   NULL, "[]");
	run("null ctx pos",    "[$1]",      NULL, "[]");

	/* NULL input -> empty output */
	{
		char *got = expand_string(NULL, &ctx);
		check_eq("null input", got, "");
		free(got);
	}

	if (failures) {
		fprintf(stderr, "%d test(s) failed\n", failures);
		return 1;
	}
	printf("all tests passed\n");
	return 0;
}
