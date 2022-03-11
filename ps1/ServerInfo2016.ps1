$title = "Server Information"

Header $title

[string]$ServerInfo = (Get-Content .\sql\ServerInfo.sql) -join "`n"
[string]$SysInfo = (Get-Content .\sql\SysInfo.sql) -join "`n"
[string]$SysInfoFormatted = (Get-Content .\sql\SysInfoFormatted.sql) -join "`n"
[string]$SysMemory = (Get-Content .\sql\SysMemory.sql) -join "`n"
[string]$NumaNodes = (Get-Content .\sql\2016\NumaNodes.sql) -join "`n"
[string]$ProcessorInfo = Get-Content .\sql\ProcessorInfo.sql

[string]$query = $ServerInfo + $SysInfo + $SysInfoFormatted + $SysMemory + $NumaNodes + $ProcessorInfo
. .\ps1\00_executeQuery.ps1

.\ps1\00_TableToHtml.ps1 -tableID 0

#########################################################################################
$htmlOut = "
<br>
<hr>
<br>
<h1>sys.dm_os_sys_info</h1>
<br>
"
WriteToHtml $htmlOut
.\ps1\00_TableToHtml.ps1 -tableID 1 -TableOrList list

#########################################################################################
$htmlOut = "
<br>
<hr>
<br>
<h1>Formatted sys.dm_os_sys_info</h1>
<br>
"
WriteToHtml $htmlOut
.\ps1\00_TableToHtml.ps1 -tableID 2

$comments = 
"<b>MaxDOP</b> Recommendations <a href='https://support.microsoft.com/en-us/kb/2806535'>https://support.microsoft.com/en-us/kb/2806535</a>
<ul><li>Server with single NUMA node:
<ul><li>Less than 8 logical processors: Keep MAXDOP at or below # of logical processors</li>
<li>Greater than 8 logical processors: Keep MAXDOP at or below # of logical processors</li></ul>
<li>Server with multiple NUMA nodes:
<ul><li>Less than 8 logical processors: Keep MAXDOP at or below # of logical processors per NUMA node</li>
<li>Greater than 8 logical processors: Keep MAXDOP at 8</li></ul></ul>

<b>affinity_type_desc</b> expected value: <i>AUTO</i>"
Comments $comments

#########################################################################################
$htmlOut = "
<br>
<hr>
<br>
<h1>Formatted sys.dm_os_sys_memory</h1>
<br>
"
WriteToHtml $htmlOut
.\ps1\00_TableToHtml.ps1 -tableID 3

$comments = 
"<b>System Memory State</b> expected value: <i>Available physical memory is high</i>
<b>% Available</b> < 10 indicates <b>max server memory</b> configuration option might be too high"
Comments $comments

#########################################################################################
$htmlOut = "
<br>
<hr>
<br>
<h1>NUMA Nodes (sys.dm_os_nodes)</h1>
<br>
"
WriteToHtml $htmlOut
.\ps1\00_TableToHtml.ps1 -tableID 4

$comments = 
"If NUMA is not present, there will be one memory node: node_id 0
node_id 64 is reserved for ONLINE_DAC (Dedicated Administrator Connection)"
Comments $comments

#########################################################################################
$htmlOut = "
<br>
<hr>
<br>
<h1>Processor Info from Registry</h1>
<br>
"
WriteToHtml $htmlOut
.\ps1\00_TableToHtml.ps1 -tableID 5

Footer
