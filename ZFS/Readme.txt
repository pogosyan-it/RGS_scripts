Для железных серверов, после установки ОС:
1) запустить oel_prep.sh
2) Имя LVM группы должно совпадать с именем zfs пула (e.g. если имя сервера sed-db-pilot, то имя zfs пула и имя LVM группы будет sed)
   Изменить имя LVM группы можно с помощью скриптов: 
   /store/Scripts_lnk/LVM/vg-rename_efi.sh или /store/Scripts_lnk/LVM/vg-rename.sh в зависимости от того у нас EFI или LEGACY
3) запустить скрипт zfs_package_install.sh
4) Создать руками zfs pool  - raidz ( e.g. zpool create -m none zpool_name raidz /dev/nvme0n1p1 /dev/nvme1n1p1 /dev/nvme2n1p1 /dev/nvme3n1p1 /dev/nvme4n1p1 /dev/nvme5n1p1 /dev/nvme6n1p1 /dev/nvme7n1p1 /dev/nvme8n1p1 spare /dev/nvme9n1p1)
5) запустить скрипт zfs_pools_and_postgres_install.sh 
   (создает файловые системы zfs и устанавливает соответствующую требованиям версию postgres )

Для ВМ:
1) Развернуть шаблон OEL8.3_zfs_template
2) Повторить все действия со 2-го по 5-е для железных серверов
