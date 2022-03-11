$title = "Database Files"

Header $title

[string]$DBFiles = (Get-Content .\sql\DBFiles.sql) -join "`n"
[string]$VolumeStats = (Get-Content .\sql\VolumeStats.sql) -join "`n"

[string]$query = $DBFiles + $VolumeStats
. .\ps1\00_executeQuery.ps1

############################################################################
.\ps1\00_TableToHtml.ps1 -tableID 0
$comments = 
"Check if there are multiple tempdb files.
Verify tempdb files all have same growth settings.
In general tempdb should <b>not</b> be located on
<ul><li>Operating System drive</li>
<li>Any drive that contains user databases</li></ul>
See also <a href='https://www.ptc.com/en/support/article?n=CS226172'> SQL Server tempdb recommendations for performance in Windchill</a>
In general percentage based growth is not recommended. As the datafile grows, so will the growth amount."
Comments $comments

############################################################################
$htmlOut = "
<br>
<hr>
<br>
<h1>Volume Information</h1>
<br>
"
WriteToHtml $htmlOut
.\ps1\00_TableToHtml.ps1 -tableID 1

Footer
