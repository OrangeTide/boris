/* iox_version.h : the version of this copy of libiox */

#ifndef IOX_VERSION_H
#define IOX_VERSION_H

/* Bumped by tools/version.sh, which also creates the matching git tag.
 * A vendored copy has no git, so this header is what identifies it. */
#define IOX_VERSION_MAJOR 0
#define IOX_VERSION_MINOR 1
#define IOX_VERSION_PATCH 0
#define IOX_VERSION_STRING "0.1.0"

/** The version as one comparable integer, e.g. 0.1.0 is 100. Use it to
 *  compile against more than one release: IOX_VERSION >= 100. */
#define IOX_VERSION (IOX_VERSION_MAJOR * 10000 + \
                     IOX_VERSION_MINOR * 100 + \
                     IOX_VERSION_PATCH)

#endif /* IOX_VERSION_H */
