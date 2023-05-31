function AddTrackedQueryID{
    param (
        [Parameter(Mandatory=$true)][string]$key,
        [Parameter(Mandatory=$true)][string]$item
    )
    
    if(-Not $global:trackedQueryIDs.ContainsKey($key)){
        $global:trackedQueryIDs.Add($key,$item)
        # DebugLog "Tracking query_id $key from $item" -logOnly $true
    }
}

Export-ModuleMember -Function 'AddTrackedQueryID'