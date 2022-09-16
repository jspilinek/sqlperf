$title = "Query Store DML"

Header $title

[string]$query = (Get-Content .\sql\QueryStoreDml.sql) -join "`n"
. .\ps1\00_executeQuery.ps1

if($failedQuery -eq $false){
$htmlOut = "
<table class='sortable'>
<tr>
<th scope='col'>query_id</th>
<th scope='col'>plan_id</th>
<th scope='col'>LastExecution</th>
<th scope='col'>Executions</th>
<th scope='col'>AvgRowCount</th>
<th scope='col'>Text</th>
</tr>
"
WriteToHtml $htmlOut

foreach($row in $results.tables[0])
{
    $queryId = $row.Item("query_id")

    $text = $row.Item("text")
    . .\ps1\00_formatSQL.ps1 -fullText $true

    $htmlOut = "
<tr>
<td><a href='QueryStoreTopSql.html#$queryId'>$queryId</td>
<td>$($row['plan_id'])</td>
<td>$($row['LastExecution'])</td>
<td>$($row['Executions'])</td>
<td>$($row['AvgRowCount'])</td>
<td>$text</td>
</tr>
"
    WriteToHtml $htmlOut
}

$htmlOut = "
</table>
"
WriteToHtml $htmlOut
}else{
    WriteToHtml "<p class='failedQuery'>Failed to execute query:</p>"
    WriteToHtml "<p class='failedQuery'>$query</p>"
    WriteToHtml "<p class='failedQuery'> Refer to <a href='debug.txt'>debug.txt</a> for details"
}

$comments = 
"Gives an idea of the DML activity in the system. Not usually important, but can give clues to if some sort of activity is causing undo load on the system."
Comments $comments

Footer
