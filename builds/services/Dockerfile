# This is a base comment  
FROM centos:latest  
MAINTAINER yorko Liu <liutiansi@gmail.com>  
  
#yum install Package  
RUN yum -y install net-tools  
RUN yum -y install iputils  iproute  man  vim-minimal  openssh-server  openssh-clients  
RUN yum -y install httpd  
RUN yum -y install python-setuptools  
RUN easy_install supervisor  
  
#set sshd  
RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key  
RUN ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key  
RUN ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N ""  
RUN sed -ri 's/session    required     pam_loginuid.so/#session    required     pam_loginuid.so/g' /etc/pam.d/sshd  
RUN mkdir -p /root/.ssh && chown root.root /root && chmod 700 /root/.ssh  
RUN echo 'root:Ksjhg34TDju' | chpasswd  
  
#set supervisor  
RUN mkdir -p /var/log/supervisor  
ADD supervisord.conf /etc/supervisord.conf  
  
#set port  
EXPOSE 22  
EXPOSE 80  
  
#set ENV  
ENV LANG en_US.UTF-8  
ENV LC_ALL en_US.UTF-8  
  
#run supervisor  
CMD ["/usr/bin/supervisord","-c","/etc/supervisord.conf &> /dev/null &"]

