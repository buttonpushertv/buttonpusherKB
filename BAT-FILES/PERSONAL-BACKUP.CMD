for /f "delims=" %%a in (C:\BPTV-KB\PRIVATE\location.txt) do set location=%%a

for /f "delims=" %%a in (C:\BPTV-KB\PRIVATE\backup_destination.txt) do set backupdestroot=%%a
set backupdest=%backupdestroot%PRIVATE-%location%
robocopy /mir "C:\BPTV-KB\PRIVATE" "%backupdest%"
TIMEOUT /T 5
