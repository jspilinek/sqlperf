$title = "Scalability Info"

Header $title -newColumn $true

[string]$ScalabilityInfo = (Get-Content .\sql\ScalabilityInfo.sql) -join "`n"
[string]$SignalWaits = (Get-Content .\sql\SignalWaits.sql) -join "`n"

[string]$query = $ScalabilityInfo + $SignalWaits
. .\ps1\00_executeQuery.ps1

.\ps1\00_TableToHtml.ps1 -tableID 0
$comments = 
"The difference between <b>CPU Time (sec)</b> and <b>Elapsed Time (sec)</b> is the amount of waiting which occurred and the cost of this wait.
Ideally there would be very little difference between the two numbers but realistically there generally always will be.
Higher elapsed time generally indicates waiting on disk IO (check wait stats to verify).
When the Elapsed time is more than double the CPU time the overhead is significant and needs to be addressed (typically by tuning SQL or adding additional memory).
If the CPU time > Elapsed time this likely indicates a parallelism issue.
<b>Cache Hit Ratio</b> should be 90% or higher."
Comments $comments

$htmlOut = "
<br>
<hr>
<br>
<h1>CPU vs. Resource Waits</h1>
<br>
"
WriteToHtml $htmlOut
.\ps1\00_TableToHtml.ps1 -tableID 1
$comments = 
"High signal wait indicates CPU pressure."
Comments $comments

Footer
