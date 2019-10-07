copy C:\BPTV-KB\settings.ini C:\BPTV-KB\PRIVATE\SETTINGS-BACKUPS
copy C:\BPTV-KB\UTIL-APPS\vnchelper\vnchelper.ini C:\BPTV-KB\PRIVATE\SETTINGS-BACKUPS
copy C:\BPTV-KB\UTIL-APPS\QAP\QuickAccessPopup.ini C:\BPTV-KB\PRIVATE\SETTINGS-BACKUPS

for /f "delims=" %%a in (C:\BPTV-KB\PRIVATE\location.txt) do set location=%%a

for /f "delims=" %%a in (C:\BPTV-KB\PRIVATE\backup_destination.txt) do set backupdestroot=%%a
set backupdest=%backupdestroot%PRIVATE-%location%
robocopy /mir "C:\BPTV-KB\PRIVATE" "%backupdest%"
TIMEOUT /T 5
