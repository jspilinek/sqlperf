function Comments{
    param (
        [Parameter(Mandatory=$true)][string]$outString
    )
    
    $htmlOut = "<br>`r`n<h2>Comments</h2>"

    foreach($line in $($outString -split "`r`n"))
    {
        $htmlOut = $htmlOut + "<p>" + $line + "</p>"
    }

    WriteToHtml $htmlOut
}

Export-ModuleMember -Function 'Comments'
