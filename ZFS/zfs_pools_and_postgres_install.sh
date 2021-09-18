#!/bin/bash

name=$(lvs | grep root | awk '{print $2}')

echo "At first you must create zpool on your hard drives, if it done type 'yes'"
read answer1

echo "Which version of postgres do you want to install"
echo "10"
echo "11"
echo "12"
echo "13"
read version

if [[ $answer1 = "yes" ]]; then 

   #zpool create -f $name /dev/sda4
   zfs set mountpoint=none $name
   zfs set compress=lz4 $name
   zfs set atime=off $name
   zfs create -o mountpoint=/db ${name}/db
   zfs create -o mountpoint=none ${name}/pgsql
   #zfs create -o mountpoint=/home ${name}/home
   zfs create -o mountpoint=/usr/pgsql-$version ${name}/pgsql/$version
   mv /var/lib/pgsql /var/lib/pgsql_bak
   zfs create -o mountpoint=/var/lib/pgsql ${name}/pgsql/home
   rsync -avzh /var/lib/pgsql_bak /var/lib/pgsql/
   rm -rf /var/lib/pgsql_bak/
   
fi

 echo "Do you want to install PostgreSQL, yes/no"  
   read answer2
    if [[ $answer2 = "yes" ]]; then
       
       dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm
       dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
       dnf -qy module disable postgresql
       #dnf install perl-TimeHiRes perl-DBI perl-DBD-Pg
       dnf install -y postgresql$version-server  postgresql$version-libs pg_activity
       dnf install -y pg_repack$version pg_stat_kcache$version postgresql$version-devel postgresql$version-contrib
       chmod -R  0700 /var/lib/pgsql
       chown -R postgres:postgres /var/lib/pgsql
       #/usr/pgsql-$version/bin/postgresql-$version-setup initdb
       #systemctl enable postgresql-$verion
       #systemctl start postgresql-$verion
       os=$(hostnamectl | grep 'Operating System' | awk '{print $3}')
       if [[ $os = "Oracle" ]]; then
         mkdir -p /root/repo
         mv /etc/yum.repos.d/*.repo /root/repo
         curl -o /usr/share/rhn/RHN-ORG-TRUSTED-SSL-CERT http://spacewalk.rgs.ru/pub/RHN-ORG-TRUSTED-SSL-CERT
         rhnreg_ks --activationkey=1-oracle8-x86_64 --serverUrl=https://spacewalk.rgs.ru/XMLRPC --sslCACert=/usr/share/rhn/RHN-ORG-TRUSTED-SSL-CERT --force
         echo "Подписаться на Sacewalk к соответствующему каналу"
       fi
  fi
#+
#   cp /export/git/pgcompacttable/bin/pgcompacttable /usr/bin/

