$title = "Database Scoped Configurations"

Header $title

[string]$query = (Get-Content .\sql\DBScopedConfigs.sql) -join "`n"
. .\ps1\00_executeQuery.ps1

.\ps1\00_TableToHtml.ps1 -tableID 0 -link $true

$comments = 
"New in SQL Server 2016. 

Can use this to check the setting of <b>LEGACY_CARDINALITY_ESTIMATION</b>. Refer to <a href='https://www.ptc.com/en/support/article/CS299797'>CS299797</a> for details."

Comments $comments

Footer
