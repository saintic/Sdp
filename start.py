#!/usr/bin/env python
#-*- coding=utf8 -*-
__author__ = 'saintic.com'
__date__ = '2015-10-13'
__doc__ = 'Entry file, all the start.'
__version__ = 'sdp1.1'

try:
  import sys,os
  from Core.Public import args_check,LANG,WEBS,APPS
  from Core.Core import StartAll
except ImportError as Errmsg:
  print __file__,"import module failed, because %s" % Errmsg

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
