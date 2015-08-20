#!/bin/bash
#Backup user data
ScriptDIR=$(cd `dirname $0`; pwd)
source ${ScriptDIR}/functions.sh

BakDir="/data/backup"
DateTime=$(date +"%Y%m%d")
LogFile="${BakDir}/backup.log"
#Log Format:
#PreciseTime user service:create_time~exp_time backup_file

[ -d ${BakDir} ] || mkdir -p $BakDir
for user in $Users
do
  userbackupfile="${BakDir}/${user}/${DateTime}.tar.gz"
  userjson=${SdpDataHOME}/${user}/user.json
  UHome=$(jq '.home' ${userjson} | awk -F \" '{print $2}')
  UService=$(jq '.service' ${userjson} | awk -F \" '{print $2}')
  UCreateTime=$(jq '.CreateTime' ${userjson} | awk -F \" '{print $2}')
  UExpirationTime=$(jq '.ExpirationTime' ${userjson} | awk -F \" '{print $2}')
  if [ -z $user ]; then
    exit 1
  else
    mkdir -p ${BakDir}/${user} ; tar zcf ${userbackupfile} ${UHome}
    if [ -e $userbackupfile ]; then
      echo "${PreciseTime} ${user}:${UHome} ${UService}:${UCreateTime}~${UExpirationTime} ${userbackupfile}" >> ${LogFile}
      echo "" >> ${LogFile}
    else
      echo "不存在备份数据，脚本退出！"
	  exit 1
    fi
  fi
done
