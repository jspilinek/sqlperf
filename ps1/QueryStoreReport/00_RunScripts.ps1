####################################################################################################################
# $Windchill is $true if WtUpgInst_VersionedAssembly table exists (getWindchillInstall.ps1 getWindchillInstall.sql)
# $ProductName AzureSQL, SQL2012, SQL2014, SQL2016, SQL2017 etc. (getProductVersion.ps1 getProductVersion.sql)
# $ProductMajorVersion SQL2014=12, SQL2016=13, SQL2017=14 etc. (getProductVersion.ps1 getProductVersion.sql)
# $compatibilityLevel compatibility_level FROM sys.databases (getCompatibilityLevel.ps1 getCompatibilityLevel.sql)
# $QueryStoreState 0=OFF 1=READ_ONLY 2=READ_WRITE 3=ERROR (getQueryStoreState.ps1 getQueryStoreState.sql)
####################################################################################################################

class RunScripts {
    [string]$name
    [string]$path
    [bool]$newColumn
    [bool]$lineBreak
}

$global:prevpage = "$main_page"
$page = "$main_page"
$global:nextpage = "$main_page"
$global:currentScript = "$main_page"

$run = @([RunScripts]@{name=$main_page;path='';newColumn=$false;lineBreak=$false})


###################################################
#Column1

$run += [RunScripts]@{name='SqlVersion';path='.\ps1\QueryStoreReport\SqlVersion.ps1';newColumn=$false;lineBreak=$true}

if($ProductMajorVersion -ge 13){
    $run += [RunScripts]@{name='QueryStoreOptions';path='.\ps1\QueryStoreOptions.ps1';newColumn=$false;lineBreak=$true}
}

###################################################
#Column2

if(($ProductMajorVersion -ge 14) -and ($QueryStoreState -ne 0) -and ($QueryStoreState -ne 3)){
    $run += [RunScripts]@{name='QueryStoreWaitStats';path='.\ps1\QueryStoreReport\QueryStoreWaitStats.ps1';newColumn=$true;lineBreak=$false}

    [string]$query = (Get-Content .\sql\QueryStoreWaitStats.sql) -join "`n"
    . .\ps1\00_executeQuery.ps1

    foreach($row in $results.tables[0]){
        [int]$category = $row.Item("wait_category")
        [string]$desc = $row.Item("wait_category_desc")
        $desc = $desc.replace(' ','')
        $run += [RunScripts]@{name="QSWait-$category-$desc";path=".\ps1\QSWaitCategory.ps1";newColumn=$false;lineBreak=$false}

    }
}

###################################################
#Column3

if(($ProductMajorVersion -ge 13) -and ($QueryStoreState -ne 0) -and ($QueryStoreState -ne 3)){
    $run += [RunScripts]@{name='QueryStoreTotalSec';path='.\ps1\QueryStoreReport\QueryStoreTotalSec.ps1';newColumn=$true;lineBreak=$false}
    $run += [RunScripts]@{name='QueryStoreAvgSec';path='.\ps1\QueryStore\QueryStoreAvgSec.ps1';newColumn=$false;lineBreak=$false}
    $run += [RunScripts]@{name='QueryStoreAvgCPU';path='.\ps1\QueryStore\QueryStoreAvgCPU.ps1';newColumn=$false;lineBreak=$false}
    $run += [RunScripts]@{name='QueryStoreAvgLogicalReads';path='.\ps1\QueryStore\QueryStoreAvgLogicalReads.ps1';newColumn=$false;lineBreak=$false}
    $run += [RunScripts]@{name='QueryStoreAvgPhysicalReads';path='.\ps1\QueryStore\QueryStoreAvgPhysicalReads.ps1';newColumn=$false;lineBreak=$false}
    $run += [RunScripts]@{name='QueryStoreExecutions';path='.\ps1\QueryStore\QueryStoreExecutions.ps1';newColumn=$false;lineBreak=$false}
    $run += [RunScripts]@{name='QueryStoreAvgRowCount';path='.\ps1\QueryStore\QueryStoreAvgRowCount.ps1';newColumn=$false;lineBreak=$false}

    
    $run += [RunScripts]@{name='QueryStoreSqlLiterals';path='.\ps1\QueryStoreSqlLiterals.ps1';newColumn=$false;lineBreak=$true}
    $run += [RunScripts]@{name='QueryStoreDml';path='.\ps1\QueryStoreDml.ps1';newColumn=$false;lineBreak=$false}

    if($ProductMajorVersion -ge 14){
        $run += [RunScripts]@{name='QSForcedPlans';path='.\ps1\QSForcedPlans.ps1';newColumn=$false;lineBreak=$false}
    }else{
        $run += [RunScripts]@{name='QSForcedPlans';path='.\ps1\2016\QSForcedPlans2016.ps1';newColumn=$false;lineBreak=$false}
    }
    
    $run += [RunScripts]@{name='QueryStoreTopSql';path='.\ps1\QueryStore\QueryStoreTopSql.ps1';newColumn=$false;lineBreak=$true}
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
