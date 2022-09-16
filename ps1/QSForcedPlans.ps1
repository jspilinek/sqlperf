$title = "Query Store Forced Plans"

Header $title

[string]$query = (Get-Content .\sql\QSForcedPlans.sql) -join "`n"
. .\ps1\00_executeQuery.ps1

if($failedQuery -eq $false){
$htmlOut = "
<table class='sortable'>
<tr>
<th scope='col'>plan_id</th>
<th scope='col'>query_id</th>
<th scope='col'>QueryPlanHash</th>
<th scope='col'>force_failure_count</th>
<th scope='col'>last_force_failure_reason_desc</th>
<th scope='col'>plan_forcing_type_desc</th>
<th scope='col'>text</th>
</tr>
"
WriteToHtml $htmlOut

foreach($row in $results.tables[0])
{
    $text = $row.Item("query_sql_text")
    . .\ps1\00_formatSQL.ps1 -fullText $true

    $htmlOut = "
<tr>
<td>$($row['plan_id'])</td>
<td>$($row['query_id'])</td>
<td>$($row['QueryPlanHash'])</td>
<td>$($row['force_failure_count'])</td>
<td>$($row['last_force_failure_reason_desc'])</td>
<td>$($row['plan_forcing_type_desc'])</td>
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

Footer
