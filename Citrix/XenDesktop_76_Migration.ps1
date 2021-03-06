$NewDelivery = "Converted Staff"

Get-BrokerDesktop -SessionState $Null -HostedMachineName "XD*"  | select -ExpandProperty  hostedmachinename | Out-File C:\vms.txt

Foreach ($VM in $VMs) {
	#Turn on Maintaince Mode to prvent users from logging in during migration.
	Get-brokerMachine -MachineName Jewelersnt\$VM | Set-BrokerPrivateDesktop -InMaintenanceMode $true
	Write-Verbose "Maintenance Mode turned on for $VM"
	
	
	#Gets the current Delivery group.
	$OldDelivery = Get-brokerMachine -MachineName Jewelersnt\$VM | Select DesktopGroupName
	Write-Verbose "$VM is currently a part of the $OldDelivery Delivery Group."
	
	#Remove VM from Current Delivery Group.
	Get-BrokerMachine -MachineName Jewelersnt\$VM | Remove-BrokerMachine $OldDelivery
	Write-Verbose "$VM is Removed from $OldDelivery"
	
	#Add VM from to the New Delivery Group.
	Get-BrokerMachine -MachineName Jewelersnt\$VM | Add-BrokerMachine $NewDelivery
	Write-Verbose "$VM is assigned to $NewDelivery Delivery Group"
	
	#Silent install of .NET Framework 4.5.1 from FS01 APPS
	Start-Process \\jmicfs01\sys\apps\microsoft\.netFramework4.5.1\NDP451-KB2858728-x86-x64-AllOS-ENU.exe /q /norestart -Wait
	Write-Verbose "Installing .NET Framework 4.5.1 on $VM"
	
	
	# wait 10 minutes for install to finish
	# Start-Sleep -s 600
	# Write-Verbose ".NET Framework 4.5.1 in installed on $VM!"

    # Uninstall Citrix Receiver using Citrix Cleanup Utility
    Start-Process "\\Jmicfs01\TSOAPPS\Citrix\Clients\ReceiverCleanupUtility.exe /silent" -Wait

    #Restart Remote VM and wait 5 minutes until Powershell is available befor continuing.
    Restart-Computer -ComputerName $VM -Wait -For PowerShell -Timeout 300 -Delay

    #Install Receiver
    Start-Process "\\jmicfs01\TSOAPPS\Citrix\Clients\Receiver 4.2\CitrixReceiver.exe /silent /includeSSON" -Wait


    Start-Process "\\jmicfs01\TSOAPPS\VMware\tools\9.4.10\setup64.exe /S /V /qn REBOOT=R ADDLOCAL=ALL REMOVE=SVGA" -Wait


	}