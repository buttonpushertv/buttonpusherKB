@echo on
@echo ===========================
@echo RUNNING SCHEDULED BAT FILES
@echo ===========================
@echo.
@echo.

REM This will use initool.exe to read the location of the rootFolder from settings.ini
@FOR /F "tokens=* USEBACKQ" %%F IN (`UTIL-APPS\initool\initool.exe g settings.ini Settings rootFolder --value-only`) DO (
SET rootFolder=%%F
)
@ECHO Root Folder is: %rootfolder%
REM the rootFolder variable gets passed off to subsequent scripts. This should allow the root folder name to be set to whatever the user wants.

REM Set working directory to the location of the SCHEDULED-BATS
CD %rootFolder%\BAT-FILES\SCHEDULED-BATS

REM run MONTHLY CMD - if you need to run backups monthly, use this.
REM UNCOMMENT THE LINE BELOW TO RUN 0_monthly.cmd
REM call 0_monthly.cmd %rootFolder%

REM run WEEKLY CMD - if you need to run backups on specific days of the week, use this.
REM UNCOMMENT THE LINE BELOW TO RUN 0_weekly.cmd
REM call 0_weekly.cmd %rootFolder%

REM run DAILY CMD
call 0_daily.cmd %rootFolder%

REM run SYSTEM BACKUP REMINDER CMD
call 0_system_backup_reminder.cmd %rootFolder%

@echo ------------------------
@echo SCHEDULED BATS COMPLETED
@echo ------------------------
@echo.
@REM The pause command will keep the window open until you press a key - useful for debugging
@PAUSE
@REM This TIMEOUT command will auto-close the window after 10 seconds - adjust if you'd like
TIMEOUT /T 10
