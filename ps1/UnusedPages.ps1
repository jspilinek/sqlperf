$title = "Unused Pages"

Header $title

[string]$query = (Get-Content .\sql\UnusedPages.sql) -join "`n"
. .\ps1\00_executeQuery.ps1

.\ps1\00_TableToHtml.ps1 -tableID 0

$comments = 
"Identify if there are tables that need to be manually shrunk to free up unused pages."
Comments $comments

Footer
