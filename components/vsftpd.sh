#!/bin/bash
#Create virtual ftp users
vfu=/etc/vsftpd/vfu.list
vfudb=/etc/vsftpd/vfu.db
vfudir=etc/vsftpd/vfu_dir
ftpdata=/data/SDIusers
user=$2
passwd=$3

. ./functions

INSTALL() {
yum -y install vsftpd
cat >> $vfu <<EOF
$user
$passwd
EOF
[ "$SYS_VERSION" == "5" ] && yum -y install db4-utils
[ "$SYS_VERSION" == "6" ] && yum -y install db4-utils
[ "$SYS_VERSION" == "7" ] && yum -y install libdb-utils
db_load -T -t hash -f $vfu $vfudb
chmod 600 $vfu $vfudb

useradd –d $ftpdata –s /sbin/nologin vsftpd
chmod -R 770 $ftpdata
chown -R vsftpd.www $ftpdata

cat > /etc/pam.d/vsftpd.vu <<EOF
#%PAM-1.0
auth   required     pam_userdb.so  db=/etc/vsftpd/vusers
account required    pam_userdb.so  db=/etc/vsftpd/vusers
EOF

cat > /etc/vsftpd/vsftpd.conf<<EOF
ftpd_banner=Welcome to Your Ftp<SaintIC PaaS>.
anonymous_enable=NO
local_enable=YES
write_enable=YES
local_umask=022
xferlog_enable=YES
xferlog_std_format=YES
chroot_local_user=YES
chroot_list_enable=YES
chroot_list_file=/etc/vsftpd/chroot_list
userlist_enable=YES
userlist_deny=YES
listen=YES
listen_ipv6=NO
max_per_ip=5
tcp_wrappers=YES
pam_service_name=vsftpd
EOF

mkdir /etc/vsftpd/vusers_dir/
cd /etc/vsftpd/vusers_dir/
cat > $user <<EOF
write_enable=YES
anon_world_readable_only=NO 
anon_upload_enable=YES 
anon_mkdir_write_enable=YES 
anon_other_write_enable=YES 
local_root=/home/vsftpd/dbzh3
EOF
}

create() 
{
}
