Авторизация пользователей AD полноценно работает без установки winbind
при условии исправления появившегося в версиях 4.х бага, связанного с гостевой УЗ.
https://bugzilla.redhat.com/show_bug.cgi?id=1740986

net -s /dev/null groupmap add sid=S-1-5-32-546 unixgroup=nobody type=builtin

после чего сервис samba успешно запустится.

(ITSM-913)
P.S см. также конфиг smb.conf store.rgs.ru
