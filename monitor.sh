# #!/bin/bash

# function show_menu() {
#     echo "Task Manager Clone - Performance Tester"
#     echo "1. CPU Usage"
#     echo "2. GPU Usage"
#     echo "3. Disk Usage"
# 	echo "4. Memory Usage"
#     echo "5. Network Stats"
#     echo "6. System Load Metrics"
#     echo "7. Exit"
# }

# function cpu_usage() {
# 	echo "============================"
#     echo "CPU Usage:"
#     while true; do
#         top -bn1 | grep "Cpu(s)"
#         sleep 1
#     done
# 	echo "============================"
# }

# function gpu() {
# 	echo "GPU Usage:"
# 	echo "============================"
#     while true; do
#         gpu_usage=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits)
# 		gpu_temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits)
# 		gpu_memory=$(nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits)
# 		echo "GPU Utilization: $gpu_usage%"
# 		echo "GPU Temperature: $gpu_temp°C"
# 		echo "GPU Memory Usage: $gpu_memory MiB"

#         sleep 1
#     done
# 	echo "============================"
# }

# function disk_usage() {
# 	echo "Disk Usage Summary:"
# 	echo "============================"
# 	df -h
# 	sudo smartctl -H /dev/sda | grep "SMART Health Status"
# 	sleep 1
# 	echo "============================"
# }

# function memory_usage() {
#     echo "Memory Usage:"
#     echo "============================"
#     total=$(grep MemTotal /proc/meminfo | awk '{print $2 / 1024 " MB"}')
# 	free=$(grep MemFree /proc/meminfo | awk '{print $2 / 1024 " MB"}')
# 	echo "Total Memory: $total"
# 	echo "Free Memory: $free"
#     echo "============================"
# }

# function network_stat() {
#     echo "network stats:"
#     interface="eth0"

# 	while true; do
# 		stats=$(grep "$interface" /proc/net/dev | awk '{print "RX Bytes: " $2 ", TX Bytes: " $10}')
# 		echo "$(date): $stats"
# 		sleep 1
# 	done
# }

# function system_load() {
# 	echo "System Load Metrics:"
# 	while true; do
# 		uptime
# 		sleep 1
# 	done
# }

# while true; do
#     show_menu
#     read -p "Choose an option: " option

#     case $option in
#         1) cpu_usage ;;
# 		2) gpu ;;  
#         3) disk_usage ;;
#         4) memory_usage ;;
#         5) network_stat ;;
#         6) system_load ;;
#         7) echo "Exiting..."; exit 0 ;;
#         *) echo "Invalid option. Please try again." ;;
#     esac

#     echo
# done

#!/bin/bash

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
    (
        echo "10" ; sleep 1
        echo "# Fetching CPU usage..." ; sleep 1
        top -bn1 | grep "Cpu(s)" | zenity --text-info --title="CPU Usage" --width=600 --height=400
        echo "100" ; sleep 1
    ) | zenity --progress --title="CPU Usage" --text="Monitoring CPU usage..." --width=300 --no-cancel
}

function gpu() {
        gpu_usage=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits)
        gpu_temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits)
        gpu_memory=$(nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits)
        
        zenity --info --title="GPU Usage" --text="\
		GPU Utilization: $gpu_usage%
		GPU Temperature: $gpu_temp°C
		GPU Memory Usage: $gpu_memory MiB" --width=300 
}

function disk_usage() {
    summary=$(df -h && sudo smartctl -H /dev/sda | grep "SMART Health Status")
    echo "$summary" | zenity --text-info --title="Disk Usage Summary" --width=600 --height=400
}

function memory_usage() {
    total=$(grep MemTotal /proc/meminfo | awk '{print $2 / 1024 " MB"}')
    free=$(grep MemFree /proc/meminfo | awk '{print $2 / 1024 " MB"}')
    zenity --info --title="Memory Usage" --text="\
	Total Memory: $total
	Free Memory: $free" --width=300
}

function network_stat() {
    interface="eth0"
	stats=$(grep "$interface" /proc/net/dev | awk '{print "RX Bytes: " $2 ", TX Bytes: " $10}')
	zenity --info --title="Network Stats" --text="\
	$(date): $stats" --width=400
}

function system_load() {

	load=$(uptime)
	zenity --info --title="System Load Metrics" --text="$load" --width=300

}

while true; do
    option=$(show_menu)

    case $option in
        1) cpu_usage ;;
        2) gpu ;;
        3) disk_usage ;;
        4) memory_usage ;;
        5) network_stat ;;
        6) system_load ;;
        7) zenity --info --title="Exit" --text="Exiting..."; exit 0 ;;
        *) zenity --error --title="Invalid Option" --text="Please select a valid option." ;;
    esac
done
