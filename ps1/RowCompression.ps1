$title = "Row Compression"

Header $title

[bool]$RowCompressionAvailable = $false

# SQL Server 2017 or later
if ($ProductMajorVersion -ge 14) {
    $RowCompressionAvailable = $true
    DebugLog "RowCompressionAvailable: SQL Server 2017 or later" -logOnly $true
}
# Azure SQL
elseif ($ProductName -eq "AzureSQL") {
    $RowCompressionAvailable = $true
    DebugLog "RowCompressionAvailable: Azure SQL" -logOnly $true
}
# SQL Server 2016 SP1 or later
elseif ($BuildVersion -eq 13.0 -And $UpdateVersion -ge 4001.0) {
    $RowCompressionAvailable = $true
    DebugLog "RowCompressionAvailable: SQL Server 2016 SP1 or later" -logOnly $true
}
# Enterprise Edition
elseif ($Edition.Split(" ")[0] -eq "Enterprise"){
    $RowCompressionAvailable = $true
    DebugLog "RowCompressionAvailable: Enterprise Edtion" -logOnly $true
}

if ($RowCompressionAvailable -eq $true)        
{
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
}else{
$comments = 
"Row compression is only available in Enterprise Edition of versions prior to SQL Server 2016 SP1"

Comments $comments
}

Footer
