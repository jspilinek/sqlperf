# sqlperf
PowerShell script for diagnosing performance issues with SQL Server and PTC's Windchill PDMLink

## Supported Releases
- SQL Server 2012, 2014, 2016, 2017, 2019
- Azure SQL

## About the script
- Script is used by PTC Technical Support to identify and troubleshoot performance issues
- Script generates a report by querying system DMVs and user schema
- Script is based on the **sqlperf.sql**, but with several important improvements:
- Output is no longer limited to a single huge TXT file
- Output is broken down into multiple smaller HTML files
- HTML output allows for formatting which makes the report much easier to review
- Full SQL text is captured in the report (previously was limited to 8000 characters)
- Query plan files (.sqlplan) are captured for the top worst SQL
- Index and column statistics are dynamically collected, avoiding follow-up requests for more information
- Support for Query Store (feature added in SQL Server 2016)
- **sqlperf.ps1** is the main script and will execute other scripts found in the **ps1** and **sql** directories
- Results of the script are saved in the **html** directory
- **html/00_sqlperf.html** is the main file of the report

## Requirements
- PowerShell Core or Windows PowerShell
  - To check the installed version of PowerShell run:
  `$PSVersionTable`
  ![image](https://user-images.githubusercontent.com/101371702/157923691-969f5b2a-50b9-4b9b-bf26-743c7fd4abda.png)
- PowerShell Core:
  - Download the [latest](https://aka.ms/powershell-release?tag=stable) install package from GitHub
  - PowerShell Core installs in its own directory and does not touch Windows PowerShell
  - PowerShell Core installation does not require a server restart
  - See [Installing PowerShell on Windows](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-windows) for more information
  - PTC has verified the **sqlperf.ps1** script works with PowerShell Core 7.1
- Windows PowerShell:
  - PTC's diagnostic script requires Windows PowerShell version 5.1 or later
  - Refer to Microsoft [documentation](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-windows-powershell?view=powershell-6) for installation instructions
- Update PowerShellGet module in Windows PowerShell (does not apply to PowerShell Core)
  - PowerShell Gallery has disabled TLS 1.0 and 1.1 as of April 2020
  - Below commands will update PowerShellGet, changing the default security protocol to TLS 1.2:
    ```
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Install-Module PowerShellGet -RequiredVersion 2.2.4 -SkipPublisherCheck
    ```
  - If PowerShellGet is not updated, the SqlServer module will fail to install
  - See [PowerShell Gallery TLS Support](https://devblogs.microsoft.com/powershell/powershell-gallery-tls-support/) for details
- SqlServer Powershell module
  - Refer to Microsoft [documentation](https://docs.microsoft.com/en-us/sql/powershell/download-sql-server-ps-module?view=sql-server-2017) for more specific installation instructions
  - PTC's diagnostic script has been developed using SqlServer module version 21.1.18147
  - To install the SqlServer module run from PowerShell:
    `Install-Module -Name SqlServer -Scope CurrentUser -AllowClobber`
  - To check the SqlServer module version run from PowerShell:
    `Get-Module SqlServer -ListAvailable`
    ![image](https://user-images.githubusercontent.com/101371702/157923763-a7b81afb-6654-4392-9ebc-b9ac8e7db51e.png)
- SQL Server administrative access
  - Script requires **VIEW SERVER STATE** permission
  - For SQL Server authentication use the **sa** account
  - For Windows authentication use the Windows login that installed SQL Server
- PowerShell script is not digitally signed
  - Running this PowerShell script may fail with error:
    ```
    .\sqlperf-v2.ps1 : File D:\sqlperf-v2\sqlperf.ps1
    cannot be loaded. The file D:\sqlperf-v2\sqlperf.ps1 is not digitally signed. You cannot run this script on the current system. For more information about running scripts and setting execution policy, see about_Execution_Policies at http://go.microsoft.com/fwlink/?LinkID=135170.
    At line:1 char:1
    + .\sqlperf-v2.ps1 -database pdm111
    + ~~~~~~~~~~~~~~~~
    + CategoryInfo          : SecurityError: (:) [], PSSecurityException
    + FullyQualifiedErrorId : UnauthorizedAccess
    ```
  - To overcome this error temporarily change the execution policy for the current PowerShell session:
    ```
    Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
    ```
  - Above command will only affect the current session, close the session once finished running the **sqlperf.ps1** script

## Windows Authentication Instructions
  1. Extract contents of **sqlperf-22.04.zip**
  2. Start PowerShell session and change directory to extracted content
  3. For local install execute:
      ```
      Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
      .\sqlperf.ps1 -database <db_name>
      ```
  4. For remote database execute:
      ```
      Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
      .\sqlperf.ps1 -database <db_name> -server <server_name>
      ```
    - Note: If the database server was installed with an instance name then <server_name> must hold <hostname>\<instance_name>
  5. When the **sqlperf.ps1** script completes zip the entire contents of the **html** directory

## SQL Server Authentication Instructions
  1. Extract contents of **sqlperf-22.04.zip**
  2. Start PowerShell session and change directory to extracted content
  3. Execute:
      ```
      Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
      .\sqlperf.ps1 -database <db_name> -server <server_name> -login sa
      ```
    - Note: If the database server was installed with an instance name then <server_name> must hold <hostname>\<instance_name>
  4. Enter user password when prompted
  5. When the **sqlperf.ps1** script completes zip the entire contents of the **html** directory

## Example run of sqlperf.ps1
```
PS C:\sqlperf-v19.17> .\sqlperf.ps1 -database pdm112 -server localhost -login sa
Enter password for sa: *********
Authentication Mode: SQL Server Authentication
ProductName: SQL2017
ProductVersion: 14.0.1000.169
Uptime: 0d 0hr 30min
Generating 00_sqlperf.html
Generating SqlVersion.html
Generating WindchillVersion.html
Generating Uptime.html
Generating ImportantConfigValues.html
Generating AllConfigValues.html
Generating AutoStats.html
Generating AutoTuning.html
Generating DBScopedConfigsNonDefault.html
Generating DBScopedConfigs.html
Generating TraceFlags.html
Generating ServerInfo.html
Generating LogPath.html
Generating Services.html
Generating ScalabilityInfo.html
Generating BufferPool.html
Generating BPE.html
Generating PerfCounters.html
Generating CpuUtilization.html
Generating DBInfo.html
Generating DBFiles.html
Generating DiskIO.html
Generating TransactionLog.html
Generating Blobs.html
Generating Tables.html and Tables.txt
Generating TransientTables.html
Generating UnusedPages.html
Generating TableLock.html
Generating TablesInMemory.html
Generating Indexes.html and Indexes.txt
Generating RowCompression.html
Generating MissingPK.html
Generating DuplicateIndexes.html
Generating FragmentedIndexes.html
Generating FillFactor.html
Generating DisabledIndexes.html
Generating MissingIndexes.html
Generating Columns.html and Columns.txt
Generating Statistics.html and Statistics.txt
Generating 99_ShowStatistics.sql
Generating StatsNoRecompute.html
Generating StaleStats.html
Generating ComputedColumns.html and ComputedColumns.txt
Generating ViewDefinitions.html and ViewDefinitions.txt
Generating Triggers.html
Generating WaitStats.html
Generating IndexUsageStats.html
Generating QueryStoreWaitStats.html
Generating QueryStoreOptions.html
Generating QueryStoreTotalSec.html
Generating QueryStoreAvgSec.html
Generating QueryStoreAvgCPU.html
Generating QueryStoreAvgLogicalIO.html
Generating QueryStoreAvgPhysicalIO.html
Generating QueryStoreExecutions.html
Generating QueryStoreAvgRowCount.html
Generating QueryStoreSqlLiterals.html
Generating QueryStoreDml.html
Generating QSForcedPlans.html
Generating QueryStoreTopSql.html and QueryStoreTopSql.txt
Generating ActiveSql.html
Generating SqlByElapsedTime.html
Generating SqlByAverageElapsedTime.html
Generating SqlByLogicalReads.html
Generating SqlByPhysicalReads.html
Generating SqlByExecutionCount.html
Generating SqlByRowCount.html
Generating FullSqlTextAndPlans.html and FullSqlTextAndPlans.txt
Generating ShowStatistics.html and ShowStatistics.txt
<please wait...>
Script done in 227.7 seconds
PS C:\sqlperf-v19.17>
```
