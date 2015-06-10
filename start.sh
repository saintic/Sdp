#!/bin/bash
#manager components, boot paas, start services.
#user/passwd/service/file->user.file->dns.map->docker.service
#usage: $0 user passwd service file_type
#retrun: $0 successful, user passwd IP:Port(DNS) service file_directory.

source ./global.func
export INIT_HOME=/data/SDI.PaaS
[ "$#" != "4" ] || ERROR
export init_user=$1
export init_passwd=$2
export init_service_type=$3
export init_file_type=$4

source boot/user.file.sh
