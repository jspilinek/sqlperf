[string]$global:scriptVersion="v22.03"
[string]$global:script_name="$startScript $scriptVersion"
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

#Default timeout is 600 seconds (10 minutes)
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
        DebugLog "Password might be wrong because CAPSLOCK is on" -logOnly $true
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