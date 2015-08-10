#!/bin/bash
#获取用户到期信息，提前一周和两天邮件提醒用户
ScriptDIR=$(cd `dirname $0`; pwd)
source ${ScriptDIR}/functions.sh
export LANG=zh_CN.UTF-8

function EMAIL() {
#邮件对象及模板
mailx -s "尊敬的${getUSER}：" -r SdpTeam@saintic.com $getEmail <<EOF
你好！
    您的Sdp云服务${getService}将于${getExpirationTime} 00:00:00正式到期，如您要继续使用，请于到期前续费。
    如您逾期尚未续费，数据将为您保留七天，七天后彻底释放；若于${keepTime}前续费，您的云服务将继续使用；如果您已续费请忽略此信息。

祝您使用愉快。如果有任何疑惑，欢迎与我们联系:
    QQ:   1663116375
    Mail: staugur@saintic.com
    旺旺: 楠孩纸
    官网：https://saintic.com/
    微博：http://weibo.com/staugur/
    淘宝：https://shop126877887.taobao.com/
EOF
}

function EmailError() {
mailx -s "捕捉到错误信息，请及时处理:" -r SdpTeam@saintic.com $getEmail <<EOF

EOF
}

function STOP() {
#到期前没续费，触发stop动作，传递getContainer_ID参数
at 23:59 <<EOF
docker stop $1
EOF
}

function START() {
#根据服务类型启动服务
nginx)
  container_id=`docker run -tdi --restart=always --name $init_user -v ${init_user_home_root}:/data/wwwroot/html $container_nginx`
  docker exec -i $container_id /usr/sbin/nginx
  docker exec -i $container_id /etc/init.d/php-fpm start
  ;;
httpd)
  container_id=`docker run -tdi --restart=always --name $init_user -v ${init_user_home_root}:/data/wwwroot/html $container_httpd`
  docker exec -i $container_id /etc/init.d/httpd start
  ;;
tomcat)
  container_id=`docker run -tdi --restart=always --name $init_user -v ${init_user_home_root}:/data/wwwroot/html $container_tomcat`
  docker exec -i $container_id /usr/local/tomcat/bin/startup.sh   
  ;;
memcached)
  container_id=`docker run -tdi --restart=always --name $init_user -p ${SERVER_IP}:${portmap}:11211 $container_memcached`
  docker exec -i $container_id /usr/local/bin/memcached -d -u root
  ;;
mongodb)
  container_id=`docker run -tdi --restart=always --name $init_user -p ${SERVER_IP}:${portmap}:27017 $container_mongodb`
  docker exec -i $container_id /data/app/mongodb/bin/mongod -f /data/app/mongodb/mongod.conf &
  ;;
mysql)
  container_id=`docker run -tdi --restart=always --name $init_user -p ${SERVER_IP}:${portmap}:3306 $container_mysql`
  docker exec -i $container_id /etc/init.d/mysqld start
  docker exec -i $container_id mysql -e "grant all on *.* to 'root'@'%' identified by \"${init_passwd}\" with grant option;"
  docker exec -i $container_id mysql -e "grant all on *.* to 'root'@'localhost' identified by \"${init_passwd}\";"
  docker exec -i $container_id /etc/init.d/mysqld restart
  ;;
redis)
  container_id=`docker run -tdi --restart=always --name $init_user -p ${SERVER_IP}:${portmap}:6379 $container_redis`
  #docker exec -i sed -i 's/appendonly no/appendonly yes/' /etc/redis.conf
  docker exec -i $container_id /etc/init.d/redis start
}

function DEL() {
#续费用户会在用户主目录创建renew空文件，若存在则启动文件，若不存在
docker rm -f $1
}

function ACTION() {
#邮件提醒 开启、停止、删除服务
for user in $Users
do
  userjson=${DataHOME}/${user}/user.json
  getUID=$(jq '.uid' $userjson)
  getUSER=$(jq '.user' $userjson)
  getUHome=$(jq '.home' $userjson)
  getEmail=$(jq '.email' $userjson)
  getService=$(jq '.service' $userjson)
  getCreateTime=$(jq '.CreateTime' $userjson)
  getExpirationTime=$(jq '.ExpirationTime' $userjson)
  getContainer_ID=$(jq '.container_id' $userjson)
  RemindTimeTwo=$(date -d "-2 day ${getExpirationTime}" +%Y-%m-%d)
  RemindTimeWeek=$(date -d "-1 week ${getExpirationTime}" +%Y-%m-%d)
  keepTime=$(date -d "+1 week ${getExpirationTime}" +%Y-%m-%d)
  getToday=$(date +%Y-%m-%d)
if [[ "$getToday" == "$RemindTimeWeek" ]] || [[ "$getToday" == "$RemindTimeTwo" ]]; then
  EMAIL
elif [[ "$getToday" == "$getExpirationTime" ]]; then
  if [ -e ${getUHome}/renew ]; then
    START $getContainer_ID $getService $getToday
    rm -f ${getUHome}/renew
  else
    STOP $getContainer_ID
  fi
elif [[ "getToday" == "$keepTime" ]]; then
  DEL $getContainer_ID
fi
