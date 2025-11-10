FROM rclone/rclone:latest

# Copy rclone config (will use environment variables for secrets)
COPY . /app
WORKDIR /app

# Expose the port Render uses
EXPOSE 10000

# Start rclone HTTP server on MEGA remote
CMD ["rclone", "serve", "http", "mega:", "--addr", ":10000"]
