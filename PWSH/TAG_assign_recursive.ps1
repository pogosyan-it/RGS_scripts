#!/usr/bin/pwsh -Command
##########################
# PowerCLI to create VMs #
# Version 1.0            #
##########################

#Connect-VIServer -Server vcenter.rgs.ru -Protocol https -User 'rgs.ru\ERPogosyan' -Password '2Me32jvppn'

foreach($VM in Get-Content .\VM_list_for_TAG.txt) 
    {
           Get-VM $VM | New-TagAssignment -Tag "ITSM"
           Get-VM $VM | New-TagAssignment -Tag "Суслов Андрей"
           Get-VM $VM | New-TagAssignment -Tag "SlowDisk"
           Get-VM $VM | New-TagAssignment -Tag "non-backup"
           Get-VM $VM | New-TagAssignment -Tag "none"
           Get-VM $VM | New-TagAssignment -Tag "Постоянно"
           Set-VM -VM $VM -Notes "Суслов Андрей Владимирович  `nДата создания: 07.05.2020 `nJIRA: ITSM-667" -Confirm:$False
           $VM
   }           



