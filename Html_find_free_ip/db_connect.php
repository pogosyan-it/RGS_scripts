<?php

$db_host='10.99.16.252';
$db_user='root';
$db_pass='123456Qw';
$db_name='ifacedb';

mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

$link = mysqli_connect($db_host, $db_user, $db_pass);
  if (!$link) {
  echo "Ошибка соединения с сервером MySQL!";
  exit;
  }

$db_select = mysqli_select_db($link, $db_name);

#$sql = "SELECT network FROM `subnet`";
#$result = mysqli_query($link, $sql);
#while ($row = mysqli_fetch_assoc($result)) 
#{
#  echo $row['network'];
#}
?>
