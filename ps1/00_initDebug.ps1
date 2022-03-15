$StopWatch = [system.diagnostics.stopwatch]::startNew()
$global:execute_time = Get-Date -format $dateFormat

#Start 7 days ago
[string]$global:start_time = (Get-Date).AddDays(-7).ToString($dateFormat)
#End current time
[string]$global:end_time = $execute_time

Set-Content -Path ".\html\debug.txt" -Value "$execute_time $script_name"

DebugLog "Script parameters:" -logOnly $true
DebugLog "    server     = $server" -logOnly $true
DebugLog "    database   = $database" -logOnly $true
DebugLog "    login      = $login" -logOnly $true
DebugLog "    stats      = $stats" -logOnly $true
DebugLog "    checkDupe  = $checkDupe"  -logOnly $true
DebugLog "    timeout    = $timeout" -logOnly $true
DebugLog "    start_time = $start_time" -logOnly $true
DebugLog "    end_time   = $end_time" -logOnly $true
