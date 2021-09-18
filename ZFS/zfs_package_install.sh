#!/bin/bash

name=$(lvs | grep root | awk '{print $2}')
#echo "Insert for master host - 1, for slave - 2"
#read num
#name2=".$num"
#name=${name1}${name2}

telnet cpmsk.rgs.ru 259

yum install tcsh git glibc-langpack-ru wget rsync lz4 bzip2 unzip zip tar telnet-server ethtool time tcpdump iotop lsof binutils gcc m4 bison make redhat-rpm-config xinetd gdb hexedit rhncfg-client -y

systemctl    stop xinetd

mount /export/share
rm -rf /root/.tcshrc /root/.cshrc /etc/csh.*
cp  /export/share/install/ROOT/etc/csh.* /etc/
cp -r /export/share/install/ROOT/etc/xinetd.d/ /etc/

echo "Insert for master host - 1, for slave - 2 or press enter to continue"
read num
if [[ $num -ge 1  ]]; then
  sed -i -e "s/set nn_=''/set nn_='.${num}'/g" /etc/csh.cshrc
  sed -i -e "s/set sg_='Dis'/set sg_='$name'/g" /etc/csh.cshrc
else
  sed -i -e "s/set nn_=''/set nn_='${num}'/g" /etc/csh.cshrc
  sed -i -e "s/set sg_='Dis'/set sg_='$name'/g" /etc/csh.cshrc
fi

systemctl stop sshd
systemctl disable sshd

systemctl start xinetd
systemctl enable xinetd

#-cp /export/Dis/screen-4.6.2-10.el8.x86_64.rpm /export/Dis/terminus-fonts-console-4.48-1.el8.noarch.rpm /root/

#-                                                    &&
  rpm -ivU /export/share/install/rpm/screen-4.6.2-10.el8.x86_64.rpm
  rpm -ivU /export/share/install/rpm/terminus-fonts-console-4.48-1.el8.noarch.rpm

  echo "KEYMAP='ruwin_cplk-UTF-8'" > /etc/vconsole.conf
  echo "FONT='ter-c14n'" >> /etc/vconsole.conf

  groupadd -g 911 me
  groupadd -g 5432 postgres
  groupadd -g 1970 cc
  groupadd -g 1982 sun
  useradd -u 10001 -g me -G wheel -d /var/lib/zobnin -s /usr/bin/tcsh zobnin
  useradd -u 5432 -g postgres -d /var/lib/pgsql -s /usr/bin/tcsh postgres
  #echo "%zobnin  ALL=(ALL)       ALL" >> /etc/sudoers
  #echo "%postgres  ALL=(ALL)       ALL" >> /etc/sudoers

  q=$(cat /etc/shadow | grep -n zobnin | sed -e 's/:.*//g')
  sed -i -e "$q d" /etc/shadow  
  echo "zobnin:\$6\$5X00Cb2uG9JhIQw4\$PHZcBjDX4JUKn70WtKPqhu4aAnIN/Xi6.peJ/m3a1MKqNTsYWzMRD1JpHalrNfjQuLoxEG6H0bkBgCOAiAVeR.:18549:0:99999:7:::" >> /etc/shadow
  sed -i -e's/^%wheel/#- %wheel/' -e's/^# %wheel/#+\n%wheel/' /etc/sudoers
  pwconv #You (postgres) are not allowed to access to (crontab) because of pam configuration 
          # Команда pwconv создаёт файл shadow из файла passwd и необязательно существующего файла shadow
#+
  #/export/oel+zfs/wheelNOPASSWD

  mount /store
  bash /store/Scripts_lnk/ad_join_rhel8.sh
  id ERPogosyan

