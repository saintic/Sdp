#/bin/bash
#tools Variable
export DataHOME="/data/SDI.Sdp"
export SdpUC=${DATA_HOME}/.Ucenter
export SdpHOME=$(jq '.SdpHome' $Sdpuc)
export PreciseTime=$(date +"%Y-%m-%d-%H:%M:%S")
export Users=$(ls -l $DataHOME | awk '/^d/ {print $NF}')

