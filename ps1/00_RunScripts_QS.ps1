####################################################################################################################
# $Windchill is $true if WtUpgInst_VersionedAssembly table exists (getWindchillInstall.ps1 getWindchillInstall.sql)
# $ProductName AzureSQL, SQL2012, SQL2014, SQL2016, SQL2017 etc. (getProductVersion.ps1 getProductVersion.sql)
# $ProductMajorVersion SQL2014=12, SQL2016=13, SQL2017=14 etc. (getProductVersion.ps1 getProductVersion.sql)
# $compatibilityLevel compatibility_level FROM sys.databases (getCompatibilityLevel.ps1 getCompatibilityLevel.sql)
# $QueryStoreState 0=OFF 1=READ_ONLY 2=READ_WRITE 3=ERROR (getQueryStoreState.ps1 getQueryStoreState.sql)
####################################################################################################################

$scriptArray = @()

$global:prevpage = "$main_page"
$page = "$main_page"
$global:nextpage = "$main_page"
$global:currentScript = "$main_page"

###################################################
#Column1

$scriptArray += 'SqlVersion_QS'

if($ProductMajorVersion -ge 13){
    $scriptArray += 'QueryStoreOptions'
}

###################################################
#Column2

if(($ProductMajorVersion -ge 14) -and ($QueryStoreState -ne 0) -and ($QueryStoreState -ne 3)){
    $scriptArray += 'QueryStoreWaitStats_QS'
    
    [string]$query = (Get-Content .\sql\QueryStoreWaitStats.sql) -join "`n"
    . .\ps1\00_executeQuery.ps1

    foreach($row in $results.tables[0]){
        [int]$category = $row.Item("wait_category")
        [string]$desc = $row.Item("wait_category_desc")
        $desc = $desc.replace(' ','')
        $scriptArray += "QSWait-$category-$desc"
    }

}

###################################################
#Column3

if(($ProductMajorVersion -ge 13) -and ($QueryStoreState -ne 0) -and ($QueryStoreState -ne 3)){
    $scriptArray += 'QueryStoreTotalSec_QS'
    $scriptArray += 'QueryStoreAvgSec'
    $scriptArray += 'QueryStoreAvgCPU'
    $scriptArray += 'QueryStoreAvgLogicalIO'
    $scriptArray += 'QueryStoreAvgPhysicalIO'
    $scriptArray += 'QueryStoreExecutions'
    $scriptArray += 'QueryStoreAvgRowCount'
    
    #$scriptArray += 'QueryStoreSqlLiterals'
    $scriptArray += 'QueryStoreDml'
    
    if($ProductMajorVersion -ge 14){
        $scriptArray += 'QSForcedPlans'
    }else{
        $scriptArray += 'QSForcedPlans2016'
    }
    
    $scriptArray += 'QueryStoreTopSql'
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
        
        $global:execute_time = Get-Date -format $dateFormat
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
