#!/bin/bash
# Скрипт для добавление диска к существующей группе vg (LVM) и распределением места по логическим томам.  


echo "Введите номер группы томов подлежащей расширению"

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
hdd_n_vol=$(fdisk -l | grep -E "\/dev\/sd[a-z]{1,2}:" | head -n $hdd_num1 | tail -n 1 | awk '{print $3}'| tr '\,' '\.')
mb=$(fdisk -l | grep -E "\/dev\/sd[a-z]:" | head -n $hdd_num1 | tail -n 1| awk '{print $4}')


 if [[ $mb = 'MB,' ]]; then    #Проверка единиц измерения объема диска и приведение к единой - GB
    hdd_new_vol=$(echo "scale=1;$hdd_n_vol/1024"|/usr/bin/bc -l) 
 fi

echo "Добавить диск $hdd_new в группе $vgname yes/no?"

read answer

Answer() {   #функция ответа с проверкой на ввод пользователя.
 
if [[ $answer = "yes" ]]; then
       # m_name=$(df -h | grep $vgname | awk '{print $1}')
        echo "Выберите логический том который  нужно расширить."
        df -h | grep $vgname | awk '{print $1}' | sed 's|.*-||' | cat -n
        read lv_num
        lv_name=$(df -h | grep $vgname | awk '{print $1}' | sed 's|.*-||' | head -n $lv_num | tail -n 1)
        pvcreate $hdd_new && 
        vgextend $vgname $hdd_new && 
        lvextend -l +100%FREE /dev/mapper/"$vgname"-"$lv_name" &&
        fs_type=$(df -Th | grep "$vgname"-"$lv_name" | awk '{print $2}' | head -n 1)
        if [[ $fs_type = "xfs" ]]; then 
             xfs_growfs /dev/mapper/"$vgname"-"$lv_name"
        else
             resize2fs /dev/mapper/"$vgname"-"$lv_name"
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



