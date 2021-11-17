#!/bin/bash
clear

# Bash coloring
color_reset='\033[0m'
color_green='\033[0;32m'
color_red='\033[0;31m'
color_yellow='\033[0;33m'

printf "\n${color_green}### Software-Information ###${color_reset}\n\n"
printf "\n${color_green}Raspbian-Version:${color_reset}\n\n"
cat /etc/debian_version 
printf "\n${color_green}Linux-Kernel:${color_reset}\n\n"
uname -a
printf "\n${color_green}Java Runtime:${color_reset}\n\n"
java -version
echo
printf "\n${color_yellow}### SoC-Information ###${color_reset}\n\n"
printf "\n${color_yellow}Raspberry Pi Model (/sys/firmware/devicetree/base/model):${color_reset}\n\n"
cat /sys/firmware/devicetree/base/model && echo
printf "\n${color_yellow}ID-String (/proc/device-tree/compatible)::${color_reset}\n\n"
cat /proc/device-tree/compatible && echo
printf "\n${color_yellow}SoC-frequency:${color_reset}\n\n"
vcgencmd measure_clock arm
printf "\n${color_yellow}VDD_CORE:${color_reset}\n\n"
vcgencmd measure_volts core
printf "\n${color_yellow}Temperature:${color_reset}\n\n"
vcgencmd measure_temp
echo
printf "\n${color_red}### HWBOT PRIME ###${color_reset}\n\n"
java -jar ./hwbotprime.jar