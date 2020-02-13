@echo +++++++++++++++++++++++++++
@echo LAUNCHING SYSTEM-BACKUP.AHK
@echo +++++++++++++++++++++++++++
REM This will use initool.exe to read the location of the rootFolder from settings.ini
@FOR /F "tokens=* USEBACKQ" %%F IN (`..\..\UTIL-APPS\initool\initool.exe g ..\..\settings.ini Settings rootFolder --value-only`) DO (
SET rootFolder=%%F
)
@echo sitting in this folder now:
cd
@echo changing to:
cd %rootFolder%\SCRIPTS-UTIL
@echo running AHK script to launch the backup app
System-Backup.ahk
