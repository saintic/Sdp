#!/usr/bin/python
#coding:utf8
import sys,redis,json,config,Tools
from flask import Flask,jsonify,abort,make_response,request,url_for

app = Flask(__name__)
logger = Tools.Sdplog.getLogger()

try:
    RC = redis.Redis(host=config.RedisConnection.get('Host', '127.0.0.1'), port=config.RedisConnection.get('Port', 6379), db=config.RedisConnection.get('Database', 0), password=config.RedisConnection.get('Passwd', None), socket_timeout=3, socket_connect_timeout=3, retry_on_timeout=1)
except Exception, e:
    logger.error(e)
    sys.exit()

@app.errorhandler(404)
def not_found(error):
    return make_response(json.dumps({'404': 'Not found'}), 404)

# 创建服务，传入JSON参数
@app.route('/create/<username>', methods=['POST'])
def create_service(username):
    if RC.exists(username):
        return json.dumps({'ERROR':'User name already exists!'})
    else:
        return

# 列出用户
@app.route('/list')
def user_list():
    return json.dumps({'Users':RC.keys()})

# 查询用户的服务信息
@app.route('/info/<username>')
def get_name_info(username):
    if username:
        return json.dumps({username:RC.hgetall(username)})


@app.route('/', methods=['GET'])
def index():
    real_ip = request.headers.get('X-Real-Ip', request.remote_addr)
    return json.dumps({'Sdp API Welcome': real_ip})

if __name__ == '__main__':
    if config.Environment == "dev":
        app.run(debug=config.Debug, host=config.Host, port=config.Port)
