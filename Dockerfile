FROM rclone/rclone:latest
WORKDIR /app
EXPOSE 8080

# Install Python for fallback HTTP server
RUN apk add --no-cache python3 py3-pip bash

# All-in-one startup script
CMD bash -c '
# Create rclone config
mkdir -p /config
cat <<EOF >/config/rclone.conf
[mega]
type = mega
user = sastro.u.03@gmail.com
pass = D3dODTYFeAdveKS_7SzKR52wc-brz_yccIaJtg
EOF

export RCLONE_CONFIG=/config/rclone.conf

# Try to start rclone HTTP server
echo "===== Starting MEGA Proxy ====="
rclone serve http mega: --addr :8080 --vfs-cache-mode full --config /config/rclone.conf
STATUS=$?

# If rclone fails, serve fallback page
if [ $STATUS -ne 0 ]; then
  echo "rclone failed, starting fallback HTTP server..."
  echo "<html><body><h1>MEGA Proxy Failed</h1><p>Check rclone configuration.</p></body></html>" > /app/fail.html
  python3 -m http.server 8080 --bind 0.0.0.0 --directory /app
fi
'
