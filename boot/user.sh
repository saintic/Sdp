#!/bin/bash
source ../global.func
[ -z $INIT_HOME ] && ERROR

useradd -d ${INIT_HOME}/${init_user} -s /sbin/nologin $init_user
export file_dir=${INIT_HOME}/${init_user}
source ./file.sh
