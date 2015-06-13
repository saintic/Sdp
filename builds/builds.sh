#!/bin/bash
#boot services.
source $SDP_HOME/global.func
[ -z $init_service_type ] && ERROR


source $SDP_HOME/.end.sh
