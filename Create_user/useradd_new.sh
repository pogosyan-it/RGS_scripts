#!/bin/bash

#name="altikhonov"
echo "Введите логин пользователя: "
read name
n=$(cat IP_List.txt | wc -l)
  for ((count=1; count<=$n; count++)); do
    ip=$(cat IP_List.txt | head -n $count | tail -n 1)
     echo $ip
     sshpass -p "x.509SSL" ssh -o StrictHostKeyChecking=no root@$ip 'cat /etc/redhat-release | cut -f1 -d" "' > OS.lst
     sed "s/$/    $ip/" OS.lst >> OS_IP.txt 
     os_name=$(cat OS.lst)
     if [[ $os_name = "Red" ]]; then
         echo "OS_NAME=$os_name"
          sshpass -p "x.509SSL" ssh -o StrictHostKeyChecking=no root@$ip 'adduser '"$name"'; gpasswd -a '"$name"' wheel; echo z58Qmrd21 | passwd '"$name"' --stdin; passwd -e '"$name"''

     else
         echo "OS_NAME=$os_name"
         sshpass -p "x.509SSL" ssh -o StrictHostKeyChecking=no root@$ip 'adduser '"$name"'; usermod -aG wheel '"$name"'; echo z58Qmrd21 | passwd '"$name"' --stdin; passwd -e '"$name"''
     fi
 done
