$title = "Important Config Values"

Header $title

[string]$query = (Get-Content .\sql\ImportantConfigValues.sql) -join "`n"
. .\ps1\00_executeQuery.ps1

.\ps1\00_TableToHtml.ps1 -tableID 0

$comments = 
"These configuration options are the most commonly involved in performance issues.
<b>cost threshold for parallelism</b> defaults to 5, meaning if a query has an estimated cost greater than 5 seconds, it will be considered for parallelism. This setting may be too low if parallel queries are running too frequently.
<b>max degree of parallelism</b> (aka MAXDOP) Default is 0 which is unlimited. Parallelism is disabled if MAXDOP is set to 1. Below link provides Microsoft's recommendation for setting MAXDOP.
<a href='https://support.microsoft.com/en-us/help/2806535/recommendations-and-guidelines-for-the-max-degree-of-parallelism-confi'>Recommendations and guidelines for the max degree of parallelism configuration option in SQL Server</a>
If <b>min server memory (MB)</b> = <b>max server memory (MB)</b>, this disables dynamic memory. If set too high, can cause paging."
Comments $comments

Footer
