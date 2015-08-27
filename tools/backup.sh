#!/bin/bash
#Backup user data
sd=$(cd `dirname $0`; pwd)
source ${sd}/functions.sh
DateTime=$(date +"%Y%m%d")

#Log Format:
#PreciseTime user service:create_time~exp_time backup_file

[ -d ${LogDIR} ] || mkdir -p $LogDIR
[ -d ${BakDIR} ] || mkdir -p $BakDIR
for user in $Users
do
  userbackupfile="${BakDIR}/${user}/${DateTime}.tar.gz"
  userjson=${SdpDataHOME}/${user}/user.json
  UHome=$(jq '.home' ${userjson} | awk -F \" '{print $2}')
  UService=$(jq '.service' ${userjson} | awk -F \" '{print $2}')
  UCreateTime=$(jq '.CreateTime' ${userjson} | awk -F \" '{print $2}')
  UExpirationTime=$(jq '.ExpirationTime' ${userjson} | awk -F \" '{print $2}')
  if [ -z $user ] || [ ! -e $UHome ]; then
    exit 1
  else
    mkdir -p ${BakDIR}/${user} ; tar zcf ${userbackupfile} ${UHome}
    if [ -e $userbackupfile ]; then
      echo "${PreciseTime} ${user}:${UHome} ${UService}:${UCreateTime}~${UExpirationTime} ${userbackupfile}" >> ${BackupLogFile}
      echo "" >> ${BackupLogFile}
    else
      echo "不存在备份数据，脚本退出！"
      exit 1
    fi
    if [ $(du -m $BackupLogFile | awk '{print $1}') -gt 18 ]; then
      tar zcf ${BackupLogFile}-${DateTime}.tar.gz ${BackupLogFile}
      echo "${PreciseTime} backup.log ${BackupLogFile}-${DateTime}.tar.gz" >> ${BackupLogFile}
    fi
  fi
done
