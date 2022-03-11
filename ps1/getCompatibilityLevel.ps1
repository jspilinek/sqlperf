[string]$query = (Get-Content .\sql\getCompatibilityLevel.sql) -join "`n"
. .\ps1\00_executeQuery.ps1

$compatibilityLevel = $results.tables[0].Item('compatibility_level')

DebugLog "compatibilityLevel: $compatibilityLevel"  -logOnly $true
