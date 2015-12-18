#!/usr/bin/env python
#coding:utf8
__date__ = '2015-11-30'
__doc__ = "log report class or function, deco."

import os
import logging
import Config

Logfile=os.path.join(Config.SDP_LOGS_DATA_HOME,'sdp.log')
Logfile='sdp.log'
def SdpLog(msg, level_name=Config.LOGLEVEL, logfile=Logfile):
    LEVELS = {'DEBUG':logging.DEBUG,
        'INFO':logging.INFO,
        'WARNING':logging.WARNING,
        'ERROR':logging.ERROR,
        'CRITICAL':logging.CRITICAL
    }
    PUT = {'DEBUG':logging.debug,
        'INFO':logging.info,
        'WARNING':logging.warning,
        'ERROR':logging.error,
        'CRITICAL':logging.critical
    }
    level=LEVELS.get(level_name, 'logging.NOTSET')
    logging.basicConfig(level=level,
        format = '%(asctime)s %(pathname)s[line:%(lineno)d] %(levelname)s %(message)s',
        datefmt = '%Y-%m-%d %H:%M:%S',
        filename = logfile,
        filemode = 'a+')
    logging.debug(msg)

if __name__ == "__main__":
    print SdpLog('This is a test log msg.')
