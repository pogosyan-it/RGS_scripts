SELECT '$SRV' into @sname; # где esx-m1-kau-01 это значение name_man из 1-го запроса.
SELECT view_Server.id FROM view_Server WHERE view_Server.NAME=@sname 
AND view_Server.osversion_name NOT LIKE '%ESXi%' OR  view_Server.NAME=@sname AND view_Server.osversion_name IS NULL INTO @id;
      
SELECT functionalci.description FROM functionalci WHERE functionalci.id=@id INTO @disc;
     
SELECT view_Server.id FROM view_Server WHERE view_Server.NAME=@sname AND view_Server.osversion_name LIKE '%ESXI%' INTO @id_for_update;
     
SELECT physicaldevice.serialnumber FROM physicaldevice WHERE physicaldevice.id=@id INTO @serial_num;
 
SELECT datacenterdevice.managementip FROM datacenterdevice WHERE datacenterdevice.id=@id INTO @mgmt_ip;
SELECT datacenterdevice.rack_id FROM datacenterdevice WHERE datacenterdevice.id=@id INTO @rack_id;
     
UPDATE functionalci SET functionalci.description=@disc WHERE functionalci.id=@id_for_update;
UPDATE physicaldevice SET physicaldevice.serialnumber=@serial_num WHERE physicaldevice.id=@id_for_update;
UPDATE datacenterdevice SET datacenterdevice.managementip=@mgmt_ip,datacenterdevice.rack_id=@rack_id where datacenterdevice.id=@id_for_update;
