@echo off
@echo ==================================
@echo RUNNING SYSTEM BACKUP REMINDER BAT
@echo ==================================

@echo location : %1

for /f "delims=" %%a in (C:\BPTV-KB\PRIVATE\days_since_system_backup.txt) do set /a dayssince=%%a

if %dayssince% == 0 goto zerodayskip

set /a checkwindow = 15

set /a backupreminder = %dayssince% %% %checkwindow%

if %backupreminder% == 0 (call "C:\BPTV-KB\BAT-FILES\launch System-Backup.cmd")

:zerodayskip
set /a backupdays=%dayssince%+1
echo Last backup: %backupdays% days ago
echo %backupdays% > C:\BPTV-KB\PRIVATE\days_since_system_backup.txt

@echo ===================================
@echo SYSTEM BACKUP REMINDER BAT COMPLETE
@echo ===================================
@echo.
