@echo on
@echo ==================================
@echo RUNNING SYSTEM BACKUP REMINDER BAT
@echo ==================================

IF NOT EXIST %1\PRIVATE\%computername%\days_since_system_backup.txt echo 15>%1\PRIVATE\%computername%\days_since_system_backup.txt

for /f "delims=" %%a in (%1\PRIVATE\%computername%\days_since_system_backup.txt) do set /a daysSince=%%a
for %%a in (%1\PRIVATE\%computername%\days_since_system_backup.txt) do set fileDate=%%~ta

if /i %fileDate:~0,10% EQU %date:~4,10% exit 0

if %daysSince% == 0 goto zerodayskip

set /a checkWindow = 15

if /I %daysSince% GEQ %checkWindow% (call "%1\BAT-FILES\launch System-Backup.cmd")

:zerodayskip
set /a backupDays=%daysSince%+1
echo Last backup: %backupDays% days ago
echo %backupDays% > %1\PRIVATE\%computername%\days_since_system_backup.txt

@echo ===================================
@echo SYSTEM BACKUP REMINDER BAT COMPLETE
@echo ===================================
@echo.
