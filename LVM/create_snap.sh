#!/bin/bash
# Скрипт  создает снапшот логического тома, по выбору удаляет снапшот  или откатывает изменения.
snapshot_create () {
n=$(vgs | wc -l)
echo "n=$n"
let "num=$n-1"
echo "Выбирите нужную группу"
vgs | awk '{print $1}' | tail -n $num | cat -n
read vg_num
vg_name=$(vgs | awk '{print $1}' | tail -n $num | cat -n | head -n $vg_num | tail -n 1 | awk '{print $2}')
echo "Выбирите логический том"
lvs | grep $vg_name | awk '{print $1}'| cat -n
read lv_num
lv_name=$(lvs | grep $vg_name | awk '{print $1}' | cat -n | head -n $lv_num | tail -n 1 | awk '{print $2}' )
echo "Введите размер снапшота в ГБ"
read sn_vol
lvcreate --size "$sn_vol"G --snapshot --name "$lv_name"_snap /dev/$vg_name/$lv_name
}

snap_merge () {
mount_point=$(df -h | grep $lv_snap_name | awk '{print $6}')
if [[ $mount_point == "/" || $mount_point == "/home" || $mount_point == "/var" ]]; then
   echo $mount_point
   echo "Чтобы восстановить $lv_snap_name необходимо его отмонтировать и перезагрузиться  yes/no"
   read answer
   if [[ $answer = "yes" && $mount_point == "/" ]]; then
       #umount -l $mount_point
       echo "Снапшот корневой диектории - в процессе востановления компьтер будет перезагружен"
       lvconvert --merge /dev/$vg_snap_name/$snap_name &&
       reboot
   elif [[ $answer = "yes" && $mount_point == "/home" || $answer = "yes" && $mount_point == "/var" ]]; then
       umount -l $mount_point &&
       lvchange -an  /dev/$vg_snap_name/$snap_name
       vchange -ay  /dev/$vg_snap_name/$snap_name
       lvconvert --merge /dev/$vg_snap_name/$snap_name 
       #reboot
   else
      echo "Good by" 
   fi
else
       echo $mount_point
       umount -l $mount_point
       lvconvert --merge /dev/$vg_snap_name/$snap_name
       mount -a
fi
}

snapshot_operate (){
snap_name=$(lvs | grep snap | awk '{print $1}')
vg_snap_name=$(lvs | grep snap | awk '{print $2}')
lv_snap_name=$(lvs | grep snap | awk '{print $5}')
if [[ ! -z $snap_name ]]; then
   echo "Выбирите действие со снапшотом $check_snap:"
   echo "1. Удалить снапшот"
   echo "2. Восстановить LV из снапшота"
   read act_num
   case $act_num in
          1)      
          lvremove /dev/$vg_snap_name/$snap_name
          ;;
          2)
          snap_merge
          ;;
          *)
          echo "Введите целое число от 1 до 2 включительно"
          ;;
   esac

else
   echo "Снапшот не создан"
fi
}

if [ -z $* ]
then
echo "Скрипт запускается либо с ключем -s (создание снапшота)"
echo "либо с ключем -f(окончание работы)"
exit 1
fi

while getopts "sf" opt
do
case $opt in
s) snapshot_create;;
f) snapshot_operate;;
*) echo "No reasonable options found!";;
esac
done
