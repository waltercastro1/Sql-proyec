USE [msdb]
GO
--sp_helptext sp_delete_job

--SELECT schedule_id, job_id 
--                FROM msdb.dbo.sysjobschedules  

--8	D4C1D12F-A022-473D-8190-B4119D3C558E	8	D4C1D12F-A022-473D-8190-B4119D3C558E	20221001	20000
--13	34003734-37C5-4D5B-803E-CB83BE21910E	13	34003734-37C5-4D5B-803E-CB83BE21910E	0	0
--9	DBDCAE9B-F935-407A-AF2E-E8A27960806F	9	DBDCAE9B-F935-407A-AF2E-E8A27960806F	20220930	222900


/* OJO @job_id=N'6e3359ee-552e-4e7f-b14d-913eba292d3d' SOLO FUNCIONA POR UNA UNICA EJECUCIÓN   */

/****** Object:  Job [Backup AdventureWorks2016-PRD]    Script Date: 30/9/2022 22:08:48 ******/
EXEC msdb.dbo.sp_delete_job @job_id=N'34003734-37C5-4D5B-803E-CB83BE21910E', @delete_unused_schedule=1
GO


/****** Object:  Job [Backup AdventureWorks2016-PRD]    Script Date: 30/9/2022 22:05:53 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 30/9/2022 22:05:53 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Backup AdventureWorks2016-PRD', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Copia de Seguridad de la bd ADvWorks', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'DESKTOP-QJS5DBQ\Raúl Gutierrez', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Backup a Disco]    Script Date: 30/9/2022 22:05:53 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Backup a Disco', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'BACKUP DATABASE [AdventureWorks2016] TO  DISK = N''C:\SQLSRV2K16\Backup\AdventureWorks2016.bak'' WITH NOFORMAT, INIT,  NAME = N''AdventureWorks2016-30092022'', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO
declare @backupSetId as int
select @backupSetId = position from msdb..backupset where database_name=N''AdventureWorks2016'' and backup_set_id=(select max(backup_set_id) from msdb..backupset where database_name=N''AdventureWorks2016'' )
if @backupSetId is null begin raiserror(N''Error de comprobación. No se encuentra la información de copia de seguridad para la base de datos ''''AdventureWorks2016''''.'', 16, 1) end
RESTORE VERIFYONLY FROM  DISK = N''C:\SQLSRV2K16\Backup\AdventureWorks2016.bak'' WITH  FILE = @backupSetId,  NOUNLOAD,  NOREWIND
GO
', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Bkp Diario', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20220930, 
		@active_end_date=99991231, 
		@active_start_time=220300, 
		@active_end_time=235959, 
		@schedule_uid=N'7777aa3b-a2fc-4e23-999a-f4089ca873a9'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

