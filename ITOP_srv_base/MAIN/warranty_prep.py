#! /usr/bin/env python
import pymysql.cursors  
import sys
import os
import datetime 
import subprocess

db = pymysql.connect(host="itop.rgs.ru",
                     user="itop",         # your username
                     passwd="itop",  # your password
                     db="itop",
                     #port="3306",    # your host, usually localhost
                     #charset='cp1251'
                     ) 
                     

# you must create a Cursor object. It will let
#  you execute all the queries you need
file = open('ip.txt','w')

cur = db.cursor()

# Use all the SQL you like 

query="""Select  serialnumber, CONCAT(serialnumber,'.rgs.ru'), managementip FROM view_Server WHERE  end_of_warranty > NOW()+INTERVAL - 2 YEAR 
         and datediff(end_of_warranty, purchase_date) < 1800 and view_Server.brand_name='Lenovo';"""     
           
cur.execute(query) 

def isint(s):
    try:
        int(s)
        return True
    except ValueError:
        return False

myresult = cur.fetchall()
for row in myresult:

    #print(row[0], row[2])
    file.write(row[0]+'  '+row[2]+'\n')

#proc = subprocess.Popen('./scripts/imm.sh', stdout=subprocess.PIPE)
#output = proc.stdout.read()
#print(output)
