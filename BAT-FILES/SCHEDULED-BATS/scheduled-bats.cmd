@echo off

@SET rootFolder=%BKB_ROOT%

@ECHO Root Folder is: %rootFolder%
@REM the rootFolder variable gets passed off to subsequent scripts. This should allow the root folder name to be set to whatever the user wants.

> %rootFolder%\PRIVATE\%computername%\LOGS\last_run_log.txt (

@echo ===========================
@echo RUNNING SCHEDULED BAT FILES
@echo ===========================
@echo.
@echo.
@REM Set working directory to the location of the SCHEDULED-BATS
@CD %rootFolder%\BAT-FILES\SCHEDULED-BATS

@REM run MONTHLY CMD - if you need to run backups monthly, use this.
@REM UNCOMMENT THE LINE BELOW TO RUN 0_monthly.cmd
@REM call 0_monthly.cmd %rootFolder%

@REM run WEEKLY CMD - if you need to run backups on specific days of the week, use this.
@REM UNCOMMENT THE LINE BELOW TO RUN 0_weekly.cmd
@REM call 0_weekly.cmd %rootFolder%

@REM run DAILY CMD
@echo +++++++
@echo RUNNING 0_DAILY.CMD
call 0_daily.cmd %rootFolder%

@echo +++++++
@echo RUNNING 0_SYSTEM_BACKUP_REMINDER.CMD
@REM run SYSTEM BACKUP REMINDER CMD
call 0_system_backup_reminder.cmd %rootFolder%

@echo ------------------------
@echo SCHEDULED BATS COMPLETED
@echo ------------------------
@echo.
)