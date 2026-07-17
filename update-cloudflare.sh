#!/bin/bash

. ./logger.sh

NEW_IP=$1

if [ -z "$NEW_IP" ]; then
	# echo "$(date '+%Y-%m-%d %H:%M:%S') - Chyba: Skriptu update-cloudflare nebola odovzdaná IP adresa." >&2
	log-error "No IP was provided as argument, exiting." >&2
	return 1
fi

# echo "$(date '+%Y-%m-%d %H:%M:%S') - Volám Cloudflare API pre $CLOUDFLARE_DOMAIN_NAME -> $NEW_IP"
log-info "Calling Cloudflare API for domain: $CLOUDFLARE_DOMAIN_NAME, new IP: $NEW_IP"

response=$(
	curl https://api.cloudflare.com/client/v4/zones/$CLOUDFLARE_ZONE_ID/dns_records/$CLOUDFLARE_DNS_RECORD_ID \
		-X PUT \
		-H 'Content-Type: application/json' \
		-H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
		--silent \
		-d '{
          "name": "'$CLOUDFLARE_DOMAIN_NAME'",
          "ttl": 1,
          "type": "A",
          "comment": "Updated with CloudflareTools – DNS updater.",
          "content": "'$NEW_IP'",
          "proxied": true
        }'
)

success=$(echo "$response" | jq -r '.success')

if [ "$success" = "true" ]; then
	# echo "$(date '+%Y-%m-%d %H:%M:%S') - Cloudflare DNS bol úspešne zmenený."
	log-info "Cloudflare DNS was successfully changed."
	return 0
else
	# echo "$(date '+%Y-%m-%d %H:%M:%S') - CHYBA pri aktualizácii Cloudflare:" >&2
	log-error "Cloudflare DNS was NOT successfully changed." >&2
	echo "$response" | jq . >&2
	return 1
fi
