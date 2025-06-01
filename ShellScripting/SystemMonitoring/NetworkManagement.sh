#!/bin/zsh

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

