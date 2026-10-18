#!/usr/bin/env bash
# log_analyser.sh - summarise a web access log (combined log format)
# Usage: ./log_analyser.sh [logfile]   (default /var/log/nginx/access.log)
set -u

LOG=${1:-/var/log/nginx/access.log}

if [[ ! -r $LOG ]]; then
    echo "Cannot read $LOG" >&2
    exit 1
fi

echo "=== Log report: $LOG ==="
echo "Total requests: $(wc -l < "$LOG")"

echo
echo "--- Top 5 client IPs ---"
awk '{print $1}' "$LOG" | sort | uniq -c | sort -rn | head -5

echo
echo "--- Requests per status code ---"
awk '{print $9}' "$LOG" | sort | uniq -c | sort -rn

echo
echo "--- Top 5 URLs ---"
awk '{print $7}' "$LOG" | sort | uniq -c | sort -rn | head -5

echo
echo "5xx errors: $(awk '$9 ~ /^5/ {n++} END {print n+0}' "$LOG")"
