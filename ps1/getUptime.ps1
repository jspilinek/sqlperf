[string]$Uptime = "unavailable"

if($ProductName -ne "AzureSQL"){
    if($ProductMajorVersion -ge 13){
        [string]$query = (Get-Content .\sql\Uptime.sql) -join "`n"
    }else{
        [string]$query = (Get-Content .\sql\2014\Uptime.sql) -join "`n"
    }
    . .\ps1\00_executeQuery.ps1
    $Uptime = $results.tables[0].Item('Uptime')
}

DebugLog "Uptime: $Uptime"
