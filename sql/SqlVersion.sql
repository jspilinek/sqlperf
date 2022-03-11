DECLARE @ProductName        NVARCHAR(30)
DECLARE @ProductVersion     NVARCHAR(20)
DECLARE @ResourceVersion    NVARCHAR(20)
DECLARE @ProductLevel       NVARCHAR(20)
DECLARE @Edition            NVARCHAR(100)

SET @ProductVersion     = CONVERT(NVARCHAR(20),SERVERPROPERTY('ProductVersion')) 
SET @ResourceVersion    = CONVERT(NVARCHAR(20),SERVERPROPERTY('ResourceVersion')) 
SET @ProductLevel       = CONVERT(NVARCHAR(20),SERVERPROPERTY('ProductLevel')) 
SET @Edition            = CONVERT(NVARCHAR(100),SERVERPROPERTY('Edition'))

SELECT @ProductName = 
        CASE @Edition
            WHEN 'SQL Azure' THEN 'SQL Azure'
            ELSE CASE SUBSTRING(@ProductVersion,1,4)
                WHEN '16.0' THEN 'SQL Server 2022'
                WHEN '15.0' THEN 'SQL Server 2019'
                WHEN '14.0' THEN 'SQL Server 2017'
                WHEN '13.0' THEN 'SQL Server 2016' 
                WHEN '12.0' THEN 'SQL Server 2014' 
                WHEN '11.0' THEN 'SQL Server 2012' 
                WHEN '10.5' THEN 'SQL Server 2008 R2' 
                WHEN '10.0' THEN 'SQL Server 2008' 
                ELSE 'unknown'
            END
        END

SELECT @ProductName AS ProductName,
@ProductLevel AS ProductLevel,
@Edition AS Edition,
@ProductVersion AS ProductVersion,
@ResourceVersion AS ResourceVersion,
@@VERSION AS Version;