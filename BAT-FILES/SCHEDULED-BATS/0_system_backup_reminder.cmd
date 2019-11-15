@echo ==================================
@echo RUNNING SYSTEM BACKUP REMINDER BAT
@echo ==================================

REM Check for the existence of days_since_system_backup.txt. If it doesn't exist, then create the file and set it's content's to '15'
IF NOT EXIST %1\PRIVATE\%computername%\days_since_system_backup.txt echo 15>%1\PRIVATE\%computername%\days_since_system_backup.txt

REM The next command sets the variable 'daysSince' to the content of the days_since_system_backup.txt file. This is used further down to compare to 'checkWindow'. It's set to run the System-Backup.cmd script if it has been 15 days or more since the last time a backup was made.
for /f "delims=" %%a in (%1\PRIVATE\%computername%\days_since_system_backup.txt) do set /a daysSince=%%a

REM The line below gets the date the days_since_system_backup.txt file was last modified.
for %%a in (%1\PRIVATE\%computername%\days_since_system_backup.txt) do set fileDate=%%~ta

REM The check below compares that to the current date. If they match, then we can exit this script (so we don't keep incrementing the daysSince counter.)
if /i %fileDate:~0,10% EQU %date:~4,10% exit /b

REM If for some reason 'daysSince' is set to 0 then we are just going to skip to increment that number and exit. I know there was a case where this could have occurred in a previous version of this script but I don't think that can happen any longer with the changes made above.
if %daysSince% == 0 goto zerodayskip

set /a checkWindow = 15

REM This is where we launch a script that will launch the backup program/script. I don't recall why I'm doing the thing where I launch a script that just launches yet another script here. It's working and I don't want to change it but it looks as though you could just run the \SCRIPTS-UTIL\System-Backup.ahk directly here.
if /I %daysSince% GEQ %checkWindow% (call "%1\BAT-FILES\launch System-Backup.cmd")

:zerodayskip
REM This is where the days_since_system_backup.txt gets updated with an incremented number of days. It is only adding to the existing number in the file but it is overwriting the file, so it shouldn't be appending another line with the new number each time - it should just overwrite the whole file.
set /a backupDays=%daysSince%+1
echo Last backup: %backupDays% days ago
echo %backupDays% > %1\PRIVATE\%computername%\days_since_system_backup.txt

@echo ===================================
@echo SYSTEM BACKUP REMINDER BAT COMPLETE
@echo ===================================
@echo.
