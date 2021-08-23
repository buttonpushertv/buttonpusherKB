@echo off
setlocal enabledelayedexpansion

set arg1=%1
set "arg1=%arg1:\=/%"

FOR /F "TOKENS=1,2 DELIMS=:" %%G IN (%arg1%) DO (
set "drive=%%G"
set "upath=%%H"
)
if %drive%==C (
set "upath=/mnt/c%upath%"
)
wsl.exe -- bash -c "cd %upath% && bash"