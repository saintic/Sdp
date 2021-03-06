# Sdp
*Simle Docker PaaS, version 1.1.6, by Python.*

**[中文]**
--------

**快速开始：**
---------
1.基础环境部署，官方文档：http://www.saintic.com/sdpv1.0/autodeploy.html

2.pip install -r requirements.txt (运行中发现提示docker-py版本过高或过低，请尝试安装具体版本)

3.git clone https://github.com/saintic/Sdp

4.cd Sdp ; ./sdp -u username -t time -s service -e email <--enable-svn> --svn-type <--enable-git>(以root身份运行) or 软链到PATH可执行。

**如果还有问题，请到[https://github.com/saintic/Sdp/issues][2]提问。**

  [1]: http://www.saintic.com
  [2]: https://github.com/saintic/Sdp/issues

# Changelog

```
2015-11-20 Release 1.1
    1.全Py实现的框架基本功能；
    2.代码管理方式FTP；
    3.IP+PORT省略静态IP设置；
    4.Nginx代理实现；

2015-11 Release Pre 1.1.x
    1.在补充版本中添加check for all，针对user预检测;
    2.读取redis等以防止存在已注册用户;
    3.日志功能;
    4.服务使用期限

2015-11-25 Release 1.1.1
    1.pypi(Deleted)
    2.End info(Completed)
    3.Design modules name(Completed)
    4.class Precheck(Complated)

2015-11-29 Release 1.1.2
    1.time(Complated)
    2.log(Complated, no apply)

2015-11-29 Release 1.1.3
    1.docker(Complated)
    2.network mode(Bridge or Host)(Complated)
    3.精简代码输出，丰富结果输出, 用户名小写(Complated)

2015-12-07 Release 1.1.4
    1.Subversion(svn http https)

2015-12-12 Release 1.1.5
    1.Git(svn or git)
    2.命令行参数支持两种，一是顺序方式，但增加了code type，代码管理方式只能是svn或git或none，即ftp；第二种是选项参数方式。

2015-01-17 Relase 1.1.6 Pre
    1.修复已知的bug(去掉--svn-type命令行选项)
    2.发布可用的稳定版本。
    3.代码管理方式只保留一种，默认启用ftp，否认关闭ftp启用svn、git任一种。

2015-01-17 Relase 1.1.7 Pre for Tools branch.

Release 1.2
    主要是PythonWeb用户注册管理服务系统和集成代码管理
```

Documents: [www.saintic.com](http://www.saintic.com/)
