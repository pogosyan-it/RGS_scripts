#!/bin/bash

mv ../ip.txt .
k=$(cat ip.txt | wc -l)
for (( i=1; i<=k; i++ )); do
  ip=$(cat ip.txt | awk '{print $2}'| head -n $i | tail -n 1)
  serial=$(cat ip.txt | awk '{print $1}'| head -n $i | tail -n 1)
   res=`ping -c 1 $ip &>/dev/null`
    if [[ "$?" = 1 ]]; then
      echo "${serial}  ${ip}" >>ip_not_reply.txt
    else
       #echo "${serial}  ${ip}" >> ip_reply.txt
       srv_type=$(sshpass -p "x,509SSL" ssh -o StrictHostKeyChecking=no admin@${ip} 'vpd sys' | awk '{print $1,$2}' | tail -n 2 | head -n 1 | cut -c 1-4)
       echo "${ip}  ${srv_type}"
       echo "${serial}  ${ip}  ${srv_type}" >> ip_type.txt
     fi
done

#python3 ./file_read.py
