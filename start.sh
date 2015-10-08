#!/bin/bash
#need: $0 user use_time service_type file_type email;
export LANG=zh_CN.UTF-8
export SDP_HOME=$(cd `dirname $0`; pwd)
source ${SDP_HOME}/global.func

#Logs
[ -d $LogDir ] || mkdir -p $LogDir
[ -d $INIT_HOME ] || mkdir -p $INIT_HOME

#判断入参及入参要求是否符合。
if [ "$#" = 5 ]; then
  #判断用户是否存在
  if [ -d ${INIT_HOME}/$1 ]; then
    echo -e "\033[31mThe user already exists\033[0m" 2>&1
    echo "${PreciseTime} $1 $5 ErrAction:\"The user already exists\"" >> $Errlog
	exit 1
  fi
  #判断时间格式
  if [[ "$2" =~ ^[0-9]+$ ]]; then
    :
  else
    echo "第二个参数要求为正整数，单位为月！"
    echo "${PreciseTime} $1 $5 ErrAction:\"使用时间参数错误\" " >> $Errlog
    exit 1;
  fi
  #判断服务类型
  if echo "${services[@]}" | grep -w $3 &> /dev/null ;then
    :
  else
    echo -e "\033[31m不支持的服务类型\033[0m" 2>&1
    echo "${PreciseTime} $1 $5 ErrAction:\"不支持的服务类型\"" >> $Errlog
	exit 1
  fi
  #判断文件代码类型
  if [ $4 = "svn" ] || [ $4 = "ftp" ] || [ $4 = "-" ] || [ $4 = "null" ];then
    :
  else
    echo -e "\033[31m不支持的代码类型\033[0m" 2>&1
    echo "${PreciseTime} $1 $5 ErrAction:\"不支持的代码类型\"" >> $Errlog
	exit 1
  fi
  #判断邮箱格式
  if [[ `echo $5 | sed -r '/^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+(\.[a-zA-Z0-9_-])+/!d'` == "" ]]; then
    echo "邮箱格式不正确！"
    echo "${PreciseTime} ${init_user} ${user_email} ErrAction:\"邮箱格式不正确\" " >> $Errlog
    exit 1;
  fi
elif [ "$#" != "5" ]; then
  echo -e "\033[31mUsage: $0 user use_time service_type file_type email\033[0m"
  cat << HELP
此脚本需要五个入参:
1).用户名若发生冲突，同个用户需要多个服务当前版本必须多次以不同用户名执行;
2).使用时间不限，至少1个月;
3).服务类型：nginx、httpd、tomcat、mysql、mongodb、redis、memcached;
4).文件类型：若为web类型可支持ftp、svn，若为app类型默认无;
5).邮件提醒：部署成功后会发给用户一封服务信息邮件(确保不在垃圾邮件中)，包括服务到期、服务续费、服务停止提醒。
HELP
  echo "${PreciseTime} ${init_user} ${user_email} ErrAction:\"入参错误, args is $#\"" >> $Errlog
  exit 1
fi

#Create a random password encrypted by MD5 and email user.
export init_user=$1
export use_time=$2
export init_passwd=`MD5PASSWD`
export init_service_type=$3
export init_file_type=$4
export user_email=$5
export init_user_home=${INIT_HOME}/$init_user           #directory
export init_user_home_info=${init_user_home}/info       #file
export init_user_home_root=${init_user_home}/root       #directory


#创建Sdp用户数据文件，JSON格式，方便tools工具后续工作。
[ -f $Sdpuc ] || cat > $Sdpuc <<EOF
{
  "SdpHome": "${SDP_HOME}",
  "SdpDataHome": "${INIT_HOME}",
  "SdpUC": "${Sdpuc}",
  "SdpIP": "${SERVER_IP}",
  },
}
EOF

#获取用户文件，如果没有即为空，UID唯一且递增。
if [ -e $uidfile ];then
  export user_id=$((`cat $uidfile` + 1))
else
  export user_id=1
fi
echo "$user_id" > $uidfile

#制定服务使用期限。
CreateTime=$(date +%Y-%m-%d)
ExpirationTime=$(date +%Y-%m-%d -d "$use_time month")

#判断服务类型，APP型和WEB型，并触发不同类型的脚本。
if echo "${webs[@]}" | grep -w $init_service_type &> /dev/null ;then
  if [[ `echo "$init_file_type"` == "-" ]]; then
    echo -e -n "\033[31mUnsupported file type:\033[0m" 2>&1 ;\
    echo -e "\033[31mAppsTypeService need svn or ftp\033[0m" 2>&1
    echo "${PreciseTime} ${init_user} ${user_email} ErrAction:\"Unsupported file type\"" >> $Errlog
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
  echo "${PreciseTime} ${init_user} ${user_email} ErrAction:\"Unsupported service type\"" >> $Errlog
  exit 1
fi

