#!/bin/zsh

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
