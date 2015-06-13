#!/bin/bash
#SaintIC Sdp svn.

<Directory "/svn/repos/">
	Order allow,deny
	Allow from all
</Directory>
<Location /repos/repo1>
   DAV svn
   SVNPath /svn/repos/repo1
   AuthType Basic
   AuthName "SDI Code Service"
   AuthUserFile /svn/webpasswd
   AuthzSVNAccessFile /svn/repos/repo1/conf/authz
   Satisfy Any
   Require valid-user
  <LimitExcept GET PROPFIND OPTIONS REPORT>
    Require valid-user
  </LimitExcept>
</Location>


