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
        days = 30 * m
        time = time + datetime.timedelta(days=days)
    return time.strftime("%Y:%m:%d %H:%M:%S")

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

def args_check(num=5):
  if len(sys.argv) == num:
    user_name = str(sys.argv[1])
    user_passwd = str(genpasswd())
    user_time = int(sys.argv[2])
    user_service = str(sys.argv[3])
    user_email = str(sys.argv[4])
    if not isinstance(user_time, (int)) or user_time <= 0:
      raise ValueError('Bad Value, demand is greater than 0 of the number.')
      sys.exit(127)

    if not user_service in Config.SERVICES:
      print "\033[0;31;40mUnsupport service\033[0m"
      sys.exit(128)

    if re.match(r'[a-zA-Z\_][0-9a-zA-Z\_]{1,19}', user_name) == None:
      print '\033[0;31;40muser_name illegal:A letter is required to begin with a letter or number, and the range number is 1-19.\033[0m'
      sys.exit(128)

    if re.match(r'([0-9a-zA-Z\_*\.*\-*]+)@([a-zA-Z0-9\-*\_*\.*]+)\.([a-zA-Z]+$)', user_email) == None:
      print "\033[0;31;40mMail format error.\033[0m"
      sys.exit(129)
    '''
    if user_name and user_passwd and user_time and user_service and user_email:
      user={"name":user_name, "passwd":user_passwd, "time":user_time, "service":user_service, "email":user_email}
    else:
      print "\033[0;31;40mERROR:Has false argument\033[0m"
      exit(1)
    '''
    return {"name":user_name, "passwd":user_passwd, "time":user_time, "service":user_service, "email":user_email}

  else:
    print "\033[0;31;40mUsage:user time service email\033[0m"
    exit(1)

class Precheck:
    def __init__(self, *args):
        if not isinstance(args, (list)):
            raise TypeError('The class Precheck asks a list. ')
        self.name    = args[0]
        self.time    = args[1]
        self.service = args[2]
        self.email   = args[3]

    def checkargs(self):
        try:
            from Redis import RedisObject
            rc = RedisObject()
            if rc.ping():
                if not rc.exists(name):
                    return False
            else:
                print "\033[0;31;40mConnect Redis Server Error,Quit.\033[0m"
                sys.exit(7)
        except:
            pass
        if re.match(r'[a-zA-Z\_][0-9a-zA-Z\_]{1,19}', self.name) == None:
            raise TypeError('user_name illegal:A letter is required to begin with a letter or number, and the range number is 1-19.')
            sys.exit(129)
        if not self.time <= 0:
            raise ValueError('Bad Value, demand is greater than 0 of the number.')
            sys.exit(127)
        if not self.service in Config.SERVICES:
            raise TypeError('Unsupport service')
            sys.exit(128)
        if re.match(r'([0-9a-zA-Z\_*\.*\-*]+)@([a-zA-Z0-9\-*\_*\.*]+)\.([a-zA-Z]+$)', self.email) == None:
            raise TypeError('Mail format error.')
            sys.exit(130)
