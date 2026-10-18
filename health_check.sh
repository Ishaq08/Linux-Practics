#!/usr/bin/env bash
# health_check.sh - basic server health report
# Usage: ./health_check.sh [service ...]   (default service: ssh)
set -u

SERVICES=("$@")
[[ ${#SERVICES[@]} -eq 0 ]] && SERVICES=(ssh)
problems=0

report() {   # report LEVEL MESSAGE
    printf '%-8s %s\n' "$1" "$2"
    [[ $1 == WARNING ]] && problems=1
}

echo "=== Health report: $(hostname) at $(date '+%F %T') ==="
echo "Uptime: $(uptime -p)"

# CPU load vs cores
cores=$(nproc)
load=$(awk '{print $1}' /proc/loadavg)
if awk -v l="$load" -v c="$cores" 'BEGIN{exit !(l > c)}'; then
    report WARNING "Load $load is above core count ($cores)"
else
    report OK "Load $load (cores: $cores)"
fi

# Memory available %
mem_pct=$(free | awk '/^Mem:/ {printf "%d", $7 / $2 * 100}')
if (( mem_pct < 15 )); then
    report WARNING "Only ${mem_pct}% memory available"
else
    report OK "${mem_pct}% memory available"
fi

# Root disk usage %
disk_pct=$(df -P / | awk 'NR==2 {gsub("%", "", $5); print $5}')
if (( disk_pct >= 80 )); then
    report WARNING "Root disk at ${disk_pct}%"
else
    report OK "Root disk at ${disk_pct}%"
fi

# Services
for svc in "${SERVICES[@]}"; do
    if systemctl is-active --quiet "$svc" 2>/dev/null; then
        report OK "Service $svc is active"
    else
        report WARNING "Service $svc is NOT active"
    fi
done

exit "$problems"
