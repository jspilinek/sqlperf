$title = "Trace Flags"

Header $title -lineBreak $true

[string]$query = (Get-Content .\sql\TraceFlags.sql) -join "`n"
. .\ps1\00_executeQuery.ps1

.\ps1\00_TableToHtml.ps1 -tableID 0

$comments = 
"See <a href='https://docs.microsoft.com/en-us/sql/t-sql/database-console-commands/dbcc-traceon-trace-flags-transact-sql'>DBCC TRACEON - Trace Flags</a> for a list of trace flags"
Comments $comments

Footer
