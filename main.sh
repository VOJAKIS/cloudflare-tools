#!/bin/bash

. ./logger.sh

INTERVAL=${CHECK_INTERVAL:-5m}
LAST_IP_FILE="/data/last_ip.txt"

graceful_shutdown() {
	log-info "Received signal for shutdown. Immediately stopping container..."
	exit 0
}

# 2. Catching signals (SIGTERM = docker stop, SIGINT = Ctrl + C)
trap graceful_shutdown SIGTERM SIGINT

log-info "Starting main DDNS manager."
log-info "Check interval: $INTERVAL"

while true; do
	log-info "Starting get IP script."
	GET_IP_SCRIPT_OUTPUT=$(. get-ip.sh)
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
			. update-cloudflare.sh "$CURRENT_IP"

			# If script ran successfully, then save the "new" (=currnet) IP to file
			if [ $? -eq 0 ]; then
				log-info "Saving current IP to last IP file."
				echo -n "$CURRENT_IP" >"$LAST_IP_FILE"
			fi
		else
			log-info "IP was not changed since last update, old: '$LAST_IP', new: '$CURRENT_IP'"
		fi
	fi

	log-info "Next check will run at: $(. next-check.sh ${INTERVAL})"

	log-info "Starting sleeping..."
	sleep "$INTERVAL" &
	wait $!
done

log-warn "Main script is exiting..."
