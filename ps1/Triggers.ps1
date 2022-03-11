$title = "Triggers"

Header $title

[string]$query = (Get-Content .\sql\Triggers.sql) -join "`n"
. .\ps1\00_executeQuery.ps1

.\ps1\00_TableToHtml.ps1 -tableID 0

$comments = 
"Used when tuning SQL involving triggers. Generally ignorable. Used for advanced analysis."
Comments $comments

Footer
