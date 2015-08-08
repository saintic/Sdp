#!/bin/bash
#need: $0 user use_time service_type file_type email;
export LANG=zh_CN.UTF-8
export SDP_HOME=$(cd `dirname $0`; pwd)
source ${SDP_HOME}/global.func

#判断入参及入参要求是否符合。
if [ "$#" = 5 ]; then
  if [[ $3 -le 0 ]]; then echo "第三个参数要求大于0，即使用期限大于一个月！" 2>&1 ; ERROR ; fi
elif [ "$#" != "5" ]; then
  cat << HELP
此脚本需要五个参数，分别是user(用户) use_time(使用时间，单位月) service_type(服务) file_type(文件类型) email(用户邮箱)。
要求：
1).用户名不冲突，同个用户需要多个服务当前版本必须多次以不同user执行；
2).使用时间不限，至少1个月(当前版本并不限制此值为0)；
3).服务类型：nginx、httpd、tomcat、mysql、mongodb、redis、memcached;
4).文件类型：若为web类型可支持ftp、svn，若为app类型默认无；
5).邮件提醒：部署成功后会发给用户一封信息邮件(确保不在垃圾邮件中)，大致内容包括用户名、密码、验证邮箱、服务类型，若为web服务类型则包含域名信息，否则为IP+PORT信息，若文件类型是svn则包含用户版本库地址，否则为FTP地址，最后是FAQ链接，此链接详细讲解用户应该如果使用邮件的信息。
HELP
  exit 1
fi

#Create a random password encrypted by MD5 and email user.
export init_user=$1
export use_time=$2
export init_passwd=`MD5PASSWD`
export init_service_type=$3
export init_file_type=$4
export user_email=$5
export INIT_HOME=/data/SDI.Sdp
export Sdpuc=${INIT_HOME}/Sdp.Ucenter                   #file
export init_user_home=${INIT_HOME}/$init_user           #directory
export init_user_home_info=${init_user_home}/info       #file
export init_user_home_root=${init_user_home}/root       #directory

#创建Sdp数据根目录
if [ -d $INIT_HOME ]; then
  [ -d $init_user_home ] && echo -e "\033[31mThe user already exists\033[0m" 2>&1 && exit 1
else
  mkdir -p $INIT_HOME
fi

#创建Sdp用户数据文件，JSON格式，方便tools工具后续工作。
[ -f $Sdpuc ] || cat > $Sdpuc <<EOF
{
  "SdpHome": "$INIT_HOME",
  "SdpUC": "$Sdpuc",
  "SdpIP": "$SERVER_IP",
}
EOF

#获取用户数，如果没有即为空，UID唯一且递增。
user_oid=$(grep user_id $Sdpuc | tail -1 | awk -F : '{print $2}')
if [ -z $user_oid ] || [ "$user_oid" = "" ]; then
  export user_id=1
else
  export user_id=`expr $user_oid + 1`
fi

#制定服务使用期限。
CreateTime=`date +%Y%m%d`
ExpirationTime=`date +%Y%m%d -d "$use_time month"`

#判断服务类型，APP型和WEB型，并触发不同类型的脚本。
if echo "${webs[@]}" | grep -w $init_service_type &> /dev/null ;then
  if [[ `echo "$init_file_type"` == "-" ]]; then
    echo -e -n "\033[31mUnsupported file type:\033[0m" 2>&1 ;\
    echo -e "\033[31mAppsTypeService need svn or ftp\033[0m" 2>&1
    exit 1
  else
    source ${SDP_HOME}/boot/web.sh
  fi
elif echo "${apps[@]}" | grep -w $init_service_type &> /dev/null ;then
  if [[ `echo "$init_file_type"` == "-" ]]; then
    source ${SDP_HOME}/boot/app.sh
  else
    export init_file_type="-"
    echo -e "\033[31mFile type is set to null\033[0m" 2>&1 ;\
    source ${SDP_HOME}/boot/app.sh	
  fi
else
  echo -e "\033[31mUnsupported service type:\033[0m" 2>&1 ;\
  echo -e "\033[31mSupported service:redis,mongodb,memcached,mysql,nginx,httpd,tomcat.\033[0m" 2>&1
  exit 1
fi

