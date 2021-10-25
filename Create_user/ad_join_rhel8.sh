#!/bin/bash
#release_num=$(hostnamectl | grep System | awk '{print $5}')

#if [[ $release_num -eq 8 ]]; then
   #echo "This is RHEL8"
   export LANG=en_US
   echo "export LANG=en_US" >> /root/.bashrc
   yum install nano realmd chrony krb5-workstation adcli sssd oddjob oddjob-mkhomedir samba-common-tools openldap-clients bind-utils timedatex -y --nogpgcheck 
   systemctl enable chronyd
   systemctl enable sssd
   #realm leave 
   sed -i "s/\#PermitRootLogin yes/PermitRootLogin no/" /etc/ssh/sshd_config
   sed -i "s/\#PermitRootLogin yes/PermitRootLogin without-password/" /etc/ssh/sshd_config
   sed -i "s/\#PermitRootLogin yes/PermitRootLogin yes/" /etc/ssh/sshd_config
   sed -i "s/\#KerberosAuthentication no/KerberosAuthentication yes/" /etc/ssh/sshd_config
   echo -e "\tGSSAPIDelegateCredentials yes" >> /etc/ssh/ssh_config 
   echo "server ntp1.rgs.ru iburst" >> /etc/chrony.conf
   timedatectl set-ntp true
   systemctl start chronyd.service
   touch /etc/sudoers.d/admins


cat > /etc/nsswitch.conf <<EOF
passwd:     files sss systemd
shadow:     files sss
group:      files sss systemd
hosts:      files dns myhostname
services:   files sss
netgroup:   sss
automount:  files sss
aliases:    files
ethers:     files
gshadow:    files
networks:   files dns
protocols:  files
publickey:  files
rpc:        files
EOF

cat > /etc/sudoers.d/admins <<EOF
gzelenin   ALL=(ALL)   NOPASSWD: ALL
sbasmanov   ALL=(ALL)   NOPASSWD: ALL
sderevyanchenko   ALL=(ALL)   NOPASSWD: ALL
vsmedvedev   ALL=(ALL)   NOPASSWD: ALL
masgibnev   ALL=(ALL)   NOPASSWD: ALL
svsuprunov   ALL=(ALL)   NOPASSWD: ALL
inkoshelev   ALL=(ALL)   NOPASSWD: ALL 
myudanilov   ALL=(ALL)   NOPASSWD: ALL
vrbalaba   ALL=(ALL)   NOPASSWD: ALL
erpogosyan   ALL=(ALL)   NOPASSWD: ALL
rauvarov     ALL=(ALL)   NOPASSWD: ALL
nnzobnin     ALL=(ALL)   NOPASSWD: ALL
zobnin     ALL=(ALL)   NOPASSWD: ALL
mrryabochkin    ALL=(ALL) NOPASSWD: ALL
EOF

cat > /etc/krb5.conf <<EOF
[logging]
 default = FILE:/var/log/krb5libs.log
 kdc = FILE:/var/log/krb5kdc.log
 admin_server = FILE:/var/log/kadmind.log

[libdefaults]
 dns_lookup_realm = false
 ticket_lifetime = 24h
 renew_lifetime = 7d
 forwardable = true
 rdns = false
# default_realm = EXAMPLE.COM
 default_ccache_name = KEYRING:persistent:%{uid}

 default_realm = RGS.RU
[realms]

 RGS.RU = {
 }
[domain_realm]
 rgs.ru = RGS.RU
 .rgs.ru = RGS.RU

EOF

cat > /etc/sssd/sssd.conf <<EOF
[sssd]
domains = rgs.ru
config_file_version = 2
services = nss, pam

[domain/rgs.ru]
ad_domain = rgs.ru
krb5_realm = RGS.RU
realmd_tags = manages-system joined-with-samba
cache_credentials = True
id_provider = ad
ad_server = rgs-rootdc-03.rgs.ru
ad_backup_server = rgs-rootdc-02.rgs.ru, rgs-rootdc-01.rgs.ru
krb5_store_password_if_offline = True
default_shell = /bin/bash
ldap_id_mapping = True
use_fully_qualified_names = False
fallback_homedir = /home/%u@%d
#access_provider = simple
access_provider = ad
#simple_allow_groups = linux_users
simple_allow_users = svsuprunov, gzelenin, inkoshelev, sbasmanov, sderevyanchenko, vsmedvedev, masgibnev, myudanilov, erpogosyan, nnzobnin, rauvarov, mrryabochkin
sudo_provider = none
EOF
#adding home directoris for simple_allow_users
mkhomedir_helper svsuprunov
mkhomedir_helper vsmedvedev
mkhomedir_helper erpogosyan
mkhomedir_helper nnzobnin
mkhomedir_helper mrryabochkin

read -p "Enter login: RGSMAIN\\" USERLOGIN
LANG=C 
/usr/sbin/adcli join --verbose --domain rgs.ru --domain-realm RGS.RU --domain-controller rgs-rootdc-02.rgs.ru --computer-ou OU="Linux Servers,DC=rgs,DC=ru" --login-type user --login-user $USERLOGIN
systemctl restart sshd.service
systemctl start realmd.service
systemctl start sssd.service

chmod go-rwx /etc/sssd/sssd.conf
systemctl restart sssd
