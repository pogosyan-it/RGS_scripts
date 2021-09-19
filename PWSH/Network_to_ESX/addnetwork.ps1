#!/usr/bin/pwsh -Command

### GET ARGS ###

Param (
    [string] $file
)

### set vSwitch ### 

$vSwitch = "vSwitch0"


### Check file argument ###

IF([string]::IsNullOrWhiteSpace($file)) {
    Write-Host "Local Network List file not set!!!!"  -foreground blue
    Write-Host "Try to get Network list from http://store.rgs.ru/store/EMC/VMWare/EsxNetworktList.csv"
    mv EsxNetworktList.csv EsxNetworktList.bkp
    wget http://store.rgs.ru/store/EMC/VMWare/EsxNetworktList.csv
    $file = "EsxNetworktList.csv"
}

### Get params from cfg file ###

Get-Content /VMware-Scripts/VMware-Scripts.cfg | Foreach-Object{
   $var = $_.Split(' = ')
   New-Variable -Name $var[0] -Value $var[1]
#####   New-Variable -Name $var[0].TrimEnd -Value $var[1].TrimStart
}


### Get ESX-host Black List from HostBlackList file ###

    $HostBlackList = Get-Content $BlackListFile
    Write-Host "BLACKLIST: $HostBlackList"  -foreground blue


### Get file to import ###

IF([string]::IsNullOrWhiteSpace($file)) {        
    Write-Host "Network List file not set!!!!"  -foreground red
    exit
}
ELSE {
    Write-Host "File to import Network List - $file"  -foreground blue

    ### Import NetworkList from file ###

    $NetList = import-csv $file
    $NetListName = $NetList."Name"

     IF([string]::IsNullOrWhiteSpace($NetListName)) {
            Write-Host "info: NetWorkList Name in $file not found...."  -foreground red
        }
     ELSE{


       ### Connect to vCenter ##
       Connect-viserver "$vCenter" -user "$vCenterUser" -password "$vCenterUserPassword" -WarningAction 0 > /dev/null

       ### Check exists Networks ##

       $GetHostList = Get-VMHost
       $GetHostListNameTmp = $GetHostList.Name

       $GetHostListName = $GetHostListNameTmp | Where {$HostBlackList -NotContains $_ }

##########################################################
#######       $GetHostListName = "esx-ktj-01.rgs.ru"
############################################################

      ForEach ($GetHost in $GetHostListName) {
          $GetNetworkList = Get-VirtualPortGroup -VMHost $GetHost
          $NetListTmp = $NetList | Where {$GetNetworkList.Name -NotContains $_.Name }

                IF([string]::IsNullOrWhiteSpace($NetListTmp.Name)) {
                    Write-Host "All NetWorks from $file exist on $GetHost"  -foreground green
                }
                ELSE {
                   Write-Host "Add networks to $GetHost :" -foreground Yellow

                   ForEach ( $i in $NetListTmp ) {                 
                            $NName = $i.Name
                            $NVlan = $i.VlanId 
                            Write-Host "add net - $NName vlan - $NVlan "
                            Get-VirtualSwitch -VMHost $GetHost -Name $vSwitch | New-VirtualPortGroup -Name $NName -VLanId $NVlan

                        }
                   Write-Host "Done....." -foreground Green
                   
                }
           
        }

   }
}

