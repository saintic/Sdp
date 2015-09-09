#!/bin/bash
#SaintIC Sdp svn.
source /etc/profile
httpconf="/etc/httpd/conf/httpd.conf"
svnconf="/etc/httpd/conf.d/subversion.conf"
yum -y install httpd subversion mod_ssl mod_dav_svn openssl openssl-devel
sed -i "s/#ServerName www.example.com:80/ServerName ${HOSTNAME}/g" $httpconf
sed -i "s/Listen 80/#Listen 80/g" $httpconf
openssl req -new -x509 -days 3650 -keyout server.key -out server.crt -subj '/CN=Test-only certificate' -node
mv -f server.key /etc/pki/tls/private/localhost.key 
mv -f server.crt /etc/pki/tls/certs/localhost.crt
mv ${svnconf} ${svnconf}.bak
cat > $svnconf <<EOF
LoadModule dav_svn_module     modules/mod_dav_svn.so
LoadModule authz_svn_module   modules/mod_authz_svn.so
<Directory "/data/">
  Order allow,deny
  Allow from all
</Directory>
<Location /sdi/test>
   DAV svn
   SVNPath /data/repos/test
   AuthType Basic
   AuthName "SDI Code Service"
   AuthUserFile /data/repos/.passwd
  <LimitExcept GET PROPFIND OPTIONS REPORT>
    Require valid-user
  </LimitExcept>
</Location>
EOF
mkdir -p /data/repos/ && svnadmin create /data/repos/test
htpasswd -bc /data/repos/.passwd test test
/etc/init.d/httpd start
if [ `netstat -anptl|grep httpd|wc -l` -ge 1 ];then
  echo "Ending,Succeed!!!"
else
  echo "Start Fail"
fi
