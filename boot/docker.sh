#!/bin/bash
#create service/application
#portmap:expose `cat $portmap_file`,comment:user_id
#Now we're just opening a IP:PORT!
#define range:5000>>=portmap=<<5999
source ../global.func

[ -z $INIT_HOME ] && ERROR
[ -z $init_user ] && ERROR
[ -z $init_user_home ] && ERROR
[ -z $init_user_home_info ] && ERROR
[ -z $portmap_file ] && ERROR
[ -z $init_service_type ] && ERROR

cat > ${init_user_home}/info


source ../builds/builds.sh
