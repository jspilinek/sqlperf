$col = 0
$width = 200
$outArray = @()
$line = ""

Try{
    $words = $sqlText -split "\s+"
    foreach ( $word in $words )
    {
        $col += $word.Length + 1
        if ( $col -gt $width )
        {
            #New line
            $col = $word.Length + 1
            $outArray += $line
            $line = ""
        }
        $line = $line + "$word "
    }
    
    $outArray += $line
    
    foreach ($line in $outArray)
    {
        WriteToText $line
    }
}Catch{
    LogException $_.Exception $error[0].ScriptStackTrace "Failed to split text:" $sqlText
}
