$title = "Duplicate Indexes"

Header $title

[string]$DuplicateIndexes = (Get-Content .\sql\DuplicateIndexes.sql) -join "`n"
[string]$DupePK = (Get-Content .\sql\DupePK.sql) -join "`n"

[string]$query = $DuplicateIndexes + $DupePK
. .\ps1\00_executeQuery.ps1

WriteToHtml '<h1>Duplicate Indexes (ignore included columns)</h1>'
.\ps1\00_TableToHtml.ps1 -tableID 0

$htmlOut = "
<br>
<hr>
<br>
<h1>Duplicate Indexes (ignore PK)</h1>
<br>
"
WriteToHtml $htmlOut
.\ps1\00_TableToHtml.ps1 -tableID 1

$comments = 
"Look for similar indexes that could be duplicates. This check ignores idA2A2 as this column is always included in non-clustered indexes.
<b>Dupe index_key_columns without PK</b> = Indexed Column Names + Included Column Names - idA2A2

Known Issues: <a href='https://www.ptc.com/en/support/article?n=CS265415'>CS265415</a> and <a href='https://www.ptc.com/en/support/article?n=CS304554'>CS304554</a>

Each index should be reviewed carefully before dropping. Contact PTC Technical Support if assistance is required.

Example: these indexes are identical:
<ul><li>create index EPMInitialCheckinData$example1 on EPMInitialCheckinData(classnamekeyB3, idA3B3) ON INDX;</li>
<li>create index EPMInitialCheckinData$example2 on EPMInitialCheckinData(classnamekeyB3, idA3B3, idA2A2) ON INDX;</li>
<li>create index EPMInitialCheckinData$example3 on EPMInitialCheckinData(classnamekeyB3, idA3B3) include (idA2A2) ON INDX;</li></ul>

See <a href='http://sqlblog.com/blogs/kalen_delaney/archive/2010/03/07/more-about-nonclustered-index-keys.aspx'>More About Nonclustered Index Keys</a> for a detailed explaination on how these are duplicate indexes."
Comments $comments

Footer
