#!/usr/bin/env python
#-*- coding=utf8 -*-
__author__ = 'saintic'
__date__ = '2015-11-10'
__doc__ = 'Webs And Apps'
__version__ = 'sdp1.1'

import sys,os,json
import Docker
import Public
from Redis import RedisObject
from Mail import SendMail

def StartAll(SdpType, **user):
  if not isinstance(SdpType, (str)):
    raise TypeError('%s need a type, app or web.' % __name__)
    sys.exit(1)
  if isinstance(user, (dict)):
    name, passwd, time, service, email = user['name'], user['passwd'], str(user['time']), user['service'], user['email']
    dn = name + Public.DN_BASE
    portfile = os.path.join(Public.SDP_DATA_HOME, 'port')
  else:
    print "Error:No dict input in the function StartAll."
    sys.exit(2)
  if not os.path.isdir(Public.SDP_DATA_HOME):os.mkdir(Public.SDP_DATA_HOME)
  if not os.path.isdir(Public.SDP_USER_DATA_HOME):os.mkdir(Public.SDP_USER_DATA_HOME)
  if not os.path.isdir(Public.SDP_LOGS_DATA_HOME):os.mkdir(Public.SDP_LOGS_DATA_HOME)
  if not os.path.isdir(Public.PROXY_DIR):os.mkdir(Public.PROXY_DIR)

  #set portfile, read and write(update)
  if os.path.exists(portfile):
    with open(portfile, 'r') as f:
      PORT=f.read()
      PORT=int(PORT) + 1
  else:
    PORT = Public.STARTPORT
  with open(portfile, 'w') as f:
    f.write(str(PORT))
  PORT = int(PORT)

  #define image_name
  #image = Public.DOCKER_REGISTRY + '/' + service
  if not Public.DOCKER_TAG:
    image = Public.DOCKER_REGISTRY + '/' + service
  else:
    image = Public.DOCKER_REGISTRY + '/' + Public.DOCKER_TAG + '/' + service

  #Web start dockerinfo
  dockerinfo = {"image":image, "name":name}
  if SdpType == "web" or SdpType == "WEB":
    userhome = os.path.join(Public.SDP_USER_DATA_HOME, name)
    os.chdir(Public.SDP_USER_DATA_HOME)
    if not os.path.isdir(name):os.mkdir(name)
    dockerinfo["port"] = Public.PORTNAT['web']
    dockerinfo["bind"] = ('127.0.0.1', PORT)
    dockerinfo["volume"] = userhome
    userinfo_admin = {"name":name, "passwd":passwd, "time":int(time), "service":service, "email":email, 'image':image, 'ip':'127.0.0.1', 'port':int(PORT), 'dn':dn, 'userhome':userhome}
    conn = dn
  #App start dockerinfo
  elif SdpType == "app" or SdpType == "APP":
    dockerinfo["port"] = Public.PORTNAT[service]
    dockerinfo["bind"] = (Public.SERVER_IP, PORT)
    userinfo_admin = {"name":name, "passwd":passwd, "time":int(time), "service":service, "email":email, 'image':image, 'ip':Public.SERVER_IP, 'port':int(PORT)}
    conn = Public.SERVER_IP + ':' + str(PORT)
  else:
    return 1
  #Run and Start Docker, should build.
  C = Docker.Docker()
  cid = C.Create(**dockerinfo)
  C.Start(cid)
  userinfo_admin['container'] = cid

  userinfo_user = r'''
Dear %s, 以下是您的SdpCloud服务使用信息！
用户: %s;
密码: %s;
使用期: %d;
服务类型: %s;
验证邮箱: %s;
服务连接信息: %s

祝您使用愉快。如果有任何疑惑，欢迎与我们联系:
邮箱: staugur@saintic.com
官网: https://saintic.com/
微博: http://weibo.com/staugur/
淘宝: https://shop126877887.taobao.com/
''' %(name, name, passwd, int(time), service, email, str(conn))

  userinfo_welcome = r'''<!DOCTYPE html>
<html>
<head>
<title>Welcome to SdpCloud!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1><center>Welcome %s:</center></h1>
<p>用户: %s;</p>
<p>密码: %s;</p>
<p>使用期: %d;</p>
<p>服务类型: %s;</p>
<p>验证邮箱: %s;</p>
<p>服务连接信息: %s</p>
<p>这是一个欢迎页面，请尽快使用FTP覆盖此页面!</p>
<p><em>Thank you for using SdpCloud.</em></p>
</body>
</html>
''' %(name, name, passwd, int(time), service, email, str(conn))

  #define connection for redis and mailserver.
  userconn = (name, email, userinfo_user)
  adminconn = ('Administrator', Public.ADMIN_EMAIL, json.dumps(userinfo_admin))
  rc = RedisObject()
  ec = SendMail()

  #start write data
  if rc.ping():
    rc.hashset(**userinfo_admin)
    #print '\033[0;32;40m' + 'UserInfo Output:', rc.hashget(name), '\033[0m'
    ec.send(*userconn)
    #ec.send(*adminconn)
    with open(Public.SDP_UC, 'a+') as f:
      f.write(json.dumps(userinfo_admin))
    if SdpType == "web" or SdpType == "WEB":
      with open(os.path.join(userhome, 'index.html'), 'w') as f:
        f.write(userinfo_welcome)
      import Nginx #Only ftp
      Code = Nginx.CodeManager(name)
      Code.ftp()
      Code.Proxy()
  else:
    print "\033[0;31;40mConnect Redis Server Error,Quit.\033[0m"
    sys.exit(7)
