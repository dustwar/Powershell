# Calculate the UTC time 365 days ago, in FileTime (Integer) format and convert it to a string

$LLTSlimit = (Get-Date).AddDays(-365).ToFileTimeUTC().ToString()

# Create the LDAP filter for the AD query

# Searching for enabled computer accounts which have lastLogonTimestamp older than 60 days

$LDAPFilter = "(&(objectCategory=Computer)(lastlogontimestamp<=$LLTSlimit) (!(userAccountControl:1.2.840.113556.1.4.803:=2)))"

# Create an ADSI Searcher to query AD

$Searcher = new-object DirectoryServices.DirectorySearcher([ADSI]"")

$Searcher.filter = $LDAPFilter

# Execute the query

$Accounts = $Searcher.FindAll()

# Process the results

If ($Accounts.Count –gt 0) {

# Create an array to store all the results

$Results = @()

# Loop through each account

ForEach ($Account in $Accounts) {

# Create an object to store this account in

$Result = "" | Select-Object Name,ADSPath,lastLogonTimestamp

# Add the name to the object as a string

$Result.Name = [String]$Account.Properties.name

# Add the ADSPath to the object as a string

$Result.ADSPath = [String]$Account.Properties.adspath

# Add the lastLogonTimestamp to the object as a readable date

$Result.lastLogonTimestamp = `

[DateTime]::FromFileTime([Int64]::Parse($Account.Properties.lastlogontimestamp))

# Add this object to our array

$Results = $Results + $Result

}

}

# Output the results

$Results | Format-Table -autosize
$Results | Out-File C:\StalePCreport.txt
