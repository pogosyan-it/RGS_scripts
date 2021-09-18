SELECT view_Server.NAME, view_Server.model_name,view_Server.serialnumber, view_Server.end_of_warranty, view_Server.location_name 
FROM view_Server WHERE view_Server.end_of_warranty > (SELECT CURDATE() - INTERVAL 1 MONTH) 
AND view_Server.end_of_warranty <(SELECT CURDATE());
