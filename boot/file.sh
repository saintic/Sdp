#!/bin/bash
source ../global.func
[ -z $file_dir ] || ERROR
[ -z $INIT_HOME ] && ERROR
[ -z $init_file_type ] && ERROR

if [ "$init_file_type" == "svn" ]; then
  svnadmin create $file_dir
elif [ "$init_file_type" == "ftp" ]; then
  create_ftp $init_user $init_passwd
fi

