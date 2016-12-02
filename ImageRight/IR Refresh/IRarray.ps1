$servers = @("JMPIMG03", "JMTTRN02", "JMDIMG01", "JMTIMG01", "JMTIMG02")

Foreach ($server in $servers)
{
    if ($server -eq "JMTIMG01")
        {
            Write-Host "I'm $server"
            Invoke-Command -ScriptBlock {Get-Service -DisplayName Imageright*  | Where {$_.Status -eq 'Running'} } -ComputerName $server  
            Write-Host
            Write-Host    
        }

    elseif ($server -eq "JMTIMG02")
        {
            Write-Host "I'm $server"
            Invoke-Command -ScriptBlock {Get-Service -DisplayName Imageright*  | Where {$_.Status -eq 'Running'} } -ComputerName $server  
            Write-Host
            Write-Host    
        }

    else 
        {
            Write-Host "I'm $server"
            Invoke-Command -ScriptBlock {Get-Service -DisplayName M*| where {$_.Status -eq 'Running'} } -ComputerName $server
            Write-Host
            Write-Host
        }


}