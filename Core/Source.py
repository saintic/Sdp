#!/usr/bin/env python
#-*- coding=utf8 -*-
__date__ = '2015-11-12'
__doc__ = 'If type = WEBS, next nginx and code manager(ftp,svn)'

import os, Config, Redis

class CodeManager():


    def __init__(self, **kw):
        self.user         = kw
        self.name         = self.user['name']
        self.passwd       = self.user['passwd']
        self.userhome     = self.user['userhome']
        self.ip           = self.user['ip']
        self.port         = self.user['port']
        self.dn           = self.user.get('dn', None)
        self.user_repo    = os.path.join(Config.SVN_ROOT, self.name)
        self.user_gitrepo = os.path.join(Config.GIT_ROOT, self.name) + '.git'

    def ftp(self):
        if Config.FTP_TYPE == 'virtual':
            ftp_user_list = "%s\n%s\n" %(self.name, self.passwd)
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
            from sh import db_load, Command, chown, chmod
            db_load("-T", "-t", "hash", "-f", Config.FTP_VFTPUSERFILE, Config.FTP_VFTPUSERDBFILE)
            vsftpd=Command(Config.FTP_SCRIPT)
            vsftpd('restart')

    def CreateApacheSvn(self, connect):
        from sh import svnadmin, chown, htpasswd, apachectl
        if not os.path.exists(Config.SVN_ROOT):
            os.mkdir(Config.SVN_ROOT)
        svnadmin('create', self.user_repo)
        chown('-R', Config.HTTPD_USER + ':' + Config.HTTPD_GROUP, self.user_repo)
        http_user_repo_content = r'''<Location /sdp/%s>
    DAV svn
    SVNPath %s
    AuthType Basic
    AuthName "Welcome to Sdp CodeRoot!"
    AuthUserFile %s
    <LimitExcept GET PROPFIND OPTIONS REPORT>
        Require valid-user
    </LimitExcept>
</Location>
''' % (self.name, self.user_repo, Config.SVN_PASSFILE)

        https_user_repo_content = r'''<Location /sdp/%s>
    DAV svn
    SVNPath %s
    AuthType Basic
    AuthName "Welcome to Sdp CodeRoot!"
    AuthUserFile %s
    SSLRequireSSL
    <LimitExcept GET PROPFIND OPTIONS REPORT>
        Require valid-user
    </LimitExcept>
</Location>
''' % (self.name, self.user_repo, Config.SVN_PASSFILE)

        if connect == 'http':
            user_repo_content = http_user_repo_content
        elif connect == 'https':
            user_repo_content = https_user_repo_content
        else:
            raise TypeError('Only support http or https.')

        with open(Config.HTTPD_CONF, 'a+') as f:
            f.write(user_repo_content)

        if os.path.exists(Config.SVN_PASSFILE):
            htpasswd('-mb', Config.SVN_PASSFILE, self.name, self.passwd)
        else:
            htpasswd('-cb', Config.SVN_PASSFILE, self.name, self.passwd)

        apachectl('restart')  #sh.Command(script)

    def Svn(self):
        pass
        """
        from sh import svnadmin
        if not os.path.exists(Config.SVN_ROOT):
            raise IOError('Not such directory: %s' % Config.SVN_ROOT)
        svnadmin('create', self.user_repo)
        user_repo_authz = "[%s:/]\n%s=rw\n*=r\n" %(self.name, self.name)
        user_pass_content = "%s=%s\n" %(self.name, self.passwd)
        with open(Config.SVN_AUTH, 'a+') as f:
            f.write(user_repo_authz)
        with open(Config.SVN_PASSFILE, 'a+') as f:
            f.write(user_pass_content)
        """

    def initSvn(self, file_content):
        from sh import svn, chmod, chown
        repourl = Config.SVN_ADDR + self.name
        hook_content = r'''#!/bin/bash
export LC_CTYPE=en_US.UTF-8
export LANG=en_US.UTF-8
svn up %s
''' % self.userhome
        #auto update with hook
        os.chdir(os.path.join(self.user_repo, 'hooks'))
        with open('post-commit', 'w') as f: f.write(hook_content)
        chmod('-R', 777, self.user_repo)
        #checkout add ci for init
        svn('co', '--non-interactive', '--trust-server-cert', repourl, self.userhome)
        chown('-R', Config.HTTPD_USER + ':' + Config.HTTPD_GROUP, self.userhome)
        os.chdir(self.userhome)
        with open('index.html', 'w') as f:
            f.write(file_content)
        svn('add', 'index.html')
        svn('ci', '--username', self.name, '--password', self.passwd, '--non-interactive', '--trust-server-cert', '-m', 'init commit', '--force-log')

    def Git(self):
        from sh import git,chown
        git('init', '--bare', self.user_gitrepo)
        chown('-R', Config.GIT_USER, self.user_gitrepo)

    def initGit(self, file_content):
        from sh import git
        git_repourl = 'git@' + Config.GIT_SVR + ':' + self.user_gitrepo
        os.chdir(Config.SDP_USER_DATA_HOME)
        git('clone', git_repourl)
        #git of add ci push
        os.chdir(self.userhome)
        with open('index.html', 'w') as f:
            f.write(file_content)
        git('add', 'index.html')
        git('commit', '-m', 'init commit')
        git('push', 'origin', 'master')
        #git of hooks, for update code
        post-update = r'''
#!/bin/bash
unset $(git rev-parse --local-env-vars)
DeployPath=%s
echo -e "\033[33mDeploy path is => ${DeployPath}\033[0m"
[ ! -d $DeployPath ] && echo -e "\033[31mDirectory $DeployPath does not exist!\033[0m" && exit 1
cd $DeployPath
git pull
if test $? -ne 0;then
    echo -e "\033[31mAutomatic pull fail, try to re deploy!\033[0m"
    cd ~
    rm -rf ${DeployPath}/*
    rm -rf ${DeployPath}/.git
    git clone %s $DeployPath
    [ $? -ne 0 ] && echo -e "\033[31mRedeploy fail, quit!\033[0m" && exit 1
fi
echo -e "\033[32mDeploy done!\033[0m"
exit 0
        ''' %(self.userhome, git_repourl)
        with open(os.path.join(self.user_gitrepo, 'hooks/post-update'), 'w') as f:
            f.write(post-update)
        #private publick key

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
