##################################
# Set the UserName for Termination
##################################
$User = "nsommertest"

##########################################################################
#Gets all Active Directory properties for both Manager and Terminated User.
##########################################################################
$Manager = (get-aduser (get-aduser $User -Properties manager).manager).samaccountName
$UserInfo = Get-ADUser $user -Properties *
$ManagerInfo = Get-ADUser $Manager -Properties *
$UserDisplayName = $UserInfo.DisplayName
$ManagerDisplayName = $ManagerInfo.DisplayName
[string]$UserFolder = $UserInfo.HomeDirectory
[string]$ManFolder = $ManagerInfo.HomeDirectory





$LogFilePath = "C:\user_" + $User + ".txt"

$Groups = $UserInfo.memberOf |ForEach-Object {
    Get-ADGroup $_ 
} 
$Groups | Out-File $LogFilePath -Append

$Groups | ForEach-Object { Remove-ADGroupMember -Identity $_ -Members $User -Confirm:$false }

#| Out-File $LogFilePath -InputObject ($Userinfo.memberOf) -Encoding utf8
