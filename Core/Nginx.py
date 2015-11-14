#!/usr/bin/env python
#-*- coding=utf8 -*-
__author__ = 'saintic'
__date__ = '2015-11-12'
__doc__ = 'If type = WEBS, next nginx and code manager(ftp,svn)'
__version__ = 'sdp1.1'

import Public
from Redis import RedisObject
from subprocess import call

#Maybe unsupported svn now.
class NginxCode:
  def __init__(self):
    self.rc=RedisObject
    if not rc.ping():
      return 1

  def Code(self, index, ctype='ftp'):
    user=self.rc.hgetall(index)
    if Public.FTP_TYPE == 'virtual':
      ftp_user = r'''
        %s
        %s''' %(user['name'], user['passwd'])
      ftp_content_conf = r"""write_enable=YES
anon_world_readable_only=NO
anon_upload_enable=YES
anon_mkdir_write_enable=YES
anon_other_write_enable=YES
local_root=%s""" % user['userhome']
      with open(Public.FTP_VFTPUSERFILE, 'a+') as f:
        f.write(ftp_user)

      call(["db_load -T -t hash -f " + Public.FTP_VFTPUSERFILE + ' ' + Public.FTP_VFTPUSERDBFILE], shell=True)

cat > ${vfudir}/$1 <<EOF
write_enable=YES
anon_world_readable_only=NO
anon_upload_enable=YES
anon_mkdir_write_enable=YES
anon_other_write_enable=YES
local_root=$3
EOF
chown -R ftp.ftp $3
chmod -R a+t $3
/etc/init.d/vsftpd reload

    with open()


