#!/usr/bin/env python
#-*- coding=utf8 -*-
__author__ = 'taochengwei'
__date__ = '2015.11.25'
__doc__ = 'Entry file, all the start.'
__version__ = '1.1.1'

import sys,os
try:
    from Core.Public import args_check
    from Core.Config import LANG,WEBS,APPS
    from Core.Handler import StartAll
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
        print "\033[0;31;40mThis program must be run as root. Aborting.\033[0m"
        sys.exit(1)
    else:
        main(**args_check())
