#!/bin/bash
#Backup user data
ScriptDIR=$(cd `dirname $0`; pwd)
source ${ScriptDIR}/functions.sh

BakDir="/data/backup/"
DateTime=$(date +"%Y%m%d")
LogFile="${BakDir}/backup.log"
#Log Format:
#PreciseTime user service:create_time~exp_time backup_file

[ -d ${BakDir} ] || mkdir -p $BakDir
for user in Users ; do
  userbackupfile="${BakDir}/${DateTime}.tar.gz"
  userjson=${SdpDataHOME}/${user}/user.json
  UHome=$(jq '.home' ${userjson})
  UService=$(jq '.service' $userjson)
  UCreateTime=$(jq '.CreateTime' $userjson|awk -F \" '{print $2}')
  UExpirationTime=$(jq '.ExpirationTime' $userjson|awk -F \" '{print $2}')
  mkdir -p ${BakDir}/${user}
  tar zcf ${userbackupfile} $UHome
  echo "
${PreciseTime} ${user} ${UService}:${UCreateTime}~${UExpirationTime} ${userbackupfile}" >> ${LogFile}
done
