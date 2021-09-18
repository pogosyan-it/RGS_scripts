#!/bin/bash
# Скрипт для добавления нового тома к существующей группе vg (LVM) 


echo "Введите номер группы томов к которой необходимо добавить новый логический том"

n=$(pvscan | sed '$d' | awk '{print $4}' | uniq | wc  -l)
pvscan | sed '$d' | awk '{print $4}' | uniq | cat -n

read vgname

if [[ $vgname -le $n ]]; then
  
  for i in `seq 1 $n`; do  #в цикле осущесталяется перебор дисков в выбранной группе 
	case $vgname in
             $i)
                vgname=$(pvscan | sed '$d' | awk '{print $4}' | uniq | head -n $i | tail -n 1)
                echo "Вы выбрали группу $vgname, содержащую следующие диски"
                ;;
         esac
  done 

else
   echo "Вы ввели не существующий номер"
fi

pvscan | grep $vgname | awk '{print $2 $6 $7 $8 $9 $10}'

echo "Выберите диск, который нужно добавить к группе $vgname"


fdisk -l | grep -E "\/dev\/sd[a-z]{1,2}:" | awk '{print $2,$3,$4 }' | cat -n

read hdd_num1

hdd_new=$(fdisk -l | grep -E "\/dev\/sd[a-z]{1,2}:" | awk '{print $2}'| head -n $hdd_num1 | tail -n 1 | sed -e 's/\:*//g')

echo "Введите название логического тома"
read lv_name

echo "Добавить диск $hdd_new в группе $vgname yes/no?"

read answer

Answer() {   #функция ответа с проверкой на ввод пользователя.
 
if [[ $answer = "yes" ]]; then
        pvcreate $hdd_new && 
        vgextend $vgname $hdd_new &&
        echo "NEW_LV_NAME=$lv_name" 
        lvcreate -l100%FREE -n /dev/mapper/"$vgname"-"$lv_name" 
        fs_type=$(df -Th | grep "$vgname*"| awk '{print $2}'| head -n 1)
        if [[ $fs_type = "xfs" ]]; then 
            mkfs.xfs /dev/mapper/"$vgname"-"$lv_name"
        else
            mkfs.ext4 /dev/mapper/"$vgname"-"$lv_name"
        fi
elif [[ $answer = "y" ]]; then
  echo "Наберите полностью yes..."
  read answer
  Answer
else
  echo "Попробуйте еще раз."
fi
      }

Answer



