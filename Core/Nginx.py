#!/usr/bin/env python
#-*- coding=utf8 -*-
__author__ = 'saintic'
__date__ = '2015-11-12'
__doc__ = 'If type = WEBS, next nginx and code manager(ftp,svn)'
__version__ = 'sdp1.1'

import os,Public,Redis
from subprocess import call

#Maybe unsupported svn now.
class NginxCode():
  def __init__(self):
    self.rc = Redis.RedisObject()
    if not self.rc.ping():
      return 1

  def ftp(self, index):
    user = self.rc.hashget(index)
    name = user['name']
    userhome = user['userhome']
    if Public.FTP_TYPE == 'virtual':
      ftp_user_list = r'''%s
%s
''' %(user['name'], user['passwd'])

      ftp_content_conf = r"""write_enable=YES
anon_world_readable_only=NO
anon_upload_enable=YES
anon_mkdir_write_enable=YES
anon_other_write_enable=YES
local_root=%s""" % userhome

      with open(Public.FTP_VFTPUSERFILE, 'a+') as f:
        f.write(ftp_user_list)

      with open(os.path.join(Public.FTP_VFTPUSERDIR, name), 'w') as f:
        f.write(ftp_content_conf)

      call(['db_load -T -t hash -f ' + Public.FTP_VFTPUSERFILE + ' ' + Public.FTP_VFTPUSERDBFILE], shell=True)
      call(['/etc/init.d/vsftpd restart'], shell=True)
      call(['chown -R ' + Public.FTP_VFTPUSER + ':' + Public.FTP_VFTPUSER + ' ' + userhome], shell=True)
      call(['chmod -R a+t ' + userhome], shell=True)

