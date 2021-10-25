#!/bin/bash
#ssh root@10.221.42.16 << EOF
#Необходимо установить sshpass

#sshpass -p "PASSW0RD" ssh -o StrictHostKeyChecking=no USERID@10.200.194.98 'batch -f S4APY342.imm -ip 10.200.32.13'
#sshpass -p "PASSW0RD" ssh -o StrictHostKeyChecking=no USERID@10.200.193.19 'batch -f 06GHBEC.imm -ip 10.200.32.13'
sshpass -p "x,509SSL" ssh -o StrictHostKeyChecking=no admin@10.200.194.109 'batch -f J30263KD.imm -ip 10.200.32.13'
sshpass -p "x,509SSL" ssh -o StrictHostKeyChecking=no admin@10.200.194.112 'batch -f J30263KE.imm -ip 10.200.32.13'
sshpass -p "x,509SSL" ssh -o StrictHostKeyChecking=no admin@10.200.194.113 'batch -f J30263KF.imm -ip 10.200.32.13'
#sshpass -p "x,509SSL1b" ssh -o StrictHostKeyChecking=no USERID@10.200.195.227 'batch -f J30263K5.imm -ip 10.200.32.13'
#sshpass -p "x,509SSL" ssh -o StrictHostKeyChecking=no admin@10.200.193.91 'batch -f J30267FL.imm -ip 10.200.32.13'

#sshpass -p "x,509SSL" ssh -o StrictHostKeyChecking=no admin@10.200.193.111 'batch -f esx-sr.imm -ip 10.200.32.13'
#sshpass -p "x,509SSL" ssh -o StrictHostKeyChecking=no admin@10.200.193.129 'batch -f esx-sr.imm -ip 10.200.32.13'
#sshpass -p "x,509SSL" ssh -o StrictHostKeyChecking=no admin@10.200.193.155 'batch -f esx-sr.imm -ip 10.200.32.13'
#sshpass -p "x,509SSL" ssh -o StrictHostKeyChecking=no admin@10.200.193.133 'batch -f esx-sr.imm -ip 10.200.32.13'
#sshpass -p "x,509SSL" ssh -o StrictHostKeyChecking=no admin@10.200.193.134 'batch -f esx-sr.imm -ip 10.200.32.13'
#sshpass -p "x,509SSL" ssh -o StrictHostKeyChecking=no admin@10.200.193.135 'batch -f esx-sr.imm -ip 10.200.32.13'


#for ((count=118;count<128;count++)); do
#     sshpass -p "x,509SSL" ssh -o StrictHostKeyChecking=no admin@10.200.193.$count 'vpd sys' | awk '{print $2}' | tail -n 2 >>new_srv.txt
#     sshpass -p "x,509SSL" ssh -o StrictHostKeyChecking=no admin@10.200.193.$count 'vpd fw'>>new_srv.txt
#done
