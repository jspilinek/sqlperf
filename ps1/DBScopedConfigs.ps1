$title = "Database Scoped Configurations"

Header $title

[string]$query = (Get-Content .\sql\DBScopedConfigs.sql) -join "`n"
. .\ps1\00_executeQuery.ps1

.\ps1\00_TableToHtml.ps1 -tableID 0 -link $true

$comments = 
"New in SQL Server 2016. Can use this to check if <b>LEGACY_CARDINALITY_ESTIMATION</b> has been enabled.
Enable with:
<b>ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = ON;</b>"
Comments $comments

Footer
