#!/usr/bin/env python
#coding:utf-8
from email import encoders
from email.header import Header
from email.mime.text import MIMEText
from email.utils import parseaddr,formataddr
import smtplib,sys
def _format_addr(s):
  name, addr = parseaddr(s)
  return formataddr((Header(name, 'utf-8').encode(), addr))

from_addr='sdp@saintic.net'
password="SaintAugur910323"
smtp_server='smtp.saintic.net'

if len(sys.argv) == 4:
  #user_name user_email and content_file
  user=sys.argv[1]
  to_addr=sys.argv[2]
  content_file=sys.argv[3]
else:
  print "Into the reference error, three parameters are required:user email info_file."
  sys.exit(1)

with open(content_file) as f:
  content=f.read()

msg = MIMEText(content, 'html', 'utf-8')
msg['From'] = _format_addr('SdpTeam <%s>' % from_addr)
msg['To'] = _format_addr('%s <%s>' % (user,to_addr))
msg['Subject'] = Header('来自SdpTeam的系统消息', 'utf-8').encode()
server=smtplib.SMTP(smtp_server, 25)
#server.set_debuglevel(1)
server.login(from_addr, password)
server.sendmail(from_addr, [to_addr], msg.as_string())
server.quit()
