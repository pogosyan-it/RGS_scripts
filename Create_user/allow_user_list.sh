#!/bin/bash

# set VAR #
AdminListFile=/etc/sssd/sssd.conf
UserListFile=/etc/sssd/conf.d/users
AllowUserListFile=/etc/sssd/conf.d/AllowUserList.conf
Users=null
Admins=null
AllowList=null

# Check file exists #

if [ -r "$AdminListFile" ]; then
   # get AdminList #
   Admins="$(cat $AdminListFile | grep simple_allow_users | awk -F " = " '{printf $2}')"
##else
##   echo "$AdminListFile not found."
fi


if [ -r "$UserListFile" ]; then
   # get UserList #
   Users="$(cat $UserListFile | grep simple_allow_users | awk -F " = " '{printf $2}')"
##else
##   echo "$UserListFile not found."
fi

# Check $VAR not null #

if [ -n "$Admins" ]; then                  
   AllowList="$(echo $Admins)"
elif [ -n "$Users" ]; then                  
   AllowList="$(echo $Users)"
elif [ -n "$Admins" ] && [ -n "$Users"]; then  
   AllowList="$(echo $Admins","$Users)"
fi 

if [ -n "$AllowList" ]; then                    

  # put AllowUserList #
    echo "[domain/rgs.ru]" > $AllowUserListFile
    echo "simple_allow_users = $AllowList" >> $AllowUserListFile
  # set permission #
    chmod 0600 $AllowUserListFile
  # restart SSSD service #
    sss_cache -E
    systemctl restart sssd

else 
   echo "Error!!! User list is empty!!!"
   exit
fi 

