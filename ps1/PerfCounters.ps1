$title = "Performance Counters"

Header $title

[string]$AccessMethods = (Get-Content .\sql\AccessMethods.sql) -join "`n"
[string]$PageLifeExpectancy = (Get-Content .\sql\PageLifeExpectancy.sql) -join "`n"
[string]$BufferManager = (Get-Content .\sql\BufferManager.sql) -join "`n"
[string]$SqlStatistics = (Get-Content .\sql\SqlStatistics.sql) -join "`n"
[string]$Locks = (Get-Content .\sql\Locks.sql) -join "`n"

[string]$query = $AccessMethods + $PageLifeExpectancy + $BufferManager + $SqlStatistics + $Locks
. .\ps1\00_executeQuery.ps1

$comments = 
"Note these are cumulative counters since the database was started. Should only be used to get a general idea of how the database is operating. These counters would have to be monitored over time to further investigate."
Comments $comments

############################################################################
$htmlOut = "
<br>
<hr>
<br>
<h1>Access Methods</h1>
<br>
"
WriteToHtml $htmlOut
.\ps1\00_TableToHtml.ps1 -tableID 0
$comments = 
"General rule of thumb: <b>Index Searches/sec</b> should be 800-1000 times higher than <b>Full Scans/sec</b>
If <b>Full Scans/sec</b> is too high, check top SQL for missing indexes or too many rows returned due a lack of a good filtering predicate"
Comments $comments

############################################################################
$htmlOut = "
<br>
<hr>
<br>
<h1>Page Life Expectancy (PLE)</h1>
<br>
"
WriteToHtml $htmlOut
.\ps1\00_TableToHtml.ps1 -tableID 1
$comments = 
"<b>Page life expectancy</b> is how long a page remains in the buffer cache (measured in seconds)
General rule of thumb: PLE = server memory / 4GB * 300
<ul><li>Example: SQL Server with 4 GB should have at least 300 PLE</li>
<li>Example: SQL Server with 32 GB should have at least 2400 PLE</li></ul>
Note this rule of thumb is fairly old and probably no longer applies.
PLE should be monitored over time. PLE could be easily affected by maintenance job that flushes buffer cache.
Too low PLE indicates SQL Server needs more memory, though should check if other tuning can be done.
Check <b>Free list stalls/sec</b> and <b>Lazy writes/sec</b> to confirm buffer cache is under memory pressure."
Comments $comments

############################################################################
$htmlOut = "
<br>
<hr>
<br>
<h1>Buffer Manager</h1>
<br>
"
WriteToHtml $htmlOut
.\ps1\00_TableToHtml.ps1 -tableID 2

############################################################################
$htmlOut = "
<br>
<hr>
<br>
<h1>SQL Statistics</h1>
<br>
"
WriteToHtml $htmlOut
.\ps1\00_TableToHtml.ps1 -tableID 3
$comments = 
"<b>SQL Compilations/sec</b> should be 10% or less of <b>Batch Requests/sec</b> as a general rule of thumb
<b>SQL Re-Compilations/sec</b> should be 10% or less of <b>SQL Compilations/sec</b> as a general rule of thumb"
Comments $comments

############################################################################
$htmlOut = "
<br>
<hr>
<br>
<h1>Locks</h1>
<br>
"
WriteToHtml $htmlOut
.\ps1\00_TableToHtml.ps1 -tableID 4
$comments = 
"<b>Lock Timeouts/sec</b> should be 0 and <b>Lock Wait Time (ms)</b> should be very low. If not this could indicate excessive blocking. Investigate top SQL and review ActiveSql.html in this report.
<b>Number of Deadlocks/sec</b> should be 0."
Comments $comments

Footer
