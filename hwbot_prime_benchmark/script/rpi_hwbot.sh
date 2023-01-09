#!/bin/bash
clear

# Version of the script
script_version="3.5"

# Bash coloring
color_reset='\033[0m'
color_cyan='\033[0;36m'
color_green='\033[0;32m'
color_red='\033[0;31m'
color_yellow='\033[0;33m'
color_magenta='\033[0;35m'

# Script get's to know itself
script="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"

# Function for converting frequencies Hz > MHz
function convert_to_MHz {
    let value=$1/1000000
    echo "$value"
}

# ARM-architecture (32/64-bit)
arch=$(uname -m)

# Chekcing if SoC is a BCM2711
if tr -d '\0' < /proc/device-tree/compatible | grep -q "bcm2711" ; then
	bcm2711_soc=true
fi

# Checking the BCM2711-stepping (B0/C0), when running on a RPi4/CM4
if [ -e /proc/device-tree/emmc2bus/dma-ranges ]; then
	bcm2711_stepping=$(od -An -tx1 /proc/device-tree/emmc2bus/dma-ranges)
	if   [[ "$bcm2711_stepping" == " 00 00 00 00 c0 00 00 00 00 00 00 00 00 00 00 00
 40 00 00 00" ]]; then
		bcm2711_stepping="B0"
	elif [[ "$bcm2711_stepping" == " 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 fc 00 00 00" ]]; then
		bcm2711_stepping="C0"
	else
		bcm2711_stepping=""
	fi
fi

# Raspberry Pi Revision Codes
revision=$(tr -d '\0' < /proc/cpuinfo | grep "Revision" | rev | cut -c 1-6 | rev)
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
["a02042"]="Model.................... 2 B\nRevision................. 1.2 (Code: "$revision")\nSoC...................... BCM2837A0\nCPU...................... Cortex-A53\nArchitecture............. ARMv8\nMemory................... 1 GB LPDDR2-SDRAM\nManufacturer............. Sony UK"
["a22042"]="Model.................... 2 B\nRevision................. 1.2 (Code: "$revision")\nSoC...................... BCM2837A0\nCPU...................... Cortex-A53\nArchitecture............. ARMv8\nMemory................... 1 GB LPDDR2-SDRAM\nManufacturer............. Embest"
["a02082"]="Model.................... 3 B\nRevision................. 1.2 (Code: "$revision")\nSoC...................... BCM2837A0 (maybe B0)\nCPU...................... Cortex-A53\nArchitecture............. ARMv8\nMemory................... 1 GB LPDDR2-SDRAM\nManufacturer............. Sony UK"
["a22082"]="Model.................... 3 B\nRevision................. 1.2 (Code: "$revision")\nSoC...................... BCM2837A0 (maybe B0)\nCPU...................... Cortex-A53\nArchitecture............. ARMv8\nMemory................... 1 GB LPDDR2-SDRAM\nManufacturer............. Embest"
["a32082"]="Model.................... 3 B\nRevision................. 1.2 (Code: "$revision")\nSoC...................... BCM2837A0 (maybe B0)\nCPU...................... Cortex-A53\nArchitecture............. ARMv8\nMemory................... 1 GB LPDDR2-SDRAM\nManufacturer............. Sony Japan"
["a52082"]="Model.................... 3 B\nRevision................. 1.2 (Code: "$revision")\nSoC...................... BCM2837A0 (maybe B0)\nCPU...................... Cortex-A53\nArchitecture............. ARMv8\nMemory................... 1 GB LPDDR2-SDRAM\nManufacturer............. Stadium"
["a22083"]="Model.................... 3 B\nRevision................. 1.3 (Code: "$revision")\nSoC...................... BCM2837B0\nCPU...................... Cortex-A53\nArchitecture............. ARMv8\nMemory................... 1 GB LPDDR2-SDRAM\nManufacturer............. Embest"
["9020e0"]="Model.................... 3 A+\nRevision................. 1.0 (Code: "$revision")\nSoC...................... BCM2837B0\nCPU...................... Cortex-A53\nArchitecture............. ARMv8\nMemory................... 512 MB LPDDR2-SDRAM\nManufacturer............. Sony UK"
["a020d3"]="Model.................... 3 B+\nRevision................. 1.3 (Code: "$revision")\nSoC...................... BCM2837B0\nCPU...................... Cortex-A53\nArchitecture............. ARMv8\nMemory................... 1 GB LPDDR2-SDRAM\nManufacturer............. Sony UK"
["a03111"]="Model.................... 4 B\nRevision................. 1.1 (Code: "$revision")\nSoC...................... BCM2711"$bcm2711_stepping"\nCPU...................... Cortex-A72\nArchitecture............. ARMv8\nMemory................... 1 GB LPDDR4-SDRAM\nManufacturer............. Sony UK"
["a03112"]="Model.................... 4 B\nRevision................. 1.2 (Code: "$revision")\nSoC...................... BCM2711"$bcm2711_stepping"\nCPU...................... Cortex-A72\nArchitecture............. ARMv8\nMemory................... 1 GB LPDDR4-SDRAM\nManufacturer............. Sony UK"
["a03114"]="Model.................... 4 B\nRevision................. 1.4 (Code: "$revision")\nSoC...................... BCM2711"$bcm2711_stepping"\nCPU...................... Cortex-A72\nArchitecture............. ARMv8\nMemory................... 1 GB LPDDR4-SDRAM\nManufacturer............. Sony UK"
["a03115"]="Model.................... 4 B\nRevision................. 1.5 (Code: "$revision")\nSoC...................... BCM2711"$bcm2711_stepping"\nCPU...................... Cortex-A72\nArchitecture............. ARMv8\nMemory................... 1 GB LPDDR4-SDRAM\nManufacturer............. Sony UK"
["b03111"]="Model.................... 4 B\nRevision................. 1.1 (Code: "$revision")\nSoC...................... BCM2711"$bcm2711_stepping"\nCPU...................... Cortex-A72\nArchitecture............. ARMv8\nMemory................... 2 GB LPDDR4-SDRAM\nManufacturer............. Sony UK"
["b03112"]="Model.................... 4 B\nRevision................. 1.2 (Code: "$revision")\nSoC...................... BCM2711"$bcm2711_stepping"\nCPU...................... Cortex-A72\nArchitecture............. ARMv8\nMemory................... 2 GB LPDDR4-SDRAM\nManufacturer............. Sony UK"
["b03114"]="Model.................... 4 B\nRevision................. 1.4 (Code: "$revision")\nSoC...................... BCM2711"$bcm2711_stepping"\nCPU...................... Cortex-A72\nArchitecture............. ARMv8\nMemory................... 2 GB LPDDR4-SDRAM\nManufacturer............. Sony UK"
["b03115"]="Model.................... 4 B\nRevision................. 1.5 (Code: "$revision")\nSoC...................... BCM2711"$bcm2711_stepping"\nCPU...................... Cortex-A72\nArchitecture............. ARMv8\nMemory................... 2 GB LPDDR4-SDRAM\nManufacturer............. Sony UK"
["c03111"]="Model.................... 4 B\nRevision................. 1.1 (Code: "$revision")\nSoC...................... BCM2711"$bcm2711_stepping"\nCPU...................... Cortex-A72\nArchitecture............. ARMv8\nMemory................... 4 GB LPDDR4-SDRAM\nManufacturer............. Sony UK"
["c03112"]="Model.................... 4 B\nRevision................. 1.2 (Code: "$revision")\nSoC...................... BCM2711"$bcm2711_stepping"\nCPU...................... Cortex-A72\nArchitecture............. ARMv8\nMemory................... 4 GB LPDDR4-SDRAM\nManufacturer............. Sony UK"
["c03114"]="Model.................... 4 B\nRevision................. 1.4 (Code: "$revision")\nSoC...................... BCM2711"$bcm2711_stepping"\nCPU...................... Cortex-A72\nArchitecture............. ARMv8\nMemory................... 4 GB LPDDR4-SDRAM\nManufacturer............. Sony UK"
["c03115"]="Model.................... 4 B\nRevision................. 1.5 (Code: "$revision")\nSoC...................... BCM2711"$bcm2711_stepping"\nCPU...................... Cortex-A72\nArchitecture............. ARMv8\nMemory................... 4 GB LPDDR4-SDRAM\nManufacturer............. Sony UK"
["d03114"]="Model.................... 4 B\nRevision................. 1.4 (Code: "$revision")\nSoC...................... BCM2711"$bcm2711_stepping"\nCPU...................... Cortex-A72\nArchitecture............. ARMv8\nMemory................... 8 GB LPDDR4-SDRAM\nManufacturer............. Sony UK"
["d03115"]="Model.................... 4 B\nRevision................. 1.5 (Code: "$revision")\nSoC...................... BCM2711"$bcm2711_stepping"\nCPU...................... Cortex-A72\nArchitecture............. ARMv8\nMemory................... 8 GB LPDDR4-SDRAM\nManufacturer............. Sony UK"
["000011"]="Model.................... Compute Module 1\nRevision................. 1.0 (Code: "$revision")\nSoC...................... BCM2835\nCPU...................... ARM1176JZ(F)-S\nArchitecture............. ARMv6\nMemory................... 512 MB LPDDR2-SDRAM\nManufacturer............. Sony UK"
["000014"]="Model.................... Compute Module 1\nRevision................. 1.0 (Code: "$revision")\nSoC...................... BCM2835\nCPU...................... ARM1176JZ(F)-S\nArchitecture............. ARMv6\nMemory................... 512 MB LPDDR2-SDRAM\nManufacturer............. Embest"
["900061"]="Model.................... Compute Module 1\nRevision................. 1.1 (Code: "$revision")\nSoC...................... BCM2835\nCPU...................... ARM1176JZ(F)-S\nArchitecture............. ARMv6\nMemory................... 512 MB LPDDR2-SDRAM\nManufacturer............. Sony UK"
["a01160"]="Model.................... Compute Module 2\nRevision................. 1.0 (Code: "$revision")\nSoC...................... BCM2836\nCPU...................... Cortex-A7\nArchitecture............. ARMv7\nMemory................... 1 GB LPDDR2-SDRAM\nManufacturer............. Sony UK"
["a020a0"]="Model.................... Compute Module 3\nRevision................. 1.0 (Code: "$revision")\nSoC...................... BCM2837A0\nCPU...................... Cortex-A53\nArchitecture............. ARMv8\nMemory................... 1 GB LPDDR2-SDRAM\nManufacturer............. Sony UK"
["a220a0"]="Model.................... Compute Module 3\nRevision................. 1.0 (Code: "$revision")\nSoC...................... BCM2837A0\nCPU...................... Cortex-A53\nArchitecture............. ARMv8\nMemory................... 1 GB LPDDR2-SDRAM\nManufacturer............. Embest"
["a02100"]="Model.................... Compute Module 3+\nRevision................. 1.0 (Code: "$revision")\nSoC...................... BCM2837B0\nCPU...................... Cortex-A53\nArchitecture............. ARMv8\nMemory................... 1 GB LPDDR2-SDRAM\nManufacturer............. Sony UK"
["a03140"]="Model.................... Compute Module 4\nRevision................. 1.0 (Code: "$revision")\nSoC...................... BCM2711"$bcm2711_stepping"\nCPU...................... Cortex-A72\nArchitecture............. ARMv8\nMemory................... 1 GB LPDDR4-SDRAM\nManufacturer............. Sony UK"
["a03141"]="Model.................... Compute Module 4\nRevision................. 1.1 (Code: "$revision")\nSoC...................... BCM2711"$bcm2711_stepping"\nCPU...................... Cortex-A72\nArchitecture............. ARMv8\nMemory................... 1 GB LPDDR4-SDRAM\nManufacturer............. Sony UK"
["b03140"]="Model.................... Compute Module 4\nRevision................. 1.0 (Code: "$revision")\nSoC...................... BCM2711"$bcm2711_stepping"\nCPU...................... Cortex-A72\nArchitecture............. ARMv8\nMemory................... 2 GB LPDDR4-SDRAM\nManufacturer............. Sony UK"
["b03141"]="Model.................... Compute Module 4\nRevision................. 1.1 (Code: "$revision")\nSoC...................... BCM2711"$bcm2711_stepping"\nCPU...................... Cortex-A72\nArchitecture............. ARMv8\nMemory................... 2 GB LPDDR4-SDRAM\nManufacturer............. Sony UK"
["c03140"]="Model.................... Compute Module 4\nRevision................. 1.0 (Code: "$revision")\nSoC...................... BCM2711"$bcm2711_stepping"\nCPU...................... Cortex-A72\nArchitecture............. ARMv8\nMemory................... 4 GB LPDDR4-SDRAM\nManufacturer............. Sony UK"
["c03141"]="Model.................... Compute Module 4\nRevision................. 1.1 (Code: "$revision")\nSoC...................... BCM2711"$bcm2711_stepping"\nCPU...................... Cortex-A72\nArchitecture............. ARMv8\nMemory................... 4 GB LPDDR4-SDRAM\nManufacturer............. Sony UK"
["d03140"]="Model.................... Compute Module 4\nRevision................. 1.0 (Code: "$revision")\nSoC...................... BCM2711"$bcm2711_stepping"\nCPU...................... Cortex-A72\nArchitecture............. ARMv8\nMemory................... 8 GB LPDDR4-SDRAM\nManufacturer............. Sony UK"
["d03141"]="Model.................... Compute Module 4\nRevision................. 1.1 (Code: "$revision")\nSoC...................... BCM2711"$bcm2711_stepping"\nCPU...................... Cortex-A72\nArchitecture............. ARMv8\nMemory................... 8 GB LPDDR4-SDRAM\nManufacturer............. Sony UK"
["a03150"]="Model.................... Compute Module 4S\nRevision................. 1.0 (Code: "$revision")\nSoC...................... BCM2711"$bcm2711_stepping"\nCPU...................... Cortex-A72\nArchitecture............. ARMv8\nMemory................... 1 GB LPDDR4-SDRAM\nManufacturer............. Sony UK"
["b03150"]="Model.................... Compute Module 4S\nRevision................. 1.0 (Code: "$revision")\nSoC...................... BCM2711"$bcm2711_stepping"\nCPU...................... Cortex-A72\nArchitecture............. ARMv8\nMemory................... 2 GB LPDDR4-SDRAM\nManufacturer............. Sony UK"
["c03150"]="Model.................... Compute Module 4S\nRevision................. 1.0 (Code: "$revision")\nSoC...................... BCM2711"$bcm2711_stepping"\nCPU...................... Cortex-A72\nArchitecture............. ARMv8\nMemory................... 4 GB LPDDR4-SDRAM\nManufacturer............. Sony UK"
["d03150"]="Model.................... Compute Module 4S\nRevision................. 1.0 (Code: "$revision")\nSoC...................... BCM2711"$bcm2711_stepping"\nCPU...................... Cortex-A72\nArchitecture............. ARMv8\nMemory................... 8 GB LPDDR4-SDRAM\nManufacturer............. Sony UK"
["c03130"]="Model.................... 400\nRevision................. 1.0 (Code: "$revision")\nSoC...................... BCM2711"$bcm2711_stepping"\nCPU...................... Cortex-A72\nArchitecture............. ARMv8\nMemory................... 4 GB LPDDR4-SDRAM\nManufacturer............. Sony UK"
["900092"]="Model.................... Zero\nRevision................. 1.2 (Code: "$revision")\nSoC...................... BCM2835\nCPU...................... ARM1176JZ(F)-S\nArchitecture............. ARMv6\nMemory................... 512 MB LPDDR2-SDRAM\nManufacturer............. Sony UK"
["900093"]="Model.................... Zero\nRevision................. 1.3 (Code: "$revision")\nSoC...................... BCM2835\nCPU...................... ARM1176JZ(F)-S\nArchitecture............. ARMv6\nMemory................... 512 MB LPDDR2-SDRAM\nManufacturer............. Sony UK"
["9000c1"]="Model.................... Zero W\nRevision................. 1.1 (Code: "$revision")\nSoC...................... BCM2835\nCPU...................... ARM1176JZ(F)-S\nArchitecture............. ARMv6\nMemory................... 512 MB LPDDR2-SDRAM\nManufacturer............. Sony UK"
["920092"]="Model.................... Zero\nRevision................. 1.2 (Code: "$revision")\nSoC...................... BCM2835\nCPU...................... ARM1176JZ(F)-S\nArchitecture............. ARMv6\nMemory................... 512 MB LPDDR2-SDRAM\nManufacturer............. Embest"
["920093"]="Model.................... Zero\nRevision................. 1.3 (Code: "$revision")\nSoC...................... BCM2835\nCPU...................... ARM1176JZ(F)-S\nArchitecture............. ARMv6\nMemory................... 512 MB LPDDR2-SDRAM\nManufacturer............. Embest"
["902120"]="Model.................... Zero 2 W\nRevision................. 1.0 (Code: "$revision")\nSiP...................... RP3A0-AU (BCM2710A1)\nCPU...................... Cortex-A53\nArchitecture............. ARMv8\nMemory................... 512 MB LPDDR2-SDRAM\nManufacturer............. Sony UK"
)

# Setting stock clock for memory
rpi_model=$(tr -d '\0' < /proc/device-tree/compatible)
if [ "$rpi_model" = "raspberrypi,model-abrcm,bcm2835" ] \
|| [ "$rpi_model" = "raspberrypi,model-bbrcm,bcm2835" ] \
|| [ "$rpi_model" = "raspberrypi,model-b-rev2brcm,bcm2835" ] \
|| [ "$rpi_model" = "raspberrypi,model-a-plusbrcm,bcm2835" ] \
|| [ "$rpi_model" = "raspberrypi,model-b-plusbrcm,bcm2835" ] \
|| [ "$rpi_model" = "raspberrypi,2-model-bbrcm,bcm2836" ] \
|| [ "$rpi_model" = "raspberrypi,2-model-b-rev2brcm,bcm2837" ] \
|| [ "$rpi_model" = "raspberrypi,compute-modulebrcm,bcm2835" ] \
|| [ "$rpi_model" = "raspberrypi,2-compute-modulebrcm,bcm2836" ]; then
	freq_mem_stock=400
elif [ "$rpi_model" = "kunbus,revpi-corebrcm,bcm2837brcm,bcm2836brcm,bcm2835" ] \
|| [ "$rpi_model" = "kunbus,revpi-compactbrcm,bcm2837brcm,bcm2836" ] \
|| [ "$rpi_model" = "kunbus,revpi-flatbrcm,bcm2837brcm,bcm2836" ] \
|| [ "$rpi_model" = "kunbus,revpi-connectbrcm,bcm2837brcm,bcm2836" ] \
|| [ "$rpi_model" = "raspberrypi,3-model-bbrcm,bcm2837" ] \
|| [ "$rpi_model" = "raspberrypi,3-compute-modulebrcm,bcm2837" ] \
|| [ "$rpi_model" = "raspberrypi,model-zerobrcm,bcm2835" ] \
|| [ "$rpi_model" = "raspberrypi,model-zero-wbrcm,bcm2835" ] \
|| [ "$rpi_model" = "raspberrypi,model-zero-2-wbrcm,bcm2837" ]; then
	freq_mem_stock=450
elif [ "$rpi_model" = "raspberrypi,3-model-a-plusbrcm,bcm2837" ] \
|| [ "$rpi_model" = "raspberrypi,3-model-b-plusbrcm,bcm2837" ]; then
	freq_mem_stock=500
elif [ "$rpi_model" = "kunbus,revpi-connect-sebrcm,bcm2711" ] \
|| [ "$rpi_model" = "raspberrypi,4-model-bbrcm,bcm2711" ] \
|| [ "$rpi_model" = "raspberrypi,4-compute-modulebrcm,bcm2711" ] \
|| [ "$rpi_model" = "raspberrypi,4-compute-module-sbrcm,bcm2711" ] \
|| [ "$rpi_model" = "raspberrypi,400brcm,bcm2711" ]; then
	freq_mem_stock=1600
fi

echo -e "${color_cyan}######################################"
echo "#                                    #"
echo "#    HWBOT Prime Benchmark Script    #"
echo "#          for Raspberry Pi          #"
echo "#                                    #"
echo "#          WWW.RASPICED.COM          #"
echo "#                                    #"
echo "#  by cr_chsn1          Version $script_version  #"
echo "#                                    #"
echo -e "######################################${color_reset}"
echo
echo

# Routine for installing dependencies & tools
if [ "${1}" = "--install" ]; then
	echo -e "${color_green}### Installing dependencies & tools ###${color_reset}"
	echo
	sudo apt update
	if [ "$arch" = "aarch64" ]; then # If the OS is 64-bit, Java 11 is used.
		sudo apt -y install cpufrequtils openjdk-11-jre-headless
	else # If the OS is 32-bit, Java 8 is used.
		sudo apt -y install cpufrequtils openjdk-8-jre-headless
	fi
	rm hwbotprime*.jar
	wget http://downloads.hwbot.org/hwbotprime.jar # Download HWBOT Prime 0.8.3 for 32-bit systems.
	mv hwbotprime.jar hwbotprime-0.8.3.jar
	wget https://s3-eu-west-1.amazonaws.com/hwbotdownloads/downloads/hwbotprime-1.0.1.jar # Download HWBOT Prime 1.0.1 for 64-bit systems.
	rm sha256sums
	wget https://raw.githubusercontent.com/cr-chsn1/raspiced/main/hwbot_prime_benchmark/script/sha256sums
	echo
	echo -e "${color_green}Everything is installed. Please restart the script for benchmarking.${color_reset}"
	echo
	exit 0
fi

# Routine for deleting tools & files
if [ "${1}" = "--uninstall" ]; then
	echo -e "${color_green}### Deleting tools & files ###${color_reset}"
	echo
	rm hwbotprime*.jar
	rm sha256sums
	rm *.hwbot
	echo
	echo -e "${color_green}Tools and files deleted.${color_reset}"
	echo
	exit 0
fi

# Routine for checking the latest version of this script
if ! [[ `wget -S --spider https://www.raspiced.com/download/hwbot_prime_benchmark/$script_version 2>&1 | grep 'HTTP/1.1 200 OK'` ]]; then
	echo
	echo "A new version of the script is available. Do you want to download it?"
	echo "If you don't have internet-access, please select: [2] No"
	echo
	echo "[1] Yes"
	echo "[2] No"
	echo
	read -p "Please select your answer (1..2), followed by [ENTER]: " input
	echo
	if (("$input" == "1")); then
		rm rpi_hwbot.sh
		rm sha256sums
		wget https://raw.githubusercontent.com/cr-chsn1/raspiced/main/hwbot_prime_benchmark/script/rpi_hwbot.sh
		wget https://raw.githubusercontent.com/cr-chsn1/raspiced/main/hwbot_prime_benchmark/script/sha256sums
		sudo chmod +x rpi_hwbot.sh
		echo
		echo -e "${color_green}The latest version has been downloaded. Please restart the script.${color_reset}"
		exit 0
	fi
fi

echo -e "${color_green}### Software-Information ###${color_reset}"
echo
echo -e "${color_green}Operating system:${color_reset}"
os_name="Raspberry Pi OS"
os_codename=$(lsb_release -sc)
os_codename=${os_codename^}
os_version=$(cat /etc/debian_version)
firmware_date=$(vcgencmd version  | grep ":") # Reading the installed firmware version
firmware_date=${firmware_date:0:20}
firmware_version=$(vcgencmd version  | grep "version")
firmware_version=${firmware_version:8:40}
echo "Name, Version............ "$os_name $os_version "("$os_codename")"
if [ "$arch" = "aarch64" ]; then
	echo "Architecture............. 64-bit"
else
	echo "Architecture............. 32-bit"
fi
echo "Firmware................. "$firmware_version "("$firmware_date")"
echo
echo -e "${color_green}Linux-Kernel:${color_reset}"
uname -r -v -m # Reading the installed kernel version
echo
echo -e "${color_green}Java Runtime:${color_reset}"
java -version # Looking for the installed Java version
echo
echo

echo -e "${color_yellow}### Hardware-Information ###${color_reset}"
echo
echo -e "${color_yellow}Raspberry Pi Model:${color_reset}"
echo -e "${revision_codes[$revision]}"
echo
echo -e "${color_yellow}Hardware:${color_reset}"
sudo cpufreq-set -g performance # Setting CPU govenor to performance
freq_arm=$(vcgencmd measure_clock arm) # Reading the current ARM frequency
freq_arm=${freq_arm:14:10}
freq_arm=$(convert_to_MHz $freq_arm)
freq_pllb=$(vcgencmd measure_clock pllb) # Reading the current PLLB frequency
freq_pllb=${freq_pllb:15:10}
freq_pllb=$(convert_to_MHz $freq_pllb)
freq_core=$(vcgencmd measure_clock core) # Reading the current Core frequency
freq_core=${freq_core:13:10}
freq_core=$(convert_to_MHz $freq_core)
freq_mem=$(vcgencmd get_config sdram_freq) # Check config if a memory clock is set
freq_mem=${freq_mem:11:4}
if (("$freq_mem" == 0)); then # If no memory clock is set, use stock speed
	freq_mem="$freq_mem_stock"
fi
freq_mem_ddr="$(($freq_mem * 2))" # Setting the effective clock for DDR-RAM
cores_total=$(lscpu | grep "CPU(s):" | rev | cut -c 1 | rev)
cores_active=$(lscpu | grep "Core(s) per socket:" | rev | cut -c 1 | rev)
mem_cpu=$(vcgencmd get_mem arm) # Reading the memory reserved for CPU
mem_cpu=${mem_cpu:4:5}
mem_gpu=$(vcgencmd get_mem gpu) # Reading the memory reserved for GPU
mem_gpu=${mem_gpu:4:5}
echo "Frequency (ARM).......... $freq_arm MHz (PLLB: $freq_pllb MHz)"
echo "Frequency (Core)......... $freq_core MHz"
echo "Frequency (RAM).......... $freq_mem_ddr MHz"
echo "ARM-Cores (active/total). $cores_active/$cores_total"
echo "Memory Split (CPU/GPU)... $mem_cpu/$mem_gpu"
echo
echo -e "${color_yellow}Sensor Data (1/2):${color_reset}"
volt_arm=$(vcgencmd measure_volts core) # Reading the current VDD_CORE
volt_arm=${volt_arm:5:4}
over_voltage_arm=$(vcgencmd get_config over_voltage) # Check config if an ARM-overvoltage-setting is set
over_voltage_arm==${over_voltage_arm:13:4}
volt_mem=$(vcgencmd measure_volts sdram_c) # Reading the current V_DDR
volt_mem=${volt_mem:5:4}
over_voltage_sdram=$(vcgencmd get_config over_voltage_sdram) # Check config if a RAM-overvoltage-setting is set
over_voltage_sdram=${over_voltage_sdram:18:4}
soc_temp_idle=$(vcgencmd measure_temp) # Reading the SoC idle temperature w/o load
soc_temp_idle=${soc_temp_idle:5:7}
soc_temp_idle=${soc_temp_idle:0:-2}
echo "Voltage (VDD_CORE)....... $volt_arm V (over_voltage$over_voltage_arm)"
echo "Voltage (V_DDR).......... $volt_mem V (over_voltage_sdram$over_voltage_sdram)"
echo "SoC-Temperature (Idle)... $soc_temp_idle °C"
if [ "$bcm2711_soc" = true ] ; then
	pmic_temp_idle=$(vcgencmd measure_temp pmic) # Reading the PMIC idle temperature w/o load
	pmic_temp_idle=${pmic_temp_idle:5:7}
	pmic_temp_idle=${pmic_temp_idle:0:-2}
	echo "PMIC-Temperature (Idle).. $pmic_temp_idle °C"
fi
echo
echo

echo -e "${color_red}### Benchmark ###${color_reset}"
echo
date_time=`date '+%Y-%m-%d_%H.%M.%S'` # Creating the current time stamp
if [ "$arch" = "aarch64" ]; then # If OS is 64-bit, HWBOT Prime 1.0.1 is used.
	java -jar hwbotprime-1.0.1.jar "$date_time"_"$freq_arm"arm_"$freq_core"core_"$freq_mem_ddr"mem.hwbot
else # If OS is 32-bit, HWBOT Prime 0.8.3 is used.
	java -jar hwbotprime-0.8.3.jar "$date_time"_"$freq_arm"arm_"$freq_core"core_"$freq_mem_ddr"mem.hwbot
fi
echo

echo -e "${color_yellow}Sensor Data (2/2):${color_reset}"
soc_temp_load=$(vcgencmd measure_temp) # Reading the SoC temperature after load
soc_temp_load=${soc_temp_load:5:7}
soc_temp_load=${soc_temp_load:0:-2}
echo "SoC-Temperature (Load)... $soc_temp_load °C"
if [ "$bcm2711_soc" = true ] ; then
	pmic_temp_load=$(vcgencmd measure_temp pmic) # Reading the PMIC temperature after load
	pmic_temp_load=${pmic_temp_load:5:7}
	pmic_temp_load=${pmic_temp_load:0:-2}
	echo "PMIC-Temperature (Load).. $pmic_temp_load °C"
fi
echo
echo

# Comparing the SHA256-checksums for script & benchmarks
echo -e "${color_magenta}### Checksums ###${color_reset}"
echo
checksum_script=$(cat sha256sums | grep "rpi_hwbot.sh" | rev | cut -c 15-79 | rev)
if [[ $(sha256sum $script) = "$checksum_script  rpi_hwbot.sh" ]]; then
	echo -e "Benchmark Script......... ${color_green}PASSED${color_reset}"
else 
	echo -e "Benchmark Script......... ${color_red}FAILED${color_reset}"
fi
if [ "$arch" = "aarch64" ]; then
	checksum_hwbotprime_101=$(cat sha256sums | grep "hwbotprime-1.0.1.jar" | rev | cut -c 23-87 | rev)
	if [[ $(sha256sum hwbotprime-1.0.1.jar) = "$checksum_hwbotprime_101  hwbotprime-1.0.1.jar" ]]; then
		echo -e "HWBOT Prime 1.0.1........ ${color_green}PASSED${color_reset}"
	else
		echo -e "HWBOT Prime 1.0.1........ ${color_red}FAILED${color_reset}"
	fi
else
	checksum_hwbotprime_083=$(cat sha256sums | grep "hwbotprime-0.8.3.jar" | rev | cut -c 23-87 | rev)
	if [[ $(sha256sum hwbotprime-0.8.3.jar) = "$checksum_hwbotprime_083  hwbotprime-0.8.3.jar" ]]; then
		echo -e "HWBOT Prime 0.8.3........ ${color_green}PASSED${color_reset}"
	else
		echo -e "HWBOT Prime 0.8.3........ ${color_red}FAILED${color_reset}"
	fi
fi

sudo cpufreq-set -g ondemand # Setting CPU govenor back to ondemand
echo