[string]$query = (Get-Content .\sql\getProductVersion.sql) -join "`n"
. .\ps1\00_executeQuery.ps1

$ProductName = $results.tables[0].Item('ProductName')
$ProductVersion = $results.tables[0].Item('ProductVersion') -replace '[^0-9.]', ''
$Edition = $results.tables[0].Item('Edition')

DebugLog "ProductName: $ProductName"
DebugLog "ProductVersion: $ProductVersion"

#For testing different versions
#SQL Server 2016 SP1
# $ProductVersion = "13.0.4001.0"
# $ProductVersion = "14.0.3335.7"

Try{
    $VersionArray = $ProductVersion.Split('.')
    # $VersionArray

    $ProductMajorVersion = [int]$VersionArray[0]
    $BuildMajor = [int]$VersionArray[0]
    $BuildMinor = [int]$VersionArray[1]
    $BuildVersion = [single]"$BuildMajor.$BuildMinor"
    $UpdateMajor = [int]$VersionArray[2]
    $UpdateMinor = [int]$VersionArray[3]
    $UpdateVersion = [single]"$UpdateMajor.$UpdateMinor"

    # $ProductMajorVersion
    # $BuildMajor
    # $BuildMinor
    # $BuildVersion
    # $UpdateMajor
    # $UpdateMinor
    # $UpdateVersion

}Catch{
    LogException $_.Exception $error[0].ScriptStackTrace "ProductVersion.Split() failed"
    #Exit
}

DebugLog "BuildVersion: $BuildVersion" -logOnly $true
DebugLog "UpdateVersion: $UpdateVersion" -logOnly $true
DebugLog "ProductMajorVersion: $ProductMajorVersion" -logOnly $true
DebugLog "Edition: $Edition" -logOnly $true
