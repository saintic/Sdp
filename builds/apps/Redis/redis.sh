#!/bin/bash
REDIS_VERSION=3.0.1
PACKAGE_PATH="/data/software"
APP_PATH="/data/app"
lock="/var/lock/subsys/paas.sdi.lock"

cat<<EOF
####################################################
##           程序版本请修改functions下各参数。    ##
##              若程序出错请查看错误信息。        ##
##作者信息:                                       ##
##    Author:   SaintIC                           ##
##    QQ：      1663116375                        ##
##    Phone:    18201707941                       ##
##    Design:   https://saintic.com/DIY           ##   
####################################################
EOF

function ERROR() {
  echo "Error:Please check this script and input/output!"
}

yum -y install wget tar gzip bzip2 gcc gcc-c++ make
[ -f $lock ] && echo "Please run \"rm -f $lock\", then run again." && exit 1 || touch $lock
if [ -f $PACKAGE_PATH/redis-${REDIS_VERSION}.tar.gz ] || [ -d $PACKAGE_PATH/redis-${REDIS_VERSION} ] ; then
  rm -rf $PACKAGE_PATH/redis-${REDIS_VERSION}*
fi
cd $PACKAGE_PATH ; wget -c http://download.redis.io/releases/redis-${REDIS_VERSION}.tar.gz || wget -c https://codeload.github.com/antirez/redis/tar.gz/$REDIS_VERSION && mv $REDIS_VERSION redis-${REDIS_VERSION}.tar.gz
tar zxf redis-${REDIS_VERSION}.tar.gz ; cd redis-$REDIS_VERSION
make
make install
cd utils ; sh install_server.sh
echo "vm.overcommit_memory = 1" >> /etc/sysctl.conf
sysctl -p
rm -f $lock
}

