#!/bin/bash
#SaintIC Sdp svn.
yum -y install httpd subversion mod_ssl mod_dav_svn
svnconf=/etc/httpd/conf.d/subversion.conf
mv $svnconf ${svnconf}.bak
cat > $svnconf<<EOF
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
htpasswd -c /data/repos/.passwd test test

