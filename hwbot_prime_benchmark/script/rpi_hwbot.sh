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

# Raspberry Pi Revision Codes 
revision=$(tr -d '\0' < /proc/cpuinfo | grep "Revision" | rev | cut -c 1-6 | rev | tr -d ' ')
declare -A revision_codes
revision_codes=(
["000007"]="Model.................... 1 A\nRevision................. 2.0 (Code: "$revision")\nSoC...................... BCM2835\nCPU...................... ARM1176JZ(F)-S\nArchitecture............. ARMv6\nMemory................... 256 MB LPDDR2-SDRAM\nManufacturer............. Egoman"
["000008"]="Model.................... 1 A\nRevision................. 2.0 (Code: "$revision")\nSoC...................... BCM2835\nCPU...................... ARM1176JZ(F)-S\nArchitecture............. ARMv6\nMemory................... 256 MB LPDDR2-SDRAM\nManufacturer............. Sony UK"
["000009"]="Model.................... 1 A\nRevision................. 2.0 (Code: "$revision")\nSoC...................... BCM2835\nCPU...................... ARM1176JZ(F)-S\nArchitecture............. ARMv6\nMemory................... 256 MB LPDDR2-SDRAM\nManufacturer............. Qisda"
["000002"]="Model.................... 1 B\nRevision................. 1.0 (Code: "$revision")\nSoC...................... BCM2835\nCPU...................... ARM1176JZ(F)-S\nArchitecture............. ARMv6\nMemory................... 256 MB LPDDR2-SDRAM\nManufacturer............. Egoman"
["000003"]="Model.................... 1 B\nRevision................. 1.0 (Code: "$revision")\nSoC...................... BCM2835\nCPU...................... ARM1176JZ(F)-S\nArchitecture............. ARMv6\nMemory................... 256 MB LPDDR2-SDRAM\nManufacturer............. Egoman"
["000004"]="Model.................... 1 B\nRevision................. 2.0 (Code: "$revision")\nSoC...................... BCM2835\nCPU...................... ARM1176JZ(F)-S\nArchitecture............. ARMv6\nMemory................... 256 MB LPDDR2-SDRAM\nManufacturer............. Sony UK"
["000005"]="Model.................... 1 B\nRevision................. 2.0 (Code: "$revision")\nSoC...................... BCM2835\nCPU...................... ARM1176JZ(F)-S\nArchitecture............. ARMv6\nMemory................... 256 MB LPDDR2-SDRAM\nManufacturer............. Qisda"
["000006"]="Model.................... 1 B\nRevision................. 2.0 (Code: "$revision")\nSoC...................... BCM2835\nCPU...................... ARM1176JZ(F)-S\nArchitecture............. ARMv6\nMemory................... 256 MB LPDDR2-SDRAM\nManufacturer............. Egoman"
["00000d"]="Model.................... 1 B\nRevision................. 2.0 (Code: "$revision")\nSoC...................... BCM2835\nCPU...................... ARM1176JZ(F)-S\nArchitecture............. ARMv6\nMemory................... 512 MB LPDDR2-SDRAM\nManufacturer............. Egoman"
["00000e"]="Model.................... 1 B\nRevision................. 2.0 (Code: "$revision")\nSoC...................... BCM2835\nCPU...................... ARM1176JZ(F)-S\nArchitecture............. ARMv6\nMemory................... 512 MB LPDDR2-SDRAM\nManufacturer............. Sony UK"
["00000f"]="Model.................... 1 B\nRevision................. 2.0 (Code: "$revision")\nSoC...................... BCM2835\nCPU...................... ARM1176JZ(F)-S\nArchitecture............. ARMv6\nMemory................... 512 MB LPDDR2-SDRAM\nManufacturer............. Egoman"
["000012"]="Model.................... 1 A+\nRevision................. 1.1 (Code: "$revision")\nSoC...................... BCM2835\nCPU...................... ARM1176JZ(F)-S\nArchitecture............. ARMv6\nMemory................... 256 MB LPDDR2-SDRAM\nManufacturer............. Sony UK"
["000015"]="Model.................... 1 A+\nRevision................. 1.1 (Code: "$revision")\nSoC...................... BCM2835\nCPU...................... ARM1176JZ(F)-S\nArchitecture............. ARMv6\nMemory................... 256/512 MB LPDDR2-SDRAM\nManufacturer............. Embest"
["900021"]="Model.................... 1 A+\nRevision................. 1.1 (Code: "$revision")\nSoC...................... BCM2835\nCPU...................... ARM1176JZ(F)-S\nArchitecture............. ARMv6\nMemory................... 512 MB LPDDR2-SDRAM\nManufacturer............. Sony UK"
["000010"]="Model.................... 1 B+\nRevision................. 1.2 (Code: "$revision")\nSoC...................... BCM2835\nCPU...................... ARM1176JZ(F)-S\nArchitecture............. ARMv6\nMemory................... 512 MB LPDDR2-SDRAM\nManufacturer............. Sony UK"
["000013"]="Model.................... 1 B+\nRevision................. 1.2 (Code: "$revision")\nSoC...................... BCM2835\nCPU...................... ARM1176JZ(F)-S\nArchitecture............. ARMv6\nMemory................... 512 MB LPDDR2-SDRAM\nManufacturer............. Embest"
["900032"]="Model.................... 1 B+\nRevision................. 1.2 (Code: "$revision")\nSoC...................... BCM2835\nCPU...................... ARM1176JZ(F)-S\nArchitecture............. ARMv6\nMemory................... 512 MB LPDDR2-SDRAM\nManufacturer............. Sony UK"
["a01040"]="Model.................... 2 B\nRevision................. 1.0 (Code: "$revision")\nSoC...................... BCM2836\nCPU...................... Cortex-A7\nArchitecture............. ARMv7\nMemory................... 1 GB LPDDR2-SDRAM\nManufacturer............. Sony UK"
["a01041"]="Model.................... 2 B\nRevision................. 1.1 (Code: "$revision")\nSoC...................... BCM2836\nCPU...................... Cortex-A7\nArchitecture............. ARMv7\nMemory................... 1 GB LPDDR2-SDRAM\nManufacturer............. Sony UK"
["a21041"]="Model.................... 2 B\nRevision................. 1.1 (Code: "$revision")\nSoC...................... BCM2836\nCPU...................... Cortex-A7\nArchitecture............. ARMv7\nMemory................... 1 GB LPDDR2-SDRAM\nManufacturer............. Embest"
["a02042"]="Model.................... 2 B\nRevision................. 1.2 (Code: "$revision")\nSoC...................... BCM2837\nCPU...................... Cortex-A53\nArchitecture............. ARMv8\nMemory................... 1 GB LPDDR2-SDRAM\nManufacturer............. Sony UK"
["a22042"]="Model.................... 2 B\nRevision................. 1.2 (Code: "$revision")\nSoC...................... BCM2837\nCPU...................... Cortex-A53\nArchitecture............. ARMv8\nMemory................... 1 GB LPDDR2-SDRAM\nManufacturer............. Embest"
["a02082"]="Model.................... 3 B\nRevision................. 1.2 (Code: "$revision")\nSoC...................... BCM2837\nCPU...................... Cortex-A53\nArchitecture............. ARMv8\nMemory................... 1 GB LPDDR2-SDRAM\nManufacturer............. Sony UK"
["a22082"]="Model.................... 3 B\nRevision................. 1.2 (Code: "$revision")\nSoC...................... BCM2837\nCPU...................... Cortex-A53\nArchitecture............. ARMv8\nMemory................... 1 GB LPDDR2-SDRAM\nManufacturer............. Embest"
["a32082"]="Model.................... 3 B\nRevision................. 1.2 (Code: "$revision")\nSoC...................... BCM2837\nCPU...................... Cortex-A53\nArchitecture............. ARMv8\nMemory................... 1 GB LPDDR2-SDRAM\nManufacturer............. Sony Japan"
["a52082"]="Model.................... 3 B\nRevision................. 1.2 (Code: "$revision")\nSoC...................... BCM2837\nCPU...................... Cortex-A53\nArchitecture............. ARMv8\nMemory................... 1 GB LPDDR2-SDRAM\nManufacturer............. Stadium"
["a22083"]="Model.................... 3 B\nRevision................. 1.3 (Code: "$revision")\nSoC...................... BCM2837\nCPU...................... Cortex-A53\nArchitecture............. ARMv8\nMemory................... 1 GB LPDDR2-SDRAM\nManufacturer............. Embest"
["9020e0"]="Model.................... 3 A+\nRevision................. 1.0 (Code: "$revision")\nSoC...................... BCM2837B0\nCPU...................... Cortex-A53\nArchitecture............. ARMv8\nMemory................... 512 MB LPDDR2-SDRAM\nManufacturer............. Sony UK"
["a020d3"]="Model.................... 3 B+\nRevision................. 1.3 (Code: "$revision")\nSoC...................... BCM2837B0\nCPU...................... Cortex-A53\nArchitecture............. ARMv8\nMemory................... 1 GB LPDDR2-SDRAM\nManufacturer............. Sony UK"
["a03111"]="Model.................... 4 B\nRevision................. 1.1 (Code: "$revision")\nSoC...................... BCM2711B0\nCPU...................... Cortex-A72\nArchitecture............. ARMv8\nMemory................... 1 GB LPDDR4-SDRAM\nManufacturer............. Sony UK"
["b03111"]="Model.................... 4 B\nRevision................. 1.1 (Code: "$revision")\nSoC...................... BCM2711B0\nCPU...................... Cortex-A72\nArchitecture............. ARMv8\nMemory................... 2 GB LPDDR4-SDRAM\nManufacturer............. Sony UK"
["b03112"]="Model.................... 4 B\nRevision................. 1.2 (Code: "$revision")\nSoC...................... BCM2711B0\nCPU...................... Cortex-A72\nArchitecture............. ARMv8\nMemory................... 2 GB LPDDR4-SDRAM\nManufacturer............. Sony UK"
["b03114"]="Model.................... 4 B\nRevision................. 1.4 (Code: "$revision")\nSoC...................... BCM2711B0\nCPU...................... Cortex-A72\nArchitecture............. ARMv8\nMemory................... 2 GB LPDDR4-SDRAM\nManufacturer............. Sony UK"
["c03111"]="Model.................... 4 B\nRevision................. 1.1 (Code: "$revision")\nSoC...................... BCM2711B0\nCPU...................... Cortex-A72\nArchitecture............. ARMv8\nMemory................... 4 GB LPDDR4-SDRAM\nManufacturer............. Sony UK"
["c03112"]="Model.................... 4 B\nRevision................. 1.2 (Code: "$revision")\nSoC...................... BCM2711B0\nCPU...................... Cortex-A72\nArchitecture............. ARMv8\nMemory................... 4 GB LPDDR4-SDRAM\nManufacturer............. Sony UK"
["c03114"]="Model.................... 4 B\nRevision................. 1.4 (Code: "$revision")\nSoC...................... BCM2711B0\nCPU...................... Cortex-A72\nArchitecture............. ARMv8\nMemory................... 4 GB LPDDR4-SDRAM\nManufacturer............. Sony UK"
["d03114"]="Model.................... 4 B\nRevision................. 1.4 (Code: "$revision")\nSoC...................... BCM2711B0\nCPU...................... Cortex-A72\nArchitecture............. ARMv8\nMemory................... 8 GB LPDDR4-SDRAM\nManufacturer............. Sony UK"
["000011"]="Model.................... Compute Module 1\nRevision................. 1.0 (Code: "$revision")\nSoC...................... BCM2835\nCPU...................... ARM1176JZ(F)-S\nArchitecture............. ARMv6\nMemory................... 512 MB LPDDR2-SDRAM\nManufacturer............. Sony UK"
["000014"]="Model.................... Compute Module 1\nRevision................. 1.0 (Code: "$revision")\nSoC...................... BCM2835\nCPU...................... ARM1176JZ(F)-S\nArchitecture............. ARMv6\nMemory................... 512 MB LPDDR2-SDRAM\nManufacturer............. Embest"
["900061"]="Model.................... Compute Module 1\nRevision................. 1.1 (Code: "$revision")\nSoC...................... BCM2835\nCPU...................... ARM1176JZ(F)-S\nArchitecture............. ARMv6\nMemory................... 512 MB LPDDR2-SDRAM\nManufacturer............. Sony UK"
["a020a0"]="Model.................... Compute Module 3\nRevision................. 1.0 (Code: "$revision")\nSoC...................... BCM2837\nCPU...................... Cortex-A53\nArchitecture............. ARMv8\nMemory................... 1 GB LPDDR2-SDRAM\nManufacturer............. Sony UK"
["a220a0"]="Model.................... Compute Module 3\nRevision................. 1.0 (Code: "$revision")\nSoC...................... BCM2837\nCPU...................... Cortex-A53\nArchitecture............. ARMv8\nMemory................... 1 GB LPDDR2-SDRAM\nManufacturer............. Embest"
["a02100"]="Model.................... Compute Module 3+\nRevision................. 1.0 (Code: "$revision")\nSoC...................... BCM2837B0\nCPU...................... Cortex-A53\nArchitecture............. ARMv8\nMemory................... 1 GB LPDDR2-SDRAM\nManufacturer............. Sony UK"
["a03140"]="Model.................... Compute Module 4\nRevision................. 1.0 (Code: "$revision")\nSoC...................... BCM2711C0\nCPU...................... Cortex-A72\nArchitecture............. ARMv8\nMemory................... 1 GB LPDDR4-SDRAM\nManufacturer............. Sony UK"
["b03140"]="Model.................... Compute Module 4\nRevision................. 1.0 (Code: "$revision")\nSoC...................... BCM2711C0\nCPU...................... Cortex-A72\nArchitecture............. ARMv8\nMemory................... 2 GB LPDDR4-SDRAM\nManufacturer............. Sony UK"
["c03140"]="Model.................... Compute Module 4\nRevision................. 1.0 (Code: "$revision")\nSoC...................... BCM2711C0\nCPU...................... Cortex-A72\nArchitecture............. ARMv8\nMemory................... 4 GB LPDDR4-SDRAM\nManufacturer............. Sony UK"
["d03140"]="Model.................... Compute Module 4\nRevision................. 1.0 (Code: "$revision")\nSoC...................... BCM2711C0\nCPU...................... Cortex-A72\nArchitecture............. ARMv8\nMemory................... 8 GB LPDDR4-SDRAM\nManufacturer............. Sony UK"
["c03130"]="Model.................... 400\nRevision................. 1.0 (Code: "$revision")\nSoC...................... BCM2711C0\nCPU...................... Cortex-A72\nArchitecture............. ARMv8\nMemory................... 4 GB LPDDR4-SDRAM\nManufacturer............. Sony UK"
["900092"]="Model.................... Zero\nRevision................. 1.2 (Code: "$revision")\nSoC...................... BCM2835\nCPU...................... ARM1176JZ(F)-S\nArchitecture............. ARMv6\nMemory................... 512 MB LPDDR2-SDRAM\nManufacturer............. Sony UK"
["900093"]="Model.................... Zero\nRevision................. 1.3 (Code: "$revision")\nSoC...................... BCM2835\nCPU...................... ARM1176JZ(F)-S\nArchitecture............. ARMv6\nMemory................... 512 MB LPDDR2-SDRAM\nManufacturer............. Sony UK"
["9000c1"]="Model.................... Zero W\nRevision................. 1.1 (Code: "$revision")\nSoC...................... BCM2835\nCPU...................... ARM1176JZ(F)-S\nArchitecture............. ARMv6\nMemory................... 512 MB LPDDR2-SDRAM\nManufacturer............. Sony UK"
["920092"]="Model.................... Zero\nRevision................. 1.2 (Code: "$revision")\nSoC...................... BCM2835\nCPU...................... ARM1176JZ(F)-S\nArchitecture............. ARMv6\nMemory................... 512 MB LPDDR2-SDRAM\nManufacturer............. Embest"
["920093"]="Model.................... Zero\nRevision................. 1.3 (Code: "$revision")\nSoC...................... BCM2835\nCPU...................... ARM1176JZ(F)-S\nArchitecture............. ARMv6\nMemory................... 512 MB LPDDR2-SDRAM\nManufacturer............. Embest"
)


printf "${color_cyan}#########################################${color_reset}\n"
printf "${color_cyan}#                                       #${color_reset}\n"
printf "${color_cyan}#  HWBOT Prime Script for Raspberry Pi  #${color_reset}\n"
printf "${color_cyan}#                                       #${color_reset}\n"
printf "${color_cyan}# by cr_chsn1               Version 2.0 #${color_reset}\n"
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
echo "Operating system......... "$os_name $os_version "("$os_codename")"
echo "Firmware................. "$firmware_version "("$firmware_date")"
echo
printf "${color_green}Linux-Kernel:${color_reset}\n"
uname -r -v
echo
printf "${color_green}Java Runtime:${color_reset}\n"
java -version
echo
echo
printf "${color_yellow}### Hardware-Information ###${color_reset}\n"
echo
printf "${color_yellow}Raspberry Pi Model:${color_reset}\n"
echo -e "${revision_codes[$revision]}"
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
echo "Frequency (ARM).......... $freq_arm MHz (PLLB: $freq_pllb MHz)"
echo "Frequency (Core)......... $freq_core MHz"
echo "Frequency (RAM).......... $freq_mem MHz"
echo "Voltage (VDD_CORE)....... $volt_arm V"
echo "Voltage (V_DDR).......... $volt_mem V"
echo "Temperature (Idle)....... $temp_idle °C"
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
echo "Temperature (Post-Load).. $temp_load °C"
echo