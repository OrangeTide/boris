# Vendored libiox

| | |
| --- | --- |
| Version | `v0.1.0` (IOX_VERSION_STRING 0.1.0) |
| Source | <https://github.com/OrangeTide/libiox/archive/refs/tags/v0.1.0.tar.gz> |
| Tests | not copied |

Copied by `tools/vendor.sh` from the release snapshot. Do not edit these
files in place: local changes are lost on the next upgrade and make it
impossible to tell what version this is. Upgrade by re-running the script
with a newer `--version`, then read the upstream CHANGELOG.

`iox_version.h` identifies this copy at compile time:

```c
#if IOX_VERSION < 100          /* 0.1.0 */
#  error "libiox 0.1.0 or newer is required"
#endif
```
