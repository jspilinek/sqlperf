$title = "SQL Server Version"

Header $title -lineBreak $true

[string]$query = (Get-Content .\sql\SqlVersion.sql) -join "`n"
. .\ps1\00_executeQuery.ps1

$htmlOut = "
<h1>SQL Server Version (SERVERPROPERTY)</h1>
<br>
"
WriteToHtml $htmlOut
.\ps1\00_TableToHtml.ps1 -tableID 0 -excludeAdditionalColumns Version

$version = $results.tables[0].Item("Version") | % {$_ -replace "<", "&lt;"} | % {$_ -replace ">", "&gt;"}

$htmlOut = "
<br>
<hr>
<br>
<h1>SQL Server Version (@@VERSION)</h1>
<br>
<pre>$version</pre>
"
WriteToHtml $htmlOut

$comments = 
"If the ResourceVersion and ProductVersion do not match this could indicate an incomplete Service Pack Install
Edition determines the features and the limits, such as maximum number of CPUs that are supported
Check below URLs to see if the latest SP or CU is installed
Note: starting with SQL Server 2017 there will no longer be service packs, only cumulative updates
<a href='http://sqlserverbuilds.blogspot.com/'>SQL Server Versions List</a>
<a href='https://sqlserverupdates.com/'>Most recent updates for SQL Server</a>"

Comments $comments

Footer
