@echo +++++++++++++++++++++++++++
@echo LAUNCHING SYSTEM-BACKUP.AHK
@echo +++++++++++++++++++++++++++
SET rootFolder=%BKB_ROOT%
)
@echo sitting in this folder now:
cd
@echo changing to:
cd %rootFolder%\SCRIPTS-UTIL
@echo running AHK script to launch the backup app
System-Backup.ahk
