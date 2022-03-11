$title = "Automatic Tuning Options"

Header $title

[string]$query = (Get-Content .\sql\AutoTuning.sql) -join "`n"
. .\ps1\00_executeQuery.ps1

.\ps1\00_TableToHtml.ps1 -tableID 0 -link $true

$comments = 
"New in SQL Server 2017 Enterprise Edition (not available in Standard Edition). Also available in SQL Azure.
Can use this to check if <b>FORCE_LAST_GOOD_PLAN</b> has been enabled. 
Enable with:
<b>ALTER DATABASE CURRENT SET AUTOMATIC_TUNING (FORCE_LAST_GOOD_PLAN = ON);</b>"
Comments $comments

Footer
