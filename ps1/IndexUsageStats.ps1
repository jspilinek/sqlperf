$title = "Index Usage Stats"

Header $title

[string]$IndexStatsSeeks = (Get-Content .\sql\IndexStatsSeeks.sql) -join "`n"
[string]$IndexStatsScans = (Get-Content .\sql\IndexStatsScans.sql) -join "`n"
[string]$IndexStatsLookups = (Get-Content .\sql\IndexStatsLookups.sql) -join "`n"
[string]$IndexStatsUpdates = (Get-Content .\sql\IndexStatsUpdates.sql) -join "`n"
[string]$IndexStatsRowScans = (Get-Content .\sql\IndexStatsRowScans.sql) -join "`n"
[string]$IndexStatsLockWaits = (Get-Content .\sql\IndexStatsLockWaits.sql) -join "`n"

[string]$query = $IndexStatsSeeks + $IndexStatsScans + $IndexStatsLookups + $IndexStatsUpdates + $IndexStatsRowScans + $IndexStatsLockWaits
. .\ps1\00_executeQuery.ps1

$htmlOut = "
<h1>User Seeks</h1>
<br>
"
WriteToHtml $htmlOut
.\ps1\00_TableToHtml.ps1 -tableID 0
$htmlOut = "
<br>
<hr>
<br>
<h1>User Scans</h1>
<br>
"
WriteToHtml $htmlOut
.\ps1\00_TableToHtml.ps1 -tableID 1
$htmlOut = "
<br>
<hr>
<br>
<h1>User Lookups</h1>
<br>
"
WriteToHtml $htmlOut
.\ps1\00_TableToHtml.ps1 -tableID 2
$htmlOut = "
<br>
<hr>
<br>
<h1>User Updates</h1>
<br>
"
WriteToHtml $htmlOut
.\ps1\00_TableToHtml.ps1 -tableID 3
$htmlOut = "
<br>
<hr>
<br>
<h1>Rows * Scans</h1>
<br>
"
WriteToHtml $htmlOut
.\ps1\00_TableToHtml.ps1 -tableID 4
$htmlOut = "
<br>
<hr>
<br>
<h1>Lock Waits (sys.dm_db_index_operational_stats)</h1>
<br>
"
WriteToHtml $htmlOut
.\ps1\00_TableToHtml.ps1 -tableID 5

Footer
