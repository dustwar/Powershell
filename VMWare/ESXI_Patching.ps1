################################
#Variables
################################
$vcenter = "jmpvcr01.jewelersnt.local"
$VMHost = "jmdvmw01.jewelersnt.local"

##########################################
# Connect to vCenter and select all hosts
##########################################
Connect-VIServer $vcenter

#####################################
#Scanning host and collect baselines
#####################################
Write-Verbose "$VMhost is preparing to scan" -Verbose
$Baseline = @()
$Baseline = Get-VMHost -Name $VMHost | Get-Baseline -Inherit 


#################################
#Putting host in Maintenance Mode
#################################
Write-Verbose "$VMhost is going into Maintenance Mode" -Verbose
Get-VMHost -Name $VMHOST | Set-VMHost -State Maintenance -confirm:$false

###################################
#Remidates all inherited baselines
###################################
foreach ($attached in $Baseline){
    $BaselineName = $attached.Name
    Write-Verbose "Remidating $Baselinename Baseline on $VMHost" -verbose
    $task = Remediate-Inventory -entity $VMHOST -Baseline $attached -confirm:$false -RunAsync
    Wait-Task -Task $task
    }
########################
#Verifies compliance
########################
$Status = Get-Compliance -Entity $VMHost -ComplianceStatus NotCompliant
if (([array]($statuses)).Count -gt 0){
    Scan-Inventory -Entity $VMHost
    Write-Verbose "$VMHost is not Compliant.  Scanning again and leaving in Maintenance Mode." -Verbose   
 }

###############################
#Removes from Maintenance Mode
###############################
elseif (([array]($statuses)).count -eq 0){
    Write-Verbose "Removing Maintenance Mode on $VMHost" -Verbose
    Get-VMHost -Name $VMHost | Set-VMHost -State Connected
    Write-Verbose "$VMHost is Compliant and working." -Verbose
}