#######################################
#WSUS Report for DR Target Group
########################################

#################################
#WSUS Connection Requirements
#################################
$Computername = 'jmpwus01.jewelersnt.local'
$UseSSL = $True
$Port = 8531

#########################
#WSUS API
#########################
[reflection.assembly]::LoadWithPartialName("Microsoft.UpdateServices.Administration") | out-null
$Wsus = [Microsoft.UpdateServices.Administration.AdminProxy]::GetUpdateServer($Computername,$UseSSL,$Port)

###################
#Reports variables
###################
$ScriptsPath = "C:\Scripts\reports"


######################################################
#Selects Target Group and computers that Need Updates
######################################################

$TargetGroup = 'DR'
$Count=(Get-WsusComputer -ComputerTargetGroups $TargetGroup).count
$updateScope = New-Object Microsoft.UpdateServices.Administration.UpdateScope
$updateScope.IncludedInstallationStates = 'Downloaded','NotInstalled'
($wsus.GetComputerTargetGroups() | Where {
    $_.Name -eq $TargetGroup 
}).GetComputerTargets() | ForEach {
        $Computername = $_.fulldomainname
        $_.GetUpdateInstallationInfoPerUpdate($updateScope) | ForEach {
            $update = $_.GetUpdate()
            [pscustomobject]@{
                Computername = $Computername
                TargetGroup = $TargetGroup
                UpdateTitle = $Update.Title
                Classification = $Update.UpdateClassificationTitle
                IsApproved = $update.IsApproved
            }
    }
###################################################################
#Exports to CSV with Patching Group - Total Machine Count in Title
###################################################################

} | Export-Csv $ScriptsPath\$TargetGroup-$Count.csv -NoTypeInformation