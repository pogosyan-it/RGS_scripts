#!/bin/bash

source <(curl -s http://store.rgs.ru/store/Linux/misc/Scripts/include/ad_join_common.sh)
case $(cat /etc/system-release | egrep -i "Red Hat|CentOS|Oracle" | sed 's/.*release //' | sed 's/\..*$//') in
    6) source <(curl -s http://store.rgs.ru/store/Linux/misc/Scripts/include/ad_join_el6.sh);;
    7) source <(curl -s http://store.rgs.ru/store/Linux/misc/Scripts/include/ad_join_el7.sh);;
    8) source <(curl -s http://store.rgs.ru/store/Linux/misc/Scripts/include/ad_join_el8.sh);;
    *) echo -en '\E[32m'"\033[1m"; echo "Unsupported OS"; tput sgr0; exit 1;;
    esac
