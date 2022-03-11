$title = "Queue Entries"

Header $title

[string]$query = (Get-Content .\sql\QueueEntry.sql) -join "`n"
$query = $query -replace "ENTER_WINDCHILL_SCHEMA","$WindchillSchema"
. .\ps1\00_executeQuery.ps1

.\ps1\00_TableToHtml.ps1 -tableID 0 -link $true

$comments = 
"High numbers of entries in a particular state generally indicate a problem.
Thousands of ready entries may indicate a queue is not processing."
Comments $comments

Footer
