#!/bin/bash
 #Скрипт заносит в базу данных все подсети, подключенные в ВМ
net_array=(`ip r | awk '{print $1 }' | grep -v 169.254* | grep -v default`)
mysql -u root -p123456Qw -D ifacedb -e "truncate table subnet;"

for net in ${net_array[*]}
do
   printf "   %s\n" $net
   export my_net=$net
   mysql -u root -p123456Qw -D ifacedb -e "set @my_net='${my_net}'; insert into subnet (network) values (@my_net);"
done
