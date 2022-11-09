#Save current directory
$origDir = $pwd

#Switch to directory of SQL Tools Service
cd "$sqlToolsPath"

#Load classes needed to query SQL Server
$Assem = (
    “Microsoft.SqlServer.Management.Sdk.Sfc”,
    “Microsoft.SqlServer.Smo”,
    “Microsoft.SqlServer.ConnectionInfo”
); 
Add-Type -AssemblyName $Assem;

#Switch back to the original directory
cd "$origDir"