@echo off

@REM The line below is mostly for new or first times running this BAT file. If the commands below this can't find the paths to the files they are looking for it will fail.
@IF NOT EXIST %BKB_ROOT%\PRIVATE\%computername% mkdir %BKB_ROOT%\PRIVATE\%computername%
@IF NOT EXIST %BKB_ROOT%\PRIVATE\%computername%\LOGS\ mkdir %BKB_ROOT%\PRIVATE\%computername%\LOGS

@REM This command will delete the file manual_last_run_log.txt
@IF EXIST %BKB_ROOT%\PRIVATE\%computername%\LOGS\manual_last_run_log.txt del %BKB_ROOT%\PRIVATE\%computername%\LOGS\manual_last_run_log.txt

REM this command should redirect output of this batch to a log file
> %BKB_ROOT%\PRIVATE\%computername%\LOGS\manual_last_run_log.txt (

@echo =================================
@echo MANUALLY RUNNING SCHEDULED BACKUP
@echo =================================

@echo BKB_ROOT is: %BKB_ROOT%
@REM This command will delete the last_daily_run.txt file so that it should force all the backup actions to occur
@echo Deleting %BKB_ROOT%\PRIVATE\%computername%\last_daily_run.txt
@echo This should allow the backup to be run even if it had already run today.
IF EXIST %BKB_ROOT%\PRIVATE\%computername%\last_daily_run.txt del %BKB_ROOT%\PRIVATE\%computername%\last_daily_run.txt

@REM And this will set the date of the %BKB_ROOT%\PRIVATE\%computername%\days_since_system_backup.txt to yesterday
powershell -command "$(Get-Item %BKB_ROOT%\PRIVATE\%computername%\days_since_system_backup.txt).LastWriteTime=(Get-Date).AddHours(-24)"

REM Set working directory to the location of the SCHEDULED-BATS
CD %BKB_ROOT%\BAT-FILES\SCHEDULED-BATS

@echo ++ CALLING scheduled-bats.cmd ++
call %BKB_ROOT%\BAT-FILES\SCHEDULED-BATS\scheduled-bats.cmd %BKB_ROOT%
@echo ++ DONE CALLING scheduled-bats.cmd ++

cd ..

@echo ---------------------------------------
@echo MANUAL RUN OF SCHEDLUED BACKUP COMPLETE
@echo ---------------------------------------
)
