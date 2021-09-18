#!/usr/bin/pwsh -Command
##########################
# PowerCLI to create VMs #
# Version 1.0            #
##########################

foreach($line in Get-Content .\VM_to_Clone.txt) 
    {
       $VMName,$SourceVM,$VMHOST,$DATASTORE = $line.Split(',')
       $VM = New-VM -Name $VMName -VM $SourceVM -VMHost $VMHOST -Datastore $DATASTORE
       
       New-TagAssignment -Tag "PCG" -Entity $VMName
       New-TagAssignment -Tag "Строганов Даниил" -Entity $VMName
       New-TagAssignment -Tag "Test" -Entity $VMName
       New-TagAssignment -Tag "SlowDisk" -Entity $VMName
       New-TagAssignment -Tag "non-backup" -Entity $VM
       New-TagAssignment -Tag "none" -Entity $VMName
       New-TagAssignment -Tag "Постоянно" -Entity $VMName
       Set-VM -VM $VMName -Notes "Владелец: Строганов Даниил `nДата создания: 05.09.2019 `nJIRA: PCG-17399" -Confirm:$False
    }
