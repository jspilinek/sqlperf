$title = "Stale Statistics"

Header $title

[string]$query = (Get-Content .\sql\StaleStats.sql) -join "`n"
. .\ps1\00_executeQuery.ps1

.\ps1\00_TableToHtml.ps1 -tableID 0

$comments = 
"Statistics with (stat rows / table rows) < 10%
This can be an indicator that stats are stale and need to be updated."
Comments $comments

Footer
