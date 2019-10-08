REM @echo off
@echo ===================
@echo RUNNING MONTHLY BAT
@echo ===================
@echo.
REM get some info about the month and day
for /f %%i in ('powershell ^(get-date^).Month') do set mon=%%i
for /f %%i in ('powershell ^(get-date^).Day') do set dom=%%i

@echo Month Number: %mon%
@echo Day Number: %dom%

@echo --------------------
@echo MONTHLY BAT COMPLETE
@echo --------------------
@echo.
