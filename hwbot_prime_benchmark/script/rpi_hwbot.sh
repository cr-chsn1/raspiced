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
printf "${color_cyan}# by cr_chsn1               Version 1.5 #${color_reset}\n"
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
printf "${color_green}Versions:${color_reset}\n"
os_name=$(lsb_release -si)
os_codename=$(lsb_release -sc)
os_version=$(cat /etc/debian_version)
firmware_date=$(vcgencmd version  | grep ":")
firmware_date=${firmware_date:0:20}
firmware_version=$(vcgencmd version  | grep "version")
firmware_version=${firmware_version:8:40}
echo "Operating system:" $os_name $os_version "("$os_codename")"
echo "Firmware:        " $firmware_version "("$firmware_date")"
echo
printf "${color_green}Linux-Kernel:${color_reset}\n"
uname -r -v
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
printf "${color_yellow}Sensor Status (1/2):${color_reset}\n"
freq_arm=$(vcgencmd measure_clock arm)
freq_arm=${freq_arm:14:10}
freq_arm=$(convert_to_MHz $freq_arm)
freq_pllb=$(vcgencmd measure_clock pllb)
freq_pllb=${freq_pllb:15:10}
freq_pllb=$(convert_to_MHz $freq_pllb)
freq_core=$(vcgencmd measure_clock core)
freq_core=${freq_core:13:10}
freq_core=$(convert_to_MHz $freq_core)
freq_mem=$(vcgencmd get_config sdram_freq)
freq_mem=${freq_mem:11:4}
rpi_model=$(tr -d '\0' < /proc/device-tree/compatible)
rpi_model=${rpi_model:12:1}
if (("$rpi_model" == "4")); then
	freq_mem=3200
fi
volt_arm=$(vcgencmd measure_volts core)
volt_arm=${volt_arm:5:4}
volt_mem=$(vcgencmd measure_volts sdram_c)
volt_mem=${volt_mem:5:4}
temp_idle=$(vcgencmd measure_temp)
temp_idle=${temp_idle:5:4}
echo "Frequency (ARM):		$freq_arm MHz (PLLB: $freq_pllb MHz)"
echo "Frequency (Core):		$freq_core MHz"
echo "Frequency (RAM):		$freq_mem MHz"
echo "Voltage (VDD_CORE):		$volt_arm V"
echo "Voltage (V_DDR):		$volt_mem V"
echo "Temperature (Idle):		$temp_idle °C"
echo
echo
printf "${color_red}### Benchmark ###${color_reset}\n"
echo
date_time=`date '+%Y-%m-%d_%H.%M.%S'`
java -jar ./hwbotprime.jar "$date_time"_"$freq_arm"arm_"$freq_core"core_"$freq_mem"mem.hwbot
echo
echo
printf "${color_yellow}Sensor Status (2/2):${color_reset}\n"
temp_load=$(vcgencmd measure_temp)
temp_load=${temp_load:5:4}
echo "Temperature (Post-Load):	$temp_load °C"
echo