#!/bin/bash
#Отправка ана почту списка серверов с истекающим сроком гарантийного обслуживания.
  
   dir="/home/admin/itop/warranty"
   cat $dir/query_end_of_warranty.sql | mysql itop  -u itop -pitop > $dir/query_end_of_warranty.txt
   cat $dir/query_one_month_before_end.sql | mysql itop  -u itop -pitop > $dir/query_one_month_before_end.txt
   n=$(cat $dir/query_end_of_warranty.txt | wc -l)
   m=$(cat $dir/query_one_month_before_end.txt | wc -l)
   m_name=$(date +"%B")
if [[ $n -gt 0 ]]; then
    echo "Список серверов снятых с поддержки - $m_name" > $dir/res.txt
    echo "                                            " >> $dir/res.txt 
    cat $dir/query_end_of_warranty.txt >> $dir/res.txt
fi
if [[ $m -gt 0 ]]; then
    echo "Список серверов c истекающим сроком поддержки" >> $dir/res.txt
    echo "                                            " >> $dir/res.txt 
    cat $dir/query_one_month_before_end.txt >> $dir/res.txt
fi
   mail -s "Server Warranty Expiration" tcadmin_arch@ss.rgs.ru < $dir/res.txt
   
rm $dir/query_end_of_warranty.txt $dir/query_one_month_before_end.txt $dir/res.txt
