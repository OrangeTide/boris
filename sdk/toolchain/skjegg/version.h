#ifndef SKJ_VERSION_H
#define SKJ_VERSION_H
/* Boris-authored, not part of the upstream vendor set. Upstream builds generate
 * this from version.mk; boris keeps a static copy so the modular-make build has
 * it without a generator rule. Re-vendoring (update-skjegg.sh) rm -rf's this
 * tree, so this file must be restored after each re-vendor; keep SKJ_VERSION in
 * step with version.mk and the commit the tree was vendored from. */
#define SKJ_VERSION "0.43.0+g49a60c3"
#endif
