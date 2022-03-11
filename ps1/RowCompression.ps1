$title = "Row Compression"

Header $title

[string]$RowCompression = (Get-Content .\sql\RowCompression.sql) -join "`n"
[string]$RowCompressionHeap = (Get-Content .\sql\RowCompressionHeap.sql) -join "`n"

[string]$query = $RowCompression + $RowCompressionHeap
. .\ps1\00_executeQuery.ps1

$htmlOut = "
<h1>Clustered and Non-Clustered Indexes</h1>
<br>
"
WriteToHtml $htmlOut
.\ps1\00_TableToHtml.ps1 -tableID 0

$htmlOut = "
<br>
<hr>
<br>
<h1>Heap Indexes</h1>
<br>
"
WriteToHtml $htmlOut
.\ps1\00_TableToHtml.ps1 -tableID 1

$comments = 
"Note compressing all indexes may take a couple hours, depending on the database size."

Comments $comments

Footer
