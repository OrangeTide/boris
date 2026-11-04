#include "objref.h"

#include <stddef.h>
#include <string.h>

int
objref_is_ref_name(const char *name)
{
	size_t n;

	if (!name)
		return 0;
	if (!strcmp(name, "%parent") || !strcmp(name, "%location")
		|| !strcmp(name, "template"))
		return 1;
	/* exit.<dir>.to : flat dotted exit destination, dir non-empty */
	n = strlen(name);
	if (n >= 9 && !strncmp(name, "exit.", 5)
		&& !strcmp(name + n - 3, ".to"))
		return 1;
	return 0;
}
