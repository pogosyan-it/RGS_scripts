<form action="" method="post">
<table border="1px" width="50%" height="50%">
 <TR>
      <TH COLSPAN="2">
         <H3><BR>IP адрес считаем свободным если: </br>
              1)  Нет A-записи. </br>
              2)  Arping не возвращает MAC адрес.     
         </H3>
      </TH>
 </TR>
<tr>
        <td align="center">Проверка IP адреса:</td>
        <td align="center">Нахождение свободных IP адресов</td>
</tr>    
<tr>
        <td align="center"> <input type="text" name="ip" placeholder="IP адрес" ></td>
        <td width="50%">
          <form action="" method="post"> 
          <input type="text" name="num" placeholder="Кол-во не более 5 штук" >
          <select name="subnet">
          <option value='0'>Выберите подсеть</option>";
       <?php
          include 'db_connect.php';
          $sql = "SELECT network FROM subnet";
          $result = mysqli_query($link, $sql);
              while ($row = mysqli_fetch_assoc($result))
{
echo "<option value='".$row['network']."'>".$row['network']." </option>";
}
            
?>
<input type="text" name="start" placeholder="Начать с:" >
</td>
</tr>
<tr>
         <td align="center"> <input type="submit" value="Проверить IP" name="btn"></td>       
<td align="center">
<input type="submit" name="net" value="Свободные IP"></td>
</form>
 </select>
</td>
</tr>
<tr><td>
<?php
        
  if(isset($_POST['btn'])){
     $ip=$_POST['ip'];
     if (filter_var($ip, FILTER_VALIDATE_IP)) 
        {
           #show_error("IP указан не корректно!");
           #system("/var/www/html/test.sh");
           $part = explode(".", $ip);
          
              if ($part[1] == '200' )
            {
              if ( $part[2] <= '195' && $part[2] >= '192')
                  {
                    $net=$part[0].'.'.$part[1].'.'.'192';
                  }
               else  {
                       exit("IP address is out of range");
                     } 
             } 
     elseif ($part[1] == '222') 
          {
               $net=$part[0].'.'.$part[1].'.'.'0';
          } 
     else {
               $net = $part[0].'.'.$part[1].'.'.$part[2];
          }

              #echo  $net;
         $ifase = `(ip r | grep $net.0 | awk '{print $3}')`;
         #echo  $ifase;
         if (empty($ifase)) 
           { echo "Нет интерфейса с такой подсетью.";  } 
          else {
             #echo $ifase;
             $a_rec = `(/usr/bin/host $ip)`;
             $findme = 'domain name pointer';
             $pos = strpos($a_rec, $findme);
             if ($pos === false) {
                $str='/usr/bin/sudo /usr/sbin/arping  -c 1 '.$ip.' -I '.$ifase;
                $arp_req = shell_exec($str);
                $findme2 = 'reply';
                $pos2 = strpos($arp_req, $findme2);
                
                if (($pos2 === false)) 
                    {
                      echo "IP адрес $ip свободен";
                    }
                else {
                       echo "IP адрес $ip занят";
                      }   
          } else {
            echo "IP адрес $ip занят";
            
                 }
                }   
       
        }
    else
        {
           echo "IP указан не корректно!";
        
        }
      
   }
 ?>
<td>
<?php
if (isset($_POST['net']) &&  isset($_POST['num']) &&  isset($_POST['start'])) 
{
  $subnet = $_POST['subnet'];
  $num=$_POST['num'];
  $start=$_POST['start'];
  $mask =  explode("/", $subnet);
  $part = explode(".", $subnet);
   #echo $mask
  if (!empty($subnet) && !empty($num) && !empty($start) ) 
     {
       #echo "This is what I get: net=$subnet and num=$num started from $start";
       #$pos3 = strpos($subnet, '24');
       
       #if ($pos3 === false )
        if ($mask[1] == "22" )
          {
            $start_num=explode(".", $start);
            
          if (empty($start_num[1]))
            {
                echo "Начальное значение для выбранной подесети должно иметь вид a.b, где a=192-195, b=1-254";
            }
           elseif ( $start_num[0] >=192 && $start_num[0] <= 195 && $start_num[1]+$num < 254 )
            {
                    $start=$start_num[1];
                    #$part[2]==$start_num[0];
                    #echo "start_num=$start_num[0], part=$part[2]";
                    $part = explode(".", $subnet);
                    $net= $part[0].'.'.$part[1].'.'.$part[2];
                    $ifase = `(ip r | grep $net.0 | awk '{print $3}')`;
                    $j = 0;
                    do {
           
                      for ($i = $start; $i<=254; $i++) 
                      {
                                      
                         $ip =  $part[0].'.'.$part[1].'.'.$start_num[0].'.'.$i; 
                         $a_rec = `(/usr/bin/host $ip)`;
                         $findme = 'domain name pointer';
                         $pos = strpos($a_rec, $findme);
                     if ($pos === false) {
                        $str='/usr/bin/sudo /usr/sbin/arping  -c 1 '.$ip.' -I '.$ifase;
                        $arp_req = shell_exec($str);
                        $findme2 = 'reply';
                        $pos2 = strpos($arp_req, $findme2);
                        
                        if (($pos2 === false)) 
                            {
                              echo "IP адрес $ip свободен";   ?> </br> <?php
                              $j=$j+1;
                              if ($j > $num -1) {break;}
                            }
                         
                  } 
                         #$res=shell_exec("/usr/bin/sudo /var/www/html/ip_test_vm_deploy.sh $ip");
                        # echo $res;
                        
                      }
                    
                
        } while ( $j < $num);
  
            }
           
           
            else { echo "BAD";} 
           
          
          }
       elseif  ($mask[1] == "24" )
             {
              #echo "subnet equal 24";
             if ( $num <= 5 && $num + $start <= 254) {
              $part = explode(".", $subnet);
              $net= $part[0].'.'.$part[1].'.'.$part[2];
              $ifase = `(ip r | grep $net.0 | awk '{print $3}')`;
              $j = 0;
      do {
           
              for ($i = $start; $i<=254; $i++) 
              {
                              
                 $ip =  $part[0].'.'.$part[1].'.'.$part[2].'.'.$i; 
                 $a_rec = `(/usr/bin/host $ip)`;
                 $findme = 'domain name pointer';
                 $pos = strpos($a_rec, $findme);
             if ($pos === false) {
                $str='/usr/bin/sudo /usr/sbin/arping  -c 1 '.$ip.' -I '.$ifase;
                $arp_req = shell_exec($str);
                $findme2 = 'reply';
                $pos2 = strpos($arp_req, $findme2);
                
                if (($pos2 === false)) 
                    {
                      echo "IP адрес $ip свободен";   ?> </br> <?php
                      $j=$j+1;
                      if ($j > $num -1) {break;}
                    }
                 
          } 
                 #$res=shell_exec("/usr/bin/sudo /var/www/html/ip_test_vm_deploy.sh $ip");
                # echo $res;
                
              }
            
        
} while ( $j < $num);
}
   else {echo "Кол-во ip адресов должно быть не больше 5";}          
                       
            }  
else {echo "under construction";}
     }    
  else {
         echo "Заполните все поля";
       }
} 
?>

</td>
</td></tr>
</table>
</form>

