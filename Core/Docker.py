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
    def __init__(self):
        self.connect = docker.Client(base_url='unix://var/run/docker.sock')

    def Images(self, image=None):
        return json.dumps(self.connect.images(image))

    def Logs(self):
        pass

    def Top(self):
        pass

    def Pull(self, image, repo=Config.DOCKER_REGISTRY, tag=None):
        if not self.connect.images(name=image):
            for line in self.connect.pull(image, stream=True):  #a generator
                print json.dumps(json.loads(line), indent=4)

    def Push(self, image):
        if self.connect.images(name=image):
            if Config.DOCKER_PUSH == 'On' or Config.DOCKER_PUSH == 'on':
                for line in self.connect.push(image, stream=True):
                    print json.dumps(json.loads(line), indent=4)
        else:
            raise ValueError('%s, no such image.' % image)

    def Create(self, **kw):
        if not isinstance(kw, (dict)):
            raise TypeError('Bad Type, ask a dict.')

        image=kw['image']
        name=kw.get('name', None)
        container_port=kw.get('port', None)   #container open port,int,attach cports.
        host_ip_port=kw.get('bind', None)     #should be tuple,(host_ip,host_port),all is {container_port, (host_ip, host_port)}.
        volume=kw.get('volume', None)         #host_dir, default binding /data/wwwroot in container.

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

        cid=self.connect.create_container(image=image, name=name, stdin_open=True, tty=True, ports=cports, volumes=None, host_config=self.connect.create_host_config(restart_policy={"MaximumRetryCount": 0, "Name": "always"}, binds=cfs, port_bindings=port_bindings), mem_limit=None, memswap_limit=None, cpu_shares=None)['Id'][:12]
        print 'Success to create container, id => %s' % cid
        return cid

    def Start(self, cid):
        __r=self.connect.start(resource_id=cid)
        if __r == None:
            print 'Success to start container, id => %s' % cid
            return True
        else:
            #print "\033[0;31;40mStart failed, id => %s\033[0m" % cid
            raise

if __name__ == '__main__':
    i=Docker()
    print i.Images('registry.saintic.com/jenkins')
