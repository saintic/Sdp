# Sdp.sh
*Simle Docker PaaS, Version Stable 1.0; Written by Shell.*

**[English]**
-------------
*Sdp positioning is a simple PAAS platform, to build a simple and convenient PAAS cloud.* 

Sdp1.0 has a large limitation, still only supports single environment, low degree of freedom, it is suitable for individual users;

Sdp2.0 (SPC) fully distributed environment, large-scale deployment, high degree of freedom, is suitable for organization and enterprise application.

Quick start:
>1. svn export https://github.com/staugur/Sdp/tags/stable-v1.0/ sdp && sh sdp/components/install_sdp.sh
>2. svn export https://github.com/staugur/scripts/trunk/Dockerfile

## One:sdp
That is Docker PaaS Simple, the current version is the stable version 1.0, the version of the address is https://github.com/staugur/Sdp/tags/stable-v1.0/.

Its current version is a set of small PaaS platform deployed on a fixed environment, support httpd, tomcat, mongodb, mysql, redis, memcached, nginx services, can be written by SPMC PHP web page to trigger, unfortunately, can not be through the web application resources, management, audit, etc..

## Two:requirements and use
**1. system requirements**

Because it is a stand-alone deployment, and the development of the time is a personal server for the environment, so the switch server has the following requirements:

>1. server itself has Nginx services, which can refer to https://github.com/staugur/CoreWeb;

>2. hardware architecture is x86_64 CentOS6.5 bit more than the required to meet the minimum requirements for docker installation;

>3. exists as a container for staugur/centos, Download links:
Https://software.saintic.com/core/docker/staugur.tar; or through the pull staugur/centos docker download; the latter through the build construction;

>4. only supports iptables, if you are firewalld type, close firewalld and open iptables;

>5. software package: jq, mailx, subversion, some pypi

**2. installation documentation**

Tip: the following setup is based on a certain level of Linux (CentOS) personnel.

1) yum -y install subversion mailx jq

2) svn co https://github.com/staugur/Sdp/tags/stable-0.1 sdp

3) sh sdp/components/install_sdp.sh

4) to ensure no error, docker, vsftpd, nginx , httpd, start service.

5) you may need to modify the nginx, httpd listener address or port, which requires the nginx reverse proxy httpd+svn to accept the request.

6) more documents please pay attention to official documents, the docs address is [http://www.saintic.com][1].

**3. Use Document**

(switch to Sdp directory;)

sh start.sh user time service codetype email

Notes:

Sdp starts with the start.sh script, the script needs five parameters, namely user (user) use_time (use time, unit month) service_type (service) file_type (file type) email (user mailbox).

**If there is a problem, please go to [https://github.com/staugur/Sdp/issues][2].**


**[中文]**
--------
*Sdp定位是一个简单PAAS平台，旨在构建简单方便快捷的PAAS云。*

Sdp1.0局限性很大，尚只支持单机环境，自由度低，适用于个人用户；

Sdp2.0(SPC)完全分布式环境、大规模部署，自由度高，适用于组织及企业级应用。


**快速开始：**
---------

## 一：Sdp

即Simple Docker PaaS,当前版本是1.0稳定版，版本地址是https://github.com/staugur/Sdp/tags/stable-v1.0/。

它目前版本是一个在固定环境的单机上部署的一套小型PaaS平台，支持nginx、httpd、tomcat、mysql、mongodb、redis、memcached服务；可通过PHP写的SPMC网页触发，遗憾的是无法通过网页申请资源、管理、审计等。


## 二：要求及使用


**1.系统要求**

  由于是单机部署，并且开发的时候是以个人服务器为环境的，所以切换服务器有如下硬性要求：
  
  >1.服务器本身有Nginx服务，可参照https://github.com/staugur/CoreWeb；
  
  >2.硬件架构是CentOS6.5 x86_64位以上，要求满足docker最低安装需求；
  
  >3.存在标签为staugur/centos的容器，下载链接：
https://software.saintic.com/core/docker/staugur.tar；或通过docker pull staugur/centos下载；后期通过build构建；

  >4.仅支持iptables，如果为firewalld类型，请关闭firewalld并开启iptables；
  
  >5.软件包：jq、mailx、subversion、python

**2.安装文档**

  提示：以下安装是基于拥有一定基础水平Linux(CentOS)人员进行的。

  1.) yum –y install subversion mailx

  2.) svn co https://github.com/staugur/Sdp/tags/stable-0.1 sdp

  3.) cd sdp/components            //运行此三个脚本安装docker、httpd+svn、vsftpd服务；

  4.) sh install_sdp.sh //确保中间没有报错,启动了docker、vsftpd、nginx、httpd服务。

  5.) 也许需要根据你服务器的实际情况修改nginx、httpd监听地址或端口，其中需要nginx反向代理httpd+svn接受请求。

  6.) 更多文档请关注官方文档，地址是[http://www.saintic.com][3]。

**3.使用文档**
  (切换到sdp目录:)

  sh start.sh user time service codetype email
 
Sdp以start.sh脚本开始，此脚本需要五个参数，分别是user(用户) use_time(使用时间，单位月) service_type(服务) file_type(文件类型) email(用户邮箱)。

**如果还有问题，请到[https://github.com/staugur/Sdp/issues][4]提问。**


  [1]: http://www.saintic.com
  [2]: https://github.com/staugur/Sdp/issues
  [3]: http://www.saintic.com
  [4]: https://github.com/staugur/Sdp/issues


###原理

  泛解析一个域名(eg:*.saintic.com)到PaaS主服务器，用户的域名cname到不同的uid.sdipaas.comt三级域名，由nginx反向代理提供一对一http路由映射到真正的docker容器上，容器即服务，而所有的docker建立在hdfs或其他分布式存储上，建立统一的数据容器，提供FTP svn git任意一种方式文件，代码上传功能，这样一个简单的PaaS。

  所有关键文件均保存为隐藏文件，将所有用户信息保存成一个JSON文件，而后由tools工具读取JSON用户文件进行相应操作。

####Directory description:

**Version1**

components:PaaS基础服务器，文件服务、容器服务。

boot:引导不同类型服务创建，引导用户生成、创建IP:PORT记录，触发文件服务功能，触发容器创建及分配和限制；

builds:创建容器中主要服务，提供PaaS应用；

tools:其他工具类脚本，如续费功能、服务到期邮件提醒功能等；

spmc:Sdp持续集成简易管理控制台。

#Note:

    这是Shell编写发布的1.0版本，基本PAAS功能已经完成，提供APP和WEB型应用支持和网页版SPMC控制台。

    实现的功能：创建、更新用户信息和应用容器、邮件发送、备份、续费(即更新用户信息)等已经完成，此Shell版日后不在维护，请关注v1.1及此后版本。


More content and Using method: [SaintIC Sdp](http://saintic.com/)
