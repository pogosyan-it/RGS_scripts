#!/bin/bash
 #Создание mdraid50 по указанию С.Деревянченко на его серверах 
yum install -y mdadm gdisk
hdd_array=($(fdisk -l | grep -E "\/dev\/sd[a-z]{1,2}:" | awk '{print $2}' | rev |cut -c 2- | rev))   # Array of all hdd in the system

exclude_hdd=$(fdisk -l | grep -E '^\/' | grep ' \* ' | awk '{print $1}' | rev | cut -c 2- | rev)  # hdd with root directory on it

for hdd in ${hdd_array[@]}; do
   if [[ $hdd != $exclude_hdd ]]; then
       sgdisk -o $hdd
       sgdisk -p $hdd
       sgdisk -N1 -t 1:fd00 $hdd
       echo $hdd
   fi
done

hdd_array () {
ARRAY_HDD=()
for i in `seq 1 $num`; do  #в цикле осущесталяется перебор дисков в выбранной группе 
       echo "Выберите следующий диск (Выбран $i из $num):"
       if [[ $i -eq 1 ]]; then
         sfdisk -l 2>/dev/null | grep -v Linux | grep -E "\/dev\/sd[a-z]{1,2}1" | awk '{print $1 }' | sort | cat -n 
       fi
       read disk
       ARRAY_HDD+=($(sfdisk -l 2>/dev/null | grep -v Linux | grep -E "\/dev\/sd[a-z]{1,2}1" | awk '{print $1}' | sort | head -n $disk | tail -n 1))
       if [[ $i -eq $num ]]; then
         echo ${ARRAY_HDD[@]}
       fi
done
}

raid5_create () {
echo "Хотите создать массив RAID5  (y/n):"
read answer

if [[ $answer == "y" ]]; then
   echo "Введите кол-во дисков из которых нужно собрать Raid5:"
   read num
   hdd_array
   md_num=$(mdadm --detail --scan --verbose | grep ARRAY | awk '{print $2}' | tail -n 1 | rev | cut -c -1 | rev)
   if [ -z "$md_num" ]; then 
       mdadm --create /dev/md1 -f --name=md1 --assume-clean --chunk=256 --level=5 --raid-devices=$num ${ARRAY_HDD[@]}
   else
     let "md_num1=$md_num+1"
     mdadm --create /dev/md"$md_num1" -f --name=md"$md_num1" --assume-clean --chunk=256 --level=5 --raid-devices=$num ${ARRAY_HDD[@]}
   fi
   unset ARRAY_HDD
   raid5_create 
fi
}

raid5_create

rm -vrf /etc/mdadm.conf

CONF () {
  dracut -f --mdadmconf

  pvcreate -v /dev/md50
  vgcreate -v bgfsvg /dev/md50
  lvcreate -v -n lv01 -L +10T bgfsvg
  lvcreate -v -n lv02 -L +10T bgfsvg
  mkfs.ext4 -m0 -E stride=64,stripe-width=1536 /dev/mapper/bgfsvg-lv01
  mkfs.ext4 -m0 -E stride=64,stripe-width=1536 /dev/mapper/bgfsvg-lv02

  echo "Введите в каком ЦОД-е находится сервер (m1 или k7):"
  read cod
  if [[ $cod == "m1" || $cod == "k7" ]]; then
    echo ${cod}_{1,2}
    mkdir -p /bgfs/storage/${cod}_{1,2}
  fi

  cp -v /etc/fstab /etc/fstab.back.`date +%F_%H%M`
  echo "/dev/mapper/bgfsvg-lv01  /bgfs/storage/${cod}_1  ext4 defaults  1 1" >> /etc/fstab
  echo "/dev/mapper/bgfsvg-lv02  /bgfs/storage/${cod}_2  ext4 defaults  1 1" >> /etc/fstab
  mount -t ext4 -a
}

raid_50 () {
md_array=()
echo "Хотите создать из существующих RAID5 массив RAID50  (y/n):"
read answer

if [[ $answer == "y" ]]; then
for md in `mdadm --detail --scan --verbose | grep ARRAY | awk '{print $2}'`; do
   mdadm --detail --scan $md >> /etc/mdadm.conf
   md_array+=($md)
   
done
   md_num=${#md_array[@]}
   mdadm --create /dev/md50 -f --name=md50 --chunk=256 --level=0 --raid-devices=$md_num ${md_array[@]}
   mdadm --detail --scan /dev/md50 >> /etc/mdadm.conf
   CONF
fi
   }

raid_50
