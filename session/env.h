#ifndef ENV_H_
#define ENV_H_

struct env;

// semantics are like POSIX setenv()
int env_setenv(struct env *env, const char *name, const char *value, int overwrite);

// semantics are like POSIX unsetenv()
int env_unsetenv(struct env *env, const char *name);

// semantics are like ANSI C getenv()
const char *env_getenv(struct env *env, const char *name);

// semantics are like POSIX clearenv()
int env_clearenv(struct env *env);

// Allocate a new (empty) env structure
struct env *env_new(void);

// Free the env structure
void env_free(struct env *env);

#endif
