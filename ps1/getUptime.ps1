[string]$Uptime = "unavailable"

if($ProductName -ne "AzureSQL"){
    [string]$query = (Get-Content .\sql\Uptime.sql) -join "`n"
    . .\ps1\00_executeQuery.ps1
    $Uptime = $results.tables[0].Item('Uptime')
}

DebugLog "Uptime: $Uptime"
