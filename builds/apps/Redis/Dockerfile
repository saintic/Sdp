# This is a base comment  
FROM 127.0.0.1:5000/centos6 
MAINTAINER SaintIC <staugur@saintic.com>  
  
#yum install Package
WORKDIR /data
RUN yum -y install net-tools iputils  iproute  man  vim git
ADD redis.sh /data
RUN sh /data/redis.sh
ADD supervisord.conf /etc/supervisord.conf
#set port 
EXPOSE $portmap

#set ENV
ENV LANG en_US.UTF-8  
ENV LC_ALL en_US.UTF-8  

#run supervisor  
CMD ["/usr/bin/supervisord","-c","/etc/supervisord.conf &> /dev/null &"]

