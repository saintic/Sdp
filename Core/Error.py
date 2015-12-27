#!/usr/bin/env python
#-*- coding=utf8 -*-
__doc__ = '''Error class and handler'''

class SdpError(Exception):
    def __init__(self, *args, **kwargs):
        self.args   = args
        self.kwargs = kwargs

class DockerError(SdpError):
    pass

class FtpError(SdpError):
    pass

