#!/bin/bash

# Všeobecná interná funkcia na formátovanie logov
# Použitie: _log_msg "ÚROVEŇ" "správa" [cieľový kanál]
_log_msg() {
	local level="$1"
	shift
	local timestamp
	timestamp=$(date '+%Y-%m-%d %H:%M:%S')

	# Prejdeme stack volaní a nájdeme prvý skript, ktorý nie je logger.sh
	local caller_script="unknown"
	for source in "${BASH_SOURCE[@]}"; do
		local name
		name=$(basename "$source")
		if [ "$name" != "logger.sh" ] && [ -n "$name" ]; then
			caller_script="$name"
			break
		fi
	done

	# Ak sa loguje priamo z interaktívneho terminálu
	if [ "$caller_script" = "unknown" ]; then
		caller_script="main"
	fi

	# Výpis na správny kanál
	if [ "$level" = "ERROR" ]; then
		echo "${timestamp} – ${level} [${caller_script}] – $*" >&2
	else
		echo "${timestamp} – ${level} [${caller_script}] – $*"
	fi
}

# Verejné funkcie pre tvoje skripty
log-debug() {
	_log_msg "DEBUG" "$*"
}

log-info() {
	_log_msg "INFO" "$*"
}

log-warn() {
	_log_msg "WARN" "$*"
}

log-error() {
	_log_msg "ERROR" "$*"
}
