@echo on
@REM This BAT file will read a Environment Variable of BKB_ROOT to get the stored value of the root folder for buttonpusherKB's scripts and files
SET rootFolder=%BKB_ROOT%

@echo Rootfolder is: %rootFolder%

@REM The line below is mostly for new or first times running this BAT file. If the commands below this can't find the paths to the files they are looking for it will fail.
@IF NOT EXIST %rootFolder%\PRIVATE\%computername% mkdir %rootFolder%\PRIVATE\%computername%
@IF NOT EXIST %rootFolder%\PRIVATE\%computername%\LOGS\ mkdir %rootFolder%\PRIVATE\%computername%\LOGS

@REM This command will delete the file manual_last_run_log.txt
@IF EXIST %rootFolder%\PRIVATE\%computername%\LOGS\manual_last_run_log.txt del %rootFolder%\PRIVATE\%computername%\LOGS\manual_last_run_log.txt

REM this command should redirect output of this batch to a log file
> %rootFolder%\PRIVATE\%computername%\LOGS\manual_last_run_log.txt (

@echo =================================
@echo MANUALLY RUNNING SCHEDULED BACKUP
@echo =================================

@echo Rootfolder is: %rootFolder%
@REM This command will delete the last_daily_run.txt file so that it should force all the backup actions to occur
@echo Deleting %rootFolder%\PRIVATE\%computername%\last_daily_run.txt
@echo This should allow the backup to be run even if it had already run today.
IF EXIST %rootFolder%\PRIVATE\%computername%\last_daily_run.txt del %rootFolder%\PRIVATE\%computername%\last_daily_run.txt

@REM And this will set the date of the %rootFolder%\PRIVATE\%computername%\days_since_system_backup.txt to yesterday
powershell -command "$(Get-Item %rootFolder%\PRIVATE\%computername%\days_since_system_backup.txt).LastWriteTime=(Get-Date).AddHours(-24)"

REM Set working directory to the location of the SCHEDULED-BATS
CD %rootFolder%\BAT-FILES\SCHEDULED-BATS

@echo ++ CALLING scheduled-bats.cmd ++
call %rootFolder%\BAT-FILES\SCHEDULED-BATS\scheduled-bats.cmd %rootFolder%
@echo ++ DONE CALLING scheduled-bats.cmd ++

cd ..

@echo ---------------------------------------
@echo MANUAL RUN OF SCHEDLUED BACKUP COMPLETE
@echo ---------------------------------------
)
