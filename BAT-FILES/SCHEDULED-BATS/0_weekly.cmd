@echo ===================
@echo RUNNING WEEKLY BATS
@echo ===================

REM Gets the name of the day of the week
for /f %%i in ('powershell ^(get-date^).DayOfWeek') do set dow=%%i

REM run day-based CMD files if you needed to.
if %dow%==Monday (call "%BKB_ROOT%\PRIVATE\%computername%\BATs\1_monday.cmd")
if %dow%==Tuesday (call "%BKB_ROOT%\PRIVATE\%computername%\BATs\2_tuesday.cmd")
if %dow%==Wednesday (call "%BKB_ROOT%\PRIVATE\%computername%\BATs\3_wednesday.cmd")
if %dow%==Thursday (call "%BKB_ROOT%\PRIVATE\%computername%\BATs\4_thursday.cmd")
if %dow%==Friday (call "%BKB_ROOT%\PRIVATE\%computername%\BATs\5_friday.cmd")
if %dow%==Saturday (call "%BKB_ROOT%\PRIVATE\%computername%\BATs\6_saturday.cmd")
if %dow%==Sunday (call "%BKB_ROOT%\PRIVATE\%computername%\BATs\7_sunday.cmd")

@echo -------------------
@echo WEEKLY BAT COMPLETE
@echo -------------------
@echo.
