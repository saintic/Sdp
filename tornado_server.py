#!/usr/bin/python -O
#tornado IOLoop for product environment!

from tornado.wsgi import WSGIContainer
from tornado.httpserver import HTTPServer
from tornado.ioloop import IOLoop
from SdpAPI import app
from config import Port, Environment, ProcessName

try:
    import setproctitle
except ImportError:
    print "Please install the module, https://github.com/dvarrazzo/py-setproctitle"
    exit()
finally:
    if ProcessName:
        setproctitle.setproctitle(ProcessName)

if Environment == 'product':
    http_server = HTTPServer(WSGIContainer(app))
    http_server.listen(Port)
    IOLoop.instance().start()
