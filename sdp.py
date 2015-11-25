#!/usr/bin/env python
#-*- coding=utf8 -*-
__author__ = 'taochengwei'
__date__ = '2015.11.25'
__doc__ = 'Entry file, all the start.'

import sys,os
try:
    from Core.Public import args_check,Sysinfo,Time
    from Core.Config import LANG,WEBS,APPS
    from Core.Handler import StartAll
    from Core import __version__
except ImportError as errmsg:
    print __file__,"import module failed, because %s" % errmsg
    sys.exit(1)

def main(**user):
    reload(sys)
    sys.setdefaultencoding(LANG)
    if not isinstance(user, (dict)):
        raise('Bae Parameter, ask dict.')

    if user['service'] in WEBS:
        StartAll('web', **user)
    elif user['service'] in APPS:
        StartAll('app', **user)
    else:
        print "\033[0;31;40mError,Quit!!!\033[0m"
        sys.exit(3)

if __name__ == "__main__":
    if os.geteuid() != 0:
        print "\033[0;31;40mAborting:this program must be run as root.\033[0m"
        sys.exit(1)
    else:
        user = args_check()
        main(**user)
        print """\033[0;32;40m
Now Time:%s
Sdp Version:%s
Hostname:%s
Kernel:%s
CPUs:%d
Total Mem:%s
Result:User(%s,%s) build sucessfully.\033[m"""%(Time(), __version__, Sysinfo.Hostname, Sysinfo.Kernel, Sysinfo.CPUs, Sysinfo.Mem, user['name'], user['email'])
