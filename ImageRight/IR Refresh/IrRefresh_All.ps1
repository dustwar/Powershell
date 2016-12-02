#--------------------------------------
# PL Import folder variables
$PL_NDX="C:\imports\plxml\backupNDX\*"
$PL_WDX="C:\imports\plxml\backupWDX\*"
$PL_Errors="C:\imports\plxml\errors\*"
$PL_Temp="C:\imports\plxml\errors\*"
#--------------------------------------
# CL Import folder variables
$CL_LDX="C:\imports\clxml\backupLDX\*"
$CL_NDX="C:\imports\clxml\backupNDX\*"
$CL_Errors="C:\imports\clxml\errors\*"
$CL_Temp="C:\imports\clxml\errors\*"
#--------------------------------------

$servers = @("JMPIMG03", "JMTTRN02", "JMDIMG01", "JMTIMG01", "JMTIMG02")

Foreach ($server in $servers)

{

#Stop all Imageright services	
    Write-Host "Stopping Imageright Services for $server"
    Get-Service -DisplayName imageright* | Stop-Service 
    Write-Host 

    if ($server -eq "JMTIMG01")
        {
          
        
        #Pause for DBAs to Apply Gold Image	
	        Write-Host "After Gold Image has been applied ..."
	        Write-Host "Press any key to continue..."
	        $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
	        Write-Host

        # Removes all old data from Primary storage location
	        Write-Host
	        Remove-Item “F:\images\*” -Force -Recurse -ErrorAction SilentlyContinue
	        Write-Host "Removed all old data from Primary Storage Location on $server"
        }

    elseif ($server -eq "JMTIMG02")
        {
        
        #----------------------------------
        #Pause for DBAs to Apply Gold Image	
        #----------------------------------
	        Write-Host "After Gold Image has been applied ..."
	        Write-Host "Press any key to continue..."
	        $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
	        Write-Host
        #----------------------------------------------------------------------------------------
        # Removes only files from PLXML except for backupNDX, backupWDX, Errors, and Temp Folders
        #----------------------------------------------------------------------------------------
	        Write-Host
	        Remove-Item “C:\imports\plxml\*” -Exclude backupNDX, backupWDX, Errors, Temp -Force -Recurse -ErrorAction SilentlyContinue 
	        Remove-Item $PL_NDX, $PL_WDX, $PL_Errors, $PL_Temp -Force -Recurse -ErrorAction SilentlyContinue 
	        Write-Host "Removed all old data on $server from PLXML except for backupNDX, backupWDX, Errors, and Temp Folders"
	
        #------------------------------------------------------------------------------------------
        # Removes all old data from CLXML except for BackupLDX, BackupNDX, Errors, and Temp folders
        #------------------------------------------------------------------------------------------
	        Write-Host
	        Remove-Item “C:\imports\clxml\*” -Exclude backupLDX, backupNDX, Errors, Temp -Force -Recurse -ErrorAction SilentlyContinue 
	        Remove-Item $CL_LDX, $CL_NDX, $CL_Errors, $CL_Temp -Force -Recurse -ErrorAction SilentlyContinue 
	        Write-Host "Removed all old data on $server from CLXML except for backupNDX, backupWDX, Errors, and Temp Folders"
        #-------------------------
        # Pause to reconfigure EMC
        #-------------------------	
	        Write-Host
	        Write-Host "Primary Device Storage and Import folders on $server are clean..."
	        Write-Host "Press any key to reset Cold Import in EMC..."
	        $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
	        Write-Host

        
        }

    else 
        {
        
        #Pause for DBAs to Apply Gold Image	
	        Write-Host "After Gold Image has been applied to $server ..."
	        Write-Host "Press any key to continue..."
	        $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
	        Write-Host

        # Removes all old data from Primary storage location
	        Write-Host
	        Remove-Item “F:\images\*” -Force -Recurse -ErrorAction SilentlyContinue
	        Write-Host "Removed all old data from Primary Storage Location on $server"

        # Removes only files from PLXML except for backupNDX, backupWDX, Errors, and Temp Folders
	        Write-Host
	        Remove-Item “C:\imports\plxml\*” -Exclude backupNDX, backupWDX, Errors, Temp -Force -Recurse -ErrorAction SilentlyContinue 
	        Remove-Item $PL_NDX, $PL_WDX, $PL_Errors, $PL_Temp -Force -Recurse -ErrorAction SilentlyContinue 
	        Write-Host "Removed all old data on $server from PLXML except for backupNDX, backupWDX, Errors, and Temp Folders"
	

        # Removes all old data from CLXML except for BackupLDX, BackupNDX, Errors, and Temp folders
	        Write-Host
	        Remove-Item “C:\imports\clxml\*” -Exclude backupLDX, backupNDX, Errors, Temp -Force -Recurse -ErrorAction SilentlyContinue 
	        Remove-Item $CL_LDX, $CL_NDX, $CL_Errors, $CL_Temp -Force -Recurse -ErrorAction SilentlyContinue 
	        Write-Host "Removed all old data on $server from CLXML except for backupNDX, backupWDX, Errors, and Temp Folders"

        # Pause to reconfigure EMC	
	        Write-Host
	        Write-Host "Primary Device Storage and Import folders on $server are clean..."
	        Write-Host "Press any key to reset Cold Import in EMC..."
	        $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
	        Write-Host

        #
        # Verifies CL_Cold Universal - Legacy (LDX Filetypes) are importing correctly.
        #
	        Write-Host "Press any key to test CL_Cold Universal - Legacy (LDX) ..."
	        $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
	        Write-Host
	        $folder = Get-ChildItem '\\jmpimg02\imp-cl_xml$\BackupLDX'| Where { $_.PSIsContainer } | sort CreationTime -desc | select -f 1
	        $path ="\\jmpimg02\imp-cl_xml$\BackupLDX\$folder\1\"
	        Copy-Item $path\*.* -Exclude *_log.txt -Destination \\$server\imp-cl_xml$\ 
	        Write-Host "We used $Path to verify CL_Cold Universal - Legacy (LDX) on $server"
	        Write-host
	        Write-host
        #
        # Verifies CL_Cold Universal - Native (NDX Filetypes) are importing correctly.
        #
	        Write-Host "Press any key to test CL_Cold Universal - Native (NDX) ..."
	        $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
	        Write-Host
	        $folder = Get-ChildItem '\\jmpimg02\imp-cl_xml$\BackupNDX'| Where { $_.PSIsContainer } | sort CreationTime -desc | select -f 1
	        $path ="\\jmpimg02\imp-cl_xml$\BackupNDX\$folder\1\"
	        Copy-Item $path\*.* -Exclude *_log.txt -Destination \\$server\imp-cl_xml$\ 
	        Write-Host "We used $Path to verify CL_Universal - Native (NDX) on $server"
	        Write-host
	        Write-host
        #
        # Verifies PL_Cold Universal - Native (NDX Filetypes) are importing correctly.
        #
	        Write-Host "Press any key to test PL_Cold Universal - Native (NDX) ..."
	        $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
	        Write-Host
	        $folder = Get-ChildItem '\\jmpimg02\imp-Pl_xml$\BackupNDX'| Where { $_.PSIsContainer } | sort CreationTime -desc | select -f 1
	        $path ="\\jmpimg02\imp-pl_xml$\BackupNDX\$folder\1\"
	        Copy-Item $path\*.* -Exclude *_log.txt -Destination \\$server\imp-pl_xml$\ 
	        Write-Host "We used $Path to verify PL_Cold universal - Native (NDX) on $server"
	        Write-host
	        Write-host
	
        #
        # Verifies PL_Cold Universal Web - Native (WDX Filetypes) are importing correctly.
        #
	        Write-Host "Press any key to test PL_Cold Universal - Web (WDX) ..."
	        $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
	        Write-Host
	        $folder = Get-ChildItem '\\jmpimg02\imp-Pl_xml$\BackupWDX'| Where { $_.PSIsContainer } | sort CreationTime -desc | select -f 1
	        $path ="\\jmpimg02\imp-pl_xml$\BackupWDX\$folder\1\"
	        Copy-Item $path\*.* -Exclude *_log.txt -Destination \\$server\imp-pl_xml$\ 
	        Write-Host "We used $Path to verify PL_Cold Universal - Web (WDX) on $server"
	        Write-host
	        Write-host
        }


}






