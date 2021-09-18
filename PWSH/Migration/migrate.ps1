#!/usr/bin/pwsh -Command
##########################
# PowerCLI to create VMs #
# Version 1.0            #
##########################

#VM migration (both compute resources and storage) in cycle from file Local_VM.txt 
# To migrate only resources use following command:  Get-VM -Name $VM | Move-VM -Destination $hostname 
$hostname = "esx-m1-01.rgs.ru"
$datastore = "m1-cluster-01-san-01"

foreach($VM in Get-Content ./Local_VM.txt) 
    {
       #$VMName,$SourceVM,$VMHOST,$DATASTORE = $line.Split(',')
       #$VM = New-VM -Name $VMName -VM $SourceVM -VMHost $VMHOST -Datastore $DATASTORE
       $VM
       Get-VM -Name $VM | Move-VM -Destination $hostname -Datastore $datastore
    }
