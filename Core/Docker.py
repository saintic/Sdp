#!/usr/bin/env python
#-*- coding=utf8 -*-
__date__ = '2015-12-06'
__doc__ = 'docker functions, for images, for containers'

try:
    import docker
    import Config
    import json
except ImportError as errmsg:
    raise ImportError('import failed, %s' % errmsg)

class Docker:
    def __init__(self, **kw):
        if not isinstance(kw, (dict)):
            raise TypeError('Bad Type, ask a dict.')
        try:
            self.kw    = kw
            self.image = kw['image']
        except  KeyError as e:
            raise KeyError('%s' % e)
        self.connect = docker.Client(base_url='unix://var/run/docker.sock')

    def Images(self):
        return self.connect.images(self.image)

    def Logs(self):
        pass

    def Top(self):
        return self.connect.top(self.image)

    def Pull(self):
        for line in self.connect.pull(self.image, stream=True):  #a generator
            print json.dumps(json.loads(line), indent=4)

    def Push(self):
        if Config.DOCKER_PUSH == 'On' or Config.DOCKER_PUSH == 'on':
            if self.Images():
                for line in self.connect.push(self.image, stream=True):
                    return json.dumps(json.loads(line), indent=4)
            else:
                raise ValueError('%s, no such image.' % self.image)

    def Create(self, mode=Config.DOCKER_NETWORK):
        name=self.kw.get('name', None)
        container_port=self.kw.get('port', None)   #container open port,int,attach cports.
        host_ip_port=self.kw.get('bind', None)     #should be tuple,(host_ip,host_port),all is {container_port, (host_ip, host_port)}.
        volume=self.kw.get('volume', None)         #host_dir, default binding /data/wwwroot in container.

        cports=[]
        if container_port:
            cports.append(container_port)
            port_bindings={container_port:host_ip_port}
        else:
            cports=None
            port_bindings=None

        volumes=[]
        if volume:
            cfs=['%s:/data/wwwroot:rw' % volume]  #ask list ['container_dir:host_dir:mode(rw,ro)']
            volumes.append(volume)                #Only this, more access=>https://github.com/docker/docker-py/issues/849
        else:
            cfs=None

        if not self.Images():
            self.Pull()

        cid=self.connect.create_container(image=self.image, name=name, stdin_open=True, tty=True, ports=cports, volumes=None, host_config=self.connect.create_host_config(restart_policy={"MaximumRetryCount": 0, "Name": "always"}, binds=cfs, port_bindings=port_bindings, network_mode=mode), mem_limit=None, memswap_limit=None, cpu_shares=None)['Id'][:12]
        return cid

    def Start(self, cid):
        __r=self.connect.start(resource_id=cid)
        if __r != None:
            #raise an error DockerStartError(Error.py)
            print "\033[0;31;40mStart failed, id => %s\033[0m" % cid
            exit()

if __name__ == '__main__':
    i=Docker(image='registry.saintic.com/nginx')
    if i.Pull():
        print i.Images()
    else:
        print 'error pull'
