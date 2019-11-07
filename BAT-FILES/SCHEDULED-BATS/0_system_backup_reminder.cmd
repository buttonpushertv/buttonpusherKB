REM @echo off
@echo ==================================
@echo RUNNING SYSTEM BACKUP REMINDER BAT
@echo ==================================

IF NOT EXIST %1\PRIVATE\%computername%\days_since_system_backup.txt echo 15>%1\PRIVATE\%computername%\days_since_system_backup.txt

for /f "delims=" %%a in (%1\PRIVATE\%computername%\days_since_system_backup.txt) do set /a dayssince=%%a

if %dayssince% == 0 goto zerodayskip

set /a checkwindow = 15

if /I %dayssince% GEQ %checkwindow% (call "%1\BAT-FILES\launch System-Backup.cmd")
if /I %dayssince% GEQ %checkwindow% (EXIT)

:zerodayskip
set /a backupdays=%dayssince%+1
echo Last backup: %backupdays% days ago
echo %backupdays% > %1\PRIVATE\%computername%\days_since_system_backup.txt

@echo ===================================
@echo SYSTEM BACKUP REMINDER BAT COMPLETE
@echo ===================================
@echo.
