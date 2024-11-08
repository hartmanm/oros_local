#!/bin/bash

# Copyright (c) 2021 Michael Neill Hartman. All rights reserved.
# mnh_license@proton.me
# https://github.com/hartmanm

# if using other than minimum powerlimit add here
MIN_LIST="1070:110 3060ti:115 3070:115 3080:215 3090:275"

ETH_ADDRESS="<your_eth_address_here>"

CORE_OVERCLOCK="0"
MEMORY_OVERCLOCK="800"

[[ `which ifconfig` != "" ]] && {
MAC=$(ifconfig -a | grep -Po 'HWaddr \K.*$')
} ## [[ `which ifconfig` != "" ]] && {
[[ `which ip` != "" ]] && {
MAC=$(ip link show | grep -Po 'ether \K.*$')
MAC=${MAC:0:17}
} ## [[ `which ip` != "" ]] && {
MAC_AS_WORKER=$(echo -n $MAC | tail -c -4 | sed 's|[:,]||g')

[[ -d Downloads ]] && cd /home/`whoami`; rm -rf Documents Downloads Music Pictures Public Templates Videos

[[ -e /home/`whoami`/lolMiner_v1.19_Lin64.tar.gz ]] || {
wget https://github.com/Lolliedieb/lolMiner-releases/releases/download/1.19/lolMiner_v1.19_Lin64.tar.gz
tar -xf /home/`whoami`/lolMiner_v1.19_Lin64.tar.gz
} ## [[ -e /home/`whoami`/lolMiner_v1.19_Lin64.tar.gz ]] || {

[[ -d /media/m1 ]] && {
[[ -d /media/m1/1.19 ]] || cp -rp /home/m1/1.19 /media/ramdisk/1.19
} ## [[ -d /media/m1 ]] && {

[[ `which xterm` == "" ]] && sudo pacman -Sy xterm -y

IS_AMD=$(lspci | grep VGA | grep -i amd)
IS_NVIDIA=$(lspci | grep VGA | grep -i nvidia)

[[ ${IS_AMD} != "" ]] && {
[[ -e /home/`whoami`/rocm-4.0.0.tar.gz ]] || {
wget https://github.com/RadeonOpenCompute/ROC-smi/archive/rocm-4.0.0.tar.gz
tar -xf /home/`whoami`/rocm-4.0.0.tar.gz
mv ROC-smi-rocm-4.0.0 rocm-smi
} ## [[ -e /home/`whoami`/rocm-4.0.0.tar.gz ]] || {

[[ `which make` == "" ]] && sudo pacman -S base-devel -y

[[ -d /home/`whoami`/opencl-amd ]] || {
cd /home/`whoami`
git clone https://aur.archlinux.org/opencl-amd.git; cd opencl-amd; makepkg -si
} ## [[ -d /home/`whoami`/opencl-amd ]] || {
} ## [[ ${IS_AMD} != "" ]] && {

WORKER="oros_local"

[[ ${IS_NVIDIA} != "" ]] && {
GPU_NAMES=""
POWER_LIMITS=""
generate_worker_name_gpu_types(){
NUMBER_OF_GPUS=$(nvidia-smi -L | tail -1 | awk '{print $2}' | tr -d ':' )
NUMBER_OF_GPUS=$(($NUMBER_OF_GPUS+1))
ITERATOR=0
while [[ $ITERATOR -ne $NUMBER_OF_GPUS ]]
do
[[ `nvidia-smi -i $ITERATOR -q | grep "Product Name" | awk '{print $(NF)}'` == "Ti" ]] && {
[[ ${GPU_NAMES} != "" ]] && {
GPU_NAMES="${GPU_NAMES}_`nvidia-smi -i $ITERATOR -q | grep \"Product Name\" | awk '{print $(NF-1)}'`ti"
} ## [[ ${GPU_NAMES} != "" ]] && {
[[ ${GPU_NAMES} == "" ]] && {
GPU_NAMES="`nvidia-smi -i $ITERATOR -q | grep \"Product Name\" | awk '{print $(NF-1)}'`ti"
} ## [[ ${GPU_NAMES} == "" ]] && {
} ## [[ `nvidia-smi -i $ITERATOR -q | grep "Product Name" | awk '{print $(NF)}'` == "Ti" ]] && {
[[ `nvidia-smi -i $ITERATOR -q | grep "Product Name" | awk '{print $(NF)}'` == "SUPER" ]] && {
[[ ${GPU_NAMES} != "" ]] && {
GPU_NAMES="${GPU_NAMES}_`nvidia-smi -i $ITERATOR -q | grep \"Product Name\" | awk '{print $(NF-1)}'`"
} ## [[ ${GPU_NAMES} != "" ]] && {
[[ ${GPU_NAMES} == "" ]] && {
GPU_NAMES="`nvidia-smi -i $ITERATOR -q | grep \"Product Name\" | awk '{print $(NF-1)}'`"
} ## [[ ${GPU_NAMES} == "" ]] && {
} ## [[ `nvidia-smi -i $ITERATOR -q | grep "Product Name" | awk '{print $(NF)}'` == "SUPER" ]] && {
[[ `nvidia-smi -i $ITERATOR -q | grep "Product Name" | awk '{print $(NF)}'` != "SUPER" && `nvidia-smi -i $ITERATOR -q | grep "Product Name" | awk '{print $(NF)}'` != "Ti" ]] && {
[[ ${GPU_NAMES} != "" ]] && {
GPU_NAMES="${GPU_NAMES}_`nvidia-smi -i $ITERATOR -q | grep \"Product Name\" | awk '{print $(NF)}'`"
} ## [[ ${GPU_NAMES} != "" ]] && {
[[ ${GPU_NAMES} == "" ]] && {
GPU_NAMES="`nvidia-smi -i $ITERATOR -q | grep \"Product Name\" | awk '{print $(NF)}'`"
} ## [[ ${GPU_NAMES} == "" ]] && {
} ## [[ `nvidia-smi -i $ITERATOR -q | grep "Product Name" | awk '{print $(NF)}'` != "SUPER" && `nvidia-smi -i $ITERATOR -q | grep "Product Name" | awk '{print $(NF)}'` != "Ti" ]] && {
ITERATOR=$(($ITERATOR+1))
done ## while [[ $ITERATOR -ne $NUMBER_OF_GPUS ]] && {
} ## generate_worker_name_gpu_types(){
generate_powerlimits(){
NUMBER_OF_GPUS=$(nvidia-smi -L | tail -1 | awk '{print $2}' | tr -d ':' )
NUMBER_OF_GPUS=$(($NUMBER_OF_GPUS+1))
ITERATOR=0
while [[ $ITERATOR -ne $NUMBER_OF_GPUS ]]
do
[[ ${POWER_LIMITS} != "" ]] && {
POWER_LIMITS="${POWER_LIMITS}_`nvidia-smi -i $ITERATOR -q | grep \"Min Power Limit\" | awk '{print $(NF-1)}' | tr '.' ' ' | awk '{print $1}'`"
} ##[[ ${POWER_LIMITS} != "" ]] && {
[[ ${POWER_LIMITS} == "" ]] && {
POWER_LIMITS="`nvidia-smi -i $ITERATOR -q | grep \"Min Power Limit\" | awk '{print $(NF-1)}' | tr '.' ' ' | awk '{print $1}'`"
} ## [[ ${POWER_LIMITS} == "" ]] && {
sudo nvidia-smi -i $ITERATOR -pl `nvidia-smi -i $ITERATOR -q | grep "Min Power Limit" | awk '{print $(NF-1)}' | tr '.' ' ' | awk '{print $1}'`
ITERATOR=$(($ITERATOR+1))
done ## while [[ $ITERATOR -ne $NUMBER_OF_GPUS ]] && {
} ## generate_powerlimits(){
raise_to_known_minimum_powerlimits(){
NUMBER_OF_GPUS=$(nvidia-smi -L | tail -1 | awk '{print $2}' | tr -d ':' )
NUMBER_OF_GPUS=$(($NUMBER_OF_GPUS+1))
ITERATOR=1
NAMES=$(echo ${GPU_NAMES} | tr '_ti' ' ')
while [[ $ITERATOR -ne $NUMBER_OF_GPUS+1 ]]
do
IS_KNOWN_MIN=$(echo ${NAMES} | awk -v i=$ITERATOR '{print $i}')
[[ `echo ${MIN_LIST} | grep ${IS_KNOWN_MIN}` != "" ]] && {
THE_MIN=$(echo ${MIN_LIST} | tr ' ' '\n' | grep ${IS_KNOWN_MIN} | tr ':' ' ' | awk '{print $NF}')
sudo nvidia-smi -i $(($ITERATOR-1)) -pl ${THE_MIN}
echo "raised $IS_KNOWN_MIN to ${THE_MIN}"
} ## [[ `echo ${MIN_LIST} | grep ${IS_KNOWN_MIN}` != "" ]] && {
ITERATOR=$(($ITERATOR+1))
done ## while [[ $ITERATOR -ne $NUMBER_OF_GPUS ]]
} ## raise_to_known_minimum_powerlimits(){
generate_worker_name_gpu_types
generate_powerlimits
raise_to_known_minimum_powerlimits
#WORKER="`ifconfig | grep \"inet addr\" | grep -v 127.0 | awk '{print $2}' | tr '.' ' ' | awk '{print $NF}'
#`_${GPU_NAMES}"
WORKER="${MAC_AS_WORKER}_${GPU_NAMES}"
GPUS=$(nvidia-smi --query-gpu=count --format=csv,noheader,nounits | tail -1)
NVD=nvidia-settings
sudo nvidia-smi -pm 1
gpu=0
while [[ $gpu -lt $GPUS ]]
do
${NVD} -a [gpu:$gpu]/GPUGraphicsClockOffset[2]=$CORE_OVERCLOCK
${NVD} -a [gpu:$gpu]/GPUMemoryTransferRateOffset[2]=$MEMORY_OVERCLOCK
${NVD} -a [gpu:$gpu]/GPUGraphicsClockOffset[3]=$CORE_OVERCLOCK
${NVD} -a [gpu:$gpu]/GPUMemoryTransferRateOffset[3]=$MEMORY_OVERCLOCK
gpu=$(($gpu+1))
done ## while [[ $gpu -lt $GPUS ]]
} ## [[ ${IS_NVIDIA} != "" ]] && {

[[ ${IS_AMD} != "" ]] && {
[[ ${IS_NVIDIA} == "" ]] && {
GPU_NAME=$(lspci | grep VGA | grep -i amd | tr ' ' '_' | tr '[]' '\n' | head -4 | tail -1 | tr '_' ' ' | awk '{print $(NF-1)}' | tr '/' ' ' | awk '{print $NF}')
WORKER="${MAC_AS_WORKER}_${GPU_NAME}"
#FAN_SPEED=25
POWERLIMIT_WATTS=115
CORE_OVERCLOCK_LEVEL=1
MEMORY_OVERCLOCK_LEVEL=3
#FAN_SP=$(awk "BEGIN {printf \"%.0f\n\", 255 * $FAN_SPEED/100}")
cd /home/`whoami`/rocm-smi
sudo ./rocm-smi -s
sudo ./rocm-smi -r
sudo ./rocm-smi --setperflevel high
sudo ./rocm-smi --setmclk $MEMORY_OVERCLOCK_LEVEL
sudo ./rocm-smi --setsclk $CORE_OVERCLOCK_LEVEL
sudo ./rocm-smi --setpoweroverdrive $POWERLIMIT_WATTS
#sudo ./rocm-smi --setfan $FAN_SP -f
} ## [[ ${IS_NVIDIA} == "" ]] && {
} ## [[ ${IS_AMD} != "" ]] && {

SPACE_7=" "
echo "
${SPACE_7}oros local
"
[[ ${IS_AMD} != "" ]] && {
echo " 
${SPACE_7}AMD GPUS: $IS_AMD
"
} ## [[ ${IS_AMD} != "" ]] && {
[[ ${IS_NVIDIA} != "" ]] && {
echo "
${SPACE_7}NVIDIA GPUS: $GPU_NAMES

${SPACE_7}POWERLIMITS are: $POWER_LIMITS

${SPACE_7}MINIMUM RAISED POWERLIMITS ARE: $MIN_LIST

${SPACE_7}CORE_OVERCLOCK is: $CORE_OVERCLOCK

${SPACE_7}MEMORY_OVERCLOCK is: $MEMORY_OVERCLOCK
"
} ## [[ ${IS_NVIDIA} != "" ]] && {
echo "${SPACE_7}ETH_ADDRESS is: $ETH_ADDRESS

${SPACE_7}WORKER is: $WORKER
"

[[ ${IS_NVIDIA} != "" ]] && cd /media/ramdisk/1.19
[[ ${IS_AMD} != "" ]] && cd /home/oros/1.19

xterm -geometry 100x80+700+0 -e ./lolMiner --algo ETHASH --pool us1.ethermine.org:4444 --user ${ETH_ADDRESS}.${WORKER}

exec true
