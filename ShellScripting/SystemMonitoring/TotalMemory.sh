#!/bin/zsh

# Total RAM on system
# Get the total physical memory in bytes                           
total_memory_bytes=$(sysctl -n hw.memsize)

echo $(which sysctl)
echo "Debug - Raw bytes: $total_memory_bytes"

total_memory_gb=$(sysctl -n hw.memsize | awk '{print $1 / (1024*    1024*1024)}')
#printf "Total Physical RAM: %.2f GB" "$(sysctl -n hw.memsize | awk '{print $1 / (1024*1024*1024)}')"

# Convert to GB for human-readable output using awk for floating-po    int division
#total_memory_gb=$(awk -v bytes="$total_memory_bytes" 'BEGIN {print     bytes / (1024*1024*1024)}')

echo "Total Physical RAM: ${total_memory_gb} GB"

total_used_gb=25.6536


export LANG=C

# Perform the calculation using bc with a here document
# The 'scale' command sets the number of decimal places for the result
ram_percentage=$(bc -l << EOF
scale=2
($total_used_gb / $total_memory_gb)*100
EOF
)
#printf ("$ram_percentage")

printf "\t\tRAM Percentage Used: %.2f%%\\n" "${ram_percentage}" 
# current process used







