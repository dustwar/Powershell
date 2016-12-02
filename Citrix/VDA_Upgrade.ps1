$Receiver = Get-WmiObject -Class Win32_Product `
                     -Filter "Name = 'Citrix Receiver (Enterprise)'"

$Framework =Get-WmiObject -Class Win32_Product `
                     -Filter "Name = 'Microsoft .NET Framework 4.5.1'"

 
#Silent install of .NET Framework 4.5.1 from FS01 APPS
Write-Verbose "Installing .NET Framework 4.5.1..."
\\jmicfs01\sys\apps\microsoft\.netFramework4.5.1\NDP451-KB2858728-x86-x64-AllOS-ENU.exe /q /norestart


#wait 10 minutes for install to finish
Start-Sleep -s 600
Write-Verbose ".NET Framework 4.5.1 in installed!"


#Uninstall Receiver (all Versions)
Write-Verbose "Removing Citrix Receiver...."
$Receiver.Uninstall()

#Wait 5 minutes for Install to finish
Start-Sleep -s 300
Write-Verbose "Citrix Receiver Removed!"


