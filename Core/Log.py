#!/usr/bin/env python
#coding:utf8
__date__ = '2015-11-30'
__doc__ = "log report class or function, deco."

import os
import Config
import logging.handlers

Logfile=os.path.join(Config.SDP_LOGS_DATA_HOME,'sdp.log')

class Sdplog:

    logger = None
    levels = {"NOTSET" : logging.NOTSET,
        "DEBUG" : logging.DEBUG,
        "INFO" : logging.INFO,
        "WARNING" : logging.WARNING,
        "ERROR" : logging.ERROR,
        "CRITICAL" : logging.CRITICAL}

    log_level = Config.LOGLEVEL
    log_file = Logfile
    log_max_byte = 10 * 1024 * 1024;
    log_backup_count = 5
    log_datefmt = '%Y-%m-%d %H:%M:%S'

    @staticmethod
    def getLogger():
        if Sdplog.logger is not None:
            return Sdplog.logger

        Sdplog.logger = logging.Logger("loggingmodule.Sdplog")
        log_handler = logging.handlers.RotatingFileHandler(filename = Sdplog.log_file,
            maxBytes = Sdplog.log_max_byte,
            backupCount = Sdplog.log_backup_count)
        log_fmt = logging.Formatter('%(asctime)s %(pathname)s[line:%(lineno)d] %(levelname)s %(message)s')
        log_handler.setFormatter(log_fmt)
        Sdplog.logger.addHandler(log_handler)
        Sdplog.logger.setLevel(Sdplog.levels.get(Sdplog.log_level))
        return Sdplog.logger

if __name__ == "__main__":
    logger = Sdplog.getLogger()
    logger.debug("this is a debug msg!")
    logger.info("this is a info msg!")
    logger.warn("this is a warn msg!")
    logger.error("this is a error msg!")
