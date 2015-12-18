#!/usr/bin/env python
#coding:utf8
__date__ = '2015-11-30'
__doc__ = "log report class or function, deco."

import os
import logging
import Config

Logfile=os.path.join(Config.SDP_LOGS_DATA_HOME,'sdp.log')
def SdpLog(logfile=Logfile, *args, **kw):
    try:
        logging.basicConfig(level=logging.DEBUG,
            format = '%(asctime)s %(pathname)s->[line:%(lineno)d] %(levelname)s %(message)s',
            datefmt = '%Y-%m-%d %H:%M:%S',
            filename = logfile,
            filemode = 'a+')
        #logging.debug(msg)
        if args:
            logging.debug(args)
        if args:
            logging.debug(kw)
    except IOError as e:
        raise IOError("Write error, %s" % e)

if __name__ == "__main__":
    print SdpLog('hello world! This is a test log msg.')
