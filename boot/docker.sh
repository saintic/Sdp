#!/bin/bash
#create service/application
#portmap:expose `cat $portmap_file`,comment:user_id
#Now we're just opening a IP:PORT!
#define range:5000>>=portmap=<<5999
source $SDP_HOME/global.func

[ -z $INIT_HOME ] && ERROR
[ -z $init_user ] && ERROR
[ -z $init_user_home ] && ERROR
[ -z $init_user_home_info ] && ERROR
[ -z $portmap_file ] && ERROR
[ -z $init_service_type ] && ERROR
export portmap=`cat $portmap_file`
cat >> $init_user_home_info <<EOF
182.92.106.104:$portmap
EOF

source $SDP_HOME/builds/builds.sh
