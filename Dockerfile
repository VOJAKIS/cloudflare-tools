# Dockerrize this biatch
FROM alpine:3.24.1

# Install dependencies & create nonroot user (security reasons)
RUN apk add --no-cache bash curl jq coreutils \
		&& addgroup -S nonroot \
    && adduser -S nonroot -G nonroot

WORKDIR /app

# Copy scripts
COPY main.sh get-ip.sh update-cloudflare.sh logger.sh check-ip-providers.txt ./

# Enable execution of scripts
RUN chmod +x main.sh get-ip.sh update-cloudflare.sh logger.sh

# Switch to nonroot user
USER nonroot

# Run main script
CMD ["/app/main.sh"]