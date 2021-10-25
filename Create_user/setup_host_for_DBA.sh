#!/bin/bash
# Script add DBA users, setup profile and sysctl params for DB-host
DBA_INSTALL=1 #Configure system for DBA

# install top's
yum install -y atop iotop htop

# config sar rotation in 30 days
sed -i 's/HISTORY=28/HISTORY=30/g' /etc/sysconfig/sysstat

if [ "$DBA_INSTALL" = "1" ]
	then
		groupadd dba -g 500
                groupadd -f staff -g 1000
		useradd zobnin -p \$6\$BtenIt4lT2nCWc33$RxYf6sfnjWND9bC1cz\/25ysgqvDMfe4rEAMS3Ab\/1\.mZ9B8P5ikleoobI\.t6uJp2C8bvLCk2GeAV2Fxk5H7fS1 -g staff -u 911
		useradd lad -p \$1\$IwSBF\/9F\$qsR\/7i4syZepTv5eri5e80 -g staff -u 502
		useradd	ama -p \$1\$J1OotR1E\$xb8P6FRN\/JI02034\/g4SM0 -g staff -u 503
		useradd	rda -p \$1\$w90FhIlr\$bZKAtZL1rbz3F\/1COgkn8\. -g staff -u 504
		useradd oracle -p \$1\$xJjScnIP\$7kpoJPnUuoIRSJZKxhzfD\. -g dba -u 500
		echo "zobnin	ALL=(ALL) 	ALL" >> /etc/sudoers.d/zobnin
		echo "lad	ALL=(ALL) 	ALL" >> /etc/sudoers.d/lad
		echo "ama	ALL=(ALL) 	ALL" >> /etc/sudoers.d/ama
		echo "rda	ALL=(ALL) 	ALL" >> /etc/sudoers.d/rda
fi

#Add Oracle kernel options to sysctl.conf file
if [ "$DBA_INSTALL" = "1" ]
	then
		echo "" >> /etc/sysctl.conf
		echo "" >> /etc/sysctl.conf
		echo "# For Oracle Database" >> /etc/sysctl.conf
		echo "kernel.sem = 250 32000 100 128" >> /etc/sysctl.conf
		echo "fs.file-max = 6815744" >> /etc/sysctl.conf
		echo "fs.aio-max-nr = 1048576" >> /etc/sysctl.conf
		echo "kernel.shmmni = 4096" >> /etc/sysctl.conf
		echo "pv4.ip_local_port_range = 9000 65500" >> /etc/sysctl.conf
		echo "net.core.rmem_default = 262144" >> /etc/sysctl.conf
		echo "net.core.rmem_max = 4194304" >> /etc/sysctl.conf
		echo "net.core.wmem_default = 262144" >> /etc/sysctl.conf
		echo "net.core.wmem_max = 1048586" >> /etc/sysctl.conf
		echo "net.core.rmem_max = 4194304" >> /etc/sysctl.conf
		echo "net.core.wmem_default = 262144" >> /etc/sysctl.conf
		echo "net.core.wmem_max = 1048586" >> /etc/sysctl.conf
fi

#Add Oracle kernel options to limits.conf file
if [ "$DBA_INSTALL" = "1" ]
        then
                echo "" >> /etc/security/limits.conf
                echo "" >> /etc/security/limits.conf
                echo "# For Oracle Database" >> /etc/security/limits.conf
                echo "soft   nofile  10240" >> /etc/security/limits.conf
                echo "hard   nofile  65536" >> /etc/security/limits.conf
fi

#set file descriptor limit
if [ "$DBA_INSTALL" = "1" ]
        then
		echo 65535 > /proc/sys/fs/file-max
fi

#make /home/oracle/.bashrc
if [ "$DBA_INSTALL" = "1" ]
	then
		echo "ORACLE_SID=\"\$1\"" > /home/oracle/.bashrc
		echo "case \"\$ORACLE_SID\" in" >> /home/oracle/.bashrc
		echo " *)" >> /home/oracle/.bashrc
		echo "   NLS_LANG=AMERICAN_CIS.CL8MSWIN1251 ; export NLS_LANG" >> /home/oracle/.bashrc
		echo "   ORACLE_SID=smsprd01 ; export ORACLE_SID" >> /home/oracle/.bashrc
		echo "   ORACLE_BASE=/u01/app/oracle  ; export ORACLE_BASE" >> /home/oracle/.bashrc
		echo "   ORACLE_HOME=\$ORACLE_BASE/product/11.2.0/dbhome_1 ; export ORACLE_HOME" >> /home/oracle/.bashrc
		echo "   LD_LIBRARY_PATH=/usr/lib:/u01/app/oracle/product/11.2.0/dbhome_1/lib:/usr/local/lib:/usr/sfw/lib ; export LD_LIBRARY_PATH" >> /home/oracle/.bashrc
		echo "   ADR_HOME=\$ORACLE_BASE/diag/rdbms/\$ORACLE_SID/\$ORACLE_SID ; export ADR_HOME" >> /home/oracle/.bashrc
		echo " ;;" >> /home/oracle/.bashrc
		echo "esac" >> /home/oracle/.bashrc
		echo "" >> /home/oracle/.bashrc
		echo "TNS_ADMIN=\$ORACLE_HOME/network" >> /home/oracle/.bashrc
		echo "PATH=\$ORACLE_HOME/bin:/usr/ccs/bin:/usr/bin:/etc:/usr/openwin/bin:/usr/local/bin:\$HOME/bin:\$PATH" >> /home/oracle/.bashrc
		echo "PROMPT_COMMAND='export PS1=\"\\u@[\`/bin/basename \$ORACLE_HOME\`:\$ORACLE_SID]\\h(\\w)\\\$ \"'" >> /home/oracle/.bashrc
		echo "SQLPATH=\${HOME}/sql" >> /home/oracle/.bashrc
		echo "" >> /home/oracle/.bashrc
		echo "export PATH PROMPT_COMMAND TNS_ADMIN SQLPATH" >> /home/oracle/.bashrc
		echo "" >> /home/oracle/.bashrc
		echo "alias io='iostat -cdnxz 5'" >> /home/oracle/.bashrc
		echo "alias udf=\"df -h | head -n1; df -h | grep u[0-9] | sort -k 6\"" >> /home/oracle/.bashrc
		echo "# alias sal='less \$ORACLE_BASE/admin/\$ORACLE_SID/bdump/alert_\$ORACLE_SID.log'" >> /home/oracle/.bashrc
		echo "alias sal='less \$ORACLE_BASE/diag/rdbms/\$ORACLE_SID/\$ORACLE_SID/trace/alert_\$ORACLE_SID.log'" >> /home/oracle/.bashrc
		echo "alias pfl='less \$ORACLE_BASE/admin/\$ORACLE_SID/pfile/init\$ORACLE_SID.ora'" >> /home/oracle/.bashrc
		echo "alias pflvi='vi \$ORACLE_BASE/admin/\$ORACLE_SID/pfile/init\$ORACLE_SID.ora'" >> /home/oracle/.bashrc
		echo "alias wsqlplus='rlwrap -b \"\" -f \$HOME/sql.dict sqlplus'" >> /home/oracle/.bashrc
		echo "alias pfl2='less \$ORACLE_HOME/dbs/init\$ORACLE_SID.ora'" >> /home/oracle/.bashrc
		echo "alias pflvi2='vi \$ORACLE_HOME/dbs/init\$ORACLE_SID.ora'" >> /home/oracle/.bashrc
		echo "" >> /home/oracle/.bashrc
fi

#make /home/oracle/.profile
if [ "$DBA_INSTALL" = "1" ]
	then
		echo "MAIL=/usr/mail/\${LOGNAME:?}" > /home/oracle/.profile
		echo "HISTSIZE=10000" >> /home/oracle/.profile
		echo "EDITOR=vi ; export EDITOR HISTSIZE" >> /home/oracle/.profile
		echo "if [ -f ~/.bashrc ]; then" >> /home/oracle/.profile
		echo "	. ~/.bashrc" >> /home/oracle/.profile
		echo "fi" >> /home/oracle/.profile
fi

