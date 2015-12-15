#!/usr/bin/env python
#-*- coding=utf8 -*-
__date__ = '2015-11-12'
__doc__ = 'If type = WEBS, next nginx and code manager(ftp,svn)'

import os,Config,Redis

class CodeManager():
    def __init__(self, index):
        self.rc = Redis.RedisObject()
        if self.rc.ping():
            self.user = self.rc.hashget(index)
            self.name = self.user['name']
            self.passwd = self.user['passwd']
            self.userhome = self.user['userhome']
            self.ip = self.user['ip']
            self.port = self.user['port']
            self.dn = self.user.get('dn', None)
        else:
            pass

    def ftp(self):
        if Config.FTP_TYPE == 'virtual':
            ftp_user_list = r'''%s
%s
''' %(self.name, self.passwd)
            ftp_content_conf = r'''write_enable=YES
anon_world_readable_only=NO
anon_upload_enable=YES
anon_mkdir_write_enable=YES
anon_other_write_enable=YES
local_root=%s
''' % self.userhome
            with open(Config.FTP_VFTPUSERFILE, 'a+') as f:
                f.write(ftp_user_list)
            with open(os.path.join(Config.FTP_VFTPUSERDIR, self.name), 'w') as f:
                f.write(ftp_content_conf)
            #The module sh, not subprocess
            from sh import db_load,Command,chown,chmod
            db_load("-T", "-t", "hash", "-f", Config.FTP_VFTPUSERFILE, Config.FTP_VFTPUSERDBFILE)
            vsftpd=Command('/etc/init.d/vsftpd')
            vsftpd('restart')
            chown('-R', Config.FTP_VFTPUSER + ':' + Config.FTP_VFTPUSER, self.userhome)
            chmod('-R', 'a+t', self.userhome)

    def Proxy(self):
        ngx_user_conf = os.path.join(Config.PROXY_DIR, self.name) + '.conf'
        ngx_conf_content = r'''server {
    listen 80;
    server_name %s;
    index index.htm index.html index.php index.jsp;
    location / {
        proxy_pass http://%s:%s/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}''' %(self.dn, self.ip, int(self.port))
        with open(ngx_user_conf, 'w') as f:
            f.write(ngx_conf_content)
        from sh import nginx
        nginx('-s', 'reload')

    def CreateSvn(self): 
        from sh import svnadmin, chown
        svnadmin('create', self.userhome)
        chown -R apache:apache $init_user_home_svnroot
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


