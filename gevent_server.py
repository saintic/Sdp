#!/usr/bin/python -O
#gevent server for product environment!

from gevent.wsgi import WSGIServer
from SdpAPI import app
from config import Host, Port, Environment, ProcessName

try:
    import setproctitle
except ImportError:
    print "Please install the module, https://github.com/dvarrazzo/py-setproctitle"
    exit()
finally:
    if ProcessName:
        setproctitle.setproctitle(ProcessName)

if Environment == 'product':
    http_server = WSGIServer((Host, Port), app)
    http_server.serve_forever()
