function InitProgressBar{
    param (
        [Parameter(Mandatory=$true)][int]$steps,
        [Parameter(Mandatory=$true)][string]$activity
    )

    $global:progressBarSteps=$steps
    $global:progressBarCounter=0
    $global:progressBarPercentComplete = 0
    $global:progressBarActivity = $activity
}

function UpdateProgressBar{
    $global:progressBarCounter++
    $global:progressBarPercentComplete = [int](($global:progressBarCounter / $global:progressBarSteps) * 100)
    Write-Progress -Activity $global:progressBarActivity -Status "$global:progressBarPercentComplete% Complete" -PercentComplete $global:progressBarPercentComplete
}

function CompleteProgressBar{
    Write-Progress -Activity $global:progressBarActivity -Completed
}


Export-ModuleMember -Function 'InitProgressBar'
Export-ModuleMember -Function 'UpdateProgressBar'
Export-ModuleMember -Function 'CompleteProgressBar'