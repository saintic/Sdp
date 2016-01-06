#!/usr/bin/env python
#-*- coding=utf8 -*-

import os
import Docker
import Config
import Public
import Redis
import Mail

def StartApp(**user):
    if not isinstance(user, (dict)):
        raise TypeError('StartAll need a dict(user).')

    name, passwd, time, service, email = user['name'], user['passwd'], str(user['time']), user['service'], user['email']
    PORT, image = Public.Handler()

    if user['network'] != None:
        docker_network_mode = user['network']
    else:
        if Config.DOCKER_NETWORK not in ['bridge', 'host']:
            raise TypeError('Unsupport docker network mode')
        else:
            docker_network_mode = Config.DOCKER_NETWORK

    #Dk = Docker.Docker(**{"image":image, "name":name, 'port':Config.PORTNAT[service], 'bind':(Config.SERVER_IP, PORT)})
    Dk = Docker.Docker(**{"image":image, "name":name, 'port':Config.PORTNAT[service], 'bind':(Config.SERVER_IP, PORT)})
    cid = Dk.Create(mode=docker_network_mode)    #docker network mode='bridge' or 'host'(not allow none and ContainerID)
    Dk.Start(cid)
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
问题: https://github.com/saintic/Sdp/issues''' %(name, name, passwd, int(time), service, email, str(Config.SERVER_IP + ':' + str(PORT)))

    userconn = (name, email, userinfo_user)
    #define instances for writing redis and sending email.
    rc = Redis.RedisObject()
    ec = Mail.SendMail()
    if rc.ping():
        rc.hashset(**{"name":name, "passwd":passwd, "time":int(time), "service":service, "email":email, 'image':image, 'ip':Config.SERVER_IP, 'port':int(PORT), 'continer':cid, 'expiretime':Public.Time(m=time), 'network':docker_network_mode})
        ec.send(*userconn)
    else:
        #raise an error for RedisConnectError(Error.py)
        print "\033[0;31;40mConnect Redis Server Error,Quit.\033[0m"
        exit()
