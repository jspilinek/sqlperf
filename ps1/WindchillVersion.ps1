$title = "Windchill Version"

Header $title

[string]$query = (Get-Content .\sql\WindchillVersion.sql) -join "`n"
$query = $query -replace "ENTER_WINDCHILL_SCHEMA","$WindchillSchema"
. .\ps1\00_executeQuery.ps1

.\ps1\00_TableToHtml.ps1 -tableID 0

$comments = 
"Useful when considering known Windchill SPRs."

Comments $comments

Footer
