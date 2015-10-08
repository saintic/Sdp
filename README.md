# Sdp
*Simle Docker PaaS, version:1.0*

###
  泛解析一个域名(eg:*.saintic.com)到PaaS主服务器，用户的域名cname到不同的uid.sdipaas.comt三级域名，由nginx反向代理提供一对一http路由映射到真正的docker容器上，容器即服务，而所有的docker建立在hdfs或其他分布式存储上，建立统一的数据容器，提供FTP svn git任意一种方式文件，代码上传功能，这样一个简单的PaaS。

  所有关键文件均保存为隐藏文件，将所有用户信息保存成一个JSON文件，而后由tools工具读取JSON用户文件进行相应操作。

####Directory description:

**Version1**

components:PaaS基础服务器，文件服务、容器服务。

boot:引导不同类型服务创建，引导用户生成、创建IP:PORT记录，触发文件服务功能，触发容器创建及分配和限制；

builds:创建容器中主要服务，提供PaaS应用；

tools:其他工具类脚本，如续费功能、服务到期邮件提醒功能等；

spmc:Sdp持续集成简易管理控制台。



More content and Using method: [SaintIC Sdp](http://saintic.com/post-122.html)
