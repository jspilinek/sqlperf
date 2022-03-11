$title = "Statistics"

Header $title -text $true

[string]$query = (Get-Content .\sql\Statistics.sql) -join "`n"
. .\ps1\00_executeQuery.ps1

.\ps1\00_TableToHtml.ps1 -tableID 0 -textOutput $true

#If Statistics.sql timed out, then don't generate 99_ShowStatistics.sql
if($results -And $results.tables[0]){
    DebugLog "Generating 99_ShowStatistics.sql"
    Set-Content -Path ".\sql\99_ShowStatistics.sql" -Value ""
    foreach($row in $results.tables[0]){
        if($row.Item("Stat Name").substring(0,3) -ne "PK_"){
            WriteToFile -path ".\sql\99_ShowStatistics.sql" $row.Item("SHOW_STATISTICS_COMMAND")  -NoNewline $false
        }
    }
}

Footer
