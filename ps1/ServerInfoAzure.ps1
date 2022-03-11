$title = "Server Information"

Header $title

[string]$ServerInfo = (Get-Content .\sql\ServerInfo.sql) -join "`n"
[string]$NumaNodes = (Get-Content .\sql\NumaNodes.sql) -join "`n"
[string]$AzureProperties = (Get-Content .\sql\AzureProperties.sql) -join "`n"

[string]$query = $ServerInfo + $NumaNodes + $AzureProperties
. .\ps1\00_executeQuery.ps1

.\ps1\00_TableToHtml.ps1 -tableID 0

$htmlOut = "
<br>
<hr>
<br>
<h1>NUMA Nodes (sys.dm_os_nodes)</h1>
<br>
"
WriteToHtml $htmlOut
.\ps1\00_TableToHtml.ps1 -tableID 1

$comments = 
"If NUMA is not present, there will be one memory node: node_id 0
node_id 64 is reserved for ONLINE_DAC (Dedicated Administrator Connection)"
Comments $comments

$htmlOut = "
<br>
<hr>
<br>
<h1>Azure Properties</h1>
<br>
"
WriteToHtml $htmlOut
.\ps1\00_TableToHtml.ps1 -tableID 2

Footer
