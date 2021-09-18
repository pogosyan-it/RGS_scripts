#! /usr/bin/env python
import mysql.connector
from mysql.connector import Error

def connect():
    """ Connect to MySQL database """
    try:
        conn = mysql.connector.connect(host='itop.rgs.ru',
                                       database='itop',
                                       user='itop',
                                       password='itop')
        if conn.is_connected():
            print('Connected to MySQL database')

cur = conn.cursor()

# Use all the SQL you like 


query="""SELECT a.NAME AS name_man FROM view_Server
     LEFT JOIN view_Server a ON a.id!=view_Server.id
     WHERE a.NAME=view_Server.NAME AND a.NAME NOT IN ('reserv-dis', 'NETBERG (Demos R140 M2)', 'IBM x3550 M3','Blade HS22',
	  'reserv/offline', 'ThinkSystem SR650', 'SB');"""

cur.execute(query) 
