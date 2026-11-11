#!/usr/bin/env bash

# Linux System Health Monitoring Script
# Project: Bash Automation

set -u

# Find the project directory, regardless of where the script is run from
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="$SCRIPT_DIR/logs"
LOG_FILE="$LOG_DIR/health_monitor.log"

# Alert thresholds
CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80

mkdir -p "$LOG_DIR"

# Print to terminal and append to log file
log() {
    local message="$1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $message" | tee -a "$LOG_FILE"
}

# Calculate CPU usage using two readings from /proc/stat
get_cpu_usage() {
    local user1 nice1 system1 idle1 iowait1 irq1 softirq1 steal1
    local user2 nice2 system2 idle2 iowait2 irq2 softirq2 steal2
    local total1 total2 idle_total1 idle_total2 total_diff idle_diff

    read -r _ user1 nice1 system1 idle1 iowait1 irq1 softirq1 steal1 _ < /proc/stat
    total1=$((user1 + nice1 + system1 + idle1 + iowait1 + irq1 + softirq1 + steal1))
    idle_total1=$((idle1 + iowait1))

    sleep 1

    read -r _ user2 nice2 system2 idle2 iowait2 irq2 softirq2 steal2 _ < /proc/stat
    total2=$((user2 + nice2 + system2 + idle2 + iowait2 + irq2 + softirq2 + steal2))
    idle_total2=$((idle2 + iowait2))

    total_diff=$((total2 - total1))
    idle_diff=$((idle_total2 - idle_total1))

    if (( total_diff > 0 )); then
        echo $(( (100 * (total_diff - idle_diff)) / total_diff ))
    else
        echo 0
    fi
}

# Get memory usage percentage
get_memory_usage() {
    free | awk '/^Mem:/ {printf "%.0f", ($3 / $2) * 100}'
}

# Get disk usage percentage for the root filesystem
get_disk_usage() {
    df -P / | awk 'NR==2 {gsub("%", "", $5); print $5}'
}

# Check CPU
check_cpu() {
    local usage
    usage="$(get_cpu_usage)"

    log "CPU Usage: ${usage}%"

    if (( usage >= CPU_THRESHOLD )); then
        log "WARNING: CPU usage is above ${CPU_THRESHOLD}%"
    else
        log "OK: CPU usage is normal"
    fi
}

# Check memory
check_memory() {
    local usage
    usage="$(get_memory_usage)"

    log "Memory Usage: ${usage}%"

    if (( usage >= MEMORY_THRESHOLD )); then
        log "WARNING: Memory usage is above ${MEMORY_THRESHOLD}%"
    else
        log "OK: Memory usage is normal"
    fi
}

# Check disk space
check_disk() {
    local usage
    usage="$(get_disk_usage)"

    log "Disk Usage: ${usage}%"

    if (( usage >= DISK_THRESHOLD )); then
        log "WARNING: Disk usage is above ${DISK_THRESHOLD}%"
    else
        log "OK: Disk usage is normal"
    fi
}

# Check internet connectivity and DNS/HTTPS access
check_network() {
    if curl -fsS --max-time 5 https://example.com -o /dev/null; then
        log "OK: Network connectivity is working"
    else
        log "WARNING: Could not reach https://example.com"
    fi
}

# Check whether Nginx is running
check_nginx() {
    if systemctl is-active --quiet nginx; then
        log "OK: Nginx service is running"
    else
        log "WARNING: Nginx service is not running"
    fi
}

# Check system uptime
check_uptime() {
    local uptime_info
    uptime_info="$(uptime -p)"
    log "System Uptime: $uptime_info"
}

# Main execution
log "========== HEALTH CHECK STARTED =========="

check_cpu
check_memory
check_disk
check_network
check_nginx
check_uptime

log "========== HEALTH CHECK COMPLETED =========="
log " "
