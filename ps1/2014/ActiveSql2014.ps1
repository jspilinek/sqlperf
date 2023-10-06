$title = "Active SQL"

Header $title -newColumn $true

[string]$ActiveRequests = Get-Content .\sql\2014\ActiveRequests.sql
[string]$ActiveSessions = Get-Content .\sql\ActiveSessions.sql

[string]$query = $ActiveRequests + $ActiveSessions
. .\ps1\00_executeQuery.ps1

.\ps1\00_TableToHtml.ps1 -tableID 0
$comments = 
"List any SQL that are currently executing. Good way to identify hung queries."
Comments $comments

############################################################################
$htmlOut = "
<br>
<hr>
<br>
<h1>Active Sessions (sys.dm_exec_sessions)</h1>
<br>
"
WriteToHtml $htmlOut
.\ps1\00_TableToHtml.ps1 -tableID 1
$comments = 
"Can be used to find blocker sessions with <b>open_transaction_count</b> &gt; 0.
If open_transaction_count=1 and last_request_start_time is over 24 hours consider setting <b>wt.pom.connectionCloserIdleTimeout=600</b> and <b>wt.pom.minDbConnections=5</b>
See <a href='https://www.ptc.com/en/support/article/CS42548'>CS42548</a> for details."
Comments $comments

Footer

