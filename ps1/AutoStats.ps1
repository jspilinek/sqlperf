$title = "Automatic Statistics"

Header $title

[string]$query = (Get-Content .\sql\AutoStats.sql) -join "`n"
. .\ps1\00_executeQuery.ps1

.\ps1\00_TableToHtml.ps1 -tableID 0 -link $true

$comments = 
"Recommended settings:
<ul><li>AUTO_UPDATE_STATISTICS: ON (default)</li>
<li>AUTO_UPDATE_STATISTICS_ASYNC: ON</li>
<li>AUTO_CREATE_STATISTICS: ON (default)</ul>
Refer to <a href='https://www.ptc.com/en/support/article?n=CS314985'>Enable AUTO_UPDATE_STATISTICS_ASYNC in SQL Server for Windchill PDMLink</a>
Enable AUTO_UPDATE_STATISTICS_ASYNC with:
<b>ALTER DATABASE CURRENT SET AUTO_UPDATE_STATISTICS_ASYNC ON;</b>"
Comments $comments

Footer
