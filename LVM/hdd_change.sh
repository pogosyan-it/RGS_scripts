#!/bin/bash
# Скрипт осуществляет замену одного диска на другой большего размера в LVM группе 


echo "Введите номер группы томов в которой необходимо заменить диск"
n=$(pvscan | sed '$d' | awk '{print $4}' | uniq | wc  -l)
pvscan | sed '$d' | awk '{print $4}' | uniq | cat -n

read vgname

if [[ $vgname -le $n ]]; then
  
  for i in `seq 1 $n`; do  #в цикле осущесталяется перебор дисков в выбранной группе 
	case $vgname in
             $i)
                vgname=$(pvscan | sed '$d' | awk '{print $4}' | uniq | head -n $i | tail -n 1)
                echo "Вы выбрали группу $vgname"
                ;;
         esac
  done 

else
   echo "Вы ввели несуществующий номер"
fi

echo "Выберете диск подлежащий замене"

pvscan | grep $vgname | awk '{print $2 $6 $7 $8 $9 $10}' | cat -n

read hdd_num

hdd_old=$(pvscan | grep $vgname | awk '{print $2}' | head -n $hdd_num | tail -n 1)
hdd_old_vol=$(pvscan | grep $hdd_old | awk '{print $6}' | sed -e 's/\[<*//g' | tr '\,' '\.')

echo "Выберите диск которым нужно заменить $hdd_old"

fdisk -l | grep -E "\/dev\/sd[a-z]{1,2}:" | awk '{print $2,$3,$4 }' | cat -n

read hdd_num1

hdd_new=$(fdisk -l | grep -E "\/dev\/sd[a-z]{1,2}:" | awk '{print $2}'| head -n $hdd_num1 | tail -n 1 | sed -e 's/\:*//g')
hdd_n_vol=$(fdisk -l | grep -E "\/dev\/sd[a-z]{1,2}:" | head -n $hdd_num1 | tail -n 1 | awk '{print $3}'| tr '\,' '\.')
mb=$(fdisk -l | grep -E "\/dev\/sd[a-z]{1,2}:" | head -n $hdd_num1 | tail -n 1| awk '{print $4}')


 if [[ $mb='MB,' ]]; then    #Проверка единиц измерения объема диска и приведение к единой - GB
    hdd_new_vol=$(echo "scale=1;$hdd_n_vol/1024"|/usr/bin/bc -l) 
 fi

echo "hdd_old_vol=$hdd_old_vol, hdd_new_vol=$hdd_new_vol"
delta=$(echo "$hdd_new_vol>=$hdd_old_vol" | bc -l)
echo "DELTA=$delta"
echo "Заменить диск $hdd_old на диск $hdd_new в группе $vgname yes/no?"

read answer

Answer() {   #функция ответа с проверкой на ввод пользователя.

#delta=1
echo "delta=$delta"

if [[ $answer = "yes" ]]; then
   if [[ $delta -eq 1 ]]; then
	# m_point=$(df -h | grep $vgname | awk '{print $6}')
         echo "Выберите лог. раздел, котой подлежит расширению"
         lvs | grep $vgname | awk '{print $1}' | cat -n
         read lv_num
         lv_name=$(lvs | grep $vgname | awk '{print $1}' | head -n $lv_num | tail -n 1)
         fs_type=$(df -Th | grep "$vgname"-"$lv_name" | awk '{print $2}')
         echo "FS_TYPE=$fs_type"
         echo "LV_NAME=$lv_name"
         pvcreate $hdd_new &&
         echo "STEP1"    
         vgextend $vgname $hdd_new && 
         echo "STEP1"    
         pvmove $hdd_old &&
         echo "STEP3" 
         vgreduce $vgname $hdd_old &&
         echo "STEP4" 
         pvremove $hdd_old &&
         echo  "STEP5" &&
         lvextend -l +100%FREE /dev/mapper/"$vgname"-"$lv_name"
        if [[ $fs_type = "xfs" ]]; then                                    #Условие для проверки типа файловой системы -  утилита resise2fs не работает с xfs! 
             xfs_growfs /dev/mapper/"$vgname"-"$lv_name"
             echo "XFS"
        else
            e2fsck -f /dev/mapper/"$vgname"-"$lv_name" 
            resize2fs /dev/mapper/"$vgname"-"$lv_name"
            echo "FS=$fs_type"
        fi

   else
        echo  "Объем нового диска $hdd_new меньше объема диска подлежащего замене"
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


