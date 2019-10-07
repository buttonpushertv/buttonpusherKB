@echo off
@echo =================
@echo RUNNING DAILY BAT
@echo =================

@echo location : %1

copy C:\BPTV-KB\settings.ini C:\BPTV-KB\PRIVATE\SETTINGS-BACKUPS
copy C:\BPTV-KB\UTIL-APPS\vnchelper\vnchelper.ini C:\BPTV-KB\PRIVATE\SETTINGS-BACKUPS
copy C:\BPTV-KB\UTIL-APPS\QAP\QuickAccessPopup.ini C:\BPTV-KB\PRIVATE\SETTINGS-BACKUPS
copy "C:\Users\ben\OneDrive\Documents\Adobe\Premiere Pro\13.0\Profile-ben\Win\BEN-CC19.kys" C:\BPTV-KB\PRIVATE\ADOBE-SETTINGS

for /f "delims=" %%a in (C:\BPTV-KB\PRIVATE\backup_destination.txt) do set backupdestroot=%%a
set backupdest=%backupdestroot%PRIVATE-%1
robocopy /mir "C:\BPTV-KB\PRIVATE" "%backupdest%"

@echo ------------------
@echo DAILY BAT COMPLETE
@echo ------------------
@echo.
