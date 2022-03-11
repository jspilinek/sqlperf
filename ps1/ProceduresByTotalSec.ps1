$title = "Stored Procedures by Total Seconds"

Header $title -lineBreak $true

[string]$query = (Get-Content .\sql\ProceduresByTotalSec.sql) -join "`n"
. .\ps1\00_executeQuery.ps1

.\ps1\00_TableToHtml.ps1 -tableID 0

Footer
