@echo off
@echo =============================
@echo MANUALLY RUNNING DAILY BACKUP
@echo =============================
@echo.
@echo.

SET rootFolder=%BKB_ROOT%
)

REM Set working directory to the location of the SCHEDULED-BATS
CD %rootFolder%\BAT-FILES\SCHEDULED-BATS

REM run DAILY CMD
call 0_system_backup_reminder.cmd %rootFolder%

CD ..

@echo -----------------------------------
@echo MANUAL RUN OF DAILY BACKUP COMPLETE
@echo -----------------------------------
@echo.
pause
