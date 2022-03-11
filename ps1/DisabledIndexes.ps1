$title = "Disabled Indexes"

Header $title

[string]$query = (Get-Content .\sql\DisabledIndexes.sql) -join "`n"
. .\ps1\00_executeQuery.ps1

.\ps1\00_TableToHtml.ps1 -tableID 0

$comments = 
"Quick way to check if out-of-the-box indexes were disabled."
Comments $comments

Footer
