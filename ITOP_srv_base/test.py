#! /usr/bin/env python
import pymysql.cursors  
import sys
import os
import datetime 
# -*- coding: utf-8 -*- 


db = pymysql.connect(host="itop.rgs.ru",
                     user="itop",         # your username
                     passwd="itop",  # your password
                     db="itop")
                     #port="3306",    # your host, usually localhost
                     #charset='cp1251') 
                     

cur = db.cursor()

#cur.execute('Select NOW();')

query="""SELECT distinct a.NAME AS name_man  FROM view_Server
         LEFT JOIN view_Server a ON a.id!=view_Server.id
         WHERE a.NAME=view_Server.NAME AND a.NAME NOT IN ('reserv-dis', 'NETBERG (Demos R140 M2)', 'IBM x3550 M3','Blade HS22',
	  'reserv/offline', 'ThinkSystem SR650', 'SB');"""

query2=""" Select id from view_Server where view_Server.Name="%s" """
           
cur.execute(query) 

for row in cur:
    #l=row[0].split('.') 
    name=row[0].split(',')
    print(row[0]) 

print(len(row[0]))

for i in range(len(name)):
    cur.execute(query2,(name[i]))  
    myresult2 = cur.fetchall()
    for row2 in myresult2:
        print(row2)

def isint(s):
    try:
        int(s)
        return True
    except ValueError:
        return False


