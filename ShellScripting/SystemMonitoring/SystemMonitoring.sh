#!/bin/zsh

printf "=========================================================================\n"
printf "%*s%s%*s\n" $(( (73 - 23) / 2 )) "" "Disk Space Management" $(( (73 - 23) / 2 )) ""
printf "=========================================================================\n\n"

# current diskspace used
read total_disk used_disk available_disk <<< $(df -h | awk '$9 == "/System/Volumes/Data" {print $2, $3, $4}')

# Print the table header for disk space
printf "--------------------------------------------------------\n" # 56 hyphens
printf "%-18s %-18s %-18s\n" "Total Disk Space" "Used Disk Space" "Available Disk Space"
printf "--------------------------------------------------------\n" # 56 hyphens
# Print the table data for disk space
printf "%-18s %-18s %-18s\n\n" "${total_disk}" "${used_disk}" "${available_disk}"

printf "=========================================================================\n"
printf "%*s%s%*s\n" $(( (73 - 15) / 2 )) "" "RAM Performance" $(( (73 - 15) / 2 )) ""
printf "=========================================================================\n\n"

# current ram used
page_size=$(sysctl -n hw.pagesize)

# Get vm_stat output and parse for active, inactive, and wired pages
active_pages=$(vm_stat | grep "Pages active:" | awk '{print $3}' | sed 's/\\.//')
inactive_pages=$(vm_stat | grep "Pages inactive:" | awk '{print $3}' | sed 's/\\.//')
wired_pages=$(vm_stat | grep "Pages wired down:" | awk '{print $4}' | sed 's/\\.//')

# Calculate total used pages
total_used_pages=$((active_pages + inactive_pages + wired_pages))

# Calculate total used memory in bytes
total_used_bytes=$((total_used_pages * page_size))

# Convert to GB for human-readable output
total_used_gb=$(LC_NUMERIC=C awk -v bytes="$total_used_bytes" 'BEGIN {printf "%.2f", bytes / (1024*1024*1024)}')

# Total RAM on system
# Get the total physical memory in bytes
total_memory_bytes=$(sysctl -n hw.memsize)

# Convert to GB for human-readable output using awk for floating-point division

total_memory_gb=$(LC_NUMERIC=C awk -v bytes="$total_memory_bytes" 'BEGIN {printf "%.2f", bytes / (1024*1024*1024)}')

export LANG=C

# Perform the calculation using bc with a here document
# The 'scale' command sets the number of decimal places for the result
ram_percentage=$(bc -l << EOF_BC
scale=2
($total_used_gb / $total_memory_gb)*100
EOF_BC
)

# Print the table header
printf "--------------------------------------------------------\n" # 56 hyphens
printf "%-18s %-18s %-10s\n" "Used RAM (GB)" "Total RAM (GB)" "Used %"
printf "--------------------------------------------------------\n" # 56 hyphens
# Print the table data
printf "%-18.2f %-18.2f %-10.2f\n" "${total_used_gb}" "${total_memory_gb}" "${ram_percentage}"
printf "--------------------------------------------------------\n" # 56 hyphens

# CPU usage
printf "\n=========================================\n"
printf "  CPU Usage (Snapshot)  \n"
printf "=========================================\n\n"

# Get the CPU usage line from top -l 1 and extract percentages using sed
# This command directly extracts user, sys, and idle percentages.
CPU_PERCS=$(top -l 1 | grep "CPU usage:" | sed 's/CPU usage: \(.*\) user, \(.*\) sys, \(.*\) idle/\1 \2 \3/')

if [[ -z "$CPU_PERCS" ]]; then
    printf "Error: Could not retrieve CPU usage data. The 'CPU usage' line was not found or could not be parsed.\n"
    exit 1
fi

# Read the extracted percentages into individual variables
read user_cpu sys_cpu idle_cpu <<< "$CPU_PERCS"

printf "CPU Usage Breakdown:\n"
printf "----------------------\n"
printf "%-10s %s%%\n" "User:" "$user_cpu"
printf "%-10s %s%%\n" "System:" "$sys_cpu"
printf "%-10s %s%%\n" "Idle:" "$idle_cpu"
printf "----------------------\n\n"


#--- Configuration ---

INTERFACE="en0" # Set your desired network interface here (e.g., en0, en1, en6, Wi-Fi, Ethernet)

printf "\n======================================================\n"
printf "  Network Interface KPIs for: %s  \n" "${INTERFACE}"
printf "======================================================\n\n"

# --- 1. Get detailed statistics from netstat -ib ---
# Columns: Ipkts Ierrs Ibytes Opkts Oerrs Obytes
read Ipkts Ierrs Ibytes Opkts Oerrs Obytes <<< $(netstat -ib | awk -v iface="${INTERFACE}" '$1 == iface {print $5, $6, $7, $8, $9, $10; exit}')

if [[ -z "${Ipkts}" ]]; then
    printf "Error: Interface '%s' not found or no data available.\n" "${INTERFACE}"
    exit 1
fi

printf "Network Traffic (Cumulative since boot/last reset):\n"
printf "---------------------------------------------------\n"
printf "%-15s %-15s %-15s\n" "Metric" "Received" "Transmitted"
printf "---------------------------------------------------\n"
printf "%-15s %-15s %-15s\n" "Packets:" "${Ipkts}" "${Opkts}"
printf "%-15s %-15s %-15s\n" "Bytes:" "${Ibytes}" "${Obytes}"
printf "%-15s %-15s %-15s\n" "Errors:" "${Ierrs}" "${Oerrs}"
printf "---------------------------------------------------\n\n"

# --- 2. Get general interface info from ifconfig ---
# Using single quotes for awk commands to prevent shell expansion of $NF, $2, etc.
MTU=$(ifconfig "${INTERFACE}" | grep -E "\s+mtu\s+" | awk '{print $NF}')
STATUS=$(ifconfig "${INTERFACE}" | grep -E "\s+status:\s+" | awk '{print $NF}')
MAC_ADDRESS=$(ifconfig "${INTERFACE}" | grep -E "\s+ether\s+" | awk '{print $2}')

if [[ -n "${MTU}" || -n "${STATUS}" || -n "${MAC_ADDRESS}" ]]; then
    printf "Interface Details:\n"
    printf "--------------------\n"
    [[ -n "${MTU}" ]] && printf "%-15s %s\n" "MTU:" "${MTU}"
    [[ -n "${STATUS}" ]] && printf "%-15s %s\n" "Status:" "${STATUS}"
    [[ -n "${MAC_ADDRESS}" ]] && printf "%-15s %s\n" "MAC Address:" "${MAC_ADDRESS}"
    printf "--------------------\n\n"
fi
