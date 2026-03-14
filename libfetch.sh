#!/bin/bash


CYAN='\033[0;36m'
GREEN='\033[0;32m'
BOLD='\033[1m'
RESET='\033[0m'


USER=$(whoami)
HOST=$(hostname)
OS=$(grep PRETTY_NAME /etc/os-release | cut -d'"' -f2)
KERNEL=$(uname -r)
UPTIME=$(uptime -p)
CPU=$(grep "model name" /proc/cpuinfo | head -1 | cut -d':' -f2 | xargs)
RAM_USED=$(free -h | awk '/^Mem:/ {print $3}')
RAM_TOTAL=$(free -h | awk '/^Mem:/ {print $2}')


echo -e "${CYAN}${BOLD}${USER}@${HOST}${RESET}"
echo "─────────────────────────"
echo -e "${GREEN}OS${RESET}:     $OS"
echo -e "${GREEN}Kernel${RESET}: $KERNEL"
echo -e "${GREEN}Uptime${RESET}: $UPTIME"
echo -e "${GREEN}CPU${RESET}:    $CPU"
echo -e "${GREEN}RAM${RESET}:    $RAM_USED / $RAM_TOTAL"