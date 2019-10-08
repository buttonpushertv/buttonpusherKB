@echo off
@echo =================
@echo RUNNING DAILY BAT
@echo =================

copy C:\BPTV-KB\settings.ini C:\BPTV-KB\PRIVATE\%computername%\SETTINGS-BACKUPS\
copy C:\BPTV-KB\UTIL-APPS\vnchelper\vnchelper.ini C:\BPTV-KB\PRIVATE\%computername%\SETTINGS-BACKUPS\
copy C:\BPTV-KB\UTIL-APPS\QAP\QuickAccessPopup.ini C:\BPTV-KB\PRIVATE\%computername%\SETTINGS-BACKUPS\
call C:\BPTV-KB\PRIVATE\%computername%-BACKUPS.cmd

@echo ------------------
@echo DAILY BAT COMPLETE
@echo ------------------
@echo.
