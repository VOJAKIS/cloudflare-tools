#!/bin/bash

. ./logger.sh

if [ -z "$1" ]; then
	log-error "No interval was provided as an argument, exiting." >&2
	return 1
fi

interval=$1

parse_seconds() {
	local val="$interval"
	case "$val" in
	*m) echo $((${val%m} * 60)) ;;
	*h) echo $((${val%h} * 3600)) ;;
	*d) echo $((${val%d} * 86400)) ;;
	*s) echo "${val%s}" ;;
	*) echo "$val" ;;
	esac
}

interval_sec=$(parse_seconds "$interval")

next_run=$(date -d "+${interval_sec} seconds" '+%Y-%m-%d %H:%M:%S')
echo $next_run
