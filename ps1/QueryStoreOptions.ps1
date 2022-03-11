$title = "Query Store Options"

Header $title -lineBreak $true

[string]$QueryStoreOptions = (Get-Content .\sql\QueryStoreOptions.sql) -join "`n"
[string]$QueryStoreRuntimeStats = (Get-Content .\sql\QueryStoreRuntimeStats.sql) -join "`n"

[string]$query = $QueryStoreOptions + $QueryStoreRuntimeStats
. .\ps1\00_executeQuery.ps1

.\ps1\00_TableToHtml.ps1 -tableID 0 -TableOrList list

$comments = 
"<b>desired_state_desc</b> and <b>actual_state_desc</b> should be <b>READ_WRITE</b> (disabled by default for new databases). 
If not enabled, check <b>readonly_reason</b> and verify <b>max_storage_size_mb</b> is not too low. 

To enable query store and set recommended configuration:
<i>ALTER DATABASE CURRENT SET QUERY_STORE = ON;</i>
<i>ALTER DATABASE CURRENT SET QUERY_STORE (INTERVAL_LENGTH_MINUTES = 15, MAX_STORAGE_SIZE_MB = 2048, QUERY_CAPTURE_MODE = AUTO);</i>
"
Comments $comments

$htmlOut = "
<br>
<hr>
<br>
<h1>sys.query_store_runtime_stats_interval</h1>
<br>
"
WriteToHtml $htmlOut
.\ps1\00_TableToHtml.ps1 -tableID 1

$comments = 
"Report generated with the time frame:
<ul><li>Start Time: <b>$start_time</b></li>
<li>End Time: <b>$end_time</b></li></ul>
"
Comments $comments

Footer
