#Script created using SqlServer Module 21.1.18147 and Powershell 5.1
param (
    [Parameter(Mandatory=$true)][string]$database = $(throw "-database is required."),
    [string]$server = $env:computername,
    [string]$login = $false,
    [int]$timeout = 600,
    [string]$start_time = '03/30/2020 06:45:00 -06:00',
    [string]$end_time = '03/30/2020 08:45:00 -06:00'
)

[string]$global:script_name="PTC Query Store Report v22.02"
[string]$global:main_page="00_sqlperf"
[string]$global:dateFormat='yyyy-MM-dd HH:mm:ss'

.\ps1\00_LoadModules.ps1
if($LASTEXITCODE -ne 0)
{
    exit
}

#execute in same scope as sqlperf.ps1
. .\ps1\00_initDebug.ps1

$srv = New-Object ('Microsoft.SQLServer.Management.Smo.Server') $server

#Change timeout to 1800 seconds (30 minutes). Default timeout is 600 seconds (10 minutes)
$srv.ConnectionContext.StatementTimeout = $timeout

if($login -eq $false){
    DebugLog "Authentication Mode: Windows Authentication"
}else{
    if([Console]::CapsLock -eq $true)
    {
        Write-Host "Warning: CAPSLOCK is on" -ForegroundColor White -BackgroundColor Red
    }
    Write-Host "Enter password for $login : " -ForegroundColor Yellow -NoNewline
    $SecurePassword = Read-Host -AsSecureString

    # Create a "password pointer"
    $PasswordPointer = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecurePassword)
    
    # Get the plain text version of the password
    $PlainTextPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto($PasswordPointer)
    
    # Free the pointer
    [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($PasswordPointer)
    
    DebugLog "Authentication Mode: SQL Server Authentication"
    
    $srv.ConnectionContext.LoginSecure = $FALSE
    $srv.ConnectionContext.Login = $login
    $srv.ConnectionContext.Password = $PlainTextPassword
}

try{
    $ErrorActionPreference = "Stop";
    $srv.ConnectionContext.Connect()
} catch {
    LogException $_.Exception $error[0].ScriptStackTrace "Login failed"
    if([Console]::CapsLock -eq $true)
    {
        Write-Host "Password might be wrong because CAPSLOCK is on" -ForegroundColor White -BackgroundColor Red
    }
    Exit
}

$db = $srv.Databases[$database]

if(!$db){
    DebugLog "Database '$database' not found!" -error $true
    DebugLog "Available databases are:"
    $srv.Databases | SELECT Name
    Exit
}

#execute in same scope as sqlperf.ps1
. .\ps1\00_values.ps1

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
<font class='label-header'>version:</font>$ProductName
<font class='label-header'>database:</font>$database
"

if($login -ne $false){
$htmlOut += "
<font class='label-header'>login:</font>$login
"
}

$htmlOut += "
<font class='label-header'>uptime:</font>$Uptime
<font class='label-header'>generated:</font>$execute_time
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
