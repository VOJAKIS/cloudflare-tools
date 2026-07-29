#!/bin/bash

intervals=(10m 5m 30s 60)

now=$(date '+%Y-%m-%d %H:%M:%S')
echo "Now:             $now"

for interval in ${intervals[@]}; do
	printf "Interval: %-3s -> %s\n" "${interval}" "$(. next-check.sh ${interval})"
done
