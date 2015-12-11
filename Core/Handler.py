#!/usr/bin/env python
#-*- coding=utf8 -*-
__date__ = '2015.11.25'
__doc__ = 'Core file, handle functions and class, for Webs And Apps.'

import sys,os,json
import Docker
import Config
import Public
from Redis import RedisObject
from Mail import SendMail

def StartAll(SdpType, **user):
    if not isinstance(SdpType, (str)):
        raise TypeError('StartAll need a type, app or web.')
    if not isinstance(user, (dict)):
        raise TypeError('StartAll need a dict(user).')
    name, passwd, time, service, email = user['name'], user['passwd'], str(user['time']), user['service'], user['email']
    dn = name + Config.DN_BASE
    portfile = os.path.join(Config.SDP_DATA_HOME, 'port')

    if not os.path.isdir(Config.SDP_DATA_HOME):
        os.mkdir(Config.SDP_DATA_HOME)
    if not os.path.isdir(Config.SDP_USER_DATA_HOME):
        os.mkdir(Config.SDP_USER_DATA_HOME)
    if not os.path.isdir(Config.SDP_LOGS_DATA_HOME):
        os.mkdir(Config.SDP_LOGS_DATA_HOME)
    if not os.path.isdir(Config.PROXY_DIR):
        os.mkdir(Config.PROXY_DIR)

    #set portfile, read and write(update)
    if os.path.exists(portfile):
        with open(portfile, 'r') as f:
            PORT=f.read()
            PORT=int(PORT) + 1
    else:
        PORT = Config.STARTPORT
    with open(portfile, 'w') as f:
        f.write(str(PORT))
    PORT = int(PORT)

    #define image_name
    if not Config.DOCKER_TAG:
        image = Config.DOCKER_REGISTRY + '/' + service
    else:
        image = Config.DOCKER_REGISTRY + '/' + Config.DOCKER_TAG + '/' + service

    #Web start dockerinfo
    dockerinfo = {"image":image, "name":name}
    if SdpType == "web" or SdpType == "WEB":
        userhome = os.path.join(Config.SDP_USER_DATA_HOME, name)
        os.chdir(Config.SDP_USER_DATA_HOME)
        if not os.path.isdir(name):
            os.mkdir(name)
        dockerinfo["port"] = Config.PORTNAT['web']
        dockerinfo["bind"] = ('127.0.0.1', PORT)
        dockerinfo["volume"] = userhome
        userinfo_admin = {"name":name, "passwd":passwd, "time":int(time), "service":service, "email":email, 'image':image, 'ip':'127.0.0.1', 'port':int(PORT), 'dn':dn, 'userhome':userhome}
        conn = dn
    #App start dockerinfo
    elif SdpType == "app" or SdpType == "APP":
        dockerinfo["port"] = Config.PORTNAT[service]
        dockerinfo["bind"] = (Config.SERVER_IP, PORT)
        userinfo_admin = {"name":name, "passwd":passwd, "time":int(time), "service":service, "email":email, 'image':image, 'ip':Config.SERVER_IP, 'port':int(PORT)}
        conn = Config.SERVER_IP + ':' + str(PORT)
    else:
        return 127

    #Run and Start Docker, should build.
    D = Docker.Docker(**dockerinfo)
    cid = D.Create()
    D.Start(cid)
    userinfo_admin['container'] = cid
    userinfo_admin['expiretime'] = Public.Time(m=time)
    userinfo_user = r'''
Dear %s, 以下是您的SdpCloud服务使用信息！
账号: %s
密码: %s
使用期: %d个月
服务类型: %s
验证邮箱: %s
服务连接信息: %s

祝您使用愉快。如果有任何疑惑，欢迎与我们联系:
邮箱: staugur@saintic.com
官网: http://www.saintic.com/
''' %(name, name, passwd, int(time), service, email, str(conn))

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
<p>服务连接信息: %s</p>
<p>这是一个欢迎页面，请尽快使用FTP覆盖此页面!</p>
<p><em>Thank you for using SdpCloud.</em></p>
</body>
</html>
''' %(name, name, passwd, int(time), service, email, str(conn))

    #define connection for redis and mailserver.
    userconn = (name, email, userinfo_user)
    #define instances
    rc = RedisObject()
    ec = SendMail()

    #start write data
    if rc.ping():
        rc.hashset(**userinfo_admin)
        ec.send(*userconn)
        #异步要保证写入数据库和文件中的数据都是正确的，抛出错误终止执行。
        with open(Config.SDP_UC, 'a+') as f:
            f.write(json.dumps(userinfo_admin))
        if SdpType == "web" or SdpType == "WEB":
            with open(os.path.join(userhome, 'index.html'), 'w') as f:
                f.write(userinfo_welcome)
            import Success
            Code = Success.CodeManager(name)
            Code.ftp()
            Code.Proxy()
    else:
        #raise an error for RedisConnectError(Error.py)
        print "\033[0;31;40mConnect Redis Server Error,Quit.\033[0m"
        sys.exit(7)
