$title = "View Definitions"

Header $title -text $true

[string]$query = (Get-Content .\sql\ViewDefinitions.sql) -join "`n"
. .\ps1\00_executeQuery.ps1

.\ps1\00_TableToHtml.ps1 -tableID 0 -textOutput $true

Footer
