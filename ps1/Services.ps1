$title = "SQL Server Services"

Header $title

[string]$Services = (Get-Content .\sql\Services.sql) -join "`n"
[string]$AgentJobs = (Get-Content .\sql\AgentJobs.sql) -join "`n"
[string]$AgentAlerts = (Get-Content .\sql\AgentAlerts.sql) -join "`n"

[string]$query = $Services + $AgentJobs + $AgentAlerts
. .\ps1\00_executeQuery.ps1

.\ps1\00_TableToHtml.ps1 -tableID 0

$htmlOut = "
<br>
<hr>
<br>
<h1>SQL Server Agent Jobs</h1>
<br>
"
WriteToHtml $htmlOut
.\ps1\00_TableToHtml.ps1 -tableID 1

$htmlOut = "
<br>
<hr>
<br>
<h1>SQL Server Agent Alerts</h1>
<br>
"
WriteToHtml $htmlOut
.\ps1\00_TableToHtml.ps1 -tableID 2

Footer
