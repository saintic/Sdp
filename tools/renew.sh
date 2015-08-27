#!/bin/bash
#crontab: run per 1min
#手工执行续费脚本，在用户目录创建renew文件，更新user.json和SdpUC
#获取user time
sd=$(cd `dirname $0`; pwd)
source ${sd}/functions.sh

#判断入参及入参要求是否符合。
if [ "$#" != 2 ]; then
  echo -e "\033[31m入参错误，要求:$0 user use_time\033[0m" 2>&1
  echo "${PreciseTime} ${user} ErrAction:\"入参错误,入参数量=$#<>2\"" >> $RenewLogFile
  exit 1
else
  user=$1
  time=$2
  if [ `jq .${user} $SdpUC` = "null" ]; then
    echo -e "\033[31mUsers do not exist\033[0m" 2>&1
    echo "${PreciseTime} ${user} ErrAction:\"Users do not exist\"" >> $RenewLogFile
	exit 1
  else
    if [[ "$time" =~ ^[0-9]+$ ]]; then
      :
    else
      echo "第二个参数要求为正整数，单位为月！"
      echo "${PreciseTime} ${user} ErrAction:\"使用时间参数错误\" " >> $RenewLogFile
      exit 1;
    fi
  fi
fi

UpdateUserInfo() {
updateUser=$user
updateExpirationTime=$(date -d "+${time} month ${getExpirationTime}" +%Y-%m-%d)
cat > ${SdpDataHOME}/${user}/user.json <<EOF
{
  "uid": "$getUID",
  "user": "$updateUser",
  "passwd": "$getPasswd",
  "home": "$getHome",
  "email": "$getEmail",
  "service": "$getService",
  "file": "$getFileType",
  "CreateTime": "$CreateTime",
  "ExpirationTime": "$updateExpirationTime",
  "container_id": "$getContainer_ID"
}
EOF
}

userjson="${SdpDataHOME}/${user}/user.json"
getUID=$(jq '.uid' $userjson | awk -F \" '{print $2}')
getPasswd=$(jq '.passwd' $userjson | awk -F \" '{print $2}')
getHome=$(jq '.home' $userjson | awk -F \" '{print $2}')
getEmail=$(jq '.email' $userjson | awk -F \" '{print $2}')
getService=$(jq '.service' $userjson | awk -F \" '{print $2}')
getFileType=$(jq '.file' $userjson | awk -F \" '{print $2}')
getExpirationTime=$(jq '.ExpirationTime' $userjson | awk -F \" '{print $2}')
getContainer_ID=$(jq '.container_id' $userjson | awk -F \" '{print $2}')

touch ${SdpDataHOME}/${user}/renew

