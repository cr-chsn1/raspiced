#!/bin/bash
clear

# Bash coloring
color_reset='\033[0m'
color_cyan='\033[0;36m'
color_green='\033[0;32m'
color_red='\033[0;31m'
color_yellow='\033[0;33m'

# Function for converting frequencies Hz > MHz
function convert_to_MHz {
    let value=$1/1000000
    echo "$value"
}

printf "${color_cyan}#########################################${color_reset}\n"
printf "${color_cyan}#                                       #${color_reset}\n"
printf "${color_cyan}#  HWBOT Prime Script for Raspberry Pi  #${color_reset}\n"
printf "${color_cyan}#                                       #${color_reset}\n"
printf "${color_cyan}# by cr_chsn1               Version 1.1 #${color_reset}\n"
printf "${color_cyan}#########################################${color_reset}\n"
echo
echo
if [ "${1}" = "--install" ]; then
	printf "${color_green}### Installing dependencies ###${color_reset}\n"
	echo
	sudo apt update
	sudo apt -y install openjdk-8-jre
	wget http://downloads.hwbot.org/hwbotprime.jar
	echo
	printf "${color_green}Everything is installed. Please restart the script for benchmarking.${color_reset}\n"
	echo
	exit 0
fi
printf "${color_green}### Software-Information ###${color_reset}\n"
echo
printf "${color_green}Raspbian-Version:${color_reset}\n"
cat /etc/debian_version 
echo
printf "${color_green}Linux-Kernel:${color_reset}\n"
uname -a
echo
printf "${color_green}Java Runtime:${color_reset}\n"
java -version
echo
echo
printf "${color_yellow}### SoC-Information ###${color_reset}\n"
echo
printf "${color_yellow}Raspberry Pi Model (/sys/firmware/devicetree/base/model):${color_reset}\n"
cat /sys/firmware/devicetree/base/model && echo
echo
printf "${color_yellow}Identification (/proc/device-tree/compatible):${color_reset}\n"
cat /proc/device-tree/compatible && echo
echo
printf "${color_yellow}Sensor Status:${color_reset}\n"
freq_arm_org=$(vcgencmd measure_clock arm)
freq_arm=${freq_arm_org:14:10}
freq_arm=$(convert_to_MHz $freq_arm)
volt_arm=$(vcgencmd measure_volts core)
volt_arm=${volt_arm:5:4}
volt_mem=$(vcgencmd measure_volts sdram_c)
volt_mem=${volt_mem:5:4}
temp=$(vcgencmd measure_temp)
temp=${temp:5:4}
echo "Frequency (arm):	$freq_arm MHz ($freq_arm_org)"
echo "Voltage (arm):		$volt_arm V"
echo "Voltage (sdram):	$volt_mem V"
echo "Temperature (idle):	$temp °C"
echo
echo
printf "${color_red}### Benchmark ###${color_reset}\n"
echo
java -jar ./hwbotprime.jar