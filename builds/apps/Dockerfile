# This is a base comment  
FROM staugur/centos  
MAINTAINER SaintIC <staugur@saintic.com>  
  
#yum install Package  
RUN yum -y install net-tools
RUN yum -y install iputils  iproute  man  vim-minimal  openssh-server  openssh-clients  
RUN yum -y install httpd  
RUN yum -y install python-setuptools  
RUN easy_install supervisor  

#set port  
EXPOSE 22  
EXPOSE 80  
EXPOSE $init_service_port

#set ENV  
ENV LANG en_US.UTF-8  
ENV LC_ALL en_US.UTF-8  

#run supervisor  
CMD ["/usr/bin/supervisord","-c","/etc/supervisord.conf &> /dev/null &"]

