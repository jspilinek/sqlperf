$title = "Missing Indexes"

Header $title

[string]$query = (Get-Content .\sql\MissingIndexes.sql) -join "`n"
. .\ps1\00_executeQuery.ps1

.\ps1\00_TableToHtml.ps1 -tableID 0

$comments = 
"<b>Cost</b> = avg_total_user_cost * avg_user_impact * (user_seeks + user_scans)
Find indexes that *might* need to be created. In general you should never create these indexes. SQL Server will recommend indexes that can cause serious performance problems. SQL Server doesn't consider other existing indexes or the impact on other queries. It only provides the very best index for a specific problem, but even then it can provide bad advice.
See also <a href='https://www.ptc.com/en/support/article?n=CS314707'>CS314707</a>"

Comments $comments

Footer
