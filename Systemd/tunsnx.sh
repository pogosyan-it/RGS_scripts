#!/bin/bash

tun_check=$(ifconfig | grep tunsnx | sed -e 's/:.*//g')

if [[ -z $tun_check ]]; then #Проверка если переменная пустая, то запускать скрипт. Скрипт надеюсь не интерактивный?
     /bin/bash /home/console/snx.sh
fi
