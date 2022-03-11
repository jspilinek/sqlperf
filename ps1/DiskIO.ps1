$title = "Disk IO"

Header $title

[string]$DriveLatency = (Get-Content .\sql\DriveLatency.sql) -join "`n"
[string]$FileLatency = (Get-Content .\sql\FileLatency.sql) -join "`n"
[string]$DatabaseIO = (Get-Content .\sql\DatabaseIO.sql) -join "`n"

[string]$query = $DriveLatency + $FileLatency + $DatabaseIO
. .\ps1\00_executeQuery.ps1

$htmlOut = "
<h1>Drive Level Latency</h1>
<br>
"
WriteToHtml $htmlOut
.\ps1\00_TableToHtml.ps1 -tableID 0

$htmlOut = "
<br>
<hr>
<br>
<h1>Latency by File</h1>
<br>
"
WriteToHtml $htmlOut
.\ps1\00_TableToHtml.ps1 -tableID 1

$htmlOut = "
<br>
<hr>
<br>
<h1>IO Usage by Database</h1>
<br>
"
WriteToHtml $htmlOut
.\ps1\00_TableToHtml.ps1 -tableID 2

$comments = 
"Check I/O performance of the system for 'large' delays. Review <b>Read Latency</b>, <b>Write Latency</b>, <b>avg_read_stall_ms</b>, <b>avg_write_stall_ms</b> and <b>avg_io_stall_ms</b> columns. 
Ideally there should be single digit values (< 10 ms).
Note this information becomes less reliable when the database has been up for days or weeks. 
In order to confirm a DiskIO issue could use PerfMon
When there are 2 digit or larger entries, then suspect an I/O problem.
When there are 3 digit or larger entries, then suspect a serious I/O problem."
Comments $comments

Footer
