#!/usr/bin/env python
#-*- coding=utf8 -*-
__author__ = 'saintic'
__date__ = '2015-10-18'
__doc__ = 'read or write redis'


try:
  import redis
  from Config import REDIS_HOST,REDIS_PORT,REDIS_DATADB,REDIS_PASSWORD
except ImportError as Errmsg:
  print __file__, "import redis module failed, because %s" % Errmsg
  exit(1)

class RedisObject():
  '''read or write redis, set or get, mset or mget.'''
  def __init__(self):
    self.redis_object = redis.Redis(host=REDIS_HOST, port=REDIS_PORT, db=REDIS_DATADB, password=REDIS_PASSWORD)

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
    if not isinstance(kw, (dict)):
      raise TypeError('Bad Type, ask a dict for user_info.')
    name=kw['name']
    for k,v in kw.iteritems():
      self.redis_object.hset(name, k, v)
    return self.redis_object.hgetall(name)

  def hashget(self, index, method='value'):
    '''index=user_name'''
    if method == 'value':
      return self.redis_object.hgetall(index)
    elif method == 'key':
      return self.redis_object.keys(index)
    else:
      return 1

