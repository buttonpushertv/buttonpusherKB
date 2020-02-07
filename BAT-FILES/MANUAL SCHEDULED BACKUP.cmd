@echo off

REM This will use initool.exe to read the location of the rootFolder from settings.ini
FOR /F "tokens=* USEBACKQ" %%F IN (`..\UTIL-APPS\initool\initool.exe g ..\settings.ini Settings rootFolder --value-only`) DO (
SET rootFolder=%%F
)

@REM this command should redirect output of this batch to a log file
> %rootFolder%\BAT-FILES\LOGS\last_run_log.txt (

@echo =================================
@echo MANUALLY RUNNING SCHEDULED BACKUP
@echo =================================

@echo Rootfolder is: %rootFolder%

@echo ++ CALLING scheduled-bats.cmd ++
@call %rootFolder%\BAT-FILES\SCHEDULED-BATS\scheduled-bats.cmd
@echo ++ DONE CALLING scheduled-bats.cmd ++

@echo ---------------------------------------
@echo MANUAL RUN OF SCHEDLUED BACKUP COMPLETE
@echo ---------------------------------------
 )
