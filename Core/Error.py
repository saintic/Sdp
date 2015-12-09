#!/usr/bin/env python
#-*- coding=utf8 -*-
__date__ = '2015.11.25'
__doc__ = '''Error class and handler'''

class SdpError(Exception, *args, **kwargs):
    def __init__(self, *args, **kwargs):
        self.args   = args
        self.kwargs = kwargs

class DockerError(SdpError):
    pass

class FtpError(SdpError):
    pass

