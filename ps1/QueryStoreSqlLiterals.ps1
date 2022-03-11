$title = "Query Store SQL Literals"

Header $title -lineBreak $true

[string]$query = (Get-Content .\sql\QueryStoreSqlLiterals.sql) -join "`n"
. .\ps1\00_executeQuery.ps1

$htmlOut = "
<table class='sortable'>
<tr>
<th scope='col'>Count</th>
<th scope='col'>QueryHash</th>
<th scope='col'>query_id</th>
<th scope='col'>text</th>
</tr>
"
WriteToHtml $htmlOut

foreach($row in $results.tables[0])
{
    $text = $row.Item("text")
    . .\ps1\00_formatSQL.ps1 -fullText $true

    $htmlOut = "
<tr>
<td>$($row['Count'])</td>
<td>$($row['QueryHash'])</td>
<td>$($row['query_id'])</td>
<td>$text</td>
</tr>
"
    WriteToHtml $htmlOut
}

$htmlOut = "
</table>
"
WriteToHtml $htmlOut

$comments = 
"Check for queries using literals instead of parameterization. Queries with a large count may be causing overhead by frequent recompliation.
To see query text for every execution of a particular QueryHash use:
<b>SELECT q.query_hash, q.query_id, qt.query_sql_text FROM sys.query_store_query q INNER JOIN sys.query_store_query_text qt ON q.query_text_id = qt.query_text_id WHERE query_hash = &lt;QueryHash&gt;</b>
"
Comments $comments

Footer
