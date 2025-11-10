FROM rclone/rclone:latest

WORKDIR /app
COPY . /app

EXPOSE 8080

# Use a shell script as entrypoint for logging
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
