#!/bin/bash
n=$(cat answer_host.txt | wc -l)
  for ((count=1; count<=$n; count++)); do
    ip=$(cat answer_host.txt | head -n $count | tail -n 1)
     ping -c1 $ip > /dev/null  
       if [ $? -gt 0 ]; then
               echo $ip >> not_resp.txt 
            else
               res=$(sshpass -p "x,509SSL" ssh -o StrictHostKeyChecking=no admin@$ip 'adapter -list' | grep FC | awk '{$1=""; print $0}' )
               echo $ip  $res >> hba.txt
       fi
  done


