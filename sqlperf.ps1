#Script created using SqlServer Module 21.1.18147 and Powershell 5.1
param (
    [Parameter(Mandatory=$true)][string]$database = $(throw "-database is required."),
    [string]$server = $env:computername,
    [string]$login = $false,
    [bool]$stats = $true,
    [bool]$checkDupe = $true,
    [int]$timeout = 600
)

[string]$global:script_name="PTC SQL Server Performance and Diagnostics Report v22.02"
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
"
Set-Content -Path $path -Value $htmlOut

.\ps1\00_RunScripts.ps1

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
