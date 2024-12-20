#!/bin/bash

# Initialize the HTML log file
LOG_FILE="performance_report.html"

function initialize_log() {
    echo "<html><head><title>Performance Report</title></head><body>" > "$LOG_FILE"
    echo "<h1>Performance Report</h1>" >> "$LOG_FILE"
    echo "<p>Generated on: $(date)</p><hr>" >> "$LOG_FILE"
}

function finalize_log() {
    echo "</body></html>" >> "$LOG_FILE"
    zenity --info --title="Report Generated" --text="The performance report has been saved to $LOG_FILE."
}

function log_to_file() {
    local title="$1"
    local content="$2"
    echo "<h2>$title</h2>" >> "$LOG_FILE"
    echo "<pre>$content</pre><hr>" >> "$LOG_FILE"
}

function show_menu() {
    zenity --list --title="Task Manager Clone - Performance Tester" \
        --text="Choose an option:" \
        --column="Option" --column="Description" \
        1 "CPU Usage" \
        2 "GPU Usage" \
        3 "Disk Usage" \
        4 "Memory Usage" \
        5 "Network Stats" \
        6 "System Load Metrics" \
        7 "Exit"
}

function cpu_usage() {
    result=$(top -bn1 | grep "Cpu(s)")
    log_to_file "CPU Usage" "$result"
    echo "$result" | zenity --text-info --title="CPU Usage" --width=600 --height=400
}

function gpu() {
    gpu_usage=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits)
    gpu_temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits)
    gpu_memory=$(nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits)
    result="GPU Utilization: $gpu_usage%\nGPU Temperature: $gpu_temp°C\nGPU Memory Usage: $gpu_memory MiB"
    log_to_file "GPU Usage" "$result"
    zenity --info --title="GPU Usage" --text="$result" --width=300
}

function disk_usage() {
    summary=$(df -h && sudo smartctl -H /dev/sda | grep "SMART Health Status")
    log_to_file "Disk Usage Summary" "$summary"
    echo "$summary" | zenity --text-info --title="Disk Usage Summary" --width=600 --height=400
}

function memory_usage() {
    total=$(grep MemTotal /proc/meminfo | awk '{print $2 / 1024 " MB"}')
    free=$(grep MemFree /proc/meminfo | awk '{print $2 / 1024 " MB"}')
    result="Total Memory: $total\nFree Memory: $free"
    log_to_file "Memory Usage" "$result"
    zenity --info --title="Memory Usage" --text="$result" --width=300
}

function network_stat() {
    interface="eth0"
    stats=$(grep "$interface" /proc/net/dev | awk '{print "RX Bytes: " $2 ", TX Bytes: " $10}')
    result="$(date): $stats"
    log_to_file "Network Stats" "$result"
    zenity --info --title="Network Stats" --text="$result" --width=400
}

function system_load() {
    load=$(uptime)
    log_to_file "System Load Metrics" "$load"
    zenity --info --title="System Load Metrics" --text="$load" --width=300
}

# Initialize the log file
initialize_log

# Main loop
while true; do
    option=$(show_menu)

    case $option in
        1) cpu_usage ;;
        2) gpu ;;
        3) disk_usage ;;
        4) memory_usage ;;
        5) network_stat ;;
        6) system_load ;;
        7) finalize_log; exit 0 ;;
        *) zenity --error --title="Invalid Option" --text="Please select a valid option." ;;
    esac
done
