[string]$query = (Get-Content .\sql\getQueryStoreState.sql) -join "`n"
. .\ps1\00_executeQuery.ps1

$QueryStoreState = $results.tables[0].Item('actual_state')

DebugLog "QueryStoreState: $QueryStoreState" -logOnly $true
