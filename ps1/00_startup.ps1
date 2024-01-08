[string]$global:scriptVersion="v24.01"
[string]$global:script_name="$startScript $scriptVersion"
[string]$global:main_page="00_sqlperf"
[string]$global:dateFormat='yyyy-MM-dd HH:mm:ss zzz'
[string]$global:TimeZone=(Get-TimeZone).Id

.\ps1\00_LoadModules.ps1
if($LASTEXITCODE -ne 0)
{
    exit
}

#execute in same scope as sqlperf.ps1
. .\ps1\00_initDebug.ps1

$serverConnection = new-object Microsoft.SqlServer.Management.Common.ServerConnection

#Default timeout is 600 seconds (10 minutes)
$serverConnection.StatementTimeout = $timeout

if($login -eq $false){
    DebugLog "Authentication Mode: Windows Authentication"
    $serverConnection.ServerInstance="$server"
}else{
    if ($IsWindows -eq $true){
        if([Console]::CapsLock -eq $true)
        {
            Write-Host "Warning: CAPSLOCK is on" -ForegroundColor White -BackgroundColor Red
        }
    }
    Write-Host "Enter password for $login : " -ForegroundColor Yellow -NoNewline
    $SecurePassword = Read-Host -AsSecureString

    # Create a "password pointer"
    $PasswordPointer = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecurePassword)
    
    # Get the plain text version of the password
    $PlainTextPassword = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($PasswordPointer)
    
    # Free the pointer
    [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($PasswordPointer)
    
    DebugLog "Authentication Mode: SQL Server Authentication"
    
    $serverConnection.ServerInstance="$server,$port"
    $serverConnection.LoginSecure = $FALSE
    $serverConnection.Login = $login
    $serverConnection.Password = $PlainTextPassword
}

$srv = new-object Microsoft.SqlServer.Management.SMO.Server($serverConnection)

try{
    $ErrorActionPreference = "Stop";
    $srv.ConnectionContext.Connect()
} catch {
    "Login failed"
    LogException $_.Exception $error[0].ScriptStackTrace "Login failed"
    if ($IsWindows -eq $true){
        if([Console]::CapsLock -eq $true)
        {
            Write-Host "Password might be wrong because CAPSLOCK is on" -ForegroundColor White -BackgroundColor Red
            DebugLog "Password might be wrong because CAPSLOCK is on" -logOnly $true
        }
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