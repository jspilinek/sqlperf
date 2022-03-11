$title = "Performance Tables Age"

Header $title

[string]$query = (Get-Content .\sql\PerfTablesAge.sql) -join "`n"
$query = $query -replace "ENTER_WINDCHILL_SCHEMA","$WindchillSchema"
. .\ps1\00_executeQuery.ps1

.\ps1\00_TableToHtml.ps1 -tableID 0

$comments = 
"Report on the oldest entry of each JMX database logging table. This is done to check if LogTableCleaner is missing or failing to run. See <a href='https://www.ptc.com/en/support/article/178198'>CS178198</a> for details.
Refer to <a href='https://www.ptc.com/en/support/article/CS44623'>CS44623</a> for configured max age of each table."

Comments $comments

Footer
