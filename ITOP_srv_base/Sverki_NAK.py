#! /usr/bin/env python
import pymysql.cursors  
import sys
import os
import xlsxwriter
import datetime 
# -*- coding: utf-8 -*- 

now = datetime.datetime.now()
date=now.strftime("%Y-%m-%d")
date=date+'.xlsx'
print(date)
workbook = xlsxwriter.Workbook(date)
worksheet = workbook.add_worksheet()
excel_row = 0
excel_col = 0 
q = 0

db = pymysql.connect(host="10.10.1.2",
                     user="root",         # your username
                     passwd="2me32jvppn",  # your password
                     db="gsotldb",
                     #port="3306",    # your host, usually localhost
                     charset='cp1251') 
                     

# you must create a Cursor object. It will let
#  you execute all the queries you need
file = open('error.txt','w')
cur = db.cursor()

# Use all the SQL you like 

cur.execute('Select NOW() into @t1;') 
cur.execute('Select NOW() - Interval 5 day into @t2;') 

query="""Select d15_departures.WayBillNum, d15_departures.PickUpCode, d15_departures.Sh_Instructions, hbc_cities.Name,
          d15_departures.S_CityID, d15_departures.S_Addr
          from d15_departures
          left join hbc_cities on hbc_cities.ID=d15_departures.S_CityID
          where d15_departures.SY_OwnDiv=2 and d15_departures.SY_Void=0 and
          d15_departures.SY_Adding between @t2 and @t1
          and d15_departures.Sh_Instructions Regexp "^[0-9]{7,9}.*" and d15_departures.PickUpCode<>'0';"""     
           
query2="""Select d15_departures.WayBillNum , DATE_FORMAT(d15_departures.WayBillDate, '%%Y.%%m.%%d'), hbc_divisions.Name, 
                  a.Name, b.Name, 
                  c.Name, d15_departures.S_Name, d15_departures.S_Contact,  d15_departures.S_Addr, 
                  d15_departures.R_Name, d15_departures.R_Contact, d.Name, 
                  d15_departures.R_Phone, d15_departures.R_Addr, d15_departures.Sh_Weight, d15_departures.Sh_Place,
				  hbc_payers.Name, hbc_paymenttypes.Name, d15_departures.Sh_VWeight
                  from d15_departures 
                  left join hbc_divisions on hbc_divisions.ID=d15_departures.SY_OwnDiv
                  left join hbc_divisions a on a.ID=d15_departures.FromDivID
                  left join hbc_divisions b on b.ID=d15_departures.ToDivID
                  left join hbc_cities c on c.ID=d15_departures.S_CityID
                  left join hbc_cities d on d.ID=d15_departures.R_CityID
				  left join hbc_paymenttypes on hbc_paymenttypes.ID=d15_departures.PayType
                  left join hbc_payers on hbc_payers.ID=d15_departures.Payment
                  where d15_departures.WayBillNum="%s" ;"""          
cur.execute(query) 

def isint(s):
    try:
        int(s)
        return True
    except ValueError:
        return False

# print all the first cell of all the rows
cell_format = workbook.add_format({'bold': True})
worksheet.write(0, 0, "Номер Заказа", cell_format)
worksheet.write(0, 1, "Номер Накладной", cell_format)
worksheet.write(0, 2, "Дата", cell_format)
worksheet.write(0, 3, "Регион заказчикa",cell_format)
worksheet.write(0, 4, "Регион отправления",cell_format)
worksheet.write(0, 5, "Регион назначения", cell_format)
worksheet.write(0, 6, "Город Отправления", cell_format)
worksheet.write(0, 7, "Отправитель", cell_format)
worksheet.write(0, 8, "Контактное лицо", cell_format)
worksheet.write(0, 9, "Адрес отправителя", cell_format)
worksheet.write(0, 10, "Получатель", cell_format)
worksheet.write(0, 11, "Контактное лицо получателя", cell_format)
worksheet.write(0, 12, "Город доставки", cell_format)
worksheet.write(0, 13, "Телефон", cell_format)
worksheet.write(0, 14, "Адрес", cell_format)
worksheet.write(0, 15, "Вес", cell_format)
worksheet.write(0, 16, "Кол-во мест", cell_format)
worksheet.write(0, 17, "Кем оплавивается", cell_format)
worksheet.write(0, 18, "Тип оплаты", cell_format)


myresult = cur.fetchall()
for row in myresult:
    
    l=row[2].split('.') 
    waybill=l[0].split(',')

    
    for i in range(len(waybill)):
       if  isint(waybill[i]) == True:
             
           waybill[i] = int(waybill[i].lstrip())
           worksheet.write(q+i+1, 0, row[1])         
           worksheet.write(q+i+1, 1, waybill[i])
           if row[4]<1:
               worksheet.write(q+i+1, 6, row[5])
           else:
               worksheet.write(q+i+1, 6, row[3])   
           cur.execute(query2,(waybill[i]))  
           myresult2 = cur.fetchall()
                     
           for row2 in myresult2:
                
              #print(row2[0],row2[1],row2[2],row2[3],row2[4],row2[5],row2[6],row2[7])
              worksheet.write(q+i+1, 2, row2[1])
              worksheet.write(q+i+1, 3, row2[2])
              worksheet.write(q+i+1, 4, row2[3])
              worksheet.write(q+i+1, 5, row2[4])
              #worksheet.write(q+i+1, 6, row2[5])
              worksheet.write(q+i+1, 7, row2[6])
              worksheet.write(q+i+1, 8, row2[7])
              worksheet.write(q+i+1, 9, row2[8])
              worksheet.write(q+i+1, 10, row2[9])
              worksheet.write(q+i+1, 11, row2[10])
              worksheet.write(q+i+1, 12, row2[11])
              worksheet.write(q+i+1, 13, row2[12])
              worksheet.write(q+i+1, 14, row2[13])
              #worksheet.write(q+i+1, 15, row2[14])
              worksheet.write(q+i+1, 16, row2[15])
              worksheet.write(q+i+1, 17, row2[16])
              worksheet.write(q+i+1, 18, row2[17])
              if row2[14]>row2[18]:
                  worksheet.write(q+i+1, 15, row2[14])
              else:
                  worksheet.write(q+i+1, 15, row2[18])     
                          
 
       else:
           
          file.write(row[1]+waybill[i] + '\n')
          print(waybill[i])
      
           #print(row[1], waybill[i])
    q=q+len(waybill)   
#print (now.strftime("%Y-%m-%d %H:%M:%S"))
workbook.close()
db.close()
file.close()

cmd1 = 'mkdir -p /home/it/Sverki/"`date \+\%Y-\%m-\%d`"'
cmd2 = 'echo "См. вложение" | mail -s "Заказы Москвы" -a "`date \+\%Y-\%m-\%d`".xlsx -r gsot@corp.ws stp@corp.dimex.ws'
cmd3 = 'mail -s "Заказы Москвы" -r gsot@corp.ws stp@corp.dimex.ws < /home/it/MyPython/error.txt'
cmd4 = 'echo "См. вложение" | mail -s "Заказы Москвы" -a "`date \+\%Y-\%m-\%d`".xlsx -r gsot@corp.ws gsverki@dmcorp.ru'
cmd5 = 'mail -s "Заказы Москвы" -r gsot@corp.ws gsverki@dmcorp.ru < /home/it/MyPython/error.txt'
cmd6 = 'echo "См. вложение" | mail -s "Заказы Москвы" -a "`date \+\%Y-\%m-\%d`".xlsx -r gsot@corp.ws zakazy@moscow.dimex.ws'
cmd7 = 'mail -s "Заказы Москвы" -r gsot@corp.ws zakazy@moscow.dimex.ws < /home/it/MyPython/error.txt'
cmd8 = 'echo "См. вложение" | mail -s "Заказы Москвы" -a "`date \+\%Y-\%m-\%d`".xlsx -r gsot@corp.ws info@moscow.dimex.ws'
cmd9 = 'mail -s "Заказы Москвы" -r gsot@corp.ws info@moscow.dimex.ws < /home/it/MyPython/error.txt'
cmd10 = 'mv "`date \+\%Y-\%m-\%d`".xlsx error.txt /home/it/Sverki/"`date \+\%Y-\%m-\%d`"'

os.system(cmd1)
os.system(cmd2)
os.system(cmd3)
os.system(cmd4)
os.system(cmd5)
os.system(cmd6)
os.system(cmd7)
os.system(cmd8)
os.system(cmd9)
os.system(cmd10) 







