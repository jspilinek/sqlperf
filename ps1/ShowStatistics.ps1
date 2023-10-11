if(Test-Path .\sql\99_ShowStatistics.sql -PathType leaf){

$title = "Show Statistics"
$textpath = ".\html\$currentScript.txt"

Header $title -text $true -lineBreak $true
Set-Content -Path $textpath -Value "*******************************************************************************************************************"

# "<please wait...>"

InitProgressBar -Steps (Get-Content .\sql\99_ShowStatistics.sql).Count -Activity $title
foreach($query in Get-Content .\sql\99_ShowStatistics.sql){
    if($query){
        . .\ps1\00_executeQuery.ps1
        WriteToHtml "<p>$query</p>"
        WriteToText "$query"

        .\ps1\00_TableToHtml.ps1 -tableID 0 -textOutput $true
        .\ps1\00_TableToHtml.ps1 -tableID 1 -textOutput $true
        .\ps1\00_TableToHtml.ps1 -tableID 2 -textOutput $true -htmlOutput $false
        
        WriteToHtml "<hr>"
        WriteToText "*******************************************************************************************************************"
    }
    UpdateProgressBar
}

CompleteProgressBar

Footer

}