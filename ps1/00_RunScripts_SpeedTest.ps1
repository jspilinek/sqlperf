####################################################################################################################
# $Windchill is $true if WtUpgInst_VersionedAssembly table exists (getWindchillInstall.ps1 getWindchillInstall.sql)
# $ProductName AzureSQL, SQL2012, SQL2014, SQL2016, SQL2017 etc. (getProductVersion.ps1 getProductVersion.sql)
# $ProductMajorVersion SQL2014=12, SQL2016=13, SQL2017=14 etc. (getProductVersion.ps1 getProductVersion.sql)
# $compatibilityLevel compatibility_level FROM sys.databases (getCompatibilityLevel.ps1 getCompatibilityLevel.sql)
# $stats optional parameter that defaults to $true (sqlperf.ps1)
# $QueryStoreState 0=OFF 1=READ_ONLY 2=READ_WRITE 3=ERROR (getQueryStoreState.ps1 getQueryStoreState.sql)
####################################################################################################################

# $scriptArray = @()

class RunScripts {
    [string]$name
    [string]$path
    [bool]$newColumn
    [bool]$lineBreak
}

# $ProductName = "AzureSQL"

$global:prevpage = "$main_page"
$page = "$main_page"
$global:nextpage = "$main_page"
$global:currentScript = "$main_page"

$run = @([RunScripts]@{name=$main_page;path='';newColumn=$false;lineBreak=$false})


###################################################
#Column1
$run += [RunScripts]@{name='SqlVersion';path='.\ps1\SqlVersion.ps1';newColumn=$false;lineBreak=$false}
if($Windchill -eq $true){
    $run += [RunScripts]@{name='WindchillVersion';path='.\ps1\WindchillVersion.ps1';newColumn=$false;lineBreak=$false}
}
if($ProductName -ne "AzureSQL"){
    $scriptArray += 'Uptime'
    $run += [RunScripts]@{name='Uptime';path='.\ps1\Uptime.ps1';newColumn=$false;lineBreak=$false}
}

$run += [RunScripts]@{name='ImportantConfigValues';path='.\ps1\ImportantConfigValues.ps1';newColumn=$false;lineBreak=$false}
$run += [RunScripts]@{name='AllConfigValues';path='.\ps1\AllConfigValues.ps1';newColumn=$false;lineBreak=$false}
$run += [RunScripts]@{name='AutoStats';path='.\ps1\AutoStats.ps1';newColumn=$false;lineBreak=$false}

if($ProductMajorVersion -ge 14.0){
    #SQL Server 2017 or later
    $run += [RunScripts]@{name='AutoTuning';path='.\ps1\AutoTuning.ps1';newColumn=$false;lineBreak=$false}
    $run += [RunScripts]@{name='DBScopedConfigsNonDefault';path='.\ps1\DBScopedConfigsNonDefault.ps1';newColumn=$false;lineBreak=$false}
}

if($ProductMajorVersion -ge 13){
    $run += [RunScripts]@{name='DBScopedConfigs';path='.\ps1\DBScopedConfigs.ps1';newColumn=$false;lineBreak=$false}
}

$run += [RunScripts]@{name='TraceFlags';path='.\ps1\TraceFlags.ps1';newColumn=$false;lineBreak=$true}

if($ProductName -eq "AzureSQL"){
    $run += [RunScripts]@{name='ServerInfoAzure';path='.\ps1\ServerInfoAzure.ps1';newColumn=$false;lineBreak=$false}
}elseif($ProductMajorVersion -ge 14){
    $run += [RunScripts]@{name='ServerInfo';path='.\ps1\ServerInfo.ps1';newColumn=$false;lineBreak=$false}
}else{
    $run += [RunScripts]@{name='ServerInfo2016';path='.\ps1\ServerInfo2016.ps1';newColumn=$false;lineBreak=$false}
}

if($ProductName -ne "AzureSQL"){
    $run += [RunScripts]@{name='LogPath';path='.\ps1\LogPath.ps1';newColumn=$false;lineBreak=$false}
    $run += [RunScripts]@{name='Services';path='.\ps1\Services.ps1';newColumn=$false;lineBreak=$false}
}

###################################################
#Column2
$run += [RunScripts]@{name='ScalabilityInfo';path='.\ps1\ScalabilityInfo.ps1';newColumn=$true;lineBreak=$false}

$run += [RunScripts]@{name='BufferPool';path='.\ps1\BufferPool.ps1';newColumn=$false;lineBreak=$false}

if(($ProductMajorVersion -ge 12) -And ($ProductName -ne "AzureSQL")){
    $run += [RunScripts]@{name='BPE';path='.\ps1\BPE.ps1';newColumn=$false;lineBreak=$false}
}

$run += [RunScripts]@{name='PerfCounters';path='.\ps1\PerfCounters.ps1';newColumn=$false;lineBreak=$false}

if($ProductName -eq "AzureSQL"){
    $run += [RunScripts]@{name='ResourceStats';path='.\ps1\ResourceStats.ps1';newColumn=$false;lineBreak=$false}
}else{
    $scriptArray += 'CpuUtilization'
    $run += [RunScripts]@{name='CpuUtilization';path='.\ps1\CpuUtilization.ps1';newColumn=$false;lineBreak=$false}
}

$run += [RunScripts]@{name='DBInfo';path='.\ps1\DBInfo.ps1';newColumn=$false;lineBreak=$true}

if($ProductName -ne "AzureSQL"){
    $run += [RunScripts]@{name='DBFiles';path='.\ps1\DBFiles.ps1';newColumn=$false;lineBreak=$false}
    $run += [RunScripts]@{name='DiskIO';path='.\ps1\DiskIO.ps1';newColumn=$false;lineBreak=$false}
}else{
    $scriptArray += 'DiskIOAzure'
    $run += [RunScripts]@{name='DiskIOAzure';path='.\ps1\DiskIOAzure.ps1';newColumn=$false;lineBreak=$false}
}

if($ProductMajorVersion -ge 12){
    $run += [RunScripts]@{name='TransactionLog';path='.\ps1\TransactionLog.ps1';newColumn=$false;lineBreak=$false}
}else{
    $run += [RunScripts]@{name='TransactionLog2012';path='.\ps1\TransactionLog2012.ps1';newColumn=$false;lineBreak=$false}
}

$run += [RunScripts]@{name='Blobs';path='.\ps1\Blobs.ps1';newColumn=$false;lineBreak=$true}

###################################################
#Column3
if(($compatibilityLevel -ge 110) -And ($ProductMajorVersion -ge 12) -And ($ProductName -ne "AzureSQL")){
    $run += [RunScripts]@{name='Tables';path='.\ps1\Tables.ps1';newColumn=$true;lineBreak=$false}
}else{
    $run += [RunScripts]@{name='Tables2012';path='.\ps1\Tables2012.ps1';newColumn=$true;lineBreak=$false}
}
$run += [RunScripts]@{name='TransientTables';path='.\ps1\TransientTables.ps1';newColumn=$false;lineBreak=$false}
if($Windchill -eq $true){
    $run += [RunScripts]@{name='PerfTablesAge';path='.\ps1\PerfTablesAge.ps1';newColumn=$false;lineBreak=$false}
    $run += [RunScripts]@{name='QueueEntry';path='.\ps1\QueueEntry.ps1';newColumn=$false;lineBreak=$false}
}
$run += [RunScripts]@{name='UnusedPages';path='.\ps1\UnusedPages.ps1';newColumn=$false;lineBreak=$false}
$run += [RunScripts]@{name='TableLock';path='.\ps1\TableLock.ps1';newColumn=$false;lineBreak=$false}

if($ProductMajorVersion -ge 12){
    $run += [RunScripts]@{name='TablesInMemory';path='.\ps1\TablesInMemory.ps1';newColumn=$false;lineBreak=$false}
}

$run += [RunScripts]@{name='Indexes';path='.\ps1\Indexes.ps1';newColumn=$false;lineBreak=$true}
$run += [RunScripts]@{name='RowCompression';path='.\ps1\RowCompression.ps1';newColumn=$false;lineBreak=$false}
$run += [RunScripts]@{name='MissingPK';path='.\ps1\MissingPK.ps1';newColumn=$false;lineBreak=$false}

if($checkDupe -eq $true){
    $run += [RunScripts]@{name='DuplicateIndexes';path='.\ps1\DuplicateIndexes.ps1';newColumn=$false;lineBreak=$false}
}
$run += [RunScripts]@{name='FragmentedIndexes';path='.\ps1\FragmentedIndexes.ps1';newColumn=$false;lineBreak=$false}
$run += [RunScripts]@{name='FillFactor';path='.\ps1\FillFactor.ps1';newColumn=$false;lineBreak=$false}
$run += [RunScripts]@{name='DisabledIndexes';path='.\ps1\DisabledIndexes.ps1';newColumn=$false;lineBreak=$false}
$run += [RunScripts]@{name='MissingIndexes';path='.\ps1\MissingIndexes.ps1';newColumn=$false;lineBreak=$false}

$run += [RunScripts]@{name='Columns';path='.\ps1\Columns.ps1';newColumn=$false;lineBreak=$true}
if(($BuildVersion -gt 14.0) -Or ($BuildVersion -eq 14.0 -And $UpdateVersion -ge 3000.16) -Or ($BuildVersion -eq 13.0 -And $UpdateVersion -ge 4446.0)){
    #SQL Server 2017 CU1, SQL Server 2016 SP1 CU4 or later
    $run += [RunScripts]@{name='Statistics';path='.\ps1\Statistics.ps1';newColumn=$false;lineBreak=$false}
}else{
    $run += [RunScripts]@{name='Statistics2016';path='.\ps1\Statistics2016.ps1';newColumn=$false;lineBreak=$false}
}
$run += [RunScripts]@{name='StatsNoRecompute';path='.\ps1\StatsNoRecompute.ps1';newColumn=$false;lineBreak=$false}
$run += [RunScripts]@{name='StaleStats';path='.\ps1\StaleStats.ps1';newColumn=$false;lineBreak=$false}
$run += [RunScripts]@{name='NullStats';path='.\ps1\NullStats.ps1';newColumn=$false;lineBreak=$false}
$run += [RunScripts]@{name='ComputedColumns';path='.\ps1\ComputedColumns.ps1';newColumn=$false;lineBreak=$false}
$run += [RunScripts]@{name='ViewDefinitions';path='.\ps1\ViewDefinitions.ps1';newColumn=$false;lineBreak=$false}
$run += [RunScripts]@{name='Triggers';path='.\ps1\Triggers.ps1';newColumn=$false;lineBreak=$false}

###################################################
#Column4

if($ProductName -eq "AzureSQL"){
    $run += [RunScripts]@{name='AzureWaitStats';path='.\ps1\AzureWaitStats.ps1';newColumn=$true;lineBreak=$false}
}else{
    $run += [RunScripts]@{name='WaitStats';path='.\ps1\WaitStats.ps1';newColumn=$true;lineBreak=$false}
}

$run += [RunScripts]@{name='IndexUsageStats';path='.\ps1\IndexUsageStats.ps1';newColumn=$false;lineBreak=$false}

if(($ProductMajorVersion -ge 14) -and ($QueryStoreState -ne 0) -and ($QueryStoreState -ne 3)){
    $run += [RunScripts]@{name='QueryStoreWaitStats';path='.\ps1\QueryStoreWaitStats.ps1';newColumn=$false;lineBreak=$true}
    
    [string]$query = (Get-Content .\sql\QueryStoreWaitStats.sql) -join "`n"
    . .\ps1\00_executeQuery.ps1

    foreach($row in $results.tables[0]){
        [int]$category = $row.Item("wait_category")
        [string]$desc = $row.Item("wait_category_desc")
        $desc = $desc.replace(' ','')
        $run += [RunScripts]@{name="QSWait-$category-$desc";path=".\ps1\QSWaitCategory.ps1";newColumn=$false;lineBreak=$false}

    }
}

if($ProductMajorVersion -ge 13){
    $run += [RunScripts]@{name='QueryStoreOptions';path='.\ps1\QueryStoreOptions.ps1';newColumn=$false;lineBreak=$true}
}

if(($ProductMajorVersion -ge 13) -and ($QueryStoreState -ne 0) -and ($QueryStoreState -ne 3)){
    # create an empty hash table
    $global:trackedQueryIDs = @{}

    $run += [RunScripts]@{name='QueryStoreTotalSec';path='.\ps1\SpeedTest\QueryStoreTotalSec.ps1';newColumn=$false;lineBreak=$true}
    $run += [RunScripts]@{name='QueryStoreAvgSec';path='.\ps1\SpeedTest\QueryStoreAvgSec.ps1';newColumn=$false;lineBreak=$false}
    $run += [RunScripts]@{name='QueryStoreAvgCPU';path='.\ps1\SpeedTest\QueryStoreAvgCPU.ps1';newColumn=$false;lineBreak=$false}
    $run += [RunScripts]@{name='QueryStoreAvgLogicalReads';path='.\ps1\SpeedTest\QueryStoreAvgLogicalReads.ps1';newColumn=$false;lineBreak=$false}
    $run += [RunScripts]@{name='QueryStoreAvgPhysicalReads';path='.\ps1\SpeedTest\QueryStoreAvgPhysicalReads.ps1';newColumn=$false;lineBreak=$false}
    $run += [RunScripts]@{name='QueryStoreExecutions';path='.\ps1\SpeedTest\QueryStoreExecutions.ps1';newColumn=$false;lineBreak=$false}
    $run += [RunScripts]@{name='QueryStoreAvgRowCount';path='.\ps1\SpeedTest\QueryStoreAvgRowCount.ps1';newColumn=$false;lineBreak=$false}

    $run += [RunScripts]@{name='QueryStoreSqlLiterals';path='.\ps1\QueryStoreSqlLiterals.ps1';newColumn=$false;lineBreak=$true}

    if($ProductMajorVersion -ge 14){
        $run += [RunScripts]@{name='QSForcedPlans';path='.\ps1\QSForcedPlans.ps1';newColumn=$false;lineBreak=$false}
    }else{
        $run += [RunScripts]@{name='QSForcedPlans2016';path='.\ps1\QSForcedPlans2016.ps1';newColumn=$false;lineBreak=$false}
    }

    $run += [RunScripts]@{name='QueryStoreTopSql';path='.\ps1\SpeedTest\QueryStoreTopSql.ps1';newColumn=$false;lineBreak=$true}
}

###################################################
#Column5
if($ProductMajorVersion -ge 13){
    $run += [RunScripts]@{name='ActiveSql';path='.\ps1\ActiveSql.ps1';newColumn=$true;lineBreak=$false}
}else{
    $run += [RunScripts]@{name='ActiveSql2014';path='.\ps1\ActiveSql2014.ps1';newColumn=$true;lineBreak=$false}
}

$run += [RunScripts]@{name='SqlByElapsedTime';path='.\ps1\SqlByElapsedTime.ps1';newColumn=$false;lineBreak=$true}
$run += [RunScripts]@{name='SqlByAverageElapsedTime';path='.\ps1\SqlByAverageElapsedTime.ps1';newColumn=$false;lineBreak=$false}
$run += [RunScripts]@{name='SqlByLogicalReads';path='.\ps1\SqlByLogicalReads.ps1';newColumn=$false;lineBreak=$false}
$run += [RunScripts]@{name='SqlByPhysicalReads';path='.\ps1\SqlByPhysicalReads.ps1';newColumn=$false;lineBreak=$false}
$run += [RunScripts]@{name='SqlByExecutionCount';path='.\ps1\SqlByExecutionCount.ps1';newColumn=$false;lineBreak=$false}
$run += [RunScripts]@{name='SqlByRowCount';path='.\ps1\SqlByRowCount.ps1';newColumn=$false;lineBreak=$false}
$run += [RunScripts]@{name='FullSqlTextAndPlans';path='.\ps1\FullSqlTextAndPlans.ps1';newColumn=$false;lineBreak=$false}

$run += [RunScripts]@{name='ProceduresByTotalSec';path='.\ps1\ProceduresByTotalSec.ps1';newColumn=$false;lineBreak=$true}
$run += [RunScripts]@{name='ProceduresByLogicalReads';path='.\ps1\ProceduresByLogicalReads.ps1';newColumn=$false;lineBreak=$false}

if($stats -eq $true){
    $scriptArray += 'ShowStatistics'
    $run += [RunScripts]@{name='ShowStatistics';path='.\ps1\ShowStatistics.ps1';newColumn=$false;lineBreak=$true}
}

###################################################
# Add main page to end of array

$run += [RunScripts]@{name=$main_page;path='';newColumn=$false;lineBreak=$false}

###################################################

# "Length: $($run.Length)"

for ($i = 1 ; $i -lt $($run.Length) - 1; $i++)
{
    $global:execute_time = Get-Date -format $dateFormat
    $StopWatch = [system.diagnostics.stopwatch]::startNew()

    # "i: $i"
    # $script = $run[$i].name
    $global:currentScript = $run[$i].name
    $global:nextpage = $run[$i+1].name + ".html"
    $global:prevpage = $run[$i-1].name + ".html"
    # $run[$i]
    # "Prev: $prevpage Current: $script Next: $nextpage"

    $path = $run[$i].path

    $global:headerLineBreak = $run[$i].lineBreak
    $global:headerNewColumn = $run[$i].newColumn

    if($currentScript.StartsWith("QSWait-") -eq $true){
        $items = $currentScript.split("-")
        $category = $items[1]
        $desc = $items[2]
        $path = ".\ps1\QSWaitCategory.ps1"
        & $path -category $category -desc $desc
    }else{
        & $path
    }


    $StopWatch.Stop()
    $elapsed = [math]::Round($StopWatch.Elapsed.TotalSeconds,1)
    
    DebugLog "$path done in $elapsed seconds" -logOnly $true
}

# $global:prevpage = "$main_page"
# $global:nextpage = "$main_page"
# $global:currentScript = "$main_page"

# [bool]$first = $false
# foreach ($script in $scriptArray)
# {
#     $next = $script
#     $global:nextpage = "$script.html"
    
#     if($first -eq $true){
#         # "$prevpage $currentScript $nextpage"
        
#         $global:execute_time = Get-Date -format $dateFormat
#         $StopWatch = [system.diagnostics.stopwatch]::startNew()
        
#         if($currentScript.StartsWith("QSWait-") -eq $true){
#             $items = $currentScript.split("-")
#             $category = $items[1]
#             $desc = $items[2]

#             $path = ".\ps1\QSWaitCategory.ps1"
#             & $path -category $category -desc $desc
#         }else{
#             $path = ".\ps1\$currentScript.ps1"
#             & $path
#         }
        
#         $StopWatch.Stop()
#         $elapsed = [math]::Round($StopWatch.Elapsed.TotalSeconds,1)
        
#         DebugLog "$path done in $elapsed seconds" -logOnly $true

#     }else{
#         $first = $true
#     }
    
#     $prev = $currentScript
#     $global:prevpage = "$currentScript.html"
#     $global:currentScript = $next
# }
