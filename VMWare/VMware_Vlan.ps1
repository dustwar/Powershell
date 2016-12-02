# VCenter you are connecting too
$vcserver = "jmpvcr02.jewelersnt.local"
# Loop to make changes to Network Adapter from List of Servers that needs to be changed
$serverlist = Get-Content "C:\vms.txt"
ForEach ($server in $serverlist)
{
$NIC = Get-NetworkAdapter -VM $server
Set-NetworkAdapter -NetworkAdapter $NIC -Portgroup "dv-vlan20" -confirm:$false
} 
