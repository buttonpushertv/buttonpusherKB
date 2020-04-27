@echo off
@REM IMPORTANT-This batch file requires an arguement be passed that is the root folder where your install of BPTV-KB is running from. It is probably best if you just leave it as 'C:\BPTV-KB".

@echo The current directory is %CD%
@echo and this is what got passed: %1

@REM This will use initool.exe to read the location of the rootFolder from settings.ini
@FOR /F "tokens=* USEBACKQ" %%F IN (`%1\UTIL-APPS\initool\initool.exe g %1\settings.ini Settings rootFolder --value-only`) DO (
SET rootFolder=%%F
)
@cd %rootFolder%
@echo Now the current directory is %CD%

BPTV-LAUNCHER.ahk
