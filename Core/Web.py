#!/usr/bin/env python
#-*- coding=utf8 -*-

import os
import Docker
import Config
import Public
import Redis
import Mail

def StartWeb(**user):
    if not isinstance(user, (dict)):
        raise TypeError('StartAll need a dict(user).')

    name, passwd, time, service, email = user['name'], user['passwd'], str(user['time']), user['service'], user['email']
    dn = name + Config.DN_BASE
    PORT, image = Public.Handler(service)
    userhome = os.path.join(Config.SDP_USER_DATA_HOME, name)

    #docker network mode is 'bridge' or 'host'(not allow none and ContainerID)
    if user['network'] != None:
        docker_network_mode = user['network']
    else:
        if Config.DOCKER_NETWORK not in ['bridge', 'host']:
            raise TypeError('Unsupport docker network mode')
        else:
            docker_network_mode = Config.DOCKER_NETWORK

    #define other code type, default is only ftp, disable svn and git, but SVN and git can't exist at the same time!
    """
    About svn, if the command line is True(--enable-svn), then will follow the svn-type settings.
    If there is a svn-type setting, you can choose "svn_type" for 'http' or 'https'.
    If there is no svn-type settings, then you will read the configuration file settings.
    However, if the configuration file is set to none, it means that the SVN is not enabled.
    """
    if user['enable_svn'] != None:
        enable_svn = True
        if user['svn_type'] != None:
            svn_type = user['svn_type']
        else:
            svn_type = Config.SVN_TYPE
        if svn_type == "none" or svn_type == "svn":
            enable_svn = False
    else:
        enable_svn = False

    svn_repo = Config.SVN_ADDR + name

    """
    Git是什么？
    Git是目前世界上最先进的分布式版本控制系统（没有之一）。
    Git有什么特点？简单来说就是：高端大气上档次！
    The Git feature that really makes it stand apart from nearly every other SCM out there is its branching model.
    Git allows and encourages you to have multiple local branches that can be entirely independent of each other. The creation, merging, and deletion of those lines of development takes seconds.
    """
    if user['enable_git'] != None:
        enable_git = True
        git_repo = 'git@' + Config.GIT_SVR + ':' + os.path.join(Config.GIT_ROOT, name) + '.git'
    else:
        enable_git = False

    #make repo info, make a choice
    if enable_svn == False:
        if enable_git == False:
            repos = "None"
        else:
            repos = "git=> " + git_repo
    if enable_svn == True:
        if enable_git == True:
            #repos = "svn=> " + svn_repo, "git=> "+git_repo
            print "\033[0;31;40mSorry...You have to make a choice between SVN and git, and you don't have to choose all of the options.\033[0m"
            exit()
        else:
            repos = "svn=> "+svn_repo

    userinfo_user = r'''
Dear %s, 以下是您的SdpCloud服务使用信息！
账号: %s
密码: %s
使用期: %d个月
服务类型: %s
验证邮箱: %s
用户域名: %s
版本库信息: %s

更多使用方法请查询官方文档(www.saintic.com)，祝您使用愉快。 如果有任何疑惑，欢迎与我们联系:
邮箱: staugur@saintic.com
官网: http://www.saintic.com/
问题: https://github.com/saintic/Sdp/issues''' %(name, name, passwd, int(time), service, email, dn, str(repos))

    userinfo_welcome = r'''<!DOCTYPE html>
<html>
<head>
<title>User information for SdpCloud!</title>
</head>
<body>
<h1><center>Welcome %s:</center></h1>
<p>账号: %s</p>
<p>密码: %s</p>
<p>使用期: %d个月</p>
<p>服务类型: %s</p>
<p>验证邮箱: %s</p>
<p>用户域名: %s</p>
<p>版本库信息: %s</p>

<p>这是一个欢迎页面，请尽快使用FTP、SVN或Git覆盖此页面!</p>
<p><em>Thank you for using SdpCloud.</em></p>
</body>
</html>''' %(name, name, passwd, int(time), service, email, dn, str(repos))

    userinfo_admin = {
        "name": name,
        "passwd": passwd,
        "time": int(time),
        "service": service,
        "email": email,
        "image": image,
        "ip": "127.0.0.1",
        "port": int(PORT),
        "dn": dn,
        "userhome": userhome,
        "repo": str(repos),
        "expiretime": Public.Time(m=time),
        "network": docker_network_mode
    }

    #define instances for writing redis and sending email.
    rc = Redis.RedisObject()
    ec = Mail.SendMail()
    if rc.ping():
        import Source
        from sh import svn,chmod,chown
        Code = Source.CodeManager(**userinfo_admin)
        Code.ftp()

        if enable_svn == False and enable_git == False:
            os.mkdir(userhome)
            with open(os.path.join(userhome, 'index.html'), 'w') as f:
                f.write(userinfo_welcome)
            chown('-R', Config.FTP_VFTPUSER + ':' + Config.FTP_VFTPUSER, userhome)
            chmod('-R', 'a+t', userhome)

        if enable_svn == True:
            Code.CreateApacheSvn(connect=svn_type)
            Code.initSvn(userinfo_welcome)

        if enable_git == True:
            Code.Git()
            Code.initGit(userinfo_welcome)

        Code.Proxy()
        Dk = Docker.Docker(**{"image":image, "name":name, "port":Config.PORTNAT['web'], "bind":('127.0.0.1', PORT), "volume":userhome})
        cid = Dk.Create(mode=docker_network_mode)
        Dk.Start(cid)
        userinfo_admin["container"] = cid
        rc.hashset(**userinfo_admin)
        ec.send(name, email, userinfo_user)
    else:
        #raise an error for RedisConnectError(Error.py)
        print "\033[0;31;40mConnect Redis Server Error,Quit.\033[0m"
        sys.exit(7)
