$StopWatch = [system.diagnostics.stopwatch]::startNew()
$global:execute_time = Get-Date -format $dateFormat

#Start $maxAgeDays days ago (default 7 days)
[string]$global:start_time = (Get-Date).AddDays(-1 * $maxAgeDays).ToString($dateFormat)
#End current time
[string]$global:end_time = $execute_time

Set-Content -Path ".\html\debug.txt" -Value "$execute_time $script_name"

if ($IsLinux -eq $true){
    DebugLog "PowerShell Platform: Linux" -logOnly $true
}else{
    #If not Linux, assume Windows
    #$IsWindows doesn't work in older PowerShell releases
    DebugLog "PowerShell Platform: Windows" -logOnly $true
}

DebugLog "Script parameters:" -logOnly $true
DebugLog "    server     = $server" -logOnly $true
DebugLog "    database   = $database" -logOnly $true
DebugLog "    login      = $login" -logOnly $true
DebugLog "    stats      = $stats" -logOnly $true
DebugLog "    checkDupe  = $checkDupe"  -logOnly $true
DebugLog "    timeout    = $timeout" -logOnly $true
DebugLog "    maxAgeDays = $maxAgeDays" -logOnly $true
DebugLog "    start_time = $start_time" -logOnly $true
DebugLog "    end_time   = $end_time" -logOnly $true
DebugLog "  sqlToolsPath = $sqlToolsPath" -logOnly $true
