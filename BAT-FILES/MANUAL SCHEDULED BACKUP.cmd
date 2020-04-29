@echo on
@REM IMPORTANT-This batch file requires an arguement be passed that is the root folder where your install of BPTV-KB is running from. It is probably best if you just leave it as 'C:\BPTV-KB".


@echo The current directory is %CD%
@echo and this is what got passed: %1

SET rootFolder=%1

@echo Rootfolder is: %rootFolder%

IF EXIST %rootFolder%\PRIVATE\%computername%\LOGS\manual_last_run_log.txt del %rootFolder%\PRIVATE\%computername%\LOGS\manual_last_run_log.txt

REM this command should redirect output of this batch to a log file
> %rootFolder%\PRIVATE\%computername%\LOGS\manual_last_run_log.txt (

@echo =================================
@echo MANUALLY RUNNING SCHEDULED BACKUP
@echo =================================

@echo Rootfolder is: %rootFolder%

@echo Deleting %rootFolder%\PRIVATE\%computername%\last_daily_run.txt
@echo This should allow the backup to be run even if it had already run today.
IF EXIST %rootFolder%\PRIVATE\%computername%\last_daily_run.txt del %rootFolder%\PRIVATE\%computername%\last_daily_run.txt

@echo And this will set the date of the %rootFolder%\PRIVATE\%computername%\days_since_system_backup.txt to yesterday
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
