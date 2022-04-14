$title = "Queue Entries"

Header $title

[string]$ProcessingQueueEntries = (Get-Content .\sql\QueueEntry.sql) -join "`n"
[string]$ScheduleQueueEntries = (Get-Content .\sql\ScheduleQueueEntry.sql) -join "`n"
$query = $ProcessingQueueEntries + $ScheduleQueueEntries -replace "ENTER_WINDCHILL_SCHEMA","$WindchillSchema"
. .\ps1\00_executeQuery.ps1

$htmlOut = "
<br>
<h1>Processing Queue Entries</h1>
<br>
"
WriteToHtml $htmlOut

.\ps1\00_TableToHtml.ps1 -tableID 0 -link $true

$comments = 
"High numbers of entries in a particular state generally indicate a problem.
Thousands of ready entries may indicate a queue is not processing."
Comments $comments

$htmlOut = "
<br>
<hr>
<br>
<h1>Schedule Queue Entries</h1>
<br>
"
WriteToHtml $htmlOut

.\ps1\00_TableToHtml.ps1 -tableID 1 -link $true

$comments = 
"Schedule queue problems are less common."
Comments $comments

Footer
