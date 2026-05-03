/* edit.c : @edit command -- open web property editor via SSE */
/* Made by a machine. PUBLIC DOMAIN (CC0-1.0) */

#include "command.h"
#include <boris.h>
#include "room.h"
#include "util.h"
#include "telnetclient.h"
#include "web/server/webclient.h"

#include <stdio.h>
#include <string.h>

int
command_do_edit(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg)
{
    char roomid_str[64];
    char propname[64];
    char url[256];
    struct web_client *wc;
    OBJ *r;

    arg = util_getword(arg, roomid_str, sizeof roomid_str);
    if (!arg) roomid_str[0] = 0;
    arg = util_getword(arg, propname, sizeof propname);
    if (!arg) propname[0] = 0;

    if (!roomid_str[0] || !propname[0] || arg) {
        telnetclient_printf(cl, "usage: @edit <roomid> <property>\n");
        return 0;
    }

    if (cl->type != CLIENT_TYPE_WEB || !cl->client_ctx) {
        telnetclient_puts(cl, "@edit is only available from the web client.\n");
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
    snprintf(url, sizeof url, "/edit?obj=%s&prop=%s&sid=%s",
             roomid_str, propname, wc->session);

    if (telnetclient_send_sse(cl, 'E', url) < 0) {
        telnetclient_puts(cl, "Failed to open editor.\n");
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
    char url[256];
    struct web_client *wc;
    OBJ *r;

    arg = util_getword(arg, roomid_str, sizeof roomid_str);
    if (!arg) roomid_str[0] = 0;
    arg = util_getword(arg, propname, sizeof propname);
    if (!arg) propname[0] = 0;

    if (!roomid_str[0] || !propname[0] || arg) {
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
