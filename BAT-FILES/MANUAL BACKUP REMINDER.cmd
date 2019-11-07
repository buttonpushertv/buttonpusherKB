@echo off
@echo =============================
@echo MANUALLY RUNNING DAILY BACKUP
@echo =============================
@echo.
@echo.

REM This will use initool.exe to read the location of the rootFolder from settings.ini
@FOR /F "tokens=* USEBACKQ" %%F IN (`..\UTIL-APPS\initool\initool.exe g ..\settings.ini Settings rootFolder --value-only`) DO (
SET var=%%F
)

REM Set working directory to the location of the SCHEDULED-BATS
CD %var%\BAT-FILES\SCHEDULED-BATS

REM run DAILY CMD
call 0_system_backup_reminder.cmd %var%

CD ..

@echo -----------------------------------
@echo MANUAL RUN OF DAILY BACKUP COMPLETE
@echo -----------------------------------
@echo.
pause
