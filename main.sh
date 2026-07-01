#!/bin/bash

. ./logger.sh

INTERVAL_SECONDS=${CHECK_INTERVAL:-5m}
LAST_IP_FILE="/data/last_ip.txt"

log-info "Starting main DDNS manager."
log-info "Going to check every: $INTERVAL_SECONDS"

while true; do
	log-info "Starting get IP script."
	GET_IP_SCRIPT_OUTPUT=$(/app/get-ip.sh)
	log-debug "Output from script: $GET_IP_SCRIPT_OUTPUT"
	CURRENT_IP=$(echo "$GET_IP_SCRIPT_OUTPUT" | tail -n1)
	log-debug "IP from script: $CURRENT_IP"

	if [ $? -ne 0 ] || [ -z "$CURRENT_IP" ]; then
		log-error "Could not get IP address."
	else
		log-info "Loading last saved IP address."
		[ -f "$LAST_IP_FILE" ] && LAST_IP=$(cat "$LAST_IP_FILE") || LAST_IP=""

		# 2. Change check
		if [ "$CURRENT_IP" != "$LAST_IP" ]; then
			log-info "IP change detected. Old: '$LAST_IP', New: '$CURRENT_IP'"

			log-info "Starting Cloudflare update script."
			/app/update-cloudflare.sh "$CURRENT_IP"

			# If script ran successfully, then save the "new" (=currnet) IP to file
			if [ $? -eq 0 ]; then
				log-info "Saving current IP to last IP file."
				echo "$CURRENT_IP" >"$LAST_IP_FILE"
			fi
		fi
	fi

	log-info "Starting sleeping..."
	sleep "$INTERVAL_SECONDS"
done

log-warn "Main script is existing..."
