$title = "Azure Wait Stats"

Header $title -newColumn $true

[string]$query = (Get-Content .\sql\AzureWaitStats.sql) -join "`n"
. .\ps1\00_executeQuery.ps1

.\ps1\00_TableToHtml.ps1 -tableID 0 -link $true

$comments = 
"This page gives an idea on the type of problems that may be occurring in SQL Server. 
Counters are reset to zero any time the database is moved or taken offline.
These statistics are not persisted across SQL Database failover events, and all data are cumulative since the last time the statistics were reset."
Comments $comments

Footer
