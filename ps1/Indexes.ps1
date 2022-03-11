$title = "Indexes"

Header $title -text $true -lineBreak $true

[string]$query = (Get-Content .\sql\Indexes.sql) -join "`n"
. .\ps1\00_executeQuery.ps1

.\ps1\00_TableToHtml.ps1 -tableID 0 -textOutput $true

Footer
