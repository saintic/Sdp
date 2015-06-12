#!/bin/bash
if [ -z $1 ] || [ $# -gt 2 ] || [ $# -eq 0 ] ;then
cat<<EOF
$0 args:
  No.1:httpd or nginx
  No.2:If the first parameter is nginx, please enter a php-fpm user.
EOF
exit 1
fi
. ./functions
if [ "$1" == "httpd" ]; then
  CREATE_PHP $1
elif [ "$1" == "nginx" ]; then
  [ -z $2 ] && exit 1
  id -u $2 &> /dev/null || useradd -M -s /sbin/nologin $2
  CREATE_PHP $1 $2
fi
