@echo off
@echo =============================
@echo MANUALLY RUNNING DAILY BACKUP
@echo =============================
@echo.
@echo.

for /f "delims=" %%a in (C:\BPTV-KB\PRIVATE\location.txt) do set location=%%a

REM Set working directory to the location of the SCHEDULED-BATS
CD C:\BPTV-KB\BAT-FILES\SCHEDULED-BATS

REM run DAILY CMD
call 0_daily.cmd %location%

@echo -----------------------------------
@echo MANUAL RUN OF DAILY BACKUP COMPLETE
@echo -----------------------------------
@echo.
pause
