#!/bin/bash

. logger.sh

PROVIDERS_FILE="check-ip-providers.txt"

if [ ! -f "$PROVIDERS_FILE" ]; then
	log-error "File $PROVIDERS_FILE does not exists." >&2
	return 1
fi

log-info "Starting to read file with providers."
while IFS= read -r provider || [ -n "$provider" ]; do
	# Cleaning provider off of the \\r character.
	provider="${provider//$'\r'/}"

	log-debug "Current provider: $provider"

	# Skipping empty lines and comments
	[[ -z "$provider" || "$provider" =~ ^# ]] && continue

	# Getting IP with 5 second timeout
	log-debug "Getting IP through provider: $provider"
	response=$(curl -s -m 5 "$provider")
	log-debug "Response: $response"
	temp_ip=$(echo $response | tr -d '[:space:]')
	log-info "New IP: $temp_ip"

	# Regex validation of IPv4 address
	if [[ $temp_ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
		log-info "Cached IP: $temp_ip"
		echo "$temp_ip"
		# Exiting with success code
		return 0
	else
		log-warn "IP '$temp_ip' is not valid."
	fi
done <"$PROVIDERS_FILE"

# Exiting with error code
return 1
