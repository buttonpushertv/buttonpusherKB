@echo off
@echo =============================
@echo MANUALLY RUNNING DAILY BACKUP
@echo =============================

@REM Remove the %BKB_ROOT%\PRIVATE\%computername%\last_daily_run.txt file so that we can force the backups to run no matter what.
@del %BKB_ROOT%\PRIVATE\%computername%\last_daily_run.txt

@REM Set working directory to the location of the SCHEDULED-BATS
@CD %BKB_ROOT%\BAT-FILES\SCHEDULED-BATS

@echo ++ CALLING 0_daily.cmd ++
call 0_daily.cmd
@echo ++ DONE CALLING 0_daily.cmd ++
@CD ..

@echo -----------------------------------
@echo MANUAL RUN OF DAILY BACKUP COMPLETE
@echo -----------------------------------
pause
