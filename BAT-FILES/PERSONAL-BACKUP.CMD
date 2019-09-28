for /f "delims=" %%a in (C:\BPTV-KB\PERSONAL\location.txt) do set location=%%a

for /f "delims=" %%a in (C:\BPTV-KB\PERSONAL\backup_destination.txt) do set backupdestroot=%%a
set backupdest=%backupdestroot%PERSONAL-%location%
robocopy /mir "C:\BPTV-KB\PERSONAL" "%backupdest%"
