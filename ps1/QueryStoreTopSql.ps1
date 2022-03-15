$title = "Query Store Top SQL"
$textpath = ".\html\$currentScript.txt"

function Format-XML {
  [CmdletBinding()]
  Param ([Parameter(ValueFromPipeline=$true,Mandatory=$true)][string]$xmlcontent)
  $xmldoc = New-Object -TypeName System.Xml.XmlDocument
  $xmldoc.LoadXml($xmlcontent)
  $sw = New-Object System.IO.StringWriter
  $writer = New-Object System.Xml.XmlTextwriter($sw)
  $writer.Formatting = [System.XML.Formatting]::Indented
  $xmldoc.WriteContentTo($writer)
  $sw.ToString()
}

Header $title -text $true -lineBreak $true
Set-Content -Path $textpath -Value "*******************************************************************************************************************"

[string]$query = (Get-Content .\sql\QueryStoreTopSql.sql) -join "`n"
. .\ps1\00_executeQuery.ps1

#Main Table
$htmlOut = "
<table class=sortable>
<tr>
<th scope='col'>query_id</th>
<th scope='col'>LastExecution</th>
<th scope='col'>Executions</th>
<th scope='col'>TotalSec</th>
<th scope='col'>AvgSec</th>
<th scope='col'>AvgCpuSec</th>
<th scope='col'>TotalLogicalReads</th>
<th scope='col'>AvgLogicalReads</th>
<th scope='col'>TotalLogicalWrites</th>
<th scope='col'>AvgLogicalWrites</th>
<th scope='col'>TotalPhysicalReads</th>
<th scope='col'>AvgPhysicalReads</th>
<th scope='col'>AvgRowCount</th>
<th scope='col'>AvgDOP</th>
<th scope='col'>AvgQueryMaxUsedMemory</th>
<th scope='col'>Text</th>
</tr>
"
WriteToHtml $htmlOut

foreach($row in $results.tables[0])
{
    [string]$queryId = $row.Item("query_id")

    [string]$text = $row.Item("text")
    . .\ps1\00_formatSQL.ps1
    
    $htmlOut = "
<tr>
<td><a href='QueryStoreTopSql.html#$queryId'>$queryId</a></td>
<td>$($row['last_execution_time'])</td>
<td>$($row['Executions'])</td>
<td>$($row['TotalSec'])</td>
<td>$($row['AvgSec'])</td>
<td>$($row['AvgCpuSec'])</td>
<td>$($row['TotalLogicalReads'])</td>
<td>$($row['AvgLogicalReads'])</td>
<td>$($row['TotalLogicalWrites'])</td>
<td>$($row['AvgLogicalWrites'])</td>
<td>$($row['TotalPhysicalReads'])</td>
<td>$($row['AvgPhysicalReads'])</td>
<td>$($row['AvgRowCount'])</td>
<td>$($row['AvgDOP'])</td>
<td>$($row['AvgQueryMaxUsedMemory'])</td>
<td>$text</td>
</tr>
"
    WriteToHtml $htmlOut
}

$htmlOut = "
</table>
"
WriteToHtml $htmlOut

#.\ps1\00_TableToHtml.ps1 -tableID 0 -textOutput $true -htmlOutput $false -excludeAdditionalColumns "text, AvgDOP, AvgQueryMaxUsedMemory, AvgPhysicalReads"
.\ps1\00_TableToHtml.ps1 -tableID 0 -textOutput $true -htmlOutput $false -excludeAdditionalColumns "text"
WriteToText "*******************************************************************************************************************"

#Individual Queries
foreach($row in $results.tables[0])
{
    [string]$queryId = $row.Item("query_id")
    [string]$sqlText = $row.Item("text")
    $AvgSec = $row.Item("AvgSec")
    $AvgLogicalReads = $row.Item("AvgLogicalReads")

    $htmlOut = "
<h2 id='$queryId'>queryId: <b>$queryId</b></h2>
<table>
<tr>
<th scope='col'>LastExecutionTime</th>
<th scope='col'>Executions</th>
<th scope='col'>TotalSec</th>
<th scope='col'>AvgSec</th>
<th scope='col'>AvgCpuSec</th>
<th scope='col'>TotalLogicalReads</th>
<th scope='col'>AvgLogicalReads</th>
<th scope='col'>TotalLogicalWrites</th>
<th scope='col'>AvgLogicalWrites</th>
<th scope='col'>TotalPhysicalReads</th>
<th scope='col'>AvgPhysicalReads</th>
<th scope='col'>AvgRowCount</th>
<th scope='col'>AvgDOP</th>
<th scope='col'>AvgQueryMaxUsedMemory</th>
</tr>

<tr>
<td>$($row['last_execution_time'])</td>
<td>$($row['Executions'])</td>
<td>$($row['TotalSec'])</td>
<td>$AvgSec</td>
<td>$($row['AvgCpuSec'])</td>
<td>$($row['TotalLogicalReads'])</td>
<td>$AvgLogicalReads</td>
<td>$($row['TotalLogicalWrites'])</td>
<td>$($row['AvgLogicalWrites'])</td>
<td>$($row['TotalPhysicalReads'])</td>
<td>$($row['AvgPhysicalReads'])</td>
<td>$($row['AvgRowCount'])</td>
<td>$($row['AvgDOP'])</td>
<td>$($row['AvgQueryMaxUsedMemory'])</td>
</tr>
</table>
<br>
"
    WriteToHtml $htmlOut
    
    $excludeColumns = "RowError, RowState, Table, ItemArray, HasErrors, text" -split ", "
    $row | select $columns -ExcludeProperty $excludeColumns | Format-Table -Property * -AutoSize | Out-String -Width 4096 | Out-File -encoding ASCII -append -FilePath $textpath

    #If ($AvgSec -gt 1 -Or $AvgLogicalReads -gt 10000){
        .\ps1\QueryStoreTopPlans.ps1
    #}

    $htmlOut = "
<br>
$sqlText
<br>
<br>
<hr>
"
    WriteToHtml $htmlOut
    
    .\ps1\00_WrapText.ps1
    WriteToFileNewline $textpath
    WriteToFileNewline $textpath
    WriteToText "*******************************************************************************************************************"
}
Footer
