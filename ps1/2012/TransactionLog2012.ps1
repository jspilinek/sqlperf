$title = "Transaction Log Usage"

Header $title

[string]$TransactionLog = (Get-Content .\sql\TransactionLog.sql) -join "`n"
[string]$LogSpace = (Get-Content .\sql\2012\LogSpace.sql) -join "`n"

[string]$query = $TransactionLog + $LogSpace
. .\ps1\00_executeQuery.ps1

.\ps1\00_TableToHtml.ps1 -tableID 0

$htmlOut = "
<br>
<hr>
<br>
<h1>Log Space Usage</h1>
<br>
"
WriteToHtml $htmlOut
.\ps1\00_TableToHtml.ps1 -tableID 1

Footer
