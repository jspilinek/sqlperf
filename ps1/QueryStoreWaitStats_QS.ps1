$title = "Query Store Wait Stats"

Header $title -newColumn $true

[string]$query = (Get-Content .\sql\QueryStoreWaitStats.sql) -join "`n"
. .\ps1\00_executeQuery.ps1

.\ps1\00_TableToHtml.ps1 -tableID 0 -link $true

$comments = 
"This page gives an idea on the type of problems that may be occurring in SQL Server. 
These are aggregated wait times from Query Store over the past 7 days."
Comments $comments

Footer
