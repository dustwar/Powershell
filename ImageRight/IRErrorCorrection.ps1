###########################################
#Variables for emailing failed imports
###########################################
$EmailFrom = "noreply@jminsure.com"  
$EmailTo = "dwarner@jminsure.com"
$EmailBody = "Here are the documents that we couldn't find a place for."
$EmailSubject = "PL imports"
$SMTPServer = "OWA.JMINSURE.com"

#############################################
#Variables used to identify import errors.
############################################
$Path = "\\JMPIMG02\C$\imports\PLXML\errors"
$IRError = "Import file not found"
$ErrorDirs = @()
$GoodIndexs = @()
$BadIndexs = @()

##################################################################################
# This code snippet gets all the Errors with error type $IRError in location $Path.
##################################################################################
Get-ChildItem $Path -include *_err.txt -Recurse | 
   Where-Object { $_.Attributes -ne "Directory"} | 
      ForEach-Object { 
         If (Get-Content $_.FullName | Select-String -Pattern $IRError) {
            $ErrorDirs += $_.Directory.Fullname 
           
         }
      }
########################################################################################################
#This code snippet selects all non error files from the array above, and moves them to import folder
########################################################################################################
ForEach ($ErrorDir in $ErrorDirs) {$GoodIndex = Get-ChildItem $errordir -Exclude *_err.txt | 
     Where-Object {($_.Attributes -ne "Directory") -and ($_.FullName -notmatch "_")} 
     If ($GoodIndex -ne $null) { 
        write-host "$GoodIndex Good!"
        }
     # Move-Item C:\imports\plxml\
      
}
####################################################################################################################
#This code snippet selects all non-imported documents and emails them to be manually imported and mails them to PL
####################################################################################################################
ForEach ($ErrorDir in $ErrorDirs) {$BadIndex = Get-ChildItem $errordir -Exclude *_err.txt | 
     Where-Object {($_.Attributes -ne "Directory") -and ($_.FullName -match "_")} 
     If ($Badindex -ne $null) { 
        write-host "$BadIndex BAD!!"
		# send-mailmessage -SmtpServer $SMTPServer -From $EmailFrom -to $EmailTo -Subject $EmailSubject -Body $EmailBody -Attachments $BadIndexs
				}

}
