@echo off

REM This will use initool.exe to read the location of the rootFolder from settings.ini
FOR /F "tokens=* USEBACKQ" %%F IN (`..\UTIL-APPS\initool\initool.exe g ..\settings.ini Settings rootFolder --value-only`) DO (
SET rootFolder=%%F
)

@REM this command should redirect output of this batch to a log file
> %rootFolder%\BAT-FILES\LOGS\MANUAL_last_run_log.txt (

@echo =================================
@echo MANUALLY RUNNING SCHEDULED BACKUP
@echo =================================

@echo Rootfolder is: %rootFolder%

@echo Deleting %rootFolder%\PRIVATE\EDIT2-PC\last_daily_run.txt
@echo This should allow the backup to be run even if it had already run today.
del %rootFolder%\PRIVATE\EDIT2-PC\last_daily_run.txt

@echo And this will set the date of the %rootFolder%\PRIVATE\%computername%\days_since_system_backup.txt to yesterday
powershell -command "$(Get-Item %rootFolder%\PRIVATE\%computername%\days_since_system_backup.txt).LastWriteTime=(Get-Date).AddHours(-24)"


@REM Set working directory to the location of the SCHEDULED-BATS
@CD %rootFolder%\BAT-FILES\SCHEDULED-BATS

@echo ++ CALLING scheduled-bats.cmd ++
@call %rootFolder%\BAT-FILES\SCHEDULED-BATS\scheduled-bats.cmd
@echo ++ DONE CALLING scheduled-bats.cmd ++

@cd ..

@echo ---------------------------------------
@echo MANUAL RUN OF SCHEDLUED BACKUP COMPLETE
@echo ---------------------------------------
)
