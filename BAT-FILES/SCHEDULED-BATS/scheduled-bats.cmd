@echo off
@echo ===========================
@echo RUNNING SCHEDULED BAT FILES
@echo ===========================
@echo.
@echo.

REM Set working directory to the location of the SCHEDULED-BATS
CD C:\BPTV-KB\BAT-FILES\SCHEDULED-BATS

REM run MONTHLY CMD
call 0_monthly.cmd

REM run WEEKLY CMD
call 0_weekly.cmd

REM run DAILY CMD
call 0_daily.cmd

REM run SYSTEM BACKUP REMINDER CMD
call 0_system_backup_reminder.cmd

@echo ------------------------
@echo SCHEDULED BATS COMPLETED
@echo ------------------------
@echo.
TIMEOUT /T 10
