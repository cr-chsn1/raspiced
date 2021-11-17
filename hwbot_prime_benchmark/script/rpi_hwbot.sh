#!/bin/bash
clear

# Bash coloring
color_reset='\033[0m'
color_cyan='\033[0;36m'
color_green='\033[0;32m'
color_red='\033[0;31m'
color_yellow='\033[0;33m'

printf "${color_cyan}#########################################${color_reset}\n"
printf "${color_cyan}#                                       #${color_reset}\n"
printf "${color_cyan}#  HWBOT Prime Script for Raspberry Pi  #${color_reset}\n"
printf "${color_cyan}#                                       #${color_reset}\n"
printf "${color_cyan}# by cr_chsn1               Version 1.0 #${color_reset}\n"
printf "${color_cyan}#########################################${color_reset}\n"
echo
printf "${color_green}### Software-Information ###${color_reset}\n"
printf "${color_green}Raspbian-Version:${color_reset}\n"
cat /etc/debian_version 
printf "${color_green}Linux-Kernel:${color_reset}\n"
uname -a
printf "${color_green}Java Runtime:${color_reset}\n"
java -version
echo
printf "${color_yellow}### SoC-Information ###${color_reset}\n"
printf "${color_yellow}Raspberry Pi Model (/sys/firmware/devicetree/base/model):${color_reset}\n"
cat /sys/firmware/devicetree/base/model && echo
printf "${color_yellow}Identification (/proc/device-tree/compatible):${color_reset}\n"
cat /proc/device-tree/compatible && echo
printf "${color_yellow}Frequency (arm):${color_reset}\n"
vcgencmd measure_clock arm
printf "${color_yellow}Voltages (arm/sdram)${color_reset}\n"
vcgencmd measure_volts core && vcgencmd measure_volts sdram_c
printf "${color_yellow}Temperature (idle):${color_reset}\n"
vcgencmd measure_temp
echo
printf "${color_red}### Benchmark ###${color_reset}\n"
java -jar ./hwbotprime.jar