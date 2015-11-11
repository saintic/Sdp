#!/usr/bin/env python
#-*- coding=utf8 -*-
__author__ = 'saintic'
__date__ = '2015-10-18'
__doc__ = 'read or write redis'
__version__ = 'sdp1.1'

try:
  import redis
except ImportError as Errmsg:
  print __file__, "import redis module failed, because %s" % Errmsg
  exit(1)

class RedisObject():
  '''read or write redis, set or get, mset or mget.
  析构函数需要传给类RedisObject一个tuple，包含redis连接的四个元素。'''
  def __init__(self, conn):
    if not isinstance(conn, (tuple)):
      raise TypeError('Bad Error Type, ask a tuple.')
    if len(conn) == 4:
      self.redis_object = redis.Redis(host=conn[0], port=conn[1], db=conn[2],password=conn[3])
    else:
      print 'Entry error, requires four elements.'
      return 2

  def keys(self):
    return self.redis_object.keys()

  def ping(self):
    return self.redis_object.ping()

  def set(self, k, v):
    if k == None or v == None:
      print "parameter error, key or value is none."
      exit(1)
    if self.redis_object.exists(k):
      print "%s exists, quit." % k
      exit(1)
    else:
      if self.redis_object.get(k) == v:
        print "%s exist, but equal %s, will quit." %(k,v)
        exit(1)
      else:
        self.redis_object.set(k,v)
        self.redis_object.save()
        return (k,v)

  def get(self, k):
    if k == None:
      print "key(%s) get error." % k
      exit(1)
    return self.redis_object.get(k)

  def hashset(self, **kw):
    '''four args=>user:name,pass:passwd,time:time,service:service,email:email
    {"name":user_name, "passwd":user_passwd, "time":user_time, "service":user_service, "email":user_email}
    '''
    if not isinstance(kw, (dict)):
      raise TypeError('Bad Type, ask a dict for user_info.')
    name=kw['name']
    passwd=kw['passwd']
    time=int(kw['time'])
    service=kw['service']
    email=kw['email']
    image=kw['image']
    container=kw['container']
    ip=kw['ip']
    port=int(kw['port'])
    dn=kw.get('dn', None)
    self.redis_object.hset(name, 'passwd', passwd)
    self.redis_object.hset(name, 'time', time)
    self.redis_object.hset(name, 'service', service)
    self.redis_object.hset(name, 'email', email)
    self.redis_object.hset(name, 'image', image)
    self.redis_object.hset(name, 'container', container)
    self.redis_object.hset(name, 'ip', ip)
    self.redis_object.hset(name, 'port', port)
    if dn != None:
      self.redis_object.hset(name, 'dn', dn)
    return self.redis_object.hgetall(name)

  def hashget(self, index, method='value'):
    '''index=user_name'''
    if method == 'value':
      return self.redis_object.hgetall(index)
    elif method == 'key':
      return self.redis_object.keys(index)
    else:
      return 1

