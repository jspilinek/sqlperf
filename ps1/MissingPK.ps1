$title = "Missing Primary Key"

Header $title

[string]$query = (Get-Content .\sql\MissingPK.sql) -join "`n"
. .\ps1\00_executeQuery.ps1

.\ps1\00_TableToHtml.ps1 -tableID 0

$comments = 
"Very rare issue.
<a href='https://www.ptc.com/en/support/article?n=CS110264'>CS110264</a> is an example that was resolved in FlexPLM 10.2 F000."
Comments $comments

Footer
