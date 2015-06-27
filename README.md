# Sdp
*Simle Docker PaaS*

###
泛解析*.saintic.net到paas主服务器，用户的域名cname到不同的number.sdi.paas.saintic.net三级域名，然后用hipache提供一对一http路由映射到真正的docker容器上，容器即服务，而所有的docker建立在hdfs或其他分布式存储上，建立统一的数据容器，提供FTP svn git任意一种方式文件，代码上传功能，这样一个简单的paas。

####Directory description:

**Version1**

components:PaaS基础服务器，文件服务、容器服务。

boot:引导不同类型服务创建，引导用户生成、创建IP:PORT记录，触发文件服务功能，触发容器创建及分配和限制；

builds:创建容器中主要服务，提供PaaS应用。


**Version2**

components:PaaS平台组件:HTTP路由，容器创建，文件服务，统一平台；

boot:引导用户生成、创建number.sdi.paas.saintic.net三级域名记录，连接hipache、redis路由，触发文件服务功能，触发容器创建及分配和限制；

builds:创建容器中主要服务，提供PaaS应用。

_More content_: [SaintIC Sdp](https://saintic.com/sdp)
