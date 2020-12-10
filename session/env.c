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

#include "env.h"

// semantics are like POSIX setenv()
int
env_setenv(struct env *env, const char *name, const char *value, int overwrite)
{
#warning TODO: implement this
}

// semantics are like POSIX unsetenv()
int
env_unsetenv(struct env *env, const char *name)
{
#warning TODO: implement this
}

// semantics are like ANSI C getenv()
const char *
env_getenv(struct env *env, const char *name)
{
#warning TODO: implement this
}

// semantics are like POSIX clearenv()
int
env_clearenv(struct env *env)
{
#warning TODO: implement this
}

struct env *
env_new(void)
{
#warning TODO: implement this
}

void
env_free(struct env *env)
{
#warning TODO: implement this
}
