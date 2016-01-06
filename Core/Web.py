#!/usr/bin/env python
#-*- coding=utf8 -*-

import os
import Docker
import Config
import Public
import Redis
import Mail

def StartWeb(**user):
    print "StartAll, args is %s" % user
    if not isinstance(user, (dict)):
        raise TypeError('StartAll need a dict(user).')

    name, passwd, time, service, email = user['name'], user['passwd'], str(user['time']), user['service'], user['email']
    dn = name + Config.DN_BASE
    portfile = os.path.join(Config.SDP_DATA_HOME, 'port')
    PORT, image = Public.Handler()
    userhome = os.path.join(Config.SDP_USER_DATA_HOME, name)

    os.chdir(Config.SDP_USER_DATA_HOME)
    if not os.path.isdir(name):
        os.mkdir(name)

    #docker network mode='bridge' or 'host'(not allow none and ContainerID)
    if user['network'] != None:
        docker_network_mode = user['network']
    else:
        if Config.DOCKER_NETWORK not in ['bridge', 'host']:
            raise TypeError('Unsupport docker network mode')
        else:
            docker_network_mode = Config.DOCKER_NETWORK

    Dk = Docker.Docker("image":image, "name":name, "port":Config.PORTNAT['web'], "bind":('127.0.0.1', PORT), "volume":userhome)
    cid = Dk.Create(mode=docker_network_mode)
    Dk.Start(cid)

    #WEB, include code type, ftp svn git.
    userinfo_user = r'''
Dear %s, 以下是您的SdpCloud服务使用信息！
账号: %s
密码: %s
使用期: %d个月
服务类型: %s
验证邮箱: %s
连接域名: http://%s
版本库地址: %s

祝您使用愉快。如果有任何疑惑，欢迎与我们联系:
邮箱: staugur@saintic.com
官网: http://www.saintic.com/
问题: https://github.com/SaintIC/Sdp/issues''' %(name, name, passwd, int(time), service, email, str(conn), userrepo)

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
<p>连接域名: %s</p>

<p>这是一个欢迎页面，请尽快使用FTP、SVN或Git覆盖此页面!</p>
<p><em>Thank you for using SdpCloud.</em></p>
</body>
</html>''' %(name, name, passwd, int(time), service, email, str(conn))

    userconn = (name, email, userinfo_user)
    #define instances for writing redis and sending email.
    rc = RedisObject()
    ec = SendMail()

    userinfo_admin = {
        "name": name, 
        "passwd": passwd, 
        "time": int(time), 
        "service": service, 
        "email": email, 
        "image": image, 
        "ip": "127.0.0.1" 
        "port": int(PORT), 
        "dn": dn, 
        "userhome": userhome, 
        "repo": userrepo,
        "container": cid,
        "expiretime": Public.Time(m=time),
        "network": docker_network_mode
    }

    #start write data
    if rc.ping():
        if SdpType == "WEB":
            import Success
            from sh import svn

            Code = Success.CodeManager(**userinfo_admin)
            Code.ftp()
            with open(os.path.join(userhome, 'index.html'), 'w') as f:
                f.write(userinfo_welcome)

            #define other code type, default is only ftp, disable svn and git.
            """
            About svn, if the command line is True(--enable-svn), then will follow the svn-type settings.
            If there is a svn-type setting, you can choose "svn_type" for 'http' or 'https'.
            If there is no svn-type settings, then you will read the configuration file settings.
            However, if the configuration file is set to none, it means that the SVN is not enabled.
            """
            if user['enable_svn'] != None:
                enable_svn = user['enable_svn']
            else:
                enable_svn = False

            if user['svn_type'] != None:
                svn_type = user['svn_type']
            else:
                svn_type = Config.SVN_TYPE
                if svn_type == "none":
                    enable_svn = False

            if enable_svn == True:
                if svn_type == 'svn':
                    raise TypeError('Code type unsupport.')
                else:
                    Code.CreateApacheSvn(connect=Config.SVN_TYPE)
                    Code.initSvn(svntype=svn_type)
                    os.chdir(userhome)
                    svn('add', 'index.html')
                    svn('ci', '--username', name, '--password', passwd, '--non-interactive', '--trust-server-cert', '-m', 'init commit', '--force-log')

            """
            About git
            """
            Code.Proxy()

        rc.hashset(**userinfo_admin)
        ec.send(*userconn)
        #异步要保证写入数据库和文件中的数据都是正确的，抛出错误终止执行。
        with open(Config.SDP_UC, 'a+') as f:
            f.write(json.dumps(userinfo_admin))

    else:
        #raise an error for RedisConnectError(Error.py)
        print "\033[0;31;40mConnect Redis Server Error,Quit.\033[0m"
        sys.exit(7)
