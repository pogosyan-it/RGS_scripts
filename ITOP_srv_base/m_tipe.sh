#!/bin/bash
#rm mnum_serial.txt
while IFS= read -r -u9 line
  do
   echo $line    
   sshpass -p x.509SSL ssh -o StrictHostKeyChecking=no root@$line 'smbiosDump' 
   #| grep "System Info" -A 10
done 9<up.txt

