# This is a base comment  
FROM 127.0.0.1:5000/centos6 
MAINTAINER SaintIC <staugur@saintic.com>  
  
#yum install Package
WORKDIR /data
ADD mongodb.repo /etc/yum.repos.d/
RUN yum -y install net-tools mongodb-org
ADD supervisord.conf /etc/supervisord.conf
#set port 
EXPOSE $portmap

#set ENV
ENV LANG en_US.UTF-8  
ENV LC_ALL en_US.UTF-8  

#run supervisor  
CMD ["/usr/bin/supervisord","-c","/etc/supervisord.conf &> /dev/null &"]

