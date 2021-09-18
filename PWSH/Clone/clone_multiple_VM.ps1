#!/usr/bin/pwsh -Command
##########################
# PowerCLI to create VMs #
# Version 1.0            #
##########################

#Connect-VIServer -Server vcenter.rgs.ru -Protocol https -User 'rgs.ru\ERPogosyan' -Password '2Me32jvppn'

$VMNAME = @{"VM_1" = "ktj-gw-tst08-db.rgs.ru"; "VM_2" = "ktj-gw-tst08-app.rgs.ru"; "VM_3" = "gw-uaa-tst08.rgs.ru"; "VM_4" = "gw-hproxy-tst08-1.rgs.ru"; 
            "VM_5" = "gw-hproxy-tst08-2.rgs.ru"; "VM_6" = "ktj-gw-sndbx-db.rgs.ru"; "VM_7" = "ktj-gw-sndbx-app.rgs.ru"; "VM_8" = "gw-sndbx-uaa.rgs.ru"} 

$SourceVM = @{"SourceVM_1" = "ktj-gw-tst05-db.rgs.ru"; "SourceVM_2" = "ktj-gw-tst06-app.rgs.ru"; "SourceVM_3" = "gw-uaa-tst06.rgs.ru"; "SourceVM_4" = "gw-hproxy-tst06-1.rgs.ru"; 
             "SourceVM_5" = "gw-hproxy-tst06-2.rgs.ru"; "SourceVM_6" = "ktj-gw-tst05-db.rgs.ru"; "SourceVM_7" = "ktj-gw-tst06-app.rgs.ru"; "SourceVM_8" = "gw-uaa-tst06.rgs.ru"}

$VMHOST = "esx-ktj-gwpc-dev-02.rgs.ru"
$DataStore="esx-ktj-cluster-gwpc-test-storage-01"

for ($i = 1; $i -le $VMNAME.Count; $i++)

  { 
       $VM = New-VM -Name $VMNAME["VM_$i"] -VM $SourceVM["SourceVM_$i"] -VMHost $VMHOST -Datastore $DataStore
       New-TagAssignment -Tag "PCG" -Entity $VMNAME["VM_$i"]
       New-TagAssignment -Tag "Строганов Даниил" -Entity $VMNAME["VM_$i"]
       New-TagAssignment -Tag "Test" -Entity $VMNAME["VM_$i"]
       New-TagAssignment -Tag "FastDisk" -Entity $VMNAME["VM_$i"]
       New-TagAssignment -Tag "non-backup" -Entity $VMNAME["VM_$i"]
       New-TagAssignment -Tag "none" -Entity $VMNAME["VM_$i"]
       New-TagAssignment -Tag "Постоянно" -Entity $VMNAME["VM_$i"]
       Set-VM -VM $VMNAME["VM_$i"] -Notes "Владелец: Строганов Даниил `nДата создания: 06.11.2019 `nJIRA: PCG-20359" -Confirm:$False
   }

