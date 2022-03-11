$title = "Error and diagnostic log path"

Header $title

[string]$LogPath = (Get-Content .\sql\LogPath.sql) -join "`n"
[string]$MemoryDumps = (Get-Content .\sql\MemoryDumps.sql) -join "`n"

[string]$query = $LogPath + $MemoryDumps
. .\ps1\00_executeQuery.ps1

.\ps1\00_TableToHtml.ps1 -tableID 0

$htmlOut = "
<br>
<hr>
<br>
<h1>Memory Dumps</h1>
<br>
"
WriteToHtml $htmlOut
.\ps1\00_TableToHtml.ps1 -tableID 1

Footer
