# Base image
FROM alpine:latest
WORKDIR /app
EXPOSE 8080

# Install required tools: rclone, bash, python3
RUN apk add --no-cache rclone bash python3

# Set environment variable for rclone config path
ENV RCLONE_CONFIG=/config/rclone.conf

# CMD with fallback page if rclone fails
CMD bash -c '
# Create rclone config
mkdir -p /config
cat <<EOF >/config/rclone.conf
[mega]
type = mega
user = sastro.u.03@gmail.com
pass = D3dODTYFeAdveKS_7SzKR52wc-brz_yccIaJtg
EOF

echo "===== Starting MEGA Proxy ====="

# Try to run rclone HTTP server
rclone serve http mega: --addr :8080 --vfs-cache-mode full --config /config/rclone.conf || \
(
  echo "rclone failed, serving fallback page..."
  echo "<html><body><h1>MEGA Proxy Failed</h1><p>Check rclone configuration.</p></body></html>" > /app/fail.html
  python3 -m http.server 8080 --bind 0.0.0.0 --directory /app
)
'
