Try{
    $query = $query -replace "ENTER_TOP_COUNT",$top_count
    $query = $query -replace "ENTER_START_TIME",$start_time
    $query = $query -replace "ENTER_END_TIME",$end_time
    $query = $query -replace "ENTER_DATE_FORMAT",$dateFormat
    $results = $db.ExecuteWithResults($query)
}Catch{
    LogException $_.Exception $error[0].ScriptStackTrace "Failed to execute query:" $query
}
