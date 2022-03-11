$title = "Buffer Pool"

Header $title

[string]$MemoryBrokers = (Get-Content .\sql\MemoryBrokers.sql) -join "`n"
[string]$MemoryClerks = (Get-Content .\sql\MemoryClerks.sql) -join "`n"
[string]$MemoryCacheCounters = (Get-Content .\sql\MemoryCacheCounters.sql) -join "`n"
[string]$BufferPoolUsage = (Get-Content .\sql\BufferPoolUsage.sql) -join "`n"

[string]$query = $MemoryBrokers + $MemoryClerks + $MemoryCacheCounters + $BufferPoolUsage
. .\ps1\00_executeQuery.ps1

$htmlOut = "
<h1>sys.dm_os_memory_brokers</h1>
<br>
"
WriteToHtml $htmlOut
.\ps1\00_TableToHtml.ps1 -tableID 0
$comments = 
"<b>MEMORYBROKER_FOR_CACHE</b>: Memory that is allocated for use by cached objects (Not Buffer Pool cache).
<b>MEMORYBROKER_FOR_STEAL</b>: Memory that is stolen from the buffer pool. This memory is not available for reuse by other components until it is freed by the current owner.
<b>MEMORYBROKER_FOR_RESERVE</b>: Memory reserved for future use by currently executing requests."
Comments $comments

############################################################################
$htmlOut = "
<br>
<hr>
<br>
<h1>sys.dm_os_memory_clerks</h1>
<br>
"
WriteToHtml $htmlOut
.\ps1\00_TableToHtml.ps1 -tableID 1 -excludeAdditionalColumns "memory_clerk_address, page_allocator_address, host_address"
$comments = 
"<b>MEMORYCLERK_SQLBUFFERPOOL</b> is the Buffer Pool and should have the largest <b>pages_kb</b>
Check if other components are taking too much memory from Buffer Pool"
Comments $comments

############################################################################
$htmlOut = "
<br>
<hr>
<br>
<h1>sys.dm_os_memory_cache_counters</h1>
<br>
"
WriteToHtml $htmlOut
.\ps1\00_TableToHtml.ps1 -tableID 2
$comments = 
"Useful for further analysis if something is taking too much memory from buffer pool."
Comments $comments

############################################################################
$htmlOut = "
<br>
<hr>
<br>
<h1>Buffer Pool Usage by Database</h1>
<br>
"
WriteToHtml $htmlOut
.\ps1\00_TableToHtml.ps1 -tableID 3

Footer
