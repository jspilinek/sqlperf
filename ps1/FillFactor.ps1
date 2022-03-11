$title = "Fill Factor"

Header $title

[string]$query = (Get-Content .\sql\FillFactor.sql) -join "`n"
. .\ps1\00_executeQuery.ps1

.\ps1\00_TableToHtml.ps1 -tableID 0

$comments = 
"Default fill_factor is <b>0</b> which is the same as 100% fill factor.
Fill factor less than 80% could result in a lot of wasted empty space."
Comments $comments

Footer
