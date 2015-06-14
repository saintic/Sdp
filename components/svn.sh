#!/bin/bash
#SaintIC Sdp svn.
yum -y install httpd subversion mod_ssl mod_dav_svn
svnconf=/etc/httpd/conf.d/subversion.conf
mv $svnconf ${svnconf}.bak
cat > $svnconf<<EOF
LoadModule dav_svn_module     modules/mod_dav_svn.so
LoadModule authz_svn_module   modules/mod_authz_svn.so
<Directory "/svn/">
	Order allow,deny
	Allow from all
</Directory>
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
   Satisfy Any
   SSLRequireSSL
  <LimitExcept GET PROPFIND OPTIONS REPORT>
    Require valid-user
  </LimitExcept>
</Location>
EOF
mkdir -p /data/repos/ && svnadmin create /data/repos/test
htpasswd -bc /data/repos/.passwd test test
echo "Ending,Succeed!!!"
echo "Please install SSL certs.If no, disable SSLRequireSSL."
