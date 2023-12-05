$title = "Statistics with NoRecompute"

Header $title

[string]$query = (Get-Content .\sql\2014\StatsNoRecompute.sql) -join "`n"
. .\ps1\00_executeQuery.ps1

.\ps1\00_TableToHtml.ps1 -tableID 0

$comments = 
"Statistics with <b>NORECOMPUTE</b> option will not be automatically updated as the table data changes.
Enabling this might make sense for very large tables with very skewed data and SQL Server is using too low of a sampling rate.
When enabled there should be a SQL Server job scheduled to update statistics so that statistics don't become stale."
Comments $comments

Footer
