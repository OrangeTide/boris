#define LOG_SUBSYSTEM "program"
#include <log.h>

#include "program.h"
#include <boris.h>
#include <mudconfig.h>

#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define DEFAULT_RAM_SIZE 65536

static int image_dir_fd = -1;

static int
path_is_safe(const char *p)
{
	if (!p || !p[0] || p[0] == '/')
		return 0;
	while (*p) {
		if (p[0] == '.' && p[1] == '.' &&
		    (p[2] == '/' || p[2] == '\0'))
			return 0;
		while (*p && *p != '/')
			p++;
		while (*p == '/')
			p++;
	}
	return 1;
}

int
program_init(void)
{
	image_dir_fd = open(mud_config.image_path,
	                    O_RDONLY | O_DIRECTORY | O_CLOEXEC);
	if (image_dir_fd < 0) {
		LOG_WARNING("cannot open image directory: %s",
		            mud_config.image_path);
		return -1;
	}
	LOG_INFO("image directory: %s", mud_config.image_path);
	return 0;
}

void
program_shutdown(void)
{
	if (image_dir_fd >= 0) {
		close(image_dir_fd);
		image_dir_fd = -1;
	}
}

OBJ *
program_get(const char *id)
{
	char key[OBJ_PATH_MAX];

	if (!id || !id[0])
		return NULL;
	snprintf(key, sizeof key, PROGRAM_ROOTDIR "/%s", id);
	return obj_get(key);
}

void
program_release(OBJ *obj)
{
	obj_release(obj);
}

unsigned
program_ram_size(OBJ *obj)
{
	const char *val = obj_prop_get(obj, "ram.size");
	if (val) {
		unsigned long n = strtoul(val, NULL, 0);
		if (n > 0)
			return (unsigned)n;
	}
	return DEFAULT_RAM_SIZE;
}

const char *
program_interface(OBJ *obj)
{
	return obj_prop_get(obj, "interface");
}

int
program_open_image(OBJ *obj)
{
	const char *rel = obj_prop_get(obj, "image.path");

	if (!path_is_safe(rel)) {
		LOG_WARNING("rejected image path: %s", rel ? rel : "(null)");
		return -1;
	}

	return openat(image_dir_fd, rel, O_RDONLY | O_CLOEXEC);
}
