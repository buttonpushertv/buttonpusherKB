@echo on
@echo =============================
@echo MANUALLY RUNNING DAILY BACKUP
@echo =============================

SET rootFolder=%BKB_ROOT%

@echo Rootfolder is: %rootFolder%

@REM Remove the %rootfolder%\PRIVATE\%computername%\last_daily_run.txt file so that we can force the backups to run no matter what.
@del %rootfolder%\PRIVATE\%computername%\last_daily_run.txt

@REM Set working directory to the location of the SCHEDULED-BATS
@CD %rootfolder%\BAT-FILES\SCHEDULED-BATS

@echo ++ CALLING 0_daily.cmd ++
call 0_daily.cmd %rootfolder%
@echo ++ DONE CALLING 0_daily.cmd ++
@CD ..

@echo -----------------------------------
@echo MANUAL RUN OF DAILY BACKUP COMPLETE
@echo -----------------------------------
pause
