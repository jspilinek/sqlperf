$title = "Transient Tables"

Header $title

[string]$query = (Get-Content .\sql\TransientTables.sql) -join "`n"
. .\ps1\00_executeQuery.ps1

.\ps1\00_TableToHtml.ps1 -tableID 0

$comments = 
"Tables that hold transient data and may grow to certain size causing performance problems."
Comments $comments

Footer
