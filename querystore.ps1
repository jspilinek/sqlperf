#Script created using SqlServer Module 21.1.18147 and Powershell 5.1
param (
    [Parameter(Mandatory=$true)][string]$database = $(throw "-database is required."),
    [string]$server = $env:computername,
    [int]$port = 1433,
    [string]$login = $false,
    [int]$timeout = 600,
    [string]$start_time = '2022-03-14 06:45:00 -06:00',
    [string]$end_time = '2022-03-14 08:45:00 -06:00'
)

$StopWatch = [system.diagnostics.stopwatch]::startNew()

[string]$global:startScript="PTC Query Store Report"
#execute in same scope as sqlperf.ps1
. .\ps1\00_startup.ps1

DebugLog "Generating $main_page.html"

$htmlOut = "
<!DOCTYPE html>
<html>
<head>
<title>$script_name</title>
<link rel='stylesheet' type='text/css' href='sqlperf.css' />
</head>
<body>
<h1>$script_name</h1>
<header>
version:<font class='label-header'>$ProductName</font>
database:<font class='label-header'>$database</font>
"

if($login -ne $false){
$htmlOut += "
login:<font class='label-header'>$login</font>
"
}

$htmlOut += "
uptime:<font class='label-header'>$Uptime</font>
generated:<font class='label-header'>$execute_time</font>
</header>
<br>
<table class='main'>
<tr><td><ul>
<li>Start Time: $start_time</li>
<li>  End Time: $end_time</li>
"
Set-Content -Path $path -Value $htmlOut

.\ps1\00_RunScripts_QS.ps1

$htmlOut = "
</ul></td></tr>
</table>
<br>
<br>
<footer>$script_name generated $execute_time </footer>
</body>
</html>
"
Add-Content -Path $path -Value $htmlOut

$StopWatch.Stop()
$elapsed = [math]::Round($StopWatch.Elapsed.TotalSeconds,1)
$execute_time = Get-Date -format $dateFormat
"$script_name done in $elapsed seconds"
Add-Content -Path ".\html\debug.txt" -Value "$execute_time $script_name done in $elapsed seconds"
