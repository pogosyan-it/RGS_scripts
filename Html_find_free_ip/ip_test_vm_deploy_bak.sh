#!/bin/bash

a=$(echo $1 | awk -F'.' '{print $1}')
b=$(echo $1 | awk -F'.' '{print $2}')
c=$(echo $1 | awk -F'.' '{print $3}')

if [[ $b -eq 200 ]]; then
  if [[ ( $c -le 195 ) && ( $c -ge 192 ) ]]; then
    net=$a.$b."192"
  else
     echo "IP address is out of range"
     exit 1
  fi 
elif [[ $b -eq  222 ]]; then
    net=$a.$b."0"
else
   net=$a.$b.$c
fi

echo $net

iface=$(ip r | grep $net.0 | awk '{print $3}')

echo $iface

if [[ -z $iface ]]; then 
   echo "Нет интерфейса с такой подсетью."
   echo "Создайте инерфейс в ВМ dhcp-tmp, затем повторите попытку"
else 

 /usr/bin/host $1 > /dev/null
   if [ $? -gt 0 ]; then
     arp_res=$(/usr/sbin/arping -c 1 $1 -I $iface)
     echo $arp_res
     echo $arp_res > /home/apache/arp12.tmp
     num=$(cat /home/apache/arp1.tmp | wc -l)
     res=$(cat /home/apache/arp1.tmp | tail -n 1 | awk '{print $2}')
     if [[ $num -ge 3 ]]; then 
        if [[ $res -eq 0 ]]; then
           echo "The ip address $1 is free"
        else
           echo "The ip addres $1 is used"
        fi
     else
        echo "The ip address $1 is free" 
     fi 
   else 
         echo "IP address $1 has A record - don't use it"
   fi
fi
