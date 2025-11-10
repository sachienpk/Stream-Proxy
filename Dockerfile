FROM rclone/rclone:latest
WORKDIR /app
EXPOSE 8080

# Install Python3 for fallback HTTP server
RUN apk add --no-cache python3 bash

# Create rclone config inside Dockerfile
RUN mkdir -p /config && \
    echo "[mega]" > /config/rclone.conf && \
    echo "type = mega" >> /config/rclone.conf && \
    echo "user = sastro.u.03@gmail.com" >> /config/rclone.conf && \
    echo "pass = D3dODTYFeAdveKS_7SzKR52wc-brz_yccIaJtg" >> /config/rclone.conf

ENV RCLONE_CONFIG=/config/rclone.conf

# Single CMD with fallback
CMD bash -c ' \
echo "===== Starting MEGA Proxy ====="; \
rclone serve http mega: --addr :8080 --vfs-cache-mode full --config /config/rclone.conf || \
(echo "<html><body><h1>MEGA Proxy Failed</h1><p>Check rclone configuration.</p></body></html>" > /app/fail.html && python3 -m http.server 8080 --bind 0.0.0.0 --directory /app) \
'
