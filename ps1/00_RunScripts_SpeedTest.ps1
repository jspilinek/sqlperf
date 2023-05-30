####################################################################################################################
# $Windchill is $true if WtUpgInst_VersionedAssembly table exists (getWindchillInstall.ps1 getWindchillInstall.sql)
# $ProductName AzureSQL, SQL2012, SQL2014, SQL2016, SQL2017 etc. (getProductVersion.ps1 getProductVersion.sql)
# $ProductMajorVersion SQL2014=12, SQL2016=13, SQL2017=14 etc. (getProductVersion.ps1 getProductVersion.sql)
# $compatibilityLevel compatibility_level FROM sys.databases (getCompatibilityLevel.ps1 getCompatibilityLevel.sql)
# $stats optional parameter that defaults to $true (sqlperf.ps1)
# $QueryStoreState 0=OFF 1=READ_ONLY 2=READ_WRITE 3=ERROR (getQueryStoreState.ps1 getQueryStoreState.sql)
####################################################################################################################

$scriptArray = @()

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

###################################################
#Column2


###################################################
#Column3



###################################################
#Column4

# if($ProductName -eq "AzureSQL"){
#     $scriptArray += 'AzureWaitStats'
# }else{
#     $scriptArray += 'WaitStats'
# }

# $scriptArray += 'IndexUsageStats'

# if(($ProductMajorVersion -ge 14) -and ($QueryStoreState -ne 0) -and ($QueryStoreState -ne 3)){
#     $scriptArray += 'QueryStoreWaitStats'
    
#     [string]$query = (Get-Content .\sql\QueryStoreWaitStats.sql) -join "`n"
#     . .\ps1\00_executeQuery.ps1

#     foreach($row in $results.tables[0]){
#         [int]$category = $row.Item("wait_category")
#         [string]$desc = $row.Item("wait_category_desc")
#         $desc = $desc.replace(' ','')
#         $scriptArray += "QSWait-$category-$desc"
#     }
# }

if($ProductMajorVersion -ge 13){
    $run += [RunScripts]@{name='QueryStoreOptions';path='.\ps1\QueryStoreOptions.ps1';newColumn=$false;lineBreak=$false}
}

if(($ProductMajorVersion -ge 13) -and ($QueryStoreState -ne 0) -and ($QueryStoreState -ne 3)){
    $run += [RunScripts]@{name='QueryStoreTotalSec';path='.\ps1\SpeedTest\QueryStoreTotalSec.ps1';newColumn=$false;lineBreak=$false}
    $run += [RunScripts]@{name='QueryStoreAvgSec';path='.\ps1\SpeedTest\QueryStoreAvgSec.ps1';newColumn=$false;lineBreak=$false}
    $run += [RunScripts]@{name='QueryStoreAvgCPU';path='.\ps1\SpeedTest\QueryStoreAvgCPU.ps1';newColumn=$false;lineBreak=$false}
    $run += [RunScripts]@{name='QueryStoreAvgLogicalReads';path='.\ps1\SpeedTest\QueryStoreAvgLogicalReads.ps1';newColumn=$false;lineBreak=$false}
    $run += [RunScripts]@{name='QueryStoreAvgPhysicalReads';path='.\ps1\SpeedTest\QueryStoreAvgPhysicalReads.ps1';newColumn=$false;lineBreak=$false}
    $run += [RunScripts]@{name='QueryStoreExecutions';path='.\ps1\SpeedTest\QueryStoreExecutions.ps1';newColumn=$false;lineBreak=$false}
    $run += [RunScripts]@{name='QueryStoreAvgRowCount';path='.\ps1\SpeedTest\QueryStoreAvgRowCount.ps1';newColumn=$false;lineBreak=$false}
    
    # $scriptArray += 'QueryStoreAvgSec'
    # $scriptArray += 'QueryStoreAvgCPU'
    # $scriptArray += 'QueryStoreAvgLogicalIO'
    # $scriptArray += 'QueryStoreAvgPhysicalIO'
    # $scriptArray += 'QueryStoreExecutions'
    # $scriptArray += 'QueryStoreAvgRowCount'
    
    # $scriptArray += 'QueryStoreSqlLiterals'
    # $scriptArray += 'QueryStoreDml'

    # if($ProductMajorVersion -ge 14){
    #     $scriptArray += 'QSForcedPlans'
    # }else{
    #     $scriptArray += 'QSForcedPlans2016'
    # }
    
    # $scriptArray += 'QueryStoreTopSql' 
}

###################################################
#Column5


###################################################

$scriptArray += $main_page
$run += [RunScripts]@{name=$main_page;path='';newColumn=$false;lineBreak=$false}

###################################################

# "Length: $($run.Length)"

for ($i = 1 ; $i -lt $($run.Length) - 1; $i++)
{
    # "i: $i"
    # $script = $run[$i].name
    $global:currentScript = $run[$i].name
    $global:nextpage = $run[$i+1].name + ".html"
    $global:prevpage = $run[$i-1].name + ".html"
    # $run[$i]
    # "Prev: $prevpage Current: $script Next: $nextpage"

    $path = $run[$i].path
    & $path

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
