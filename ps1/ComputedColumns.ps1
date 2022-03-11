$title = "Computed Columns"

Header $title -text $true

[string]$query = (Get-Content .\sql\ComputedColumns.sql) -join "`n"
. .\ps1\00_executeQuery.ps1

.\ps1\00_TableToHtml.ps1 -tableID 0 -textOutput $true

Footer

