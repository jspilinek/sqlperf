$title = "Stored Procedures by Total Logical Reads"

Header $title

[string]$query = (Get-Content .\sql\2014\ProceduresByLogicalReads.sql) -join "`n"
. .\ps1\00_executeQuery.ps1

.\ps1\00_TableToHtml.ps1 -tableID 0

Footer
