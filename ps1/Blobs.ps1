$title = "Blobs Over 1 GB"

Header $title -lineBreak $true

[string]$query = (Get-Content .\sql\Blobs.sql) -join "`n"
. .\ps1\00_executeQuery.ps1

.\ps1\00_TableToHtml.ps1 -tableID 0

$comments = 
"<a href='https://www.ptc.com/en/support/article?n=CS120635'>How to move BLOBS to a vault in Windchill PDMLink when using SQL Server</a>"
Comments $comments

Footer
