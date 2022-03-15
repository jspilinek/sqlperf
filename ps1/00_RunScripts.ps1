####################################################################################################################
# $Windchill is $true if WtUpgInst_VersionedAssembly table exists (getWindchillInstall.ps1 getWindchillInstall.sql)
# $ProductName AzureSQL, SQL2012, SQL2014, SQL2016, SQL2017 etc. (getProductVersion.ps1 getProductVersion.sql)
# $ProductMajorVersion SQL2014=12, SQL2016=13, SQL2017=14 etc. (getProductVersion.ps1 getProductVersion.sql)
# $compatibilityLevel compatibility_level FROM sys.databases (getCompatibilityLevel.ps1 getCompatibilityLevel.sql)
# $stats optional parameter that defaults to $true (sqlperf.ps1)
# $QueryStoreState 0=OFF 1=READ_ONLY 2=READ_WRITE 3=ERROR (getQueryStoreState.ps1 getQueryStoreState.sql)
####################################################################################################################

$scriptArray = @()

# $ProductName = "AzureSQL"

$global:prevpage = "$main_page"
$page = "$main_page"
$global:nextpage = "$main_page"
$global:currentScript = "$main_page"

###################################################
#Column1

$scriptArray += 'SqlVersion'
if($Windchill -eq $true){
    $scriptArray += 'WindchillVersion'
}
if($ProductName -ne "AzureSQL"){
    $scriptArray += 'Uptime'
}
$scriptArray += 'ImportantConfigValues'
$scriptArray += 'AllConfigValues'
$scriptArray += 'AutoStats'

if($ProductMajorVersion -ge 14.0){
    #SQL Server 2017 or later
    $scriptArray += 'AutoTuning'
    $scriptArray += 'DBScopedConfigsNonDefault'
}

if($ProductMajorVersion -ge 13){
    $scriptArray += 'DBScopedConfigs'
}

$scriptArray += 'TraceFlags'

if($ProductName -eq "AzureSQL"){
    $scriptArray += 'ServerInfoAzure'
}elseif($ProductMajorVersion -ge 14){
    $scriptArray += 'ServerInfo'
}else{
    $scriptArray += 'ServerInfo2016'
}

if($ProductName -ne "AzureSQL"){
    $scriptArray += 'LogPath'
    $scriptArray += 'Services'
}
###################################################
#Column2

$scriptArray += 'ScalabilityInfo'
$scriptArray += 'BufferPool'

if(($ProductMajorVersion -ge 12) -And ($ProductName -ne "AzureSQL")){
    $scriptArray += 'BPE'
}

$scriptArray += 'PerfCounters'

if($ProductName -eq "AzureSQL"){
    $scriptArray += 'ResourceStats'
}else{
    $scriptArray += 'CpuUtilization'
}

$scriptArray += 'DBInfo'

if($ProductName -ne "AzureSQL"){
    $scriptArray += 'DBFiles'
    $scriptArray += 'DiskIO'
}else{
    $scriptArray += 'DiskIOAzure'
}

if($ProductMajorVersion -ge 12){
    $scriptArray += 'TransactionLog'
}else{
    $scriptArray += 'TransactionLog2012'
}

$scriptArray += 'Blobs'


###################################################
#Column3

if(($compatibilityLevel -ge 110) -And ($ProductMajorVersion -ge 12) -And ($ProductName -ne "AzureSQL")){
    $scriptArray += 'Tables'
}else{
    $scriptArray += 'Tables2012'
}
$scriptArray += 'TransientTables'
if($Windchill -eq $true){
    $scriptArray += 'PerfTablesAge'
    $scriptArray += 'QueueEntry'
}
$scriptArray += 'UnusedPages'
$scriptArray += 'TableLock'

if($ProductMajorVersion -ge 12){
    $scriptArray += 'TablesInMemory'
}

$scriptArray += 'Indexes'
$scriptArray += 'RowCompression'
$scriptArray += 'MissingPK'

if($checkDupe -eq $true){
    $scriptArray += 'DuplicateIndexes'
}
$scriptArray += 'FragmentedIndexes'
$scriptArray += 'FillFactor'
$scriptArray += 'DisabledIndexes'
$scriptArray += 'MissingIndexes'

$scriptArray += 'Columns'
if(($BuildVersion -gt 14.0) -Or ($BuildVersion -eq 14.0 -And $UpdateVersion -ge 3000.16) -Or ($BuildVersion -eq 13.0 -And $UpdateVersion -ge 4446.0)){
    #SQL Server 2017 CU1, SQL Server 2016 SP1 CU4 or later
    $scriptArray += 'Statistics'
}else{
    $scriptArray += 'Statistics2016'
}
$scriptArray += 'StatsNoRecompute'
$scriptArray += 'StaleStats'
$scriptArray += 'NullStats'
$scriptArray += 'ComputedColumns'
$scriptArray += 'ViewDefinitions'
$scriptArray += 'Triggers'

###################################################
#Column4

if($ProductName -eq "AzureSQL"){
    $scriptArray += 'AzureWaitStats'
}else{
    $scriptArray += 'WaitStats'
}

$scriptArray += 'IndexUsageStats'

if(($ProductMajorVersion -ge 14) -and ($QueryStoreState -ne 0) -and ($QueryStoreState -ne 3)){
    $scriptArray += 'QueryStoreWaitStats'
    
    [string]$query = (Get-Content .\sql\QueryStoreWaitStats.sql) -join "`n"
    . .\ps1\00_executeQuery.ps1

    foreach($row in $results.tables[0]){
        [int]$category = $row.Item("wait_category")
        [string]$desc = $row.Item("wait_category_desc")
        $desc = $desc.replace(' ','')
        $scriptArray += "QSWait-$category-$desc"
    }
}

if($ProductMajorVersion -ge 13){
    $scriptArray += 'QueryStoreOptions'
}

if(($ProductMajorVersion -ge 13) -and ($QueryStoreState -ne 0) -and ($QueryStoreState -ne 3)){
    $scriptArray += 'QueryStoreTotalSec'
    $scriptArray += 'QueryStoreAvgSec'
    $scriptArray += 'QueryStoreAvgCPU'
    $scriptArray += 'QueryStoreAvgLogicalIO'
    $scriptArray += 'QueryStoreAvgPhysicalIO'
    $scriptArray += 'QueryStoreExecutions'
    $scriptArray += 'QueryStoreAvgRowCount'
    
    $scriptArray += 'QueryStoreSqlLiterals'
    $scriptArray += 'QueryStoreDml'

    if($ProductMajorVersion -ge 14){
        $scriptArray += 'QSForcedPlans'
    }else{
        $scriptArray += 'QSForcedPlans2016'
    }
    
    $scriptArray += 'QueryStoreTopSql' 
}

###################################################
#Column5

if($ProductMajorVersion -ge 13){
    $scriptArray += 'ActiveSql'
}else{
    $scriptArray += 'ActiveSql2014'
}

$scriptArray += 'SqlByElapsedTime'
$scriptArray += 'SqlByAverageElapsedTime'
$scriptArray += 'SqlByLogicalReads'
$scriptArray += 'SqlByPhysicalReads'
$scriptArray += 'SqlByExecutionCount'
$scriptArray += 'SqlByRowCount'
$scriptArray += 'FullSqlTextAndPlans'

$scriptArray += 'ProceduresByTotalSec'
$scriptArray += 'ProceduresByLogicalReads'

if($stats -eq $true){
    $scriptArray += 'ShowStatistics'
}

###################################################

$scriptArray += $main_page

###################################################

[bool]$first = $false
foreach ($script in $scriptArray)
{
    $next = $script
    $global:nextpage = "$script.html"
    
    if($first -eq $true){
        # "$prevpage $currentScript $nextpage"
        
        $global:execute_time = Get-Date -format "yyyy-MM-dd HH:mm:ss"
        $StopWatch = [system.diagnostics.stopwatch]::startNew()
        
        if($currentScript.StartsWith("QSWait-") -eq $true){
            $items = $currentScript.split("-")
            $category = $items[1]
            $desc = $items[2]

            $path = ".\ps1\QSWaitCategory.ps1"
            & $path -category $category -desc $desc
        }else{
            $path = ".\ps1\$currentScript.ps1"
            & $path
        }
        
        $StopWatch.Stop()
        $elapsed = [math]::Round($StopWatch.Elapsed.TotalSeconds,1)
        
        DebugLog "$path done in $elapsed seconds" -logOnly $true

    }else{
        $first = $true
    }
    
    $prev = $currentScript
    $global:prevpage = "$currentScript.html"
    $global:currentScript = $next
}
