#!/usr/bin/env python
#-*- coding=utf8 -*-
__date__ = '2015-12-06'
__doc__ = 'docker functions, for images, for containers'

try:
    import docker
    import Config
except ImportError as errmsg:
    raise ImportError('import failed, %s' % errmsg)

class Docker:
    def __init__(self):
        self.connect = docker.Client(base_url='unix://var/run/docker.sock', version='auto')
        #self.connect = docker.Client(base_url='tcp://127.0.0.1:2375')

    def Create(self, **kw):
        """The operation of the docker module is encapsulated."""
        if not isinstance(kw, (dict)):
            raise TypeError('Bad Type, ask a dict.')
        image=kw['image']
        name=kw.get('name', None)
        container_port=kw.get('port', None)#container open port,int,attach cports
        host_ip_port=kw.get('bind', None)#should be tuple,(host_ip,host_port),all is {container_port, (host_ip, host_port)}
        volume=kw.get('volume', None) #host_dir
        volumes=[]
        cports=[]
        if container_port:
            cports.append(container_port)
            port_bindings={container_port:host_ip_port}
        else:
            cports=None
            port_bindings=None
        if volume:
            cfs=['%s:/data/wwwroot:rw' % volume] # ask list ['container_dir:host_dir:mode(rw,ro)']
            volumes.append(volume)     #Only this, more access=>https://github.com/docker/docker-py/issues/849
        else:
            cfs=None
        cid=self.connect.create_container(image=image, name=name, stdin_open=True, tty=True, ports=cports, volumes=None, host_config=self.connect.create_host_config(restart_policy={"MaximumRetryCount": 0, "Name": "always"}, binds=cfs, port_bindings=port_bindings), mem_limit=None, memswap_limit=None, cpu_shares=None)['Id'][:12]
        #print '\033[0;32;40mSuccess to create container, id => %s\033[0m' % cid
        return cid

    def Start(self, cid):
        __r=self.connect.start(resource_id=cid)
        if __r == None:
            #print '\033[0;32;40mSuccess to start container, id => %s\033[0m' % cid
            return 0
        else:
            print "\033[0;31;40mStart failed, id => %s\033[0m" % cid
            return 1

    def Ci(self, image):
        if not isinstance(image, (str)):
            raise TypeError('Bad type, ask an image')
        if Config.DOCKER_PUSH == 'On' or Config.DOCKER_PUSH == 'on':
            self.connect.push(image)
            return

    def Build(self):
        pass
