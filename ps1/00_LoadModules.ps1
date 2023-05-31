if ($IsLinux -eq $true){
#Load SQL Tools Service for Linux
.\ps1\00_SqlToolsService.ps1

}else{
    #If not Linux, assume Windows
    #Load sqlserver module
    try{
        $ErrorActionPreference = "Stop";
        Import-Module "sqlserver"
    }catch{
        Write-Host $_.Exception -ForegroundColor red -BackgroundColor black
        Write-Host "Check https://www.ptc.com/en/support/article?n=CS299797 for SqlServer PowerShell module installation instructions"
        Exit 1
    }
}

#Load custom modules
$moduleList = @()

$moduleList += "Comments"
$moduleList += "DebugLog"
$moduleList += "WriteToFile"
$moduleList += "TrackedQueryID"

foreach($module in $moduleList)
{
    #Remove module if it was previously loaded
    if (Get-Module -Name $module){
        Remove-Module $module
    }
    
    try{
        Import-Module .\modules\$module.psm1
    }catch{
        Write-Host $_.Exception -ForegroundColor red -BackgroundColor black
        Exit 1
    }
}
Exit 0
