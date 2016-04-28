import os
import config
import logging.handlers

CODE_HOME = os.path.dirname(os.path.abspath(__file__))

class Sdplog:

    logger = None
    levels = {
        "DEBUG" : logging.DEBUG,
        "INFO" : logging.INFO,
        "WARNING" : logging.WARNING,
        "ERROR" : logging.ERROR,
        "CRITICAL" : logging.CRITICAL}

    log_level = config.LogLevel
    log_file = os.path.join(CODE_HOME, 'sys.log')
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
        log_fmt = logging.Formatter('%(asctime)s %(filename)s[line:%(lineno)d] %(levelname)s %(message)s', datefmt=Sdplog.log_datefmt)
        log_handler.setFormatter(log_fmt)
        Sdplog.logger.addHandler(log_handler)
        Sdplog.logger.setLevel(Sdplog.levels.get(Sdplog.log_level))
        return Sdplog.logger

