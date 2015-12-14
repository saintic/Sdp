
function create_svn() 
{
#arg:$init_user $init_passwd
init_user_home_svnroot=${init_user_home}/$init_user
svnadmin create $init_user_home_svnroot ; chown -R apache:apache $init_user_home_svnroot
[ "$#" != "2" ] && ERROR
cat >> $svnconf <<EOF

<Location /sdi/$1>
   DAV svn
   SVNPath $init_user_home_svnroot
   AuthType Basic
   AuthName "Welcome to Sdp CodeSourceRoot."
   AuthUserFile $httpasswd
   #SSLRequireSSL
  <LimitExcept GET PROPFIND OPTIONS REPORT>
    Require valid-user
  </LimitExcept>
</Location>
EOF
[ -e $httpasswd ] && htpasswd -mb $httpasswd $1 $2 || htpasswd -bc $httpasswd $1 $2
/etc/init.d/httpd reload
}

function AutoUpdateSvn() {
cd $init_user_home ; svn co https://saintic.top/sdi/$init_user root;
cd ${init_user_home_svnroot}/hooks/;
cat > post-commit <<EOF
#!/bin/bash
export LC_CTYPE=en_US.UTF-8
export LANG=en_US.UTF-8
cd $init_user_home_root ;  svn up
EOF
chmod -R 777 post-commit
chown -R apache.apache post-commit
chmod -R 777 $init_user_home_root
}


