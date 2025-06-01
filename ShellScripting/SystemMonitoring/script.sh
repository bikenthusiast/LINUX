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

# current process used
# todo
# current network width
# too
