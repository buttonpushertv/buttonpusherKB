@echo off
@echo ===================
@echo RUNNING MONTHLY BAT
@echo ===================
@echo.

REM get some info about the month and day

for /F "skip=1 delims=" %%F in ('
    wmic PATH Win32_LocalTime GET Day^,Month^,Year /FORMAT:TABLE
') do (
    for /F "tokens=1-3" %%L in ("%%F") do (
        set CurrDay=0%%L
        set CurrMonth=0%%M
        set CurrYear=%%N
    )
)
set CurrDay=%CurrDay:~-2%
set CurrMonth=%CurrMonth:~-2%
echo Current day  :  %CurrDay%
echo Current month:  %CurrMonth%
echo Current year :%CurrYear%

REM other methods using a powershell script
REM for /f %%i in ('powershell ^(get-date^).Month') do set mon=%%i
REM for /f %%i in ('powershell ^(get-date^).Day') do set dom=%%i

REM @echo Month Number: %mon%
REM @echo Day Number: %dom%

REM this calls the 'bat/cmd' file that has the same name as the number of the month.
@call "%BKB_ROOT%\PRIVATE\%computername%\BATs\monthly\%CurrMonth%.cmd"

@echo --------------------
@echo MONTHLY BAT COMPLETE
@echo --------------------
@echo.
