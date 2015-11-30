#!/usr/bin/env python
#coding:utf8
__date__ = '2015-11-30'
__doc__ = "log report class or function, deco."

def SdpLog(msg):
    import logging
    logging.basicConfig(level=logging.DEBUG,
        format='%(asctime)s %(filename)s[line:%(lineno)d] %(levelname)s %(message)s',
        datefmt='%a, %d %b %Y %H:%M:%S',
        filename='sdp.log',
        filemode='a+')
    return logging.debug(msg)

class Logreport:
    def __init__(self, log='/var/log/sdp.log', msg):
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
        logger.addHandler(self.fileout)
        logger.addHandler(self.console)

        #report(print)
        #logger.info('foorbar')
        #logger.debug('foorbar')
        return logger.debug(msg)

