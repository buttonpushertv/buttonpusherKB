@echo off
@echo ===========================
@echo RUNNING SCHEDULED BAT FILES
@echo ===========================
@echo.
@echo.

REM This will use initool.exe to read the location of the rootFolder from settings.ini
@FOR /F "tokens=* USEBACKQ" %%F IN (`..\UTIL-APPS\initool\initool.exe g ..\settings.ini Settings rootFolder --value-only`) DO (
SET var=%%F
)

REM Set working directory to the location of the SCHEDULED-BATS
CD C:\BPTV-KB\BAT-FILES\SCHEDULED-BATS

REM run MONTHLY CMD - if you need to run backups monthly, use this.
REM UNCOMMENT THE LINE BELOW TO RUN 0_monthly.cmd
call 0_monthly.cmd

REM run WEEKLY CMD - if you need to run backups on specific days of the week, use this.
REM UNCOMMENT THE LINE BELOW TO RUN 0_weekly.cmd
REM call 0_weekly.cmd

REM run DAILY CMD
call 0_daily.cmd

REM run SYSTEM BACKUP REMINDER CMD
call 0_system_backup_reminder.cmd

@echo ------------------------
@echo SCHEDULED BATS COMPLETED
@echo ------------------------
@echo.
TIMEOUT /T 10
