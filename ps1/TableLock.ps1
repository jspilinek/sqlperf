$title = "Table Lock Escalation"

Header $title

[string]$query = (Get-Content .\sql\TableLock.sql) -join "`n"
. .\ps1\00_executeQuery.ps1

.\ps1\00_TableToHtml.ps1 -tableID 0

$comments = 
"Checks for tables with lock escalation enabled.
Default lock_escalation: 0
Default lock_escalation_desc: TABLE

It's recommended to disable lock escalation on all tables."
Comments $comments

Footer
