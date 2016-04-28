#!/bin/bash
#init system service script

BASE=$(cd `dirname $0` ; pwd)
ProcessName=$(grep "ProcessName" ${BASE}/../config.py | grep -v ^$ | awk -F "ProcessName = " '{print $2}' | awk -F \" '{print $2}' | grep -v ^$)
ProductType=$(grep "ProductType" ${BASE}/../config.py | grep -v ^$ | awk -F "ProductType = " '{print $2}' | awk -F \" '{print $2}' | grep -v ^$)
ApplicationHome=$(grep "ApplicationHome" ${BASE}/../config.py | grep -v ^$ | awk -F "ApplicationHome = " '{print $2}' | awk -F \" '{print $2}' | grep -v ^$)
initd="/etc/init.d/sdp"

cat > $initd << 'EOF'
#!/bin/bash
# chkconfig: 46 35 101
# description: Daemon for ProcessName
# Source function library.
. /etc/rc.d/init.d/functions

exec="/usr/bin/python"

#You can define file with config.py.
app_name="ProcessName"
product_app="ProductType"
basedir="ApplicationHome"

#You can define file, but need permission.
pidfile="${basedir}/${app_name}.pid"
lockfile="${basedir}/${app_name}.lock"
logfile="${basedir}/access.log"

case $1 in
start)
    if [ -f $pidfile ]; then
        echo "$pidfile still exists..." ; exit 1
    else
        echo "Starting Application ${app_name}......"
        $exec ${basedir}/${product_app}_server.py &>> $logfile &
        pid=$!
        echo $pid > $pidfile
    fi
    ;;

stop)
    echo $"Stopping Application ${app_name}!"
    kill -9 `cat $pidfile`
    retval=$?
    [ $retval -eq 0 ] && rm -f $pidfile
    ;;

restart)
    $0 stop
    $0 start
    ;;

*)
    echo "Usage: $0 {start|stop|restart}"
    exit 2
    ;;
esac

exit $?
EOF

if [ -z $ProcessName ]; then
    ProcessName="SIC.SdpApi"
fi
sed -i "s/ProcessName/${ProcessName}/" $initd
sed -i "s/ProductType/${ProductType}/" $initd
sed -i "s#ApplicationHome#${ApplicationHome}#" $initd
chmod +x $initd
