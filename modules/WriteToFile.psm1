function WriteToFile
{
    param(
        [Parameter(Mandatory=$true)][string]$path,
        [Parameter(Mandatory=$true)][string]$outString,
        # [bool]$textOutput = $false,
        # [bool]$LogDebug = $false,
        # [bool]$mainPage = $false,
        [Parameter(Mandatory=$true)][bool]$NoNewline = $false
    )
    
<#     if($LogDebug -eq $true){
        $path = ".\html\debug.txt"
    }elseif($mainPage -eq $true){
        $path = ".\html\00_sqlperf.html"
    }elseif($textOutput -eq $true){
        $path = ".\html\$currentScript.txt"
    }else{
        $path = ".\html\$currentScript.html"
    } #>
    
    if($NoNewline){
        $outString | Out-File -Encoding Ascii $path -Append -NoNewline
    }else{
        $outString | Out-File -Encoding Ascii $path -Append
    }
}

function WriteToHtml
{
    param(
        [Parameter(Mandatory=$true)][string]$outString,
        [bool]$NoNewline = $false
    )
    
    $path = ".\html\$currentScript.html"
    
    WriteToFile -path $path -outString $outString -NoNewline $NoNewline
}

function WriteToText
{
    param(
        [Parameter(Mandatory=$true)][string]$outString,
        [bool]$NoNewline = $false
    )
    
    $path = ".\html\$currentScript.txt"
    
    WriteToFile -path $path -outString $outString -NoNewline $NoNewline
}

function WriteToMainPage
{
    param(
        [Parameter(Mandatory=$true)][string]$outString,
        [bool]$NoNewline = $false
    )
    
    $path = ".\html\00_sqlperf.html"
    
    WriteToFile -path $path -outString $outString -NoNewline $NoNewline
}

function WriteToDebugLog
{
    param(
        [Parameter(Mandatory=$true)][string]$outString,
        [bool]$NoNewline = $false
    )
    
    $path = ".\html\debug.txt"
    
    WriteToFile -path $path -outString $outString -NoNewline $NoNewline
}

function WriteToFileNewline
{
    param([Parameter(Mandatory=$true)][string]$outFile)
    
    "" | Out-File -Encoding Ascii $outFile -Append
}

function Header
{
    param (
        [Parameter(Mandatory=$true)][string]$title,
        [string]$text = $false,
        [bool]$lineBreak = $false,
        [bool]$newColumn = $false
    )
    
    $htmlfile = "$currentScript.html"
    $textfile = "$currentScript.txt"
    $path = ".\html\$htmlfile"

    if($text -eq $false){
        DebugLog "Generating $htmlfile"
    }else{
        $textfile = "$currentScript.txt"
        DebugLog "Generating $htmlfile and $textfile"
        NewTextFile
    }

$htmlOut = "
<!DOCTYPE html>
<html>
<head>
<title>$title</title>
<link rel='stylesheet' type='text/css' href='sqlperf.css'/>
<script src='sorttable.js'></script>
</head>
<body>
<h1>$title</h1>
<hr>
<br>
<a href='00_sqlperf.html'>Back to main page</a>
<br>
[<a href='$prevpage'>Prev</a>] [<a href='$nextpage'>Next</a>]
<br>
<br>
"

    Set-Content -Path $path -Value $htmlOut

    ########################################################
    #Add link to 00_sqlperf.html

    if($lineBreak -eq $true){
        $htmlOut = "
        <br>
        "
        WriteToMainPage $htmlOut
    }

    if($newColumn -eq $true){
        $htmlOut = "
        </ul></td><td><ul>
        "
        WriteToMainPage $htmlOut
    }

    if($text -eq $true){
        $htmlOut = "
        <li>$title <a href='$htmlfile'>html</a> <a href='$textfile'>txt</a></li>
        "
        WriteToMainPage $htmlOut
    }else{
        $htmlOut = "
        <li><a href='$htmlfile'>$title</a></li>
        "
        WriteToMainPage $htmlOut
    }
}

function Footer
{
$htmlOut = "
<br>
<a href='00_sqlperf.html'>Back to main page</a>
<br>
[<a href='$prevpage'>Prev</a>] [<a href='$nextpage'>Next</a>]
<br>
<br>
<footer>$script_name generated $execute_time </footer>
</body>
</html>
"

    WriteToHtml $htmlOut
}

function NewTextFile
{
    $textpath = ".\html\$currentScript.txt"
    Set-Content -Path $textpath -Value ""
}

Export-ModuleMember -Function 'WriteTo*'
Export-ModuleMember -Function 'Header'
Export-ModuleMember -Function 'Footer'