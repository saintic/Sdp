#!/usr/bin/env python
#-*- coding:utf8 -*-
__date__ = '2015-10-12'

import re,sys,psutil,platform
import Config

class Sysinfo():
    Hostname=platform.uname()[1]
    Kernel=platform.uname()[2]
    CPUs=int(psutil.cpu_count())
    Total=psutil.virtual_memory().total
    Mem=str(Total / 1024 / 1024) + 'M'

def Time(m=None):
    import datetime
    time = datetime.datetime.now()
    if m:
        m = int(m)
        days = 30 * m
        time = time + datetime.timedelta(days=days)
    return time.strftime("%Y-%m-%d %H:%M:%S")

def genpasswd(L=12):
    if not isinstance(L, (int)):
        raise TypeError('Bad operand type, ask Digital.')
    from random import Random
    passstr = ''
    chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz0123456789~!@#$%^&*'
    length = len(chars) - 1
    random = Random()
    for i in range(L):
        passstr+=chars[random.randint(0, length)]
    return passstr

def genuserinfo(num=5):
    if len(sys.argv) == num:
        user_name = str(sys.argv[1])
        user_passwd = str(genpasswd())
        try:
            user_time = int(sys.argv[2])
        except ValueError:
            print sys.argv[0],"demand is number and greater than 0"
            sys.exit(1)
        user_service = str(sys.argv[3])
        user_email = str(sys.argv[4])
        return {"name":user_name, "passwd":user_passwd, "time":user_time, "service":user_service, "email":user_email}
    else:
        print "\033[0;31;40mUsage:user time service email\033[0m"
        sys.exit(1)

class Precheck:
    def __init__(self, **kwargs):
        if not isinstance(kwargs, (dict)):
            raise TypeError('The class Precheck asks a list. ')
        try:
            self.name    = kwargs['name']
            self.time    = kwargs['time']
            self.service = kwargs['service']
            self.email   = kwargs['email']
        except KeyError as kv:
            print "Assignment error:%s" % kv
            sys.exit(1)

    def checkargs(self):
        from Redis import RedisObject
        rc = RedisObject()
        if rc.ping():
            if rc.exists(self.name):
                raise KeyError("Existing user name, exit!")
        else:
            print "\033[0;31;40mConnect Redis Server Error,Quit.\033[0m"
            sys.exit(7)

        if re.match(r'[a-zA-Z\_][0-9a-zA-Z\_]{1,19}', self.name) == None:
            raise TypeError('user_name illegal:A letter is required to begin with a letter or number, and the range number is 1-19.')
            sys.exit(129)

        if not self.time > 0:
            raise ValueError('Bad Value, demand is greater than 0 of the number.')
            sys.exit(127)

        if not self.service in Config.SERVICES:
            raise TypeError('Unsupport service:%s' % self.service)
            sys.exit(128)

        if re.match(r'([0-9a-zA-Z\_*\.*\-*]+)@([a-zA-Z0-9\-*\_*\.*]+)\.([a-zA-Z]+$)', self.email) == None:
            raise TypeError('Mail format error.')
            sys.exit(130)

