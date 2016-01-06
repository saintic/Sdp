#!/usr/bin/env python
#-*- coding:utf8 -*-
__doc__ = 'Config file parser'
"""
def read_conf(f, i):
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
"""
from Public import read_conf
import os

#BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
BASE_CONF = os.path.join(os.path.dirname(__file__), "sdp.cfg")

if not os.path.exists(BASE_CONF):
    raise OSError('No config file sdp.cfg')

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
GLOBAL_CONF   = read_conf(BASE_CONF, 'globals')
REDIS_CONF    = read_conf(BASE_CONF, 'redis')
DOCKER_CONF   = read_conf(BASE_CONF, 'docker')
SVN_CONF      = read_conf(BASE_CONF, 'svn')
FTP_CONF      = read_conf(BASE_CONF, 'ftp')
NGINX_CONF    = read_conf(BASE_CONF, 'nginx')
GIT_CONF      = read_conf(BASE_CONF, 'git')

#set global variables
LANG               = GLOBAL_CONF['LANG']
SDP_DATA_HOME      = GLOBAL_CONF['SDP_DATA_HOME']
SDP_USER_DATA_HOME = os.path.join(SDP_DATA_HOME, 'users')
STARTPORT          = GLOBAL_CONF['STARTPORT']
SERVER_IP          = GLOBAL_CONF['ServerIp']
DN_BASE            = GLOBAL_CONF['DN']

#set redis variables
REDIS_HOST         = REDIS_CONF['host']
REDIS_PORT         = int(REDIS_CONF['port'])
REDIS_DATADB       = int(REDIS_CONF['DataDB'])
REDIS_PASSWORD     = REDIS_CONF['password']
if REDIS_PASSWORD == "None":
    REDIS_PASSWORD = None

#set docker variables
DOCKER_PUSH     = DOCKER_CONF['push']
DOCKER_TAG      = DOCKER_CONF['imgtag']
DOCKER_REGISTRY = DOCKER_CONF['registry']
DOCKER_NETWORK  = DOCKER_CONF['network']

#set svn variables
SVN_TYPE     = SVN_CONF['SvnType']
SVN_PASSFILE = SVN_CONF['PassFile']
SVN_ROOT     = SVN_CONF['SvnRoot']
SVN_ADDR     = SVN_CONF['SvnAddr']
HTTPD_USER   = SVN_CONF['HttpdUser']
HTTPD_GROUP  = SVN_CONF['HttpdGroup']
HTTPD_CMD    = SVN_CONF['HttpdCmd']
HTTPD_CONF   = SVN_CONF['HttpdConf']

#set ftp variables
FTP_TYPE            = FTP_CONF['FtpType']
FTP_SCRIPT          = FTP_CONF['FtpScript']
FTP_VFTPUSER        = FTP_CONF['VFtpUser']
FTP_VFTPUSERFILE    = FTP_CONF['VFtpUserFile']
FTP_VFTPUSERDBFILE  = FTP_CONF['VFtpUserDBFile']
FTP_VFTPUSERDIR     = FTP_CONF['VFtpUserDir']

#set nginx variables
NGINX_EXEC = NGINX_CONF['CmdPath']
PROXY_DIR  = NGINX_CONF['ProxyDir']

#set git variables
GIT_USER = GIT_CONF['Git_User']
GIT_ROOT = GIT_CONF['Git_Root']
GIT_KEYS = GIT_CONF['Git_Keys']
GIT_SVR  = GIT_CONF['Git_Server']
