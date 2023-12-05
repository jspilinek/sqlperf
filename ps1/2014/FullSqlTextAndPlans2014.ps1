$title = "Full SQL Text and Plans"
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

Header $title -text $true
Set-Content -Path $textpath -Value "*******************************************************************************************************************"

[string]$query = (Get-Content .\sql\2014\FullSqlTextAndPlans.sql) -join "`n"
. .\ps1\00_executeQuery.ps1

if($failedQuery -eq $false){
#Main Table
$htmlOut = "
<table class=sortable>
<tr>
<th scope='col'>query_hash</th>
<th scope='col'>Executions</th>
<th scope='col'>TotalSec</th>
<th scope='col'>AvgSec</th>
<th scope='col'>AvgCpuSec</th>
<th scope='col'>AvgLogicalReads</th>
<th scope='col'>AvgPhysicalReads</th>
<th scope='col'>AvgRows</th>
<th scope='col'>LastExecutionTime</th>
<th scope='col'>Text</th>
</tr>
"
WriteToHtml $htmlOut

InitProgressBar -Steps $results.tables[0].Rows.Count -Activity $title
foreach($row in $results.tables[0])
{

    [string]$queryHash = $row.Item("QueryHash")
    [string]$text = $row.Item("text")
    . .\ps1\00_formatSQL.ps1

    $htmlOut = "
<tr>
<td><a href='FullSqlTextAndPlans.html#$queryHash'>$queryHash</td>
<td>$($row['Executions'])</td>
<td>$($row['TotalSec'])</td>
<td>$($row['AvgSec'])</td>
<td>$($row['AvgCpuSec'])</td>
<td>$($row['AvgLogicalReads'])</td>
<td>$($row['AvgPhysicalReads'])</td>
<td>$($row['AvgRows'])</td>
<td>$($row['last_execution_time'])</td>
<td>$text</td>
</tr>
"
    WriteToHtml $htmlOut

    UpdateProgressBar
}

CompleteProgressBar

$htmlOut = "
</table>
<br>
<hr>
<br>
"
WriteToHtml $htmlOut

.\ps1\00_TableToHtml.ps1 -tableID 0 -textOutput $true -htmlOutput $false -excludeAdditionalColumns "query_hash, text"
WriteToText "*******************************************************************************************************************"

#Individual Queries
InitProgressBar -Steps $results.tables[0].Rows.Count -Activity $title
foreach($row in $results.tables[0])
{
    $queryHash = $row.Item("QueryHash")
    $sqlText = $row.Item("text")
    $AvgSec = $row.Item("AvgSec")
    $AvgLogicalReads = $row.Item("AvgLogicalReads")

    $htmlOut = "
<h2 id='$queryHash'>QueryHash: <b>$queryHash</b></h2>
<table>
<tr>
<th scope='col'>LastExecutionTime</th>
<th scope='col'>Executions</th>
<th scope='col'>TotalSec</th>
<th scope='col'>AvgSec</th>
<th scope='col'>AvgCpuSec</th>
<th scope='col'>AvgLogicalReads</th>
<th scope='col'>AvgPhysicalReads</th>
<th scope='col'>AvgRows</th>
</tr>

<tr>
<td>$($row['last_execution_time'])</td>
<td>$($row['Executions'])</td>
<td>$($row['TotalSec'])</td>
<td>$AvgSec</td>
<td>$($row['AvgCpuSec'])</td>
<td>$AvgLogicalReads</td>
<td>$($row['AvgPhysicalReads'])</td>
<td>$($row['AvgRows'])</td>
</tr>
</table>
<br>
"
    WriteToHtml $htmlOut
    
    $excludeColumns = "RowError, RowState, Table, ItemArray, HasErrors, query_hash, text, shortText" -split ", "
    $row | select $columns -ExcludeProperty $excludeColumns | Format-Table -Property * -AutoSize | Out-String -Width 4096 | Out-File -encoding ASCII -append -FilePath $textpath


if(($ProductMajorVersion -ge 13) -and ($QueryStoreState -ne 0) -and ($QueryStoreState -ne 3)){
    #Disabled since we'll get the plans from Query Store
}else{
#Enabled when Query Store is not available:
    #SQL Server 2014 or earlier
    #QueryStore in OFF or ERROR state
    If ($AvgSec -gt 1 -Or $AvgLogicalReads -gt 10000){
        .\ps1\SqlTopPlans.ps1
    }
}
    
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

    UpdateProgressBar
}

CompleteProgressBar

}else{
    WriteToHtml "<p class='failedQuery'>Failed to execute query:</p>"
    WriteToHtml "<p class='failedQuery'>$query</p>"
    WriteToHtml "<p class='failedQuery'> Refer to <a href='debug.txt'>debug.txt</a> for details"
}

Footer
