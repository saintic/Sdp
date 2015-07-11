#!/bin/bash
#SaintIC Sdp svn.
source /etc/profile
yum -y install httpd subversion mod_ssl mod_dav_svn
sed -i "s/#ServerName www.example.com:80/ServerName ${HOSTNAME}/g" /etc/httpd/conf/httpd.conf
svnconf=/etc/httpd/conf.d/subversion.conf
mv $svnconf ${svnconf}.bak
cat > $svnconf<<EOF
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
   #SSLRequireSSL
  <LimitExcept GET PROPFIND OPTIONS REPORT>
    Require valid-user
  </LimitExcept>
</Location>
EOF
mkdir -p /data/repos/ && svnadmin create /data/repos/test
htpasswd -bc /data/repos/.passwd test test
echo "Ending,Succeed!!!"
echo "Please install SSL certs and enable SSLRequireSSL in 22 line."
