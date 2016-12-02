###################################
###################################
##Imageright Build Cleanup Script##
###################################
###################################

########################
#computer name variables
########################
[string]$OldName="JMDIMG99"
$NewName=$env:COMPUTERNAME

##################################################
#IR File and folder location variables and arrays
##################################################
[string]$IRServiceConfigfile = "c:\Program Files (x86)\Imageright\Services\imageright.service.exe.config"
[string]$IRServiceFld= 'C:\Program Files (x86)\imageright\Services'
[string]$IRClientFld= 'C:\Program Files (x86)\Imageright\Clients'
[string]$IRCLShare = "F:\Imports\CLXML"
[string]$IRPLShare = "F:\Imports\PLXML"
[string]$ImagesShare = "F:\Images"
[string]$ImagewrtShare= "F:\Imagewrt"
[string]$InstallFile = "F:\Imagewrt\installs\Settings.ini"
$IRServiceFiles=@()
$IRClientFiles=@()

######################
#IR string variables
######################
[string]$oldDBName="Imageright5"
[string]$newDBName="Imageright"
[string]$oldDataSource="dbImageRight_QA5"
[string]$newDataSource="dbaImageRight_Dev"

##############################
#Stop all Imageright Services
##############################
Get-Service -DisplayName "Imageright *" | Stop-Service -Verbose


#####################################################
#Changing dbConnectionString to match new environment
#####################################################
(Get-Content $IRserviceConfigfile) | ForEach-Object {$_ -replace $oldDBName, $newDBName} | Set-Content $IRserviceConfigfile
Write-Verbose -Message "replacing database name text $oldDBName from $IRServiceConfigFile with $NewDBName" -Verbose
(Get-Content $IRserviceConfigfile) | ForEach-Object {$_ -replace $oldDataSource, $newDataSource} | Set-Content $IRserviceConfigfile
Write-Verbose -Message "replacing data source text $oldDataScource from $IRServiceConfigFile with $newDataSource" -Verbose

###################################################
#Changing all config files to match new environment
###################################################

	###########################################
	#Changing config files under Service folder
	###########################################
	$IRServiceFiles = Get-ChildItem $IRserviceFld *.config -Recurse | select -ExpandProperty fullname 
	 foreach ($IRfile in $IRServiceFiles) {
	    
	      (Get-Content $IRfile) | ForEach-Object {$_ -replace $oldName, $newName} | Set-Content $IRfile
		  Write-Verbose "Removed all text of $oldName in $IRFile with $newName" -Verbose
		
	    } 
		
	############################################		
	#Changing config files under Client folder
	############################################
	$IRClientFiles = Get-ChildItem $IRClientFld *.config -Recurse | select -ExpandProperty fullname 
	 foreach ($IRfile in $IRClientFiles) {
	    
	      (Get-Content $IRfile) | ForEach-Object {$_ -replace $oldName, $newName} | Set-Content $IRfile
		  Write-Verbose "Removed all text of $oldName in $IRFile with $newName" -Verbose

	    } 

#####################################
#CL Import Folder and Share Creation
#####################################
Write-Verbose -Message "Creating $IRCLShare Share" -Verbose
$Fldexist = Test-Path $IRCLShare
If ($FldExist -eq $false){
    New-Item $IRCLShare -Type directory}
New-SmbShare -Name imp-cl_xml$ -Path $IRCLShare -FullAccess everyone

######################################
#PL Import Folder and Share Creation
######################################
Write-Verbose -Message "Creating $IRPLShare Share" -Verbose
$Fldexist = Test-Path $IRPLShare
If ($FldExist -eq $false){
    New-Item $IRPLShare -Type directory}
New-SmbShare -Name imp-pl_xml$ -Path $IRPLShare -FullAccess everyone

####################################
#Create Images Folder and Share
####################################
Write-Verbose -Message "Creating $ImagesShare Share" -Verbose
$Fldexist = Test-Path $ImagesShare
If ($FldExist -eq $false){
    New-Item $ImagesShare -Type directory}
New-SmbShare -Name Images$ -Path $ImagesShare -FullAccess everyone

##################################################################
#Create Imagewrt folder, copy content from Prod, and create share
##################################################################
Write-Verbose -Message "Creating $ImagewrtShare Share" -Verbose
$Fldexist = Test-Path $ImagewrtShare
If ($FldExist -eq $false){
    New-Item $ImagewrtShare -Type directory}
New-SmbShare -Name Imagewrt$ -Path $ImagewrtShare -FullAccess everyone
Write-Verbose -message "Copying install directory from \\jmpimg01\imagewrt\install5"
Copy-Item \\jmpimg01\imagewrt\install5\* $ImagewrtShare -Verbose
Copy-Item \\jmpimg01\imagewrt\install5\installs\* F:\Imagewrt\installs -Verbose
Copy-Item \\jmpimg01\imagewrt\install5\installs\OutlookPlugin\* F:\Imagewrt\installs\OutlookPlugin -Verbose
Copy-Item "\\jmpimg01\imagewrt\install5\installs\3rd party\*" 'F:\Imagewrt\installs\3rd Party' -Verbose
Write-Verbose -Message "Replacing JMPIMG01 with $NewName in $InstallFile" -Verbose
(Get-Content $InstallFile) | ForEach-Object {$_ -replace "JMPIMG01", $NewName} | Set-Content $InstallFile
Write-Verbose -Message "Replacing JMPIMG02 with $NewName in $InstallFile" -Verbose
(Get-Content $InstallFile) | ForEach-Object {$_ -replace "JMPIMG02", $NewName} | Set-Content $InstallFile