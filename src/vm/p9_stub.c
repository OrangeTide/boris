/* p9_stub.c : placeholder for the fs/ 9p server the embedded skj-run links.
 *
 * emu/guest.c (guest_p9_doorbell) and guest_install_mounts reference the
 * fs/p9_server.h entry points. The CAS-backed server (src/vfs/p9_vfs.c) provides
 * the real implementation; until it lands, no guest binds a 9p mount, so
 * guest_p9_doorbell never reaches a bound server and these stubs exist only to
 * satisfy the link. */

#include <stddef.h>
#include <stdint.h>

struct p9_server;

struct p9_server *
p9_server_create(const char *root)
{
	(void)root;
	return NULL;
}

void
p9_server_destroy(struct p9_server *s)
{
	(void)s;
}

int
p9_server_handle_stream(struct p9_server *s, const uint8_t *req, uint32_t reqlen,
                        uint8_t *rx, uint32_t rxcap)
{
	(void)s;
	(void)req;
	(void)reqlen;
	(void)rx;
	(void)rxcap;
	return -1;
}
