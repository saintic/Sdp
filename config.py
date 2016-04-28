#-*- coding:utf8 -*-
#Supports configuration files for Python data types, including variables, lists, dictionaries, etc.

Environment = "product"
"""
Environment:
  1. The meaning of the representative is the application of the environment, the value of dev, product;
  2. When the value is dev, only exec app.run() with flask.
  3. When the value is product, will start server with tornado or gevent.
"""

Host = "0.0.0.0"
"""
Host:
    Application run network address, you can set it `0.0.0.0`, `127.0.0.1`, ``, `None`;
    Default run on all network interfaces.
"""

Port = 7072
"""
Port:
    Application run port, default is 5000;
"""

ProcessName = "SIC.SdpApi"
"""
ProcessName:
    Custom process, you can see it with "ps aux|grep ProcessName".
"""

ProductType = "tornado"
"""
ProductType:
    生产环境启动方法，可选`gevent`与`tornado`,其中tornado log level是WARNNING，也就是低于WARN级别的日志不会打印或写入日志中。
"""

ApplicationHome = "/data/wwwroot/Sdp"
"""
ApplicationHome:
    应用代码存在目录，包含启动服务的脚本.
"""

Debug = True
"""
Debug:
    Open debug mode?
    The development environment is open, the production environment is closed, which is also the default configuration.
"""

LogLevel = "DEBUG"
"""
LogLevel:
    
"""

RedisConnection = {
    "Host": '106.38.251.8',
    "Port": 6379,
    "Database": 0,
    "Passwd": "Sdp"
}
"""
RedisConnection:
    Redis Server Information, change to actual value.
    Host:MySQL Server Hostname or IP,
    Port:
    Database: 
    User:
    Passwd:
"""
