$title = "Query Store by Executions"

Header $title

[string]$query = (Get-Content .\sql\SpeedTest\QueryStoreExecutions.sql) -join "`n"
. .\ps1\00_executeQuery.ps1

$global:topExecutions = New-Object System.Collections.ArrayList

if($failedQuery -eq $false){

foreach($row in $results.tables[0])
{
    $global:topExecutions += $row
}

################ Second table with details ################################

$htmlOut = "
<table class='sortable'>
<tr>
<th scope='col'>query_id</th>
<th scope='col'>plan_id</th>
<th scope='col'>LastExecution</th>
<th scope='col'>Executions</th>
<th scope='col'>TotalSec</th>
<th scope='col'>AvgSec</th>
<th scope='col'>AvgLogicalReads</th>
<th scope='col'>AvgLogicalWrites</th>
<th scope='col'>AvgPhysicalReads</th>
<th scope='col'>AvgRowCount</th>
<th scope='col'>Text</th>
</tr>
"
WriteToHtml $htmlOut

foreach($row in $topExecutions)
{
    [string]$planId = $row.Item("plan_id")
    [string]$Executions = $row.Item("Executions")

    .\ps1\SpeedTest\QueryStoreExecutions_metrics.ps1

    # $queryId = $row.Item("query_id")
    
    # $text = $row.Item("text")
    # . .\ps1\00_formatSQL.ps1

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

# "Top SQL:"
# $global:topExecutions
