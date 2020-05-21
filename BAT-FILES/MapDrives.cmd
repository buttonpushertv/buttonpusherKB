PowerShell -Command "Remove-Item %TEMP%\StartupLog.txt"
PowerShell -Command "Set-ExecutionPolicy -Scope CurrentUser Unrestricted" >> "%TEMP%\StartupLog.txt" 2>&1 
PowerShell -File "%SystemDrive%\BKB\BAT-FILES\MapDrives.ps1" >> "%TEMP%\StartupLog.txt" 2>&1