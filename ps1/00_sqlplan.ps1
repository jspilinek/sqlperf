$planPath = ".\html\sqlplan\"
if(Test-Path -Path $planPath) {
    DebugLog "$planPath exists" -logOnly $true
}else{
    New-Item -Path . -Name "html\sqlplan" -ItemType "directory" | Out-Null
    DebugLog "Created directory $planPath" -logOnly $true
}
