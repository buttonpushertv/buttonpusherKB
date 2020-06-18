@echo off
@REM IMPORTANT-This batch file requires an arguement be passed that is the root folder where your install of BKB is running from. It is probably best if you just leave it as 'C:\BKB".

@echo The current directory is %CD%
@echo and this is what got passed: %1

SET rootFolder=%BKB_ROOT%
)
@cd %rootFolder%
@echo Now the current directory is %CD%

BKB-LAUNCHER.ahk
