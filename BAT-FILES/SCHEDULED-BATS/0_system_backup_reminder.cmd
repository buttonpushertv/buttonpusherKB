REM @echo off
@echo ==================================
@echo RUNNING SYSTEM BACKUP REMINDER BAT
@echo ==================================

IF NOT EXIST C:\BPTV-KB\PRIVATE\%computername%\days_since_system_backup.txt echo 15>C:\BPTV-KB\PRIVATE\%computername%\days_since_system_backup.txt

for /f "delims=" %%a in (C:\BPTV-KB\PRIVATE\%computername%\days_since_system_backup.txt) do set /a dayssince=%%a

if %dayssince% == 0 goto zerodayskip

set /a checkwindow = 15

if /I %dayssince% GEQ %checkwindow% (call "C:\BPTV-KB\BAT-FILES\launch System-Backup.cmd")

:zerodayskip
set /a backupdays=%dayssince%+1
echo Last backup: %backupdays% days ago
echo %backupdays% > C:\BPTV-KB\PRIVATE\%computername%\days_since_system_backup.txt

@echo ===================================
@echo SYSTEM BACKUP REMINDER BAT COMPLETE
@echo ===================================
@echo.
