#!/usr/bin/env python
#-*- coding=utf8 -*-
__doc__ = '''
1. If you don't have a mail server, try local mail service, this requires that your local mail service is turned on.
The following is a part of the change.

Modify this line:
smtp_server='127.0.0.1'

Comment on this line:
#password='xxxx'
#server.login(from_addr, password)

2. If you need't html, please modify:
msg = MIMEText(content, 'html', 'utf-8')
change to(for plain):
msg = MIMEText(content, 'utf-8')
'''

from email import encoders
from email.header import Header
from email.mime.text import MIMEText
from email.utils import parseaddr,formataddr
import smtplib,sys

class SendMail():
    def __init__(self):
        self.from_addr = 'sdp@saintic.net'
        self.smtp_server = 'smtp.saintic.net'
        self.password = 'SaintIC.com'
        """
        self.from_addr = 'staugur@saintic.com'
        self.smtp_server = '127.0.0.1'
        """

    def _format_addr(self, s):
        name, addr = parseaddr(s)
        return formataddr((Header(name, 'utf-8').encode(), addr))

    def send(self, *args):
        if len(args) != 3:
            print "\033[0;31;40mEmailErro,quit!!!\033[0m"
            sys.exit(1)
        user = args[0]
        to_addr = args[1]
        content = args[2]
        msg = MIMEText(content, 'plain', 'utf-8')
        msg['From'] = self._format_addr('SdpCloud运营团队 <%s>' % self.from_addr)
        msg['To'] = self._format_addr('%s <%s>' % (user, to_addr))
        msg['Subject'] = Header('用户信息', 'utf-8').encode()
        server=smtplib.SMTP(self.smtp_server, 25)
        #server.set_debuglevel(1)
        server.login(self.from_addr, self.password)
        server.sendmail(self.from_addr, [to_addr], msg.as_string())
        server.quit()

if __name__ == '__main__':
    #When the replacement did not receive mail
    import sys
    from Redis import RedisObject

    if len(sys.argv) == 2:
        user = sys.argv[1]
    else:
        raise KeyError('Args is not enough.')

    sinfo = {"Username":user}
    rc = RedisObject()
    if rc.ping() and rc.exists(user):
        uinfo = rc.hashget(user)
        email = uinfo['email']
        sinfo['Service'] = uinfo['service']
        sinfo['Password'] = uinfo['passwd']
        if uinfo.get('dn', None):  #if true, is web, or app.
            sinfo['Connection'] = uinfo['dn']
        else:
            sinfo['Connection'] = uinfo['ip'] + ':' + uinfo['port']
        sinfo['other'] = 'This is a supplemental email.'
        ec = SendMail()
        import json
        ec.send(user, email, json.dumps(sinfo))
    else:
        print "No user or connect fail"
        sys.exit(1)
