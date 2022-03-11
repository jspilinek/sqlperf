$title = "Fragmented Indexes"

Header $title

[string]$query = (Get-Content .\sql\FragmentedIndexes.sql) -join "`n"
. .\ps1\00_executeQuery.ps1

.\ps1\00_TableToHtml.ps1 -tableID 0

$comments = 
"Gives command to rebuild > 30% frag
Gives command to reorganize > 15% and <= 30%
Note: <b>online</b> option requires Enterprise Edition."
Comments $comments

Footer

