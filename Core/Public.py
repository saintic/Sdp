#!/usr/bin/env python
#-*- coding:utf8 -*-
__author__ = 'saintic'
__date__ = '2015-10-12'
__version__ = 'sdp1.1'
__doc__ = 'some functions'

try:
  import os,re,sys
except ImportError as Errmsg:
  print __file__,"import module failed, because %s" % Errmsg

def genpasswd(L=15):
  if not isinstance(L, (int)):
    raise TypeError('Bad operand type, ask Digital.')
  from random import Random
  stri = ''
  chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz0123456789'
  length = len(chars) - 1
  random = Random()
  for i in range(L):
    stri+=chars[random.randint(0, length)]
  return stri

def read_conf(f,i):
  if not isinstance(f, (str)):
    raise TypeError('Bad operand type, ask a file.')
  if not isinstance(i, (str)):
    raise TypeError('bad operand type, ask string.')
  from configobj import ConfigObj
  try:
    return ConfigObj(f)[i]
  except:
    print 'Get configuration information failure.'
    return 1

CONF_NAME = 'sdp.cfg'
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
BASE_CONF = os.path.join(BASE_DIR, str(CONF_NAME))
APPS = ("mongodb", "mysql", "redis", "memcache")
WEBS = ("nginx", "tengine", "httpd", "lighttpd", "tomcat", "resin")
SERVICES = APPS + WEBS
PORTNAT = {'mongodb': 27017, 'mysql': 3306, 'redis': 6379, 'memcache': 11211, 'web': 80}

#get variables from sdp.conf, format is dict.
GLOBAL_CONF = read_conf(BASE_CONF, 'globals')
REDIS_CONF = read_conf(BASE_CONF, 'redis')
DOCKER_CONF = read_conf(BASE_CONF, 'docker')
SVN_CONF = read_conf(BASE_CONF, 'svn')
FTP_CONF = read_conf(BASE_CONF, 'ftp')
NGINX_CONF = read_conf(BASE_CONF, 'nginx')

#set global variables
LANG = GLOBAL_CONF['LANG']
SDP_DATA_HOME = GLOBAL_CONF['SDP_DATA_HOME']
SDP_USER_DATA_HOME = os.path.join(SDP_DATA_HOME, str(GLOBAL_CONF['SDP_USER_DATA_HOME']))
SDP_LOGS_DATA_HOME = os.path.join(SDP_DATA_HOME, str(GLOBAL_CONF['SDP_LOGS_DATA_HOME']))
SDP_UC = os.path.join(SDP_DATA_HOME, str(GLOBAL_CONF['SDP_UC']))
STARTPORT = GLOBAL_CONF['STARTPORT']
ADMIN_EMAIL = GLOBAL_CONF['AdminEmail']
SERVER_IP = GLOBAL_CONF['ServerIp']
DN_BASE = GLOBAL_CONF['DN']

#set redis variables
REDIS_HOST = REDIS_CONF['host']
REDIS_PORT = int(REDIS_CONF['port'])
REDIS_QUEUEDB = int(REDIS_CONF['QueueDB'])
REDIS_DATADB = int(REDIS_CONF['DataDB'])
REDIS_PASSWORD = REDIS_CONF['password']
if REDIS_PASSWORD == "None":REDIS_PASSWORD = None

#set docker variables
DOCKER_PUSH = DOCKER_CONF['push']
DOCKER_TAG = DOCKER_CONF['imgtag']
DOCKER_REGISTRY = DOCKER_CONF['registry']

#set svn variables
HTTPD_USER = SVN_CONF['HttpdUser']
HTTPD_GROUP = SVN_CONF['HttpdGroup']
SVN_PASSFILE = SVN_CONF['PassFile']
SVN_CONF = SVN_CONF['SvnConf']

#set ftp variables
FTP_TYPE = FTP_CONF['FtpType']
FTP_VFTPUSER = FTP_CONF['VFtpUser']
FTP_VFTPUSERFILE = FTP_CONF['VFtpUserFile']
FTP_VFTPUSERDBFILE= FTP_CONF['VFtpUserDBFile']
FTP_VFTPUSERDIR = FTP_CONF['VFtpUserDir']

#set nginx variables
PROXY_DIR = NGINX_CONF['ProxyDir']
NGINX_EXEC = NGINX_CONF['CmdPath']

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

    if not user_service in SERVICES:
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
              

