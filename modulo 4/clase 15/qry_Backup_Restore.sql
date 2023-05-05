BACKUP DATABASE [AdventureWorks2016] TO  DISK = N'E:\SQLSRV2K16\Backup\AdventureWorks2016.bak' WITH NOFORMAT, INIT,  NAME = N'AdventureWorks2016-30092022', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO
declare @backupSetId as int
select @backupSetId = position from msdb..backupset where database_name=N'AdventureWorks2016' and backup_set_id=(select max(backup_set_id) from msdb..backupset where database_name=N'AdventureWorks2016' )
if @backupSetId is null begin raiserror(N'Error de comprobación. No se encuentra la información de copia de seguridad para la base de datos ''AdventureWorks2016''.', 16, 1) end
RESTORE VERIFYONLY FROM  DISK = N'E:\SQLSRV2K16\Backup\AdventureWorks2016.bak' WITH  FILE = @backupSetId,  NOUNLOAD,  NOREWIND
GO



EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'AdventureWorks2016'
GO
use [master];
GO
USE [master]
GO
ALTER DATABASE [AdventureWorks2016] SET  SINGLE_USER WITH ROLLBACK IMMEDIATE
GO
USE [master]
GO
/****** Object:  Database [AdventureWorks2016_v1]    Script Date: 30/9/2022 21:38:00 ******/
DROP DATABASE [AdventureWorks2016]
GO


--USE [master]
--RESTORE DATABASE [AdventureWorks2016] FROM  DISK = N'C:\SQLSRV2K16\Backup\AdventureWorks2016.bak' WITH  RESTRICTED_USER,  FILE = 1,  NOUNLOAD,  REPLACE,  STATS = 5

--GO

USE [master]
RESTORE DATABASE [AdventureWorks2016] FROM  DISK = N'C:\SQLSRV2K16\Backup\AdventureWorks2016.bak' WITH  FILE = 1,  NOUNLOAD,  STATS = 5

GO


