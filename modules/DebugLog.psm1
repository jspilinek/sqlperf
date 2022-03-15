function DebugLog
{
    param (
        [Parameter(Mandatory=$true)][string]$message,
        [bool]$logOnly = $false,
        [bool]$error = $false
    )

    #Print message to console
    if($logOnly -eq $false){
        if($error -eq $true){
            Write-Host "$message" -ForegroundColor Red -BackgroundColor Black
        }else{
            "$message"
        }
    }

    $messageTimeStamp = Get-Date -format $dateFormat
    WriteToDebugLog "$messageTimeStamp $message"
}

function LogException
{
    param (
        [Parameter(Mandatory=$true)][Exception]$exception,
        [Parameter(Mandatory=$true)][string]$scriptStackTrace,
        [Parameter(Mandatory=$true)][string]$errorMessage,
        [string]$details = ""
    )
    
    [string]$errorString = $exception -replace "--->","`r`n--->"
    DebugLog $errorString
    DebugLog "ScriptStackTrace:`r`n$scriptStackTrace" -logOnly $true
    DebugLog $errorMessage -error $true
    if([string]::IsNullOrEmpty($details) -ne $true){
        DebugLog $details
    }
}

Export-ModuleMember -Function 'DebugLog'
Export-ModuleMember -Function 'LogException'
