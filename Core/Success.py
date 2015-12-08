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
            #subprocess.call(['db_load -T -t hash -f ' + Config.FTP_VFTPUSERFILE + ' ' + Config.FTP_VFTPUSERDBFILE], shell=True)
            #subprocess.call(['/etc/init.d/vsftpd restart'], shell=True)
            #subprocess.call(['chown -R ' + Config.FTP_VFTPUSER + ':' + Config.FTP_VFTPUSER + ' ' + self.userhome], shell=True)
            #subprocess.call(['chmod -R a+t ' + self.userhome], shell=True)

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
        '''
        status,output = commands.getstatusoutput(Config.NGINX_EXEC + ' -s reload')
        if status == 0:
            if os.environ['LANG'].split('.')[0] == 'zh_CN':
                print 'Success:Reload Nginx' + ' ' * 39 + '[' + '\033[0;32;40m确定\033[0m' + ']'
            else:
                print 'Success:Reload Nginx' + ' ' * 39 + '[ ' + '\033[0;32;40m OK \033[0m' + ' ]'
        else:
            print "\033[0;31;40mRelod Nginx Error:\033[0m", output
        '''
