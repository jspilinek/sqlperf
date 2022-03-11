$title = "Wait Stats"

Header $title -newColumn $true

[string]$query = (Get-Content .\sql\WaitStats.sql) -join "`n"
. .\ps1\00_executeQuery.ps1

.\ps1\00_TableToHtml.ps1 -tableID 0 -link $true

$comments = 
"This page gives an idea on the type of problems that may be occurring in SQL Server. 
These are aggregated wait times since SQL Server was started, or since the stats were manually reset."
Comments $comments

Footer
