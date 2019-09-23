@echo off
@echo =================
@echo RUNNING DAILY BAT
@echo =================

for /f "delims=" %%a in (C:\BPTV-KB\PERSONAL\days_since_system_backup.txt) do set /a dayssince=%%a

if %dayssince% == 0 goto zerodayskip

set /a checkwindow = 15

set /a backupreminder = %dayssince% %% %checkwindow%

if %backupreminder% == 0 (call "C:\BPTV-KB\BAT-FILES\launch System-Backup.cmd")

:zerodayskip
set /a backupdays=%dayssince%+1
echo Last backup: %backupdays% days ago
echo %backupdays% > C:\BPTV-KB\PERSONAL\days_since_system_backup.txt


for /f "delims=" %%a in (C:\BPTV-KB\PERSONAL\backup_destination.txt) do set backupdest=%%a
robocopy /mir "C:\BPTV-KB\PERSONAL" "%backupdest%"

@echo ------------------
@echo DAILY BAT COMPLETE
@echo ------------------
@echo.