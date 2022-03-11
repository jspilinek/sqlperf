$title = "Database Information"

Header $title -lineBreak $true

[string]$query = (Get-Content .\sql\DBInfo.sql) -join "`n"
. .\ps1\00_executeQuery.ps1

.\ps1\00_TableToHtml.ps1 -tableID 0 -excludeAdditionalColumns "source_sid, owner_sid, source_database_id"

$comments = 
"master, tempdb and Windchill databse must be set to Collation <b>SQL_Latin1_General_CP1_CS_AS</b>
Windchill only supported with <b>is_read_committed_snapshot_on=1</b> and <b>snapshot_isolation_state=0</b>
Check that <b>compatibility_level</b> for the above databases match the installed product version:"
Comments $comments

$htmlOut = "
<table><thead><tr>
<th>Product</th>
<th>compatibility_level</th>
</tr></thead>
<tbody>
<tr><td>SQL Server 2019</td><td>150</td></tr>
<tr><td>SQL Server 2017</td><td>140</td></tr>
<tr><td>SQL Server 2016</td><td>130</td></tr>
<tr><td>SQL Server 2014</td><td>120</td></tr>
<tr><td>SQL Server 2012</td><td>110</td></tr>
<tr><td>SQL Server 2008</td><td>100</td></tr>
</tbody></table>"
WriteToHtml $htmlOut

Footer
