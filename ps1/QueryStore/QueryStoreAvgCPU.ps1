$title = "Query Store by Average CPU Time"

Header $title

[string]$query = (Get-Content .\sql\QueryStore\QueryStoreAvgCPU.sql) -join "`n"
. .\ps1\00_executeQuery.ps1

if($failedQuery -eq $false){

$htmlOut = "
<table class='sortable'>
<tr>
<th scope='col'>query_id</th>
<th scope='col'>plan_id</th>
<th scope='col'>LastExecution</th>
<th scope='col'>Executions</th>
<th scope='col'>TotalSec</th>
<th scope='col'>AvgSec</th>
<th scope='col'>AvgCpuSec</th>
<th scope='col'>MinSec</th>
<th scope='col'>MaxSec</th>
<th scope='col'>AvgLogicalReads</th>
<th scope='col'>AvgLogicalWrites</th>
<th scope='col'>AvgPhysicalReads</th>
<th scope='col'>AvgRowCount</th>
<th scope='col'>Text</th>
</tr>
"
WriteToHtml $htmlOut

foreach($row in $results.tables[0])
{
    [string]$planId = $row.Item("plan_id")
    [string]$AvgCpuSec = $row.Item("AvgCpuSec")

    .\ps1\QueryStore\QueryStoreAvgCPU_metrics.ps1
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
