$title = "Tables"

Header $title -text $true -newColumn $true

[string]$query = (Get-Content .\sql\Tables.sql) -join "`n"
. .\ps1\00_executeQuery.ps1

.\ps1\00_TableToHtml.ps1 -tableID 0 -textOutput $true

$comments = 
"Sort by <b>Rows</b> column to determine the largest tables in the database."
Comments $comments

Footer

