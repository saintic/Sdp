#!/usr/bin/env python
#-*- coding=utf8 -*-
__author__ = 'saintic'
__date__ = '2015-11-12'
__doc__ = 'If type = WEBS, next nginx and code manager(ftp,svn)'
__version__ = 'sdp1.1'

from Redis import RedisObject

#Maybe unsupported svn now.
class NginxCode:
  def __init__(self):
    self.rc=RedisObject
    if not rc.ping():
      return 1

  def Code(self):
    svn_conf_content = r'''
<Location /SdpCloud/%s>
   DAV svn
   SVNPath %s
   AuthType Basic
   AuthName "Welcome to Your SdpCloud Home."
   AuthUserFile /data/repos/.passwd
   #SSLRequireSSL
  <LimitExcept GET PROPFIND OPTIONS REPORT>
    Require valid-user
  </LimitExcept>
</Location>
''' % (name, userhome, )



