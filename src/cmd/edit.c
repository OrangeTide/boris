/* edit.c : @edit command -- property editor via web SSE or MCP simpleedit */
/* Made by a machine. PUBLIC DOMAIN (CC0-1.0) */

#include "command.h"
#include <boris.h>
#include "room.h"
#include "util.h"
#include "telnetclient.h"
#include "web/server/webclient.h"
#include "mcp.h"

#include <stdio.h>
#include <string.h>

/* mcp_edit_apply saves content sent back by an MCP client for a reference
 * handed out by @edit. The reference format is "room:<roomid>:<property>".
 */
void
mcp_edit_apply(DESCRIPTOR_DATA *cl, const char *reference, const char *content)
{
    char roomid_str[64];
    const char *prop;
    OBJ *r;

    if (strncmp(reference, "room:", 5) != 0) {
        telnetclient_puts(cl, "Edit failed: bad reference.\n");
        return;
    }

    prop = strrchr(reference + 5, ':');
    if (!prop || (size_t)(prop - (reference + 5)) >= sizeof roomid_str) {
        telnetclient_puts(cl, "Edit failed: bad reference.\n");
        return;
    }

    memcpy(roomid_str, reference + 5, prop - (reference + 5));
    roomid_str[prop - (reference + 5)] = 0;
    prop++;

    r = room_get(roomid_str);
    if (!r) {
        telnetclient_printf(cl, "Edit failed: room \"%s\" not found.\n",
                            roomid_str);
        return;
    }

    int rc = obj_prop_set(r, prop, content);
    room_put(r);

    if (rc == OBJ_ERR_PROTECTED) {
        telnetclient_printf(cl, "Edit failed: property \"%s\" is protected.\n",
                            prop);
        return;
    }
    if (rc != OBJ_OK) {
        telnetclient_printf(cl, "Edit failed: could not set \"%s\".\n", prop);
        return;
    }

    telnetclient_printf(cl, "Property %s.%s updated.\n", roomid_str, prop);
}

/* edit_via_mcp offers a room property for client-side editing over MCP.
 * The caller has verified the property exists; r stays valid until the
 * borrowed value pointer is no longer needed.
 */
static int
edit_via_mcp(DESCRIPTOR_DATA *cl, OBJ *r, const char *roomid_str,
             const char *propname)
{
    char reference[144];
    char title[132];
    const char *value = obj_prop_get(r, propname);

    snprintf(reference, sizeof reference, "room:%s:%s", roomid_str, propname);
    snprintf(title, sizeof title, "%s.%s", roomid_str, propname);

    return mcp_simpleedit_start(cl, reference, title, value ? value : "");
}

int
command_do_edit(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg)
{
    char roomid_str[64];
    char propname[64];
    char extra[2];
    char url[256];
    struct web_client *wc;
    OBJ *r;

    arg = util_getword(arg, roomid_str, sizeof roomid_str);
    if (!arg) roomid_str[0] = 0;
    arg = util_getword(arg, propname, sizeof propname);
    if (!arg) propname[0] = 0;

    if (!roomid_str[0] || !propname[0] ||
        util_getword(arg, extra, sizeof extra)) {
        telnetclient_printf(cl, "usage: @edit <roomid> <property>\n");
        return 0;
    }

    r = room_get(roomid_str);
    if (!r) {
        telnetclient_printf(cl, "room \"%s\" not found.\n", roomid_str);
        return 0;
    }

    if (!obj_prop_get(r, propname)) {
        telnetclient_printf(cl, "property \"%s\" not found on \"%s\".\n", propname, roomid_str);
        room_put(r);
        return 0;
    }

    if (cl->type == CLIENT_TYPE_WEB && cl->client_ctx) {
        room_put(r);

        wc = cl->client_ctx;
        snprintf(url, sizeof url, "/edit?obj=%s&prop=%s&sid=%s",
                 roomid_str, propname, wc->session);

        if (telnetclient_send_sse(cl, 'E', url) < 0) {
            telnetclient_puts(cl, "Failed to open editor.\n");
            return 0;
        }
    } else if (mcp_simpleedit_ok(cl)) {
        int rc = edit_via_mcp(cl, r, roomid_str, propname);
        room_put(r);

        if (rc != 0) {
            telnetclient_puts(cl, "Failed to open editor.\n");
            return 0;
        }
    } else {
        room_put(r);
        telnetclient_puts(cl, "@edit requires the web client or an "
                          "MCP-capable client.\n");
        return 0;
    }

    telnetclient_printf(cl, "Opening editor for %s.%s\n", roomid_str, propname);

    return 1;
}

int
command_do_view(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg)
{
    char roomid_str[64];
    char propname[64];
    char extra[2];
    char url[256];
    struct web_client *wc;
    OBJ *r;

    arg = util_getword(arg, roomid_str, sizeof roomid_str);
    if (!arg) roomid_str[0] = 0;
    arg = util_getword(arg, propname, sizeof propname);
    if (!arg) propname[0] = 0;

    if (!roomid_str[0] || !propname[0] ||
        util_getword(arg, extra, sizeof extra)) {
        telnetclient_printf(cl, "usage: @view <roomid> <property>\n");
        return 0;
    }

    if (cl->type != CLIENT_TYPE_WEB || !cl->client_ctx) {
        telnetclient_puts(cl, "@view is only available from the web client.\n");
        return 0;
    }

    r = room_get(roomid_str);
    if (!r) {
        telnetclient_printf(cl, "room \"%s\" not found.\n", roomid_str);
        return 0;
    }

    if (!obj_prop_get(r, propname)) {
        telnetclient_printf(cl, "property \"%s\" not found on \"%s\".\n", propname, roomid_str);
        room_put(r);
        return 0;
    }

    room_put(r);

    wc = cl->client_ctx;
    snprintf(url, sizeof url, "/view?obj=%s&prop=%s&sid=%s",
             roomid_str, propname, wc->session);

    if (telnetclient_send_sse(cl, 'V', url) < 0) {
        telnetclient_puts(cl, "Failed to open viewer.\n");
        return 0;
    }

    telnetclient_printf(cl, "Opening viewer for %s.%s\n", roomid_str, propname);

    return 1;
}
