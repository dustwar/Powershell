#################################
#Deploy VM from Template
#################################
 
###############################
#Load PowerCLI Modules
###############################
Get-Module *vmware* -ListAvailable | Import-Module
 
###########################################
#Load Assembly
###########################################
Add-Type -AssemblyName Microsoft.VisualBasic
 
 
################################
#Variables
################################
$vCenter = "jmpvcr02.jewelersnt.local"
$TemplateName = "Win7-Standard-Template"
$CustomizationName = "Win7 Test"
$VMName = [string] [Microsoft.VisualBasic.Interaction]::InputBox("Please provide the VM name")
$DSCName = "CMP4020_Cluster"
$VMHost = "JMPVMW85.jewelersnt.local"
$VLAN = "dv-vlan20"
$Notes = [string] [Microsoft.VisualBasic.Interaction]::InputBox("List the owner of the VM")
 
###########################
#Connect to vCenter
###########################
 
  try {
    Write-debug "Connecting to vCenter, please wait.."
    Connect-ViServer -server $vCenter -Force | Out-Null
    if ($? -eq $false) {throw $error[0].exception}
               
                ##############################################
                #Variables needed after connecting to vCenter
                ##############################################
                $DSC = Get-DatastoreCluster -Name $dscName
 
 
    ###################################################
    #Deploys VM using customization, and powers on VM
    ###################################################
    New-VM -Name $VMName -Host $VMHost -Template $TemplateName -OSCustomizationSpec $CustomizationName -Datastore $DSC | Start-VM -RunAsync
 
    #################################################
    #Change vlan for Persistent VMs
    ##################################################
    Get-NetworkAdapter -VM $VMName | Set-NetworkAdapter -PortGroup $VLAN -Confirm:$false
 
  }
  catch [Exception]{
    $status = 1
    $exception = $_.Exception
    Write-debug "Could not connect to vCenter"
  }
 
 
######################################
#Move VM to correct OU
######################################
do{
While(-Not(Get-ADComputer -Ldapfilter "(name=$VMName)")) { Start-Sleep -Seconds 5 }
 
}
until(Get-ADComputer -Ldapfilter "(name=$VMName)" )
Write-host 'computer moved to correct OU'
$TargetPath = 'OU=XenDesktop 01ab controllers,OU=XD7,OU=Xendesktop,DC=jewelersnt,DC=local'
Get-ADComputer -Ldapfilter "(name=$VMName)" | Move-ADObject -TargetPath $TargetPath
 
####################
#Set VM description
####################
Set-VM $VMName -description "$Notes" -Confirm:$false