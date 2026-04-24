# systemd Hardening for boris

systemd provides OS-level sandboxing that works independently of -- or
alongside -- boris's built-in Landlock and seccomp filters. This is
useful on kernels too old for Landlock (pre-5.13) or as defense in depth.

## Hardened Unit File

Save as `/etc/systemd/system/boris.service`:

```ini
[Unit]
Description=boris MUD server
After=network.target

[Service]
Type=simple
WorkingDirectory=/opt/boris
ExecStart=/opt/boris/bin/boris
Restart=on-failure
RestartSec=5

# Run as a dynamic unprivileged user (no shell, no home)
DynamicUser=yes
StateDirectory=boris

# Filesystem restrictions
ProtectSystem=strict
ProtectHome=yes
PrivateTmp=yes
ReadWritePaths=/opt/boris/data/muddb
ReadOnlyPaths=/opt/boris/data/help /opt/boris/data/text /opt/boris/data/forms /opt/boris/data/unicode /opt/boris/bin/www

# Capabilities
NoNewPrivileges=yes
CapabilityBoundingSet=
AmbientCapabilities=

# If running on a privileged port (<1024), add:
#   AmbientCapabilities=CAP_NET_BIND_SERVICE
#   CapabilityBoundingSet=CAP_NET_BIND_SERVICE

# Syscall filtering
SystemCallFilter=@system-service
SystemCallFilter=~@privileged @resources @mount @swap @reboot @module @debug

# Network
RestrictAddressFamilies=AF_INET AF_INET6 AF_UNIX
PrivateNetwork=no

# Namespace and device isolation
ProtectKernelTunables=yes
ProtectKernelModules=yes
ProtectKernelLogs=yes
ProtectControlGroups=yes
ProtectClock=yes
PrivateDevices=yes
DeviceAllow=/dev/urandom r
RestrictNamespaces=yes
LockPersonality=yes
MemoryDenyWriteExecute=yes
RestrictRealtime=yes
RestrictSUIDSGID=yes

[Install]
WantedBy=multi-user.target
```

## Installation

```sh
# Install boris
sudo mkdir -p /opt/boris
sudo cp -r bin data boris.cfg /opt/boris/

# Create the LMDB data directory
sudo mkdir -p /opt/boris/data/muddb

# Install and start the service
sudo cp boris.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now boris
```

## How It Works

**DynamicUser** allocates a transient UID/GID with no login shell. The
process cannot escalate to root.

**ProtectSystem=strict** mounts the entire filesystem read-only except
paths listed in `ReadWritePaths`. Combined with `ProtectHome` and
`PrivateTmp`, boris can only write to its database directory.

**SystemCallFilter** uses systemd's predefined syscall groups. The
`@system-service` set allows syscalls typical for network daemons, then
the `~` exclusions remove dangerous categories (privileged operations,
mount, swap, reboot, kernel modules, debugging).

**MemoryDenyWriteExecute** prevents mapping memory as both writable and
executable, blocking most shellcode injection techniques.

**RestrictNamespaces** prevents creating new user/mount/pid namespaces,
closing a common container-escape vector.

## Using with In-Process Sandboxing

The systemd unit and boris's built-in Landlock/seccomp are complementary:

- **systemd alone**: Set `security.landlock=0` and `security.seccomp=0`
  in `boris.cfg`. systemd handles all restriction. Works on any kernel
  version with systemd 232+.

- **In-process alone**: Run boris without systemd or with a minimal unit
  file. Landlock requires Linux 5.13+; seccomp requires Linux 3.5+.

- **Both (recommended)**: Leave all defaults. systemd provides the outer
  sandbox (filesystem, user, capabilities), boris provides the inner
  sandbox (fine-grained filesystem rules, targeted syscall deny-list).
  If one layer has a gap, the other catches it.

## Verifying

```sh
# Check active security features
sudo systemd-analyze security boris.service

# Watch boris logs for sandbox status
journalctl -u boris -f
```

The `systemd-analyze security` command scores the unit's hardening. A
well-configured unit should score below 3.0 (out of 10).
