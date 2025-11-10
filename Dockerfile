FROM alpine:latest
WORKDIR /app
EXPOSE 8080

# Install required tools
RUN apk add --no-cache rclone bash python3

# CMD: create config, start rclone, fallback if fails
CMD ["bash","-c","\
mkdir -p /config && \
echo '[mega]' > /config/rclone.conf && \
echo 'type = mega' >> /config/rclone.conf && \
echo 'user = sastro.u.03@gmail.com' >> /config/rclone.conf && \
echo 'pass = D3dODTYFeAdveKS_7SzKR52wc-brz_yccIaJtg' >> /config/rclone.conf && \
export RCLONE_CONFIG=/config/rclone.conf && \
echo '===== Starting MEGA Proxy =====' && \
rclone serve http mega: --addr :8080 --vfs-cache-mode minimal --config /config/rclone.conf || \
(echo '<html><body><h1>MEGA Proxy Failed</h1><p>Check rclone configuration.</p></body></html>' > /app/fail.html && python3 -m http.server 8080 --bind 0.0.0.0 --directory /app) \
"]
