@echo on
@echo =============================
@echo MANUALLY RUNNING DAILY BACKUP
@echo =============================

@REM This will use initool.exe to read the location of the rootFolder from settings.ini
@FOR /F "tokens=* USEBACKQ" %%F IN (`..\UTIL-APPS\initool\initool.exe g ..\settings.ini Settings rootFolder --value-only`) DO (
SET var=%%F
)

@REM Set working directory to the location of the SCHEDULED-BATS
@CD %var%\BAT-FILES\SCHEDULED-BATS

@echo ++ CALLING 0_daily.cmd ++
call 0_daily.cmd %var%
@echo ++ DONE CALLING 0_daily.cmd ++
@CD ..

@echo -----------------------------------
@echo MANUAL RUN OF DAILY BACKUP COMPLETE
@echo -----------------------------------
pause
