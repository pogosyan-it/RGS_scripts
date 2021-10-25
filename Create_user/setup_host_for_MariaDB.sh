#!/bin/bash
# Script add DBA users, setup profile and sysctl params for MariaDB-host
MARIADB_INSTALL=1 #Configure system for DBA

if [ "$MARIADB_INSTALL" = "1" ]
        then
#                useradd akv -p \$1\$n9lvGVWA\$q8uxNyCNvPDXu1Vl55ufb\. -g staff -u 501
                useradd lad -p \$1\$IwSBF\/9F\$qsR\/7i4syZepTv5eri5e80 -g staff -u 502
                useradd ama -p \$1\$J1OotR1E\$xb8P6FRN\/JI02034\/g4SM0 -g staff -u 503
                useradd rav -p '$1$26ZBD5Mg$7UJErHNM8xcppkqZJWRjq0' -g staff -u 504

#                echo "akv       ALL=(ALL)       ALL" >> /etc/sudoers.d/dba
                echo "lad       ALL=(ALL)       ALL" >> /etc/sudoers.d/dba
                echo "ama       ALL=(ALL)       ALL" >> /etc/sudoers.d/dba
                echo "rav       ALL=(ALL)       ALL" >> /etc/sudoers.d/dba
fi

#Add MariaDB kernel options to sysctl.conf file
if [ "$MARIADB_INSTALL" = "1" ]
        then
                echo "" >> /etc/sysctl.conf
                echo "" >> /etc/sysctl.conf
                echo "# For MariaDB" >> /etc/sysctl.conf
fi
