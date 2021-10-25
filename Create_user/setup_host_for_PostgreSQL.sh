#!/bin/bash
# Script add DBA users, setup profile and sysctl params for PostgreSQL-host
POSTGRESQL_INSTALL=1 #Configure system for DBA

if [ "$POSTGRESQL_INSTALL" = "1" ]
	then
#		useradd akv -p \$1\$n9lvGVWA\$q8uxNyCNvPDXu1Vl55ufb\. -g staff -u 501
		useradd lad -p \$1\$IwSBF\/9F\$qsR\/7i4syZepTv5eri5e80 -g staff -u 502
		useradd	ama -p \$1\$J1OotR1E\$xb8P6FRN\/JI02034\/g4SM0 -g staff -u 503
		useradd	rav -p '$1$26ZBD5Mg$7UJErHNM8xcppkqZJWRjq0' -g staff -u 504
		groupadd -g 26 postgres
		useradd postgres --comment='PostgreSQL Server' --home-dir=/var/lib/pgsql -p '!$1$ba9tgfcD$i7SDM3DcRzxnjZZEAbvPS.' -u 26 -g 26
		groupadd -g 989 barman
		useradd barman --comment='Backup and Recovery Manager for PostgreSQL' --home-dir=/var/lib/barman -p '!$1$1ST9FFVC$Y6YsamTmqpYdwniQLi9n7.' -u 992 -g 989
		usermod -a -G postgres barman

#		echo "akv	ALL=(ALL) 	ALL" >> /etc/sudoers.d/akv
		echo "lad	ALL=(ALL) 	ALL" >> /etc/sudoers.d/lad
		echo "ama	ALL=(ALL) 	ALL" >> /etc/sudoers.d/ama
		echo "rav	ALL=(ALL) 	ALL" >> /etc/sudoers.d/rav
fi

#Add PostgreSQL kernel options to sysctl.conf file
if [ "$POSTGRESQL_INSTALL" = "1" ]
	then
		echo "" >> /etc/sysctl.conf
		echo "" >> /etc/sysctl.conf
		echo "# For PostgreSQL Database" >> /etc/sysctl.conf
                echo "vm.nr_hugepages = 100" >> /etc/sysctl.conf
                echo "vm.vfs_cache_pressure = 1000" >> /etc/sysctl.conf
fi

#disable transparent_hugepages
#add parameter in /boot/grub2/grub.cfg
if [ "$POSTGRESQL_INSTALL" = "1" ]
	then
		sed -i 's/rhgb quiet/rhgb quiet transparent_hugepage=never/g' /boot/grub2/grub.cfg
#		echo "never" > /sys/kernel/mm/transparent_hugepage/defrag
#		echo "never" > /sys/kernel/mm/transparent_hugepage/enabled
fi

