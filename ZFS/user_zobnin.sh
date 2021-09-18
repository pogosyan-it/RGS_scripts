 #!/bin/bash 
  
 echo "KEYMAP='ruwin_cplk-UTF-8'" > /etc/vconsole.conf
  echo "FONT='ter-c14n'" >> /etc/vconsole.conf

  groupadd -g 911 me
  groupadd -g 5432 postgres
  groupadd -g 1970 cc
  groupadd -g 1982 sun
  useradd -u 10001 -g me -G wheel -d /var/lib/zobnin -s /usr/bin/tcsh zobnin
  useradd -u 5432 -g postgres -d /var/lib/pgsql -s /usr/bin/tcsh postgres
  #echo "%zobnin  ALL=(ALL)       ALL" >> /etc/sudoers
  #echo "%postgres  ALL=(ALL)       ALL" >> /etc/sudoers

  q=$(cat /etc/shadow | grep -n zobnin | sed -e 's/:.*//g')
  sed -i -e "$q d" /etc/shadow
  echo "zobnin:\$6\$5X00Cb2uG9JhIQw4\$PHZcBjDX4JUKn70WtKPqhu4aAnIN/Xi6.peJ/m3a1MKqNTsYWzMRD1JpHalrNfjQuLoxEG6H0bkBgCOAiAVeR.:18549:0:99999:7:::" >> /etc/shadow
  sed -i -e's/^%wheel/#- %wheel/' -e's/^# %wheel/#+\n%wheel/' /etc/sudoers
  pwconv
