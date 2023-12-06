## [V23.05] - 2023-12-06
### Fixed
- FullSqlTextAndPlans was blank
- Removed time zone format for version prior to SQL Server 2016

## [V23.04] - 2023-10-27
### Changed
- Support for SQL Server 2022

## [V23.03] - 2023-10-25
### Fixed
- Method invocation error in DupeIndexes.ps1

## [V23.02] - 2023-10-12
### Added
- AuditTables.html using results from Tables.ps1
- Progress Bar for long foreach loops
- DupeIndexes replaced DuplicateIndexes with 99.95% improvement in elapsed time
### Changed
- Improved performance of Query Store reports
- TablesInMemory.sql updated with query from Tables.sql
- Removed in-memory tables from Tables.sql
- Added Table Type, DataSpace/Row and DataSpace/IndexSpace to Tables.sql
- TransientTables pulls from Tables.ps1
### Fixed
- Corrected typo in RowCompression.sql
- Added offset to dateFormat
- Detect timezone in PowerShell then use this to query the database and format results

## [V23.01] - 2023-05-15
### Fixed
- Allow connecting to a non-default instance
- Add $port parameter to querystore.ps1
- Don't use $port for Windows Authentication

## [V22.12] - 2022-11-22
### Fixed
- Improved readability with "sortable" HTML tables are no longer a single line

## [V22.11] - 2022-09-16
### Changed
- Script continues if there was a query execution that failed
- Main page now indicates when a query has failed to execute
- Display error message instead of "Zero rows returned" when a query has failed to execute

## [V22.10] - 2022-06-23
### Fixed
- Comments.psm1 now handles multi-line comments

## [V22.09] - 2022-04-25
### Changed
- Added -maxAgeDays parameter to sqlperf.ps1, defaults to 7. Query from QueryStoreTopSql.ps1 was timing out with the 7 day default for a customer.

## [V22.08] - 2022-04-23
### Changed
- 00_RunScripts_QS.ps1 switched from QueryStoreTopSql_QS.ps1 to QueryStoreTopSql.ps1
### Removed
- QueryStoreTopSql_QS.ps1

## [V22.07] - 2022-04-14
### Added
- ScheduleQueueEntries.sql
### Changed
- QueueEntry.html now lists schedule queue entries

## [V22.06] - 2022-04-11
### Changed
- DiskIO.html comments updated with link to article
- ScalabilityInfo.html comments updated with link to article

## [V22.05] - 2022-03-30
### Added
- $Edition variable, currently only used to check if row compression is available
### Changed
- RowCompression.html only displays commands if row compression is available
  - Enterprise Edition is required for versions prior to SQL Server 2016 SP1

## [V22.04] - 2022-03-23
### Fixed
- Corrected broken queries in QueryStoreTopSql.sql and FullSqlTextAndPlans.sql
### Changed
- Added article link for sqlperf.ps1 to 00_sqlperf.html
- Added -debug parameter to 00_executeQuery.ps1

## [V22.03] - 2022-03-15
### Added
- checkDupe parameter added to sqlperf.ps1 to skip DuplicateIndexes. This was done to speed up test runs.
- 00_sqlplan.ps1 to create html/sqlplan directory if necessary
- Global $dateFormat set to 'yyyy-MM-dd HH:mm:ss'
- When prompting for password display CapsLock warning if enabled
- Generate warning if login failed and CapsLock is on
- 00_startup.ps1 to cover overlap between sqlperf.ps1 and querystore.ps1
- txt links added to 00_sqlperf.html
### Changed
- Replaced \<font class='footer'> with \<footer> tag
- Replaced \<p class='main.header'> with \<header> tag
- Updated queries to use global $dateFormat
### Removed
- html/sqlplan/README.MD

## [V22.02] - 2022-03-14
### Added
- NullStats.html to list stats with Null rows
### Fixed
Corrected table display for dark module
Added html/sqlplan/readme.MD so that github creates the sqlplan directory

## [V22.01] - 2022-03-11
### Added
- Dark Theme!
### Changed
- sqlperf.css Defaults to light theme. Switches to dark theme if browser is using dark theme
- sqlperf.ps1 slight change to support dark theme
- Updated WaitStats.sql and AzureWaitStats.sql
- Added SQL Server 2022 to SqlVersion.sql

## [V21.02] - 2021-03-02
### Changed
- Updated comments in DBInfo.html
### Fixed
- Handle different collations in TransactionLog.sql 

## [V21.01] - 2021-02-01
### Changed
- Updated getProductVersion.ps1 to prevent error: Cannot convert value to type "System.Int32"
- Updated comments for Page life expectancy in PerfCounters.ps1
- Updated comments in ActiveSql.ps1 and ActiveSql2014.ps1

## V20.08 - 2020-12-10
### Added
- querystore.ps1 for generating Query Store report for specified time frame
- 00_RunScripts_QS.ps1
- QueryStoreTopSql_QS.ps1
- QueryStoreTotalSec_QS.ps1
- QueryStoreWaitStats_QS.ps1
- SqlVersion_QS.ps1
### Changed
- Added error handling to getProductVersion.ps1
- Added error handling to SqlTopPlans.ps1 when .sqlplan is missing

## V20.07 - 2020-06-17
### Changed
- Filter on db added to AutoStats.sql
- Added edition comments to AutoTuning.html
- 2014/ActiveRequests.sql no longer truncates statement_text

## V20.06 - 2020-04-09
### Added
- PerfTablesAge.html

## V20.05 - 2020-03-30
### Fixed
- Date format changed from MM/dd/yyyy to yyyy-MM-dd to address errors on French DB

## V20.04 - 2020-02-13
### Changed
- Added $timeout to 00_initDebug.ps1
### Fixed
- Corrected how 00_RunScripts.ps1 selects the Statistics script

## V20.03 - 2020-02-12
### Added
- Optional -timeout parameter for ConnectionContext.StatementTimeout (default is 10 minutes)
### Changed
- Updated Statistics.ps1/Statistics2016.ps1 to handle case where query timed out
- ShowStatistics.ps1 test if 99_ShowStatistics.sql exists

## V20.02 - 2020-02-10
### Changed
- Fixed error logging in 00_LoadModules.ps1

## V20.01 - 2020-01-24
### Changed
- StatsNoRecompute.html filter out NULL stats
- Added persisted_sample_percent column to Statistics.html
- Updated getProductVersion.ps1 to determine BuildVersion and UpdateVersion

## V19.19 - 2019-10-23
### Changed
- ENABLE AUTOSTATS COMMAND added to StatsNoRecompute.html

## V19.18 - 2019-10-22
### Added
- LogException function added to DebugLog.psm1
- DiskIOAzure.html
- IO Usage by Database added to DiskIO.html
- ProceduresByTotalSec.html
- ProceduresByLogicalReads.html
- Azure Properties added to ServerInfoAzure.html
### Changed
- Updated comments in AutoStats.html
- Password prompt is now Yellow to make it clear script is waiting for input
- Updated script done message
- Removed ORDER BY clause from DBScopedConfigs.sql and DBScopedConfigsNonDefault.sql
- Updated WaitStats.sql and AzureWaitStats.sql
- Has Missing Index added to QueryStoreTopSql.html and FullSqlTextAndPlans.html

## V19.17 - 2019-10-10
### Added
- QueueEntry.html
### Changed
- Added time frame to QueryStoreOptions.html

## V19.16 - 2019-10-10
### Added
- StatsNoRecompute.html
- StaleStats.html
### Changed
- Added database filter to MissingIndexes.sql
- Added article link to MissingIndexes.html
- Added no_recompute column to Statistics.html
- Removed password from command line arguments
- Added prompt for password when using SQL Server Authentication
### Fixed
- Addressed issue with 00_LoadModules.ps1 not setting the $LASTEXITCODE when successful

## V19.15 - 2019-10-08
### Added
- start_time, end_time and top_count global variables
- QSForcedPlans2016.html
- QSWaitCategory.ps1 and QSWaitCategory.sql
### Changed
- Updated plan_id metrics in QueryStoreTopSql.html and QueryStoreTopSql.txt
- Error handling added to Add-HTMLTableAttribute function in 00_TableToHtml.ps1
- Updated Query Store SQL scripts with start_time, end_time and top_count global variables
- Updated sqlplan file name from Query Store to include query_id
- Updated use of Get-Date to use format "MM/dd/yyyy HH:mm:ss"
- Additional columns added to QSForcedPlans.html
### Fixed
- Added QSForcedPlans to 00_RunScript.ps1
### Removed
- QueryStoreCpuWaits.ps1
- QueryStoreLatchWaits.ps1
- QueryStoreParallelismWaits.ps1

## V19.14 - 2019-10-01
### Added
- Blobs.html
- 00_LoadModules.ps1
- Comments.psm1
- DebugLog.psm1
- WriteToFile.psm1
- QueryStoreDml.html
- Triggers.html
### Changed
- ActiveSql.html updated with comment on wt.pom.implicitTransactions property
- Switched from Add-Content to Out-File to avoid error: "Add-Content : Stream was not readable."
- Global variables: script_name, main_page, execute_time, prevpage, nextpage, currentScript
### Fixed
- TransactionLog.html and TransactionLog2012.html now display both tables
- BPE.html format corrected
- 00_WrapText.ps1 now writes to file by line instead of by word
### Removed
- 00_Comments.ps1
- 00_log.ps1
- 00_header.ps1
- 00_footer.ps1

## V19.13 - 2019-07-25
### Fixed
- Added error handling to SqlTopPlans.ps1 for an empty plan

## V19.12 - 2019-07-25
### Changed
- sqlperf.ps1 now exits if 'sqlserver' module failed to import
- Updated error handling in sqlperf.ps1
### Fixed
- 00_formatSQL.ps1 no longer attempt to format an empty string

## V19.11 - 2019-07-25
### Changed
- Updated comments in ScalabilityInfo.html
- Updated connection error handling in sqlperf.ps1

## V19.10 - 2019-07-01
### Added
- AutoTuning.html
- AutoStats.html
- RowCompression.html
### Changed
- Version number changed to point release system
    - Major release will be updated each year
    - Minor release will be an incremental number
    - Going with 19.10 since this is the 10th update of 2019
- TableLock.html report on tables with lock escalation enabled and the command to disable
- BPE.html format updated
- QueryStoreOptions.html comments updated
- 00_RunScripts.ps1 updated with comments and $QueryStoreState check
- Indexes.html updated with sort direction: DESC or ASC
- QueryStoreSqlLiterals.sql filter out "SELECT StatMan" queries
### Fixed
- DBScopedConfigsNonDefault now requires SQL Server 2017 or higher

## V9 - 2019-05-13
### Added
- QueryStoreCpuWaits.html
- QueryStoreLatchWaits.html
- QueryStoreParallelismWaits.html
- AzureWaitStats.html
- QSForcedPlans.html
- DBScopedConfigs.html
- DBScopedConfigsNonDefault.html
### Changed
- Removed new column from QueryStoreWaitStats.ps1
- 00_formatSQL.ps1 updated with $fullText parameter
- 00_sqlperf.html header only shows Login parameter when using SQL Server Authentication
- ActiveRequests.sql capture full query text
- Replaced Download attribute in sqlplan links with type='xml/sqlplan'
- Filter out "SELECT StatMan" queries from Query Store reports
### Fixed
- 00_RunScripts.ps1 updated to use TransactionLog2012.ps1 for SQL Server 2012

## V8 - 2019-04-15
### Added
- changelog.txt
- Locks section added to PerfCounters.html
- Support for Azure SQL Database
- QueryStoreTotalSec.html
- 00_formatSQL.ps1 to trim parameter list from SQL text
- 00_RunScripts.ps1 dynamically generates a list of scripts to run based on the environment
- 00_executeQuery.ps1 to handle exceptions when executing SQL
- WindchillVersion.html lists installation history
- ResourceStats.html for Azure
### Changed
- Comments updated in DuplicateIndexes.html
- Comments updated in MissingIndexes.html
- FragmentedIndexes.sql updated
- sqlplan files formatted with line returns
- ShowStatistics.ps1 output now includes the DBBC SHOW_STATISTICS command used
- ShowStatistics.html no longer includes histogram making the page quicker to load in browser
- QueryStoreOptions.html updated with comments
- Improved Query Store reports
- TraceFlags.html updated with comments
- Download attribute added to sqlplan links
- sqlperf.ps1 checks if database parameter is valid
- DupePK.sql now includes UNIQUE for index type
- Tables.html and Indexes.html now include Schema Name
- WaitStats.sql updated
### Fixed
- MissingIndexes.sql corrected
- QueryStoreTopSql.ps1 output corrected
- Statistics.sql now generates show statistics commands with schema name instead of DB name

### Removed
- 00_RunScript.ps1 replaced by 00_RunScripts.ps1

## V7 - 2019-02-12
### Added
- 00_log.ps1 added to generate debug.txt
- 00_RunScript.ps1 added to capture timing of each ps1 script
- 00_TableToHtml.ps1 new $list param can output table or list 
- 00_TableToHtml.ps1 new $link param added for HTML character encoding
- QueryStoreSqlLiterals.html checks for SQL using literals
- ShowStatistics.html displays results of DBCC SHOW_STATISTICS commands gathered by Statistics.sql
- sqlperf.ps1 new $stats param to with default $true
### Changed
- Several console messages were moved to debug.txt
- QueryStoreOptions.html changed to display options as a list
- QueryStoreTopSql.ps1 exclude query_plan from table output
- ServerInfo.html sys.dm_os_sys_info table switched to list
- Statistics.ps1 updated to generate 99_ShowStatistics.sql
- WaitEvents.html renamed to WaitStats.html
- Statistics.sql exclude tables with NULL rows
### Fixed
- Statistics.sql DBBC SHOW_STATISTICS command corrected

## V6 - 2019-02-05
### Added
- 00_header.ps1 new $text param
- 00_TableToHtml.ps1 new $textfile, $htmlOutput, $htmlAndText params to support writing to html, text, or both
- 00_WrapText.ps1 used to line wrap SQL text
- Columns.txt
- ComputedColumns.txt
- FullSqlTextAndPlans.txt
- Indexes.txt
- QueryStoreTopSql.txt
- Statistics.txt
- Tables.txt
- ViewDefinitions.txt
- Type column added to Columns.sql
### Changed
- QueryStoreTopSql.html column names updated

## V5 - 2019-01-30
### Added
- 00_Comments.ps1 to add comments to html output
- Columns.html
- TableLock.html check for tables with non-default lock escalation
- TablesInMemory.html check for memory optimized tables
- NumaNodes.sql for 2016 and earlier
### Changed
- Many html pages updated with comments
### Fixed
- ServerInfo.ps1 check for major version updated to 2017 since Numa column was not available in 2016 RTM
### Removed
- Few columns dropped from Indexes.sql
- NumaNodes-2014.sql
- Lock escalation dropped from Tables.sql

## V4 - 2019-01-28
### Added
- 00_TableToHtml.ps1 new $sortable param

## V3 - 2019-01-25
### Added
- LogSpace.sql added for 2012 and earlier
### Changed
- Replaced c100 scripts with 2012
### Fixed
- BufferPool.ps1 check version before running BPE queries
- Tables.ps1 updated version check
- TransactionLog.ps1 updated version check
- 
## V2 - 2019-01-25
### Added
- 00_values.ps1
- getCompatibilityLevel.ps1
- getProductVersion.ps1
- getQueryStoreState.ps1
- getUptime.ps1
- Main header added to 00_sqlperf.html
- Support added for 2014 and 2012
### Changed
- Moved query logic into scripts in sql directory

## V1 - 2019-01-23
- Yay! First release
