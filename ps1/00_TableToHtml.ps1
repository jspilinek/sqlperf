param (
    [Parameter(Mandatory=$true)][int]$tableID,
    [string]$excludeAdditionalColumns = "",
    [bool]$sortable = $true,
    [bool]$htmlOutput = $true,
    [bool]$textOutput = $false,
    [bool]$link = $false,
    [string]$TableOrList = "table"
)

#Add-HTMLTableAttribute used to add class='sortable' to the <table> tag
Function Add-HTMLTableAttribute
{
    Param
    (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [string]
        $HTML,
    
        [Parameter(Mandatory=$true)]
        [string]
        $AttributeName,
    
        [Parameter(Mandatory=$true)]
        [string]
        $Value

    )

    Try{
        $xml=[xml]$HTML
        $attr=$xml.CreateAttribute($AttributeName)
        $attr.Value=$Value
        $xml.table.Attributes.Append($attr) | Out-Null
        Return ($xml.OuterXML | out-string)
    }Catch{
        LogException $_.Exception $error[0].ScriptStackTrace "Failure in Add-HTMLTableAttribute"
        DebugLog "HTML: $HTML" -logOnly $true
        DebugLog "AttributeName: $AttributeName" -logOnly $true
        DebugLog "Value: $Value" -logOnly $true
    }
}

$excludeColumns = "RowError, RowState, Table, ItemArray, HasErrors, $excludeAdditionalColumns" -split ", "

$path = ".\html\$currentScript.html"
$textpath = ".\html\$currentScript.txt"

if($htmlOutput -eq $false){
    $textOutput = $true
}

if($results -eq $null){
    $rowcount = 0
}else{
    $rowcount = @($results.tables[$tableID]).count
}

if($failedQuery){
    if($htmlOutput -eq $true){
        WriteToHtml "<p class='failedQuery'>Failed to execute query:</p>"
        WriteToHtml "<p class='failedQuery'>$query</p>"
        WriteToHtml "<p class='failedQuery'> Refer to <a href='debug.txt'>debug.txt</a> for details"
    }

    if($textOutput -eq $true){
        WriteToText "Failed to execute query:"
        WriteToText $query
        WriteToText "Refer to debug.txt for details"
    }
}elseif($rowcount -eq 0 -Or !$results.tables[$tableID]){
    if($htmlOutput -eq $true){
        WriteToHtml "Zero rows found <br>"
    }

    if($textOutput -eq $true){
        WriteToText "Zero rows found"
    }
}else{
    if($htmlOutput -eq $true){
        if($sortable -eq $true){
            if($link -eq $false){
                #$results.tables[$tableID] | select $columns -ExcludeProperty $excludeColumns | ConvertTo-Html -As $TableOrList -Fragment | Out-String | Add-HTMLTableAttribute -AttributeName 'class' -Value 'sortable' | Out-File -encoding ASCII -append -FilePath $path
                $outString = $results.tables[$tableID] | select $columns -ExcludeProperty $excludeColumns | ConvertTo-Html -As $TableOrList -Fragment | Out-String | Add-HTMLTableAttribute -AttributeName 'class' -Value 'sortable'
                WriteToHtml $outString
            }else{
                $html = $results.tables[$tableID] | select $columns -ExcludeProperty $excludeColumns | ConvertTo-Html -As $TableOrList -Fragment -Property *
                Add-Type -AssemblyName System.Web
                #[System.Web.HttpUtility]::HtmlDecode($html) | Out-String | Add-HTMLTableAttribute -AttributeName 'class' -Value 'sortable' | Out-File -encoding ASCII -append -FilePath $path
                $outString = [System.Web.HttpUtility]::HtmlDecode($html) | Out-String | Add-HTMLTableAttribute -AttributeName 'class' -Value 'sortable'
                WriteToHtml $outString
            }
        }else{
            #$results.tables[$tableID] | select $columns -ExcludeProperty $excludeColumns | ConvertTo-Html -As $TableOrList -Fragment | Out-File -encoding ASCII -append -FilePath $path
            $outString = $results.tables[$tableID] | select $columns -ExcludeProperty $excludeColumns | ConvertTo-Html -As $TableOrList -Fragment
            WriteToHtml $outString
        }
    }

    if($textOutput -eq $true){
        #$results.tables[$tableID] | select $columns -ExcludeProperty $excludeColumns | Format-Table -Property * -AutoSize | Out-String -Width 4096 | Out-File -encoding ASCII -append -FilePath $textpath
        $outString = $results.tables[$tableID] | select $columns -ExcludeProperty $excludeColumns | Format-Table -Property * -AutoSize | Out-String -Width 4096
        WriteToText $outString 
    }
}