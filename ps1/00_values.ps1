$path = ".\html\$main_page.html"

. .\ps1\00_sqlplan.ps1

$columns = '*'
$excludeColumns = 'RowError, RowState, Table, ItemArray, HasErrors' -split ", "

. .\ps1\getProductVersion.ps1
. .\ps1\getCompatibilityLevel.ps1
. .\ps1\getUptime.ps1

if($ProductMajorVersion -ge 13){
. .\ps1\getQueryStoreState.ps1
}

. .\ps1\getWindchillInstall.ps1

[string]$global:top_count="100"
