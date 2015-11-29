#!/usr/bin/env python
#-*- coding=utf8 -*-
__date__ = '2015-11-29'
__doc__ = '''read or write redis, set or get, mset or mget.'''

try:
    import redis
    from Config import REDIS_HOST,REDIS_PORT,REDIS_DATADB,REDIS_PASSWORD
except ImportError as Errmsg:
    print __file__, "import redis module failed, because %s" % Errmsg
    exit(1)

class RedisObject:
    def __init__(self):
        self.redis_object = redis.Redis(host=REDIS_HOST, port=REDIS_PORT, db=REDIS_DATADB, password=REDIS_PASSWORD)

    def keys(self):
        return self.redis_object.keys()

    def ping(self):
        return self.redis_object.ping()

    def exists(self, k):
        return self.redis_object.exists(k)

    def set(self, k, v):
        pass

    def get(self, k):
        return self.redis_object.get(k)

    def hashset(self, **kw):
        if not isinstance(kw, (dict)):
            raise TypeError('Bad Type, ask a dict for user_info.')
        name=kw['name']
        for k,v in kw.iteritems():
            self.redis_object.hset(name, k, v)
        return self.redis_object.hgetall(name)

    def hashget(self, index, method='value'):
        if method == 'value':
            return self.redis_object.hgetall(index)
        elif method == 'key':
            return self.redis_object.keys(index)
        else:
            return

if __name__ == '__main__':
    rc = RedisObject()
    if rc.ping():
        if rc.exists('saintic'):
            print rc.hashget('saintic')
        else:
            print "no exist"
    else:
        print "\033[0;31;40mConnect Redis Server Error,Quit.\033[0m"
        sys.exit(7)

