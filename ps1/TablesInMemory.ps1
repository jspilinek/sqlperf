$title = "Tables In-Memory"

Header $title

[string]$query = (Get-Content .\sql\TablesInMemory.sql) -join "`n"
. .\ps1\00_executeQuery.ps1

.\ps1\00_TableToHtml.ps1 -tableID 0

$comments = 
"In-Memory was introduced in SQL Server 2014.
Check for memory optimized tables that are in-memory."
Comments $comments

Footer
