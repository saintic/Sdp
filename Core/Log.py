#!/usr/bin/env python
#coding:utf8
__date__ = '2015-11-30'
__doc__ = "log report class or function, deco."

import logging
def SdpLog(msg):
    logging.basicConfig(level=logging.DEBUG,
        format='%(asctime)s %(filename)s[line:%(lineno)d] %(levelname)s %(message)s',
        #atefmt='%a, %d %b %Y %H:%M:%S',
        filename='/var/log/sdp.log',
        filemode='a+')
    return logging.debug(msg)

class Logreport:
    def __init__(self, msg, log='/var/log/sdp.log'):
        #create a logger
        self.logger = logging.getLogger('sdp')
        self.logger.setLevel(logging.DEBUG)

        #create a handler, write to file
        self.fileout = logging.FileHandler(log)
        self.fileout.setLevel(logging.DEBUG)

        #create another handler, in console
        self.console = logging.StreamHandler()
        self.console.setLevel(logging.DEBUG)

        #define format
        self.formatter = logging.Formatter('%(asctime)s %(filename)s[line:%(lineno)d] %(levelname)s %(message)s')
        self.fileout.setFormatter(self.formatter)
        self.console.setFormatter(self.formatter)

        #add handler for logger
        self.logger.addHandler(self.fileout)
        self.logger.addHandler(self.console)

        #report(print)
        #self.logger.info('foorbar')
        #self.logger.debug('foorbar')
        return self.logger.debug(msg)

if __name__ == "__main__":
    #print Logreport('this is an error msg')
    print SdpLog('hello world')
