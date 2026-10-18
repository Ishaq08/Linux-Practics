#!/usr/bin/env bash
# disk_alert.sh - alert when a filesystem reaches a usage threshold
# Usage: ./disk_alert.sh [threshold_percent]   (default 80)
set -u

THRESHOLD=${1:-80}
alert=0

if ! [[ $THRESHOLD =~ ^[0-9]+$ ]]; then
    echo "Threshold must be a number" >&2
    exit 2
fi

while read -r fs _ _ _ pct mount; do
    usage=${pct%\%}
    if (( usage >= THRESHOLD )); then
        echo "ALERT: $mount is at ${usage}% (device $fs, threshold ${THRESHOLD}%)"
        alert=1
    fi
done < <(df -P -x tmpfs -x devtmpfs -x squashfs -x overlay | tail -n +2)

if (( alert == 0 )); then
    echo "OK: all filesystems below ${THRESHOLD}%"
fi
exit "$alert"
