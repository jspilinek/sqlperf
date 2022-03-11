[string]$query = (Get-Content .\sql\getWindchillInstall.sql) -join "`n"
. .\ps1\00_executeQuery.ps1

$rowcount = @($results.tables[0]).count

if($rowcount -eq 0 -Or !$results.tables[0]){
    [bool]$Windchill = $false
    [string]$WindchillSchema = ""
    DebugLog "Windchill not found" -logOnly $true
}else{
    [bool]$Windchill = $true
    [string]$WindchillSchema = $results.tables[0].rows[0].Item("schemaName")
    DebugLog "Windchill found" -logOnly $true
}

DebugLog "WindchillSchema: $WindchillSchema" -logOnly $true
