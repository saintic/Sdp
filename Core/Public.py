#!/usr/bin/env python
#-*- coding:utf8 -*-

import os
import re
import sys
import psutil
import platform
import Config
from __init__ import __version__
from optparse import OptionParser
from optparse import OptionGroup

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

def SOA():
    usage = "%prog [Options] [arg...]"
    parser = OptionParser(usage=usage)

    parser.add_option('-u', '--user', dest='name', metavar='user', help='User name')
    parser.add_option("-t", "--time", dest='time', type='int', metavar='time', default=1, help="User service usage month, defalt value is %default")
    parser.add_option('-s', '--service', dest='service', metavar='service', help='User service type, now support: %s' % str(Config.SERVICES))
    parser.add_option('-e', '--email', dest='email', metavar='email', help='User email')
    parser.add_option("-v", "--version", action="store_false", dest="version", help="Show the Sdp version information and quit")

    #svn options group
    svn_group = OptionGroup(parser, "Svn Options")
    parser.add_option_group(svn_group)
    svn_group.add_option("--enable-svn", action="store_true", dest="enable_svn", metavar="enable svn", help="Enable svn support, default disable")
    svn_group.add_option('--svn-type', dest='svn_type', metavar='svn type', help="Svn type for http, https")

    #git options group
    git_group = OptionGroup(parser, "Git Options")
    parser.add_option_group(git_group)
    git_group.add_option('--enable-git', action="store_true", dest='enable_git', help="Enable git support, default disable")

    #docker options group
    docker_group = OptionGroup(parser, "Docker Options")
    parser.add_option_group(docker_group)
    docker_group.add_option('--network', dest='network', metavar='docker network', help="Docker network mode for bridge or host")

    (options, args) = parser.parse_args()
    #-h|--help, default show the help message
    if len(sys.argv) == 1:
        print parser.format_help()
        sys.exit()

    #-v|--version, print version information
    if options.version == False:
        print __version__
        sys.exit()

    """Make option args, must have:-u, -t, -s, -e, defalt ftp, not svn and git.
    1. If "enable_svn" and "enable_git" is False, only ftp is enabled.
    2. If "enable_svn" is True only, you can choose "svn_type" for 'http' or 'https'.
    3. If "enable_git" is True only, will use 'git', but not svn.
    4. If "enable_svn" and "enable_git" is True both, will use 'svn' and 'git'.
    5. Whatever, ftp is enabled.
    """
    #print "options:%s, args:%s" %(options, args)
    user = {"name":options.name, "time":options.time, "service":options.service, "email":options.email}
    opts = {"enable_svn":options.enable_svn, "svn_type":options.svn_type, "enable_git":options.enable_git, "network":options.network}

    #check command line options
    try:
        for value in user:
            if user.get(value, None) == None:
                print "\033[0;31;40m%s -u|--user -t|--time -s|--service -e|--email [svn] [git]\033[0m" % sys.argv[0]
                sys.exit()

            if user['time'] == 0:
                raise ValueError("demand is number and greater than 0")

    except RuntimeError as e:
        raise RuntimeError("Runtime error:%s" % e)

    user['passwd'] = str(genpasswd())

    for k,v in opts.items():
        if k in user.keys():
            user[k] += v
        else:
            user[k] = v

    return user

class Precheck:

    """precheck args and options"""
    def __init__(self, **kwargs):

        if not isinstance(kwargs, (dict)):
            raise TypeError('The class Precheck asks a list. ')

        try:
            self.name    = kwargs['name'].lower()
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
            raise ValueError('user_name illegal:A letter is required to begin with a letter or number, and the range number is 1-19.')
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

class Sysinfo:

    Hostname=platform.uname()[1]
    Kernel=platform.uname()[2]
    CPUs=int(psutil.cpu_count())
    #mem used percent
    mem=psutil.virtual_memory()
    total=mem.total
    free=mem.free
    buffers=mem.buffers
    cached=mem.cached
    UsedPerc=100 * int(total - free - cached - buffers) / int(total)
    mem_total=str(total / 1024 / 1024) + 'M'
    mem_free=str(free / 1024 / 1024) + 'M'
    MemPerc=str(UsedPerc)+'%'

def Handler(service):
    portfile = os.path.join(Config.SDP_DATA_HOME, 'port')

    if not os.path.isdir(Config.SDP_DATA_HOME):
        os.mkdir(Config.SDP_DATA_HOME)

    if not os.path.isdir(Config.SDP_USER_DATA_HOME):
        os.mkdir(Config.SDP_USER_DATA_HOME)

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

    return (PORT,image)
