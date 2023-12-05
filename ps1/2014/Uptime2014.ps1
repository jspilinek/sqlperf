$title = "Uptime"

Header $title

[string]$query = (Get-Content .\sql\2014\Uptime.sql) -join "`n"
. .\ps1\00_executeQuery.ps1

.\ps1\00_TableToHtml.ps1 -tableID 0

$comments = 
"How long the database has been running. Anything less than 30-60 minutes is probably not enough to make changes against (unless Query Store is available). 
Some DMVs are cumulative since the start of the database and may not be reliable if the database has been up for weeks."
Comments $comments

Footer
