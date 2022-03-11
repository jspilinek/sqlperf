$title = "CPU Utilization for last 256 minutes"

Header $title

[string]$query = (Get-Content .\sql\CpuUtilization.sql) -join "`n"
. .\ps1\00_executeQuery.ps1

.\ps1\00_TableToHtml.ps1 -tableID 0

Footer
