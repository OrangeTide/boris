/* mcp.h : MUD Client Protocol 2.1 with the simpleedit package */
/* Made by a machine. PUBLIC DOMAIN (CC0-1.0) */

#ifndef MCP_H_
#define MCP_H_
#include <mud.h>

struct mcp;

void mcp_banner(DESCRIPTOR_DATA *cl);
void mcp_free(DESCRIPTOR_DATA *cl);
const char *mcp_filter(DESCRIPTOR_DATA *cl, const char *line);
int mcp_simpleedit_ok(DESCRIPTOR_DATA *cl);
int mcp_simpleedit_start(DESCRIPTOR_DATA *cl, const char *reference,
                         const char *title, const char *content);

/* mcp_edit_apply is provided by the embedding application. It is called
 * when a client sends back edited content for a reference that was handed
 * out by mcp_simpleedit_start on the same connection.
 */
void mcp_edit_apply(DESCRIPTOR_DATA *cl, const char *reference,
                    const char *content);

#endif /* MCP_H_ */
