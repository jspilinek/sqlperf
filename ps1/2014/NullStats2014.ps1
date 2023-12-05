$title = "Null Statistics"

Header $title

[string]$query = (Get-Content .\sql\2014\NullStats.sql) -join "`n"
. .\ps1\00_executeQuery.ps1

.\ps1\00_TableToHtml.ps1 -tableID 0

$comments = 
"Statistics with NULL stat rows
This can be normal if the table has zero rows"
Comments $comments

Footer
