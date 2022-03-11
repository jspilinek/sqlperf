$title = "Buffer Pool Extension"

Header $title

[string]$BPE = (Get-Content .\sql\BPE.sql) -join "`n"
[string]$BPEUsage = (Get-Content .\sql\BPEUsage.sql) -join "`n"

[string]$query = $BPE + $BPEUsage
. .\ps1\00_executeQuery.ps1

.\ps1\00_TableToHtml.ps1 -tableID 0
$comments = 
"BPE was introduced in SQL Server 2014. I haven't seen any customers using this."
Comments $comments

$htmlOut = "
<br>
<hr>
<br>
<h1>Buffer Pool Extension Usage</h1>
<br>
"
WriteToHtml $htmlOut
.\ps1\00_TableToHtml.ps1 -tableID 1

Footer
