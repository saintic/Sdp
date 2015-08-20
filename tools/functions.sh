#!/bin/bash
export LANG="zh_CN.UTF-8"
export SERVER_IP="182.92.106.104"
export SdpHOME="/data/sdp"
export DataHome="/data/PaaSdp"
export SdpDataHOME="${DataHome}/USERS"
export SdpUC="${SdpDataHOME}/.Ucenter"
export PreciseTime=$(date +"%Y-%m-%d_%H:%M:%S")
export Users=$(ls -l ${SdpDataHOME} | awk '/^d/ {print $NF}')
export BakDir="${DataHome}/backup"
export LogFile="${DataHome}/logs/backup.log"

