@echo off
@FOR /F "tokens=* USEBACKQ" %%F IN (`%BKB_ROOT%\PRIVATE\APPS\initool\initool.exe g %BKB_ROOT%\settings.ini Settings systemPathToDropbox --value-only`) DO (
SET var=%%F
)
@ECHO %var%
