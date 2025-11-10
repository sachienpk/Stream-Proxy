#!/bin/sh
set -e

echo "===== MEGA Proxy Startup ====="

# Log environment variables (mask password)
echo "RCLONE_CONFIG_MEGA_TYPE: $RCLONE_CONFIG_MEGA_TYPE"
echo "RCLONE_CONFIG_MEGA_USER: $RCLONE_CONFIG_MEGA_USER"
if [ -z "$RCLONE_CONFIG_MEGA_PASS" ]; then
    echo "RCLONE_CONFIG_MEGA_PASS is NOT set!"
else
    echo "RCLONE_CONFIG_MEGA_PASS is set (hidden)"
fi

# Generate rclone config from env vars if not present
if [ ! -f /config/rclone.conf ]; then
    echo "Creating rclone config from environment variables..."
    mkdir -p /config
    cat <<EOF >/config/rclone.conf
[mega]
type = ${RCLONE_CONFIG_MEGA_TYPE}
user = ${RCLONE_CONFIG_MEGA_USER}
pass = ${RCLONE_CONFIG_MEGA_PASS}
EOF
else
    echo "rclone.conf already exists, using existing configuration."
fi

echo "Listing configured remotes:"
rclone listremotes --config /config/rclone.conf

echo "Starting rclone serve http..."
rclone serve http mega: --addr :8080 --vfs-cache-mode full --config /config/rclone.conf
