/* gdbstub.c : the architecture-neutral GDB RSP server (see gdbstub.h). */

#include "gdbstub.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netinet/tcp.h>
#include <arpa/inet.h>

#define PKT_MAX      8192           /* packet payload buffer (PacketSize below) */
#define BP_MAX       64             /* host-side software breakpoints           */
#define WP_MAX       16             /* host-side write watchpoints              */
#define WATCH_MAXLEN 16             /* longest watched range we shadow          */
#define IRQ_STRIDE   4096           /* steps between interrupt-byte polls       */

struct watchpoint {
    uint64_t addr;
    uint32_t len;
    uint8_t shadow[WATCH_MAXLEN];   /* watched bytes as of the last run start */
};

struct gdb {
    int fd;                         /* the accepted connection                 */
    int ack_mode;                   /* +/- acknowledgements still in effect    */
    const struct gdb_target *t;     /* the backend seam                        */
    void *ctx;                      /* the backend's own state                 */
    uint64_t bp[BP_MAX];
    int nbp;
    struct watchpoint wp[WP_MAX];
    int nwp;
    int watch_hit;                  /* the last stop was a write watchpoint    */
    uint64_t watch_addr;            /* its address (valid when watch_hit)      */
};

/****************************************************************
 * Hex and packet transport
 ****************************************************************/

static int
hexval(int c)
{
    if (c >= '0' && c <= '9') return c - '0';
    if (c >= 'a' && c <= 'f') return c - 'a' + 10;
    if (c >= 'A' && c <= 'F') return c - 'A' + 10;
    return -1;
}

static char
hexdig(int v)
{
    return "0123456789abcdef"[v & 0xf];
}

static int
write_all(int fd, const void *buf, size_t len)
{
    const char *p = buf;

    while (len) {
        ssize_t n = write(fd, p, len);
        if (n < 0) {
            if (errno == EINTR) continue;
            return -1;
        }
        p += n;
        len -= (size_t)n;
    }
    return 0;
}

/* Read one byte, blocking.  Returns 0 and the byte, or -1 on EOF/error. */
static int
read_byte(int fd, unsigned char *c)
{
    for (;;) {
        ssize_t n = read(fd, c, 1);
        if (n == 1) return 0;
        if (n == 0) return -1;
        if (errno == EINTR) continue;
        return -1;
    }
}

/* Append the $...#cc frame for `payload` and send it, honoring ack mode. */
static int
send_packet(struct gdb *s, const char *payload)
{
    char buf[PKT_MAX + 8];
    unsigned sum = 0;
    size_t i, len = strlen(payload);

    if (len + 5 > sizeof buf)
        return -1;
    buf[0] = '$';
    for (i = 0; i < len; i++) {
        buf[1 + i] = payload[i];
        sum += (unsigned char)payload[i];
    }
    buf[1 + len] = '#';
    buf[2 + len] = hexdig((sum >> 4) & 0xf);
    buf[3 + len] = hexdig(sum & 0xf);
    for (;;) {
        unsigned char ack;
        if (write_all(s->fd, buf, len + 4))
            return -1;
        if (!s->ack_mode)
            return 0;
        if (read_byte(s->fd, &ack))
            return -1;
        if (ack == '+')
            return 0;
        if (ack == '-')
            continue;               /* resend on a NAK */
        return 0;                   /* unexpected: treat as delivered */
    }
}

/* Receive one packet payload into `out` (NUL-terminated).  Returns the length,
   -1 on EOF/error, or -2 when a raw Ctrl-C (0x03) interrupt byte arrived in
   place of a packet.  Leading `+`/`-` acks are skipped. */
static int
recv_packet(struct gdb *s, char *out, size_t cap)
{
    unsigned char c;
    unsigned sum, want;
    size_t n;

    for (;;) {
        if (read_byte(s->fd, &c))
            return -1;
        if (c == 0x03)
            return -2;              /* interrupt request */
        if (c == '$')
            break;
        /* otherwise a stray ack or noise: ignore */
    }
    n = 0;
    sum = 0;
    for (;;) {
        if (read_byte(s->fd, &c))
            return -1;
        if (c == '#')
            break;
        if (n + 1 >= cap)
            return -1;
        out[n++] = (char)c;
        sum += c;
    }
    out[n] = '\0';
    {
        unsigned char h, l;
        if (read_byte(s->fd, &h) || read_byte(s->fd, &l))
            return -1;
        want = (unsigned)((hexval(h) << 4) | hexval(l));
    }
    if (s->ack_mode) {
        char a = (want == (sum & 0xff)) ? '+' : '-';
        if (write_all(s->fd, &a, 1))
            return -1;
        if (a == '-')
            return recv_packet(s, out, cap);    /* bad checksum: await resend */
    }
    return (int)n;
}

/* Is a raw 0x03 interrupt byte waiting on the socket?  Non-blocking. */
static int
interrupt_pending(int fd)
{
    unsigned char c;
    ssize_t n = recv(fd, &c, 1, MSG_DONTWAIT);

    return (n == 1 && c == 0x03);
}

/****************************************************************
 * Stop replies and execution
 ****************************************************************/

/* Send the stop reply for the current state: W<code> when the guest has exited,
   a T<sig>watch:<addr>; when a write watchpoint fired, else S<sig>. */
static int
send_stop(struct gdb *s)
{
    char buf[48];
    if (s->t->exited(s->ctx))
        snprintf(buf, sizeof buf, "W%02x", s->t->exit_code(s->ctx) & 0xff);
    else if (s->watch_hit)
        snprintf(buf, sizeof buf, "T%02xwatch:%llx;", 5,
                 (unsigned long long)s->watch_addr);
    else
        snprintf(buf, sizeof buf, "S%02x", s->t->stop_signal(s->ctx));
    return send_packet(s, buf);
}

static int
is_breakpoint(struct gdb *s, uint64_t pc)
{
    int i;
    for (i = 0; i < s->nbp; i++)
        if (s->bp[i] == pc)
            return 1;
    return 0;
}

/* Snapshot the current bytes of every active watchpoint range.  Taken at the
   start of each run so a memory write by the debugger (M packet) between stops
   does not read back as a guest write. */
static void
watch_snapshot(struct gdb *s)
{
    int i;
    uint32_t j;
    for (i = 0; i < s->nwp; i++)
        for (j = 0; j < s->wp[i].len; j++)
            s->wp[i].shadow[j] = s->t->read8(s->ctx, s->wp[i].addr + j);
}

/* If a watched range changed since the snapshot, record the hit (for the stop
   reply), refresh the shadow so the next run starts clean, and return 1. */
static int
watch_check(struct gdb *s)
{
    int i;
    uint32_t j;
    for (i = 0; i < s->nwp; i++)
        for (j = 0; j < s->wp[i].len; j++)
            if (s->t->read8(s->ctx, s->wp[i].addr + j) != s->wp[i].shadow[j]) {
                s->watch_hit = 1;
                s->watch_addr = s->wp[i].addr;
                watch_snapshot(s);
                return 1;
            }
    return 0;
}

/* Continue: single-step until a breakpoint, exit, fault/halt, or an interrupt
   byte on the socket.  Returns 1 if the guest exited, else 0 (stopped). */
static int
do_continue(struct gdb *s)
{
    uint32_t steps = 0;
    int exited = 0;

    s->watch_hit = 0;
    watch_snapshot(s);
    if (s->t->run_begin)
        s->t->run_begin(s->ctx);
    for (;;) {
        int r = s->t->step(s->ctx);
        if (r == GDB_RUN_EXITED) {
            exited = 1;
            break;
        }
        if (r == GDB_RUN_STOP)          /* fault, trap, or halt */
            break;
        if (s->nwp && watch_check(s))   /* a watched range was written */
            break;
        if (is_breakpoint(s, s->t->get_pc(s->ctx)))
            break;
        if (((++steps) & (IRQ_STRIDE - 1)) == 0 && interrupt_pending(s->fd))
            break;                      /* Ctrl-C from the debugger */
    }
    if (s->t->run_end)
        s->t->run_end(s->ctx);
    return exited;
}

/****************************************************************
 * Packet dispatch
 ****************************************************************/

/* Returns 1 to keep serving, 0 to end the session. */
static int
handle_packet(struct gdb *s, const char *p)
{
    char out[PKT_MAX];

    switch (p[0]) {
    case '?':                           /* why stopped */
        return send_stop(s) == 0;

    case 'q':
        if (strncmp(p, "qSupported", 10) == 0) {
            if (s->t->target_xml)
                snprintf(out, sizeof out,
                         "PacketSize=%x;qXfer:features:read+", PKT_MAX - 1);
            else
                snprintf(out, sizeof out, "PacketSize=%x", PKT_MAX - 1);
            return send_packet(s, out) == 0;
        }
        if (s->t->target_xml && strncmp(p, "qXfer:features:read:", 20) == 0) {
            /* qXfer:features:read:ANNEX:OFFSET,LENGTH */
            const char *a = p + 20;
            unsigned long off, len;
            const char *comma;
            size_t xlen = strlen(s->t->target_xml);

            comma = strchr(a, ':');
            if (!comma)
                return send_packet(s, "E00") == 0;
            off = strtoul(comma + 1, (char **)&comma, 16);
            len = (*comma == ',') ? strtoul(comma + 1, NULL, 16) : 0;
            if (off >= xlen)
                return send_packet(s, "l") == 0;
            if (len > sizeof out - 2)
                len = sizeof out - 2;
            if (off + len >= xlen) {
                out[0] = 'l';
                memcpy(out + 1, s->t->target_xml + off, xlen - off);
                out[1 + (xlen - off)] = '\0';
            } else {
                out[0] = 'm';
                memcpy(out + 1, s->t->target_xml + off, len);
                out[1 + len] = '\0';
            }
            return send_packet(s, out) == 0;
        }
        if (strcmp(p, "qAttached") == 0)
            return send_packet(s, "1") == 0;
        if (p[1] == 'C' && p[2] == '\0')        /* current thread */
            return send_packet(s, "QC01") == 0;
        if (strcmp(p, "qfThreadInfo") == 0)
            return send_packet(s, "m01") == 0;
        if (strcmp(p, "qsThreadInfo") == 0)
            return send_packet(s, "l") == 0;
        if (strncmp(p, "qTStatus", 8) == 0)
            return send_packet(s, "") == 0;
        return send_packet(s, "") == 0;

    case 'H':                           /* set thread for subsequent ops */
        return send_packet(s, "OK") == 0;

    case 'g':                           /* read all registers */
        if (s->t->read_regs(s->ctx, out, sizeof out))
            return send_packet(s, "E01") == 0;
        return send_packet(s, out) == 0;

    case 'G':                           /* write all registers */
        return send_packet(s, s->t->write_regs(s->ctx, p + 1) ? "E01" : "OK") == 0;

    case 'p': {                         /* read one register */
        long n = strtol(p + 1, NULL, 16);
        if (!s->t->read_reg)
            return send_packet(s, "") == 0;
        if (n < 0 || s->t->read_reg(s->ctx, (int)n, out, sizeof out))
            return send_packet(s, "E01") == 0;
        return send_packet(s, out) == 0;
    }

    case 'P': {                         /* write one register: P n=val */
        const char *eq = strchr(p, '=');
        long n = strtol(p + 1, NULL, 16);
        if (!s->t->write_reg)
            return send_packet(s, "") == 0;
        if (!eq || n < 0 || s->t->write_reg(s->ctx, (int)n, eq + 1))
            return send_packet(s, "E01") == 0;
        return send_packet(s, "OK") == 0;
    }

    case 'm': {                         /* read memory: m addr,len */
        char *end;
        uint64_t addr = strtoull(p + 1, &end, 16);
        uint32_t len = (*end == ',') ? (uint32_t)strtoul(end + 1, NULL, 16) : 0;
        char *w = out;
        uint32_t i;

        if (len == 0)
            return send_packet(s, "E01") == 0;
        if (!s->t->mem_mapped(s->ctx, addr))
            return send_packet(s, "E01") == 0;
        if (len > (PKT_MAX - 1) / 2)
            len = (PKT_MAX - 1) / 2;
        for (i = 0; i < len; i++) {
            uint8_t b = s->t->read8(s->ctx, addr + i);
            *w++ = hexdig(b >> 4);
            *w++ = hexdig(b & 0xf);
        }
        *w = '\0';
        return send_packet(s, out) == 0;
    }

    case 'M': {                         /* write memory: M addr,len:data */
        char *end;
        uint64_t addr = strtoull(p + 1, &end, 16);
        uint32_t len = (*end == ',') ? (uint32_t)strtoul(end + 1, &end, 16) : 0;
        const char *data = (*end == ':') ? end + 1 : NULL;
        uint32_t i;

        if (!data || !s->t->mem_mapped(s->ctx, addr))
            return send_packet(s, "E01") == 0;
        for (i = 0; i < len; i++) {
            int hi = hexval(data[2 * i]), lo = hexval(data[2 * i + 1]);
            if (hi < 0 || lo < 0)
                return send_packet(s, "E01") == 0;
            s->t->write8(s->ctx, addr + i, (uint8_t)((hi << 4) | lo));
        }
        return send_packet(s, "OK") == 0;
    }

    case 'c':                           /* continue [addr] */
        if (p[1])
            s->t->set_pc(s->ctx, strtoull(p + 1, NULL, 16));
        do_continue(s);
        return send_stop(s) == 0;

    case 's':                           /* single step [addr] */
        if (p[1])
            s->t->set_pc(s->ctx, strtoull(p + 1, NULL, 16));
        s->watch_hit = 0;
        if (!s->t->exited(s->ctx)) {
            if (s->nwp)
                watch_snapshot(s);      /* baseline before the step */
            if (s->t->run_begin)
                s->t->run_begin(s->ctx);
            s->t->step(s->ctx);
            if (s->t->run_end)
                s->t->run_end(s->ctx);
            if (s->nwp)                 /* a watched write this step is a hit */
                watch_check(s);
        }
        return send_stop(s) == 0;

    case 'Z':                           /* insert bp (Z0) or write watch (Z2) */
        if (p[1] == '0') {
            uint64_t addr = strtoull(p + 3, NULL, 16);
            if (!is_breakpoint(s, addr)) {
                if (s->nbp >= BP_MAX)
                    return send_packet(s, "E01") == 0;
                s->bp[s->nbp++] = addr;
            }
            return send_packet(s, "OK") == 0;
        }
        if (p[1] == '2') {              /* Z2,addr,kind — kind is the length */
            char *end;
            uint64_t addr = strtoull(p + 3, &end, 16);
            uint32_t len = (*end == ',') ? (uint32_t)strtoul(end + 1, NULL, 16) : 1;
            int i;
            if (len == 0 || len > WATCH_MAXLEN)
                return send_packet(s, "E01") == 0; /* gdb falls back to sw watch */
            for (i = 0; i < s->nwp; i++)
                if (s->wp[i].addr == addr && s->wp[i].len == len)
                    return send_packet(s, "OK") == 0;
            if (s->nwp >= WP_MAX)
                return send_packet(s, "E01") == 0;
            s->wp[s->nwp].addr = addr;
            s->wp[s->nwp].len = len;
            s->nwp++;
            return send_packet(s, "OK") == 0;
        }
        return send_packet(s, "") == 0; /* Z1/Z3/Z4 unsupported */

    case 'z':                           /* remove bp (z0) or write watch (z2) */
        if (p[1] == '0') {
            uint64_t addr = strtoull(p + 3, NULL, 16);
            int i;
            for (i = 0; i < s->nbp; i++)
                if (s->bp[i] == addr) {
                    s->bp[i] = s->bp[--s->nbp];
                    break;
                }
            return send_packet(s, "OK") == 0;
        }
        if (p[1] == '2') {
            char *end;
            uint64_t addr = strtoull(p + 3, &end, 16);
            uint32_t len = (*end == ',') ? (uint32_t)strtoul(end + 1, NULL, 16) : 1;
            int i;
            for (i = 0; i < s->nwp; i++)
                if (s->wp[i].addr == addr && s->wp[i].len == len) {
                    s->wp[i] = s->wp[--s->nwp];
                    break;
                }
            return send_packet(s, "OK") == 0;
        }
        return send_packet(s, "") == 0;

    case 'D':                           /* detach */
        send_packet(s, "OK");
        return 0;

    case 'k':                           /* kill */
        return 0;

    default:
        return send_packet(s, "") == 0; /* unsupported: empty reply */
    }
}

/****************************************************************
 * Server setup and loop
 ****************************************************************/

static int
listen_accept(int port)
{
    int ls, conn, yes = 1;
    struct sockaddr_in addr;

    ls = socket(AF_INET, SOCK_STREAM, 0);
    if (ls < 0)
        return -1;
    setsockopt(ls, SOL_SOCKET, SO_REUSEADDR, &yes, sizeof yes);
    memset(&addr, 0, sizeof addr);
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
    addr.sin_port = htons((uint16_t)port);
    if (bind(ls, (struct sockaddr *)&addr, sizeof addr) < 0 ||
        listen(ls, 1) < 0) {
        close(ls);
        return -1;
    }
    fprintf(stderr, "skj-run: gdb server listening on 127.0.0.1:%d\n", port);
    fflush(stderr);
    conn = accept(ls, NULL, NULL);
    close(ls);
    if (conn < 0)
        return -1;
    setsockopt(conn, IPPROTO_TCP, TCP_NODELAY, &yes, sizeof yes);
    return conn;
}

int
gdb_serve(const struct gdb_target *t, void *ctx, int port, int *exit_code)
{
    struct gdb s;
    char pkt[PKT_MAX];

    memset(&s, 0, sizeof s);
    s.ack_mode = 1;
    s.t = t;
    s.ctx = ctx;

    s.fd = listen_accept(port);
    if (s.fd < 0) {
        fprintf(stderr, "skj-run: gdb server could not listen on port %d\n",
                port);
        return -1;
    }

    for (;;) {
        int n = recv_packet(&s, pkt, sizeof pkt);
        if (n == -1)
            break;                      /* connection closed */
        if (n == -2) {                  /* an interrupt between packets */
            send_stop(&s);
            continue;
        }
        if (n == 0)
            continue;                   /* empty packet */
        if (!handle_packet(&s, pkt))
            break;
    }

    close(s.fd);
    if (exit_code)
        *exit_code = t->exited(ctx) ? t->exit_code(ctx) : 0;
    return 0;
}
