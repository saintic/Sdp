# Sdp
Simle Docker PaaS

###########
Directory description:
boot:创建number.sdi.paas.saintic.net三级域名记录，连接hipache、redis路由，触发文件服务功能，触发容器创建及分配和限制；
components:SaintIC PaaS平台组件，HTTP路由，容器创建，文件服务，统一平台；



services:创建容器中主要服务，提供PaaS应用。

##

泛解析*.saintic.net到paas主服务器，用户的域名cname到不同的number.sdi.paas.saintic.net三级域名，然后用hipache提供一对一http路由映射到真正的docker容器上，容器即服务，而所有的docker建立在hdfs或其他分布式存储上，建立统一的数据容器，提供FTP svn git任意一种方式文件，代码上传功能，这样一个简单的paas。


