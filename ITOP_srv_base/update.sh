#!/bin/bash

n=$(cat without_type.txt | wc -l)
#echo $n
for (( i=1; i<=$n; i++ )); do
   serial=$(cat date_list.txt | awk '{print $1}' | head -n $i | tail -n 1 )
   date_start=$(cat date_list.txt | awk '{print $2}' | head -n $i | tail -n 1 )
   date_finish=$(cat date_list.txt | awk '{print $3}' | head -n $i | tail -n 1 )
   
   #echo $serial,$date_start,$date_finish
   #echo "SELECT * FROM physicaldevice WHERE physicaldevice.serialnumber='$serial'"| mysql itop  -u itop -pitop --disable-column-names
   echo "UPDATE physicaldevice SET physicaldevice.purchase_date='$date_start', physicaldevice.end_of_warranty='$date_finish' WHERE physicaldevice.serialnumber='$serial';" | mysql itop  -u itop -pitop 
done
