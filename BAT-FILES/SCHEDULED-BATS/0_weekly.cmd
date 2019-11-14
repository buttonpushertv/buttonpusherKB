@echo ===================
@echo RUNNING WEEKLY BATS
@echo ===================

REM Gets the name of the day of the week
for /f %%i in ('powershell ^(get-date^).DayOfWeek') do set dow=%%i

REM run day-based CMD files if you needed to.
REM if %dow% == Monday (call 1_monday.cmd)
REM if "%dow%"=="Tuesday" (call 2_tuesday.cmd)
REM if "%dow%"=="Wednesday" (call 3_wednesday.cmd)
REM if "%dow%"=="Thursday" (call 4_thursday.cmd)
REM if "%dow%"=="Friday" (call 5_friday.cmd)
REM if "%dow%"=="Saturday" (call 6_saturday.cmd)
REM if "%dow%"=="Sunday" (call 7_sunday.cmd)

@echo -------------------
@echo WEEKLY BAT COMPLETE
@echo -------------------
@echo.
