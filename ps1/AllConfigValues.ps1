$title = "All Config Values"

Header $title

[string]$query = (Get-Content .\sql\AllConfigValues.sql) -join "`n"
. .\ps1\00_executeQuery.ps1

.\ps1\00_TableToHtml.ps1 -tableID 0

Footer
