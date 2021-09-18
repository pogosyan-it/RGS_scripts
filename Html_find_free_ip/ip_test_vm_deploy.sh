#!/bin/bash
 #Скрипт парсит введенный с вею формы ip адрес, сравнивает с имеющимися в ВМ подсетями. В случае если введенный ip адрес пренадлежит подсети, то сперва проверяетс резолвится ли он, а затем и arping.
 #Если резолвится - то сразу считаем что занят, если нет то проверяем arping. Если arping не возвращает MAC адрес, то такой IP считаем свободным.
 # Весь функционал перенесен в файл ip_check.php 
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

#echo $net

iface=$(ip r | grep $net.0 | awk '{print $3}')

#echo $iface
touch  /home/apache/1.txt
if [[ -z $iface ]]; then 
   echo "Нет интерфейса с такой подсетью."
   echo "Создайте инерфейс в ВМ dhcp-tmp, затем повторите попытку"
else 

 /usr/bin/host $1 > /dev/null
   if [ $? -gt 0 ]; then
     arp_req=$(arping -c 1 $1 -I $iface | grep reply)
     echo "arp=$arp_req" 
     if [[ -z $arp_req ]]; then 
           echo "The ip address $1 is free"
      else
           echo "The ip addres $1 is used"
      fi
   else 
         echo "IP address $1 has A record - don't use it"
   fi
fi
