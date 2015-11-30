#!/usr/bin/env python
#-*- coding:utf8 -*-
__date__ = '2015-11-25'
__doc__ = 'Config file parser'

def read_conf(f,i):
    if not isinstance(f, (str)):
        raise TypeError('Bad operand type, ask a file.')
    if not isinstance(i, (str)):
        raise TypeError('bad operand type, ask string.')
    try:
        from configobj import ConfigObj
        return ConfigObj(f)[i]
    except ImportError:
        print 'Import module configobj failed, maybe you need to install it.(pip install configobj)'
        exit(1)

import Public
import os

CONF_NAME = 'sdp.cfg'
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
BASE_CONF = os.path.join(BASE_DIR, str(CONF_NAME))
APPS = ("mongodb", "mysql", "redis", "memcache")
WEBS = ("nginx", "tengine", "httpd", "lighttpd", "tomcat")
SERVICES = APPS + WEBS
PORTNAT = {
    'mongodb': 27017,
    'mysql': 3306,
    'redis': 6379,
    'memcache': 11211,
    'web': 80
    }

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

