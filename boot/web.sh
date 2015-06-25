#!/bin/bash
#web.app:nginx,httpd,tomcat
#Sdp Server,nginx proxy dns.
source $SDP_HOME/global.func
[ -z $webs ] && ERROR
[ -z $INIT_HOME ] && ERROR
[ -z $init_user ] && ERROR
[ -z $init_passwd ] && ERROR
[ -z $init_file_type ] && ERROR
[ -z $init_user_home ] && ERROR
[ -z $init_user_home_info ] && ERROR
[ -z $init_user_home_root ] && ERROR


server { 
    listen 80; 
    server_name s5.yong.com;
    location / { 
        proxy_set_header X-Real-IP $remote_addr; 
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for; 
        proxy_set_header Host $http_host; 
        proxy_pass http://s5:8080; 
    } 
}

