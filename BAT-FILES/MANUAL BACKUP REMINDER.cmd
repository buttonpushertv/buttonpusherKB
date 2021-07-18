@echo off
@echo =============================
@echo MANUALLY RUNNING DAILY BACKUP
@echo =============================
@echo.
@echo.

REM Set working directory to the location of the SCHEDULED-BATS
CD %BKB_ROOT%\BAT-FILES\SCHEDULED-BATS

REM run DAILY CMD
call 0_system_backup_reminder.cmd
CD ..

@echo -----------------------------------
@echo MANUAL RUN OF DAILY BACKUP COMPLETE
@echo -----------------------------------
@echo.
pause
